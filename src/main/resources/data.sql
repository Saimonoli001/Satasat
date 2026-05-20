
INSERT INTO categories (name, description, icon) SELECT 'Programming', 'Learn to code in various languages', 'fas fa-laptop-code' WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Programming');
INSERT INTO categories (name, description, icon) SELECT 'Language', 'Learn a new spoken language', 'fas fa-language' WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Language');
INSERT INTO categories (name, description, icon) SELECT 'Music', 'Learn to play instruments or sing', 'fas fa-music' WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Music');
INSERT INTO categories (name, description, icon) SELECT 'Art & Design', 'Painting, drawing, and graphic design', 'fas fa-palette' WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Art & Design');
INSERT INTO categories (name, description, icon) SELECT 'Fitness', 'Yoga, workouts, and health', 'fas fa-dumbbell' WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Fitness');
INSERT INTO categories (name, description, icon) SELECT 'Cooking', 'Culinary skills and recipes', 'fas fa-utensils' WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Cooking');


-- Passwords: admin@satasat.com = Admin@123 | saimon@satasat.com = Test@1234
INSERT INTO users (full_name, email, password_hash, role, status) SELECT 'System Admin', 'admin@satasat.com', 'e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7', 'ADMIN', 'ACTIVE' WHERE NOT EXISTS (SELECT 1 FROM users WHERE email='admin@satasat.com');

INSERT INTO users (full_name, email, password_hash, role, status) SELECT 'Saimon Oli', 'saimon@satasat.com', '849f1575ccfbf3a4d6cf00e6c5641b7fd4da2ed3e212c2d79ba9161a5a432ff0', 'USER', 'ACTIVE' WHERE NOT EXISTS (SELECT 1 FROM users WHERE email='saimon@satasat.com');
