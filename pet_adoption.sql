create database pet_adoption_system;
use pet_adoption_system;
-- drop database pet_adoption_system;
show tables;
show databases;

-- Users table
create table Users(
	user_id smallint UNSIGNED PRIMARY KEY auto_increment,
    username VARCHAR(50) UNIQUE NOT NULL, 
    fullname varchar(100) Not null,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
	phone VARCHAR(15),
    address TEXT,
    city VARCHAR(50),
    pincode VARCHAR(6),
    role ENUM('Admin', 'Adopter') NOT NULL DEFAULT 'Adopter',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX (username),
    INDEX (email),
    INDEX (city),
    INDEX (role)
);
select * from users;
insert into users(fullname, username, email, password,address,role) values('admin','admin_1223', 'admin1223@gmail.com', 'aece1accf9f8d41e780185450770cfa43a43ed8d07b16f8c34b4209fee7c1a7a','aabbbccdd','Admin');
insert into Users(fullname, username, email, password,address,role) values('Riya Sanjay Mahale', 'ruchitamahale18', 'ruchitamahale180904@gmail.com',  'b7fe75f14eb09c06e7ce44e6fab1eaa74a956bed58e0215cfe729332bff345fc','dfsdfds','Admin');
-- Pets Table
CREATE TABLE Pets (
    pet_id smallint unsigned primary KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    species ENUM('Dog', 'Cat') NOT NULL,
    breed VARCHAR(50),
    age tinyint unsigned CHECK (age >= 0), 
    gender ENUM('Male', 'Female') NOT NULL,
    -- size ENUM('Small', 'Medium', 'Large'),
    weight decimal(5,2) not null,
    height decimal(5,2) not null,
    description TEXT,
    status ENUM('Available', 'Adopted','Deceased','Fostered') DEFAULT 'Available',
    image VARCHAR(255),
    color VARCHAR(50),
    neutered_or_spayed ENUM('Yes', 'No') DEFAULT 'No', 
    vaccinated ENUM('Yes', 'No', 'Partially') DEFAULT 'No', 
    good_with_pets ENUM('Yes', 'No', 'Unknown') DEFAULT 'Unknown',
    good_with_kids ENUM('Yes', 'No', 'Unknown') DEFAULT 'Unknown',
    good_with_strangers ENUM('Yes', 'No', 'Unknown') DEFAULT 'Unknown',
    behavioral_traits TEXT, 
    health_status TEXT,
    medication TEXT,
    preferable_food TEXT,
    special_needs text,
    daily_routine TEXT,
    trained_for TEXT,
    dietary_restrictions TEXT,
    owner_name varchar(80),
    contact_no varchar(15),
    address varchar(200) NOT NULL,
	area varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
    pincode varchar(6) NOT NULL,
    story text,
    reason_for_rehoming TEXT,
    INDEX (species),
    INDEX (breed),
    INDEX (gender),
    INDEX (status),
    INDEX (city),
    INDEX (area)
);

INSERT INTO Pets (
    name, species, breed, age, gender, weight, height, description, status, image,
    color, neutered_or_spayed, vaccinated, good_with_pets, good_with_kids, good_with_strangers,
    behavioral_traits, health_status, preferable_food, medication, special_needs,
    daily_routine, trained_for, dietary_restrictions, owner_name, contact_no,
    address, area, city, pincode, story
)
VALUES 
('Bella', 'Dog', 'Labrador Retriever', 3, 'Female', 25.00, 60.00, 'Friendly and energetic', 'Available', '1-bella.jpg',
 'Golden', 'Yes', 'Yes', 'Yes', 'Yes', 'Yes', 'Playful, Loyal', 'Healthy', 'Dry food, Chicken treats', '', '', 'Morning and evening walks', 'Sit, Stay', '', 'Ramesh Patel', '+91-9876543210',
 '101, Gokul Residency, Near Manekbaug Hall', 'Ambawadi', 'Ahmedabad', '380006',
 "I'm Bella, a joyful Labrador who loves to play fetch and go on long walks. I used to live with a lovely family, but they had to move away and couldn’t take me along. I’m looking for a new family who’ll shower me with cuddles and treats!"),

