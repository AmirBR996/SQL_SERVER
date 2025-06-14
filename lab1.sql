CREATE DATABASE LAB1
USE LAB1
CREATE TABLE Student  
( 
StudentID INT PRIMARY KEY, 
SName VARCHAR(50),         
Gender CHAR(1),            
Age INT, 
Class VARCHAR(20), 
Marks INT, 
Email VARCHAR(100),        
Address VARCHAR(255)       
); 
INSERT INTO Student (StudentID, SName, Gender, Age, Class, Marks, Email, Address) VALUES
(1, 'Sita Sharma', 'F', 19, 'BSc CSIT', 78, 'sita.sharma@gmail.com', 'Kathmandu'),
(2, 'Ram Thapa', 'M', 20, 'BSc CSIT', 85, 'ram.thapa@gmail.com', 'Pokhara'),
(3, 'Gita Neupane', 'F', 18, 'BCA', 90, 'gita.neupane@gmail.com', 'Butwal'),
(4, 'Hari Poudel', 'M', 21, 'BIM', 70, 'hari.poudel@gmail.com', 'Biratnagar'),
(5, 'Sunita Karki', 'F', 22, 'BSc CSIT', 65, 'sunita.karki@gmail.com', 'Dharan'),
(6, 'Raju Basnet', 'M', 23, 'BCA', 82, 'raju.basnet@gmail.com', 'Hetauda'),
(7, 'Meena Bhandari', 'F', 20, 'BIM', 88, 'meena.bhandari@gmail.com', 'Bhaktapur'),
(8, 'Kishor Rai', 'M', 19, 'BSc CSIT', 77, 'kishor.rai@gmail.com', 'Lalitpur'),
(9, 'Anju Adhikari', 'F', 21, 'BCA', 91, 'anju.adhikari@gmail.com', 'Janakpur'),
(10, 'Bikash Lama', 'M', 18, 'BIM', 74, 'bikash.lama@gmail.com', 'Banepa'),
(11, 'Pooja Maharjan', 'F', 20, 'BSc CSIT', 83, 'pooja.maharjan@gmail.com', 'Patan'),
(12, 'Dipesh Shrestha', 'M', 22, 'BCA', 76, 'dipesh.shrestha@gmail.com', 'Kirtipur'),
(13, 'Sarita Khadka', 'F', 19, 'BIM', 79, 'sarita.khadka@gmail.com', 'Tulsipur'),
(14, 'Manish Bhattarai', 'M', 21, 'BSc CSIT', 87, 'manish.bhattarai@gmail.com', 'Itahari'),
(15, 'Rita Tamang', 'F', 20, 'BCA', 68, 'rita.tamang@gmail.com', 'Chitwan');
SELECT * 
FROM student;

SELECT SName, Email,Marks 
FROM Student

SELECT *
FROM Student
WHERE Address = 'Chitwan';

UPDATE Student
SET Address = 'Kathmandu'
WHERE StudentID = 3;

SELECT *
FROM Student
WHERE Marks > 80 and Age < 20

SELECT COUNT(*) AS YahooEmailCount
FROM Student
WHERE Email LIKE '%@yahoo.com';

SELECT * 
FROM Student 
WHERE Email IS NULL;

SELECT * 
FROM Student 
ORDER BY SName ASC;

SELECT Class, MAX(Marks) AS HighestMarks
FROM Student
GROUP BY Class;

DELETE FROM Student
WHERE Address IS NULL OR Address = ''; 

ALTER TABLE Student
ADD PhoneNumber VARCHAR(15);

CREATE VIEW ContactList AS
SELECT SName, Email, PhoneNumber
FROM Student;

SELECT * FROM ContactList;

SELECT * 
FROM Student
WHERE  LEFT(SName, CHARINDEX(' ', SName + ' ') - 1) LIKE 'R%a';

SELECT Address, COUNT(*) AS Num_Students
FROM Student
GROUP BY Address;

SELECT Gender, COUNT(*) AS Count
FROM Student
GROUP BY Gender;

CREATE TRIGGER trg_PreventEmailUpdate
ON Student
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN deleted d ON i.StudentID = d.StudentID
        WHERE i.Email <> d.Email
    )
    BEGIN
        RAISERROR('Email update is not allowed once entered.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

SELECT S1.StudentID, S1.SName, S1.Address
  FROM Student S1
 JOIN Student S2 
  	 ON S1.Address = S2.Address 
 AND S1.SName <> S2.SName
 	 AND S1.StudentID <> S2.StudentID
 ORDER BY S1.Address;

 EXEC sp_rename 'Student.Marks', 'TotalMarks', 'COLUMN';