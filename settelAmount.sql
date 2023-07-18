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
-- Database: `task_settele_amount`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `pending_report` ()  BEGIN
SELECT om.order_id, om.customer_id, om.order_date, om.order_amt, ps.sett_amt as paid_amt,(om.order_amt-ps.sett_amt) as pending 
FROM tb_order_master as om
INNER JOIN
tb_payment_settelment as ps
ON
om.order_id=ps.order_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `settel_report` ()  BEGIN
SELECT pm.payment_id, pm.customer_id, (SELECT SUM(om.order_amt) FROM tb_order_master as om WHERE om.customer_id=pm.customer_id) as sell_amt,
(SELECT SUM(ps.sett_amt) FROM tb_payment_settelment as ps WHERE ps.payment_id=pm.payment_id) as settel_amt ,((SELECT SUM(om.order_amt) FROM tb_order_master as om WHERE om.customer_id=pm.customer_id)-(SELECT SUM(ps.sett_amt) FROM tb_payment_settelment as ps WHERE ps.payment_id=pm.payment_id))as balance_amt
FROM tb_payment_master as pm;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_order_master`
--

CREATE TABLE `tb_order_master` (
  `order_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `order_date` datetime NOT NULL DEFAULT current_timestamp(),
  `order_amt` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_order_master`
--

INSERT INTO `tb_order_master` (`order_id`, `customer_id`, `order_date`, `order_amt`) VALUES
(1, 1, '2022-01-04 22:12:09', '10000'),
(2, 1, '2022-01-04 22:15:28', '2000'),
(3, 2, '2022-01-04 22:35:24', '10000'),
(4, 2, '2022-01-04 22:35:24', '3000'),
(5, 2, '2022-01-04 22:35:39', '5000'),
(6, 3, '2022-01-04 22:35:39', '10000'),
(7, 3, '2022-01-04 22:35:55', '3000'),
(8, 3, '2022-01-04 22:35:55', '4000');

-- --------------------------------------------------------

--
-- Table structure for table `tb_payment_master`
--

CREATE TABLE `tb_payment_master` (
  `payment_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `paid_amt` varchar(100) NOT NULL,
  `paid_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_payment_master`
--

INSERT INTO `tb_payment_master` (`payment_id`, `customer_id`, `paid_amt`, `paid_date`) VALUES
(1, 1, '10000', '2022-01-04 22:12:21'),
(2, 2, '12000', '2022-01-04 22:37:47'),
(3, 3, '13000', '2022-01-04 22:37:47');

-- --------------------------------------------------------

--
-- Table structure for table `tb_payment_settelment`
--

CREATE TABLE `tb_payment_settelment` (
  `sett_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `payment_id` int(11) NOT NULL,
  `sett_amt` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_payment_settelment`
--

INSERT INTO `tb_payment_settelment` (`sett_id`, `order_id`, `payment_id`, `sett_amt`) VALUES
(1, 1, 1, '5000'),
(2, 2, 1, '2000'),
(3, 3, 2, '10000'),
(4, 4, 2, '2000'),
(5, 6, 3, '5000'),
(6, 7, 3, '8000');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_order_master`
--
ALTER TABLE `tb_order_master`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `cust_id` (`customer_id`);

--
-- Indexes for table `tb_payment_master`
--
ALTER TABLE `tb_payment_master`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `cust_id` (`customer_id`);

--
-- Indexes for table `tb_payment_settelment`
--
ALTER TABLE `tb_payment_settelment`
  ADD PRIMARY KEY (`sett_id`),
  ADD KEY `o_id` (`order_id`),
  ADD KEY `p_id` (`payment_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_order_master`
--
ALTER TABLE `tb_order_master`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tb_payment_master`
--
ALTER TABLE `tb_payment_master`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tb_payment_settelment`
--
ALTER TABLE `tb_payment_settelment`
  MODIFY `sett_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
