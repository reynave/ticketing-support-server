-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 02, 2026 at 04:47 PM
-- Server version: 11.4.12-MariaDB-cll-lve
-- PHP Version: 8.4.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `crma2118_s03`
--

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `id` int(9) NOT NULL,
  `id_user` int(9) NOT NULL DEFAULT 0,
  `company` varchar(250) NOT NULL DEFAULT '',
  `address` text NOT NULL,
  `key` varchar(50) NOT NULL DEFAULT '',
  `uniqueMachineID` text NOT NULL,
  `start_date` date NOT NULL DEFAULT '2020-01-01',
  `expired_date` date NOT NULL DEFAULT '2030-01-01',
  `input_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `update_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`id`, `id_user`, `company`, `address`, `key`, `uniqueMachineID`, `start_date`, `expired_date`, `input_date`, `update_date`) VALUES
(1, 1, 'Akumatik', 'Address2', 'Key CRM', 'Machine ID', '2020-01-24', '2030-03-15', '2020-01-01 00:00:00', '2020-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `crm3_activity`
--

CREATE TABLE `crm3_activity` (
  `id` int(11) NOT NULL,
  `id_person` int(11) NOT NULL DEFAULT 0,
  `id_module` int(11) NOT NULL DEFAULT 0,
  `id_company` int(11) NOT NULL DEFAULT 0,
  `id_opportunity` int(11) NOT NULL DEFAULT 0,
  `id_activity_type` int(11) NOT NULL DEFAULT 1,
  `id_user` int(6) NOT NULL DEFAULT 0,
  `event` int(1) NOT NULL DEFAULT 0,
  `due_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `closed_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `closed` int(2) NOT NULL DEFAULT 0,
  `subject` varchar(250) NOT NULL DEFAULT '',
  `start_date` date NOT NULL DEFAULT '2020-01-01',
  `start_time` time NOT NULL DEFAULT '00:00:00',
  `end_date` date NOT NULL DEFAULT '2020-01-01',
  `end_time` time NOT NULL DEFAULT '00:00:00',
  `id_priority` int(3) NOT NULL DEFAULT 0,
  `description` text NOT NULL,
  `comment` text NOT NULL,
  `amount` float(10,0) NOT NULL DEFAULT 0,
  `checkIn_datetime` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `checkIn_lat` varchar(50) NOT NULL DEFAULT '0',
  `checkIn_long` varchar(50) NOT NULL DEFAULT '0',
  `checkIn_note` varchar(250) NOT NULL DEFAULT '',
  `checkIn_by` int(9) NOT NULL DEFAULT 0,
  `checkOut_datetime` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `checkOut_lat` varchar(50) NOT NULL DEFAULT '0',
  `checkOut_long` varchar(50) NOT NULL DEFAULT '0',
  `checkOut_note` varchar(250) NOT NULL DEFAULT '',
  `checkOut_by` int(9) NOT NULL DEFAULT 0,
  `log` text NOT NULL,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_activity`
--

INSERT INTO `crm3_activity` (`id`, `id_person`, `id_module`, `id_company`, `id_opportunity`, `id_activity_type`, `id_user`, `event`, `due_date`, `closed_date`, `closed`, `subject`, `start_date`, `start_time`, `end_date`, `end_time`, `id_priority`, `description`, `comment`, `amount`, `checkIn_datetime`, `checkIn_lat`, `checkIn_long`, `checkIn_note`, `checkIn_by`, `checkOut_datetime`, `checkOut_lat`, `checkOut_long`, `checkOut_note`, `checkOut_by`, `log`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 156, 500, 195, 211, 100, 118, 0, '2020-07-23 08:00:00', '2020-01-01 00:00:00', 1, 'First Call', '2020-07-23', '08:00:00', '2020-07-23', '00:00:00', 0, 'Ada kebutuhan blood collection needle 50 pcs, minta visit dulu untuk tunjukkan barangnya apakah cocok atau tidak', '', 0, '2020-01-01 00:00:00', '0', '0', '', 0, '2020-01-01 00:00:00', '0', '0', '', 0, 'Created by Hellen Keller', 1, 1, '2020-07-23 08:13:59', 118, '2020-07-23 08:13:59', 0),
(2, 156, 500, 195, 211, 200, 118, 0, '2020-07-23 08:00:00', '2020-01-01 00:00:00', 0, 'Visit', '2020-07-23', '08:00:00', '2020-07-23', '00:00:00', 0, 'Visit untuk tunjukkan barang ke bapaknya', '', 50000, '2020-07-23 08:15:06', '-6.2018549', '106.7990531', 'Visit ke kantor bapaknya', 118, '2020-07-23 14:05:58', '-6.2019935', '106.7989551', 'selesai meeting', 118, 'Created by Hellen Keller', 1, 1, '2020-07-23 08:14:41', 118, '2020-07-23 08:14:41', 0),
(3, 153, 500, 192, 208, 100, 118, 0, '2020-08-26 09:30:00', '2020-01-01 00:00:00', 1, 'First Call', '2020-08-26', '09:30:00', '2020-08-26', '00:00:00', 0, 'Ada kebutuhan untuk rectal tube dan blood collecting needle, mau lihat barangnya dulu sekalian tanya lebih detail. Coba set meeting.', '', 0, '2020-01-01 00:00:00', '0', '0', '', 0, '2020-01-01 00:00:00', '0', '0', '', 0, 'Created by Hellen Keller', 1, 1, '2020-08-26 14:43:04', 118, '2020-08-26 14:43:04', 0),
(4, 153, 500, 192, 208, 200, 118, 0, '2020-08-26 12:00:00', '2020-01-01 00:00:00', 0, 'Meeting', '2020-08-26', '12:00:00', '2020-08-26', '14:00:00', 0, 'Meeting untuk menjelaskan rectal tube dan blood collecting needle', '', 50000, '2020-08-26 14:47:01', '-6.2017385', '106.7991944', '', 118, '2020-08-26 14:47:11', '-6.2017385', '106.7991944', '', 118, 'Created by Hellen Keller', 1, 1, '2020-08-26 14:46:37', 118, '2020-08-26 14:46:37', 0),
(5, 153, 500, 192, 208, 1, 118, 0, '2020-08-26 00:00:00', '2020-01-01 00:00:00', 0, 'Membuat quotation', '2020-08-26', '12:00:00', '2020-08-26', '14:00:00', 0, 'Bapaknya cocok dengan produknya, minta buatkan quotation untuk rectal tube 100 pcs dan blood collection needle 50 pcs.', '', 0, '2020-01-01 00:00:00', '0', '0', '', 0, '2020-01-01 00:00:00', '0', '0', '', 0, 'Created by Hellen Keller', 1, 1, '2020-08-26 14:48:20', 118, '2020-08-26 14:48:20', 0),
(6, 154, 500, 193, 209, 100, 118, 0, '2020-08-25 10:00:00', '2020-01-01 00:00:00', 1, 'First Call', '2020-08-26', '10:00:00', '2020-08-26', '00:00:00', 0, 'Ada kebutuhan untuk Automatic Pressure Infusor 5 unit. Minta meeting sekalian demo alatnya.', '', 0, '2020-01-01 00:00:00', '0', '0', '', 0, '2020-01-01 00:00:00', '0', '0', '', 0, 'Created by Hellen Keller', 1, 1, '2020-08-26 14:57:41', 118, '2020-08-26 14:57:41', 0),
(7, 154, 500, 193, 209, 200, 118, 0, '2020-08-26 10:00:00', '2020-01-01 00:00:00', 0, 'Meeting', '2020-08-26', '10:00:00', '2020-08-26', '00:00:00', 0, 'Meeting untuk demo Automatic Pressure Infusor', '', 100000, '2020-08-26 14:58:39', '-6.2017123', '106.7991721', '', 118, '2020-08-26 14:58:47', '-6.2017123', '106.7991721', '', 118, 'Created by Hellen Keller', 1, 1, '2020-08-26 14:58:29', 118, '2020-08-26 14:58:29', 0),
(8, 155, 500, 194, 210, 100, 118, 0, '2020-08-26 00:00:00', '2020-01-01 00:00:00', 1, 'Call in', '2020-08-26', '00:00:00', '2020-08-26', '00:00:00', 0, 'Call in dari bapaknya ada kebutuhan untuk alat suntik 2 ml. Butuh 100 pcs. Minta meeting dulu untuk lihat barangnya.', '', 0, '2020-01-01 00:00:00', '0', '0', '', 0, '2020-01-01 00:00:00', '0', '0', '', 0, 'Created by Hellen Keller', 1, 1, '2020-08-26 15:15:42', 118, '2020-08-26 15:15:42', 0),
(9, 155, 500, 194, 210, 200, 118, 0, '2020-08-26 13:00:00', '2020-01-01 00:00:00', 0, 'Meeting', '2020-08-26', '13:00:00', '2020-08-26', '14:00:00', 0, 'Meeting untuk tunjukkan alat suntiknya.', '', 0, '2020-08-26 15:16:33', '-6.2017372', '106.7991449', '', 118, '2020-08-26 15:16:41', '-6.2017328', '106.7991601', '', 118, 'Created by Hellen Keller', 1, 1, '2020-08-26 15:16:18', 118, '2020-08-26 15:16:18', 0),
(10, 157, 500, 196, 212, 100, 118, 0, '2020-08-27 00:00:00', '2020-01-01 00:00:00', 1, 'First Call', '2020-08-27', '00:00:00', '2020-08-27', '00:00:00', 0, 'Ada kebutuhan ', '', 0, '2020-01-01 00:00:00', '0', '0', '', 0, '2020-01-01 00:00:00', '0', '0', '', 0, 'Created by Hellen Keller', 1, 1, '2020-08-27 11:51:36', 118, '2020-08-27 11:51:36', 0),
(11, 157, 500, 196, 212, 200, 118, 0, '2020-08-27 00:00:00', '2020-01-01 00:00:00', 0, 'Meeting dengan Pak Leo', '2020-08-27', '00:00:00', '2020-08-27', '13:00:00', 0, 'Meeting untuk tunjukkan dan jelaskan produknya', '', 0, '2020-08-27 11:57:12', '-6.1550149', '106.8269924', 'Meeting', 118, '2020-08-27 11:58:38', '-6.1550149', '106.8269924', '', 118, 'Created by Hellen Keller', 1, 1, '2020-08-27 11:56:11', 118, '2020-08-27 11:56:11', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_activity_comment`
--

CREATE TABLE `crm3_activity_comment` (
  `id` int(11) NOT NULL,
  `id_activity` int(11) NOT NULL DEFAULT 0,
  `comment` text NOT NULL,
  `log` text NOT NULL,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `crm3_activity_priority`
--

CREATE TABLE `crm3_activity_priority` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '',
  `value` int(11) NOT NULL DEFAULT 0,
  `color` varchar(50) NOT NULL DEFAULT '',
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_activity_priority`
--

INSERT INTO `crm3_activity_priority` (`id`, `name`, `value`, `color`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 'Low', 0, 'light', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(10, 'Normal', 10, 'success', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(150, 'High', 80, 'warning', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(300, 'Urgent', 90, 'danger', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_activity_type`
--

CREATE TABLE `crm3_activity_type` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '',
  `fas` varchar(50) NOT NULL DEFAULT '',
  `auto_closed` int(1) NOT NULL DEFAULT 0,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_activity_type`
--

INSERT INTO `crm3_activity_type` (`id`, `name`, `fas`, `auto_closed`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 'Task', '<i class=\"far fa-check-square\"></i>', 0, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(100, 'Log a Call', '<i class=\"fas fa-phone\"></i>', 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(200, 'Visit', '<i class=\"fas fa-map-marker-alt\"></i>', 0, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(300, 'Event', '<i class=\"fas fa-street-view\"></i>', 0, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(400, 'Note', '<i class=\"far fa-sticky-note\"></i>', 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(1001, 'Log', '<i class=\"far fa-clipboard\"></i>', 1, 0, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_attachment`
--

CREATE TABLE `crm3_attachment` (
  `id` int(11) NOT NULL,
  `module` varchar(50) NOT NULL DEFAULT '',
  `id_module` int(9) NOT NULL DEFAULT 0,
  `full_path` text NOT NULL,
  `url` text NOT NULL,
  `file_name` varchar(250) NOT NULL DEFAULT '',
  `file_size` varchar(250) NOT NULL DEFAULT '',
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `input_by` int(9) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `update_by` int(9) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_attachment`
--

INSERT INTO `crm3_attachment` (`id`, `module`, `id_module`, `full_path`, `url`, `file_name`, `file_size`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 'priceList', 1, '/home/crma2118/public_html/s03/api-v1/upload/1/blood-collection-needle-500x500.jpg', './upload/1/blood-collection-needle-500x500.jpg', 'blood-collection-needle-500x500.jpg', '15.9', 1, '2020-07-22 17:11:02', 1, '2020-07-22 17:11:02', 0),
(2, 'priceList', 5, '/home/crma2118/public_html/s03/api-v1/upload/Aut_Presure_Infusor.png', './upload//Aut_Presure_Infusor.png', 'Aut_Presure_Infusor.png', '20.59', 1, '2020-08-26 11:34:50', 118, '2020-08-26 11:34:50', 0),
(3, 'priceList', 6, '/home/crma2118/public_html/s03/api-v1/upload/Hitec_2-01_(FILEminimizer)-500x500.png', './upload//Hitec_2-01_(FILEminimizer)-500x500.png', 'Hitec_2-01_(FILEminimizer)-500x500.png', '210.94', 1, '2020-08-26 11:49:53', 118, '2020-08-26 11:49:53', 0),
(4, 'opportunity', 212, '/home/crma2118/public_html/s03/api-v1/upload/Chrysanthemum.jpg', './upload//Chrysanthemum.jpg', 'Chrysanthemum.jpg', '858.78', 1, '2020-08-27 12:04:10', 118, '2020-08-27 12:04:10', 0),
(5, 'opportunity', 212, '/home/crma2118/public_html/s03/api-v1/upload/Penguins.jpg', './upload//Penguins.jpg', 'Penguins.jpg', '759.6', 1, '2020-08-27 12:04:54', 118, '2020-08-27 12:04:54', 0),
(6, 'opportunity', 212, '/home/crma2118/public_html/s03/api-v1/upload/Chrysanthemum1.jpg', './upload//Chrysanthemum1.jpg', 'Chrysanthemum1.jpg', '858.78', 1, '2020-08-27 12:04:57', 118, '2020-08-27 12:04:57', 0),
(7, 'opportunity', 212, '/home/crma2118/public_html/s03/api-v1/upload/Chrysanthemum2.jpg', './upload//Chrysanthemum2.jpg', 'Chrysanthemum2.jpg', '858.78', 1, '2020-08-27 12:05:15', 118, '2020-08-27 12:05:15', 0),
(8, 'opportunity', 212, '/home/crma2118/public_html/s03/api-v1/upload/Chrysanthemum3.jpg', './upload//Chrysanthemum3.jpg', 'Chrysanthemum3.jpg', '858.78', 1, '2020-08-27 12:05:15', 118, '2020-08-27 12:05:15', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_branch`
--

CREATE TABLE `crm3_branch` (
  `id` int(11) NOT NULL,
  `id_company` int(11) NOT NULL DEFAULT 0,
  `name` varchar(250) NOT NULL DEFAULT '',
  `code` varchar(250) NOT NULL DEFAULT '',
  `email` varchar(250) NOT NULL DEFAULT '',
  `phone` varchar(250) NOT NULL DEFAULT '',
  `fax` varchar(250) NOT NULL DEFAULT '',
  `id_branch_status` int(2) NOT NULL DEFAULT 1,
  `address_street` varchar(250) NOT NULL DEFAULT '',
  `address_city` varchar(250) NOT NULL DEFAULT '',
  `address_state` varchar(250) NOT NULL DEFAULT '',
  `address_code` varchar(6) NOT NULL DEFAULT '',
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_branch`
--

INSERT INTO `crm3_branch` (`id`, `id_company`, `name`, `code`, `email`, `phone`, `fax`, `id_branch_status`, `address_street`, `address_city`, `address_state`, `address_code`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(6, 119, 'sdfasdf', '', '', '2342341234', '', 1, '', '', '', '', 1, 1, '2019-07-16 18:41:53', 1, '2019-07-16 18:41:53', 0),
(7, 119, 'sdfasdf', '', '', '123123123', '', 1, '', '', '', '', 1, 1, '2019-07-16 18:45:36', 1, '2019-07-16 18:45:36', 0),
(8, 119, 'r33434343', '', '', '56456', '', 1, '', '', '', '', 1, 1, '2019-07-16 18:57:01', 1, '2019-07-16 18:57:01', 0),
(9, 119, 'sdfasdf', '', '', '7777', '', 1, '', '', '', '', 1, 1, '2019-07-16 18:57:36', 1, '2019-07-16 18:57:36', 0),
(10, 119, '345345', '', '', '653324234', '', 1, '', '', '', '', 1, 1, '2019-07-16 18:58:01', 1, '2019-07-16 18:58:01', 0),
(11, 119, '1', '2', '4', '3', '', 1, '5', '6', '', '8', 1, 1, '2019-07-16 19:07:16', 1, '2019-07-16 19:07:16', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_branch_status`
--

CREATE TABLE `crm3_branch_status` (
  `id` int(3) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_branch_status`
--

INSERT INTO `crm3_branch_status` (`id`, `name`) VALUES
(1, 'Active'),
(100, 'Non Active');

-- --------------------------------------------------------

--
-- Table structure for table `crm3_company`
--

CREATE TABLE `crm3_company` (
  `id` int(11) NOT NULL,
  `code_number` varchar(50) NOT NULL DEFAULT '',
  `id_company_class` int(3) NOT NULL DEFAULT 0,
  `id_user` int(11) NOT NULL DEFAULT 0,
  `name` varchar(250) NOT NULL DEFAULT '',
  `website` varchar(250) NOT NULL DEFAULT '',
  `email` varchar(250) NOT NULL DEFAULT '',
  `phone` varchar(250) NOT NULL DEFAULT '',
  `fax` varchar(250) NOT NULL DEFAULT '',
  `id_industry` int(4) NOT NULL DEFAULT 0,
  `bill_name` varchar(250) NOT NULL DEFAULT '',
  `bill_street1` text NOT NULL,
  `bill_street2` varchar(250) NOT NULL DEFAULT '',
  `bill_city` varchar(250) NOT NULL DEFAULT '',
  `bill_state` varchar(250) NOT NULL DEFAULT '',
  `bill_code` varchar(250) NOT NULL DEFAULT '',
  `bill_country` varchar(250) NOT NULL DEFAULT '',
  `ship_name` varchar(250) NOT NULL DEFAULT '',
  `ship_street1` varchar(250) NOT NULL DEFAULT '',
  `ship_street2` varchar(250) NOT NULL DEFAULT '',
  `ship_city` varchar(250) NOT NULL DEFAULT '',
  `ship_state` varchar(250) NOT NULL DEFAULT '',
  `ship_code` varchar(250) NOT NULL DEFAULT '',
  `ship_country` varchar(250) NOT NULL DEFAULT '',
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_company`
--

INSERT INTO `crm3_company` (`id`, `code_number`, `id_company_class`, `id_user`, `name`, `website`, `email`, `phone`, `fax`, `id_industry`, `bill_name`, `bill_street1`, `bill_street2`, `bill_city`, `bill_state`, `bill_code`, `bill_country`, `ship_name`, `ship_street1`, `ship_street2`, `ship_city`, `ship_state`, `ship_code`, `ship_country`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(192, '', 0, 118, 'RS Berdikari', '', 'bambang@rsberdikari.com', '', '', 0, '', 'Jl. Raya Bogor km 31', '', 'Jakarta', 'DKI Jakarta', '', 'Indonesia', '', '', '', '', '', '', '', 1, 1, '2020-08-26 14:49:06', 118, '2020-08-26 14:49:06', 0),
(193, '', 1, 118, 'RS Mulia', '', 'johny@rsmulia.co.id', '', '', 0, '', '', '', '', '', '', '', '', '', '', '', '', '', '', 1, 1, '2020-08-26 15:04:37', 118, '2020-08-26 15:04:37', 0),
(194, '', 2, 118, 'RS Mulia', '', 'johny@rsmulia.co.id', '', '', 0, '', '', '', '', '', '', '', '', '', '', '', '', '', '', 1, 1, '2020-08-26 15:17:50', 118, '2020-08-26 15:17:50', 0),
(195, '', 2, 118, 'RS Pinang', 'www.rspinang.com', 'michael.keaton@rspinang.com', '021-7919999', '-', 0, '', 'Jl. Pondok Pinang 10', '', '', '', '', '', '', '', '', '', '', '', '', 1, 1, '2020-08-26 16:16:38', 118, '2020-08-26 16:16:38', 0),
(196, '', 3, 118, 'Indoprima Bionet', 'www.indoprima.com', 'leo@indoprima.com', '021-5444444', '021-5445555', 3, '', 'Jl. Taman sari no 56', '', 'Jakarta', 'DKI Jakarta', '11100', 'Indonesia', '', '', '', '', '', '', '', 1, 1, '2020-08-27 12:05:15', 118, '2020-08-27 12:05:15', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_company_class`
--

CREATE TABLE `crm3_company_class` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_company_class`
--

INSERT INTO `crm3_company_class` (`id`, `name`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 'Retail', 1, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(2, 'Agent', 1, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(3, 'Distributor', 1, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(4, 'Partner', 1, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(5, 'Channel', 1, '2020-03-12 16:04:45', 1, '2020-03-12 16:04:45', 0),
(6, 'Franchise', 1, '2020-03-12 16:06:13', 1, '2020-03-12 16:06:13', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_company_class_price_list`
--

CREATE TABLE `crm3_company_class_price_list` (
  `id` int(11) NOT NULL,
  `id_company_class` int(11) NOT NULL DEFAULT 0,
  `id_product` int(11) NOT NULL DEFAULT 0,
  `price` float(10,0) NOT NULL DEFAULT 0,
  `input_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_company_class_price_list`
--

INSERT INTO `crm3_company_class_price_list` (`id`, `id_company_class`, `id_product`, `price`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(25, 6, 1, 0, '2020-03-12 16:07:33', 1, '2020-03-12 16:08:05', 1),
(27, 1, 2, 0, '2020-04-01 16:10:51', 103, '2020-04-01 16:10:52', 103);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_contact`
--

CREATE TABLE `crm3_contact` (
  `id` int(11) NOT NULL,
  `code_number` varchar(50) NOT NULL DEFAULT '',
  `id_company` int(11) NOT NULL DEFAULT 0,
  `id_user` int(6) NOT NULL DEFAULT 0,
  `id_title` int(6) NOT NULL DEFAULT 0,
  `first_name` varchar(250) NOT NULL DEFAULT '',
  `last_name` varchar(250) NOT NULL DEFAULT '',
  `position` varchar(250) NOT NULL DEFAULT '',
  `department` varchar(250) NOT NULL DEFAULT '',
  `email` varchar(250) NOT NULL DEFAULT '',
  `phone` varchar(250) NOT NULL DEFAULT '',
  `mobile` varchar(250) NOT NULL DEFAULT '',
  `sex` varchar(2) NOT NULL DEFAULT '',
  `birthdate` date NOT NULL DEFAULT '1980-01-01',
  `id_lead_source` int(5) NOT NULL DEFAULT 0,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_contact`
--

INSERT INTO `crm3_contact` (`id`, `code_number`, `id_company`, `id_user`, `id_title`, `first_name`, `last_name`, `position`, `department`, `email`, `phone`, `mobile`, `sex`, `birthdate`, `id_lead_source`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(153, '', 192, 118, 1, 'Bambang', '', 'Director', '', 'bambang@rsberdikari.com', '', '', '1', '1980-03-05', 2, 1, 1, '2020-08-26 14:49:06', 118, '2020-08-26 14:49:06', 0),
(154, '', 193, 118, 1, 'Johny', '', 'Purchasing Manager', 'Purchasing', 'johny@rsmulia.co.id', '', '08212121219', '1', '1980-03-05', 3, 1, 1, '2020-08-26 15:04:37', 118, '2020-08-26 15:04:37', 0),
(155, '', 194, 118, 1, 'Johny', '', '', '', 'johny@rsmulia.co.id', '', '', '1', '1980-03-05', 1, 1, 1, '2020-08-26 15:17:50', 118, '2020-08-26 15:17:50', 0),
(156, '', 195, 118, 1, 'Michael', 'Keaton', 'Director', 'NA', 'michael.keaton@rspinang.com', '021-7919999', '0823999999', '1', '1980-03-05', 1, 1, 1, '2020-08-26 16:16:38', 118, '2020-08-26 16:16:38', 0),
(157, '', 196, 118, 1, 'Leo', '-', 'Operational Director', 'Operation', 'leo@indoprima.com', '021-5444444', '08122222222', '1', '1980-03-05', 1, 1, 1, '2020-08-27 12:05:15', 118, '2020-08-27 12:05:15', 0),
(158, '', 196, 118, 1, 'Teddy', '-', 'Marketing Director', 'Marketing', 'teddy@indoprima.com', '021-5455555', '0811111111', '', '1980-01-01', 1, 1, 1, '2020-08-27 12:07:17', 118, '2020-08-27 12:07:17', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_currency`
--

CREATE TABLE `crm3_currency` (
  `id` int(6) NOT NULL,
  `isDefault` int(1) NOT NULL DEFAULT 0,
  `name` varchar(50) NOT NULL DEFAULT '',
  `symbol` varchar(4) NOT NULL DEFAULT '',
  `code` varchar(4) NOT NULL DEFAULT '',
  `value` float(9,0) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(6) NOT NULL DEFAULT 0,
  `input_by` int(6) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_currency`
--

INSERT INTO `crm3_currency` (`id`, `isDefault`, `name`, `symbol`, `code`, `value`, `input_date`, `update_date`, `update_by`, `input_by`) VALUES
(1, 1, 'Rupiah', 'Rp', 'IDR', 1, '2019-01-01 00:00:00', '2019-01-01 00:00:00', 0, 0),
(2, 0, 'US Dollar', '$', 'USD', 16000, '2020-04-08 09:56:28', '2020-04-08 09:57:24', 107, 107);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_global`
--

CREATE TABLE `crm3_global` (
  `id` int(11) NOT NULL,
  `name` varchar(250) DEFAULT '',
  `value` varchar(250) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_global`
--

INSERT INTO `crm3_global` (`id`, `name`, `value`) VALUES
(10, 'id_currency', '1');

-- --------------------------------------------------------

--
-- Table structure for table `crm3_industry`
--

CREATE TABLE `crm3_industry` (
  `id` int(11) NOT NULL,
  `name` varchar(250) NOT NULL DEFAULT '',
  `backgroundColor` varchar(250) NOT NULL DEFAULT '',
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_industry`
--

INSERT INTO `crm3_industry` (`id`, `name`, `backgroundColor`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(3, 'Manufactur', 'rgb(255, 206, 86)', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_label`
--

CREATE TABLE `crm3_label` (
  `id` int(11) NOT NULL,
  `id_module` int(4) NOT NULL DEFAULT 0,
  `name` varchar(50) NOT NULL DEFAULT '',
  `lang1` varchar(50) NOT NULL DEFAULT '',
  `lang2` varchar(50) NOT NULL DEFAULT '',
  `lang3` varchar(50) NOT NULL DEFAULT '',
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_label`
--

INSERT INTO `crm3_label` (`id`, `id_module`, `name`, `lang1`, `lang2`, `lang3`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 100, 'home', 'Home', 'Home', 'Home', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(2, 200, 'name', 'Name', 'Name', 'Name', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(3, 200, 'first_name', 'First Name', 'First Name', 'First Name', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(4, 200, 'last_name', 'Last Name', 'Last Name', 'Last Name', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(5, 200, 'mobile', 'Mobile', 'Mobile', 'Mobile', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(6, 200, 'phone', 'Phone', 'Phone', 'Phone', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(7, 200, 'email', 'Email', 'Email', 'Email', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(8, 200, 'lead_owner', 'Lead Owner', 'Lead Owner', 'Lead Owner', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(9, 200, 'lead_source', 'Lead Source', 'Lead Source', 'Lead Source', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(10, 0, 'create_date', 'create_date', 'create_date', 'create_date', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(11, 0, 'update_date', 'update_date', 'update_date', 'update_date', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(14, 200, 'lead_status', 'Lead Status', 'Lead Status', 'Lead Status', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(16, 0, 'print', 'Print', 'Print', 'Print', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(17, 0, 'search', 'Search', 'Search', 'Search', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(18, 0, 'new', 'New', 'New', 'New', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(19, 0, 'edit', 'Edit', 'Edit', 'Edit', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(20, 0, 'delete', 'Delete', 'Delete', 'Delete', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(21, 0, 'add', 'Add', 'Add', 'Add', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(22, 0, 'save', 'Save', 'Save', 'Save', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(23, 0, 'cancel', 'Cancel', 'Cancel', 'Cancel', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_lead`
--

CREATE TABLE `crm3_lead` (
  `id` int(11) NOT NULL,
  `isDuplicate` int(1) NOT NULL DEFAULT 0,
  `convert` int(1) NOT NULL DEFAULT 0,
  `id_user` int(6) NOT NULL DEFAULT 0,
  `id_company_class` int(6) NOT NULL DEFAULT 0,
  `id_lead_status` int(6) NOT NULL DEFAULT 1,
  `id_title` int(3) NOT NULL DEFAULT 0,
  `first_name` varchar(250) NOT NULL DEFAULT '',
  `last_name` varchar(250) NOT NULL DEFAULT '',
  `position` varchar(250) NOT NULL DEFAULT '',
  `department` varchar(250) NOT NULL DEFAULT '',
  `company` varchar(250) NOT NULL DEFAULT '',
  `id_company` int(6) NOT NULL DEFAULT 0,
  `id_lead_source` int(3) NOT NULL DEFAULT 1,
  `id_industry` int(3) NOT NULL DEFAULT 1,
  `website` varchar(250) NOT NULL DEFAULT '',
  `email` varchar(250) NOT NULL DEFAULT '',
  `mobile` varchar(250) NOT NULL DEFAULT '',
  `phone` varchar(250) NOT NULL DEFAULT '',
  `fax` varchar(250) NOT NULL DEFAULT '',
  `opportunity` varchar(250) NOT NULL DEFAULT '',
  `amount` float(10,0) NOT NULL DEFAULT 0,
  `address_street` text NOT NULL,
  `address_city` varchar(250) NOT NULL DEFAULT '',
  `address_state` varchar(250) NOT NULL DEFAULT '',
  `address_code` varchar(250) NOT NULL DEFAULT '',
  `address_country` varchar(250) NOT NULL DEFAULT '',
  `sex` varchar(2) NOT NULL DEFAULT '',
  `birthdate` date NOT NULL DEFAULT '2020-01-01',
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_lead`
--

INSERT INTO `crm3_lead` (`id`, `isDuplicate`, `convert`, `id_user`, `id_company_class`, `id_lead_status`, `id_title`, `first_name`, `last_name`, `position`, `department`, `company`, `id_company`, `id_lead_source`, `id_industry`, `website`, `email`, `mobile`, `phone`, `fax`, `opportunity`, `amount`, `address_street`, `address_city`, `address_state`, `address_code`, `address_country`, `sex`, `birthdate`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1125, 0, 1, 118, 2, 2, 1, 'Michael', 'Keaton', 'Director', 'NA', 'RS Pinang', 0, 1, 0, 'www.rspinang.com', 'michael.keaton@rspinang.com', '0823999999', '021-7919999', '-', '', 0, 'Jl. Pondok Pinang 10', '', '', '', '', '1', '1980-03-05', 1, 0, '2020-07-21 16:22:57', 118, '2020-07-21 16:22:57', 0),
(1126, 0, 0, 118, 0, 1, 2, 'Keisha', '-', 'General Manager', '', 'Klinik Manjur', 0, 1, 3, '', 'keisha@klinikmanjur.com', '081111999', '021-6590000', '', '', 0, 'Jl. KH Hasyim Ashari 123', 'Jakarta', 'DKI Jakarta', '', 'Indonesia', '2', '1980-03-05', 1, 1, '2020-07-22 09:34:23', 118, '2020-07-22 20:56:44', 118),
(1127, 0, 1, 118, 0, 2, 1, 'Bambang', '', 'Director', '', 'RS Berdikari', 0, 2, 0, '', 'bambang@rsberdikari.com', '', '', '', '', 0, 'Jl. Raya Bogor km 31', 'Jakarta', 'DKI Jakarta', '', 'Indonesia', '1', '1980-03-05', 1, 0, '2020-07-23 08:04:35', 118, '2020-07-23 08:04:35', 0),
(1128, 0, 1, 118, 1, 2, 1, 'Johny', '', 'Purchasing Manager', 'Purchasing', 'RS Mulia', 0, 3, 0, '', 'johny@rsmulia.co.id', '08212121219', '', '', '', 0, '', '', '', '', '', '1', '1980-03-05', 1, 0, '2020-08-26 14:56:26', 118, '2020-08-26 14:56:26', 0),
(1129, 0, 1, 118, 2, 2, 1, 'Johny', '', '', '', 'RS Mulia', 0, 1, 0, '', 'johny@rsmulia.co.id', '', '', '', '', 0, '', '', '', '', '', '1', '1980-03-05', 1, 0, '2020-08-26 15:14:27', 118, '2020-08-26 15:14:27', 0),
(1130, 0, 0, 118, 1, 2, 1, 'Rezky', '-', 'Director', '', 'Klinik Sehat', 0, 1, 0, '', 'rezky@kliniksehat.com', '', '021-648009', '', '', 0, '', '', '', '', '', '1', '1980-03-05', 1, 1, '2020-08-26 16:20:30', 118, '2020-08-26 16:20:30', 0),
(1131, 0, 1, 118, 3, 4, 1, 'Leo', '-', 'Operational Director', 'Operation', 'Indoprima Bionet', 0, 1, 3, 'www.indoprima.com', 'leo@indoprima.com', '08122222222', '021-5444444', '021-5445555', '', 0, 'Jl. Taman sari no 56', 'Jakarta', 'DKI Jakarta', '11100', 'Indonesia', '1', '1980-03-05', 1, 0, '2020-08-27 11:50:27', 118, '2020-08-27 12:01:47', 118);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_lead_convert`
--

CREATE TABLE `crm3_lead_convert` (
  `id` int(11) NOT NULL,
  `id_user` int(6) NOT NULL DEFAULT 0,
  `id_lead` int(6) NOT NULL DEFAULT 0,
  `id_company` int(6) NOT NULL DEFAULT 0,
  `id_contact` int(6) NOT NULL DEFAULT 0,
  `id_opportunity` int(6) NOT NULL DEFAULT 0,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `convert_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `convert_by` int(11) NOT NULL DEFAULT 0,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_lead_convert`
--

INSERT INTO `crm3_lead_convert` (`id`, `id_user`, `id_lead`, `id_company`, `id_contact`, `id_opportunity`, `status`, `presence`, `convert_date`, `convert_by`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(57, 118, 1127, 192, 153, 208, 1, 1, '2020-08-26 14:49:06', 118, '2020-08-26 14:49:06', 118, '2020-08-26 14:49:06', 0),
(58, 118, 1128, 193, 154, 209, 1, 1, '2020-08-26 15:04:37', 118, '2020-08-26 15:04:37', 118, '2020-08-26 15:04:37', 0),
(59, 118, 1129, 194, 155, 210, 1, 1, '2020-08-26 15:17:50', 118, '2020-08-26 15:17:50', 118, '2020-08-26 15:17:50', 0),
(60, 118, 1125, 195, 156, 211, 1, 1, '2020-08-26 16:16:38', 118, '2020-08-26 16:16:38', 118, '2020-08-26 16:16:38', 0),
(61, 118, 1131, 196, 157, 212, 1, 1, '2020-08-27 12:05:15', 118, '2020-08-27 12:05:15', 118, '2020-08-27 12:05:15', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_lead_product`
--

CREATE TABLE `crm3_lead_product` (
  `id` int(11) NOT NULL,
  `id_lead` int(11) NOT NULL DEFAULT 0,
  `id_product` int(11) NOT NULL DEFAULT 0,
  `id_price_list` int(11) NOT NULL DEFAULT 0,
  `price` float(12,0) NOT NULL DEFAULT 0,
  `qty` int(6) NOT NULL DEFAULT 0,
  `discount` float(2,0) NOT NULL DEFAULT 0,
  `total` float(12,0) NOT NULL DEFAULT 0,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_lead_product`
--

INSERT INTO `crm3_lead_product` (`id`, `id_lead`, `id_product`, `id_price_list`, `price`, `qty`, `discount`, `total`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 1131, 6, 0, 50000, 1, 0, 50000, 1, 1, '2020-08-27 12:02:01', 118, '2020-08-27 12:02:01', 0),
(2, 1131, 4, 0, 35000, 1, 0, 35000, 1, 1, '2020-08-27 12:02:01', 118, '2020-08-27 12:02:01', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_lead_source`
--

CREATE TABLE `crm3_lead_source` (
  `id` int(11) NOT NULL,
  `name` varchar(250) NOT NULL DEFAULT '',
  `backgroundColor` varchar(50) NOT NULL DEFAULT 'rgb(136,199,201)',
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_lead_source`
--

INSERT INTO `crm3_lead_source` (`id`, `name`, `backgroundColor`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 'Database', 'rgb(98,160,203)', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(2, 'Refferal', 'rgb(75,192,192)', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(3, 'Call Out', 'rgb(255,206,86)', 1, 1, '2020-03-07 15:00:30', 1, '2020-03-07 15:00:30', 0),
(4, 'Call In', 'rgb(255,159,64)', 1, 1, '2020-03-07 15:00:44', 1, '2020-03-07 15:00:44', 0),
(5, 'Event', 'rgb(153,102,255)', 1, 1, '2020-03-07 15:02:17', 1, '2020-03-07 15:02:17', 0),
(6, 'Website', 'rgb(255,99,132)', 1, 1, '2020-03-07 15:02:23', 1, '2020-03-07 15:02:23', 0),
(7, 'Strategic Partner', 'rgb(136,199,201)', 1, 1, '2020-03-24 09:46:57', 1, '2020-03-24 09:46:57', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_lead_status`
--

CREATE TABLE `crm3_lead_status` (
  `id` int(11) NOT NULL,
  `name` varchar(250) NOT NULL DEFAULT '',
  `value` int(3) NOT NULL DEFAULT 0,
  `color` varchar(50) NOT NULL DEFAULT '',
  `ilock` int(1) NOT NULL DEFAULT 0,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_lead_status`
--

INSERT INTO `crm3_lead_status` (`id`, `name`, `value`, `color`, `ilock`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 'Low', 0, 'light', 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(2, 'Normal', 25, 'green', 0, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(3, 'High', 50, 'brown', 0, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(4, 'Priority', 90, 'red', 0, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_module`
--

CREATE TABLE `crm3_module` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '',
  `lang1` varchar(50) NOT NULL DEFAULT '',
  `lang2` varchar(50) NOT NULL DEFAULT '',
  `lang3` varchar(50) NOT NULL DEFAULT '',
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_module`
--

INSERT INTO `crm3_module` (`id`, `name`, `lang1`, `lang2`, `lang3`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(100, 'user', 'User', 'User', 'User', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(110, 'accessRight', 'Access Right', 'Access Right', 'Access Right', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(111, 'accessData', 'Access Data', 'Access Data', 'Access Data', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(200, 'lead', 'Lead', 'Lead', 'Lead', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(300, 'contact', 'Contact', 'Contact', 'Contact', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(400, 'company', 'Company', 'Company', 'Company', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(410, 'companyClass', 'Company Class', 'Company Class', 'Company Class', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(411, 'CCPriceList', 'Class Price List', 'Class Price List', 'Class Price List', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(500, 'opportunity', 'Opportunity', 'Opportunity', 'Opportunity', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(510, 'lost', 'Closed Lost', 'Closed Lost', 'Closed Lost', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(520, 'deal', 'Deal', 'Deal', 'Deal', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(550, 'salesOrder', 'Sales Order', 'Sales Order', 'Sales Order', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(600, 'activity', 'Activity', 'Activity', 'Activity', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(700, 'product', 'Product', 'Product', 'Product', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(710, 'priceList', 'Price List', 'Price List', 'Price List', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(800, 'quote', 'Quotation', 'Quotation', 'Quotation', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(1000, 'master', 'Master Data', 'Master Data', 'Master Data', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(2001, 'po', 'Purchased Order', 'Purchased Order', 'Purchased Order', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_number`
--

CREATE TABLE `crm3_number` (
  `id` int(4) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '',
  `runing_number` int(9) NOT NULL DEFAULT 0,
  `digit` int(9) NOT NULL DEFAULT 1,
  `rules` varchar(50) NOT NULL DEFAULT '',
  `latest_request_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `latest_request_by` int(9) NOT NULL DEFAULT 0,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(6) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(6) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_number`
--

INSERT INTO `crm3_number` (`id`, `name`, `runing_number`, `digit`, `rules`, `latest_request_date`, `latest_request_by`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 'lead', 1131, 1, '', '2020-08-27 11:50:27', 118, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(2, 'company', 196, 1, '', '2020-08-27 12:05:15', 118, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(3, 'contact', 158, 5, 'CONT', '2020-08-27 12:07:17', 118, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(4, 'branch', 11, 1, '', '2019-07-16 19:07:16', 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(5, 'opportunity', 212, 1, '', '2020-08-27 12:05:15', 118, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(6, 'lead_convert', 61, 1, '', '2020-08-27 12:05:15', 118, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(7, 'activity', 216, 1, '', '2020-01-22 00:04:46', 7, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(8, 'quote', 53, 6, '', '2020-08-27 12:10:18', 118, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(9, 'sales_order', 61, 6, '', '2020-08-27 12:19:14', 118, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(10, 'deal', 0, 1, '', '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(11, 'user', 119, 1, '', '2020-08-25 15:12:38', 118, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_opportunity`
--

CREATE TABLE `crm3_opportunity` (
  `id` int(11) NOT NULL,
  `code_number` varchar(50) NOT NULL DEFAULT '',
  `closed` int(1) NOT NULL DEFAULT 0,
  `id_closed_reason` int(1) NOT NULL DEFAULT 0,
  `id_stage` int(6) NOT NULL DEFAULT 0,
  `id_opportunity_business` int(3) NOT NULL DEFAULT 0,
  `id_user` int(6) NOT NULL DEFAULT 0,
  `id_lead` int(6) NOT NULL DEFAULT 0,
  `id_contact` int(6) NOT NULL DEFAULT 0,
  `id_company` int(6) NOT NULL DEFAULT 0,
  `id_currency` int(2) NOT NULL DEFAULT 1,
  `id_quote` int(8) NOT NULL DEFAULT 0,
  `sales_order` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(250) NOT NULL DEFAULT '',
  `amount` decimal(15,0) NOT NULL DEFAULT 0,
  `id_lead_source` int(6) NOT NULL DEFAULT 0,
  `start_date` date NOT NULL DEFAULT '2019-01-01',
  `expecting_closing_date` date NOT NULL DEFAULT '2019-01-01',
  `budget` int(11) NOT NULL DEFAULT 0,
  `closed_date` date NOT NULL DEFAULT '2019-01-01',
  `competitor` text NOT NULL,
  `comparison_with_competitor` text NOT NULL,
  `critical_point` text NOT NULL,
  `our_proposal` text NOT NULL,
  `other` text NOT NULL,
  `po` text NOT NULL,
  `notes1` text NOT NULL,
  `notes2` text NOT NULL,
  `notes3` text NOT NULL,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_opportunity`
--

INSERT INTO `crm3_opportunity` (`id`, `code_number`, `closed`, `id_closed_reason`, `id_stage`, `id_opportunity_business`, `id_user`, `id_lead`, `id_contact`, `id_company`, `id_currency`, `id_quote`, `sales_order`, `name`, `amount`, `id_lead_source`, `start_date`, `expecting_closing_date`, `budget`, `closed_date`, `competitor`, `comparison_with_competitor`, `critical_point`, `our_proposal`, `other`, `po`, `notes1`, `notes2`, `notes3`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(208, '', 1, 11, 1000, 0, 118, 1127, 153, 192, 1, 1, '', 'RS Berdikari - Rectal Tube & Blood Collecting Needle', 0, 2, '2020-08-26', '2020-08-31', 0, '2020-08-26', 'NA', 'NA', 'Price', 'Reviewed', '', '', 'NA', 'Approved by customer', 'Approved di diskon 10%', 1, 1, '2020-08-26 14:49:06', 118, '2020-08-26 14:54:05', 118),
(209, '', 1, 7, 1000, 0, 118, 1128, 154, 193, 1, 2, '', 'RS Mulia - Automatic Pressure Infusor', 2500000, 3, '2020-08-26', '2020-08-31', 0, '2020-08-26', '', 'kualitas barang', 'kualitas barang', '', '', '', '', 'Closed win tanpa nego karena cocok dengan barangnya', '', 1, 1, '2020-08-26 15:04:37', 118, '2020-08-26 15:07:31', 118),
(210, '', 1, 12, 3000, 0, 118, 1129, 155, 194, 1, 3, '', 'RS Mulia - Syringe', 250000, 1, '2020-08-26', '2020-08-28', 0, '2020-08-26', '', 'Quality & Price', 'Quality', '', '', '', '', 'Quote direject karena harganya kemahalan', '', 1, 1, '2020-08-26 15:17:50', 118, '2020-08-26 15:22:45', 118),
(211, '', 0, 0, 103, 0, 118, 1125, 156, 195, 1, 0, '', 'RS Pinang - Closed Suction Chateter', 5000000, 1, '2020-08-26', '2020-08-27', 0, '2019-01-01', 'ada produk dari vendor lain tapi tidak mau info dulu', 'NA', 'NA', '', '', '', '', '', '', 1, 1, '2020-08-26 16:16:38', 118, '2020-08-26 16:17:10', 118),
(212, '', 1, 11, 1000, 0, 118, 1131, 157, 196, 1, 5, '', 'Indoprima - Chateter', 500000, 1, '2020-08-27', '2020-08-31', 350000, '2020-08-27', '', 'Price', 'Price', 'Tawarkan Chateter special discont', '', '', '-', 'Quote approved', 'Approved', 1, 1, '2020-08-27 12:05:15', 118, '2020-08-27 12:13:47', 118);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_opportunity_business`
--

CREATE TABLE `crm3_opportunity_business` (
  `id` int(4) NOT NULL,
  `name` varchar(250) NOT NULL DEFAULT '',
  `presence` int(9) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `input_by` int(9) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `update_by` int(9) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_opportunity_business`
--

INSERT INTO `crm3_opportunity_business` (`id`, `name`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 'New Business', 1, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(2, 'Existing Business', 1, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_opportunity_closed_reason`
--

CREATE TABLE `crm3_opportunity_closed_reason` (
  `id` int(9) NOT NULL,
  `note` varchar(250) DEFAULT '',
  `closed_win` int(1) DEFAULT 1,
  `presence` int(1) DEFAULT 1,
  `input_date` datetime DEFAULT '2020-01-01 00:00:00',
  `update_date` datetime DEFAULT '2020-01-01 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_opportunity_closed_reason`
--

INSERT INTO `crm3_opportunity_closed_reason` (`id`, `note`, `closed_win`, `presence`, `input_date`, `update_date`) VALUES
(7, 'Menang Baik', 1, 1, '2020-03-31 01:21:14', '2020-03-31 01:21:14'),
(8, 'Menang karena sales hebat', 1, 1, '2020-03-31 01:21:39', '2020-03-31 01:21:39'),
(9, 'Gagal Total', 0, 1, '2020-03-31 01:21:45', '2020-03-31 01:21:45'),
(10, 'Kompetitor hebat', 0, 1, '2020-03-31 01:21:53', '2020-03-31 01:21:53'),
(11, 'Good Price', 1, 1, '2020-04-08 10:42:25', '2020-04-08 10:42:25'),
(12, 'Not Competitive Price', 0, 1, '2020-04-08 10:42:49', '2020-04-08 10:42:49');

-- --------------------------------------------------------

--
-- Table structure for table `crm3_opportunity_log`
--

CREATE TABLE `crm3_opportunity_log` (
  `id` int(11) NOT NULL,
  `id_opportunity` int(6) NOT NULL DEFAULT 0,
  `id_user` int(6) NOT NULL DEFAULT 0,
  `id_stage` int(6) NOT NULL DEFAULT 0,
  `id_currency` int(3) NOT NULL DEFAULT 0,
  `amount` float(12,0) NOT NULL DEFAULT 0,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_opportunity_log`
--

INSERT INTO `crm3_opportunity_log` (`id`, `id_opportunity`, `id_user`, `id_stage`, `id_currency`, `amount`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 208, 118, 100, 1, 0, 1, 1, '2020-08-26 14:49:33', 118, '2020-08-26 14:49:33', 0),
(2, 208, 118, 101, 1, 0, 1, 1, '2020-08-26 14:49:53', 118, '2020-08-26 14:49:53', 0),
(3, 208, 118, 103, 1, 0, 1, 1, '2020-08-26 14:53:48', 118, '2020-08-26 14:53:48', 0),
(4, 209, 118, 100, 1, 2500000, 1, 1, '2020-08-26 15:04:55', 118, '2020-08-26 15:04:55', 0),
(5, 209, 118, 101, 1, 2500000, 1, 1, '2020-08-26 15:05:22', 118, '2020-08-26 15:05:22', 0),
(6, 209, 118, 103, 1, 2500000, 1, 1, '2020-08-26 15:07:19', 118, '2020-08-26 15:07:19', 0),
(7, 210, 118, 100, 1, 250000, 1, 1, '2020-08-26 15:18:35', 118, '2020-08-26 15:18:35', 0),
(8, 210, 118, 101, 1, 250000, 1, 1, '2020-08-26 15:18:54', 118, '2020-08-26 15:18:54', 0),
(9, 210, 118, 103, 1, 250000, 1, 1, '2020-08-26 15:22:35', 118, '2020-08-26 15:22:35', 0),
(10, 211, 118, 100, 1, 5000000, 1, 1, '2020-08-26 16:17:04', 118, '2020-08-26 16:17:04', 0),
(11, 211, 118, 101, 1, 5000000, 1, 1, '2020-08-26 16:17:10', 118, '2020-08-26 16:17:10', 0),
(12, 212, 118, 100, 1, 500000, 1, 1, '2020-08-27 12:08:35', 118, '2020-08-27 12:08:35', 0),
(13, 212, 118, 101, 1, 500000, 1, 1, '2020-08-27 12:09:07', 118, '2020-08-27 12:09:07', 0),
(14, 212, 118, 103, 1, 500000, 1, 1, '2020-08-27 12:13:25', 118, '2020-08-27 12:13:25', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_opportunity_product`
--

CREATE TABLE `crm3_opportunity_product` (
  `id` int(11) NOT NULL,
  `id_opportunity` int(11) NOT NULL DEFAULT 0,
  `id_product` int(11) NOT NULL DEFAULT 0,
  `id_price_list` int(11) NOT NULL DEFAULT 0,
  `price` float(12,0) NOT NULL DEFAULT 0,
  `qty` int(6) NOT NULL DEFAULT 0,
  `discount` float(2,0) NOT NULL DEFAULT 0,
  `total` float(12,0) NOT NULL DEFAULT 0,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_opportunity_product`
--

INSERT INTO `crm3_opportunity_product` (`id`, `id_opportunity`, `id_product`, `id_price_list`, `price`, `qty`, `discount`, `total`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 208, 1, 0, 5000, 1, 0, 5000, 1, 1, '2020-08-26 14:49:24', 118, '2020-08-26 14:49:24', 0),
(2, 208, 2, 0, 10000, 1, 0, 10000, 1, 1, '2020-08-26 14:49:24', 118, '2020-08-26 14:49:24', 0),
(3, 210, 3, 0, 2500, 1, 0, 2500, 1, 1, '2020-08-26 15:18:29', 118, '2020-08-26 15:18:29', 0),
(4, 212, 6, 0, 50000, 1, 0, 50000, 1, 1, '2020-08-27 12:02:01', 0, '2020-08-27 12:02:01', 0),
(5, 212, 4, 0, 35000, 1, 0, 35000, 1, 1, '2020-08-27 12:02:01', 0, '2020-08-27 12:02:01', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_opportunity_quiz`
--

CREATE TABLE `crm3_opportunity_quiz` (
  `id` int(9) NOT NULL,
  `id_opportunity` int(9) NOT NULL DEFAULT 0,
  `id_stage` int(4) NOT NULL DEFAULT 0,
  `name` varchar(200) NOT NULL DEFAULT '',
  `value` text NOT NULL,
  `input_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `input_by` int(9) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `update_by` int(9) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `crm3_opportunity_stage`
--

CREATE TABLE `crm3_opportunity_stage` (
  `id` int(5) NOT NULL,
  `id_next` int(5) NOT NULL DEFAULT 0,
  `name` varchar(50) NOT NULL DEFAULT '',
  `progress` int(3) NOT NULL DEFAULT 0,
  `weight` int(3) NOT NULL DEFAULT 0,
  `ilock` int(1) NOT NULL DEFAULT 0,
  `won` int(1) NOT NULL DEFAULT 0,
  `notes` text NOT NULL,
  `selectable` int(1) NOT NULL DEFAULT 1,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_opportunity_stage`
--

INSERT INTO `crm3_opportunity_stage` (`id`, `id_next`, `name`, `progress`, `weight`, `ilock`, `won`, `notes`, `selectable`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(10, 100, 'New', 1, 0, 1, 0, 'New Opportunity', 0, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(100, 101, 'Prospecting', 10, 10, 0, 0, 'Map out your sales process, his means actively defining the specific phases of your sales process and determining which of them you will reflect in your Salesforce Opportunity Stages', 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(101, 103, 'Analysis', 30, 20, 0, 0, 'Define entrance and exit criteria for each stage\r\nAn opportunity stage is not a one-off milestone, as it includes a number of key tasks to be completed before moving to the next stage', 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(103, 104, 'Proposal', 50, 40, 0, 0, 'Customize options for opportunities to help your sales reps close deals faster.', 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(104, 0, 'Negotiation', 80, 30, 0, 0, 'Revise your opportunity stages\r\nSince sales process evolves and may significantly change with time, you should periodically revisit your sales process to ensure your opportunity stages are still relevant.', 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(1000, 0, 'Closed Deal', 100, 0, 1, 1, '', 0, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(3000, 0, 'Closed Lost', 99, 0, 1, 0, '', 0, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_opportunity_stage_done`
--

CREATE TABLE `crm3_opportunity_stage_done` (
  `id` int(11) NOT NULL,
  `id_opportunity` int(6) NOT NULL DEFAULT 0,
  `id_stage` int(6) NOT NULL DEFAULT 0,
  `done` int(1) NOT NULL DEFAULT 0,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_opportunity_stage_done`
--

INSERT INTO `crm3_opportunity_stage_done` (`id`, `id_opportunity`, `id_stage`, `done`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 170, 100, 1, 1, 1, '2020-03-07 14:28:56', 1, '2020-03-07 14:28:56', 0),
(2, 170, 101, 1, 1, 1, '2020-03-07 14:34:12', 1, '2020-03-07 14:34:12', 0),
(3, 170, 103, 1, 1, 1, '2020-03-07 14:46:42', 1, '2020-03-07 14:47:27', 1),
(4, 170, 104, 1, 1, 1, '2020-03-07 14:48:33', 1, '2020-03-07 14:48:33', 0),
(5, 170, 1000, 1, 1, 1, '2020-03-07 14:48:33', 1, '2020-03-07 14:48:33', 0),
(6, 171, 100, 1, 1, 1, '2020-03-09 09:28:56', 103, '2020-03-09 09:28:56', 0),
(7, 171, 101, 1, 1, 1, '2020-03-09 09:29:30', 103, '2020-03-09 09:29:30', 0),
(8, 171, 103, 1, 1, 1, '2020-03-09 09:29:48', 103, '2020-03-09 09:29:48', 0),
(9, 171, 104, 1, 1, 1, '2020-03-09 09:33:21', 103, '2020-04-13 14:00:50', 103),
(10, 171, 1000, 1, 1, 1, '2020-03-09 09:33:21', 103, '2020-03-09 09:33:21', 0),
(11, 172, 100, 1, 1, 1, '2020-03-09 09:51:57', 103, '2020-03-09 09:51:57', 0),
(12, 172, 101, 1, 1, 1, '2020-03-09 09:52:19', 103, '2020-03-09 09:52:19', 0),
(13, 172, 103, 1, 1, 1, '2020-03-09 09:53:03', 103, '2020-03-09 09:53:03', 0),
(14, 173, 100, 1, 1, 1, '2020-03-12 15:44:21', 1, '2020-03-12 15:44:21', 0),
(15, 173, 101, 1, 1, 1, '2020-03-12 15:44:22', 1, '2020-03-12 15:44:22', 0),
(16, 173, 103, 1, 1, 1, '2020-03-12 15:49:46', 1, '2020-03-12 15:49:46', 0),
(17, 173, 104, 1, 1, 1, '2020-03-12 15:49:51', 1, '2020-03-12 15:49:51', 0),
(18, 173, 1000, 1, 1, 1, '2020-03-12 15:49:51', 1, '2020-03-12 15:49:51', 0),
(19, 177, 100, 1, 1, 1, '2020-03-23 14:39:17', 103, '2020-03-23 14:39:17', 0),
(20, 177, 101, 1, 1, 1, '2020-03-23 14:50:56', 103, '2020-03-23 14:50:56', 0),
(21, 177, 103, 1, 1, 1, '2020-03-23 14:51:08', 103, '2020-03-23 14:51:08', 0),
(22, 177, 104, 1, 1, 1, '2020-03-23 14:51:35', 103, '2020-03-23 14:51:35', 0),
(23, 177, 3000, 1, 1, 1, '2020-03-23 14:51:35', 103, '2020-03-23 14:51:35', 0),
(24, 178, 100, 1, 1, 1, '2020-03-23 17:30:36', 103, '2020-03-23 17:30:36', 0),
(25, 178, 101, 1, 1, 1, '2020-03-23 17:30:39', 103, '2020-03-23 17:30:39', 0),
(26, 178, 103, 1, 1, 1, '2020-03-23 17:31:05', 103, '2020-03-23 17:31:05', 0),
(27, 178, 104, 1, 1, 1, '2020-03-23 17:31:14', 103, '2020-03-23 17:31:14', 0),
(28, 178, 1000, 1, 1, 1, '2020-03-23 17:31:14', 103, '2020-03-23 17:31:14', 0),
(29, 180, 100, 1, 1, 1, '2020-03-27 11:05:00', 103, '2020-03-27 11:21:43', 103),
(30, 180, 101, 1, 1, 1, '2020-03-27 11:05:44', 103, '2020-03-27 11:21:56', 103),
(31, 180, 103, 1, 1, 1, '2020-03-27 11:21:06', 103, '2020-03-27 11:21:06', 0),
(32, 180, 104, 1, 1, 1, '2020-03-27 11:21:17', 103, '2020-03-27 11:32:38', 103),
(33, 180, 1000, 1, 1, 1, '2020-03-27 11:21:17', 103, '2020-03-27 11:32:39', 103),
(34, 181, 100, 1, 1, 1, '2020-04-01 15:30:39', 103, '2020-04-01 15:30:39', 0),
(35, 181, 101, 1, 1, 1, '2020-04-01 15:31:13', 103, '2020-04-01 15:31:13', 0),
(36, 181, 103, 1, 1, 1, '2020-04-01 15:31:23', 103, '2020-04-01 15:31:23', 0),
(37, 181, 104, 1, 1, 1, '2020-04-01 15:35:46', 103, '2020-04-01 15:35:46', 0),
(38, 182, 100, 1, 1, 1, '2020-04-01 16:13:49', 103, '2020-04-01 16:13:49', 0),
(39, 182, 101, 1, 1, 1, '2020-04-01 16:14:22', 103, '2020-04-01 16:14:22', 0),
(40, 182, 103, 1, 1, 1, '2020-04-01 16:14:32', 103, '2020-04-01 16:14:32', 0),
(41, 182, 104, 1, 1, 1, '2020-04-01 16:38:12', 103, '2020-04-01 16:38:17', 103),
(42, 183, 100, 1, 1, 1, '2020-04-01 17:22:11', 107, '2020-04-01 17:22:11', 0),
(43, 183, 101, 1, 1, 1, '2020-04-01 17:23:12', 107, '2020-04-01 17:23:12', 0),
(44, 183, 103, 1, 1, 1, '2020-04-01 17:29:55', 107, '2020-04-01 17:29:55', 0),
(45, 183, 104, 1, 1, 1, '2020-04-01 17:30:44', 107, '2020-04-01 17:30:44', 0),
(46, 184, 100, 1, 1, 1, '2020-04-02 14:50:06', 103, '2020-04-02 14:50:06', 0),
(47, 184, 101, 1, 1, 1, '2020-04-02 14:50:14', 103, '2020-04-02 14:50:14', 0),
(48, 184, 103, 1, 1, 1, '2020-04-02 14:53:23', 103, '2020-04-02 14:53:23', 0),
(49, 184, 104, 1, 1, 1, '2020-04-02 15:03:49', 103, '2020-04-02 15:03:49', 0),
(50, 185, 100, 1, 1, 1, '2020-04-02 16:53:38', 108, '2020-04-02 16:56:15', 108),
(51, 185, 101, 1, 1, 1, '2020-04-02 16:57:03', 108, '2020-04-02 16:57:03', 0),
(52, 185, 103, 1, 1, 1, '2020-04-02 17:01:18', 108, '2020-04-02 17:01:18', 0),
(53, 185, 104, 1, 1, 1, '2020-04-02 17:01:48', 108, '2020-04-02 17:01:48', 0),
(54, 186, 100, 1, 1, 1, '2020-04-03 11:30:04', 108, '2020-04-03 11:30:04', 0),
(55, 186, 101, 1, 1, 1, '2020-04-03 11:30:11', 108, '2020-04-03 11:30:11', 0),
(56, 186, 103, 1, 1, 1, '2020-04-03 11:30:26', 108, '2020-04-03 11:30:26', 0),
(57, 186, 104, 1, 1, 1, '2020-04-03 11:35:04', 108, '2020-04-03 11:35:04', 0),
(58, 187, 100, 1, 1, 1, '2020-04-03 15:56:46', 108, '2020-04-03 15:56:46', 0),
(59, 188, 100, 1, 1, 1, '2020-04-06 10:47:36', 108, '2020-04-06 10:47:36', 0),
(60, 188, 101, 1, 1, 1, '2020-04-06 11:07:36', 108, '2020-04-06 11:07:36', 0),
(61, 188, 103, 1, 1, 1, '2020-04-06 11:09:52', 108, '2020-04-06 11:09:52', 0),
(62, 188, 104, 1, 1, 1, '2020-04-06 11:48:29', 108, '2020-04-06 11:48:29', 0),
(63, 187, 103, 1, 1, 1, '2020-04-06 11:55:23', 108, '2020-04-06 11:55:23', 0),
(64, 187, 104, 1, 1, 1, '2020-04-06 11:55:31', 108, '2020-04-06 11:55:31', 0),
(65, 189, 100, 1, 1, 1, '2020-04-06 16:40:37', 108, '2020-04-06 16:40:37', 0),
(66, 189, 101, 1, 1, 1, '2020-04-06 16:40:41', 108, '2020-04-06 16:40:41', 0),
(67, 189, 103, 1, 1, 1, '2020-04-06 16:40:52', 108, '2020-04-06 16:40:52', 0),
(68, 189, 104, 1, 1, 1, '2020-04-06 16:40:59', 108, '2020-04-06 16:40:59', 0),
(69, 190, 100, 1, 1, 1, '2020-04-07 14:18:31', 108, '2020-04-07 14:18:31', 0),
(70, 190, 101, 1, 1, 1, '2020-04-07 15:12:59', 108, '2020-04-07 15:12:59', 0),
(71, 190, 103, 1, 1, 1, '2020-04-07 15:13:23', 108, '2020-04-07 15:13:23', 0),
(72, 190, 104, 1, 1, 1, '2020-04-07 15:17:14', 108, '2020-04-07 15:17:14', 0),
(73, 193, 101, 1, 1, 1, '2020-04-07 15:17:26', 106, '2020-04-07 15:17:32', 106),
(74, 193, 100, 1, 1, 1, '2020-04-07 15:17:29', 106, '2020-04-07 15:17:29', 0),
(75, 193, 103, 1, 1, 1, '2020-04-07 15:27:09', 106, '2020-04-07 15:27:09', 0),
(76, 193, 104, 1, 1, 1, '2020-04-07 15:27:28', 106, '2020-04-07 15:27:28', 0),
(77, 194, 100, 1, 1, 1, '2020-04-07 17:04:53', 107, '2020-04-07 17:04:53', 0),
(78, 194, 101, 1, 1, 1, '2020-04-07 17:05:20', 107, '2020-04-07 17:05:20', 0),
(79, 199, 101, 1, 1, 1, '2020-04-14 11:30:39', 103, '2020-04-14 11:30:39', 0),
(80, 179, 101, 1, 1, 1, '2020-06-10 00:03:48', 1, '2020-06-10 00:04:24', 1),
(81, 179, 100, 1, 1, 1, '2020-06-10 00:03:50', 1, '2020-06-10 00:04:23', 1),
(82, 179, 103, 1, 1, 1, '2020-06-11 22:16:58', 1, '2020-06-11 22:16:58', 0),
(83, 194, 103, 1, 1, 1, '2020-06-16 09:35:11', 107, '2020-06-16 09:35:11', 0),
(84, 194, 104, 1, 1, 1, '2020-06-16 09:35:58', 107, '2020-06-16 09:35:58', 0),
(85, 179, 104, 1, 1, 1, '2020-06-16 15:51:28', 1, '2020-06-16 15:52:10', 1),
(86, 200, 100, 1, 1, 1, '2020-06-19 13:11:37', 1, '2020-06-19 13:11:37', 0),
(87, 201, 100, 1, 1, 1, '2020-06-20 22:11:32', 1, '2020-06-20 22:11:32', 0),
(88, 201, 101, 1, 1, 1, '2020-06-20 22:12:44', 1, '2020-06-20 22:12:44', 0),
(89, 201, 103, 1, 1, 1, '2020-06-20 22:29:08', 1, '2020-06-20 22:29:08', 0),
(90, 201, 104, 1, 1, 1, '2020-06-20 22:30:22', 1, '2020-06-20 22:30:22', 0),
(91, 202, 100, 1, 1, 1, '2020-06-22 14:41:45', 103, '2020-06-22 17:05:20', 103),
(92, 202, 101, 1, 1, 1, '2020-06-22 14:42:00', 103, '2020-07-03 16:02:09', 103),
(93, 202, 103, 1, 1, 1, '2020-06-22 14:42:14', 103, '2020-07-03 16:15:48', 103),
(94, 196, 100, 1, 1, 1, '2020-06-24 16:57:23', 1, '2020-06-24 16:57:23', 0),
(95, 199, 100, 1, 1, 1, '2020-06-24 17:19:50', 1, '2020-06-24 17:19:50', 0),
(96, 200, 101, 1, 1, 1, '2020-06-24 17:20:55', 1, '2020-06-24 17:20:55', 0),
(97, 203, 100, 1, 1, 1, '2020-06-24 17:29:21', 1, '2020-06-24 17:29:21', 0),
(98, 207, 103, 1, 1, 1, '2020-07-01 14:53:23', 103, '2020-07-03 17:17:48', 103),
(99, 207, 100, 1, 1, 1, '2020-07-01 14:53:27', 103, '2020-07-01 14:53:27', 0),
(100, 207, 101, 1, 1, 1, '2020-07-01 14:53:30', 103, '2020-07-01 14:53:30', 0),
(101, 207, 104, 1, 1, 1, '2020-07-01 14:53:43', 103, '2020-07-03 17:22:31', 103),
(102, 206, 100, 1, 1, 1, '2020-07-03 16:21:39', 103, '2020-07-03 16:21:39', 0),
(103, 206, 101, 1, 1, 1, '2020-07-03 16:22:46', 103, '2020-07-03 16:22:46', 0),
(104, 208, 100, 1, 1, 1, '2020-08-26 14:49:33', 118, '2020-08-26 14:49:33', 0),
(105, 208, 101, 1, 1, 1, '2020-08-26 14:49:53', 118, '2020-08-26 14:49:53', 0),
(106, 208, 103, 1, 1, 1, '2020-08-26 14:53:48', 118, '2020-08-26 14:53:48', 0),
(107, 208, 104, 1, 1, 1, '2020-08-26 14:54:05', 118, '2020-08-26 14:54:05', 0),
(108, 209, 100, 1, 1, 1, '2020-08-26 15:04:55', 118, '2020-08-26 15:04:55', 0),
(109, 209, 101, 1, 1, 1, '2020-08-26 15:05:22', 118, '2020-08-26 15:05:22', 0),
(110, 209, 103, 1, 1, 1, '2020-08-26 15:07:19', 118, '2020-08-26 15:07:19', 0),
(111, 209, 104, 1, 1, 1, '2020-08-26 15:07:31', 118, '2020-08-26 15:07:31', 0),
(112, 210, 100, 1, 1, 1, '2020-08-26 15:18:35', 118, '2020-08-26 15:18:35', 0),
(113, 210, 101, 1, 1, 1, '2020-08-26 15:18:54', 118, '2020-08-26 15:18:54', 0),
(114, 210, 103, 1, 1, 1, '2020-08-26 15:22:35', 118, '2020-08-26 15:22:35', 0),
(115, 210, 104, 1, 1, 1, '2020-08-26 15:22:45', 118, '2020-08-26 15:22:45', 0),
(116, 211, 100, 1, 1, 1, '2020-08-26 16:17:04', 118, '2020-08-26 16:17:04', 0),
(117, 211, 101, 1, 1, 1, '2020-08-26 16:17:10', 118, '2020-08-26 16:17:10', 0),
(118, 212, 100, 1, 1, 1, '2020-08-27 12:08:35', 118, '2020-08-27 12:08:35', 0),
(119, 212, 101, 1, 1, 1, '2020-08-27 12:09:07', 118, '2020-08-27 12:09:07', 0),
(120, 212, 103, 1, 1, 1, '2020-08-27 12:13:25', 118, '2020-08-27 12:13:25', 0),
(121, 212, 104, 1, 1, 1, '2020-08-27 12:13:47', 118, '2020-08-27 12:13:47', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_output`
--

CREATE TABLE `crm3_output` (
  `id` int(11) NOT NULL,
  `module` varchar(50) NOT NULL DEFAULT '',
  `id_module` int(9) NOT NULL DEFAULT 0,
  `version` int(9) NOT NULL DEFAULT 0,
  `full_path` text NOT NULL,
  `url` text NOT NULL,
  `file_name` varchar(250) NOT NULL DEFAULT '',
  `file_size` varchar(250) NOT NULL DEFAULT '',
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `input_by` int(9) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `update_by` int(9) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_output`
--

INSERT INTO `crm3_output` (`id`, `module`, `id_module`, `version`, `full_path`, `url`, `file_name`, `file_size`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 'quote', 1, 1, './upload/quote/000023-1.html', '', '000023', '', 1, '2020-03-07 13:53:15', 0, '2020-03-07 13:53:15', 0),
(2, 'quote', 1, 2, './upload/quote/000023-2.html', '', '000023', '', 1, '2020-03-07 13:53:15', 0, '2020-03-07 13:53:15', 0),
(3, 'quote', 2, 1, './upload/quote/000024-1.html', '', '000024', '', 1, '2020-03-12 15:46:12', 0, '2020-03-12 15:46:12', 0),
(4, 'quote', 3, 1, './upload/quote/000025-1.html', '', '000025', '', 1, '2020-03-23 17:20:46', 0, '2020-03-23 17:22:05', 0),
(5, 'quote', 3, 2, './upload/quote/000025-2.html', '', '000025', '', 1, '2020-03-23 17:20:46', 0, '2020-03-23 17:22:05', 0),
(6, 'quote', 3, 3, './upload/quote/000025-3.html', '', '000025', '', 1, '2020-03-23 17:20:46', 0, '2020-03-23 17:28:28', 0),
(7, 'quote', 4, 1, './upload/quote/000026-1.html', '', '000026', '', 1, '2020-03-27 11:04:37', 0, '2020-03-27 11:04:37', 0),
(8, 'quote', 5, 1, './upload/quote/000027-1.html', '', '000027', '', 1, '2020-04-01 15:26:19', 0, '2020-04-01 15:26:25', 0),
(9, 'quote', 5, 2, './upload/quote/000027-2.html', '', '000027', '', 1, '2020-04-01 15:26:19', 0, '2020-04-01 15:27:38', 0),
(10, 'quote', 6, 1, './upload/quote/000028-1.html', '', '000028', '', 1, '2020-04-01 16:11:29', 0, '2020-04-01 16:11:29', 0),
(11, 'quote', 6, 2, './upload/quote/000028-2.html', '', '000028', '', 1, '2020-04-01 16:11:29', 0, '2020-04-01 16:13:11', 0),
(12, 'quote', 7, 1, './upload/quote/000029-1.html', '', '000029', '', 1, '2020-04-01 17:27:51', 0, '2020-04-01 17:27:57', 0),
(13, 'quote', 8, 1, './upload/quote/000030-1.html', '', '000030', '', 1, '2020-04-02 14:40:56', 0, '2020-04-02 14:47:32', 0),
(14, 'quote', 9, 1, './upload/quote/000031-1.html', '', '000031', '', 1, '2020-04-02 14:40:56', 0, '2020-04-02 14:54:27', 0),
(15, 'quote', 8, 2, './upload/quote/000030-2.html', '', '000030', '', 1, '2020-04-02 14:40:56', 0, '2020-04-02 14:55:49', 0),
(16, 'quote', 10, 1, './upload/quote/000032-1.html', '', '000032', '', 1, '2020-04-02 16:31:53', 0, '2020-04-02 16:41:39', 0),
(17, 'quote', 11, 1, './upload/quote/000033-1.html', '', '000033', '', 1, '2020-04-03 11:22:00', 0, '2020-04-03 11:22:00', 0),
(18, 'quote', 11, 2, './upload/quote/000033-2.html', '', '000033', '', 1, '2020-04-03 11:22:00', 0, '2020-04-03 11:24:50', 0),
(19, 'quote', 12, 1, './upload/quote/000034-1.html', '', '000034', '', 1, '2020-04-03 15:56:24', 0, '2020-04-03 16:05:18', 0),
(20, 'quote', 13, 1, './upload/quote/000035-1.html', '', '000035', '', 1, '2020-04-06 10:41:27', 0, '2020-04-06 10:45:08', 0),
(21, 'quote', 13, 2, './upload/quote/000035-2.html', '', '000035', '', 1, '2020-04-06 10:41:27', 0, '2020-04-06 11:10:37', 0),
(22, 'quote', 13, 3, './upload/quote/000035-3.html', '', '000035', '', 1, '2020-04-06 10:41:27', 0, '2020-04-06 11:45:15', 0),
(23, 'quote', 14, 1, './upload/quote/000036-1.html', '', '000036', '', 1, '2020-04-06 15:08:39', 0, '2020-04-06 15:08:39', 0),
(24, 'quote', 15, 1, './upload/quote/000037-1.html', '', '000037', '', 1, '2020-04-07 14:18:15', 0, '2020-04-07 14:34:41', 0),
(25, 'quote', 15, 2, './upload/quote/000037-2.html', '', '000037', '', 1, '2020-04-07 14:18:15', 0, '2020-04-07 14:36:12', 0),
(26, 'quote', 16, 1, './upload/quote/000038-1.html', '', '000038', '', 1, '2020-04-07 15:14:07', 0, '2020-04-07 15:14:07', 0),
(27, 'quote', 17, 1, './upload/quote/000039-1.html', '', '000039', '', 1, '2020-04-07 17:02:41', 0, '2020-04-07 17:04:24', 0),
(28, 'quote', 3, 4, './upload/quote/000025-4.html', '', '000025', '', 1, '2020-03-23 17:20:46', 0, '2020-03-23 17:28:28', 0),
(29, 'quote', 17, 2, './upload/quote/000039-2.html', '', '000039', '', 1, '2020-04-07 17:02:41', 0, '2020-04-07 17:04:24', 0),
(30, 'quote', 17, 3, './upload/quote/000039-3.html', '', '000039', '', 1, '2020-04-07 17:02:41', 0, '2020-04-07 17:04:24', 0),
(31, 'quote', 17, 4, './upload/quote/000039-4.html', '', '000039', '', 1, '2020-04-07 17:02:41', 0, '2020-04-08 14:24:58', 0),
(32, 'quote', 18, 1, './upload/quote/000040-1.html', '', '000040', '', 1, '2020-03-09 09:26:33', 0, '2020-04-13 13:59:18', 0),
(33, 'quote', 19, 1, './upload/quote/000041-1.html', '', '000041', '', 1, '2020-04-14 11:23:24', 0, '2020-04-14 11:23:53', 0),
(34, 'quote', 19, 2, './upload/quote/000041-2.html', '', '000041', '', 1, '2020-04-14 11:23:24', 0, '2020-04-14 11:30:58', 0),
(35, 'quote', 20, 1, './upload/quote/000042-1.html', '', '000042', '', 1, '2020-04-07 17:02:41', 0, '2020-06-16 09:05:59', 0),
(36, 'quote', 22, 1, './upload/quote/000044-1.html', '', '000044', '', 1, '2020-06-20 22:09:26', 0, '2020-06-20 22:09:26', 0),
(37, 'quote', 24, 1, './upload/quote/000046-1.html', '', '000046', '', 1, '2020-07-01 14:25:21', 0, '2020-07-01 14:25:44', 0),
(38, 'quote', 26, 1, './upload/quote/000048-1.html', '', '000048', '', 1, '2020-07-03 16:35:48', 0, '2020-07-03 16:36:13', 0),
(39, 'quote', 26, 2, './upload/quote/000048-2.html', '', '000048', '', 1, '2020-07-03 16:35:48', 0, '2020-07-03 16:36:13', 0),
(40, 'quote', 26, 3, './upload/quote/000048-3.html', '', '000048', '', 1, '2020-07-03 16:35:48', 0, '2020-07-03 16:36:13', 0),
(41, 'quote', 1, 1, './upload/quote/000049-1.html', '', '000049', '', 1, '2020-08-26 14:49:24', 0, '2020-08-26 14:51:03', 0),
(42, 'quote', 1, 2, './upload/quote/000049-2.html', '', '000049', '', 1, '2020-08-26 14:49:24', 0, '2020-08-26 14:52:22', 0),
(43, 'quote', 2, 1, './upload/quote/000050-1.html', '', '000050', '', 1, '2020-08-26 15:06:05', 0, '2020-08-26 15:06:13', 0),
(44, 'quote', 3, 1, './upload/quote/000051-1.html', '', '000051', '', 1, '2020-08-26 15:18:29', 0, '2020-08-26 15:20:04', 0),
(45, 'quote', 4, 1, './upload/quote/000052-1.html', '', '000052', '', 1, '2020-08-26 16:17:27', 0, '2020-08-26 16:17:27', 0),
(46, 'quote', 4, 2, './upload/quote/000052-2.html', '', '000052', '', 1, '2020-08-26 16:18:02', 0, '2020-08-26 16:18:08', 0),
(47, 'quote', 5, 1, './upload/quote/000053-1.html', '', '000053', '', 1, '2020-08-27 12:02:01', 0, '2020-08-27 12:11:23', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_price_list`
--

CREATE TABLE `crm3_price_list` (
  `id` int(11) NOT NULL,
  `id_currency` int(2) NOT NULL DEFAULT 1,
  `name` varchar(50) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `expired` date NOT NULL DEFAULT '2020-01-01',
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `crm3_price_list_catalog`
--

CREATE TABLE `crm3_price_list_catalog` (
  `id` int(11) NOT NULL,
  `id_price_list` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `crm3_price_list_class`
--

CREATE TABLE `crm3_price_list_class` (
  `id` int(9) NOT NULL,
  `id_company_class` int(9) NOT NULL DEFAULT 0,
  `id_price_list` int(9) NOT NULL DEFAULT 0,
  `discount` float NOT NULL DEFAULT 0,
  `input_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `input_by` int(9) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `update_by` int(9) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `crm3_price_list_product`
--

CREATE TABLE `crm3_price_list_product` (
  `id` int(11) NOT NULL,
  `id_price_list` int(11) NOT NULL DEFAULT 0,
  `id_price_list_catalog` int(11) NOT NULL DEFAULT 0,
  `id_product` int(11) NOT NULL DEFAULT 0,
  `description` text NOT NULL,
  `price` float(12,0) NOT NULL DEFAULT 0,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `crm3_product`
--

CREATE TABLE `crm3_product` (
  `id` int(11) NOT NULL,
  `sku` varchar(50) NOT NULL DEFAULT '',
  `price` int(11) NOT NULL DEFAULT 0,
  `name` varchar(250) NOT NULL,
  `description` text NOT NULL,
  `id_currency` int(2) NOT NULL DEFAULT 1,
  `id_product_type` int(2) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `status` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `input_by` varchar(250) NOT NULL DEFAULT '0',
  `update_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `update_by` varchar(250) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_product`
--

INSERT INTO `crm3_product` (`id`, `sku`, `price`, `name`, `description`, `id_currency`, `id_product_type`, `presence`, `status`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 'Ned001', 5000, 'Blood Collection Needle 22 G', 'Needle for blood collection', 1, 10, 1, 0, '2020-07-21 16:07:06', '118', '2020-07-22 17:11:06', '1'),
(2, 'Tube001', 10000, 'Rectal Tube ', 'Rectal Tube 22 ml', 1, 10, 1, 0, '2020-07-21 16:14:07', '118', '2020-07-21 16:15:14', '118'),
(3, 'Syr001', 2500, 'Syringe 2 ml', 'Syringe for injection', 1, 10, 1, 0, '2020-07-22 16:12:36', '118', '2020-07-22 16:13:09', '118'),
(4, 'Cat001', 35000, 'Catheter Mount', '', 1, 10, 1, 0, '2020-07-23 08:08:53', '118', '2020-07-23 08:09:24', '118'),
(5, 'Inf001', 500000, 'Automatic Pressure Infusor', 'Blood Warmer atau Alat Penghangat Darah PROTHEM II adalah adalah alat multifungsi untuk menghangatkan darah maupun cairan infus yang akan diberikan secara normal maupun secara cepat tanpa adanya resiko lisinyab sel darah maupun terkontaminasi. Area panas yang terkontrol secara independen akan memberikan efek penghangatan yang efektif dan tanpa merusak darah maupun cairan infus.', 1, 10, 1, 0, '2020-08-26 11:32:10', '118', '2020-08-26 11:34:57', '118'),
(6, 'Cat002', 50000, 'Closed Suction Catheter ', 'Kateter sistem tertutup untuk melakukan suctioning pada pasien yang terpasang endotracheal tube\n\n', 1, 10, 1, 0, '2020-08-26 11:48:30', '118', '2020-08-26 11:50:00', '118');

-- --------------------------------------------------------

--
-- Table structure for table `crm3_product_location`
--

CREATE TABLE `crm3_product_location` (
  `id` int(11) NOT NULL,
  `id_product` int(9) NOT NULL DEFAULT 1,
  `location` varchar(250) NOT NULL,
  `location_code` varchar(250) NOT NULL,
  `qty` int(9) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `input_by` varchar(250) NOT NULL DEFAULT '0',
  `update_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `update_by` varchar(250) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_product_location`
--

INSERT INTO `crm3_product_location` (`id`, `id_product`, `location`, `location_code`, `qty`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 1, 'Head Office', 'HO', 1000, 1, '2020-01-01 00:00:00', '0', '2020-01-01 00:00:00', '0'),
(2, 1, 'Surabaya', 'SBY', 500, 1, '2020-01-01 00:00:00', '0', '2020-01-01 00:00:00', '0'),
(3, 2, 'Head Office', 'HO', 500, 1, '2020-01-01 00:00:00', '0', '2020-01-01 00:00:00', '0'),
(4, 2, 'Surabaya', 'SBY', 200, 1, '2020-01-01 00:00:00', '0', '2020-01-01 00:00:00', '0'),
(5, 3, 'Head Office', 'HO', 1000, 1, '2020-01-01 00:00:00', '0', '2020-01-01 00:00:00', '0'),
(6, 3, 'Surabaya', 'SBY', 500, 1, '2020-01-01 00:00:00', '0', '2020-01-01 00:00:00', '0'),
(7, 4, 'Head Office', 'HO', 200, 1, '2020-01-01 00:00:00', '0', '2020-01-01 00:00:00', '0'),
(8, 4, 'Surabaya', 'SBY', 50, 1, '2020-01-01 00:00:00', '0', '2020-01-01 00:00:00', '0'),
(9, 5, 'Head Office', 'HO', 50, 1, '2020-01-01 00:00:00', '0', '2020-01-01 00:00:00', '0'),
(10, 5, 'Surabaya', 'SBY', 10, 1, '2020-01-01 00:00:00', '0', '2020-01-01 00:00:00', '0'),
(11, 6, 'Head Office', 'HO', 200, 1, '2020-01-01 00:00:00', '0', '2020-01-01 00:00:00', '0'),
(12, 6, 'Surabaya', 'SBY', 100, 1, '2020-01-01 00:00:00', '0', '2020-01-01 00:00:00', '0');

-- --------------------------------------------------------

--
-- Table structure for table `crm3_product_type`
--

CREATE TABLE `crm3_product_type` (
  `id` int(6) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '',
  `stock` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_product_type`
--

INSERT INTO `crm3_product_type` (`id`, `name`, `stock`) VALUES
(10, 'Good', 1),
(20, 'Service', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_quote`
--

CREATE TABLE `crm3_quote` (
  `id` int(11) NOT NULL,
  `id_opportunity` int(11) NOT NULL DEFAULT 0,
  `id_quote_status` int(3) NOT NULL DEFAULT 1,
  `id_quote_status_final` int(3) NOT NULL DEFAULT 0,
  `id_user` int(9) NOT NULL DEFAULT 0,
  `id_contact` int(9) NOT NULL DEFAULT 0,
  `id_output` int(9) NOT NULL DEFAULT 0,
  `syncing` int(1) NOT NULL DEFAULT 0,
  `quotes_number` varchar(50) NOT NULL DEFAULT '0',
  `version` int(4) NOT NULL DEFAULT 0,
  `name` varchar(250) NOT NULL DEFAULT '',
  `grand_total` float(20,2) NOT NULL DEFAULT 0.00,
  `expired_date` date NOT NULL DEFAULT '2019-01-01',
  `id_template` int(11) NOT NULL DEFAULT 0,
  `description` text NOT NULL,
  `discount` float NOT NULL DEFAULT 0,
  `tax` float NOT NULL DEFAULT 0,
  `shipping` float NOT NULL DEFAULT 0,
  `email` text NOT NULL,
  `phone` text NOT NULL,
  `fax` text NOT NULL,
  `term` text NOT NULL,
  `bill_name` varchar(250) NOT NULL DEFAULT '',
  `bill_street1` varchar(250) NOT NULL DEFAULT '',
  `bill_street2` varchar(250) NOT NULL DEFAULT '',
  `bill_city` varchar(250) NOT NULL DEFAULT '',
  `bill_state` varchar(250) NOT NULL DEFAULT '',
  `bill_code` varchar(250) NOT NULL DEFAULT '',
  `bill_country` varchar(250) NOT NULL DEFAULT '',
  `ship_name` varchar(250) NOT NULL DEFAULT '',
  `ship_street1` varchar(250) NOT NULL DEFAULT '',
  `ship_street2` varchar(250) NOT NULL DEFAULT '',
  `ship_city` varchar(250) NOT NULL DEFAULT '',
  `ship_state` varchar(250) NOT NULL DEFAULT '',
  `ship_code` varchar(250) NOT NULL DEFAULT '',
  `ship_country` varchar(250) NOT NULL DEFAULT '',
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_quote`
--

INSERT INTO `crm3_quote` (`id`, `id_opportunity`, `id_quote_status`, `id_quote_status_final`, `id_user`, `id_contact`, `id_output`, `syncing`, `quotes_number`, `version`, `name`, `grand_total`, `expired_date`, `id_template`, `description`, `discount`, `tax`, `shipping`, `email`, `phone`, `fax`, `term`, `bill_name`, `bill_street1`, `bill_street2`, `bill_city`, `bill_state`, `bill_code`, `bill_country`, `ship_name`, `ship_street1`, `ship_street2`, `ship_city`, `ship_state`, `ship_code`, `ship_country`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 208, 200, 500, 118, 153, 0, 0, '000049', 2, 'RS Berdikari - Rectal Tube & Blood Collecting Needle', 1125000.00, '2020-08-31', 0, '', 0, 0, 0, 'bambang@rsberdikari.com', '', '', '', '', 'Jl. Raya Bogor km 31', '', 'Jakarta', 'DKI Jakarta', '', 'Indonesia', '', '', '', '', '', '', '', 1, 1, '2020-08-26 14:50:20', 118, '2020-08-26 14:53:12', 118),
(2, 209, 200, 500, 118, 154, 0, 0, '000050', 1, 'RS Mulia - Automatic Pressure Infusor', 2500000.00, '2020-08-31', 0, '', 0, 0, 0, 'johny@rsmulia.co.id', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 1, 1, '2020-08-26 15:05:42', 118, '2020-08-26 15:06:45', 118),
(3, 210, 200, 400, 118, 155, 0, 0, '000051', 1, 'RS Mulia - Syringe', 250000.00, '2020-08-29', 0, '', 0, 0, 0, 'johny@rsmulia.co.id', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 1, 1, '2020-08-26 15:19:47', 118, '2020-08-26 15:20:36', 118),
(4, 211, 200, 500, 118, 156, 0, 0, '000052', 2, 'RS Pinang - Closed Suction Chateter', 5000000.00, '2020-08-28', 0, '', 0, 0, 0, 'michael.keaton@rspinang.com', '021-7919999', '-', '', '', 'Jl. Pondok Pinang 10', '', '', '', '', '', '', '', '', '', '', '', '', 1, 1, '2020-08-26 16:17:27', 118, '2020-08-27 12:21:00', 118),
(5, 212, 200, 500, 118, 157, 0, 0, '000053', 1, 'Indoprima - Chateter', 807500.00, '2020-08-31', 0, 'Quotation Chateter', 0, 0, 0, 'leo@indoprima.com', '021-5444444', '021-5445555', '', 'Pak Leo', 'Jl. Taman sari no 56', '', 'Jakarta', 'DKI Jakarta', '11100', 'Indonesia', 'Pak Leo', 'Jl. Taman sari no 56', '', 'Jakarta', 'DKI Jakarta', '', '', 1, 1, '2020-08-27 12:10:18', 118, '2020-08-27 12:12:06', 118);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_quote_detail`
--

CREATE TABLE `crm3_quote_detail` (
  `id` int(11) NOT NULL,
  `id_quote` int(11) NOT NULL DEFAULT 0,
  `id_product` int(11) NOT NULL DEFAULT 0,
  `id_price_list` int(11) NOT NULL DEFAULT 0,
  `description` text NOT NULL,
  `price` float NOT NULL DEFAULT 0,
  `discount` float NOT NULL DEFAULT 0,
  `qty` int(6) NOT NULL DEFAULT 0,
  `total` float NOT NULL DEFAULT 0,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `sorting` int(3) NOT NULL DEFAULT 999,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_quote_detail`
--

INSERT INTO `crm3_quote_detail` (`id`, `id_quote`, `id_product`, `id_price_list`, `description`, `price`, `discount`, `qty`, `total`, `status`, `presence`, `sorting`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 1, 1, 0, 'Needle for blood collection', 5000, 10, 50, 225000, 1, 1, 1, '2020-08-26 14:49:24', 0, '2020-08-26 14:52:12', 118),
(2, 1, 2, 0, 'Rectal Tube 22 ml', 10000, 10, 100, 900000, 1, 1, 2, '2020-08-26 14:49:24', 0, '2020-08-26 14:52:22', 118),
(3, 2, 5, 0, 'Blood Warmer atau Alat Penghangat Darah PROTHEM II adalah adalah alat multifungsi untuk menghangatkan darah maupun cairan infus yang akan diberikan secara normal maupun secara cepat tanpa adanya resiko lisinyab sel darah maupun terkontaminasi. Area panas yang terkontrol secara independen akan memberikan efek penghangatan yang efektif dan tanpa merusak darah maupun cairan infus.', 500000, 0, 5, 2500000, 1, 1, 999, '2020-08-26 15:06:05', 118, '2020-08-26 15:06:13', 118),
(4, 3, 3, 0, 'Syringe for injection', 2500, 0, 100, 250000, 1, 1, 1, '2020-08-26 15:18:29', 0, '2020-08-26 15:20:04', 118),
(5, 4, 6, 0, 'Kateter sistem tertutup untuk melakukan suctioning pada pasien yang terpasang endotracheal tube\n\n', 50000, 0, 100, 5000000, 1, 1, 999, '2020-08-26 16:18:02', 118, '2020-08-26 16:18:08', 118),
(6, 5, 6, 0, 'Kateter sistem tertutup untuk melakukan suctioning pada pasien yang terpasang endotracheal tube\n\n', 50000, 5, 10, 475000, 1, 1, 1, '2020-08-27 12:02:01', 0, '2020-08-27 12:10:55', 118),
(7, 5, 4, 0, '', 35000, 5, 10, 332500, 1, 1, 2, '2020-08-27 12:02:01', 0, '2020-08-27 12:11:23', 118);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_quote_status`
--

CREATE TABLE `crm3_quote_status` (
  `id` int(3) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '',
  `closed` int(2) NOT NULL DEFAULT 0,
  `note` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_quote_status`
--

INSERT INTO `crm3_quote_status` (`id`, `name`, `closed`, `note`) VALUES
(1, 'Draft', 0, 'Daft baru'),
(200, 'Process', 0, 'Send ke cuostmer '),
(300, 'Revision', 0, 'Revisi Penawaran Anda'),
(400, 'Reject', 1, 'Project Gagal'),
(500, 'Approved by Customer', 1, 'Customer Sudah setuju dengan penawarana anda');

-- --------------------------------------------------------

--
-- Table structure for table `crm3_sales_order`
--

CREATE TABLE `crm3_sales_order` (
  `id` int(11) NOT NULL,
  `id_company` int(11) NOT NULL DEFAULT 0,
  `id_opportunity` int(11) NOT NULL DEFAULT 0,
  `id_user` int(9) NOT NULL DEFAULT 0,
  `id_contact` int(9) NOT NULL DEFAULT 0,
  `id_quote` int(9) NOT NULL DEFAULT 0,
  `so_number` varchar(50) NOT NULL DEFAULT '0',
  `name` varchar(250) NOT NULL DEFAULT '',
  `grand_total` float(20,2) NOT NULL DEFAULT 0.00,
  `expired_date` date NOT NULL DEFAULT '2019-01-01',
  `id_template` int(11) NOT NULL DEFAULT 0,
  `description` text NOT NULL,
  `discount` float NOT NULL DEFAULT 0,
  `tax` float NOT NULL DEFAULT 0,
  `shipping` float NOT NULL DEFAULT 0,
  `email` text NOT NULL,
  `phone` text NOT NULL,
  `fax` text NOT NULL,
  `term` text NOT NULL,
  `bill_name` varchar(250) NOT NULL DEFAULT '',
  `bill_street1` varchar(250) NOT NULL DEFAULT '',
  `bill_street2` varchar(250) NOT NULL DEFAULT '',
  `bill_city` varchar(250) NOT NULL DEFAULT '',
  `bill_state` varchar(250) NOT NULL DEFAULT '',
  `bill_code` varchar(250) NOT NULL DEFAULT '',
  `bill_country` varchar(250) NOT NULL DEFAULT '',
  `ship_name` varchar(250) NOT NULL DEFAULT '',
  `ship_street1` varchar(250) NOT NULL DEFAULT '',
  `ship_street2` varchar(250) NOT NULL DEFAULT '',
  `ship_city` varchar(250) NOT NULL DEFAULT '',
  `ship_state` varchar(250) NOT NULL DEFAULT '',
  `ship_code` varchar(250) NOT NULL DEFAULT '',
  `ship_country` varchar(250) NOT NULL DEFAULT '',
  `id_sales_order_status` int(3) NOT NULL DEFAULT 1,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_sales_order`
--

INSERT INTO `crm3_sales_order` (`id`, `id_company`, `id_opportunity`, `id_user`, `id_contact`, `id_quote`, `so_number`, `name`, `grand_total`, `expired_date`, `id_template`, `description`, `discount`, `tax`, `shipping`, `email`, `phone`, `fax`, `term`, `bill_name`, `bill_street1`, `bill_street2`, `bill_city`, `bill_state`, `bill_code`, `bill_country`, `ship_name`, `ship_street1`, `ship_street2`, `ship_city`, `ship_state`, `ship_code`, `ship_country`, `id_sales_order_status`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 192, 208, 118, 153, 1, '000059', 'RS Berdikari - Rectal Tube & Blood Collecting Needle', 1125000.00, '2020-08-26', 0, '', 0, 0, 0, 'bambang@rsberdikari.com', '', '', '0', '', 'Jl. Raya Bogor km 31', '', 'Jakarta', 'DKI Jakarta', '', 'Indonesia', '', '', '', '', '', '', '', 1, 1, 1, '2020-08-26 14:54:32', 118, '2020-08-26 14:54:32', 0),
(2, 193, 209, 118, 154, 2, '000060', 'RS Mulia - Automatic Pressure Infusor', 2500000.00, '2020-08-26', 0, '', 0, 0, 0, 'johny@rsmulia.co.id', '', '', '0', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 1, 1, 1, '2020-08-26 15:07:48', 118, '2020-08-26 15:07:48', 0),
(3, 196, 212, 118, 157, 5, '000061', 'Indoprima - Chateter', 807500.00, '2020-08-27', 0, 'Quotation Chateter', 0, 0, 0, 'leo@indoprima.com', '021-5444444', '021-5445555', '0', 'Pak Leo', 'Jl. Taman sari no 56', '', 'Jakarta', 'DKI Jakarta', '11100', 'Indonesia', 'Pak Leo', 'Jl. Taman sari no 56', '', 'Jakarta', 'DKI Jakarta', '', '', 1, 1, 1, '2020-08-27 12:19:14', 118, '2020-08-27 12:19:14', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_sales_order_detail`
--

CREATE TABLE `crm3_sales_order_detail` (
  `id` int(11) NOT NULL,
  `id_sales_order` int(11) NOT NULL DEFAULT 0,
  `id_product` int(11) NOT NULL DEFAULT 0,
  `id_price_list` int(11) NOT NULL DEFAULT 0,
  `description` text NOT NULL,
  `price` float NOT NULL DEFAULT 0,
  `discount` float NOT NULL DEFAULT 0,
  `qty` int(6) NOT NULL DEFAULT 0,
  `total` float NOT NULL DEFAULT 0,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `sorting` int(3) NOT NULL DEFAULT 999,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_sales_order_detail`
--

INSERT INTO `crm3_sales_order_detail` (`id`, `id_sales_order`, `id_product`, `id_price_list`, `description`, `price`, `discount`, `qty`, `total`, `status`, `presence`, `sorting`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 1, 1, 0, 'Needle for blood collection', 5000, 10, 50, 225000, 1, 1, 999, '2020-08-26 14:54:32', 118, '2020-08-26 14:54:32', 0),
(2, 1, 2, 0, 'Rectal Tube 22 ml', 10000, 10, 100, 900000, 1, 1, 999, '2020-08-26 14:54:32', 118, '2020-08-26 14:54:32', 0),
(3, 2, 5, 0, 'Blood Warmer atau Alat Penghangat Darah PROTHEM II adalah adalah alat multifungsi untuk menghangatkan darah maupun cairan infus yang akan diberikan secara normal maupun secara cepat tanpa adanya resiko lisinyab sel darah maupun terkontaminasi. Area panas yang terkontrol secara independen akan memberikan efek penghangatan yang efektif dan tanpa merusak darah maupun cairan infus.', 500000, 0, 5, 2500000, 1, 1, 999, '2020-08-26 15:07:48', 118, '2020-08-26 15:07:48', 0),
(4, 3, 6, 0, 'Kateter sistem tertutup untuk melakukan suctioning pada pasien yang terpasang endotracheal tube\n\n', 50000, 5, 10, 475000, 1, 1, 999, '2020-08-27 12:19:14', 118, '2020-08-27 12:19:14', 0),
(5, 3, 4, 0, '', 35000, 5, 10, 332500, 1, 1, 999, '2020-08-27 12:19:14', 118, '2020-08-27 12:19:14', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_sales_order_log`
--

CREATE TABLE `crm3_sales_order_log` (
  `id` int(6) NOT NULL,
  `id_sales_order` int(6) NOT NULL DEFAULT 0,
  `id_sales_order_status` int(6) NOT NULL DEFAULT 0,
  `input_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `input_by` int(9) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `crm3_sales_order_status`
--

CREATE TABLE `crm3_sales_order_status` (
  `id` int(3) NOT NULL,
  `name` varchar(50) DEFAULT '',
  `note` varchar(50) DEFAULT '',
  `editable` int(1) DEFAULT 1,
  `presence` int(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_sales_order_status`
--

INSERT INTO `crm3_sales_order_status` (`id`, `name`, `note`, `editable`, `presence`) VALUES
(1, 'Draft', '', 1, 1),
(400, 'Open ', 'Harus create SO di ERP dan ambil balik SO number', 0, 1),
(900, 'Complete ', 'Status SO di ERP apakah sudah selesai', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_title`
--

CREATE TABLE `crm3_title` (
  `id` int(11) NOT NULL,
  `name` varchar(250) NOT NULL DEFAULT '',
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_title`
--

INSERT INTO `crm3_title` (`id`, `name`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 'Bpk', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(2, 'Ibu', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(3, 'Mr', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(4, 'Mrs', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(5, 'Miss', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_user`
--

CREATE TABLE `crm3_user` (
  `id` int(11) NOT NULL,
  `id_user_access` int(5) NOT NULL DEFAULT 0,
  `id_user_group` int(6) NOT NULL DEFAULT 0,
  `id_parent` int(6) NOT NULL DEFAULT 0,
  `folder` varchar(50) NOT NULL DEFAULT '',
  `email` varchar(250) NOT NULL DEFAULT '',
  `password` varchar(250) NOT NULL DEFAULT '',
  `code` varchar(250) NOT NULL DEFAULT '',
  `first_name` varchar(250) NOT NULL DEFAULT '',
  `last_name` varchar(250) NOT NULL DEFAULT '',
  `max_discount` float(2,0) NOT NULL DEFAULT 0,
  `target_amount_year` bigint(20) NOT NULL DEFAULT 0,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_user`
--

INSERT INTO `crm3_user` (`id`, `id_user_access`, `id_user_group`, `id_parent`, `folder`, `email`, `password`, `code`, `first_name`, `last_name`, `max_discount`, `target_amount_year`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 1, 1, 0, '1', 'admin@crm.co.id', 'a906449d5769fa7361d7ecc6aa3f6d28', 'ES', 'Admin', 'Thinktank', 30, 12000000000, 1, 1, '2019-01-01 00:00:00', 0, '2020-07-06 19:04:02', 1),
(118, 1, 2, 0, '', 'hellen@crm.co.id', 'a906449d5769fa7361d7ecc6aa3f6d28', 'HK', 'Hellen', 'Keller', 20, 0, 1, 1, '2019-01-01 00:00:00', 0, '2020-08-26 15:11:08', 118),
(119, 5, 2, 118, '', 'fitria@crm.co.id', 'a906449d5769fa7361d7ecc6aa3f6d28', 'FT', 'Fitria', '-', 10, 0, 1, 1, '2019-01-01 00:00:00', 0, '2020-08-26 15:10:29', 118);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_user_access`
--

CREATE TABLE `crm3_user_access` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '',
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_user_access`
--

INSERT INTO `crm3_user_access` (`id`, `name`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 'Supervisor', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(5, 'Sales Person', 1, 1, '2020-02-11 13:23:17', 7, '2020-02-11 13:23:17', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_user_access_rules`
--

CREATE TABLE `crm3_user_access_rules` (
  `id` int(11) NOT NULL,
  `id_user_access` int(5) NOT NULL DEFAULT 0,
  `id_module` int(5) NOT NULL DEFAULT 0,
  `_access` int(1) NOT NULL DEFAULT 0,
  `_insert` int(1) NOT NULL DEFAULT 0,
  `_update` int(1) NOT NULL DEFAULT 0,
  `_delete` int(1) NOT NULL DEFAULT 0,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_user_access_rules`
--

INSERT INTO `crm3_user_access_rules` (`id`, `id_user_access`, `id_module`, `_access`, `_insert`, `_update`, `_delete`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 1, 200, 1, 1, 1, 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(2, 1, 300, 1, 1, 1, 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(3, 1, 400, 1, 1, 1, 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(4, 1, 500, 1, 1, 1, 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(5, 1, 600, 1, 1, 1, 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(6, 1, 700, 1, 1, 1, 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(7, 1, 410, 1, 1, 1, 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(8, 1, 510, 1, 1, 1, 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(9, 1, 520, 1, 1, 1, 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(10, 1, 550, 1, 1, 1, 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(11, 1, 710, 1, 1, 1, 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(12, 1, 800, 1, 1, 1, 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(14, 1, 411, 1, 1, 1, 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(29, 5, 100, 0, 0, 0, 0, 1, 1, '2020-02-11 13:23:17', 7, '2020-02-11 13:23:17', 0),
(30, 5, 200, 1, 1, 1, 1, 1, 1, '2020-02-11 13:23:17', 7, '2020-02-11 13:23:17', 0),
(31, 5, 300, 1, 1, 1, 1, 1, 1, '2020-02-11 13:23:17', 7, '2020-02-11 13:23:17', 0),
(32, 5, 400, 1, 1, 1, 1, 1, 1, '2020-02-11 13:23:17', 7, '2020-02-11 13:23:17', 0),
(33, 5, 410, 1, 1, 1, 1, 1, 1, '2020-02-11 13:23:17', 7, '2020-02-11 13:23:17', 0),
(34, 5, 411, 1, 1, 1, 1, 1, 1, '2020-02-11 13:23:17', 7, '2020-02-11 13:23:17', 0),
(35, 5, 500, 1, 1, 1, 1, 1, 1, '2020-02-11 13:23:17', 7, '2020-02-11 13:23:17', 0),
(36, 5, 510, 1, 1, 1, 1, 1, 1, '2020-02-11 13:23:17', 7, '2020-02-11 13:23:17', 0),
(37, 5, 520, 1, 1, 1, 1, 1, 1, '2020-02-11 13:23:17', 7, '2020-02-11 13:23:17', 0),
(38, 5, 550, 1, 1, 1, 1, 1, 1, '2020-02-11 13:23:17', 7, '2020-02-11 13:23:17', 0),
(39, 5, 600, 1, 1, 1, 1, 1, 1, '2020-02-11 13:23:17', 7, '2020-02-11 13:23:17', 0),
(40, 5, 700, 1, 1, 1, 1, 1, 1, '2020-02-11 13:23:17', 7, '2020-02-11 13:23:17', 0),
(41, 5, 710, 1, 1, 1, 1, 1, 1, '2020-02-11 13:23:17', 7, '2020-02-11 13:23:17', 0),
(42, 5, 800, 1, 1, 1, 1, 1, 1, '2020-02-11 13:23:17', 7, '2020-02-11 13:23:17', 0),
(43, 1, 100, 1, 1, 1, 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(44, 1, 110, 1, 1, 1, 1, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(45, 5, 110, 0, 0, 0, 0, 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(46, 1, 111, 1, 1, 1, 1, 1, 1, '2020-03-06 17:34:55', 7, '2020-03-06 17:34:55', 0),
(47, 1, 1000, 1, 1, 1, 1, 1, 1, '2020-03-06 17:34:55', 7, '2020-03-06 17:34:55', 0),
(48, 1, 2001, 1, 1, 1, 0, 1, 1, '2020-03-06 17:34:55', 7, '2020-03-06 17:34:55', 0),
(49, 5, 111, 0, 0, 0, 0, 1, 1, '2020-03-06 17:34:55', 7, '2020-03-06 17:34:55', 0),
(50, 5, 1000, 1, 1, 1, 1, 1, 1, '2020-03-06 17:34:55', 7, '2020-03-06 17:34:55', 0),
(51, 5, 2001, 1, 1, 1, 0, 1, 1, '2020-03-06 17:34:55', 7, '2020-03-06 17:34:55', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_user_auth`
--

CREATE TABLE `crm3_user_auth` (
  `id` int(11) NOT NULL,
  `id_user` int(11) NOT NULL DEFAULT 0,
  `token` varchar(50) NOT NULL DEFAULT '',
  `player_id` varchar(50) NOT NULL DEFAULT '',
  `device` varchar(50) NOT NULL DEFAULT '',
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_user_auth`
--

INSERT INTO `crm3_user_auth` (`id`, `id_user`, `token`, `player_id`, `device`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(6, 7, '82015e63eccb35d24255ef83213dbefa', '', 'browser', 1, 1, '2019-12-26 14:20:06', 7, '2019-12-26 14:20:06', 0),
(7, 7, 'sdfasdfasdfasdfwe4u467456', '', '', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(8, 4, 'b4c203aa0f7a45f8ef2a8077b1110f02', '', 'browser', 1, 1, '2020-02-18 11:14:16', 4, '2020-02-18 11:14:16', 0),
(9, 1, '964493fe19254d3db48b2618efdef556', '', 'browser', 1, 1, '2020-03-02 17:07:07', 1, '2020-03-02 17:07:07', 0),
(10, 102, 'acc9c17ce5b4fa1f0d6c5d35f2340ff1', '', 'browser', 1, 1, '2020-03-05 13:40:26', 102, '2020-03-05 13:40:26', 0),
(11, 103, '59161c17b67577c94c2d4856fdc28ed1', '', 'browser', 1, 1, '2020-03-05 15:06:49', 103, '2020-03-05 15:06:49', 0),
(12, 104, '089f5cbeeec03b48a3e4381ca0004f1f', '', 'browser', 1, 1, '2020-03-11 17:40:04', 104, '2020-03-11 17:40:04', 0),
(13, 106, '90d7fa86c8281d59366581c6f85e7117', '', 'browser', 1, 1, '2020-03-24 09:48:32', 106, '2020-03-24 09:48:32', 0),
(14, 107, '12e7fb7e6f91fdfe7d16802c764bb1a0', '', 'browser', 1, 1, '2020-03-24 11:13:14', 107, '2020-03-24 11:13:14', 0),
(15, 108, 'bac8abcbadec8b1a11c4d6856b0a7214', '', 'browser', 1, 1, '2020-03-26 09:44:57', 108, '2020-03-26 09:44:57', 0),
(16, 109, '293f28660083baf9d7ab31fc15981932', '', 'browser', 1, 1, '2020-04-04 09:39:22', 109, '2020-04-04 09:39:22', 0),
(17, 110, 'c3f407257454e375b3bf435b792eaebd', '', 'browser', 1, 1, '2020-04-04 10:19:31', 110, '2020-04-04 10:19:31', 0),
(18, 111, 'a316ab74f0a8f59cac5ca5c66baeb22a', '', 'browser', 1, 1, '2020-04-04 10:23:22', 111, '2020-04-04 10:23:22', 0),
(19, 112, 'afd079bdbe2837463e441560aef96583', '', 'browser', 1, 1, '2020-04-04 11:51:48', 112, '2020-04-04 11:51:48', 0),
(20, 113, 'adbbe6b9ec5364e7224873610e91d4fd', '', 'browser', 1, 1, '2020-04-04 12:01:03', 113, '2020-04-04 12:01:03', 0),
(21, 115, 'f836f00d8f02c71a04e552054d7ac7b5', '', 'browser', 1, 1, '2020-04-04 12:26:31', 115, '2020-04-04 12:26:31', 0),
(22, 108, 'b42ff007fb4732dc43c2ab072a1c3fd6', '', 'browser', 1, 1, '2020-04-13 15:39:42', 108, '2020-04-13 15:39:42', 0),
(23, 103, '1d4c32d4c5fdeb88ec5410bbb1e72a0b', '', 'browser', 1, 1, '2020-04-13 15:46:02', 103, '2020-04-13 15:46:02', 0),
(24, 108, '321fb9ee51567b75415239d80bc41d35', '', 'browser', 1, 1, '2020-04-13 15:47:39', 108, '2020-04-13 15:47:39', 0),
(25, 107, 'dcd655bbcf4001f3737c531d3407b24b', '', 'browser', 1, 1, '2020-04-13 15:48:16', 107, '2020-04-13 15:48:16', 0),
(26, 103, '51e9596d3e94cc36745f74dbf03bad86', '', 'browser', 1, 1, '2020-04-13 15:48:46', 103, '2020-04-13 15:48:46', 0),
(27, 103, '78ba364eb701deea5ed0365433162999', '', 'browser', 1, 1, '2020-04-13 16:11:42', 103, '2020-04-13 16:11:42', 0),
(28, 107, 'd6be95beb72ccf8020127d24af16401b', '', 'browser', 1, 1, '2020-04-13 16:40:36', 107, '2020-04-13 16:40:36', 0),
(29, 103, '1b8da4ba5d6121f88ff9d1f44074cb4b', '', 'browser', 1, 1, '2020-04-13 16:43:47', 103, '2020-04-13 16:43:47', 0),
(30, 107, 'e6f92754d846fdadc1a11f6002621ca1', '', 'browser', 1, 1, '2020-04-13 16:48:03', 107, '2020-04-13 16:48:03', 0),
(31, 103, '2f67144905a61813ae52efbfd1804502', '', 'browser', 1, 1, '2020-04-13 16:53:36', 103, '2020-04-13 16:53:36', 0),
(32, 108, '5893835d6ef9b2bb11412f5ee6022b62', '', 'browser', 1, 1, '2020-04-13 16:54:09', 108, '2020-04-13 16:54:09', 0),
(33, 103, 'f1ad0581cbbd7b33d66c51bf8fa769cd', '', 'browser', 1, 1, '2020-04-13 16:55:14', 103, '2020-04-13 16:55:14', 0),
(34, 107, '291f2fd8817953c7f134b8618691035c', '', 'browser', 1, 1, '2020-04-13 17:18:10', 107, '2020-04-13 17:18:10', 0),
(35, 103, '61ba855c8afb95041957eda5e48b9283', '', 'browser', 1, 1, '2020-04-13 18:04:05', 103, '2020-04-13 18:04:05', 0),
(36, 103, '5efc4c4a47156a245735e0d431b2de72', '', 'browser', 1, 1, '2020-04-14 08:32:36', 103, '2020-04-14 08:32:36', 0),
(37, 107, 'e991a5f1c7107c283ea7148fd25ef74b', '', 'browser', 1, 1, '2020-04-14 08:33:37', 107, '2020-04-14 08:33:37', 0),
(38, 108, '9496e322a55307250988e99eb403712c', '', 'browser', 1, 1, '2020-04-14 08:35:04', 108, '2020-04-14 08:35:04', 0),
(39, 103, '7b6008584a7a0fb5c5ba3d5298142e56', '', 'browser', 1, 1, '2020-04-14 08:39:26', 103, '2020-04-14 08:39:26', 0),
(40, 7, '8c531466113a603f697b8fd6d587638b', '', 'browser', 1, 1, '2020-04-14 11:03:41', 7, '2020-04-14 11:03:41', 0),
(41, 103, 'c54ddc3bdd56e62da5d099266dfff4d6', '', 'browser', 1, 1, '2020-04-14 11:04:04', 103, '2020-04-14 11:04:04', 0),
(42, 103, '762fd00139643b22e7e7df395885d37e', '', 'browser', 1, 1, '2020-04-14 11:06:40', 103, '2020-04-14 11:06:40', 0),
(43, 107, '07f33794564eeee76d16a9e339b1e001', '', 'browser', 1, 1, '2020-04-14 13:41:50', 107, '2020-04-14 13:41:50', 0),
(44, 112, 'd5af8e678f1bdfd949feea120667d20e', '', 'browser', 1, 1, '2020-04-14 13:51:40', 112, '2020-04-14 13:51:40', 0),
(45, 113, '3007a7bff8d177cf0ed3b12b5d2d392c', '', 'browser', 1, 1, '2020-04-14 14:18:02', 113, '2020-04-14 14:18:02', 0),
(46, 107, 'c8d274dbe831816178669a9ae0706ca5', '', 'browser', 1, 1, '2020-04-14 14:18:32', 107, '2020-04-14 14:18:32', 0),
(47, 112, 'a61b6c8ab37278c3c670be91f2f8940e', '', 'browser', 1, 1, '2020-04-14 14:40:56', 112, '2020-04-14 14:40:56', 0),
(48, 7, 'eea9d2084e1417ef29563f373e680f7e', '', 'browser', 1, 1, '2020-04-14 14:43:28', 7, '2020-04-14 14:43:28', 0),
(49, 1, 'f2dc0bfab01884544d48434362ec5a39', '', 'browser', 1, 1, '2020-04-14 14:44:14', 1, '2020-04-14 14:44:14', 0),
(50, 112, '41e6d4247a9a7e896ba16c2d670687d5', '', 'browser', 1, 1, '2020-04-14 14:45:04', 112, '2020-04-14 14:45:04', 0),
(51, 112, 'ff031791e636064a6137677b75009cc8', '', 'browser', 1, 1, '2020-04-14 14:48:15', 112, '2020-04-14 14:48:15', 0),
(52, 107, 'e3800c4df2256381354dbec8ea586123', '', 'browser', 1, 1, '2020-04-15 09:47:03', 107, '2020-04-15 09:47:03', 0),
(53, 112, '00977913126c67449d534b2c9636a174', '', 'browser', 1, 1, '2020-04-15 10:18:19', 112, '2020-04-15 10:18:19', 0),
(54, 1, '9213c266af9e426bb8139963616b6be2', '', 'browser', 1, 1, '2020-04-15 10:19:19', 1, '2020-04-15 10:19:19', 0),
(55, 107, '2bad2054c40f33d1c7b931aa02353754', '', 'browser', 1, 1, '2020-04-15 10:40:59', 107, '2020-04-15 10:40:59', 0),
(56, 108, 'bf510cd457725ea4818c353067a55620', '', 'browser', 1, 1, '2020-04-15 10:42:39', 108, '2020-04-15 10:42:39', 0),
(57, 1, '9be105ffaaede92ef10e62661295f0fa', '', 'browser', 1, 1, '2020-04-15 10:43:16', 1, '2020-04-15 10:43:16', 0),
(58, 107, '80e91b209cfb431c34698e5a3973d42a', '', 'browser', 1, 1, '2020-04-15 10:43:34', 107, '2020-04-15 10:43:34', 0),
(59, 107, '4181b3eb5ca1c9f11e3ff046839aab0e', '', 'browser', 1, 1, '2020-04-15 10:47:14', 107, '2020-04-15 10:47:14', 0),
(60, 1, 'd9340cbee92304e14ca9db731d0258e5', '', 'browser', 1, 1, '2020-04-22 12:38:32', 1, '2020-04-22 12:38:32', 0),
(61, 1, 'd0747a1a68321d4d7c923da6a37ef13d', '', 'browser', 1, 1, '2020-04-24 22:17:05', 1, '2020-04-24 22:17:05', 0),
(62, 112, '6703cba3e407d26de3eccc2c4fd7cf4f', '', 'browser', 1, 1, '2020-04-27 14:22:34', 112, '2020-04-27 14:22:34', 0),
(63, 103, '42891ea932b6042abd8727c2c33621ac', '', 'browser', 1, 1, '2020-04-27 15:49:25', 103, '2020-04-27 15:49:25', 0),
(64, 1, '9f63f58d80c640548cf49a408b3b6373', '', 'browser', 1, 1, '2020-04-28 11:25:05', 1, '2020-04-28 11:25:05', 0),
(65, 1, '9f63f58d80c640548cf49a408b3b6373', '', 'browser', 1, 1, '2020-04-28 11:25:05', 1, '2020-04-28 11:25:05', 0),
(66, 103, 'c434c761dda00c20230fdb04b1075ade', '', 'browser', 1, 1, '2020-04-28 11:26:18', 103, '2020-04-28 11:26:18', 0),
(67, 103, 'f86d49ca46097b18feb117457b1cd9a7', '', 'browser', 1, 1, '2020-04-28 12:13:48', 103, '2020-04-28 12:13:48', 0),
(68, 1, 'aa5013de6c0570eae75fa560ed4f5601', '', 'browser', 1, 1, '2020-04-30 16:10:32', 1, '2020-04-30 16:10:32', 0),
(69, 1, 'dda4c6b9dbc262084349eddf8c8b1aac', '', 'browser', 1, 1, '2020-05-04 11:50:39', 1, '2020-05-04 11:50:39', 0),
(70, 103, 'c3a7bcb834f88cafd25bd153fd5c109c', '', 'browser', 1, 1, '2020-05-05 12:38:23', 103, '2020-05-05 12:38:23', 0),
(71, 103, '9b1fb0dacf522e9dff106bc46b7e983b', '', 'browser', 1, 1, '2020-05-05 12:39:18', 103, '2020-05-05 12:39:18', 0),
(72, 103, '4a0bf3b900af0b89702ad1d5fa513bee', '', 'android', 1, 1, '2020-05-05 15:47:54', 103, '2020-05-05 15:47:54', 0),
(73, 7, 'f6198b444b5aa976f2f395bce9df5062', '', 'android', 1, 1, '2020-05-05 19:55:34', 7, '2020-05-05 19:55:34', 0),
(74, 7, '66b082cb5c11220d4a4511e8094ee52d', '', 'android', 1, 1, '2020-05-06 12:13:15', 7, '2020-05-06 12:13:15', 0),
(75, 7, 'e23aa04b78aebba79b437394d8afec22', '', 'browser', 1, 1, '2020-05-06 14:26:36', 7, '2020-05-06 14:26:36', 0),
(76, 7, 'f7ae980f346e68c82024ffd1c7b9250f', '', 'browser', 1, 1, '2020-05-08 12:33:55', 7, '2020-05-08 12:33:55', 0),
(77, 7, '5f2e42712b1445167ae285ab2d9cb587', '', 'browser', 1, 1, '2020-05-08 23:24:50', 7, '2020-05-08 23:24:50', 0),
(78, 7, '9e589e27d023488df4513f2a2499ed01', '', 'browser', 1, 1, '2020-05-11 10:46:25', 7, '2020-05-11 10:46:25', 0),
(79, 7, '2e664a2e63375235d3d47df7f13823b9', '', 'browser', 1, 1, '2020-05-12 15:38:43', 7, '2020-05-12 15:38:43', 0),
(80, 7, 'c800bf1ea2f81bc8994c330ab1c9cca8', '', 'browser', 1, 1, '2020-05-13 15:25:54', 7, '2020-05-13 15:25:54', 0),
(81, 7, '351845c66902975009e1ea9bab4d3714', '', 'browser', 1, 1, '2020-05-14 11:14:57', 7, '2020-05-14 11:14:57', 0),
(82, 1, '9b3034e28f81e38429d638065d8d69ff', '', 'browser', 1, 1, '2020-05-14 11:48:52', 1, '2020-05-14 11:48:52', 0),
(83, 7, 'f930c832b35ae1fccbc7f6981d194fc5', '', 'browser', 1, 1, '2020-05-15 10:17:10', 7, '2020-05-15 10:17:10', 0),
(84, 7, '256c35c25bf0e5171e1f9c30db793c11', '', 'android', 1, 1, '2020-05-15 15:28:48', 7, '2020-05-15 15:28:48', 0),
(85, 7, '256c35c25bf0e5171e1f9c30db793c11', '', 'android', 1, 1, '2020-05-15 15:28:48', 7, '2020-05-15 15:28:48', 0),
(86, 7, '22bc392e948b13fb8c389222bdc49242', '', 'android', 1, 1, '2020-05-15 22:07:18', 7, '2020-05-15 22:07:18', 0),
(87, 7, '9edd6f5d8465a012413691609ecdec52', '', 'android', 1, 1, '2020-05-15 22:08:04', 7, '2020-05-15 22:08:04', 0),
(88, 7, '6c0076d88f30e9149cef6ef7cc58ab95', '', 'android', 1, 1, '2020-05-16 13:13:27', 7, '2020-05-16 13:13:27', 0),
(89, 7, '89d835acb9896950392ef71c0b1b90db', '', 'android', 1, 1, '2020-05-16 13:14:59', 7, '2020-05-16 13:14:59', 0),
(90, 7, 'abd8d167d9ad0dcdccfffbcee09e0422', '', 'android', 1, 1, '2020-05-16 13:23:33', 7, '2020-05-16 13:23:33', 0),
(91, 7, 'cbfdd18c3a4cc371057d37cea3327f9e', '', 'android', 1, 1, '2020-05-16 13:24:05', 7, '2020-05-16 13:24:05', 0),
(92, 7, '4c141de83d4a244ae57c47b62a61bab4', '', 'android', 1, 1, '2020-05-18 11:19:21', 7, '2020-05-18 11:19:21', 0),
(93, 7, '1d18fd84bcc798ebb6f233a0a309f7cf', '', 'android', 1, 1, '2020-05-18 12:18:02', 7, '2020-05-18 12:18:02', 0),
(94, 7, 'b106dffd007688afc98c08117b8aa01a', '', 'android', 1, 1, '2020-05-18 12:22:13', 7, '2020-05-18 12:22:13', 0),
(95, 7, '2cb4bd97947179720e09f88342928089', '', 'android', 1, 1, '2020-05-18 12:24:26', 7, '2020-05-18 12:24:26', 0),
(96, 7, 'b24ee3cfb207369afcbf02c276289505', '', 'android', 1, 1, '2020-05-18 12:31:35', 7, '2020-05-18 12:31:35', 0),
(97, 7, '2273aea3a7f3c815e474c445328a116f', '', 'android', 1, 1, '2020-05-18 12:32:45', 7, '2020-05-18 12:32:45', 0),
(98, 7, '56adc6445393753e614f99cf95c05579', '', 'android', 1, 1, '2020-05-18 12:34:45', 7, '2020-05-18 12:34:45', 0),
(99, 7, '7f53768c384674ee69785965d0cd300c', '', 'android', 1, 1, '2020-05-18 12:57:03', 7, '2020-05-18 12:57:03', 0),
(100, 7, '82d8ac2578adf3d25b346bbcc0f71f55', '', 'android', 1, 1, '2020-05-18 17:23:06', 7, '2020-05-18 17:23:06', 0),
(101, 7, '9ca14ac9a46d53c4323b3b2e95045a7c', '', 'android', 1, 1, '2020-05-18 17:47:13', 7, '2020-05-18 17:47:13', 0),
(102, 7, '551aba4e946a42cdf5be9d75201d6396', '', 'android', 1, 1, '2020-05-18 17:51:10', 7, '2020-05-18 17:51:10', 0),
(103, 7, 'e36770761556280e61334f2e6ecabc3e', '', 'android', 1, 1, '2020-05-18 17:54:09', 7, '2020-05-18 17:54:09', 0),
(104, 7, '50263c0883692585870535a147975d3e', '', 'android', 1, 1, '2020-05-18 17:55:01', 7, '2020-05-18 17:55:01', 0),
(105, 7, 'c2712743d4ff6664c9d2683bb7d58f30', '', 'android', 1, 1, '2020-05-18 18:04:14', 7, '2020-05-18 18:04:14', 0),
(106, 7, '88c47fb420026cdd1db4fae8cb45bbd8', '', 'android', 1, 1, '2020-05-18 18:19:20', 7, '2020-05-18 18:19:20', 0),
(107, 7, '8d8ea42461df61bff3778aee8ce4c05b', '', 'android', 1, 1, '2020-05-18 18:51:24', 7, '2020-05-18 18:51:24', 0),
(108, 7, 'e1dbdb504ed66eebbec896bd1d4c9b16', '', 'android', 1, 1, '2020-05-18 18:51:46', 7, '2020-05-18 18:51:46', 0),
(109, 7, '50a08e1bb31ceb9bf13a07ac5f8d3301', '', 'android', 1, 1, '2020-05-18 18:54:02', 7, '2020-05-18 18:54:02', 0),
(110, 7, '6114fed37997114660518e56b756f281', '', 'android', 1, 1, '2020-05-18 20:33:52', 7, '2020-05-18 20:33:52', 0),
(111, 7, '5dbe3a3e450ae178798f91b0f6c5638b', '', 'android', 1, 1, '2020-05-19 11:05:06', 7, '2020-05-19 11:05:06', 0),
(112, 1, 'b7c4f7d6c807061611d9f73a570ee379', '', 'browser', 1, 1, '2020-05-19 11:17:23', 1, '2020-05-19 11:17:23', 0),
(113, 7, '29fcdaa160dbb6c7883219b5790305d2', '', 'android', 1, 1, '2020-05-19 11:24:25', 7, '2020-05-19 11:24:25', 0),
(114, 1, 'd7bc5cd0987981b9ee5e6b13b4b8579e', '', 'android', 1, 1, '2020-05-19 11:30:03', 1, '2020-05-19 11:30:03', 0),
(115, 1, 'a9b1fde78dae13c6ad618d901258bd44', '', 'android', 1, 1, '2020-05-19 11:41:33', 1, '2020-05-19 11:41:33', 0),
(116, 7, '1548b63fb4bd1aa98106b81b3138154a', '', 'browser', 1, 1, '2020-05-19 14:00:12', 7, '2020-05-19 14:00:12', 0),
(117, 1, '3e5081f518562aec950cac32d51372e8', '', 'browser', 1, 1, '2020-05-19 14:00:12', 1, '2020-05-19 14:00:12', 0),
(118, 1, 'a79773fefcf8c21fc4ffd918a718a4a2', '', 'android', 1, 1, '2020-05-19 14:03:22', 1, '2020-05-19 14:03:22', 0),
(119, 1, '3cc6dd878c179c4c5e134d387e1b6919', '', 'browser', 1, 1, '2020-05-19 14:04:30', 1, '2020-05-19 14:04:30', 0),
(120, 7, '73957dc493ed5ac729347b373307bfca', '', 'browser', 1, 1, '2020-05-19 18:02:23', 7, '2020-05-19 18:02:23', 0),
(121, 7, '73957dc493ed5ac729347b373307bfca', '', 'browser', 1, 1, '2020-05-19 18:02:23', 7, '2020-05-19 18:02:23', 0),
(122, 1, '0c533ffd1832e4ad55108a6df93d162e', '', 'browser', 1, 1, '2020-05-19 21:49:17', 1, '2020-05-19 21:49:17', 0),
(123, 103, '608441bc7b8d68d6ed7a02ac88262a40', '', 'browser', 1, 1, '2020-05-19 22:28:01', 103, '2020-05-19 22:28:01', 0),
(124, 7, '6173f8dcfed967887541b569b12ea45e', '', 'android', 1, 1, '2020-05-20 00:27:09', 7, '2020-05-20 00:27:09', 0),
(125, 1, '12265071297f5254f297b70bea9200ce', '', 'android', 1, 1, '2020-05-20 01:15:14', 1, '2020-05-20 01:15:14', 0),
(126, 7, 'db3225151ae81d56e0961d94901bab2f', '', 'android', 1, 1, '2020-05-20 09:28:41', 7, '2020-05-20 09:28:41', 0),
(127, 107, '3423b8db173da595ded178ed32d80e7a', '', 'browser', 1, 1, '2020-05-20 11:56:34', 107, '2020-05-20 11:56:34', 0),
(128, 107, '8318c9298d66455234a38b23c8729cf1', '', 'android', 1, 1, '2020-05-20 11:56:57', 107, '2020-05-20 11:56:57', 0),
(129, 103, 'f9b5fb5516bef9fb0802b4097d6ebf25', '', 'browser', 1, 1, '2020-05-20 12:00:09', 103, '2020-05-20 12:00:09', 0),
(130, 103, '2d3903c2c1daeb308ad363a2cc591f0b', '', 'android', 1, 1, '2020-05-20 13:00:48', 103, '2020-05-20 13:00:48', 0),
(131, 103, '1d9c0a21f670c0dd1dec9eefbdcb9c78', '', 'browser', 1, 1, '2020-05-20 13:31:53', 103, '2020-05-20 13:31:53', 0),
(132, 103, '0fbb786ea5ed4c8e3fd68a8762639d05', '', 'android', 1, 1, '2020-05-20 14:17:59', 103, '2020-05-20 14:17:59', 0),
(133, 7, 'ed5380e82a916646f2efaa822d5c9190', '', 'browser', 1, 1, '2020-05-20 15:44:58', 7, '2020-05-20 15:44:58', 0),
(134, 108, '6a439bc16c0afc31b6685bed69552b54', '', 'browser', 1, 1, '2020-05-20 16:12:06', 108, '2020-05-20 16:12:06', 0),
(135, 108, 'b84594040b6dbf062a6dd4a1d26430e9', '', 'android', 1, 1, '2020-05-20 16:12:26', 108, '2020-05-20 16:12:26', 0),
(136, 108, 'faa42ae912c33dc09eff503c29d5f507', '', 'browser', 1, 1, '2020-05-20 16:55:05', 108, '2020-05-20 16:55:05', 0),
(137, 108, 'd6455ad39e5e7409795dbf016dea0cbc', '', 'android', 1, 1, '2020-05-20 16:56:54', 108, '2020-05-20 16:56:54', 0),
(138, 7, '053a4080d82838ad0ec91645e41191da', '', 'android', 1, 1, '2020-05-20 17:51:39', 7, '2020-05-20 17:51:39', 0),
(139, 7, '055954f4208c24b2dc5daa6054918ab4', '', 'android', 1, 1, '2020-05-20 17:55:49', 7, '2020-05-20 17:55:49', 0),
(140, 7, 'b2bb30b9688de66e07d1519e9b722626', '', 'android', 1, 1, '2020-05-20 18:14:35', 7, '2020-05-20 18:14:35', 0),
(141, 7, 'b42631a45e672d6ee3f9f88823658e47', '', 'browser', 1, 1, '2020-05-21 09:57:50', 7, '2020-05-21 09:57:50', 0),
(142, 1, '1969762295b03d2ee604cca6183570a6', '', 'browser', 1, 1, '2020-05-21 13:39:13', 1, '2020-05-21 13:39:13', 0),
(143, 7, '401fab471ee40b66b81c8251ee601495', '', 'browser', 1, 1, '2020-05-21 14:15:35', 7, '2020-05-21 14:15:35', 0),
(144, 1, 'a19db842c258c3fe29c87fefbef10c2c', '', 'android', 1, 1, '2020-05-21 14:21:45', 1, '2020-05-21 14:21:45', 0),
(145, 1, 'cacb0828892ab58a9bbb7da37810b9bc', '', 'android', 1, 1, '2020-05-21 14:22:06', 1, '2020-05-21 14:22:06', 0),
(146, 1, 'b751e8b276c319e0853f3dd10988c9cd', '', 'browser', 1, 1, '2020-05-21 15:12:50', 1, '2020-05-21 15:12:50', 0),
(147, 1, 'a668e72d4b2f4cf09a995b2c8ff5f6b2', '', 'android', 1, 1, '2020-05-21 15:32:37', 1, '2020-05-21 15:32:37', 0),
(148, 1, '0cbe682411c3087a8a6e5aad3844434c', '', 'android', 1, 1, '2020-05-21 15:34:25', 1, '2020-05-21 15:34:25', 0),
(149, 1, 'ee0ddb03db5b51a223a8baa3b283dfce', '', 'android', 1, 1, '2020-05-21 15:36:08', 1, '2020-05-21 15:36:08', 0),
(150, 103, 'd8988d64fca26dd5bd7806fe97bb23c4', '', 'browser', 1, 1, '2020-05-21 22:55:44', 103, '2020-05-21 22:55:44', 0),
(151, 7, '82a48bbe00030ee2efd8fa3cc47920bf', '', 'browser', 1, 1, '2020-05-22 14:33:59', 7, '2020-05-22 14:33:59', 0),
(152, 1, '5423a73348b96db9acc01985e8f3a419', '', 'browser', 1, 1, '2020-05-22 14:46:02', 1, '2020-05-22 14:46:02', 0),
(153, 1, 'a92044396740f6130625870482d813cd', '', 'android', 1, 1, '2020-05-22 14:53:41', 1, '2020-05-22 14:53:41', 0),
(154, 107, '2700b593f728df46dd285498cbd97235', '', 'android', 1, 1, '2020-05-22 14:56:20', 107, '2020-05-22 14:56:20', 0),
(155, 108, '063df57f0057c8fa9bb418368c53bc57', '', 'android', 1, 1, '2020-05-22 15:35:39', 108, '2020-05-22 15:35:39', 0),
(156, 108, 'a6e7647ca8553819d7492cb3af7ccc08', '', 'browser', 1, 1, '2020-05-22 15:49:10', 108, '2020-05-22 15:49:10', 0),
(157, 1, '22d2775325632fca47eb3ffcc18bb0da', '', 'browser', 1, 1, '2020-05-22 17:54:21', 1, '2020-05-22 17:54:21', 0),
(158, 1, '192b94bb01e3cd579450562feb5c6530', '', 'android', 1, 1, '2020-05-23 22:32:37', 1, '2020-05-23 22:32:37', 0),
(159, 1, '8694687b97498422c887daac8664db88', '', 'browser', 1, 1, '2020-05-25 14:22:39', 1, '2020-05-25 14:22:39', 0),
(160, 1, 'cf8ef09b301dcd89dd101cfae64ee179', '', 'browser', 1, 1, '2020-05-26 15:59:47', 1, '2020-05-26 15:59:47', 0),
(161, 1, 'f63d973f9a9e1645076c053b98827b34', '', 'browser', 1, 1, '2020-05-26 15:59:48', 1, '2020-05-26 15:59:48', 0),
(162, 1, 'e82b76224019d8bf2718469e1fb5be24', '', 'browser', 1, 1, '2020-05-26 17:57:24', 1, '2020-05-26 17:57:24', 0),
(163, 1, '2539a92af62b2f4816af4a6afe3a69cc', '', 'browser', 1, 1, '2020-05-26 17:57:35', 1, '2020-05-26 17:57:35', 0),
(164, 1, 'f42656c5a6a2404bf78f79561d2d9a40', '', 'browser', 1, 1, '2020-05-26 17:57:58', 1, '2020-05-26 17:57:58', 0),
(165, 1, 'a26ce8d51c5af2bd8cae9f524a095849', '', 'browser', 1, 1, '2020-05-26 17:58:42', 1, '2020-05-26 17:58:42', 0),
(166, 7, 'a8c952fcfe15f4d74287b4366018adb7', '', 'browser', 1, 1, '2020-05-26 17:59:00', 7, '2020-05-26 17:59:00', 0),
(167, 1, 'b14aecf96526dd761c6b75578e72abb6', '', 'browser', 1, 1, '2020-05-26 18:01:37', 1, '2020-05-26 18:01:37', 0),
(168, 1, 'b14aecf96526dd761c6b75578e72abb6', '', 'browser', 1, 1, '2020-05-26 18:01:37', 1, '2020-05-26 18:01:37', 0),
(169, 1, 'b14aecf96526dd761c6b75578e72abb6', '', 'browser', 1, 1, '2020-05-26 18:01:37', 1, '2020-05-26 18:01:37', 0),
(170, 1, 'b14aecf96526dd761c6b75578e72abb6', '', 'browser', 1, 1, '2020-05-26 18:01:37', 1, '2020-05-26 18:01:37', 0),
(171, 1, 'b14aecf96526dd761c6b75578e72abb6', '', 'browser', 1, 1, '2020-05-26 18:01:37', 1, '2020-05-26 18:01:37', 0),
(172, 1, '61b27a3e6453e17ac53adcc6e05e0c23', '', 'browser', 1, 1, '2020-05-26 18:01:38', 1, '2020-05-26 18:01:38', 0),
(173, 1, '36ea5a62a45c70677d3dc1c250bd87e9', '', 'browser', 1, 1, '2020-05-26 18:02:07', 1, '2020-05-26 18:02:07', 0),
(174, 1, '36ea5a62a45c70677d3dc1c250bd87e9', '', 'browser', 1, 1, '2020-05-26 18:02:07', 1, '2020-05-26 18:02:07', 0),
(175, 1, '26b6407f869e216d4cf8513d382c62e9', '', 'browser', 1, 1, '2020-05-26 18:02:08', 1, '2020-05-26 18:02:08', 0),
(176, 103, 'dab5b266f2bb95fd4c9738c6bcd4404a', '', 'android', 1, 1, '2020-05-27 09:40:47', 103, '2020-05-27 09:40:47', 0),
(177, 103, '9be331f51c4f174d8e42e0f38381b6e6', '', 'browser', 1, 1, '2020-05-27 10:04:08', 103, '2020-05-27 10:04:08', 0),
(178, 103, 'b8967ba585060929e771fc966c880779', '', 'android', 1, 1, '2020-05-27 10:06:10', 103, '2020-05-27 10:06:10', 0),
(179, 107, 'daf06894c8b0d2dfca6471d05c979d9f', '', 'android', 1, 1, '2020-05-27 10:24:59', 107, '2020-05-27 10:24:59', 0),
(180, 103, 'ddb1988aa2bcf407227ee0d23e7cb069', '', 'android', 1, 1, '2020-05-27 10:26:34', 103, '2020-05-27 10:26:34', 0),
(181, 103, '12bb0317466b7bacd8ada123cb05cd04', '', 'browser', 1, 1, '2020-05-27 10:36:52', 103, '2020-05-27 10:36:52', 0),
(182, 1, '13dbf8d22db12278f4999dc651999144', '', 'android', 1, 1, '2020-05-27 11:44:41', 1, '2020-05-27 11:44:41', 0),
(183, 1, '56756883588f6a31d03481431d87b7b9', '', 'browser', 1, 1, '2020-05-27 11:45:33', 1, '2020-05-27 11:45:33', 0),
(184, 103, '6573186ef0c3260021aefcde3c73a70f', '', 'android', 1, 1, '2020-05-27 11:56:54', 103, '2020-05-27 11:56:54', 0),
(185, 1, 'd98646a72c53545d522697d81be21efc', '', 'browser', 1, 1, '2020-05-27 12:02:47', 1, '2020-05-27 12:02:47', 0),
(186, 1, '24e9fd088e2b6b678bda72716f11ae27', '', 'android', 1, 1, '2020-05-27 12:02:56', 1, '2020-05-27 12:02:56', 0),
(187, 1, 'f30aa31bacc48eeaae5d91c8f00f9afb', '', 'browser', 1, 1, '2020-05-27 12:48:37', 1, '2020-05-27 12:48:37', 0),
(188, 1, '869361c449d3db3ef94a18857673c729', '', 'browser', 1, 1, '2020-05-27 12:49:13', 1, '2020-05-27 12:49:13', 0),
(189, 1, 'dbfa31a091e99e12bb830d35c878883b', '', 'browser', 1, 1, '2020-05-27 13:04:36', 1, '2020-05-27 13:04:36', 0),
(190, 1, '193f15d4ee8cfb304ad3bdc3b5872679', '', 'browser', 1, 1, '2020-05-27 13:07:16', 1, '2020-05-27 13:07:16', 0),
(191, 103, '9f5a2d729a01192b544f427b1a6c6dc1', '', 'browser', 1, 1, '2020-05-27 13:12:59', 103, '2020-05-27 13:12:59', 0),
(192, 107, '04e3a49a8a491b492e3d91317a3ccbbe', '', 'android', 1, 1, '2020-05-27 13:35:45', 107, '2020-05-27 13:35:45', 0),
(193, 107, '5c65a187bf77325bde263891c5df4a75', '', 'android', 1, 1, '2020-05-27 14:05:00', 107, '2020-05-27 14:05:00', 0),
(194, 107, '8901560c729e2b3b0cbe29b323d88f3f', '', 'browser', 1, 1, '2020-05-27 14:05:15', 107, '2020-05-27 14:05:15', 0),
(195, 107, '93789f8d4fda2aa1b0114ec37fca1b0d', '', 'android', 1, 1, '2020-05-27 14:35:56', 107, '2020-05-27 14:35:56', 0),
(196, 108, '6d8b0e396b6d67ba669eae2d6b3f7c63', '', 'android', 1, 1, '2020-05-27 14:38:17', 108, '2020-05-27 14:38:17', 0),
(197, 108, '1a3b5c6f1cc14d878ab23933e8181c4e', '', 'browser', 1, 1, '2020-05-27 14:41:01', 108, '2020-05-27 14:41:01', 0),
(198, 103, '60ece4b63e39699c3c161abef6219663', '', 'browser', 1, 1, '2020-05-27 14:49:57', 103, '2020-05-27 14:49:57', 0),
(199, 103, 'daf293ba6778964b18a167e1d64b95fd', '', 'android', 1, 1, '2020-05-27 14:50:46', 103, '2020-05-27 14:50:46', 0),
(200, 1, 'baf5e74c78c3dc775b4dc01a83ff8512', '', 'android', 1, 1, '2020-05-27 19:26:57', 1, '2020-05-27 19:26:57', 0),
(201, 1, '3d2d57e5b98f86ca3a44fb204760a3fe', '', 'browser', 1, 1, '2020-05-27 19:41:05', 1, '2020-05-27 19:41:05', 0),
(202, 107, '4d138d07764c7405fd40ca5b85b84f35', '', 'browser', 1, 1, '2020-05-28 09:28:38', 107, '2020-05-28 09:28:38', 0),
(203, 107, '3e856500b90bd33cf4214fe7dfe3f400', '', 'android', 1, 1, '2020-05-28 09:31:09', 107, '2020-05-28 09:31:09', 0),
(204, 1, '811ac7a95f25138f7ff26b6d9bd3169b', '', 'browser', 1, 1, '2020-05-28 10:16:48', 1, '2020-05-28 10:16:48', 0),
(205, 107, '96b5d28f1ae16365d1288098642db3a2', '', 'browser', 1, 1, '2020-05-28 10:17:22', 107, '2020-05-28 10:17:22', 0),
(206, 103, 'cfcd261cdd280e4ccaa2cd3f7afa21da', '', 'android', 1, 1, '2020-05-28 10:18:54', 103, '2020-05-28 10:18:54', 0),
(207, 103, '0314b158cf2e059c0d3e971070de3830', '', 'browser', 1, 1, '2020-05-28 10:19:05', 103, '2020-05-28 10:19:05', 0),
(208, 110, '59b85b9bae547e76746a3fcc9896c894', '', 'ForgetPassword', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(209, 108, '4f694ddb7a8359e939a7b09afab9bcf8', '', 'android', 1, 1, '2020-05-28 10:29:21', 108, '2020-05-28 10:29:21', 0),
(210, 108, '82319cba8f514f9f392c40cbb2c2e098', '', 'browser', 1, 1, '2020-05-28 10:29:47', 108, '2020-05-28 10:29:47', 0),
(211, 110, '0fc5af893eab26ea42ca9ba905053c48', '', 'android', 1, 1, '2020-05-28 14:48:07', 110, '2020-05-28 14:48:07', 0),
(213, 110, '3f840d6e7215c58ed57cdb693b195bce', '', 'android', 1, 1, '2020-05-28 14:53:09', 110, '2020-05-28 14:53:09', 0),
(215, 110, '4cf35592047d40ea3b3ab239fddf31a2', '', 'android', 1, 1, '2020-05-28 14:54:04', 110, '2020-05-28 14:54:04', 0),
(216, 103, 'c090319b930c94c1f0af466f4eef6af3', '', 'android', 1, 1, '2020-05-28 14:54:26', 103, '2020-05-28 14:54:26', 0),
(217, 1, '72545627d1315d01eae760fec3bd70ac', '', 'android', 1, 1, '2020-05-28 15:13:44', 1, '2020-05-28 15:13:44', 0),
(218, 103, 'cff15f6c81437dec3ea1dd8b1e729354', '', 'browser', 1, 1, '2020-05-28 15:27:00', 103, '2020-05-28 15:27:00', 0),
(219, 1, '45fb375fdfa6c114658828b63403b381', '', 'browser', 1, 1, '2020-05-28 16:00:28', 1, '2020-05-28 16:00:28', 0),
(220, 1, '6a3d1766dd9d9c5dae1ae340bc9eb896', '', 'android', 1, 1, '2020-05-28 17:30:58', 1, '2020-05-28 17:30:58', 0),
(221, 1, '42f1d05b2bc672e6b3225ebe43ba888c', '', 'android', 1, 1, '2020-05-28 21:31:43', 1, '2020-05-28 21:31:43', 0),
(222, 1, '38ec4e4d08f31d8a98d51d03954fd5e0', '', 'browser', 1, 1, '2020-05-28 23:13:16', 1, '2020-05-28 23:13:16', 0),
(223, 1, 'ac05ce3ee7e6f4bd9000edc85978fbee', '', 'android', 1, 1, '2020-05-28 23:15:29', 1, '2020-05-28 23:15:29', 0),
(224, 1, 'ca7489c58c022ba6e487adc32a4c57ab', '', 'browser', 1, 1, '2020-05-29 01:05:24', 1, '2020-05-29 01:05:24', 0),
(225, 1, 'ca7489c58c022ba6e487adc32a4c57ab', '', 'browser', 1, 1, '2020-05-29 01:05:24', 1, '2020-05-29 01:05:24', 0),
(226, 107, 'be2997c5f61280b01bf0f347ce80f843', '', 'browser', 1, 1, '2020-05-29 09:02:12', 107, '2020-05-29 09:02:12', 0),
(227, 107, '36f823e6ad5281fdd2c3269480ac6d82', '', 'android', 1, 1, '2020-05-29 09:04:44', 107, '2020-05-29 09:04:44', 0),
(228, 103, '879b11e4e87b6bb671d91b8b643891e3', '', 'android', 1, 1, '2020-05-29 09:07:55', 103, '2020-05-29 09:07:55', 0),
(229, 107, '88fc878216823b8a7269aa6198a1e2df', '', 'android', 1, 1, '2020-05-29 09:12:39', 107, '2020-05-29 09:12:39', 0),
(230, 107, '307a16b056a9b1c53739cf273be4c75b', '', 'browser', 1, 1, '2020-05-29 10:10:13', 107, '2020-05-29 10:10:13', 0),
(231, 1, '7af0d95f1133cf84448e05e1fc8c8ec6', '', 'android', 1, 1, '2020-05-29 14:43:27', 1, '2020-05-29 14:43:27', 0),
(232, 107, '14f78f63b66965bb62832297879461a2', '', 'android', 1, 1, '2020-05-29 14:47:25', 107, '2020-05-29 14:47:25', 0),
(233, 1, '34cac4719ae07030cb785855ab726cbb', '', 'android', 1, 1, '2020-05-29 14:51:14', 1, '2020-05-29 14:51:14', 0),
(234, 1, '1b8af22621ecf96fa015b23dfa4e83a3', '', 'browser', 1, 1, '2020-05-29 14:54:07', 1, '2020-05-29 14:54:07', 0),
(235, 103, '91c734cf9c3455e1818d3241444fb9b8', '', 'android', 1, 1, '2020-05-29 15:03:41', 103, '2020-05-29 15:03:41', 0),
(236, 103, 'f2d2874c595c77f69f86c15bdc89bf09', '', 'browser', 1, 1, '2020-05-29 15:04:10', 103, '2020-05-29 15:04:10', 0),
(237, 1, '9a87a0ef523f15646393a7ce565e8449', '', 'browser', 1, 1, '2020-05-29 15:46:27', 1, '2020-05-29 15:46:27', 0),
(238, 1, '6f6c89970344a50ab9f42bca20b14e9e', '', 'android', 1, 1, '2020-05-29 16:21:56', 1, '2020-05-29 16:21:56', 0),
(239, 1, 'c18c1444a7c926921777f4244ca36c19', '', 'android', 1, 1, '2020-05-29 16:51:30', 1, '2020-05-29 16:51:30', 0),
(240, 1, '6d122eddbf212731b9bcc98fb9474b91', '', 'android', 1, 1, '2020-05-29 16:53:28', 1, '2020-05-29 16:53:28', 0),
(241, 103, 'ed536cae8cdb99e24a053824ab2f80c3', '', 'browser', 1, 1, '2020-05-29 16:55:40', 103, '2020-05-29 16:55:40', 0),
(242, 103, 'PasNew@866e2f7a0d01e8ad9e4d5f39e2daa847', '', 'ForgetPassword', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(243, 103, '68ccebd3e3e3876bfd4e7ac7bcfc0bb4', '', 'browser', 1, 1, '2020-05-29 16:56:28', 103, '2020-05-29 16:56:28', 0),
(244, 1, 'b54995adffbd6562ba2ba2de41ea4226', '', 'android', 1, 1, '2020-05-29 17:00:32', 1, '2020-05-29 17:00:32', 0),
(245, 1, '36382d5f063829fac57969e9537ac43b', '', 'browser', 1, 1, '2020-05-29 17:03:01', 1, '2020-05-29 17:03:01', 0),
(246, 107, '095995bf5aa5a433bc8391566e37ce15', '', 'browser', 1, 1, '2020-05-29 17:11:29', 107, '2020-05-29 17:11:29', 0),
(247, 117, '5fe95d5d465433ad6f0cc1195db25cfd', '', 'browser', 1, 1, '2020-05-29 17:15:00', 117, '2020-05-29 17:15:00', 0),
(248, 117, 'PasNew@7a9a23fdf30a1083f6b2be149493a365', '', 'ForgetPassword', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(249, 111, 'PasNew@7d71dff005c7e472e2b3e03a3acb67cb', '', 'ForgetPassword', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(250, 110, 'PasNew@012b30f339aa4980d501b914787a63ef', '', 'ForgetPassword', 1, 1, '2019-01-01 00:00:00', 0, '2019-01-01 00:00:00', 0),
(252, 116, 'b4346c0d9d9d8c5710c39da0fffffee8', '', 'browser', 1, 1, '2020-05-29 17:43:28', 116, '2020-05-29 17:43:28', 0),
(253, 116, '0e70881c3dd9f26cdbce1b73bcfd3be8', '', 'android', 1, 1, '2020-05-29 17:43:39', 116, '2020-05-29 17:43:39', 0),
(254, 1, 'aecd80063e17b310cfa0367868898793', '', 'browser', 1, 1, '2020-05-29 17:47:24', 1, '2020-05-29 17:47:24', 0),
(255, 1, 'e6861f0cc9dca74d25f9c882c2adfe4e', '', 'browser', 1, 1, '2020-05-30 00:33:20', 1, '2020-05-30 00:33:20', 0),
(256, 1, '30e92cf1d46b015317e00f41aeb336c1', '', 'android', 1, 1, '2020-05-30 00:34:06', 1, '2020-05-30 00:34:06', 0),
(257, 1, '267cd10d7f48532f3cb57bd9b8ffca43', '', 'android', 1, 1, '2020-05-30 11:24:41', 1, '2020-05-30 11:24:41', 0),
(258, 1, '75040bef729933fb6c382e157ac05637', '', 'browser', 1, 1, '2020-05-30 11:25:23', 1, '2020-05-30 11:25:23', 0),
(259, 1, '6026cacedf6a13d06ea1e9a9bde7d877', '', 'browser', 1, 1, '2020-05-30 11:25:59', 1, '2020-05-30 11:25:59', 0),
(260, 1, '6b57b8c13a09921347619c538a32cff0', '', 'browser', 1, 1, '2020-05-31 14:24:16', 1, '2020-05-31 14:24:16', 0),
(261, 103, 'f46c40e0cb45a3fd682b827d0e5ae3cb', '', 'android', 1, 1, '2020-06-02 10:31:13', 103, '2020-06-02 10:31:13', 0),
(262, 107, '2b01a8cc4536f8f98e460050aa5f997e', '', 'android', 1, 1, '2020-06-02 10:50:49', 107, '2020-06-02 10:50:49', 0),
(263, 103, '7b0fb4375ef2223e3087ba56aa345456', '', 'android', 1, 1, '2020-06-02 10:54:47', 103, '2020-06-02 10:54:47', 0),
(264, 1, 'eb927fc6d090d2a88288d23bf403def1', '', 'browser', 1, 1, '2020-06-02 17:16:41', 1, '2020-06-02 17:16:41', 0),
(265, 1, 'ab889899a11e14d9a80b5d1b6c37002a', '', 'android', 1, 1, '2020-06-02 17:19:44', 1, '2020-06-02 17:19:44', 0),
(266, 1, '8d3c7afd9a2bcc8a8fa086c1b59e21e7', '', 'browser', 1, 1, '2020-06-02 17:21:17', 1, '2020-06-02 17:21:17', 0),
(267, 107, '8624764ab464be5b8e21826aba68ed06', '', 'android', 1, 1, '2020-06-02 17:21:20', 107, '2020-06-02 17:21:20', 0),
(268, 1, '60d3f6eff0f0735138a8a50e5b69349e', '', 'android', 1, 1, '2020-06-02 17:21:36', 1, '2020-06-02 17:21:36', 0),
(269, 1, 'ae927114b1d40729c6f932ccc386fcad', '', 'browser', 1, 1, '2020-06-02 17:22:41', 1, '2020-06-02 17:22:41', 0),
(270, 1, '3c852c0854f756fdaf56dd2d88a1d5e4', '', 'android', 1, 1, '2020-06-02 17:27:47', 1, '2020-06-02 17:27:47', 0),
(271, 1, '06a73c7aa927c2efd3df9176003065e8', '', 'android', 1, 1, '2020-06-02 18:54:15', 1, '2020-06-02 18:54:15', 0),
(272, 103, 'e83f0f559b20050415c0ded6be2e23fb', '', 'android', 1, 1, '2020-06-03 08:58:03', 103, '2020-06-03 08:58:03', 0),
(273, 1, '598ec46130be98b02ca1d3ae4c50ab95', '', 'android', 1, 1, '2020-06-03 10:48:15', 1, '2020-06-03 10:48:15', 0),
(274, 1, '001d899795b2e5c3f5a067553b70ce94', '', 'android', 1, 1, '2020-06-03 10:49:03', 1, '2020-06-03 10:49:03', 0),
(275, 1, 'e113a70b38be666662991eb467dc7354', '', 'browser', 1, 1, '2020-06-03 16:47:13', 1, '2020-06-03 16:47:13', 0),
(276, 1, 'd9a9df5b1403793671a0beb9b7c42f98', '', 'browser', 1, 1, '2020-06-03 16:53:02', 1, '2020-06-03 16:53:02', 0),
(277, 103, 'b0147411dd2e1c19ee6a41d8a038c3be', '', 'android', 1, 1, '2020-06-03 17:02:00', 103, '2020-06-03 17:02:00', 0),
(278, 1, '6f4ac4d45d1cc8df0a40a09f0d9351be', '', 'browser', 1, 1, '2020-06-03 21:38:23', 1, '2020-06-03 21:38:23', 0),
(279, 1, '6b792ac65e0e7c1b4533959aa74665c8', '', 'android', 1, 1, '2020-06-03 21:50:38', 1, '2020-06-03 21:50:38', 0),
(280, 107, 'eb56d7013c4bcea939703319159cc334', '', 'android', 1, 1, '2020-06-04 09:32:33', 107, '2020-06-04 09:32:33', 0),
(281, 1, '6713ccf5c5eec40988a4da035c3e01ba', '', 'browser', 1, 1, '2020-06-04 11:16:28', 1, '2020-06-04 11:16:28', 0),
(282, 107, '4c034cf67a9efe7ddfc1ed64210df335', '', 'browser', 1, 1, '2020-06-04 11:23:32', 107, '2020-06-04 11:23:32', 0),
(283, 108, '7bccd7f271aeb80dec1cb500f9ecf62e', '', 'android', 1, 1, '2020-06-04 13:48:56', 108, '2020-06-04 13:48:56', 0),
(284, 103, 'ad0f15a04fdc0166b12b623bc14cbd9f', '', 'android', 1, 1, '2020-06-04 13:49:49', 103, '2020-06-04 13:49:49', 0),
(285, 107, '135ab258eb4f7ef801cc393a1a86f011', '', 'android', 1, 1, '2020-06-04 13:53:45', 107, '2020-06-04 13:53:45', 0),
(286, 1, 'aebcef86398d319316db0e619f258f7d', '', 'browser', 1, 1, '2020-06-05 15:48:34', 1, '2020-06-05 15:48:34', 0),
(287, 1, 'd3826a8ea9bc41b5f06c616ec89de463', '', 'android', 1, 1, '2020-06-05 15:51:58', 1, '2020-06-05 15:51:58', 0),
(288, 1, 'c8ee6b99d90e80f3f6f94a6b03a32d1b', '', 'browser', 1, 1, '2020-06-06 14:24:48', 1, '2020-06-06 14:24:48', 0),
(289, 1, 'db5c5b576ecf5a3be4eb525ded3f1bec', '', 'android', 1, 1, '2020-06-06 14:25:44', 1, '2020-06-06 14:25:44', 0),
(290, 1, '37d0f9103a2498eead4f78a3880e698a', '', 'browser', 1, 1, '2020-06-08 14:06:17', 1, '2020-06-08 14:06:17', 0),
(291, 1, 'f40339f57026acefb15fc02013c03102', '', 'browser', 1, 1, '2020-06-08 17:08:51', 1, '2020-06-08 17:08:51', 0),
(292, 103, '829e34ecd61fa93bc06a7b72576591b8', '', 'browser', 1, 1, '2020-06-09 10:29:52', 103, '2020-06-09 10:29:52', 0),
(293, 1, 'b320037e9c181d565a985ec11c0828ae', '', 'browser', 1, 1, '2020-06-09 10:37:23', 1, '2020-06-09 10:37:23', 0),
(294, 103, '9dc8d6c6e778c294d58a7e7349286c75', '', 'browser', 1, 1, '2020-06-09 15:01:41', 103, '2020-06-09 15:01:41', 0),
(295, 107, 'ef2d82b7165ea237afe9b1492fe5fc3b', '', 'browser', 1, 1, '2020-06-09 15:03:32', 107, '2020-06-09 15:03:32', 0),
(296, 1, '0b97fc285fb74d035170afab58e45823', '', 'browser', 1, 1, '2020-06-10 00:03:29', 1, '2020-06-10 00:03:29', 0),
(297, 1, '99141c38b835d31d61f2c24dfbbaf447', '', 'browser', 1, 1, '2020-06-10 11:00:16', 1, '2020-06-10 11:00:16', 0),
(298, 1, '48229e92ffd0cc23d069616c3abd9957', '', 'browser', 1, 1, '2020-06-10 11:01:58', 1, '2020-06-10 11:01:58', 0),
(299, 1, '3defc354886ec88df744456302d77795', '', 'browser', 1, 1, '2020-06-10 15:18:44', 1, '2020-06-10 15:18:44', 0),
(300, 1, '7630848b4cf6147a24ac70c4ab046b70', '', 'browser', 1, 1, '2020-06-10 15:45:32', 1, '2020-06-10 15:45:32', 0),
(301, 107, 'fdb4cc2838a9841fd5e6aa2bf304eddd', '', 'browser', 1, 1, '2020-06-11 09:13:46', 107, '2020-06-11 09:13:46', 0),
(302, 103, 'c2671f379a8b3fc6bdba7a3c752ce848', '', 'android', 1, 1, '2020-06-11 09:53:06', 103, '2020-06-11 09:53:06', 0),
(303, 103, '42e2b397ecbc4fdf60544054c8e2f4b4', '', 'browser', 1, 1, '2020-06-11 09:53:16', 103, '2020-06-11 09:53:16', 0),
(304, 108, 'bebcf60cbecc304960e97198d22cf0af', '', 'android', 1, 1, '2020-06-11 10:10:58', 108, '2020-06-11 10:10:58', 0),
(305, 108, 'a2fbe37d9abd4046d1fff188eb5768a7', '', 'browser', 1, 1, '2020-06-11 10:11:18', 108, '2020-06-11 10:11:18', 0),
(306, 107, 'b8350ce72daa4d0085ca4faa1e39e9d1', '', 'browser', 1, 1, '2020-06-11 11:18:01', 107, '2020-06-11 11:18:01', 0),
(307, 1, '0b2d99897004631f6d24248358019376', '', 'browser', 1, 1, '2020-06-11 14:37:54', 1, '2020-06-11 14:37:54', 0),
(308, 107, '47fb97bfd39afeb18455b16e67bf6dfa', '', 'android', 1, 1, '2020-06-15 08:45:51', 107, '2020-06-15 08:45:51', 0),
(309, 103, 'c1ecb0547b9a7347c2ed324ba46e0545', '', 'android', 1, 1, '2020-06-15 10:14:30', 103, '2020-06-15 10:14:30', 0),
(310, 103, '98c7d8b5778b6192e049ff49fc98800f', '', 'browser', 1, 1, '2020-06-15 14:09:16', 103, '2020-06-15 14:09:16', 0),
(311, 107, '52d05be473c6535a9c126eeb91125a91', '', 'android', 1, 1, '2020-06-15 14:30:19', 107, '2020-06-15 14:30:19', 0),
(312, 107, 'c5c1692e8169d2484ae4fe70a465bed3', '', 'browser', 1, 1, '2020-06-15 14:30:29', 107, '2020-06-15 14:30:29', 0),
(313, 1, 'b70f18ed08f210e71585e028e76eb100', '', 'browser', 1, 1, '2020-06-15 15:17:22', 1, '2020-06-15 15:17:22', 0),
(314, 1, 'c7a93d0484fb042e758834119220ce82', '', 'android', 1, 1, '2020-06-15 16:23:41', 1, '2020-06-15 16:23:41', 0),
(315, 103, 'd40f639fb2f62591deb1bf31cea85f12', '', 'browser', 1, 1, '2020-06-15 16:56:42', 103, '2020-06-15 16:56:42', 0),
(316, 103, '3c58b669973170cc649818b7399582e0', '', 'android', 1, 1, '2020-06-16 07:57:48', 103, '2020-06-16 07:57:48', 0),
(317, 107, '1fb766291fc074dc1bbb3c70f727910e', '', 'android', 1, 1, '2020-06-16 08:42:54', 107, '2020-06-16 08:42:54', 0),
(318, 107, '8dbce6a96ae8f26c129a04542bf14b59', '', 'browser', 1, 1, '2020-06-16 08:44:12', 107, '2020-06-16 08:44:12', 0),
(319, 108, 'cd87a0c0e04d3d0ba200655df757fe2f', '', 'browser', 1, 1, '2020-06-16 09:37:25', 108, '2020-06-16 09:37:25', 0),
(320, 108, 'e6fcd87431eb0b9c9b8a7eb2a59dbe32', '', 'android', 1, 1, '2020-06-16 09:37:53', 108, '2020-06-16 09:37:53', 0),
(321, 103, '14fa6e91059f5413bfe03f9b19a26ca2', '', 'browser', 1, 1, '2020-06-16 09:41:27', 103, '2020-06-16 09:41:27', 0),
(322, 103, '1da061ed34ff9ce8802734d7bf7bb5fa', '', 'android', 1, 1, '2020-06-16 09:41:40', 103, '2020-06-16 09:41:40', 0),
(323, 1, '208f9f0d56342f9c1b3ea4ea40439f1b', '', 'browser', 1, 1, '2020-06-16 11:31:09', 1, '2020-06-16 11:31:09', 0),
(324, 107, '90504142ceab1aea5c184f814cec067b', '', 'android', 1, 1, '2020-06-16 16:42:29', 107, '2020-06-16 16:42:29', 0),
(325, 107, '2301c4be227cba0df447b82336db315a', '', 'browser', 1, 1, '2020-06-16 16:43:53', 107, '2020-06-16 16:43:53', 0),
(326, 1, 'b0437a41574efe5691b711927a14887f', '', 'browser', 1, 1, '2020-06-17 11:18:18', 1, '2020-06-17 11:18:18', 0),
(327, 103, 'd474ae90c0c1cf1c2e8a136c4c3a07c6', '', 'browser', 1, 1, '2020-06-17 16:55:05', 103, '2020-06-17 16:55:05', 0),
(328, 103, '36b041489988721bc8295354926af0fd', '', 'android', 1, 1, '2020-06-17 16:55:12', 103, '2020-06-17 16:55:12', 0),
(329, 107, 'c99796861aa370743fd80fc495d676ce', '', 'browser', 1, 1, '2020-06-17 16:56:11', 107, '2020-06-17 16:56:11', 0),
(330, 1, '63bf29e7ec830f0a19796dcceede7719', '', 'browser', 1, 1, '2020-06-17 17:00:19', 1, '2020-06-17 17:00:19', 0),
(331, 107, '4244d8f145d3ad07cced201d6926ad1c', '', 'android', 1, 1, '2020-06-17 17:01:18', 107, '2020-06-17 17:01:18', 0),
(332, 103, 'fd7d2817f07ef96387676e1fe9a9af95', '', 'android', 1, 1, '2020-06-17 17:02:11', 103, '2020-06-17 17:02:11', 0),
(333, 103, '555ed6c1d9eda9cdfaa23155a5033204', '', 'browser', 1, 1, '2020-06-17 17:05:44', 103, '2020-06-17 17:05:44', 0),
(334, 107, '16bdb0b9e1d1e26d33429915431a44dc', '', 'browser', 1, 1, '2020-06-17 17:07:57', 107, '2020-06-17 17:07:57', 0),
(335, 107, 'bd00ffe15197cd34919465906d843019', '', 'android', 1, 1, '2020-06-17 17:08:11', 107, '2020-06-17 17:08:11', 0),
(336, 103, '3f581d4bc7a45ed7396ed6fc884b4be8', '', 'android', 1, 1, '2020-06-17 17:25:08', 103, '2020-06-17 17:25:08', 0),
(337, 1, 'f003cdec47b053e05417d38c8d61e48b', '', 'browser', 1, 1, '2020-06-19 13:46:25', 1, '2020-06-19 13:46:25', 0),
(338, 1, 'd31681ed37c4b4311a941583c54e9bb1', '', 'browser', 1, 1, '2020-06-22 01:42:32', 1, '2020-06-22 01:42:32', 0),
(339, 1, '3336ffab428e614bea1080d0b6be6e7e', '', 'browser', 1, 1, '2020-06-22 01:42:33', 1, '2020-06-22 01:42:33', 0),
(340, 1, 'd40f6637ba7518c3ced614a68b24c946', '', 'browser', 1, 1, '2020-06-22 01:42:38', 1, '2020-06-22 01:42:38', 0),
(341, 103, 'b2702519b63dec31b4bb5f99f3a5903d', '', 'browser', 1, 1, '2020-06-22 01:42:41', 103, '2020-06-22 01:42:41', 0),
(342, 103, '8a23df58cc4f14ae807768acc9bdec89', '', 'browser', 1, 1, '2020-06-22 01:42:42', 103, '2020-06-22 01:42:42', 0),
(343, 103, '8a23df58cc4f14ae807768acc9bdec89', '', 'browser', 1, 1, '2020-06-22 01:42:42', 103, '2020-06-22 01:42:42', 0),
(344, 1, 'd97b1d00d8e7dd928de7a858e9dde2bb', '', 'browser', 1, 1, '2020-06-22 01:42:52', 1, '2020-06-22 01:42:52', 0),
(345, 1, '6fd376b93a1df548ec4f3e2002bf84d7', '', 'browser', 1, 1, '2020-06-22 01:43:02', 1, '2020-06-22 01:43:02', 0),
(346, 1, 'aa8177ef6de46d8d38e44dde909523e6', '', 'browser', 1, 1, '2020-06-22 01:43:03', 1, '2020-06-22 01:43:03', 0),
(347, 1, 'e4e67c2729d87e73bdd31c22eb01d1a9', '', 'android', 1, 1, '2020-06-22 01:43:39', 1, '2020-06-22 01:43:39', 0),
(348, 1, '630b544bd11576e1f09fa1bf49f9182f', '', 'android', 1, 1, '2020-06-22 01:43:57', 1, '2020-06-22 01:43:57', 0),
(349, 1, '5d510d666baa0b2cef8d59f254761bc3', '', 'browser', 1, 1, '2020-06-22 10:35:12', 1, '2020-06-22 10:35:12', 0),
(350, 103, 'ad023ceafaa6b1f67acca6293fddf08f', '', 'android', 1, 1, '2020-06-22 14:18:43', 103, '2020-06-22 14:18:43', 0),
(351, 107, '41560fe70d0c1b762843a331caba7e8c', '', 'browser', 1, 1, '2020-06-22 14:48:03', 107, '2020-06-22 14:48:03', 0),
(352, 103, '4278f07207a4a27a09b469277e111ad3', '', 'android', 1, 1, '2020-06-22 17:04:49', 103, '2020-06-22 17:04:49', 0),
(353, 103, '740b3bd434571085e5390aef7bdc3955', '', 'browser', 1, 1, '2020-06-22 17:07:54', 103, '2020-06-22 17:07:54', 0),
(354, 1, 'a1d3026b64dc05bdadc548ce70f35d20', '', 'browser', 1, 1, '2020-06-23 22:46:38', 1, '2020-06-23 22:46:38', 0),
(355, 1, '0dd78bac81ae07f87226234385578b98', '', 'browser', 1, 1, '2020-06-24 13:12:47', 1, '2020-06-24 13:12:47', 0),
(356, 103, '4cda7905929a3b726ca852c0fa0853d5', '', 'browser', 1, 1, '2020-06-24 14:47:26', 103, '2020-06-24 14:47:26', 0),
(357, 107, '4c9f0dfb2b89baf0136f6e5747c2f2f7', '', 'android', 1, 1, '2020-06-24 16:46:27', 107, '2020-06-24 16:46:27', 0),
(358, 1, 'c00faa9efb8a11366828ebdc4215d37b', '', 'browser', 1, 1, '2020-06-24 23:40:44', 1, '2020-06-24 23:40:44', 0),
(359, 103, 'd5891e776ff8eb54706a9bebbac80e30', '', 'browser', 1, 1, '2020-06-25 09:52:14', 103, '2020-06-25 09:52:14', 0),
(360, 1, '495c9ecc4bf897de9092ee3fbbedfb27', '', 'browser', 1, 1, '2020-06-25 11:07:15', 1, '2020-06-25 11:07:15', 0),
(361, 103, 'c4de6aae863512c7994e89bc324234bd', '', 'android', 1, 1, '2020-06-25 11:15:04', 103, '2020-06-25 11:15:04', 0),
(362, 107, 'd46cdffbdfa46f0a9839fbf0551b8b03', '', 'android', 1, 1, '2020-06-25 14:05:55', 107, '2020-06-25 14:05:55', 0),
(363, 107, '93710a65aa2d4fb84bf18a0573333088', '', 'browser', 1, 1, '2020-06-25 14:06:29', 107, '2020-06-25 14:06:29', 0),
(364, 107, '653cf7e220db51bdf7dc9e294e195acc', '', 'browser', 1, 1, '2020-06-25 14:48:58', 107, '2020-06-25 14:48:58', 0),
(365, 103, 'b3c9473c1b5bb7358bb5da5eb2f9bab9', '', 'android', 1, 1, '2020-06-25 15:00:59', 103, '2020-06-25 15:00:59', 0),
(366, 7, '9d88619af33deb5a3d2ceaf362036c9f', '', 'android', 1, 1, '2020-06-26 13:34:02', 7, '2020-06-26 13:34:02', 0),
(367, 1, '055fa2725f0f7fad588300e84848ce1b', '', 'browser', 1, 1, '2020-06-26 13:58:57', 1, '2020-06-26 13:58:57', 0),
(368, 7, 'b4d56ec366d2a577dae29e8b3ec98716', '', 'android', 1, 1, '2020-06-26 15:35:47', 7, '2020-06-26 15:35:47', 0),
(369, 103, '6c5a02cc004d19e4deb5afcc0633fc0d', '', 'browser', 1, 1, '2020-06-26 16:06:52', 103, '2020-06-26 16:06:52', 0),
(370, 103, 'e88786625afd68846ab92ea73c817bf0', '', 'browser', 1, 1, '2020-06-26 16:30:38', 103, '2020-06-26 16:30:38', 0),
(371, 103, '984cb3fd8f925abc4fd48845580ba6f8', '', 'browser', 1, 1, '2020-06-26 16:31:14', 103, '2020-06-26 16:31:14', 0),
(372, 103, 'a87a5ae07e4c3abb49cca74967b2f16d', '', 'browser', 1, 1, '2020-06-29 09:21:43', 103, '2020-06-29 09:21:43', 0),
(373, 1, '0e924aab000d1089ae48f8d2eda3d466', '', 'android', 1, 1, '2020-06-29 11:40:37', 1, '2020-06-29 11:40:37', 0),
(374, 1, 'fad6db0b2f8d13a5d73f80bf560ee827', '', 'browser', 1, 1, '2020-06-29 13:01:25', 1, '2020-06-29 13:01:25', 0),
(375, 103, '24e859f0648015717425507044524237', '', 'browser', 1, 1, '2020-06-30 09:25:00', 103, '2020-06-30 09:25:00', 0),
(376, 1, '34b8cc7a1a1e5bc0c993922a14e7350c', '', 'browser', 1, 1, '2020-06-30 11:05:56', 1, '2020-06-30 11:05:56', 0),
(377, 1, '3633bfd48e2bf7be0e4009fafafb7cb1', '', 'browser', 1, 1, '2020-06-30 11:06:23', 1, '2020-06-30 11:06:23', 0),
(378, 1, 'cbb041d7416212bb72f49730425df823', '', 'browser', 1, 1, '2020-06-30 12:55:26', 1, '2020-06-30 12:55:26', 0),
(379, 107, '23bc7fe956b61eb45260b66dbab2030d', '', 'android', 1, 1, '2020-06-30 14:18:51', 107, '2020-06-30 14:18:51', 0),
(380, 103, '11ef9a912321a92b77fce64ab56ef63e', '', 'browser', 1, 1, '2020-06-30 15:27:38', 103, '2020-06-30 15:27:38', 0),
(381, 103, 'd1bf801278d947e3850a026f0caa9a30', '', 'browser', 1, 1, '2020-07-01 08:53:23', 103, '2020-07-01 08:53:23', 0),
(382, 103, '9990982b14bfc33ddebc668bb9b9f714', '', 'android', 1, 1, '2020-07-01 08:59:14', 103, '2020-07-01 08:59:14', 0),
(383, 103, '0002fcc2cf5b489d383f9fb9d7bafe9d', '', 'browser', 1, 1, '2020-07-01 13:45:32', 103, '2020-07-01 13:45:32', 0),
(384, 103, 'e4d1d9c74df86fc838ce443f164cd043', '', 'browser', 1, 1, '2020-07-01 14:46:42', 103, '2020-07-01 14:46:42', 0),
(385, 103, '8ede53b579ada6e189594961ea652b35', '', 'browser', 1, 1, '2020-07-06 10:43:02', 103, '2020-07-06 10:43:02', 0),
(386, 103, '0d80ffa06ca1a3e72589d8bf4c018d28', '', 'browser', 1, 1, '2020-07-06 13:04:47', 103, '2020-07-06 13:04:47', 0),
(387, 103, '0d80ffa06ca1a3e72589d8bf4c018d28', '', 'browser', 1, 1, '2020-07-06 13:04:47', 103, '2020-07-06 13:04:47', 0),
(388, 103, '0d80ffa06ca1a3e72589d8bf4c018d28', '', 'browser', 1, 1, '2020-07-06 13:04:47', 103, '2020-07-06 13:04:47', 0),
(389, 103, '0d80ffa06ca1a3e72589d8bf4c018d28', '', 'browser', 1, 1, '2020-07-06 13:04:47', 103, '2020-07-06 13:04:47', 0),
(390, 103, '0d80ffa06ca1a3e72589d8bf4c018d28', '', 'browser', 1, 1, '2020-07-06 13:04:47', 103, '2020-07-06 13:04:47', 0),
(391, 103, 'af73431508eba3314318aa44cef8590d', '', 'browser', 1, 1, '2020-07-06 13:16:43', 103, '2020-07-06 13:16:43', 0),
(392, 103, 'af73431508eba3314318aa44cef8590d', '', 'browser', 1, 1, '2020-07-06 13:16:43', 103, '2020-07-06 13:16:43', 0),
(393, 103, '843a9709034493d97051f5ebb67c73f0', '', 'browser', 1, 1, '2020-07-06 13:18:10', 103, '2020-07-06 13:18:10', 0),
(394, 107, '348d9e87e41a554f5c976261058be4ae', '', 'android', 1, 1, '2020-07-06 16:06:39', 107, '2020-07-06 16:06:39', 0),
(395, 1, '61050d2dd074b6106082abcb510c808f', '', 'browser', 1, 1, '2020-07-06 18:42:25', 1, '2020-07-06 18:42:25', 0),
(396, 1, '00a67c5593aca7e4f57b9c8627ac1d7d', '', 'browser', 1, 1, '2020-07-06 19:04:20', 1, '2020-07-06 19:04:20', 0),
(397, 1, '9da6fadc0053fa1d68b52081c8866e9a', '', 'browser', 1, 1, '2020-07-13 14:36:58', 1, '2020-07-13 14:36:58', 0),
(398, 1, 'a12a882ec5a8783a9ed64f7383f829e9', '', 'browser', 1, 1, '2020-07-20 14:25:13', 1, '2020-07-20 14:25:13', 0),
(399, 1, '6bb276e8c41d89234575629e1e2165ca', '', 'android', 1, 1, '2020-07-21 12:17:41', 1, '2020-07-21 12:17:41', 0),
(400, 1, 'ded02d732cfa7c0df77150614870162f', '', 'android', 1, 1, '2020-07-21 14:42:31', 1, '2020-07-21 14:42:31', 0),
(401, 1, '0b68ca31682bd24648344761ca579d4e', '', 'browser', 1, 1, '2020-07-21 14:54:34', 1, '2020-07-21 14:54:34', 0),
(402, 1, '121094a4606d3ea80d13854be2230c8c', '', 'browser', 1, 1, '2020-07-21 15:55:21', 1, '2020-07-21 15:55:21', 0),
(403, 118, '7a3eff4bb945c81d953e032a320f83ba', '', 'browser', 1, 1, '2020-07-21 15:56:24', 118, '2020-07-21 15:56:24', 0),
(404, 118, '02e16ef777774278a3f56aee991be96d', '', 'browser', 1, 1, '2020-07-22 09:32:17', 118, '2020-07-22 09:32:17', 0),
(405, 1, '2c5acc172e381b252a8ad3fb3d9f6487', '', 'android', 1, 1, '2020-07-22 16:50:19', 1, '2020-07-22 16:50:19', 0),
(406, 1, 'debb9983500d33d3470623d3c55f5124', '', 'browser', 1, 1, '2020-07-22 16:58:10', 1, '2020-07-22 16:58:10', 0),
(407, 118, '91d2754dda3ded174fd54c9685db7f17', '', 'browser', 1, 1, '2020-07-22 17:17:15', 118, '2020-07-22 17:17:15', 0),
(408, 118, 'ea4c518cf60c3a596e48347ac4943e1d', '', 'browser', 1, 1, '2020-07-22 20:55:36', 118, '2020-07-22 20:55:36', 0),
(409, 118, '4d8f1364f6d8315781fcdc7845bdced8', '', 'android', 1, 1, '2020-07-23 07:47:25', 118, '2020-07-23 07:47:25', 0),
(410, 1, 'cbba04fb36d0de51c827d698a736a55b', '', 'browser', 1, 1, '2020-08-25 15:10:43', 1, '2020-08-25 15:10:43', 0),
(411, 118, 'dcac6b45a5529420b838159f50c2a380', '', 'browser', 1, 1, '2020-08-25 15:11:16', 118, '2020-08-25 15:11:16', 0),
(412, 118, '4ff989e46a0d80111dd67ab52caef4b1', '', 'browser', 1, 1, '2020-08-26 11:29:09', 118, '2020-08-26 11:29:09', 0),
(413, 118, 'ce7e3ad5b349efef40f66b9d5a1af09c', '', 'android', 1, 1, '2020-08-26 16:25:23', 118, '2020-08-26 16:25:23', 0),
(414, 118, 'abbdb006d155ee56bbc22d8673350a25', '', 'browser', 1, 1, '2020-08-26 16:25:40', 118, '2020-08-26 16:25:40', 0),
(415, 119, '722e839a8deafa796eb460f1fa7bbacc', '', 'browser', 1, 1, '2020-08-26 16:42:23', 119, '2020-08-26 16:42:23', 0),
(416, 118, '72814df09b4a8184a0bb48419739e275', '', 'browser', 1, 1, '2020-08-27 11:45:25', 118, '2020-08-27 11:45:25', 0),
(417, 118, 'e9608c9644be3a64c97f535b8df2786b', '', 'android', 1, 1, '2020-08-27 11:46:36', 118, '2020-08-27 11:46:36', 0),
(418, 118, '67ca1792466b9d535e5e5e507b9c8ac7', '', 'browser', 1, 1, '2020-09-03 14:17:46', 118, '2020-09-03 14:17:46', 0),
(419, 1, 'fdf90b7ac11af697b3fe67463b537a16', '', 'browser', 1, 1, '2020-09-03 14:31:45', 1, '2020-09-03 14:31:45', 0),
(420, 1, 'af88d9dc00e45774226c695b9125ea4a', '', 'browser', 1, 1, '2020-09-03 14:32:31', 1, '2020-09-03 14:32:31', 0),
(421, 1, '9aa190725709542238bda747efdb797d', '', 'browser', 1, 1, '2020-09-04 17:57:09', 1, '2020-09-04 17:57:09', 0),
(422, 1, '0824e0e534b2a339335123cbb165a2ea', '', 'browser', 1, 1, '2020-09-04 17:57:54', 1, '2020-09-04 17:57:54', 0),
(423, 1, 'b0086dfa1035ed3065f42839946752f2', '', 'browser', 1, 1, '2020-09-04 17:58:49', 1, '2020-09-04 17:58:49', 0),
(424, 1, 'ce6e59b5ec3e799a6cbd90332c5b3513', '', 'android', 1, 1, '2021-03-15 10:33:48', 1, '2021-03-15 10:33:48', 0),
(425, 1, 'f40eb36a096446f1a82bb6b329e23c6c', '', 'browser', 1, 1, '2026-06-12 15:22:25', 1, '2026-06-12 15:22:25', 0);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_user_group`
--

CREATE TABLE `crm3_user_group` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '0',
  `all_access` int(1) NOT NULL DEFAULT 0,
  `sharing_team_access` int(1) NOT NULL DEFAULT 0,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `input_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2019-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_user_group`
--

INSERT INTO `crm3_user_group` (`id`, `name`, `all_access`, `sharing_team_access`, `status`, `presence`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(1, 'Sales Team 1', 0, 0, 1, 1, '2019-01-01 00:00:00', 0, '2020-03-27 14:31:24', 7),
(2, 'Sales Team 2', 0, 0, 1, 1, '2019-01-01 00:00:00', 0, '2020-03-27 14:31:26', 7),
(3, 'Sales Team 3', 0, 0, 1, 1, '2020-03-24 11:01:55', 1, '2020-03-27 14:31:25', 7),
(4, 'Administrator', 0, 1, 1, 1, '2020-03-27 10:32:53', 7, '2020-04-13 15:20:13', 7),
(5, 'Sales Team 4', 0, 0, 1, 1, '2020-04-07 15:31:43', 1, '2020-04-07 15:31:54', 1);

-- --------------------------------------------------------

--
-- Table structure for table `crm3_user_target`
--

CREATE TABLE `crm3_user_target` (
  `id` int(9) NOT NULL,
  `id_user` int(9) NOT NULL DEFAULT 0,
  `amount` float(12,0) NOT NULL DEFAULT 0,
  `leads` int(9) NOT NULL DEFAULT 0,
  `opportunities` int(9) NOT NULL DEFAULT 0,
  `quotes` int(9) NOT NULL DEFAULT 0,
  `year` int(4) NOT NULL DEFAULT 2020,
  `input_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `input_by` int(11) NOT NULL DEFAULT 0,
  `update_date` datetime NOT NULL DEFAULT '2020-01-01 00:00:00',
  `update_by` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crm3_user_target`
--

INSERT INTO `crm3_user_target` (`id`, `id_user`, `amount`, `leads`, `opportunities`, `quotes`, `year`, `input_date`, `input_by`, `update_date`, `update_by`) VALUES
(9, 105, 1100000000, 100, 50, 20, 2020, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(10, 104, 1000000000, 120, 60, 40, 2020, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(11, 103, 2000000000, 400, 240, 160, 2020, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(13, 106, 1000000000, 160, 80, 40, 2020, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(15, 103, 4000000000, 500, 300, 200, 2021, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(16, 109, 1000000000, 200, 80, 50, 2020, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(17, 110, 100000000, 10000, 2000, 200, 2020, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(18, 113, 800000000, 120, 80, 40, 2020, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(19, 114, 600000000, 100, 40, 20, 2020, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(20, 115, 1000000000, 200, 120, 80, 2020, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(21, 112, 2000000000, 200, 160, 80, 2020, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(22, 1, 1000000000, 200, 100, 60, 2020, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(23, 108, 1000000000, 240, 120, 80, 2020, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(24, 107, 1500000000, 480, 240, 160, 2020, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(25, 110, 124555552, 23345, 4345, 32, 2021, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(26, 117, 500000000, 60, 40, 40, 1, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(27, 118, 2000000000, 120, 60, 24, 2020, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0),
(29, 119, 1000000000, 60, 24, 12, 2020, '2020-01-01 00:00:00', 0, '2020-01-01 00:00:00', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_activity`
--
ALTER TABLE `crm3_activity`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_activity_comment`
--
ALTER TABLE `crm3_activity_comment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_activity_priority`
--
ALTER TABLE `crm3_activity_priority`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_activity_type`
--
ALTER TABLE `crm3_activity_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_attachment`
--
ALTER TABLE `crm3_attachment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_branch`
--
ALTER TABLE `crm3_branch`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_branch_status`
--
ALTER TABLE `crm3_branch_status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_company`
--
ALTER TABLE `crm3_company`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_company_class`
--
ALTER TABLE `crm3_company_class`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_company_class_price_list`
--
ALTER TABLE `crm3_company_class_price_list`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_contact`
--
ALTER TABLE `crm3_contact`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_currency`
--
ALTER TABLE `crm3_currency`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `crm3_global`
--
ALTER TABLE `crm3_global`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_industry`
--
ALTER TABLE `crm3_industry`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_label`
--
ALTER TABLE `crm3_label`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_lead`
--
ALTER TABLE `crm3_lead`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_lead_convert`
--
ALTER TABLE `crm3_lead_convert`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_lead_product`
--
ALTER TABLE `crm3_lead_product`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_lead_source`
--
ALTER TABLE `crm3_lead_source`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_lead_status`
--
ALTER TABLE `crm3_lead_status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_module`
--
ALTER TABLE `crm3_module`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `crm3_number`
--
ALTER TABLE `crm3_number`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `crm3_opportunity`
--
ALTER TABLE `crm3_opportunity`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_opportunity_business`
--
ALTER TABLE `crm3_opportunity_business`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_opportunity_closed_reason`
--
ALTER TABLE `crm3_opportunity_closed_reason`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_opportunity_log`
--
ALTER TABLE `crm3_opportunity_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_opportunity_product`
--
ALTER TABLE `crm3_opportunity_product`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_opportunity_quiz`
--
ALTER TABLE `crm3_opportunity_quiz`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_opportunity_stage`
--
ALTER TABLE `crm3_opportunity_stage`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_opportunity_stage_done`
--
ALTER TABLE `crm3_opportunity_stage_done`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_output`
--
ALTER TABLE `crm3_output`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_price_list`
--
ALTER TABLE `crm3_price_list`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_price_list_catalog`
--
ALTER TABLE `crm3_price_list_catalog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_price_list_class`
--
ALTER TABLE `crm3_price_list_class`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_price_list_product`
--
ALTER TABLE `crm3_price_list_product`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_product`
--
ALTER TABLE `crm3_product`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_product_location`
--
ALTER TABLE `crm3_product_location`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_product_type`
--
ALTER TABLE `crm3_product_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_quote`
--
ALTER TABLE `crm3_quote`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `quotes_number` (`quotes_number`);

--
-- Indexes for table `crm3_quote_detail`
--
ALTER TABLE `crm3_quote_detail`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_quote_status`
--
ALTER TABLE `crm3_quote_status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_sales_order`
--
ALTER TABLE `crm3_sales_order`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `quotes_number` (`so_number`);

--
-- Indexes for table `crm3_sales_order_detail`
--
ALTER TABLE `crm3_sales_order_detail`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_sales_order_log`
--
ALTER TABLE `crm3_sales_order_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_sales_order_status`
--
ALTER TABLE `crm3_sales_order_status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_title`
--
ALTER TABLE `crm3_title`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_user`
--
ALTER TABLE `crm3_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `crm3_user_access`
--
ALTER TABLE `crm3_user_access`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_user_access_rules`
--
ALTER TABLE `crm3_user_access_rules`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_user_auth`
--
ALTER TABLE `crm3_user_auth`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_user_group`
--
ALTER TABLE `crm3_user_group`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crm3_user_target`
--
ALTER TABLE `crm3_user_target`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `id` int(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `crm3_activity`
--
ALTER TABLE `crm3_activity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `crm3_activity_comment`
--
ALTER TABLE `crm3_activity_comment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `crm3_activity_priority`
--
ALTER TABLE `crm3_activity_priority`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=301;

--
-- AUTO_INCREMENT for table `crm3_activity_type`
--
ALTER TABLE `crm3_activity_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1002;

--
-- AUTO_INCREMENT for table `crm3_attachment`
--
ALTER TABLE `crm3_attachment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `crm3_branch`
--
ALTER TABLE `crm3_branch`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `crm3_branch_status`
--
ALTER TABLE `crm3_branch_status`
  MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT for table `crm3_company`
--
ALTER TABLE `crm3_company`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=197;

--
-- AUTO_INCREMENT for table `crm3_company_class`
--
ALTER TABLE `crm3_company_class`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `crm3_company_class_price_list`
--
ALTER TABLE `crm3_company_class_price_list`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `crm3_contact`
--
ALTER TABLE `crm3_contact`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=159;

--
-- AUTO_INCREMENT for table `crm3_currency`
--
ALTER TABLE `crm3_currency`
  MODIFY `id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `crm3_global`
--
ALTER TABLE `crm3_global`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `crm3_industry`
--
ALTER TABLE `crm3_industry`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `crm3_label`
--
ALTER TABLE `crm3_label`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `crm3_lead`
--
ALTER TABLE `crm3_lead`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1132;

--
-- AUTO_INCREMENT for table `crm3_lead_convert`
--
ALTER TABLE `crm3_lead_convert`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `crm3_lead_product`
--
ALTER TABLE `crm3_lead_product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `crm3_lead_source`
--
ALTER TABLE `crm3_lead_source`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `crm3_lead_status`
--
ALTER TABLE `crm3_lead_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `crm3_module`
--
ALTER TABLE `crm3_module`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2002;

--
-- AUTO_INCREMENT for table `crm3_number`
--
ALTER TABLE `crm3_number`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `crm3_opportunity`
--
ALTER TABLE `crm3_opportunity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=213;

--
-- AUTO_INCREMENT for table `crm3_opportunity_business`
--
ALTER TABLE `crm3_opportunity_business`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `crm3_opportunity_closed_reason`
--
ALTER TABLE `crm3_opportunity_closed_reason`
  MODIFY `id` int(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `crm3_opportunity_log`
--
ALTER TABLE `crm3_opportunity_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `crm3_opportunity_product`
--
ALTER TABLE `crm3_opportunity_product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `crm3_opportunity_quiz`
--
ALTER TABLE `crm3_opportunity_quiz`
  MODIFY `id` int(9) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `crm3_opportunity_stage`
--
ALTER TABLE `crm3_opportunity_stage`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3001;

--
-- AUTO_INCREMENT for table `crm3_opportunity_stage_done`
--
ALTER TABLE `crm3_opportunity_stage_done`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=122;

--
-- AUTO_INCREMENT for table `crm3_output`
--
ALTER TABLE `crm3_output`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `crm3_price_list`
--
ALTER TABLE `crm3_price_list`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `crm3_price_list_catalog`
--
ALTER TABLE `crm3_price_list_catalog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `crm3_price_list_class`
--
ALTER TABLE `crm3_price_list_class`
  MODIFY `id` int(9) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `crm3_price_list_product`
--
ALTER TABLE `crm3_price_list_product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `crm3_product`
--
ALTER TABLE `crm3_product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `crm3_product_location`
--
ALTER TABLE `crm3_product_location`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `crm3_product_type`
--
ALTER TABLE `crm3_product_type`
  MODIFY `id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `crm3_quote`
--
ALTER TABLE `crm3_quote`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `crm3_quote_detail`
--
ALTER TABLE `crm3_quote_detail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `crm3_quote_status`
--
ALTER TABLE `crm3_quote_status`
  MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=501;

--
-- AUTO_INCREMENT for table `crm3_sales_order`
--
ALTER TABLE `crm3_sales_order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `crm3_sales_order_detail`
--
ALTER TABLE `crm3_sales_order_detail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `crm3_sales_order_log`
--
ALTER TABLE `crm3_sales_order_log`
  MODIFY `id` int(6) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `crm3_sales_order_status`
--
ALTER TABLE `crm3_sales_order_status`
  MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=901;

--
-- AUTO_INCREMENT for table `crm3_title`
--
ALTER TABLE `crm3_title`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `crm3_user`
--
ALTER TABLE `crm3_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=120;

--
-- AUTO_INCREMENT for table `crm3_user_access`
--
ALTER TABLE `crm3_user_access`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `crm3_user_access_rules`
--
ALTER TABLE `crm3_user_access_rules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `crm3_user_auth`
--
ALTER TABLE `crm3_user_auth`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=426;

--
-- AUTO_INCREMENT for table `crm3_user_group`
--
ALTER TABLE `crm3_user_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `crm3_user_target`
--
ALTER TABLE `crm3_user_target`
  MODIFY `id` int(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
