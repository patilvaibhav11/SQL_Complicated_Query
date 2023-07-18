-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 03, 2022 at 10:12 AM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `task_generate_dates`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ALL_DONE` (IN `fromDate` DATE, IN `toDate` DATE, IN `empId` INT)  BEGIN
WITH recursive gd AS (
    select fromDate as Date 
   union all
   select Date + interval 1 day
   from gd
   where Date < toDate)
SELECT EmpId,

COALESCE((SELECT em.name FROM tb_employee_master as em WHERE em.employee_id=empId),'--//--')as Name,

COALESCE((SELECT em.position FROM tb_employee_master as em WHERE em.employee_id=empId),'--//--')as Position,

gd.Date,

(CASE WHEN ((CASE WHEN (SELECT am.in_time FROM tb_attendance_master as am WHERE am.date=gd.Date AND am.employee_id=empId) THEN am.in_time END)||(CASE WHEN (SELECT am.out_time FROM tb_attendance_master as am WHERE am.date=gd.Date AND am.employee_id=empId) THEN am.out_time END))!='00:00:00' THEN 'Present' ELSE 'Absent' END)as AttendanceStatus,

(CASE 
WHEN 
 (COALESCE((CASE WHEN (SELECT am.in_time FROM tb_attendance_master as am WHERE am.date=gd.Date AND am.employee_id=empId) THEN am.in_time END),'00:00:00'))='00:00:00' THEN 'Absent'
 WHEN 
 (COALESCE((CASE WHEN (SELECT am.in_time FROM tb_attendance_master as am WHERE am.date=gd.Date AND am.employee_id=empId) THEN am.in_time END),'00:00:00'))<='10:00:00' THEN 'OnTime'
 WHEN 
 (COALESCE((CASE WHEN (SELECT am.in_time FROM tb_attendance_master as am WHERE am.date=gd.Date AND am.employee_id=empId) THEN am.in_time END),'00:00:00'))>'10:00:00' THEN 'Late'
END)AS InOffice,

COALESCE((CASE WHEN (SELECT am.in_time FROM tb_attendance_master as am WHERE am.date=gd.Date AND am.employee_id=empId) THEN am.in_time END),'00:00:00')as InTime,
COALESCE((CASE WHEN (SELECT am.out_time FROM tb_attendance_master as am WHERE am.date=gd.Date AND am.employee_id=empId) THEN am.out_time END),'00:00:00') as OutTime,

COALESCE((GREATEST(HOUR(CASE WHEN (SELECT am.out_time FROM tb_attendance_master as am WHERE am.date=gd.Date AND am.employee_id=empId) THEN am.out_time END),0)-
GREATEST(HOUR(CASE WHEN (SELECT am.in_time FROM tb_attendance_master as am WHERE am.date=gd.Date AND am.employee_id=empId) THEN am.in_time END),0)),'00')as WorkHrs,

COALESCE((CASE 
WHEN
 (GREATEST(HOUR(CASE WHEN (SELECT am.out_time FROM tb_attendance_master as am WHERE am.date=gd.Date AND am.employee_id=empId) THEN am.out_time END),0)-
GREATEST(HOUR(CASE WHEN (SELECT am.in_time FROM tb_attendance_master as am WHERE am.date=gd.Date AND am.employee_id=empId) THEN am.in_time END),0))>=8 THEN 'Full day'
WHEN
 (GREATEST(HOUR(CASE WHEN (SELECT am.out_time FROM tb_attendance_master as am WHERE am.date=gd.Date AND am.employee_id=empId) THEN am.out_time END),0)-
GREATEST(HOUR(CASE WHEN (SELECT am.in_time FROM tb_attendance_master as am WHERE am.date=gd.Date AND am.employee_id=empId) THEN am.in_time END),0))>=4 THEN 'Half day'
WHEN
 (GREATEST(HOUR(CASE WHEN (SELECT am.out_time FROM tb_attendance_master as am WHERE am.date=gd.Date AND am.employee_id=empId) THEN am.out_time END),0)-
GREATEST(HOUR(CASE WHEN (SELECT am.in_time FROM tb_attendance_master as am WHERE am.date=gd.Date AND am.employee_id=empId) THEN am.in_time END),0))<4 THEN 'Absent on the day'
END),'Absent')as WorkStatus

from gd 
LEFT JOIN 
tb_attendance_master as am ON am.date=gd.Date
GROUP BY gd.Date;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_attendance_master`
--

CREATE TABLE `tb_attendance_master` (
  `attendent_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `in_time` time DEFAULT NULL,
  `out_time` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_attendance_master`
--

INSERT INTO `tb_attendance_master` (`attendent_id`, `employee_id`, `date`, `in_time`, `out_time`) VALUES
(1, 1, '2022-01-01', '09:53:31', '22:53:31'),
(2, 2, '2022-01-01', '10:53:31', '21:53:31'),
(3, 1, '2022-01-02', '08:54:10', '16:44:10'),
(4, 2, '2022-01-02', '12:54:10', '16:50:10'),
(5, 1, '2022-01-03', '07:55:06', '16:45:06'),
(6, 2, '2022-01-03', '11:55:06', '23:55:06'),
(7, 1, '2022-01-04', '08:55:54', '13:55:54'),
(8, 1, '2022-01-05', '09:55:54', '20:55:54'),
(10, 2, '2022-01-13', '08:57:01', NULL),
(11, 1, '2022-01-20', '10:30:15', '19:19:07');

-- --------------------------------------------------------

--
-- Table structure for table `tb_employee_master`
--

CREATE TABLE `tb_employee_master` (
  `employee_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `position` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_employee_master`
--

INSERT INTO `tb_employee_master` (`employee_id`, `name`, `position`) VALUES
(1, 'vaibhav', 'hr'),
(2, 'ruhi', 'dev');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_attendance_master`
--
ALTER TABLE `tb_attendance_master`
  ADD PRIMARY KEY (`attendent_id`);

--
-- Indexes for table `tb_employee_master`
--
ALTER TABLE `tb_employee_master`
  ADD PRIMARY KEY (`employee_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_attendance_master`
--
ALTER TABLE `tb_attendance_master`
  MODIFY `attendent_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `tb_employee_master`
--
ALTER TABLE `tb_employee_master`
  MODIFY `employee_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
