CREATE DATABASE CollegeMIS;
USE CollegeMIS;

CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    Gender CHAR(1),
    DOB DATE,
    DepartmentID INT,
    Email VARCHAR(100),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE Enrollment (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    Semester VARCHAR(10),
    Marks INT,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);


INSERT INTO Department VALUES (1, 'Computer Science'), (2, 'IT'), (3, 'Electronics');

INSERT INTO Student VALUES 
(101, 'Amir', 'F', '2002-04-12', 1, 'amir@gmail.com'),
(102, 'Babal', 'M', '2001-06-30', 2, 'baaaa@yahoo.com'),
(103, 'Champa', 'M', '2000-12-25', 1, 'chaam@gmail.com'),
(104, 'Dhanush', 'F', '2002-09-15', 3, 'dhanush@gmail.com');

INSERT INTO Course VALUES 
(201, 'Data Structures', 1),
(202, 'DBMS', 1),
(203, 'Computer Networks', 2),
(204, 'Digital Electronics', 3),
(205, 'OOP', 2);

INSERT INTO Enrollment VALUES 
(1, 101, 201, 'Sem1', 90),
(2, 101, 202, 'Sem2', 88),
(3, 102, 203, 'Sem1', 76),
(4, 103, 201, 'Sem1', 84),
(5, 103, 202, 'Sem2', 91),
(6, 104, 204, 'Sem1', 70);


SELECT S.StudentID, S.Name, D.DeptName
FROM Student S
JOIN Department D ON S.DepartmentID = D.DepartmentID;

SELECT CourseName 
FROM Course C
JOIN Department D ON C.DepartmentID = D.DepartmentID
WHERE D.DeptName = 'Computer Science';

SELECT DISTINCT S.Name
FROM Student S
JOIN Enrollment E ON S.StudentID = E.StudentID
JOIN Course C ON E.CourseID = C.CourseID
WHERE C.CourseName = 'Data Structures';

SELECT D.DeptName, COUNT(S.StudentID) AS StudentCount
FROM Department D
LEFT JOIN Student S ON D.DepartmentID = S.DepartmentID
GROUP BY D.DeptName;

SELECT DISTINCT S.Name, E.Marks
FROM Student S
JOIN Enrollment E ON S.StudentID = E.StudentID
WHERE E.Marks > 80;

SELECT C.CourseName, AVG(E.Marks) AS AverageMarks
FROM Course C
JOIN Enrollment E ON C.CourseID = E.CourseID
GROUP BY C.CourseName;

SELECT S.Name
FROM Student S
LEFT JOIN Enrollment E ON S.StudentID = E.StudentID
WHERE E.EnrollmentID IS NULL;

SELECT C.CourseName, COUNT(E.StudentID) AS EnrolledStudents
FROM Course C
LEFT JOIN Enrollment E ON C.CourseID = E.CourseID
GROUP BY C.CourseName;

SELECT S.StudentID, S.Name, E.Marks
FROM Student S
JOIN Enrollment E ON S.StudentID = E.StudentID
JOIN Course C ON E.CourseID = C.CourseID
WHERE C.CourseName = 'DBMS'
  AND E.Marks = (
      SELECT MAX(E2.Marks)
      FROM Enrollment E2
      JOIN Course C2 ON E2.CourseID = C2.CourseID
      WHERE C2.CourseName = 'DBMS'
  );


UPDATE Student
SET DepartmentID = 2
WHERE StudentID = 104;

SELECT name 
FROM sys.foreign_keys 
WHERE parent_object_id = OBJECT_ID('Enrollment');
-- Step 1: Drop the existing foreign key constraint
ALTER TABLE Enrollment
DROP CONSTRAINT FK_Enrollment_Course;  -- Make sure this name is correct
-- Step 2: Recreate the foreign key with ON DELETE CASCADE
ALTER TABLE Enrollment
ADD CONSTRAINT FK_Enrollment_Course
FOREIGN KEY (CourseID)
REFERENCES Course(CourseID)
ON DELETE CASCADE;
-- Step 3: Delete the course, enrollments will be deleted automatically
DELETE FROM Course
WHERE CourseName = 'OOP';




SELECT D.DeptName, COUNT(C.CourseID) AS CourseCount
FROM Department D
JOIN Course C ON D.DepartmentID = C.DepartmentID
GROUP BY D.DeptName
HAVING COUNT(C.CourseID) > 3;

SELECT S.Name, COUNT(E.CourseID) AS TotalCourses
FROM Student S
JOIN Enrollment E ON S.StudentID = E.StudentID
GROUP BY S.Name;

CREATE VIEW TopPerformers AS
SELECT S.StudentID, S.Name, AVG(E.Marks) AS AvgMarks
FROM Student S
JOIN Enrollment E ON S.StudentID = E.StudentID
GROUP BY S.StudentID, S.Name
HAVING AVG(E.Marks) > 85;

CREATE VIEW StudentDetails AS
SELECT S.StudentID, S.Name, D.DeptName AS Department, S.Email
FROM Student S
JOIN Department D ON S.DepartmentID = D.DepartmentID;

SELECT S.Name AS StudentName, C.CourseName, E.Marks
FROM Enrollment E
JOIN Student S ON E.StudentID = S.StudentID
JOIN Course C ON E.CourseID = C.CourseID;

SELECT S.Name
FROM Student S
JOIN Enrollment E ON S.StudentID = E.StudentID
JOIN Course C ON E.CourseID = C.CourseID
GROUP BY S.StudentID, S.Name
HAVING COUNT(DISTINCT C.DepartmentID) > 1;

SELECT DeptName
FROM Department D
LEFT JOIN Student S ON D.DepartmentID = S.DepartmentID
WHERE S.StudentID IS NULL;

EXEC sp_rename 'Student.DOB', 'DateOfBirth', 'COLUMN';

SELECT S.Name
FROM Student S
JOIN Enrollment E ON S.StudentID = E.StudentID
JOIN Course C ON E.CourseID = C.CourseID
JOIN Department D ON S.DepartmentID = D.DepartmentID
WHERE D.DeptName = 'IT' AND C.CourseName = 'Computer Networks';

SELECT Name, Email
FROM Student
WHERE Email LIKE '%@gmail.com';

SELECT S.Name, E.Marks
FROM Student S
JOIN Enrollment E ON S.StudentID = E.StudentID
WHERE E.Marks > (SELECT AVG(Marks) FROM Enrollment);

SELECT C.CourseName, AVG(E.Marks) AS AvgMarks
FROM Course C
JOIN Enrollment E ON C.CourseID = E.CourseID
GROUP BY C.CourseName;

SELECT S.Name AS StudentName, C.CourseName, E.Marks
FROM Student S
JOIN Enrollment E ON S.StudentID = E.StudentID
JOIN Course C ON E.CourseID = C.CourseID
ORDER BY E.Marks DESC;




