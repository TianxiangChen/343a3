SET search_path TO quizschema;

DROP VIEW IF EXISTS StudentInQuiz CASCADE;
DROP VIEW IF EXISTS QuizTotalScore CASCADE;
DROP VIEW IF EXISTS StudentMark CASCADE;
DROP VIEW IF EXISTS CorrectAnswer CASCADE;

CREATE VIEW StudentInQuiz AS
SELECT Student.sID AS sID,
CONCAT(Student.FirstName,' ',Student.SurName) AS FullName
FROM Quiz NATURAL JOIN TakingClass NATURAL JOIN Class
NATURAL JOIN Room NATURAL JOIN Student
WHERE Quiz.quizID = 'Pr1-220310' AND  Class.Grade = '8'
AND Class.Room = '120' AND Room.Teacher = 'Mr Higgins'
GROUP BY Student.sID, Student.FirstName, Student.SurName;

CREATE VIEW QuizTotalScore AS
SELECT SUM(weight) AS TotalScore
FROM QuizQuestion
WHERE quizID = 'Pr1-220310'
GROUP BY quizID;

CREATE VIEW CorrectAnswer AS
SELECT qID, Question, tf_answer AS answer
FROM Question_Bank NATURAL JOIN TF_answer
UNION
SELECT qID, Question, Correct_answer AS answer
FROM Question_Bank NATURAL JOIN MC_answer
UNION
SELECT qID, Question, CAST(Correct_answer AS VARCHAR(20)) AS answer
FROM Question_Bank NATURAL JOIN NUM_answer;

CREATE VIEW StudentMark AS
SELECT StudentInQuiz.sID AS Student_Number, StudentInQuiz.FullName AS FullName,
SUM(QuizQuestion.weight) AS Grade
FROM StudentInQuiz LEFT JOIN Response NATURAL JOIN QuizQuestion NATURAL JOIN CorrectAnswer -- Change to left join since student can answer nothing for a quiz
WHERE Response.quizID = 'Pr1-220310' AND Response.answered = QuizQuestion.questionID AND Response.answer = CorrectAnswer.answer
GROUP BY StudentInQuiz.sID, StudentInQuiz.FullName;

SELECT *
FROM StudentMark NATURAL JOIN QuizTotalScore;