('Max', 'Dog', 'German Shepherd', 5, 'Male', 30.00, 65.00, 'Protective and well-trained', 'Available', '2-max.jpg',
 'Black & Tan', 'Yes', 'Partially', 'Yes', 'No', 'Yes', 'Alert, Intelligent', 'Arthritis in one leg', 'High-protein kibble', 'Pain relief meds', 'Soft bedding', 'Morning walks', 'Guard commands', 'Avoid wheat', 'Sneha Mehta', '+91-9823456781',
 'B-42, Sunshine Apartment, Opp. Iscon Temple', 'SG Highway', 'Ahmedabad', '380015',
 "I’m Max, a loyal German Shepherd. I was trained by a retired army officer and I’m always on alert. After he passed away, I’ve been longing for someone who appreciates my intelligence and strong protective instincts."),

('Whiskers', 'Cat', 'Persian', 2, 'Female', 5.00, 25.00, 'Gentle and quiet', 'Fostered', '3-whiskers.jpg',
 'White', 'No', 'No', 'Unknown', 'Yes', 'Unknown', 'Calm, Affectionate', 'Healthy', 'Soft canned food', '', '', 'Afternoon naps', 'Litter trained', 'Avoid dairy', 'Nikita Shah', '+91-9898989898',
 '3rd Floor, Rajvi Plaza, Bopal Cross Road', 'Bopal', 'Ahmedabad','380058',
 "Hi, I’m Whiskers. I was rescued from a busy marketplace where I used to hide behind food stalls. Now, I love my cozy foster home, but I dream of finding a forever home where I can nap in peace and be loved."),

('Buddy', 'Dog', 'Labrador Retriever', 3, 'Male', 30.00, 60.00, 'Friendly and playful, loves kids and running.', 'Available', '4-buddy.jpg',
 'Golden', 'Yes', 'Yes', 'Yes', 'Yes', 'Yes', 'Energetic, Loyal', 'Healthy', 'Dry food, Peanut butter biscuits', '', '', 'Plays in garden, evening walk', 'Fetch', '', 'Amit Sharma', '+91-9812345678',
 '7, Tulsi Bungalows, Nr. Shivranjani Cross Roads', 'Satellite', 'Ahmedabad', '380015',
 "They call me Buddy because I really am everyone’s best buddy! I love running around with kids and I’m always the life of the garden. I was left behind when my owners moved, but I still have so much love to give."),

('Luna', 'Cat', 'Persian', 2, 'Female', 4.50, 25.00, 'Quiet and cuddly cat, perfect for indoors.', 'Available', '5-luna5.jpg',
 'Cream', 'Yes', 'Partially', 'Yes', 'Yes', 'No', 'Calm, Gentle', 'Allergic to certain foods', 'Canned tuna, Chicken bits', '', '', 'Sleeps on window sill', 'Litter trained', 'Avoid cold', 'Rina Desai','+91-9966554433',
 '302, Milan Apartments, Near Vijay Cross Road', 'Navrangpura', 'Ahmedabad', '380009',
 "I’m Luna, a sweet Persian with a soft heart. My previous owner developed allergies and had to give me up. I may be quiet, but my gentle purrs and cuddles speak volumes. I just want to be someone’s calm companion."),

('Charlie', 'Dog', 'Beagle', 4, 'Male', 11.20, 35.00, 'Loves walks and howls when happy.', 'Fostered', '6-charlie.jpg',
 'Brown and White', 'Yes', 'Yes', 'No', 'Yes', 'Yes', 'Curious, Active', 'Recovered from tick fever', 'Dry food, Carrot sticks', '', '', 'Morning walks, Evening playtime', 'Basic obedience', 'Avoid red meat', 'Jatin Bhatt','+91-9833123456',
 'D-22, Goyal Terrace, Nr. Vastrapur Lake', 'Vastrapur', 'Ahmedabad','380015',
 "Charlie’s the name, and howling when I’m happy is my game! I used to wander streets before I found my way to a kind rescuer. I adore company, belly rubs, and long sniffy walks.");

select * from Pets;

