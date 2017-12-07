--------------------------------------------------------------------------------
---------------------------- Preliminary questions: ----------------------------
--------------------------------------------------------------------------------
---- What constraints from the domain could not be enforced?
--
--------------------------------------------------------------------------------
---- What constraints that could have been enforced were not enforced? Why not?
--   Each Class must have one or more students.
---- We can do this by creating a larger table which contains the class info
---- with the sID, the stduent who is taken it. Each row will be one (cID, sID, ClassInfo)
---- By doing this we will create a lot of redudent data of class info so we chose not to do it.
--------------------------------------------------------------------------------

DROP SCHEMA IF EXISTS quizschema cascade;
CREATE SCHEMA quizschema;
SET search_path to quizschema;

-- A table storing Student Info: sID, FirstName and SurName
-- As required, the sID is forced to be a 10-digit number
CREATE TABLE Student(
	sID BIGINT NOT NULL,
	FirstName VARCHAR(15) NOT NULL,
	SurName VARCHAR(15) NOT NULL,
  PRIMARY KEY (sID),
	CONSTRAINT valid_sID
      CHECK (siD < 10000000000)
);


-- Since one room can only have one teacher,
-- we create a Room table.
CREATE TABLE Room(
  Room VARCHAR(15) NOT NULL,
  Teacher VARCHAR(15) NOT NULL,
  PRIMARY KEY (Room)
);

-- I didnt conser each class need one or more students
-- Having new key saves space in other tables
CREATE TABLE Class(
  cID INTEGER NOT NULL,
  Room VARCHAR(15) NOT NULL,
  Grade VARCHAR(10) NOT NULL,
  PRIMARY KEY (cID),
  FOREIGN KEY (Room) REFERENCES Room
);

-- Record which class the students are in
CREATE TABLE TakingClass(
  sID BIGINT REFERENCES Student(sID),
  cID INTEGER REFERENCES Class(cID),
  PRIMARY KEY(cID, sID)
);

-- Defind the question type as T/F, Multiple Choice and Numerical
CREATE TYPE Question_type AS ENUM(
	'TF', 'MC','NUM');

-- Record the basic info of questions
-- The info here is what every question has regradless its type
CREATE TABLE Question_Bank(
  qID INTEGER NOT NULL,
  Qtype Question_type NOT NULL,
  Question VARCHAR(255) NOT NULL,
  PRIMARY KEY (qID)
);

-- A table for correct T/F answer
CREATE TABLE TF_answer(
  qID INTEGER REFERENCES Question_Bank(qID),
  tf_answer VARCHAR(5) CHECK (tf_answer = 'True' or tf_answer = 'False') NOT NULL,
  PRIMARY KEY(qID)
);

-- A table for correct multiple choices answers
CREATE TABLE MC_answer(
  qID INTEGER REFERENCES Question_Bank(qID),
  Correct_answer VARCHAR(255) NOT NULL,
  PRIMARY KEY(qID)
);

-- A table for wrong multiple choices answers
-- We placed wrong_answer in another talbe thus saving a hint space
-- for each question in the correct answer positon
CREATE TABLE MC_wrong_answer(
  qID INTEGER REFERENCES MC_answer(qID),
  aID INTEGER NOT NULL,
  wrong_answer VARCHAR(255) NOT NULL,
  hint VARCHAR(255),
  PRIMARY KEY(qID, aID)
);

-- A table for correct numerical question answers
CREATE TABLE NUM_answer(
  qID INTEGER REFERENCES Question_Bank(qID),
  Correct_answer VARCHAR(255) NOT NULL,
  PRIMARY KEY(qID)
);

-- A table for wrong numerical question answers
CREATE TABLE NUM_wrong_answer(
  qID INTEGER REFERENCES NUM_answer(qID),
  Lower_bound INT NOT NULL,
  Upper_bound INT CHECK (Upper_bound > Lower_bound) NOT NULL,
  hint VARCHAR(255),
  PRIMARY KEY(qID, Lower_bound, Upper_bound)
);


-- A table records all info required for a quiz
CREATE TABLE Quiz(
  quizID VARCHAR(20) NOT NULL, --According to query 3 it can be string
  Title VARCHAR(50) NOT NULL,
  Class INTEGER REFERENCES Class(cID),
  DueBy TIMESTAMP NOT NULL,
  hint_allowed BOOLEAN NOT NULL,
  PRIMARY KEY(quizID)
);

-- Table contains what questions belong to what quiz
-- Same quetion in different quiz could have different weight
CREATE TABLE QuizQuestion(
  quizID VARCHAR(20) REFERENCES Quiz(quizID),
  questionID INT REFERENCES Question_Bank(qID),
  weight INTEGER NOT NULL,
  PRIMARY KEY(quizID, questionID)
);

-- Need a double reference for student and answered
-- Since student need belong to the class taking that question,
-- same applies to answered
CREATE TABLE Response(
  quizID VARCHAR(20) REFERENCES Quiz(quizID),
  sID BIGINT REFERENCES Student(sID),
  answered INTEGER REFERENCES Question_Bank(qID),
  answer VARCHAR(255) NOT NULL, --Student may answer anything,
	-- for example, 1+1=?. a numerical question, but student can answer "apple" in real case
  PRIMARY KEY(quizID, sID, answered)
);
