CREATE DATABASE railway_reservation1;
USE railway_reservation1;

-- Create trains table
CREATE TABLE trains (
    train_id INT AUTO_INCREMENT PRIMARY KEY,
    train_name VARCHAR(100) NOT NULL,
    source_station VARCHAR(100) NOT NULL,
    destination_station VARCHAR(100) NOT NULL,
    departure_time TIME NOT NULL,
    arrival_time TIME NOT NULL,
    seats_available INT NOT NULL,
    fare DECIMAL(10,2) NOT NULL
);

-- Create users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL
);

-- Create bookings table
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    train_id INT NOT NULL,
    journey_date DATE NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    passengers INT NOT NULL,
    total_fare DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Confirmed',
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (train_id) REFERENCES trains(train_id)
);

-- Insert sample train data
INSERT INTO trains (train_name, source_station, destination_station, departure_time, arrival_time, seats_available, fare)
VALUES 
('Mumbai Express', 'Delhi', 'Mumbai', '17:30:00', '08:30:00', 120, 1500.00),
('Shatabdi Express', 'Bangalore', 'Chennai', '06:00:00', '11:00:00', 80, 800.00),
('Duronto Express', 'Kolkata', 'Delhi', '22:15:00', '10:30:00', 150, 1200.00);
select * from trains;
describe trains;
select * from users;
select * from bookings;
INSERT INTO trains (train_name, source_station, destination_station, departure_time, arrival_time, seats_available, fare)
VALUES 
('Rajdhani Express', 'Delhi', 'Mumbai', '16:30:00', '07:15:00', 100, 1800.00),
('Chennai Mail', 'Kolkata', 'Chennai', '20:45:00', '06:20:00', 90, 1100.00),
('Garib Rath', 'Patna', 'New Delhi', '23:10:00', '07:45:00', 200, 750.00),
('Sampark Kranti', 'Trivandrum', 'Delhi', '11:20:00', '20:35:00', 110, 1350.00),
('Deccan Queen', 'Mumbai', 'Pune', '07:15:00', '10:30:00', 75, 500.00),
('Goa Express', 'Delhi', 'Goa', '12:40:00', '10:15:00', 85, 1600.00),
('Golden Temple Mail', 'Mumbai', 'Amritsar', '21:50:00', '08:10:00', 95, 1900.00),
('Humsafar Express', 'Bangalore', 'Hyderabad', '18:30:00', '04:15:00', 120, 950.00),
('Vande Bharat', 'Delhi', 'Varanasi', '06:00:00', '14:00:00', 50, 2200.00),
('Tejas Express', 'Mumbai', 'Ahmedabad', '15:20:00', '21:45:00', 60, 1250.00),
('Shatabdi Express', 'Delhi', 'Bhopal', '08:00:00', '13:25:00', 70, 900.00),
('Jan Shatabdi', 'Chennai', 'Bangalore', '14:30:00', '20:15:00', 130, 650.00),
('Udyan Express', 'Bangalore', 'Mumbai', '19:00:00', '09:30:00', 140, 1400.00),
('Karnataka Express', 'Delhi', 'Bangalore', '22:30:00', '12:45:00', 110, 1750.00),
('Gujarat Mail', 'Mumbai', 'Ahmedabad', '23:45:00', '06:30:00', 100, 850.00);
INSERT INTO trains (train_name, source_station, destination_station, departure_time, arrival_time, seats_available, fare)
VALUES
('Pune Shatabdi', 'Mumbai', 'Pune', '06:00:00', '09:15:00', 60, 700.00),             -- Fastest option
('Indrayani Express', 'Mumbai', 'Pune', '17:30:00', '20:50:00', 120, 450.00),         -- Budget-friendly
('Mumbai-Pune Intercity', 'Mumbai', 'Pune', '12:15:00', '15:30:00', 100, 550.00);     -- Mid-range
INSERT INTO trains (train_name, source_station, destination_station, departure_time, arrival_time, seats_available, fare)
VALUES
('Poorva Express', 'Kolkata', 'Delhi', '12:50:00', '05:30:00', 120, 1400.00),         -- Day-night journey
('Kolkata Rajdhani', 'Kolkata', 'Delhi', '16:55:00', '09:30:00', 90, 2500.00),        -- Luxury option
('Sealdah Express', 'Kolkata', 'Delhi', '21:30:00', '18:00:00', 180, 1100.00);        -- Budget, slower
INSERT INTO trains (train_name, source_station, destination_station, departure_time, arrival_time, seats_available, fare)
VALUES
('Brindavan Express', 'Bangalore', 'Chennai', '08:30:00', '13:15:00', 100, 550.00),   -- Mid-range, daytime
('Lalbagh Express', 'Bangalore', 'Chennai', '15:00:00', '20:10:00', 80, 600.00),      -- Slightly higher fare
('Bangalore-Chennai AC Special', 'Bangalore', 'Chennai', '06:00:00', '10:45:00', 50, 1200.00);  -- Premium AC service
INSERT INTO trains (train_name, source_station, destination_station, departure_time, arrival_time, seats_available, fare)
VALUES
('August Kranti Rajdhani', 'Delhi', 'Mumbai', '17:00:00', '07:30:00', 110, 2200.00),  -- Premium fare, faster
('Mumbai Superfast', 'Delhi', 'Mumbai', '23:45:00', '15:30:00', 150, 1300.00),        -- Budget option, longer duration
('Gujarat Express', 'Delhi', 'Mumbai', '05:30:00', '19:45:00', 200, 950.00); 
select * from bookings;
         -- Lowest fare, more stops
