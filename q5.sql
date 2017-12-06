SET search_path TO quizschema;

DROP VIEW IF EXISTS Questions CASCADE;
DROP VIEW IF EXISTS AnsweredCount CASCADE;
DROP VIEW IF EXISTS StudentsInQuiz CASCADE;
DROP VIEW IF EXISTS CorrectAnswer CASCADE;

CREATE VIEW Questions AS
SELECT Question_Bank.qID AS qID
FROM QuizQuestion NATURAL JOIN Quiz NATURAL JOIN TakingClass NATURAL JOIN Class
WHERE Quiz.quizID = "Pr1-220310" AND  Class.Grade = "8"
AND Class.Room = "120" AND Room.Teacher = "Mr Higgins";

CREATE VIEW StudentInQuiz AS
SELECT Student.sID AS sID
FROM Quiz NATURAL JOIN TakingClass NATURAL JOIN Class
NATURAL JOIN Room NATURAL JOIN Student
WHERE Quiz.quizID = "Pr1-220310" AND  Class.Grade = "8"
AND Class.Room = "120" AND Room.Teacher = "Mr Higgins"
GROUP BY Student.sID, Student.FirstName, Student.SurName;

CREATE VIEW CorrectAnswer AS
SELECT qID, Question, tf_answer AS answer
FROM Question_Bank NATURAL JOIN TF_answer
UNION
SELECT qID, Question, Correct_answer AS answer
FROM Question_Bank NATURAL JOIN MC_answer
UNION
SELECT qID, Question, CAST(Correct_answer AS VARCHAR(20)) AS answer
FROM Question_Bank NATURAL JOIN NUM_answer;

CREATE VIEW AnsweredCount AS
SELECT Questions.qID as qID, count(Response.answer = CorrectAnswer.answer) as correct, count (Response.answer <> CorrectAnswer.answer) as incorrect
FROM Response NATURAL JOIN Questions NATURAL JOIN StudentInQuiz NATURAL JOIN CorrectAnswer
GROUP BY Questions.qID;


SELECT qID, correct, incorrect, total - correct - incorrect as no_answer
FROM AnsweredCount, (count(*) as total FROM StudentInQuiz) num_students;
