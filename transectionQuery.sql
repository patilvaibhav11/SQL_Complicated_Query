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
-- Database: `task_trnasection_query`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_dummy_data` (IN `no_stud` INT)  BEGIN
	DECLARE i int;
    set i = 0;
    l1: LOOP
   INSERT INTO tb_student(`name`,`age`,`gender`,`total_marks`,`fees`) VALUES((SELECT name FROM student ORDER BY rand() LIMIT 1), RAND()*(25-10)+10, 'Male' ,RAND()*(100-10)+10 ,RAND()*(10000-5000+1));
    set i = i + 1;
    if(i = no_stud) THEN
    LEAVE l1;
    SELECT 'Student Inserted';
    END IF;
    END LOOP l1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fund_transfer_with_trn_qry` (IN `from_acc_no` INT, IN `to_acc_no` INT, IN `amt` INT)  BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
    END;
    DECLARE EXIT HANDLER For SQLWARNING
    BEGIN
    	ROLLBACK;
    END;
    START TRANSACTION;
    	UPDATE tb_bank_account SET balance = balance - amt 
            WHERE acc_no = from_acc_no;
	UPDATE tb_bank_account set balance = balance + amt 
            WHERE acc_no = to_acc_no;
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `money_transfer` (IN `Dr_No` INT, IN `Cr_No` INT, IN `amt` INT)  BEGIN
   DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
    END;
    DECLARE EXIT HANDLER For SQLWARNING
    BEGIN
    	ROLLBACK;
    END;
    
	IF((SELECT COUNT(acc_no) FROM tb_bank_account WHERE acc_no = Dr_No)<=0) THEN
    	SELECT 'Dr_No Not Available';
    ELSEIF((SELECT COUNT(acc_no) FROM tb_bank_account WHERE acc_no = Cr_No)<=0) THEN
    	SELECT 'Cr_No Not Available';
    ELSE
    	IF((SELECT balance FROM tb_bank_account WHERE acc_no = Dr_No)>=amt) THEN
		    START TRANSACTION;
        	UPDATE tb_bank_account set balance = balance - amt WHERE acc_no = Dr_No;
            UPDATE tb_bank_account set balance = balance + amt WHERE acc_no = Cr_No;
			COMMIT;
         ELSE
         	SELECT 'Insufficient Credit Balance';
         
    	END IF;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `gender` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`id`, `name`, `gender`) VALUES
(1, 'Vaibhav', 'Male'),
(2, 'Kalpesh', 'Male'),
(6, 'Rudra', 'Male'),
(7, 'Toshif', 'Male'),
(8, 'Samarth', 'Male');

-- --------------------------------------------------------

--
-- Table structure for table `tb_bank_account`
--

