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
    photo varchar(255),
    role ENUM('Admin', 'Adopter') NOT NULL DEFAULT 'Adopter',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX (username),
    INDEX (email),
    INDEX (city),
    INDEX (role)
);
insert into users(fullname,username,email, password,address,role)values('Netra Patel','Netra123', 'netrajigneshpatel@gmail.com','2cde53fd409ba5293fa23ccb7669fae75fb5398a1ec06141851d969c3c31e27c','naranpura','Adopter');
insert into users(fullname, username, email, password,address,role) values('admin','admin_1223', 'admin1223@gmail.com', 'aece1accf9f8d41e780185450770cfa43a43ed8d07b16f8c34b4209fee7c1a7a','aabbbccdd','Admin');
insert into Users(fullname, username, email, password,address,role) values('Riya Sanjay Mahale', 'ruchitamahale18', 'ruchitamahale180904@gmail.com',  'b7fe75f14eb09c06e7ce44e6fab1eaa74a956bed58e0215cfe729332bff345fc','dfsdfds','Admin');


select * from users;

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
    status ENUM('Available', 'Adopted','Deceased') DEFAULT 'Available',
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
    previous_owner_name varchar(80),
    contact_no varchar(15),
    -- address varchar(200) NOT NULL,
	-- area varchar(50) NOT NULL,
    -- city varchar(50) NOT NULL,
    -- pincode varchar(6) NOT NULL,
    story text,
    reason_for_rehoming TEXT,
    INDEX (species),
    INDEX (breed),
    INDEX (gender),
    INDEX (status)
    -- INDEX (city),
    -- INDEX (area)
);
INSERT INTO Pets (name, species, breed, age, gender, weight, height, description, status, image, color, neutered_or_spayed, vaccinated, 
	good_with_pets, good_with_kids, good_with_strangers, behavioral_traits, health_status, medication, preferable_food, special_needs, 
    daily_routine, trained_for, dietary_restrictions, previous_owner_name, contact_no, story, reason_for_rehoming) VALUES
('Bella', 'Dog', 'Labrador Retriever', 3, 'Female', 25.00, 60.00, 'Friendly and energetic', 'Available', '1-bella.png', 'Golden', 
 'Yes', 'Yes', 'Yes', 'Yes', 'Yes', 'Playful, Loyal', 'Healthy', '', 'Dry food, Chicken treats', '', 
 'Morning and evening walks', 'Sit, Stay', '', 'Ramesh Patel', '+91-9876543210', 
 'I''m Bella, a joyful Labrador who loves to play fetch and go on long walks. I used to live with a lovely family, but they had to move away and couldn’t take me along. I’m looking for a new family who’ll shower me with cuddles and treats!', 
 'Owners moved away and couldn’t take me along.'),
('Max', 'Dog', 'German Shepherd', 5, 'Male', 30.00, 65.00, 'Protective and well-trained', 'Available', '2-max.jpg', 'Black & Tan', 
 'Yes', 'Partially', 'Yes', 'No', 'Yes', 'Alert, Intelligent', 'Arthritis in one leg', 'Pain relief meds', 
 'High-protein kibble', 'Soft bedding', 'Morning walks', 'Guard commands', 'Avoid wheat', 'Sneha Mehta', '+91-9823456781', 
 'I’m Max, a loyal German Shepherd. I was trained by a retired army officer and I’m always on alert. After he passed away, I’ve been longing for someone who appreciates my intelligence and strong protective instincts.', 
 'Owner passed away.'),
('Whiskers', 'Cat', 'Persian', 2, 'Female', 5.00, 25.00, 'Gentle and quiet', 'Available', '3-whiskers.jpg', 'White', 
 'No', 'No', 'Unknown', 'Yes', 'Unknown', 'Calm, Affectionate', 'Healthy', '', 'Soft canned food', '', 
 'Afternoon naps', 'Litter trained', 'Avoid dairy', 'Nikita Shah', '+91-9898989898', 
 'Hi, I’m Whiskers. I was rescued from a busy marketplace where I used to hide behind food stalls. Now, I love my cozy foster home, but I dream of finding a forever home where I can nap in peace and be loved.', 
 'Rescued from a marketplace, seeking a forever home.'),
