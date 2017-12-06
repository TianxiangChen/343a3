SET search_path TO quizschema;

DROP VIEW IF EXISTS StudentInQuiz CASCADE;
DROP VIEW IF EXISTS Questions CASCADE;
DROP VIEW IF EXISTS StudentAnswered CASCADE;
DROP VIEW IF EXISTS StudentAllAnswered CASCADE;

CREATE VIEW StudentInQuiz AS
SELECT Student.sID AS sID,
CONCAT(Student.FirstName,' ',Student.SurName) AS FullName
FROM Quiz NATURAL JOIN TakingClass NATURAL JOIN Class
NATURAL JOIN Room NATURAL JOIN Student
WHERE Quiz.quizID = 'Pr1-220310' AND  Class.Grade = '8'
AND Class.Room = '120' AND Room.Teacher = 'Mr Higgins'
GROUP BY Student.sID, Student.FirstName, Student.SurName;

CREATE VIEW Questions AS
SELECT Question_Bank.qID AS qID, Question_Bank.Question AS text
FROM QuizQuestion NATURAL JOIN Quiz NATURAL JOIN TakingClass NATURAL JOIN Class NATURAL JOIN Question_Bank NATURAL JOIN Room
WHERE Quiz.quizID ='Pr1-220310' AND  Class.Grade = '8'
AND Class.Room = '120' AND Room.Teacher = 'Mr Higgins';

CREATE VIEW StudentAnswered AS
SELECT StudentInQuiz.sID AS sID, Questions.qID AS qID, Questions.text AS text
FROM StudentInQuiz NATURAL JOIN Response, Questions
WHERE Response.quizID = 'Pr1-220310' AND Response.answered = Questions.qID;

CREATE VIEW StudentAllAnswered AS
SELECT StudentInQuiz.sID AS sID, Questions.qID AS qID, Questions.text AS text
FROM StudentInQuiz, Questions;


SELECT * FROM StudentAllAnswered
EXCEPT
SELECT * FROM StudentAnswered;
