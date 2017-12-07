SET search_path TO quizschema;

DROP VIEW IF EXISTS StudentInQuiz CASCADE;
DROP VIEW IF EXISTS Questions CASCADE;
DROP VIEW IF EXISTS StudentAnswered CASCADE;
DROP VIEW IF EXISTS StudentAllAnswered CASCADE;
DROP VIEW IF EXISTS Result CASCADE;

CREATE VIEW StudentInQuiz AS
SELECT Student.sID AS sID,
CONCAT(Student.FirstName,' ',Student.SurName) AS FullName
FROM Quiz NATURAL JOIN TakingClass NATURAL JOIN Class
NATURAL JOIN Room NATURAL JOIN Student
WHERE Quiz.quizID = 'Pr1-220310' AND  Class.Grade = 'grade 8'
AND Class.Room = 'room 120' AND Room.Teacher = 'Mr Higgins'
GROUP BY Student.sID, Student.FirstName, Student.SurName;

-- quiz's questions are defined by qID, not related to class
CREATE VIEW Questions AS
SELECT DISTINCT QuizQuestion.questionID AS qID , Question_Bank.Question AS text
FROM QuizQuestion NATURAL JOIN Quiz, Question_Bank
WHERE Quiz.quizID ='Pr1-220310' AND Question_Bank.qID = QuizQuestion.questionID;

CREATE VIEW StudentAnswered AS
SELECT StudentInQuiz.sID AS sID, Response.answered AS qID, Questions.text AS text
FROM StudentInQuiz NATURAL JOIN Response, Questions
WHERE Response.quizID = 'Pr1-220310' AND Response.answered = Questions.qID
ORDER BY StudentInQuiz.sID, Response.answered;

CREATE VIEW StudentAllAnswered AS
SELECT StudentInQuiz.sID AS sID, Questions.qID AS qID, Questions.text AS text
FROM StudentInQuiz, Questions
ORDER BY StudentInQuiz.sID, Questions.qID;

CREATE VIEW Result AS
SELECT * FROM StudentAllAnswered
EXCEPT
SELECT * FROM StudentAnswered;

SELECT * From Result ORDER BY sID, qID;
