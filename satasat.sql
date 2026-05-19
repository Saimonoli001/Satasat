CREATE TABLE IF NOT EXISTS users (
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

CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(500),
    icon VARCHAR(100),
    is_active INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS skills (
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

CREATE TABLE IF NOT EXISTS barter_requests (
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

CREATE TABLE IF NOT EXISTS sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    scheduled_date TIMESTAMP,
    completed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    status VARCHAR(50) DEFAULT 'SCHEDULED',
    FOREIGN KEY (request_id) REFERENCES barter_requests(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS reviews (
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

CREATE TABLE IF NOT EXISTS messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    sender_id INT NOT NULL,
    content TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES barter_requests(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS reports (
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


INSERT INTO users VALUES
(1, 'System Admin', 'admin@satasat.com', 'e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7', NULL, NULL, NULL, 'ADMIN', 'ACTIVE', 0.0, 0, '2026-05-17 18:10:26.75505', '2026-05-17 18:10:26.75505'),
(2, 'Saimon Oli', 'saimon@satasat.com', '849f1575ccfbf3a4d6cf00e6c5641b7fd4da2ed3e212c2d79ba9161a5a432ff0', NULL, NULL, NULL, 'USER', 'ACTIVE', 0.0, 0, '2026-05-17 18:10:26.757068', '2026-05-17 18:10:26.757068');


INSERT INTO categories VALUES
(1, 'Programming', 'Learn to code in various languages', 'fas fa-laptop-code', 1, '2026-05-17 18:10:26.745341'),
(2, 'Language', 'Learn a new spoken language', 'fas fa-language', 1, '2026-05-17 18:10:26.748057'),
(3, 'Music', 'Learn to play instruments or sing', 'fas fa-music', 1, '2026-05-17 18:10:26.750059'),
(4, 'Art & Design', 'Painting, drawing, and graphic design', 'fas fa-palette', 1, '2026-05-17 18:10:26.751058'),
(5, 'Fitness', 'Yoga, workouts, and health', 'fas fa-dumbbell', 1, '2026-05-17 18:10:26.753053'),
(6, 'Cooking', 'Culinary skills and recipes', 'fas fa-utensils', 1, '2026-05-17 18:10:26.754054');


INSERT INTO skills VALUES
(1, 2, 1, 'Java Programming', 'I can teach Java basics and OOP principles.', 'INTERMEDIATE', 'Weekends', 1, 0, '2026-05-19 18:48:45.55206', '2026-05-19 18:48:45.55206');


INSERT INTO skills (user_id, category_id, title, description, skill_level, availability, is_active, view_count, created_at, updated_at) 
VALUES (1, 2, 'Language Tutoring', 'I can teach English fluently.', 'EXPERT', 'Weekdays', 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO barter_requests (requester_id, receiver_id, offered_skill_id, requested_skill_id, message, counter_message, status, created_at, updated_at)
VALUES (1, 2, 2, 1, 'Hi Saimon, lets exchange skills!', '', 'ACCEPTED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO sessions (request_id, scheduled_date, status, created_at)
VALUES (1, CURRENT_TIMESTAMP, 'SCHEDULED', CURRENT_TIMESTAMP);

INSERT INTO messages (request_id, sender_id, content, sent_at)
VALUES (1, 1, 'Hello Saimon! Here is our Jitsi link: https://meet.jit.si/satasat-session-1', CURRENT_TIMESTAMP);
