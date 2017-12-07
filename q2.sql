SET search_path TO quizschema;

DROP VIEW IF EXISTS MCquestion CASCADE;
DROP VIEW IF EXISTS NUMquestion CASCADE;
DROP VIEW IF EXISTS TFquestion CASCADE;
DROP VIEW IF EXISTS Result CASCADE;


CREATE VIEW MCquestion AS
SELECT Question_Bank.qID AS Question_ID, Question_Bank.Question AS Question_test,
COUNT(MC_wrong_answer.hint) AS Num_Hints
FROM Question_Bank NATURAL JOIN MC_wrong_answer
WHERE Question_Bank.Qtype = 'MC'
GROUP BY Question_Bank.qID, Question_Bank.Question;

CREATE VIEW NUMquestion AS
SELECT Question_Bank.qID AS Question_ID, Question_Bank.Question AS Question_test,
COUNT(NUM_wrong_answer.hint) AS Num_Hints
FROM Question_Bank NATURAL JOIN NUM_wrong_answer
WHERE Question_Bank.Qtype = 'NUM'
GROUP BY Question_Bank.qID, Question_Bank.Question;

CREATE VIEW TFquestion AS
SELECT Question_Bank.qID AS Question_ID, Question_Bank.Question AS Question_test
FROM Question_Bank NATURAL JOIN TF_answer
WHERE Question_Bank.Qtype = 'TF'
GROUP BY Question_Bank.qID, Question_Bank.Question;

CREATE VIEW Result AS
SELECT * FROM MCquestion
UNION
SELECT * FROM NUMquestion
UNION
SELECT *, NULL as Num_Hints FROM TFquestion;

SELECT * FROM Result ORDER BY Question_ID;
