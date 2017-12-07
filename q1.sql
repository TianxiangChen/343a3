SET search_path TO quizschema;

SELECT CONCAT(FirstName,' ',SurName) AS Fullname, sID AS Student_Number
FROM Student
ORDER BY Student_Number;
