--- View Tables
USE [BVC Practice];
SELECT * FROM StudentGrade;
SELECT * FROM Scores;

--- Rename Table, Columns
EXEC sp_rename 'gradeRecordModuleV','StudentGrade';
EXEC sp_rename 'StudentGrade.studentID','student_ID','COLUMN';
EXEC sp_rename 'StudentGrade.First_name','first_name','COLUMN';
EXEC sp_rename 'StudentGrade.Lastname','last_name','COLUMN';
EXEC sp_rename 'StudentGrade.Midtermexam','midterm_exam','COLUMN';
EXEC sp_rename 'StudentGrade.Finalexam','final_exam','COLUMN';

------------------------------------------------1NF----------------------------------------------
--- Columns Totalpoints and Studentaverage are redundant so dropping them
ALTER TABLE StudentGrade
DROP COLUMN Totalpoints;

ALTER TABLE StudentGrade
DROP COLUMN Studentaverage;

--- Checking for duplicates in studentID
SELECT student_ID, COUNT(*) FROM StudentGrade
GROUP BY student_ID HAVING COUNT(*) >1;

--- There were 3 duplicates. Checking if they are duplicates
SELECT * FROM StudentGrade
WHERE student_ID = 35932 OR student_ID = 47058 OR student_ID = 64698
ORDER BY student_ID;

--- Since ID not duplicates, looking into seeing if substitute studentIDs are already in data set.
SELECT * FROM StudentGrade
WHERE student_ID = 35933 OR student_ID = 47059 OR student_ID = 64699
ORDER BY student_ID;

--Updating Student IDs
UPDATE StudentGrade
SET student_ID = 35933
WHERE student_ID = 35932 AND first_name = 'Tallulah';

UPDATE StudentGrade
SET student_ID = 47059
WHERE student_ID = 47058 AND first_name = 'Jaye';

UPDATE StudentGrade
SET student_ID = 64699
WHERE student_ID = 64698 AND first_name = 'Claudian';

---------------------------------------------------------2NF--------------------------------------------

--- In order to deal with partial dependency, will split table into 3 parts - StudentName, Scores and Grades

--- Creating Tables
SELECT student_ID, first_name, last_name
INTO StudentName FROM StudentGrade;

SELECT student_ID, midterm_exam, final_exam, assignment1, assignment2
INTO Scores FROM StudentGrade;

--- Creating Primary and Foreign Keys
ALTER TABLE StudentName
ADD PRIMARY KEY (student_ID);

ALTER TABLE Scores
ADD score_ID int IDENTITY(101,1);

ALTER TABLE Scores
ADD PRIMARY KEY (score_ID);

ALTER TABLE Scores
ADD FOREIGN KEY (student_ID) REFERENCES StudentName(student_ID);