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
-- Database: `task_delivery_time_slot`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Give_input` (IN `Nth` INT)  BEGIN
select 
v.selected_date,
ds.Slot_Name, 
COALESCE((CASE WHEN v.selected_date=CURDATE() AND ds.From_Time > (select CURTIME()) THEN ds.From_Time
          WHEN v.selected_date!=CURDATE()THEN ds.From_Time END),'Slot Not Avilable') as From_Time,
COALESCE((CASE WHEN (CASE WHEN ds.From_Time > (select CURTIME()) THEN ds.From_Time END)!='Slot Not Avilable' THEN ds.To_Time 
           WHEN v.selected_date!=CURDATE()THEN ds.To_Time END),'Slot Not Avilable')To_time
from 
((select adddate('1970-01-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) selected_date from 
 (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0,
 (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1,
 (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2,
 (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3,
 (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v)
INNER JOIN tb_delivery_slot as ds where v.selected_date between CURRENT_DATE and DATE_ADD(CURRENT_DATE ,INTERVAL Nth-1 DAY);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Insert_Interval` (IN `Nth` INT)  BEGIN
WITH recursive gd AS (
    select CURDATE() as Date 
   union all
   select Date + interval 1 day
   from gd
   where Date < DATE_ADD(CURRENT_DATE ,INTERVAL Nth-1 DAY))
SELECT 
gd.Date,
ds.Slot_Name,
COALESCE((CASE WHEN gd.Date=CURDATE() AND ds.From_Time > (select CURTIME()) THEN ds.From_Time
          WHEN gd.Date!=CURDATE()THEN ds.From_Time END),'Slot Not Avilable') as From_Time,
COALESCE((CASE WHEN (CASE WHEN ds.From_Time > (select CURTIME()) THEN ds.From_Time END)!='Slot Not Avilable' THEN ds.To_Time 
           WHEN gd.Date!=CURDATE()THEN ds.To_Time END),'Slot Not Avilable')To_time
FROM gd INNER JOIN tb_delivery_slot as ds ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Todays_Slot` ()  BEGIN
SELECT 
ds.Slot_Name, 
COALESCE((CASE WHEN ds.From_Time > (select CURTIME()) THEN ds.From_Time END),'Slot Not Avilable')From_Time, 
COALESCE((CASE WHEN (CASE WHEN ds.From_Time > (select CURTIME()) THEN ds.From_Time END)!=0 THEN ds.To_Time END),'Slot Not Avilable')To_time
FROM tb_delivery_slot as ds;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_delivery_slot`
--

CREATE TABLE `tb_delivery_slot` (
  `id` int(11) NOT NULL,
  `Slot_Name` varchar(100) NOT NULL,
  `From_Time` time NOT NULL,
  `To_Time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_delivery_slot`
--

INSERT INTO `tb_delivery_slot` (`id`, `Slot_Name`, `From_Time`, `To_Time`) VALUES
(1, '9 to 10', '09:00:00', '10:00:00'),
(2, '10 to 11', '10:00:00', '11:00:00'),
(3, '11 to 12', '11:00:00', '12:00:00'),
(4, '12 to 1', '12:00:00', '13:00:00'),
(5, '1 to 2', '13:00:00', '14:00:00'),
(6, '2 to 3', '14:00:00', '15:00:00'),
(7, '3 to 4', '15:00:00', '16:00:00'),
(8, '4 to 5', '16:00:00', '17:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `tb_delivery_slot_master`
--

CREATE TABLE `tb_delivery_slot_master` (
  `Delivery_Slot_Id` int(11) NOT NULL,
  `Reg_Date_Time` datetime NOT NULL DEFAULT current_timestamp(),
  `Slot_Name` varchar(50) NOT NULL,
  `From_Time` time NOT NULL,
  `To_Time` time NOT NULL,
  `Status` int(11) NOT NULL COMMENT '0-Inactive, 1- Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tb_delivery_slot_master`
--

INSERT INTO `tb_delivery_slot_master` (`Delivery_Slot_Id`, `Reg_Date_Time`, `Slot_Name`, `From_Time`, `To_Time`, `Status`) VALUES
(1, '2021-06-21 14:41:17', '9 AM - 12 AM', '08:00:00', '12:00:00', 1),
(2, '2021-06-21 14:45:39', '1 PM - 5 PM', '13:00:00', '17:00:00', 1),
(3, '2021-06-21 14:46:16', '6 PM To 8 PM', '18:00:00', '20:00:00', 1),
(5, '2021-06-29 14:31:40', '8:30 PM To 10:30 PM', '20:30:00', '22:30:00', 0),
(6, '2021-07-02 14:05:00', '6:30 AM To 8:30 AM', '06:30:00', '08:30:00', 1),
(7, '2021-07-13 11:40:27', '6:00 PM To 8:00 PM', '18:00:00', '20:00:00', 1),
(8, '2021-11-17 15:58:00', '9 AM To 5 PM', '08:55:00', '17:10:00', 1),
(9, '2021-11-27 15:21:19', '11 PM - 12 PM', '12:00:00', '23:00:00', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_delivery_slot`
--
ALTER TABLE `tb_delivery_slot`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_delivery_slot_master`
--
ALTER TABLE `tb_delivery_slot_master`
  ADD PRIMARY KEY (`Delivery_Slot_Id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_delivery_slot`
--
ALTER TABLE `tb_delivery_slot`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tb_delivery_slot_master`
--
ALTER TABLE `tb_delivery_slot_master`
  MODIFY `Delivery_Slot_Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
