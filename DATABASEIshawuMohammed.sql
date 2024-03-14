--- ISHAWU MOHAMMED

CREATE TABLE Programme(
PID VARCHAR(40) PRIMARY KEY,
P_Name VARCHAR(40),
Amount_To_Pay INT,
Department VARCHAR(40)
);

SELECT * FROM Programme;
INSERT INTO Programme VALUES ('BSCA', 'Bsc Agric', 2000, 'Agric Science');
INSERT INTO Programme VALUES ('SSOA', 'Ba Social Science', 1800, 'Humanities');
INSERT INTO Programme VALUES ('AACA', 'Ba Accounting', 2500, 'Finance');
INSERT INTO Programme VALUES ('BACE', 'Ba Accounting', 1700, 'Education');

CREATE TABLE Student(
StudentID VARCHAR PRIMARY KEY,
First_Name VARCHAR(40),
Last_Name VARCHAR(40),
PID VARCHAR,
FOREIGN KEY (PID) REFERENCES Programme(PID)ON DELETE SET NULL
	);
	
SELECT * FROM Student;
INSERT INTO Student VALUES ('SD01', 'Mark', 'Morrison', 'BSCA' );
INSERT INTO student VALUES ('SD02', 'Yaa', 'Boateng', 'SSOA');
INSERT INTO student VALUES ('SD03', 'Johny', 'Walker', 'AACA');
INSERT INTO student VALUES ('SD04', 'Jack', 'Morrison', 'BACE');
INSERT INTO student VALUES ('SD06', 'More', 'Green', 'SSOA');
INSERT INTO student VALUES ('SD09', 'Kofi', 'Mark', 'BSCA');
INSERT INTO student VALUES ('SD010', 'Adjei', 'Mensah', 'AACA');
INSERT INTO student VALUES ('SD11', 'Yaw', 'George', 'BACE');

CREATE TABLE Payment(
PaymentID INT PRIMARY KEY,
Amount_Paid INT,
StudentID VARCHAR,
FOREIGN KEY (StudentID) REFERENCES Student(StudentID) ON DELETE SET null
);

SELECT * FROM Payment;
INSERT INTO Payment VALUES (1, 1000, 'SD04');
INSERT INTO payment VALUES (2, 1500, 'SD01');
INSERT INTO payment VALUES (3, 1000, 'SD03');
INSERT INTO payment VALUES (4, 3000, 'SD03');
INSERT INTO payment VALUES (5, 700, 'SD02');
INSERT INTO payment VALUES (6, 500, 'SD06');
INSERT INTO payment VALUES (7, 400, 'SD04');
INSERT INTO payment VALUES (8, 1700, 'SD11');

-- 2.Query to display the name, first name, last name of a particular student who paid an amount 700.
SELECT programme.p_name AS programme_name, Student.first_name, Student.last_name
FROM Student
JOIN Programme
ON Programme.PID = Student.PID
WHERE StudentID = (SELECT StudentID FROM payment WHERE Amount_Paid = 700);

-- 3 Query to display the programme name, first name, last name and all those who have not made any form of payment.
SELECT Programme.p_name AS Programme_name, Student.first_name, Student.last_name
FROM Student
JOIN Programme
ON Programme.PID = Student.PID
WHERE StudentID NOT IN (SELECT StudentID FROM payment);

-- 4 Query to display the programme name, first name, last name of all those who have made some form of payment.
SELECT Programme.p_name AS Programme_name, Student.first_name,Student.last_name
FROM Student
JOIN Programme
ON Programme.PID = Student.PID
WHERE StudentID IN (SELECT StudentID FROM Payment);

--5 Query to display programme name, StudentID, of all those who have not made payment but are not student
SELECT Programme.P_NAME, student.StudentID
FROM Student
JOIN Programme
ON Programme.PID = Student.PID
WHERE Student.StudentID NOT IN (SELECT StudentID FROM Payment);

--6 Query to display average payment of each student.
SELECT Student.StudentID, ROUND(AVG(Payment.Amount_Paid), 2) AS Average_Amount_Paid
FROM Payment
JOIN Student
ON Student.StudentID = Payment.StudentID
GROUP BY Student.StudentID;

--7 Query to display the total payment of each student.
SELECT Student.StudentID, ROUND(AVG(Payment.Amount_Paid),2) AS Average_Amount_Paid
FROM Payment
RIGHT JOIN Student
ON Student.StudentID = Payment.StudentID
GROUP BY Student.StudentID;

-- 8 Query to display the programme name, last name, of all those whole have made payments in excess of the legal amount to pay and excess amount.
SELECT
Programme.P_NAME AS Programme_Name,
Student.first_name, Student.last_name,
(Payment.Amount_Paid - Programme.Amount_To_Pay) AS Excess
FROM Student
JOIN Payment
ON Payment.StudentID = Student.StudentID
JOIN Programme
ON Programme.PID = Student.PID
WHERE Payment.Amount_Paid > Programme.Amount_To_Pay;

--9 Query to display the nuber of students who pursue the various programmes.
SELECT PID AS ProgrammeID, COUNT(StudentID) FROM Student 
GROUP BY PID;

---10 Query to display the number of programme name, first name, last name of the person  who paid the minimum amount at a single payment.
SELECT Programme.P_NAME AS Programme_Name, Student.first_name, Student.last_name
FROM Student
JOIN Programme
ON Student.PID = Programme.PID
WHERE Student.StudentID = (
	SELECT StudentID FROM Payment WHERE Amount_Paid = (SELECT MIN (Amount_Paid) FROM Payment)
);


---11 Query to display the programme name, first name, last name of the person who paid the minimum at a single payment.
SELECT programme.P_NAME AS Programme_Name, Student.first_name, Student.last_name
FROM Student
JOIN Programme
ON Student.PID = Programme.PID
WHERE Student.StudentID = (
SELECT StudentID FROM Payment WHERE Amount_Paid = ( SELECT MAX(Amount_Paid)FROM Payment));
