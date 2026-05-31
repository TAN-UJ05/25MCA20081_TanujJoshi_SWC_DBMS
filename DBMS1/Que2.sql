-- Create Table
CREATE TABLE employee (
    eid INT,
    dept VARCHAR(10),
    scores DECIMAL(5,2)
);

-- Insert Data
INSERT INTO employee (eid, dept, scores) VALUES
(1, 'D1', 1),
(2, 'D1', 5.28),
(3, 'D1', 4),
(4, 'D2', 8),
(5, 'D1', 2.5),
(6, 'D2', 7),
(7, 'D3', 9),
(8, 'D4', 10.2);


SELECT e1.eid, e1.dept, e2.highest_score
FROM employee e1
JOIN (SELECT dept, MAX(scores) AS highest_score
FROM employee
GROUP BY dept) AS e2
ON e1.dept=e2.dept;
