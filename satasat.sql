-- Resets and creates the satasat database (run entire script in MySQL Workbench)

DROP DATABASE IF EXISTS satasat;
CREATE DATABASE satasat;
USE satasat;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    bio TEXT,
    profile_image VARCHAR(255),
    location VARCHAR(255),
    role VARCHAR(50) DEFAULT 'USER',
    status VARCHAR(50) DEFAULT 'ACTIVE',
    avg_rating DOUBLE DEFAULT 0.0,
    total_reviews INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(500),
    icon VARCHAR(100),
    is_active INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    skill_level VARCHAR(50),
    availability VARCHAR(255),
    is_active INT DEFAULT 1,
    view_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

CREATE TABLE barter_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    requester_id INT NOT NULL,
    receiver_id INT NOT NULL,
    offered_skill_id INT NOT NULL,
    requested_skill_id INT NOT NULL,
    message TEXT,
    counter_message TEXT,
    status VARCHAR(50) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (requester_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (offered_skill_id) REFERENCES skills(id) ON DELETE CASCADE,
    FOREIGN KEY (requested_skill_id) REFERENCES skills(id) ON DELETE CASCADE
);

CREATE TABLE sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    scheduled_date TIMESTAMP,
    completed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    status VARCHAR(50) DEFAULT 'SCHEDULED',
    FOREIGN KEY (request_id) REFERENCES barter_requests(id) ON DELETE CASCADE
);

CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    reviewer_id INT NOT NULL,
    reviewee_id INT NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES sessions(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewee_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    sender_id INT NOT NULL,
    content TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES barter_requests(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reporter_id INT NOT NULL,
    reported_user_id INT,
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'OPEN',
    admin_reply TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (reporter_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE wishlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    skill_id INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_skill (user_id, skill_id)
);

CREATE TABLE admin_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT NOT NULL,
    action VARCHAR(100) NOT NULL,
    target_type VARCHAR(50),
    target_id INT,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Logins: admin@satasat.com / Admin@123  |  saimon@satasat.com / Test@1234
INSERT INTO users (full_name, email, password_hash, role, status) VALUES
('System Admin', 'admin@satasat.com', 'e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7', 'ADMIN', 'ACTIVE'),
('Saimon Oli', 'saimon@satasat.com', '849f1575ccfbf3a4d6cf00e6c5641b7fd4da2ed3e212c2d79ba9161a5a432ff0', 'USER', 'ACTIVE');

INSERT INTO categories (name, description, icon) VALUES
('Programming', 'Learn to code in various languages', 'fas fa-laptop-code'),
('Language', 'Learn a new spoken language', 'fas fa-language'),
('Music', 'Learn to play instruments or sing', 'fas fa-music'),
('Art & Design', 'Painting, drawing, and graphic design', 'fas fa-palette'),
('Fitness', 'Yoga, workouts, and health', 'fas fa-dumbbell'),
('Cooking', 'Culinary skills and recipes', 'fas fa-utensils');

INSERT INTO skills (user_id, category_id, title, description, skill_level, availability, is_active, view_count)
SELECT u.id, c.id, 'Java Programming', 'I can teach Java basics and OOP principles.', 'INTERMEDIATE', 'Weekends', 1, 0
FROM users u, categories c
WHERE u.email = 'saimon@satasat.com' AND c.name = 'Programming';

INSERT INTO skills (user_id, category_id, title, description, skill_level, availability, is_active, view_count)
SELECT u.id, c.id, 'Language Tutoring', 'I can teach English fluently.', 'EXPERT', 'Weekdays', 1, 0
FROM users u, categories c
WHERE u.email = 'admin@satasat.com' AND c.name = 'Language';

INSERT INTO barter_requests (requester_id, receiver_id, offered_skill_id, requested_skill_id, message, counter_message, status)
SELECT admin_u.id, saimon_u.id, offered.id, requested.id, 'Hi Saimon, lets exchange skills!', '', 'ACCEPTED'
FROM users admin_u, users saimon_u, skills offered, skills requested
WHERE admin_u.email = 'admin@satasat.com'
  AND saimon_u.email = 'saimon@satasat.com'
  AND offered.user_id = admin_u.id AND offered.title = 'Language Tutoring'
  AND requested.user_id = saimon_u.id AND requested.title = 'Java Programming';

INSERT INTO sessions (request_id, scheduled_date, status)
SELECT br.id, CURRENT_TIMESTAMP, 'SCHEDULED'
FROM barter_requests br
JOIN users admin_u ON admin_u.id = br.requester_id AND admin_u.email = 'admin@satasat.com'
WHERE br.message = 'Hi Saimon, lets exchange skills!';

INSERT INTO messages (request_id, sender_id, content)
SELECT br.id, admin_u.id, 'Hello Saimon! Here is our Jitsi link: https://meet.jit.si/satasat-session-1'
FROM barter_requests br
JOIN users admin_u ON admin_u.id = br.requester_id AND admin_u.email = 'admin@satasat.com'
WHERE br.message = 'Hi Saimon, lets exchange skills!';

SELECT 'Database created successfully.' AS Result;
