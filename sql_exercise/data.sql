--2----------------Task 2: Populate Tables with Sample Data

----------------- Insert sample data into Students
INSERT INTO Students (student_id, name, age, gender) VALUES
(1, 'Alice', 20, 'Female'),
(2, 'Bob', 22, 'Male'),
(3, 'Charlie', 21, 'Male'),
(4, 'Diana', 19, 'Female'),
(5, 'Eve', 23, 'Female');

---------------- Insert sample data into Courses
INSERT INTO Courses (course_id, course_name, credits, capacity) VALUES
(1, 'Mathematics', 3, 2),
(2, 'Physics', 4, 3),
(3, 'Chemistry', 3, 2),
(4, 'Biology', 4, 3);

----------------- Insert sample data into Enrollments
INSERT INTO Enrollments (student_id, course_id) VALUES
(1, 1), (2, 1), 
(3, 2), (4, 2), 
(5, 2), (1, 3), 
(3, 3), (4, 4);
