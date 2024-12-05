--3---------------Task 3: Query Student Enrollment Details
-----------Query 1: Retrieve all students and their enrolled courses.

SELECT s.name AS student_name, c.course_name, c.credits
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id;


----------Query 2: Find students not enrolled in any course.

SELECT name AS student_name
FROM Students s
WHERE NOT EXISTS (
    SELECT *
    FROM Enrollments e 
    WHERE e.student_id = s.student_id
);

--4--------------Task 4: Query Course Statistics
-----------Query 3: List all courses and the number of students enrolled.

SELECT c.course_name, COUNT(e.enrollment_id) AS student_count
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;


-----------Query 4: Identify courses where enrollments exceed half the capacity.

SELECT c.course_name
FROM Courses c
JOIN (
    SELECT course_id, COUNT(*) AS student_count
    FROM Enrollments
    GROUP BY course_id
) e ON c.course_id = e.course_id
WHERE student_count > (c.capacity / 2);


--5----------------Task 5: Advanced Enrollment Analysis
--------------Query 5: Find students enrolled in the maximum number of courses.

SELECT s.name AS student_name, COUNT(e.course_id) AS course_count
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) = (
    SELECT MAX(course_count)
    FROM (
        SELECT COUNT(course_id) AS course_count
        FROM Enrollments
        GROUP BY student_id
    ) AS counts
);

---------------Query 6: Calculate the total credits each student is taking.

SELECT s.name AS student_name, SUM(c.credits) AS total_credits
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
GROUP BY s.student_id;

--------------Query 7: Identify courses with no enrollments.
SELECT course_name
FROM Courses c
WHERE NOT EXISTS (
    SELECT *
    FROM Enrollments e
    WHERE e.course_id = c.course_id
);

--6---------Task 6: Implement Constraints
--------Prevent enrolling students in a course if it has reached its capacity:
CREATE TRIGGER check_capacity
BEFORE INSERT ON Enrollments
FOR EACH ROW
BEGIN
    DECLARE current_count INT;
    SELECT COUNT(*) INTO current_count
    FROM Enrollments
    WHERE course_id = NEW.course_id;
    IF current_count >= (SELECT capacity FROM Courses WHERE course_id = NEW.course_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Course capacity reached';
    END IF;
END;


-----------Ensure each student can enroll in a maximum of 5 courses:
CREATE TRIGGER check_student_courses
BEFORE INSERT ON Enrollments
FOR EACH ROW
BEGIN
    DECLARE course_count INT;
    SELECT COUNT(*) INTO course_count
    FROM Enrollments
    WHERE student_id = NEW.student_id;
    IF course_count >= 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student cannot enroll in more than 5 courses';
    END IF;
END;


--7----------Task 7: Clean and Reset Data
----------Remove all enrollments for a specific course:
DELETE FROM Enrollments
WHERE course_id = 1;

----------Delete all students who have not enrolled in any courses:
DELETE FROM Students
WHERE NOT EXISTS (
    SELECT *
    FROM Enrollments
    WHERE Enrollments.student_id = Students.student_id
);




