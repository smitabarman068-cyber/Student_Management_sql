CREATE DATABASE student_management;
USE student_management;
SHOW DATABASES;

CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    mobile VARCHAR(15)
);
SHOW TABLES;
describe Students;

CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL UNIQUE,
    fee DECIMAL(10,2) NOT NULL
);
show tables;
describe Courses;

CREATE TABLE Admissions (
    admission_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    agreed_fee DECIMAL(10,2) NOT NULL,
    admission_date DATE NOT NULL,

    FOREIGN KEY (student_id)
        REFERENCES Students(student_id),

    FOREIGN KEY (course_id)
        REFERENCES Courses(course_id)
);
describe Admissions;

CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    admission_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,

    FOREIGN KEY (admission_id)
        REFERENCES Admissions(admission_id),

    CHECK (amount > 0)
);
show tables;

INSERT INTO Students (name, email, mobile)
VALUES
('Janvi', 'janvi@gmail.com', '9865115832'),
('Priya', 'priya@gmail.com', '9876543211'),
('Pranay', 'pranay@gmail.com', '9876543212'),
('Sneha', 'sneha@gmail.com', '9876543213'),
('Karan', 'karan@gmail.com', '9876543214');
SELECT * FROM Students;

INSERT INTO Courses (course_name, fee)
VALUES
('Python Full Stack', 25000),
('Java Full Stack', 30000),
('Data Science', 35000),
('Django Development', 20000),
('Web Development', 18000);
SELECT * FROM Courses;

INSERT INTO Admissions
(student_id, course_id, agreed_fee, admission_date)
VALUES
(1, 1, 25000, '2026-11-01'),
(2, 2, 30000, '2026-11-02'),
(3, 1, 24000, '2026-11-03'),
(4, 3, 35000, '2026-11-04'),
(1, 4, 20000, '2026-11-05'),
(5, 5, 18000, '2026-11-06');
select * from Admissions;

INSERT INTO Payments
(admission_id, amount, payment_date)
VALUES
(1, 10000, '2026-11-02'),
(1, 5000, '2026-11-05'),
(2, 15000, '2026-11-03'),
(3, 9000, '2026-11-04'),
(4, 20000, '2026-11-05'),
(5, 10000, '2026-11-06'),
(6, 8000, '2026-11-07');
select * from Payments;

UPDATE Students
SET mobile = '8565291378'
WHERE student_id = 1;
SELECT * FROM Students;
UPDATE Students
SET name = 'Priya Sharma',
    email = 'priyasharma@gmail.com'
WHERE student_id = 2;
SELECT * FROM Students
WHERE student_id = 2;
INSERT INTO Students (name, email, mobile)
VALUES ('dimpi', 'dimpi@gmail.com', '6900211158');
DELETE FROM Students
WHERE email = 'testuser@gmail.com';

#Calculate total payments per student
SELECT
    s.student_id,
    s.name,
    c.course_name,
    a.agreed_fee
FROM Students s
INNER JOIN Admissions a
    ON s.student_id = a.student_id
INNER JOIN Courses c
    ON a.course_id = c.course_id;
SELECT
    s.student_id,
    s.name,
    SUM(p.amount) AS total_paid
FROM Students s
INNER JOIN Admissions a
    ON s.student_id = a.student_id
INNER JOIN Payments p
    ON a.admission_id = p.admission_id
GROUP BY s.student_id, s.name;
SELECT admission_id, student_id
FROM Admissions;
DESCRIBE Admissions;

#Identify pending fee balances.
SELECT
    s.student_id,
    s.name,
    a.admission_id,
    a.agreed_fee,
    COALESCE(SUM(p.amount), 0) AS total_paid,
    a.agreed_fee - COALESCE(SUM(p.amount), 0) AS pending_fee
FROM Students s
INNER JOIN Admissions a
    ON s.student_id = a.student_id
LEFT JOIN Payments p
    ON a.admission_id = p.admission_id
GROUP BY
    s.student_id,
    s.name,
    a.admission_id,
    a.agreed_fee;
    
   #Count admissions course-wise
    SELECT
    c.course_id,
    c.course_name,
    COUNT(a.admission_id) AS total_admissions
FROM Courses c
INNER JOIN Admissions a
    ON c.course_id = a.course_id
GROUP BY
    c.course_id,
    c.course_name;
   
   # This query Shows which students selected which courses
    SELECT  
    c.course_name,
    s.name AS student_name 
FROM Courses c
INNER JOIN Admissions a
    ON c.course_id = a.course_id
INNER JOIN Students s
    ON a.student_id = s.student_id
ORDER BY c.course_name;

#Display payment history
SELECT
    s.student_id,
    s.name,
    p.payment_date,
    p.amount
FROM Students s
INNER JOIN Admissions a
    ON s.student_id = a.student_id
INNER JOIN Payments p
    ON a.admission_id = p.admission_id
ORDER BY p.payment_date;

#Filter Admissions by Date
SELECT
    s.student_id,
    s.name,
    c.course_name,
    a.admission_date
FROM Students s
INNER JOIN Admissions a
    ON s.student_id = a.student_id
INNER JOIN Courses c
    ON a.course_id = c.course_id
WHERE a.admission_date BETWEEN '2026-11-01' AND '2026-11-05'
ORDER BY a.admission_date;

#Practice Transactions and Rollback
SELECT *
FROM Students
WHERE student_id =5;

SELECT *
FROM Students
WHERE student_id = 1;

START TRANSACTION;
UPDATE Students
SET name = 'smita'
WHERE student_id = 1;
SELECT *
FROM Students
WHERE student_id = 1;
Rollback;
SELECT*
FROM Students
WHERE student_id = 1;

UPDATE Students
SET name = 'janvi'
WHERE student_id = 5;
SELECT *
FROM Students
WHERE student_id = 5;
ROLLBACK;
SELECT *
FROM Students
WHERE student_id = 5;

START TRANSACTION;

UPDATE Students
SET name = 'Janvi'
WHERE student_id = 1;

COMMIT;
SELECT *
FROM Students
WHERE student_id = 1;

