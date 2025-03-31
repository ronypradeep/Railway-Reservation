from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re
from datetime import datetime, timedelta
from werkzeug.security import generate_password_hash, check_password_hash
from config import Config

app = Flask(__name__)
app.secret_key = Config.SECRET_KEY

# Configure MySQL settings FIRST
app.config['MYSQL_HOST'] = Config.MYSQL_HOST
app.config['MYSQL_USER'] = Config.MYSQL_USER
app.config['MYSQL_PASSWORD'] = Config.MYSQL_PASSWORD
app.config['MYSQL_DB'] = Config.MYSQL_DB

# Initialize MySQL AFTER configuration
mysql = MySQL(app)

# Context processor to inject current datetime into templates
@app.context_processor
def inject_now():
    return {'now': datetime.now()}

def format_timedelta(td: timedelta) -> str:
    """Convert timedelta to HH:MM format"""
    total_seconds = td.total_seconds()
    hours = int(total_seconds // 3600)
    minutes = int((total_seconds % 3600) // 60)
    return f"{hours:02}:{minutes:02}"

# --------------------------
# Routes
# --------------------------

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = generate_password_hash(request.form['password'])
        email = request.form['email']
        full_name = request.form['full_name']

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM users WHERE username = %s', (username,))
        
        if cursor.fetchone():
            flash('Username already exists!', 'error')
        else:
            cursor.execute('''
                INSERT INTO users (username, password, email, full_name)
                VALUES (%s, %s, %s, %s)
            ''', (username, password, email, full_name))
            mysql.connection.commit()
            flash('Registration successful! Please login', 'success')
            return redirect(url_for('login'))
    
    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM users WHERE username = %s', (username,))
        account = cursor.fetchone()

        if account and check_password_hash(account['password'], password):
            session['loggedin'] = True
            session['user_id'] = account['user_id']
            session['username'] = account['username']
            return redirect(url_for('index'))
        
        flash('Invalid username/password!', 'error')
    
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('index'))

@app.route('/search', methods=['GET', 'POST'])
def search():
    if request.method == 'POST':
        source = request.form['source']
        destination = request.form['destination']
        date = request.form['date']

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('''
            SELECT * FROM trains 
            WHERE source_station = %s 
            AND destination_station = %s 
            AND seats_available > 0
        ''', (source, destination))
        
        trains = [
            {**train, 
             'departure_time': format_timedelta(train['departure_time']),
             'arrival_time': format_timedelta(train['arrival_time'])}
            for train in cursor.fetchall()
        ]
        
        return render_template('search.html', trains=trains, date=date)
    
    return render_template('search.html')

@app.route('/booking/<int:train_id>/<date>', methods=['GET', 'POST'])
def booking(train_id, date):
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM trains WHERE train_id = %s', (train_id,))
    train = cursor.fetchone()
    
    if not train:
        flash('Train not found!', 'error')
        return redirect(url_for('search'))

    # Format train times
    formatted_train = {
        **train,
        'departure_time': format_timedelta(train['departure_time']),
        'arrival_time': format_timedelta(train['arrival_time'])
    }

    if request.method == 'POST':
        try:
            passengers = int(request.form['passengers'])
            if passengers <= 0:
                raise ValueError
        except ValueError:
            flash('Invalid number of passengers!', 'error')
            return redirect(url_for('booking', train_id=train_id, date=date))

        if passengers > formatted_train['seats_available']:
            flash('Not enough seats available!', 'error')
            return redirect(url_for('booking', train_id=train_id, date=date))

        total_fare = passengers * formatted_train['fare']
        
        try:
            cursor.execute('''
                INSERT INTO bookings 
                (user_id, train_id, journey_date, passengers, total_fare)
                VALUES (%s, %s, %s, %s, %s)
            ''', (session['user_id'], train_id, date, passengers, total_fare))
            
            cursor.execute('''
                UPDATE trains 
                SET seats_available = seats_available - %s 
                WHERE train_id = %s
            ''', (passengers, train_id))
            
            mysql.connection.commit()
            flash('Booking successful!', 'success')
            return redirect(url_for('mybookings'))
        
        except Exception as e:
            mysql.connection.rollback()
            flash('Booking failed! Please try again.', 'error')
    
    return render_template('booking.html', train=formatted_train, date=date)

@app.route('/mybookings')
def mybookings():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('''
        SELECT b.*, t.train_name, t.source_station, 
               t.destination_station, t.departure_time, t.arrival_time
        FROM bookings b
        JOIN trains t ON b.train_id = t.train_id
        WHERE b.user_id = %s
        ORDER BY b.journey_date DESC
    ''', (session['user_id'],))
    
    bookings = [
        {**booking, 
         'departure_time': format_timedelta(booking['departure_time']),
         'arrival_time': format_timedelta(booking['arrival_time'])}
        for booking in cursor.fetchall()
    ]
    
    return render_template('mybookings.html', bookings=bookings)

if __name__ == '__main__':
    app.run(debug=True)