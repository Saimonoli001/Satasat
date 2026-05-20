-- Demo chat/session data (safe to re-run after satasat.sql / schema + seed)

INSERT INTO skills (user_id, category_id, title, description, skill_level, availability, is_active, view_count)
SELECT u.id, c.id, 'Language Tutoring', 'I can teach English fluently.', 'EXPERT', 'Weekdays', 1, 0
FROM users u
JOIN categories c ON c.name = 'Language'
WHERE u.email = 'admin@satasat.com'
  AND NOT EXISTS (SELECT 1 FROM skills s WHERE s.user_id = u.id AND s.title = 'Language Tutoring');

INSERT INTO barter_requests (requester_id, receiver_id, offered_skill_id, requested_skill_id, message, counter_message, status)
SELECT admin_u.id, saimon_u.id, offered.id, requested.id,
       'Hi Saimon, lets exchange skills!', '', 'ACCEPTED'
FROM users admin_u
JOIN users saimon_u ON saimon_u.email = 'saimon@satasat.com'
JOIN skills offered ON offered.user_id = admin_u.id AND offered.title = 'Language Tutoring'
JOIN skills requested ON requested.user_id = saimon_u.id AND requested.title = 'Java Programming'
WHERE admin_u.email = 'admin@satasat.com'
  AND NOT EXISTS (
    SELECT 1 FROM barter_requests br
    WHERE br.requester_id = admin_u.id
      AND br.receiver_id = saimon_u.id
      AND br.message = 'Hi Saimon, lets exchange skills!'
  );

INSERT INTO sessions (request_id, scheduled_date, status)
SELECT br.id, CURRENT_TIMESTAMP, 'SCHEDULED'
FROM barter_requests br
JOIN users admin_u ON admin_u.id = br.requester_id AND admin_u.email = 'admin@satasat.com'
WHERE br.message = 'Hi Saimon, lets exchange skills!'
  AND NOT EXISTS (SELECT 1 FROM sessions s WHERE s.request_id = br.id);

INSERT INTO messages (request_id, sender_id, content)
SELECT br.id, admin_u.id, 'Hello Saimon! Here is our Jitsi link: https://meet.jit.si/satasat-session-1'
FROM barter_requests br
JOIN users admin_u ON admin_u.id = br.requester_id AND admin_u.email = 'admin@satasat.com'
WHERE br.message = 'Hi Saimon, lets exchange skills!'
  AND NOT EXISTS (
    SELECT 1 FROM messages m
    WHERE m.request_id = br.id
      AND m.content LIKE 'Hello Saimon! Here is our Jitsi link:%'
  );
