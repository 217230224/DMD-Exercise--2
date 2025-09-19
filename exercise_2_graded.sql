-- 创建智能养老院数据库
CREATE DATABASE smart_old_age_home;

-- 连接到数据库
\c smart_old_age_home;

-- 创建medication_stock表
CREATE TABLE medication_stock (
    medication_id INTEGER PRIMARY KEY,
    medication_name VARCHAR NOT NULL,
    quantity INTEGER NOT NULL
);

-- 创建其他所需表
CREATE TABLE patients (
    patient_id INTEGER PRIMARY KEY,
    patient_name VARCHAR NOT NULL,
    age INTEGER NOT NULL,
    doctor_id INTEGER
);

CREATE TABLE doctors (
    doctor_id INTEGER PRIMARY KEY,
    doctor_name VARCHAR NOT NULL,
    specialization VARCHAR NOT NULL
);

CREATE TABLE treatments (
    treatment_id INTEGER PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    doctor_id INTEGER NOT NULL,
    treatment_type VARCHAR NOT NULL,
    treatment_date DATE NOT NULL,
    nurse_id INTEGER,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE nurses (
    nurse_id INTEGER PRIMARY KEY,
    nurse_name VARCHAR NOT NULL,
    shift VARCHAR NOT NULL -- 'morning', 'afternoon', 'night'
);

-- 插入示例数据
INSERT INTO medication_stock (medication_id, medication_name, quantity) VALUES
(1, 'Paracetamol', 150),
(2, 'Lisinopril', 75),
(3, 'Metformin', 100),
(4, 'Aspirin', 200),
(5, 'Atorvastatin', 50),
(6, 'Omeprazole', 60),
(7, 'Amoxicillin', 40),
(8, 'Ibuprofen', 120);

INSERT INTO doctors (doctor_id, doctor_name, specialization) VALUES
(1, 'Dr. Smith', 'Cardiology'),
(2, 'Dr. Johnson', 'Neurology'),
(3, 'Dr. Williams', 'Cardiology'),
(4, 'Dr. Brown', 'Orthopedics'),
(5, 'Dr. Davis', 'Geriatrics'),
(6, 'Dr. Miller', 'Dermatology'),
(7, 'Dr. Wilson', 'Cardiology');

INSERT INTO patients (patient_id, patient_name, age, doctor_id) VALUES
(1, 'John Doe', 75, 1),
(2, 'Jane Smith', 82, 3),
(3, 'Robert Johnson', 78, 1),
(4, 'Mary Williams', 85, 5),
(5, 'Michael Brown', 72, 2),
(6, 'Jennifer Davis', 90, 3),
(7, 'William Miller', 68, 4),
(8, 'Elizabeth Wilson', 88, 5),
(9, 'James Moore', 76, 1),
(10, 'Patricia Taylor', 81, 3),
(11, 'Robert Anderson', 79, 2),
(12, 'Linda Thomas', 83, 5),
(13, 'Richard Jackson', 70, 6),
(14, 'Barbara White', 87, 5),
(15, 'Joseph Harris', 69, 7),
(16, 'Susan Martin', 84, 3),
(17, 'Thomas Thompson', 73, 4),
(18, 'Dorothy Garcia', 86, 5),
(19, 'Daniel Rodriguez', 77, 1),
(20, 'Lisa Lewis', 80, 3);

INSERT INTO nurses (nurse_id, nurse_name, shift) VALUES
(1, 'Nurse Adams', 'morning'),
(2, 'Nurse Baker', 'afternoon'),
(3, 'Nurse Clark', 'night'),
(4, 'Nurse Davis', 'morning'),
(5, 'Nurse Evans', 'afternoon');

INSERT INTO treatments (treatment_id, patient_id, doctor_id, treatment_type, treatment_date, nurse_id) VALUES
(1, 1, 1, 'Consultation', '2023-01-15', 1),
(2, 2, 3, 'Medication', '2023-01-16', 4),
(3, 3, 1, 'Check-up', '2023-01-17', 1),
(4, 4, 5, 'Consultation', '2023-01-18', 2),
(5, 5, 2, 'Medication', '2023-01-19', 3),
(6, 6, 3, 'Check-up', '2023-01-20', 4),
(7, 7, 4, 'Consultation', '2023-01-21', 2),
(8, 8, 5, 'Medication', '2023-01-22', 1),
(9, 9, 1, 'Check-up', '2023-01-23', 4),
(10, 10, 3, 'Consultation', '2023-01-24', 1),
(11, 11, 2, 'Medication', '2023-01-25', 3),
(12, 12, 5, 'Check-up', '2023-01-26', 2),
(13, 14, 5, 'Consultation', '2023-01-27', 1),
(14, 15, 7, 'Medication', '2023-01-28', 4),
(15, 16, 3, 'Check-up', '2023-01-29', 1),
(16, 17, 4, 'Consultation', '2023-01-30', 2),
(17, 18, 5, 'Medication', '2023-01-31', 1),
(18, 19, 1, 'Check-up', '2023-02-01', 4),
(19, 20, 3, 'Consultation', '2023-02-02', 1),
(20, 6, 3, 'Medication', '2023-02-03', 4);

-- Q1: 列出所有患者的姓名和年龄
SELECT patient_name, age FROM patients;

-- Q2: 列出所有心脏科(Cardiology)医生
SELECT doctor_name FROM doctors WHERE specialization = 'Cardiology';

-- Q3: 找出所有80岁以上的患者
SELECT patient_name, age FROM patients WHERE age > 80;

-- Q4: 按年龄排序列出所有患者(最年轻的在前)
SELECT patient_name, age FROM patients ORDER BY age ASC;

-- Q5: 统计每个专科的医生数量
SELECT specialization, COUNT(*) AS doctor_count FROM doctors GROUP BY specialization;

-- Q6: 列出患者及其医生的姓名
SELECT p.patient_name, d.doctor_name 
FROM patients p
JOIN doctors d ON p.doctor_id = d.doctor_id;

-- Q7: 显示治疗以及患者姓名和医生姓名
SELECT t.treatment_type, p.patient_name, d.doctor_name
FROM treatments t
JOIN patients p ON t.patient_id = p.patient_id
JOIN doctors d ON t.doctor_id = d.doctor_id;

-- Q8: 统计每位医生负责的患者数量
SELECT d.doctor_name, COUNT(p.patient_id) AS patient_count
FROM doctors d
LEFT JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.doctor_name;

-- Q9: 计算患者的平均年龄并显示为average_age
SELECT AVG(age) AS average_age FROM patients;

-- Q10: 找出最常见的治疗类型，并只显示该类型
SELECT treatment_type, COUNT(*) AS treatment_count
FROM treatments
GROUP BY treatment_type
HAVING COUNT(*) = (
    SELECT MAX(count) FROM (
        SELECT COUNT(*) AS count FROM treatments GROUP BY treatment_type
    ) AS subquery
);

-- Q11: 列出年龄大于所有患者平均年龄的患者
SELECT patient_name, age
FROM patients
WHERE age > (SELECT AVG(age) FROM patients);

-- Q12: 列出负责5个以上患者的医生
SELECT d.doctor_name, COUNT(p.patient_id) AS patient_count
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.doctor_name
HAVING COUNT(p.patient_id) > 5;

-- Q13: 列出所有由早班护士提供的治疗，并包含患者姓名
SELECT t.treatment_type, p.patient_name, n.nurse_name
FROM treatments t
JOIN patients p ON t.patient_id = p.patient_id
JOIN nurses n ON t.nurse_id = n.nurse_id
WHERE n.shift = 'morning';

-- Q14: 找出每位患者最近的治疗
SELECT p.patient_name, t.treatment_type, t.treatment_date
FROM patients p
JOIN (
    SELECT patient_id, MAX(treatment_date) AS latest_date
    FROM treatments
    GROUP BY patient_id
) AS latest_t ON p.patient_id = latest_t.patient_id
JOIN treatments t ON p.patient_id = t.patient_id AND latest_t.latest_date = t.treatment_date;

-- Q15: 列出所有医生及其患者的平均年龄
SELECT d.doctor_name, AVG(p.age) AS average_patient_age
FROM doctors d
LEFT JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.doctor_name;

-- Q16: 列出负责3个以上患者的医生姓名
SELECT d.doctor_name, COUNT(p.patient_id) AS patient_count
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.doctor_name
HAVING COUNT(p.patient_id) > 3;

-- Q17: 列出未接受任何治疗的患者(HINT: 使用NOT IN)
SELECT patient_name
FROM patients
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM treatments);

-- Q18: 列出库存(数量)低于平均库存的所有药品
SELECT medication_name, quantity
FROM medication_stock
WHERE quantity < (SELECT AVG(quantity) FROM medication_stock);

-- Q19: 对每位医生的患者按年龄排名
SELECT 
    d.doctor_name,
    p.patient_name,
    p.age,
    RANK() OVER (PARTITION BY d.doctor_id ORDER BY p.age) AS age_rank
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
ORDER BY d.doctor_name, age_rank;

-- Q20: 对于每个专科，找出拥有最年长患者的医生
WITH max_age_per_specialization AS (
    SELECT 
        d.specialization,
        MAX(p.age) AS max_age
    FROM doctors d
    JOIN patients p ON d.doctor_id = p.doctor_id
    GROUP BY d.specialization
)
SELECT 
    m.specialization,
    d.doctor_name,
    p.patient_name,
    p.age
FROM max_age_per_specialization m
JOIN doctors d ON m.specialization = d.specialization
JOIN patients p ON d.doctor_id = p.doctor_id AND m.max_age = p.age;