('Buddy', 'Dog', 'Labrador Retriever', 3, 'Male', 30.00, 60.00, 'Friendly and playful, loves kids and running.', 'Available', '4-buddy.png', 'Golden', 
 'Yes', 'Yes', 'Yes', 'Yes', 'Yes', 'Energetic, Loyal', 'Healthy', '', 'Dry food, Peanut butter biscuits', '', 
 'Plays in garden, evening walk', 'Fetch', '', 'Amit Sharma', '+91-9812345678', 
 'They call me Buddy because I really am everyone’s best buddy! I love running around with kids and I’m always the life of the garden. I was left behind when my owners moved, but I still have so much love to give.', 
 'Owners moved and left me behind.'),
('Luna', 'Cat', 'Persian', 2, 'Female', 4.50, 25.00, 'Quiet and cuddly cat, perfect for indoors.', 'Available', '5-luna5.jpg', 'Cream', 
 'Yes', 'Partially', 'Yes', 'Yes', 'No', 'Calm, Gentle', 'Allergic to certain foods', '', 'Canned tuna, Chicken bits', '', 
 'Sleeps on window sill', 'Litter trained', 'Avoid cold', 'Rina Desai', '+91-9966554433', 
 'I’m Luna, a sweet Persian with a soft heart. My previous owner developed allergies and had to give me up. I may be quiet, but my gentle purrs and cuddles speak volumes. I just want to be someone’s calm companion.', 
 'Owner developed allergies.'),
('Charlie', 'Dog', 'Beagle', 4, 'Male', 11.20, 35.00, 'Loves walks and howls when happy.', 'Available', '6-charlie.jpg', 'Brown and White', 
 'Yes', 'Yes', 'No', 'Yes', 'Yes', 'Curious, Active', 'Recovered from tick fever', '', 'Dry food, Carrot sticks', '', 
 'Morning walks, Evening playtime', 'Basic obedience', 'Avoid red meat', 'Jatin Bhatt', '+91-9833123456', 
 'Charlie’s the name, and howling when I’m happy is my game! I used to wander streets before I found my way to a kind rescuer. I adore company, belly rubs, and long sniffy walks.', 
 'Rescued from the streets.'),
('Simba', 'Cat', 'Siamese', 1, 'Male', 3.60, 22.00, 'Very social, loves attention and play.', 'Available', '7-simba.jpg', 'Cream and Brown', 
 'No', 'No', 'Yes', 'Yes', 'Yes', 'Affectionate, Vocal', 'Healthy', '', 'Chicken and fish mix', '', 
 'Interactive play sessions', 'Responds to name', 'Avoid spicy food', 'Vidhi Joshi', '+91-9877012345', 
 'I’m Simba, and I believe the world is my playground. I was born on the streets but rescued as a kitten. I’ve grown up surrounded by humans and love chatting with everyone. Give me toys and I’ll show you my moves!', 
 'Rescued as a kitten.'),
('Daisy', 'Dog', 'Pomeranian', 5, 'Female', 5.00, 28.00, 'Fluffy and sassy, needs gentle grooming.', 'Available', '8-daisy.jpg', 'White', 
 'Yes', 'Yes', 'No', 'Yes', 'Yes', 'Protective, Loving', 'Under medication for joints', 'Joint medication', 'Dry food, Boiled egg', 'Grooming twice a week', 
 '','Sit, Paw', 'Avoid sugar', 'Bhavna Trivedi', '+91-9911223344', 
 'Hello! I’m Daisy, a little diva with a big personality. My fluffy coat turns heads everywhere I go. I was pampered until my previous owner had to move abroad. I miss the cuddles and can’t wait to be spoiled again!', 
 'Owner moved abroad.'),
('Sheru', 'Dog', 'Indian Pariah', 2, 'Male', 18.50, 50.00, 'Smart and alert street dog, loyal companion.', 'Available', '9-sheru.jpg', 'Brown', 
 'No', 'Partially', 'Yes', 'Yes', 'Yes', 'Alert, Friendly', 'Minor skin allergies', '', 'Balanced home-cooked food', '', 
 'Street walks twice a day', 'Basic commands', 'Avoid milk', 'Deepak Solanki', '+91-9988776655', 
 'I’m Sheru, a proud Indian Pariah dog. I lived near a tea stall and helped guard the area until a volunteer took me in. I’m smart and street-wise and would make a fiercely loyal friend.', 
 'Rescued from near a tea stall.'),
