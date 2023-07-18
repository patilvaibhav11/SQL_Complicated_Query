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
-- Database: `task_offer_cashback`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCustomerTotalBlns` (IN `cust_id` INT)  SELECT 
COALESCE((t.cust_id),cust_id)as cust_id, 
COALESCE((t.offer_id),0)as offer_id, 
COALESCE(SUM(t.transfer_amt),0)as transfer_amt, 
COALESCE(SUM(w.offer_amt),0)as recivedOfferAmt,
COALESCE((SUM(t.transfer_amt) + COALESCE(SUM(w.offer_amt),0)),'please recharge your wallet')as customerBlns 
FROM tbl_transection_master as t LEFT JOIN tbl_wallet_master as w ON t.tran_id=w.tran_id WHERE t.cust_id=cust_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCustomerWiseOffer` (IN `cust_id` INT)  BEGIN
SELECT t.cust_id, COALESCE((t.offer_id),0)as offer_id, t.transfer_amt, COALESCE((w.offer_amt),0)as offer_amt, t.created_at FROM tbl_transection_master as t LEFT JOIN tbl_wallet_master as w ON t.tran_id=w.tran_id WHERE t.cust_id=cust_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_customer_master`
--

CREATE TABLE `tbl_customer_master` (
  `cust_id` int(11) NOT NULL,
  `cust_name` varchar(100) NOT NULL,
  `address` varchar(100) NOT NULL,
  `phone_no` varchar(100) NOT NULL,
  `is_new` tinyint(1) NOT NULL DEFAULT 0,
  `is_ordered` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_customer_master`
--

INSERT INTO `tbl_customer_master` (`cust_id`, `cust_name`, `address`, `phone_no`, `is_new`, `is_ordered`, `status`) VALUES
(1, 'vaibhav', '12-a, nashik', '9096010022', 1, 0, 1),
(2, 'Sakshi Patil', '12-a, nashik', '909808789', 0, 0, 1),
(3, 'kumar sangakara', '12-a, nashik', '989878987', 0, 0, 1),
(4, 'harshad patel', '12-a, nashik', '9898989898', 0, 0, 1),
(5, 'sahil shinde', '12-a, nashik', '9898989898', 0, 0, 1),
(6, 'vikas patil', '12-a, nashik', '8787878778', 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_offer_master`
--

CREATE TABLE `tbl_offer_master` (
  `offer_id` int(11) NOT NULL,
  `offer_name` varchar(100) NOT NULL,
  `offer_description` varchar(100) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `offer_type` tinyint(1) NOT NULL DEFAULT 1,
  `offer_status` tinyint(1) NOT NULL DEFAULT 0,
  `topup` float NOT NULL,
  `cashback` float NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_offer_master`
--

INSERT INTO `tbl_offer_master` (`offer_id`, `offer_name`, `offer_description`, `start_date`, `end_date`, `offer_type`, `offer_status`, `topup`, `cashback`, `created_at`) VALUES
(1, 'Holi offer', 'Holi offer description', '2022-02-08', '2022-03-08', 1, 1, 100, 10, '2022-02-15 14:12:19'),
(2, 'Holi offer', 'Holi offer description', '2022-02-08', '2022-03-08', 1, 1, 200, 20, '2022-02-15 14:12:19'),
(3, 'Holi offer', 'Holi offer description', '2022-02-08', '2022-03-08', 1, 1, 500, 70, '2022-02-15 14:12:58'),
(4, 'special offer', 'special offer to every customer', '2022-02-01', '2022-04-30', 1, 1, 1000, 200, '2022-02-15 14:16:33');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_transection_master`
--

CREATE TABLE `tbl_transection_master` (
  `tran_id` int(11) NOT NULL,
  `cust_id` int(11) NOT NULL,
  `offer_id` int(11) DEFAULT NULL,
  `transfer_amt` float NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `tbl_transection_master`
--
DELIMITER $$
CREATE TRIGGER `newStage` BEFORE INSERT ON `tbl_transection_master` FOR EACH ROW UPDATE tbl_customer_master SET is_new = '1' WHERE tbl_customer_master.cust_id = new.cust_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `transectionOffer` AFTER INSERT ON `tbl_transection_master` FOR EACH ROW INSERT INTO tbl_wallet_master (cust_id,tran_id,offer_amt)
VALUES(
new.cust_id,
new.tran_id,
COALESCE((SELECT (CASE WHEN o.offer_status=1 AND ((SELECT c.status FROM tbl_customer_master as c WHERE c.cust_id=new.cust_id)=1) THEN o.cashback END) FROM tbl_offer_master as o WHERE o.offer_id=new.offer_id || o.topup=new.transfer_amt ),'Without any offer')  
)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_wallet_master`
--

CREATE TABLE `tbl_wallet_master` (
  `wallet_id` int(11) NOT NULL,
  `tran_id` int(11) DEFAULT NULL,
  `cust_id` int(11) DEFAULT NULL,
  `offer_amt` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_customer_master`
--
ALTER TABLE `tbl_customer_master`
  ADD PRIMARY KEY (`cust_id`);

--
-- Indexes for table `tbl_offer_master`
--
ALTER TABLE `tbl_offer_master`
  ADD PRIMARY KEY (`offer_id`);

--
-- Indexes for table `tbl_transection_master`
--
ALTER TABLE `tbl_transection_master`
  ADD PRIMARY KEY (`tran_id`),
  ADD KEY `cust_id` (`cust_id`),
  ADD KEY `offer_id` (`offer_id`);

--
-- Indexes for table `tbl_wallet_master`
--
ALTER TABLE `tbl_wallet_master`
  ADD PRIMARY KEY (`wallet_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_customer_master`
--
ALTER TABLE `tbl_customer_master`
  MODIFY `cust_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tbl_offer_master`
--
ALTER TABLE `tbl_offer_master`
  MODIFY `offer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_transection_master`
--
ALTER TABLE `tbl_transection_master`
  MODIFY `tran_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_wallet_master`
--
ALTER TABLE `tbl_wallet_master`
  MODIFY `wallet_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_transection_master`
--
ALTER TABLE `tbl_transection_master`
  ADD CONSTRAINT `tbl_transection_master_ibfk_1` FOREIGN KEY (`cust_id`) REFERENCES `tbl_customer_master` (`cust_id`),
  ADD CONSTRAINT `tbl_transection_master_ibfk_2` FOREIGN KEY (`offer_id`) REFERENCES `tbl_offer_master` (`offer_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
