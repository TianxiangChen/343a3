--------------------------------------------------------------------------------
---------------------------- Preliminary questions: ----------------------------
--------------------------------------------------------------------------------
---- What constraints from the domain could not be enforced?
----
---- All of the constraints are enforceable, although some would make the schema
---- harder to use if enforced due to added complexity.
----
--------------------------------------------------------------------------------
---- What constraints that could have been enforced were not enforced? Why not?
----
---- Each Class must have one or more students.
---- We can do this by creating a larger table which contains the class info
---- with the sID, the student who is taken it. Each row will be one (cID, sID, ClassInfo)
---- By doing this we will create a lot of redundant data of class info so we chose not to do it.
---- 
---- The constraints that all questions have one correct answer, all multiple choice 
---- questions have at least one wrong answer and all quizes have at least one question 
---- are ignored for similar reasons to the constraint that all classes have at least one student. 
---- These constraints may be enforced through the creation of new cumbersome attributes and tables, 
---- however we feel these would complicate the usage of the schema more than they are worth. 
---- 
---- For example, we could add three new id attributes for each different question type to each 
---- Question_Bank entry where two are null and the last is not, enforced by check constraints comparing
---- with the question's type. For a T/F question, the new TF_id is a unique nullable foreign key
---- referencing a new id attribute in the TF_answer table. These two keys would circularly reference eachother,
---- ensuring that all TF questions have one answer. New id attributes in the other two correct answer tables
---- would accomplish the same goal for the other question types, ensuring all question have one answer.
---- 
--------------------------------------------------------------------------------

DROP SCHEMA IF EXISTS quizschema cascade;
CREATE SCHEMA quizschema;
SET search_path to quizschema;

-- A table storing Student Info: sID, FirstName and SurName
-- As required, the sID is forced to be a 10-digit number
CREATE TABLE Student(
	sID BIGINT,
	FirstName VARCHAR(15) NOT NULL,
	SurName VARCHAR(15) NOT NULL,
  PRIMARY KEY (sID),
	CONSTRAINT valid_sID
      CHECK (siD < 10000000000)
);

-- Since one room can only have one teacher,
-- we create a Room table.
CREATE TABLE Room(
  Room VARCHAR(15),
  Teacher VARCHAR(15) NOT NULL,
  PRIMARY KEY (Room)
);

-- Having new key cID saves space in other tables
CREATE TABLE Class(
  cID INTEGER NOT NULL,
  Room VARCHAR(15) NOT NULL,
  Grade VARCHAR(10) NOT NULL,
  PRIMARY KEY (cID),
  FOREIGN KEY (Room) REFERENCES Room
);

-- Record which classes the students are in
CREATE TABLE TakingClass(
  sID BIGINT REFERENCES Student(sID),
  cID INTEGER REFERENCES Class(cID),
  PRIMARY KEY(cID, sID)
);

-- Define the question type as T/F, Multiple Choice or Numerical
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

-- A table for correct T/F answers
CREATE TABLE TF_answer(
  qID INTEGER REFERENCES Question_Bank(qID),
  tf_answer VARCHAR(5) CHECK (tf_answer = 'True' or tf_answer = 'False') NOT NULL,
  PRIMARY KEY(qID)
);

-- A table for correct multiple choice answers
CREATE TABLE MC_answer(
  qID INTEGER REFERENCES Question_Bank(qID),
  Correct_answer VARCHAR(255) NOT NULL,
  PRIMARY KEY(qID)
);

-- A table for wrong multiple choice answers
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

-- Records all info required for a quiz
CREATE TABLE Quiz(
  quizID VARCHAR(20) NOT NULL,
  Title VARCHAR(50) NOT NULL,
  Class INTEGER REFERENCES Class(cID) NOT NULL,
  DueBy TIMESTAMP NOT NULL,
  hint_allowed BOOLEAN NOT NULL,
  PRIMARY KEY(quizID),
  UNIQUE (quizID, Class)
);

-- Table contains what questions belong to what quiz
-- Same question in different quiz could have different weight
CREATE TABLE QuizQuestion(
  quizID VARCHAR(20) REFERENCES Quiz(quizID),
  questionID INT REFERENCES Question_Bank(qID),
  weight INTEGER NOT NULL,
  PRIMARY KEY(quizID, questionID)
);

-- Stores a student's response for a question in a quiz
-- for a class they are in
CREATE TABLE Response(
  quizID VARCHAR(20) REFERENCES Quiz(quizID),
  sID BIGINT REFERENCES Student(sID),
  cID INTEGER REFERENCES Class(cID) NOT NULL,
  answered INTEGER REFERENCES Question_Bank(qID),
  answer VARCHAR(255) NOT NULL, --Student may answer anything,
	-- for example, 1+1=?. a numerical question, but student can answer "apple" in real case
  PRIMARY KEY(quizID, sID, answered),
  FOREIGN KEY (answered, quizID) REFERENCES QuizQuestion(questionID, quizID),
  FOREIGN KEY (sID, cID) REFERENCES TakingClass(sID, cID),
  FOREIGN KEY (quizID, cID) REFERENCES Quiz(quizID, Class)
);
