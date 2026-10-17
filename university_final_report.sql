CREATE DATABASE IF NOT EXISTS UniversityDB;
USE UniversityDB;

CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(10),
    major VARCHAR(100),
    enrollment_year INT
);

CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    credits INT NOT NULL,
    department VARCHAR(100)
);

CREATE TABLE Instructors (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hire_date DATE,
    department VARCHAR(100)
);

CREATE TABLE Enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Course_Assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    instructor_id INT NOT NULL,
    course_id INT NOT NULL,
    semester VARCHAR(20),
    year INT,
    FOREIGN KEY (instructor_id) REFERENCES Instructors(instructor_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO Students
(first_name, last_name, email, date_of_birth, gender, major, enrollment_year)
VALUES
('Ahmad', 'Ali', 'ahmad@example.com', '2003-04-12', 'Male', 'IT', 2022),
('Sara', 'Khaled', 'sara@example.com', '2002-08-20', 'Female', 'MIS', 2021),
('Omar', 'Hassan', 'omar@example.com', '2003-01-15', 'Male', 'CS', 2022),
('Lina', 'Sami', 'lina@example.com', '2004-05-11', 'Female', 'IT', 2023),
('Yousef', 'Adel', 'yousef@example.com', '2002-09-25', 'Male', 'MIS', 2021);

INSERT INTO Instructors
(first_name, last_name, email, hire_date, department)
VALUES
('Khaled', 'Naser', 'khaled@example.com', '2018-09-01', 'IT'),
('Mona', 'Saleh', 'mona@example.com', '2019-02-15', 'MIS'),
('Tariq', 'Omar', 'tariq@example.com', '2017-06-10', 'CS'),
('Huda', 'Ahmad', 'huda@example.com', '2020-01-20', 'IT'),
('Rami', 'Fadi', 'rami@example.com', '2016-08-05', 'MIS');

INSERT INTO Courses
(course_name, course_code, credits, department)
VALUES
('Database Systems', 'DB101', 3, 'IT'),
('Web Development', 'WEB201', 3, 'IT'),
('Programming', 'CS101', 4, 'CS'),
('Systems Analysis', 'MIS201', 3, 'MIS'),
('Computer Networks', 'NET301', 3, 'IT');

INSERT INTO Enrollments (student_id, course_id, grade)
VALUES
(1, 1, 'A'), (1, 2, 'B'),
(2, 1, 'B'), (2, 4, 'A'),
(3, 2, 'A'), (3, 3, 'B'),
(4, 1, 'B'), (4, 5, 'A'),
(5, 3, 'A'), (5, 4, 'B');

INSERT INTO Course_Assignments
(instructor_id, course_id, semester, year)
VALUES
(1, 1, 'Fall', 2026),
(4, 2, 'Fall', 2026),
(3, 3, 'Fall', 2026),
(2, 4, 'Fall', 2026),
(1, 5, 'Fall', 2026);

SELECT
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.email,
    s.major,
    c.course_name,
    CONCAT(i.first_name, ' ', i.last_name) AS instructor_name,
    e.grade,
    c.credits,
    (
        SELECT SUM(c2.credits)
        FROM Enrollments e2
        INNER JOIN Courses c2
            ON e2.course_id = c2.course_id
        WHERE e2.student_id = s.student_id
    ) AS total_credits
FROM Students s
INNER JOIN Enrollments e
    ON s.student_id = e.student_id
INNER JOIN Courses c
    ON e.course_id = c.course_id
LEFT JOIN Course_Assignments ca
    ON c.course_id = ca.course_id
    AND ca.semester = 'Fall'
    AND ca.year = 2026
LEFT JOIN Instructors i
    ON ca.instructor_id = i.instructor_id
ORDER BY s.student_id, c.course_name;

