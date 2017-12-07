SET search_path TO quizschema;

DROP VIEW IF EXISTS Questions CASCADE;
DROP VIEW IF EXISTS StudentInQuiz CASCADE;
DROP VIEW IF EXISTS CorrectAnswer CASCADE;
DROP VIEW IF EXISTS CorrectAnsweredCount CASCADE;
DROP VIEW IF EXISTS WrongAnswer CASCADE;
DROP VIEW IF EXISTS WrongAnsweredCount CASCADE;
DROP VIEW IF EXISTS NotAnswered CASCADE;
DROP VIEW IF EXISTS NotAnsweredCount CASCADE;
DROP VIEW IF EXISTS Result CASCADE;

CREATE VIEW Questions AS
SELECT DISTINCT QuizQuestion.questionID AS qID
FROM QuizQuestion NATURAL JOIN Quiz
WHERE Quiz.quizID ='Pr1-220310';

CREATE VIEW StudentInQuiz AS
SELECT Student.sID AS sID
FROM Quiz NATURAL JOIN TakingClass NATURAL JOIN Class
NATURAL JOIN Room NATURAL JOIN Student
WHERE Quiz.quizID = 'Pr1-220310' AND  Class.Grade = 'grade 8'
AND Class.Room = 'room 120' AND Room.Teacher = 'Mr Higgins'
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

CREATE VIEW CorrectAnsweredCount AS
SELECT Questions.qID AS qID,  COUNT(*) AS Correct
FROM Response JOIN Questions ON Response.answered = Questions.qID NATURAL JOIN StudentInQuiz NATURAL JOIN CorrectAnswer
GROUP BY Questions.qID;

-- Record every questions' wrong answers
CREATE VIEW WrongAnswer AS
SELECT Questions.qID AS qID, Response.answer AS Answers
FROM Response JOIN Questions ON Response.answered = Questions.qID NATURAL JOIN StudentInQuiz
GROUP BY Questions.qID, Response.answer
EXCEPT
SELECT Questions.qID AS qID, Response.answer AS Answers
FROM Response JOIN Questions ON Response.answered = Questions.qID NATURAL JOIN StudentInQuiz NATURAL JOIN CorrectAnswer
GROUP BY Questions.qID, Response.answer;

CREATE VIEW WrongAnsweredCount AS
SELECT qID, count(*) AS Incorrect
FROM WrongAnswer
GROUP BY qID;

-- Record for every question, who didnt answer it
CREATE VIEW NotAnswered AS
SELECT QuizQuestion.questionID AS qID, StudentInQuiz.sID AS sID
FROM  QuizQuestion NATURAL JOIN StudentInQuiz
WHERE QuizQuestion.quizID = 'Pr1-220310'
GROUP BY QuizQuestion.questionID, StudentInQuiz.sID
EXCEPT
SELECT Response.answered AS qID, Response.sID AS sID
FROM Response NATURAL JOIN StudentInQuiz
GROUP BY Response.answered, Response.sID;

CREATE VIEW NotAnsweredCount AS
SELECT qID, count(*) AS Not_Answered
FROM NotAnswered
GROUP BY qID;

CREATE VIEW Result AS
SELECT *
FROM CorrectAnsweredCount NATURAL JOIN WrongAnsweredCount NATURAL JOIN NotAnsweredCount;

SELECT * FROM Result ORDER BY qID;
