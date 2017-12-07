SET search_path TO quizschema;

-- Insert all questions first
INSERT INTO Question_Bank (qID, Qtype, Question) VALUES
    (782, 'MC', 'What do you promise when you take the oath of citizenship?'),
    (566, 'TF', 'The Prime Minister, Justin Trudeau, is Canada''s Head of State.'),
    (601, 'NUM', 'During the "Quiet Revolution," Quebec experienced rapid change. In what
    decade did this occur? (Enter the year that began the decade, e.g., 1840.)'),
    (625, 'MC', 'What is the Underground Railroad?'),
    (790, 'MC', 'During the War of 1812 the Americans burned down the Parliament Buildings in
    York (now Toronto). What did the British and Canadians do in return?');

-- Insert multiple choices questions correct answer
INSERT INTO MC_answer (qID, Correct_answer) VALUES
    (782, 'To pledge your loyalty to the Sovereign, Queen Elizabeth II'),
    (625, 'A network used by slaves who escaped the United States into Canada'),
    (790, 'They burned down the White House in Washington D.C.');

-- Insert the wrong answers for multiple choices questions
INSERT INTO MC_wrong_answer (qID, aID, wrong_answer, hint) VALUES
    (782, 1, 'To pledge your allegiance to the flag and fulfill the duties of a Canadian', NULL),
    (782, 2, 'To pledge your allegiance to the flag and fulfill the duties of a Canadian', 'Think regally.'),
    (782, 3, 'To pledge your loyalty to Canada from sea to sea', NULL),
    (625, 1, 'The first railway to cross Canada', 'The Underground Railroad was generally south to north,
    not east-west.'),
    (625, 2, 'The CPR''s secret railway line', 'The Underground Railroad was secret, but it had nothing to do
    with trains.'),
    (625, 3, 'The TTC subway system', 'The TTC is relatively recent; the Underground Railroad was
    in operation over 100 years ago.'),
    (790, 1, 'They attacked American merchant ships', NULL),
    (790, 2, 'They expanded their defence system, including Fort York', NULL ),
    (790, 3, 'They captured Niagara Falls', NULL);

-- Insert T/F correct answer
INSERT INTO TF_answer (qID, tf_answer) VALUES
    (566, 'False');

-- Insert numerical question correct answer
INSERT INTO NUM_answer (qID, Correct_answer) VALUES
    (601, 1960);

-- Insert the wrong answers for numerical questions
INSERT INTO NUM_wrong_answer (qID, Lower_bound, Upper_bound, hint) VALUES
    (601, 1800, 1900, 'The Quiet Revolution happened during the 20th
    Century.'),
    (601, 2000, 2010, 'The Quiet Revolution happened some time ago.'),
    (601, 2020, 3000, 'The Quiet Revolution has already happened!');

-- Insert Student Info
INSERT INTO Student (sID, FirstName, SurName) VALUES
    (0998801234, 'Lena', 'Headey'),
    (0010784522, 'Peter', 'Dinklage'),
    (0997733991, 'Emilia', 'Clarke'),
    (5555555555, 'Kit', 'Harrington'),
    (1111111111, 'Sophie', 'Turner'),
    (2222222222, 'Maisie', 'Williams');

-- Construct the room-teacher relation
INSERT INTO Room (Room, Teacher) VALUES
    ('room 120', 'Mr Higgins'),
    ('room 366', 'Miss Nyers');

-- Fill in Class info
INSERT INTO Class (cID, Room, Grade) VALUES
    (1, 'room 120', 'grade 8'),
    (2, 'room 366', 'grade 5');

-- Build Student taking Class relation
INSERT INTO TakingClass (sID, cID) VALUES
    (0998801234, 1),
    (0010784522, 1),
    (0997733991, 1),
    (5555555555, 1),
    (1111111111, 1),
    (2222222222, 2);

-- Define basic info about the quiz
INSERT INTO Quiz (quizID, Title, Class, DueBy, hint_allowed) VALUES
    ('Pr1-220310', 'Citizenship Test Practise Questions', 1, '2017-10-01 13:30:00
', 'True');

-- List the questions inside the quiz
INSERT INTO QuizQuestion (quizID, questionID, weight) VALUES
    ('Pr1-220310', 601, 2),
    ('Pr1-220310', 566, 1),
    ('Pr1-220310', 790, 3),
    ('Pr1-220310', 625, 2);

-- Record student's performance on the quiz
INSERT INTO Response (quizID, sID, cID, answered,answer) VALUES
    ('Pr1-220310', 0998801234, 1, 601, '1950'),
    ('Pr1-220310', 0998801234, 1, 566, 'False'),
    ('Pr1-220310', 0998801234, 1, 790, 'They expanded their defence system, including Fort York'),
    ('Pr1-220310', 0998801234, 1, 625, 'A network used by slaves who escaped the United States into Canada'),
    ('Pr1-220310', 0010784522, 1, 601, '1960'),
    ('Pr1-220310', 0010784522, 1, 566, 'False'),
    ('Pr1-220310', 0010784522, 1, 790, 'They burned down the White House in Washington D.C.'),
    ('Pr1-220310', 0010784522, 1, 625, 'A network used by slaves who escaped the United States into Canada'),
    ('Pr1-220310', 0997733991, 1, 601, '1960'),
    ('Pr1-220310', 0997733991, 1, 566, 'True'),
    ('Pr1-220310', 0997733991, 1, 790, 'They burned down the White House in Washington D.C.'),
    ('Pr1-220310', 0997733991, 1, 625, 'The CPR''s secret railway line'),
    ('Pr1-220310', 5555555555, 1, 566, 'False'),
    ('Pr1-220310', 5555555555, 1, 790, 'They captured Niagara Falls');
