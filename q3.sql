SET search_path TO quizschema;

DROP VIEW IF EXISTS StudentInQuiz CASCADE;
DROP VIEW IF EXISTS QuizTotalScore CASCADE;
DROP VIEW IF EXISTS StudentMark CASCADE;


CREATE VIEW StudentInQuiz AS
SELECT Student.sID AS sID,
CONCAT(Student.FirstName,' ',Student.SurName) AS FullName,
FROM Quiz NATURAL JOIN TakingClass NATURAL JOIN Class
NATURAL JOIN Room NATURAL JOIN Student,
WHERE Quiz.quizID = "Pr1-220310" AND  Class.Grade = "grade 8"
AND Class.Room = "room 12s0" AND Room.Teacher = "Mr Higgins"
GROUP BY Student.sID, Student.FirstName, Student.SurName;

CREATE VIEW QuizTotalScore AS
SELECT SUM(weight) AS TotalScore
FROM QuizQuestion
WHERE quizID = "Pr1-220310"
GROUP BY quizID;

CREATE VIEW StudentMark AS
SELECT StudentInQuiz.sID AS Student_Number, StudentInQuiz.FullName AS FullName,
SUM(QuizQuestion.weight) AS Grade
FROM StudentInQuiz NATURAL JOIN Response NATURAL JOIN QuizQuestion
WHERE Response.quizID = "Pr1-220310" AND Response.answered = QuizQuestion.questionID
GROUP BY StudentInQuiz.sID, StudentInQuiz.FullName;

SELECT *
FROM StudentMark NATURAL JOIN QuizTotalScore;