('Moti', 'Dog', 'Rajapalayam Hound', 4, 'Male', 25.00, 65.00, 'Regal, muscular and protective.', 'Available', '10-moti.png', 'White', 
 'Yes', 'Yes', 'No', 'No', 'No', 'Territorial, Bold', 'Healthy', '', 'Protein-rich diet', '', 
 'Walks and runs daily', 'Obedience trained', 'Avoid excess salt', 'Shalini Iyer', '+91-9922334455', 
 'My name is Moti, and I’m as regal as they come. I was raised in a rural home and trained to protect. When my owner aged and couldn’t handle me anymore, I was brought here. I’m waiting for a strong-hearted human to be my partner.', 
 'Owner aged and couldn’t handle me.'),
('Chikki', 'Cat', 'Indian Billi', 3, 'Female', 3.00, 20.00, 'Independent yet affectionate stray cat.', 'Available', '11-chikki.jpg', 'Grey Tabby', 
 'No', 'No', 'Yes', 'Yes', 'Unknown', 'Curious, Quiet', 'Healthy', '', 'Canned fish', '', 
 'Roams locally', 'Litter trained', 'Avoid bones', 'Hardik Vyas', '+91-9898123412', 
 'Chikki here! I’m a street cat with a twist—I actually love being around people. I grew up near a bookstore where readers used to feed me. Now I want a lap to curl up in and maybe some bedtime stories too.', 
 'Rescued from near a bookstore.'),
('Raja', 'Dog', 'Kombai', 5, 'Male', 28.00, 70.00, 'Protective and powerful, good guard dog.', 'Available', '12-rani.png', 'Brown', 
 'Yes', 'Yes', 'No', 'No', 'Yes', 'Fearless, Loyal', 'Recovering from leg injury', 'Leg bandage care', 'Boiled meat, Dry food', 'Gentle exercise only', 
 'Evening patrol', 'Basic guard skills', 'Avoid rough play', 'Neha Modi', '+91-9822221100', 
 'I’m Rani, a brave Kombai breed. I was injured while protecting my old home from intruders. Now that I’m healing, I’m hoping for a peaceful place where my loyalty will be cherished, not tested.', 
 'Injured while protecting home, owner couldn’t care for me.'),
('Mintu', 'Dog', 'Indian Spitz', 2, 'Male', 10.00, 35.00, 'Friendly and lively, ideal for small homes.', 'Available', '13-mintu.jpeg', 'Cream', 
 'No', 'Partially', 'Yes', 'Yes', 'Yes', 'Playful, Loving', 'Mild digestive issue', '', 'Dry food, Vegetables', '', 
 'Indoor play, evening walks', 'Sit, Stay', 'Avoid oily food', 'Priya Malhotra', '+91-9876765432', 
 'Mintu’s my name and making you smile is my mission! I used to be the star of a small family, but they moved to a city apartment that didn’t allow pets. I promise I’ll light up your home with my cheerful vibes!', 
 'Owners moved to a no-pet apartment.'),
('Tiger', 'Dog', 'Chippiparai', 3, 'Male', 22.00, 65.00, 'Elegant and loyal, ideal for active families.', 'Available', '14-tiger.jpg', 'Silver-grey', 
 'Yes', 'Yes', 'Yes', 'Yes', 'Yes', 'Graceful, Obedient', 'Healthy', '', 'Meat-based food', '', 
 'Morning runs, Training', 'Advanced commands', 'Avoid sweet food', 'Pooja Nair', '+91-9800678901', 
 'I’m Tiger, sleek and swift. I was once part of a racing training camp but wasn’t fast enough to keep up. All I want now is to run around a backyard and cuddle with someone who appreciates my grace.', 
 'Didn’t meet racing camp standards.'),
