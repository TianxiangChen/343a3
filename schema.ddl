--------------------------------------------------------------------------------
---------------------------- Preliminary questions: ----------------------------
--------------------------------------------------------------------------------
---- What constraints from the domain could not be enforced?
--
--------------------------------------------------------------------------------
---- What constraints that could have been enforced were not enforced? Why not?
--
--------------------------------------------------------------------------------

DROP SCHEMA IF EXISTS quizschema cascade;
CREATE SCHEMA quizschema;
SET search_path to quizschema;

CREATE TABLE Student(
	sID INTEGER NOT NULL,
	FirstName VARCHAR(15) NOT NULL,
	SurName VARCHAR(15) NOT NULL,
  PRIMARY KEY (sID),
	CONSTRAINT valid_sID
      CHECK (1000000000 <= sID and siD < 10000000000) --changed from sID <= 10000000000
);

-- One room can only have one teacher
CREATE TABLE Room(
  Room VARCHAR(15) NOT NULL,
  Teacher VARCHAR(15) NOT NULL,
  PRIMARY KEY (Room)
);

-- cID is a newly created primary key which is not good
-- I didnt conser each class need one or more students
-- Not srue what type Grade should be, in handout is "Grade 5" a string
--string
CREATE TABLE Class(
  cID INTEGER NOT NULL,
  Room VARCHAR(15) NOT NULL,
  Grade VARCHAR(10) NOT NULL,
  PRIMARY KEY (cID),
  FOREIGN KEY (Room) REFERENCES Room
);

-- Record which class the students are in
CREATE TABLE TakingClass(
  sID INTEGER REFERENCES Student(sID),
  cID INTEGER REFERENCES Class(cID),
  PRIMARY KEY(cID, sID) --changed from PRIMARY KEY(cID)
);

-- Defind the question type as T/F, Multiple Choice and Numerical
CREATE TYPE Question_type AS ENUM(
	'TF', 'MC','NUM');

CREATE TABLE Question_Bank(
  qID INTEGER NOT NULL,
  Qtype Question_type NOT NULL,
  Question VARCHAR(255) NOT NULL,
  PRIMARY KEY (qID)
);

CREATE TABLE TF_answer(
  qID INTEGER REFERENCES Question_Bank(qID),
  tf_answer VARCHAR(5) CHECK (tf_answer = 'True' or tf_answer = 'False') NOT NULL,
  PRIMARY KEY(qID)
);

CREATE TABLE MC_answer(
  qID INTEGER REFERENCES Question_Bank(qID),
  Correct_answer VARCHAR(255) NOT NULL,
  PRIMARY KEY(qID)
);

-- We placed wrong_answer in another talbe thus saving a hint space
-- for each question in the correct answer positon
CREATE TABLE MC_wrong_answer(
  qID INTEGER REFERENCES MC_answer(qID),
  aID INTEGER NOT NULL,
  wrong_answer VARCHAR(255) NOT NULL,
  hint VARCHAR(255),
  PRIMARY KEY(qID, aID)
);


CREATE TABLE NUM_answer(
  qID INTEGER REFERENCES Question_Bank(qID),
  Correct_answer VARCHAR(255) NOT NULL,
  PRIMARY KEY(qID)
);

CREATE TABLE NUM_wrong_answer(
  qID INTEGER REFERENCES NUM_answer(qID),
  Lower_bound INT NOT NULL,
  Upper_bound INT CHECK (Upper_bound > Lower_bound) NOT NULL,
	-- not sure the synax above is correct or not
    --correct
  hint VARCHAR(255),
  PRIMARY KEY(qID, Lower_bound, Upper_bound)
);


CREATE TABLE Quiz(
  quizID INTEGER NOT NULL,
  Title VARCHAR(50) NOT NULL,
  Class INTEGER REFERENCES Class(cID),
  DueBy TIMESTAMP NOT NULL,
  hint_allowed BOOLEAN NOT NULL,
  PRIMARY KEY(quizID)
);

-- Same quetion in different quiz could have different weight
CREATE TABLE QuizQuestion(
  quizID INTEGER REFERENCES Quiz(quizID),
  questionID INT REFERENCES Question_Bank(qID),
  weight INTEGER NOT NULL,
  PRIMARY KEY(quizID, questionID)
);

-- Need a double reference for student and answered
-- Since student need belong to the class taking that question,
-- same applies to answered
CREATE TABLE Response(
  quizID INTEGER REFERENCES Quiz(quizID),
  sID INTEGER REFERENCES Student(sID),
  answered INTEGER REFERENCES Question_Bank(qID),
  PRIMARY KEY(quizID, sID)
);