-- Adopters Table
CREATE TABLE Adopters (
    adopter_id smallint unsigned PRIMARY KEY,
    -- username VARCHAR(50) UNIQUE NOT NULL,
    -- email VARCHAR(100) UNIQUE NOT NULL,
    -- password VARCHAR(255) NOT NULL,
	-- phone VARCHAR(15),
	-- address TEXT,
    has_pets ENUM('Yes', 'No'),
    no_of_pets tinyint unsigned,
    no_of_family_members tinyint unsigned,
    has_any_allergy enum('Yes', 'No'),
    allergy_details TEXT,
	foreign key(adopter_id) references Users(user_id) on delete cascade,
    CHECK (
        (has_any_allergy = 'No' AND allergy_details IS NULL) OR 
        (has_any_allergy = 'Yes' AND allergy_details IS NOT NULL)
    ),
    CHECK (
        (has_pets = 'No' AND no_of_pets IS NULL) OR 
        (has_pets = 'Yes' AND no_of_pets IS NOT NULL)
    )
);
select * from Adopters;

-- Adoption Requests Table
CREATE TABLE AdoptionRequests (
    request_id smallint unsigned PRIMARY KEY AUTO_INCREMENT,
    adopter_id smallint unsigned,
    pet_id smallint unsigned,
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- message text,
    reason_for_adoption TEXT NOT NULL,
    status ENUM('Pending', 'Accepted', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (adopter_id) REFERENCES Adopters(adopter_id) ON DELETE CASCADE,
    FOREIGN KEY (pet_id) REFERENCES Pets(pet_id) ON DELETE CASCADE,
    INDEX (adopter_id),
    INDEX (pet_id),
    INDEX (status)
);
select * from AdoptionRequests;

-- Feedback Table
CREATE TABLE Feedback (
    feedback_id smallint unsigned primary key auto_increment,
    user_id smallint unsigned not null,
    feedback_type ENUM('testimonial', 'general') DEFAULT 'general',
    feedback_text TEXT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5) DEFAULT NULL,
    feedback_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    INDEX (user_id),
    INDEX (feedback_type)
);
select * from Feedback;

-- Donations Table
CREATE TABLE Donations (
    donation_id smallint unsigned PRIMARY KEY AUTO_INCREMENT,
    user_id smallint unsigned,
    -- foster_id smallint unsigned,
    amount DECIMAL(10,2) NOT NULL,
    donation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL,
    INDEX (user_id),
    INDEX (donation_date)
    -- FOREIGN KEY (foster_id) REFERENCES FosterCare(foster_id) ON DELETE SET NULL
);
select * from Donations;

-- Appointment Scheduling Table
create table Appointments(
	appointment_id smallint unsigned primary key auto_increment,
    adopter_id smallint unsigned not null,
    pet_id smallint unsigned not null,
    appointment_date date not null,
    appointment_time time not null,
    meeting_number TINYINT UNSIGNED not null default 1 CHECK (meeting_number BETWEEN 1 AND 2),
    status enum('Pending', 'Approved', 'Rejected', 'Cancelled', 'Completed') default 'Pending',
    created_at timestamp default current_timestamp,
    remarks text,
    FOREIGN KEY (adopter_id) REFERENCES Adopters(adopter_id) ON DELETE CASCADE,
    FOREIGN KEY (pet_id) REFERENCES Pets(pet_id) ON DELETE CASCADE,
    index(adopter_id),
    index(pet_id),
    INDEX (appointment_date),
    INDEX (status)
);
select * from Appointments;

-- Vet Table
create table Veterinarians(
	vet_id smallint unsigned primary key auto_increment,
    vet_name varchar(100) not null,
    email VARCHAR(100) UNIQUE NOT NULL,
    contact_no VARCHAR(15),
    specialization VARCHAR(100),
    clinic_name varchar(100),
	address TEXT NOT NULL,
    city VARCHAR(50),
    pincode VARCHAR(6),
    available_days VARCHAR(100),
    available_time VARCHAR(100),
    extra_info text,
    INDEX (city),
    INDEX (specialization)
);
select * from Veterinarians;

-- Images of pet table for multiple images
CREATE TABLE PetImages (
    image_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    pet_id SMALLINT UNSIGNED NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    FOREIGN KEY (pet_id) REFERENCES Pets(pet_id) ON DELETE CASCADE,
	INDEX (pet_id)
);