('Meera', 'Dog', 'Mudhol Hound', 2, 'Female', 20.00, 70.00, 'High-energy and intelligent, requires regular exercise.', 'Available', '15-meera.jpg', 'Fawn', 
 'No', 'Partially', 'No', 'No', 'Yes', 'Alert, Agile', 'Healthy', '', 'High-energy food', '', 
 'Daily jogs and fetch', 'Jump, Run', 'Avoid excess protein', 'Manoj Kumar', '+91-9911442233', 
 'Meera here, your agile workout buddy! I was bred for running and have lots of energy to burn. A busy family adopted me once, but they couldn’t keep up. I need an active home that loves outdoor adventures.', 
 'Previous family couldn’t match my energy.'),
('Sultan', 'Dog', 'Indian Leopard Hound', 4, 'Male', 26.00, 68.00, 'Rare sight hound, very alert and agile.', 'Available', '16-sultan.png', 'Brindle', 
 'Yes', 'Yes', 'No', 'No', 'No', 'Intelligent, Fierce', 'Needs vet follow-up for leg sprain', 'Leg sprain meds', 'Meat, Dry food', '', 
 'Evening guard duty', 'Track and alert', 'Avoid overfeeding', 'Ayesha Khan', '+91-9871234567', 
 'I’m Sultan, a rare and noble hound. I sprained my leg while chasing after a goat (long story!). I’m recovering well, and I’d love a peaceful home where I can watch over you from a sunny spot.', 
 'Injured while chasing, needs a new home.'),
('Jugnu', 'Dog', 'Indian Mastiff', 5, 'Male', 40.00, 75.00, 'Strong and fearless guardian, experienced owner preferred.', 'Available', '17-jugnu.png', 'White and Tan', 
 'Yes', 'Yes', 'No', 'No', 'Yes', 'Bold, Dominant', 'Recovered from skin condition', '', 'Heavy meals with rice and meat', '', 
 'Guard duty twice a day', 'Sit, Guard', 'Avoid bones', 'Arjun Deshmukh', '+91-9819876543', 
 'They call me Jugnu because I light up the place with my strong presence. I was a guard dog in a warehouse, but after they shut down, I was left behind. I’m now ready for a second chance with someone who respects strength and loyalty.', 
 'Warehouse shut down, left behind.');

select * from Pets;
-- Adopters Table
CREATE TABLE Adopters (
    user_id smallint unsigned PRIMARY KEY,
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
	foreign key(user_id) references Users(user_id) on delete cascade,
    CHECK (
        (has_any_allergy = 'No' AND allergy_details IS NULL) OR 
        (has_any_allergy = 'Yes' AND allergy_details IS NOT NULL)
    ),
    CHECK (
        (has_pets = 'No' AND no_of_pets IS NULL) OR 
        (has_pets = 'Yes' AND no_of_pets IS NOT NULL)
    )
);

-- Assuming the user_id = 1 exists in Users table
INSERT INTO Adopters (
    user_id, has_pets, no_of_pets, no_of_family_members, has_any_allergy, allergy_details
) VALUES (
    1, 'No', NULL, 4, 'Yes', 'Allergic to cat fur'
);

-- user_id = 2, has pets and no allergies
INSERT INTO Adopters (
    user_id, has_pets, no_of_pets, no_of_family_members, has_any_allergy, allergy_details
) VALUES (
    2, 'Yes', 2, 3, 'No', NULL
);


select * from Adopters;

-- Adoption Requests Table
CREATE TABLE AdoptionRequests (
    request_id smallint unsigned PRIMARY KEY AUTO_INCREMENT,
    user_id smallint unsigned,
    pet_id smallint unsigned,
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- message text,
    reason_for_adoption TEXT NOT NULL,
    status ENUM('Pending', 'Accepted', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES Adopters(user_id) ON DELETE CASCADE,
    FOREIGN KEY (pet_id) REFERENCES Pets(pet_id) ON DELETE CASCADE,
    INDEX (user_id),
    INDEX (pet_id),
    INDEX (status)
);
select * from AdoptionRequests;
-- Assuming pet_id = 1 and 2 exist in the Pets table
INSERT INTO AdoptionRequests (
    user_id, pet_id, reason_for_adoption
) VALUES (
    1, 1, 'Looking for a companion for my elderly parent'
);

INSERT INTO AdoptionRequests (
    user_id, pet_id, reason_for_adoption
) VALUES (
    2, 2, 'We want to adopt a pet for our kids to grow up with'
);

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
    user_id smallint unsigned not null,
    pet_id smallint unsigned not null,
    appointment_date date not null,
    appointment_time time not null,
    meeting_number TINYINT UNSIGNED not null default 1 CHECK (meeting_number BETWEEN 1 AND 2),
    status enum('Pending', 'Approved', 'Rejected', 'Cancelled', 'Completed') default 'Pending',
    created_at timestamp default current_timestamp,
    remarks text,
    FOREIGN KEY (user_id) REFERENCES Adopters(user_id) ON DELETE CASCADE,
    FOREIGN KEY (pet_id) REFERENCES Pets(pet_id) ON DELETE CASCADE,
    index(user_id),
    index(pet_id),
    INDEX (appointment_date),
    INDEX (status)
);
select * from Appointments;