CREATE TABLE `tb_bank_account` (
  `id` int(11) NOT NULL,
  `acc_no` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `balance` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_bank_account`
--

INSERT INTO `tb_bank_account` (`id`, `acc_no`, `name`, `balance`) VALUES
(1, 2121, 'vaibhav', 22300),
(2, 3434, 'Sakshi', 30500),
(3, 4323, 'Parth', 11000),
(4, 3430, 'Kunal', 24000);

-- --------------------------------------------------------

--
-- Table structure for table `tb_student`
--

CREATE TABLE `tb_student` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `age` int(11) NOT NULL,
  `gender` varchar(100) NOT NULL,
  `total_marks` int(11) NOT NULL,
  `fees` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_student`
--

INSERT INTO `tb_student` (`id`, `name`, `age`, `gender`, `total_marks`, `fees`) VALUES
(1, 'Samarth', 21, 'Male', 42, 2947.87),
(2, 'Rudra', 15, 'Male', 31, 1039.13),
(3, 'Kalpesh', 24, 'Male', 86, 2301.9),
(4, 'Toshif', 11, 'Male', 24, 3286.27),
(5, 'Rudra', 10, 'Male', 55, 2260.8),
(6, 'Kalpesh', 22, 'Male', 72, 4947.42),
(7, 'Samarth', 20, 'Male', 33, 1570.97),
(8, 'Kalpesh', 22, 'Male', 84, 3249.96),
(9, 'Kalpesh', 24, 'Male', 49, 1846.53),
(10, 'Samarth', 17, 'Male', 40, 1406.79),
(11, 'Toshif', 17, 'Male', 33, 4223.81),
(12, 'Samarth', 14, 'Male', 97, 590.986),
(13, 'Kalpesh', 11, 'Male', 41, 2366.34),
(14, 'Kalpesh', 21, 'Male', 20, 1765.69),
(15, 'Kalpesh', 24, 'Male', 50, 1707.41),
(16, 'Rudra', 12, 'Male', 56, 661.471),
(17, 'Vaibhav', 14, 'Male', 21, 3711.32),
(18, 'Vaibhav', 21, 'Male', 89, 1056.13),
(19, 'Samarth', 14, 'Male', 66, 1735.25),
(20, 'Rudra', 23, 'Male', 75, 545.732),
(21, 'Samarth', 18, 'Male', 61, 859.325),
(22, 'Vaibhav', 11, 'Male', 48, 4544.33),
(23, 'Samarth', 13, 'Male', 25, 1264.7),
(24, 'Kalpesh', 16, 'Male', 53, 1387.01),
(25, 'Samarth', 17, 'Male', 24, 1597.14),
(26, 'Vaibhav', 17, 'Male', 22, 1775.14),
(27, 'Vaibhav', 22, 'Male', 63, 2893.01),
(28, 'Vaibhav', 17, 'Male', 85, 3604.76),
(29, 'Vaibhav', 20, 'Male', 12, 1014.91),
(30, 'Kalpesh', 13, 'Male', 33, 3275.44),
(31, 'Rudra', 15, 'Male', 92, 2689.43),
(32, 'Kalpesh', 21, 'Male', 82, 3667.66),
(33, 'Kalpesh', 12, 'Male', 51, 4803.29),
(34, 'Rudra', 15, 'Male', 36, 2095.53),
(35, 'Samarth', 13, 'Male', 93, 4847.52),
(36, 'Vaibhav', 14, 'Male', 28, 992.069),
(37, 'Kalpesh', 16, 'Male', 27, 3635.77),
(38, 'Vaibhav', 13, 'Male', 100, 2102.93),
(39, 'Rudra', 22, 'Male', 63, 3314.64),
(40, 'Samarth', 13, 'Male', 19, 4843.2),
(41, 'Samarth', 11, 'Male', 39, 1519.33),
(42, 'Samarth', 17, 'Male', 95, 1354.33),
(43, 'Rudra', 20, 'Male', 40, 3561.61),
(44, 'Toshif', 21, 'Male', 13, 4724.65),
(45, 'Kalpesh', 25, 'Male', 87, 1444.63),
(46, 'Toshif', 19, 'Male', 36, 3552.97),
(47, 'Samarth', 17, 'Male', 44, 2746.99),
(48, 'Toshif', 16, 'Male', 11, 4382.5),
(49, 'Samarth', 23, 'Male', 20, 47.4831),
(50, 'Rudra', 15, 'Male', 98, 4679.29),
(51, 'Toshif', 23, 'Male', 54, 3950.59),
(52, 'Kalpesh', 16, 'Male', 84, 4991.23),
(53, 'Toshif', 11, 'Male', 59, 2372.28),
(54, 'Rudra', 11, 'Male', 13, 243.717),
(55, 'Vaibhav', 11, 'Male', 72, 1501.28),
(56, 'Rudra', 24, 'Male', 85, 2238.92),
(57, 'Toshif', 14, 'Male', 71, 3338.28),
(58, 'Vaibhav', 18, 'Male', 57, 4868.42),
(59, 'Toshif', 12, 'Male', 68, 3544.58),
(60, 'Kalpesh', 21, 'Male', 81, 3775.95),
(61, 'Vaibhav', 18, 'Male', 78, 411.755),
(62, 'Rudra', 23, 'Male', 82, 2092.12),
(63, 'Toshif', 18, 'Male', 64, 1476.69),
(64, 'Samarth', 15, 'Male', 20, 3080.76),
(65, 'Rudra', 11, 'Male', 14, 4804.74),
(66, 'Toshif', 11, 'Male', 61, 3147.82),
(67, 'Toshif', 12, 'Male', 22, 1601.47),
(68, 'Samarth', 17, 'Male', 39, 894.806),
(69, 'Kalpesh', 18, 'Male', 28, 1877.14),
(70, 'Rudra', 12, 'Male', 76, 1206.3),
(71, 'Vaibhav', 17, 'Male', 64, 3111.02),
(72, 'Vaibhav', 13, 'Male', 85, 3097.97),
(73, 'Kalpesh', 17, 'Male', 75, 936.89),
(74, 'Samarth', 21, 'Male', 64, 3733.81),
(75, 'Rudra', 23, 'Male', 60, 567.201),
(76, 'Kalpesh', 11, 'Male', 23, 2780.39),
(77, 'Kalpesh', 22, 'Male', 48, 3393.38),
(78, 'Vaibhav', 14, 'Male', 79, 4996.65),
(79, 'Samarth', 22, 'Male', 86, 4321.71),
(80, 'Rudra', 16, 'Male', 94, 2157.63),
(81, 'Samarth', 22, 'Male', 84, 3418.33),
(82, 'Rudra', 16, 'Male', 92, 1267.43),
(83, 'Samarth', 11, 'Male', 97, 3387.22),
(84, 'Kalpesh', 13, 'Male', 77, 1007.77),
(85, 'Kalpesh', 23, 'Male', 65, 2103.91),
(86, 'Toshif', 10, 'Male', 53, 1578.12),
(87, 'Vaibhav', 22, 'Male', 37, 509.307),
(88, 'Rudra', 14, 'Male', 72, 3066.9),
(89, 'Vaibhav', 22, 'Male', 65, 3399.12),
(90, 'Samarth', 24, 'Male', 79, 4707.04),
(91, 'Toshif', 25, 'Male', 41, 3873.96),
(92, 'Toshif', 11, 'Male', 74, 1720.69),
(93, 'Vaibhav', 16, 'Male', 18, 1247.12),
(94, 'Kalpesh', 22, 'Male', 14, 3980.03),
(95, 'Rudra', 17, 'Male', 44, 2831.58),
(96, 'Samarth', 20, 'Male', 81, 4463.65),
(97, 'Toshif', 22, 'Male', 77, 1277.99),
(98, 'Vaibhav', 15, 'Male', 16, 1890.75),
(99, 'Kalpesh', 12, 'Male', 75, 679.291),
(100, 'Kalpesh', 21, 'Male', 100, 4160.7);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_bank_account`
--
ALTER TABLE `tb_bank_account`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_student`
--
ALTER TABLE `tb_student`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `student`
--
ALTER TABLE `student`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tb_bank_account`
--
ALTER TABLE `tb_bank_account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tb_student`
--
ALTER TABLE `tb_student`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
