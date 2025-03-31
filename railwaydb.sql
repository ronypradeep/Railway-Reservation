CREATE DATABASE railway_reservation;
USE railway_reservation;

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
('Rajdhani Express', 'Delhi', 'Mumbai', '17:30:00', '08:30:00', 120, 1500.00),
('Shatabdi Express', 'Bangalore', 'Chennai', '06:00:00', '11:00:00', 80, 800.00),
('Duronto Express', 'Kolkata', 'Delhi', '22:15:00', '10:30:00', 150, 1200.00);
select * from trains;
describe trains
select * from users;
select * from bookings;
INSERT INTO trains (
    train_name, 
    source_station, 
    destination_station, 
    departure_time, 
    arrival_time, 
    duration, 
    distance, 
    train_type, 
    classes, 
    running_days, 
    seats_available, 
    fare
) VALUES
-- Rajdhani Express (Delhi to Mumbai)
('Rajdhani Express', 'Delhi', 'Mumbai', '17:30:00', '08:30:00', 15, 1384, 'Superfast', 'AC First,AC Second,AC Third', 'Daily', 120, 1500.00),

-- Shatabdi Express (Bangalore to Chennai)
('Shatabdi Express', 'Bangalore', 'Chennai', '06:00:00', '11:00:00', 5, 360, 'Superfast', 'AC Chair Car,Executive', 'Daily', 80, 800.00),

-- Duronto Express (Kolkata to Delhi)
('Duronto Express', 'Kolkata', 'Delhi', '22:15:00', '10:30:00', 12, 1449, 'Superfast', 'AC First,AC Second,AC Third', 'Daily', 150, 1200.00),

-- Garib Rath (Mumbai to Goa)
('Garib Rath', 'Mumbai', 'Goa', '23:15:00', '07:30:00', 8, 581, 'Express', 'AC Third', 'Daily', 200, 600.00),

-- Tejas Express (Delhi to Lucknow)
('Tejas Express', 'Delhi', 'Lucknow', '06:15:00', '12:30:00', 6, 512, 'Superfast', 'AC Chair Car,Executive', 'Daily', 90, 900.00),

-- Vande Bharat (Chennai to Bangalore)
('Vande Bharat', 'Chennai', 'Bangalore', '14:30:00', '20:15:00', 5.75, 360, 'Superfast', 'AC Chair Car', 'Daily', 100, 950.00),

-- Jan Shatabdi (Delhi to Chandigarh)
('Jan Shatabdi', 'Delhi', 'Chandigarh', '15:30:00', '18:45:00', 3.25, 245, 'Express', 'AC Chair Car,Sleeper', 'Daily', 180, 450.00),

-- Humsafar Express (Jaipur to Mumbai)
('Humsafar Express', 'Jaipur', 'Mumbai', '20:00:00', '10:30:00', 14.5, 1142, 'Express', 'AC Three Tier', 'Tue,Thu,Sat', 160, 1100.00),

-- Sampark Kranti (Delhi to Bhopal)
('Sampark Kranti', 'Delhi', 'Bhopal', '16:45:00', '04:30:00', 11.75, 702, 'Superfast', 'AC Two Tier,AC Three Tier,Sleeper', 'Daily', 140, 850.00),

-- Gatimaan Express (Delhi to Agra)
('Gatimaan Express', 'Delhi', 'Agra', '08:10:00', '09:50:00', 1.67, 188, 'Superfast', 'AC Chair Car,Executive', 'Daily', 75, 750.00);

