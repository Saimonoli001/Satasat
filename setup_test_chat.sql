INSERT INTO skills (user_id, category_id, title, description, skill_level, availability, is_active, view_count, created_at, updated_at) 
VALUES (1, 2, 'Language Tutoring', 'I can teach English fluently.', 'EXPERT', 'Weekdays', 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO barter_requests (requester_id, receiver_id, offered_skill_id, requested_skill_id, message, counter_message, status, created_at, updated_at)
VALUES (1, 2, 2, 1, 'Hi Saimon, lets exchange skills!', '', 'ACCEPTED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO sessions (request_id, scheduled_date, status, created_at)
VALUES (1, CURRENT_TIMESTAMP, 'SCHEDULED', CURRENT_TIMESTAMP);

INSERT INTO messages (request_id, sender_id, content, sent_at)
VALUES (1, 1, 'Hello Saimon! Here is our Jitsi link: https://meet.jit.si/satasat-session-1', CURRENT_TIMESTAMP);