-- Vet Table
create table Veterinarians(
	vet_id smallint unsigned primary key auto_increment,
    vet_name varchar(100) not null,
    photo varchar(255),
    email VARCHAR(100) UNIQUE NOT NULL,
    contact_no VARCHAR(15),
    specialization VARCHAR(100),
    clinic_name varchar(100),
	address TEXT NOT NULL,
    area varchar(50) NOT NULL,
    city VARCHAR(50),
    pincode VARCHAR(6),
    available_days VARCHAR(100),
    available_time VARCHAR(100),
    extra_info text,
    index(area),
    INDEX (city),
    INDEX (specialization)
);
INSERT INTO Veterinarians (
    vet_name, photo, email, contact_no, specialization, clinic_name,
    address, area, city, pincode, available_days, available_time, extra_info
) VALUES
('Dr. Neha Shah', 'neha_shah.jpg', 'dr.neha.shah@gmail.com', '9876543210', 'Small Animals', 'PawCare Veterinary Clinic',
    '12, Shivalik Business Center, Opp. AMA', 'IIM Road', 'Ahmedabad', '380015',
    'Monday to Saturday', '10:00 AM - 1:00 PM, 5:00 PM - 8:00 PM',
    'Specializes in dog and cat care. Emergency services available.'),
('Dr. Anil Patel', 'anil_patel.jpg', 'anil.patel@vetcare.com', '9876543210', 'Small Animal Medicine', 'Paws & Claws Clinic',
    'Shop No. 12, Surya Complex, Gurukul Road', 'Memnagar', 'Ahmedabad', '380052',
    'Monday-Saturday', '10:00 AM - 6:00 PM',
    'Specializes in canine and feline health, vaccinations, and surgeries.'),
('Dr. Priya Sharma', 'priya_sharma.jpg', 'priya.sharma@pethealth.in', '9825012345', 'Avian Medicine', 
	'Feather Care Vet Clinic', 'B-203, Shivam Apartment, Near Manekbaug Hall', 'Ambawadi', 'Ahmedabad', '380015',
    'Tuesday-Sunday', '9:00 AM - 5:00 PM',
    'Expert in treating birds, including parrots and pigeons.'),
('Dr. Karan Desai', 'karan_desai.jpg', 'dr.karan@desaivet.in', '9900011122',
    'Exotic Animals', 'ExoVet Animal Clinic',
    '1st Floor, Eden Complex', 'Satellite', 'Ahmedabad', '380015',
    'Wednesday to Monday', '10:30 AM - 1:30 PM, 5:30 PM - 8:30 PM',
    'Specializes in birds, rabbits, and exotic pets.'),
('Dr. Aarti Mehta', 'aarti_mehta.jpg', 'draarti.petclinic@gmail.com', '9898123456',
    'Vaccination & Preventive Care', 'Happy Paws Animal Hospital',
    'GF-4, Aaryan Workspaces, Near Bopal Cross Road', 'Bopal', 'Ahmedabad', '380058',
    'Tuesday to Sunday', '11:00 AM - 2:00 PM, 6:00 PM - 9:00 PM',
    'Offers annual health check packages for pets.');
select * from Veterinarians;
drop table Veterinarians;

-- Images of pet table for multiple images
-- CREATE TABLE PetImages (
--     image_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
--     pet_id SMALLINT UNSIGNED NOT NULL,
--     image_url VARCHAR(255) NOT NULL,
--     FOREIGN KEY (pet_id) REFERENCES Pets(pet_id) ON DELETE CASCADE,
-- 	INDEX (pet_id)
-- );