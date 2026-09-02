-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               10.4.28-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.21.0.7344
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for table thinktank-ticket.auto_number
CREATE TABLE IF NOT EXISTS `auto_number` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `prefix` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `digit` int(11) NOT NULL DEFAULT 6,
  `runningNumber` int(11) NOT NULL DEFAULT 0,
  `lastRecord` varchar(50) DEFAULT NULL,
  `updateDate` datetime DEFAULT '2024-01-01 00:00:00',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=329 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table thinktank-ticket.auto_number: ~4 rows (approximately)
INSERT INTO `auto_number` (`id`, `name`, `prefix`, `digit`, `runningNumber`, `lastRecord`, `updateDate`) VALUES
	(324, 'project', 'P', 6, 0, NULL, '2024-01-01 00:00:00'),
	(325, 'client', 'C', 6, 0, NULL, '2024-01-01 00:00:00'),
	(326, 'task', 'TA', 6, 60, 'TA000060', '2026-09-01 14:12:26'),
	(327, 'issue', 'IS', 6, 67, 'IS000067', '2026-09-01 16:51:51'),
	(328, 'changeRequest', 'CR', 6, 0, NULL, '2024-01-01 00:00:00');

-- Dumping structure for table thinktank-ticket.client
CREATE TABLE IF NOT EXISTS `client` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(250) NOT NULL DEFAULT '',
  `address` varchar(250) NOT NULL DEFAULT '',
  `IndustryId` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=358 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.client: ~6 rows (approximately)
INSERT INTO `client` (`id`, `code`, `name`, `address`, `IndustryId`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(351, 'CLI-DEMO', 'PT XYZ Jp.co', 'Jakarta', 352, 1, 1, '2026-06-10 15:53:03', 1, '2026-08-19 13:20:17', 0),
	(352, 'CLI-TEMP-CRUD', 'Client Temp CRUD Updated', 'Bandung', 127, 0, 0, '2026-06-10 16:48:55', 1, '2026-06-10 16:48:55', 1),
	(353, 'CLI-AUTO-1781164821', 'Client Auto Updated 1781164821', 'Jakarta', 127, 0, 0, '2026-06-11 15:00:21', 1, '2026-06-11 15:00:21', 1),
	(354, 'CLI-VAL-1781164843', 'Client Val 1781164843', 'Bandung', 127, 0, 0, '2026-06-11 15:00:43', 1, '2026-06-11 15:00:44', 1),
	(355, 'CLI-VAL-1781164861', 'Client Val 1781164861', 'Bandung', 127, 0, 0, '2026-06-11 15:01:01', 1, '2026-06-11 15:01:01', 1),
	(356, 'test 123', 'Tentang Belfoods', '123tt ter', 351, 0, 0, '2026-06-11 15:36:48', 1, '2026-06-11 15:37:00', 1),
	(357, 'CD2', 'Astra Otto', 'Address', 351, 1, 1, '2026-07-30 12:59:40', 1, '2026-07-30 12:59:40', 1);

-- Dumping structure for table thinktank-ticket.global_setting
CREATE TABLE IF NOT EXISTS `global_setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  `value` varchar(50) NOT NULL DEFAULT '0',
  `note` text NOT NULL DEFAULT '',
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1002 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.global_setting: ~2 rows (approximately)
INSERT INTO `global_setting` (`id`, `name`, `value`, `note`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1000, 'ticket', '3', 'hours', '2025-01-01 00:00:00', 1, '2026-06-11 13:47:51', 1),
	(1001, 'Man Day', '8', 'hours', '2025-01-01 00:00:00', 1, '2026-06-15 15:00:43', 1);

-- Dumping structure for table thinktank-ticket.industry
CREATE TABLE IF NOT EXISTS `industry` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=355 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.industry: ~4 rows (approximately)
INSERT INTO `industry` (`id`, `name`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(351, 'Automative', 1, 1, '2025-01-01 00:00:00', 1, '2026-08-04 15:09:16', 1),
	(352, 'FMCG', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(353, 'Dummy Industry CRUD Updated', 1, 0, '2026-06-10 16:43:35', 1, '2026-06-10 16:43:35', 1),
	(354, 'Temp Industry UI Test Updated', 1, 0, '2026-06-11 13:35:24', 1, '2026-06-11 13:35:24', 1);

-- Dumping structure for table thinktank-ticket.module
CREATE TABLE IF NOT EXISTS `module` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6003 DEFAULT CHARSET=utf16 COLLATE=utf16_bin;

-- Dumping data for table thinktank-ticket.module: ~19 rows (approximately)
INSERT INTO `module` (`id`, `name`) VALUES
	(1000, 'Home'),
	(1001, 'Industri'),
	(1002, 'Product'),
	(1003, 'Project Type'),
	(1004, 'Project Bileable'),
	(1005, 'Ticket Categories'),
	(1006, 'User Auth Level'),
	(1007, 'Global Setting'),
	(1010, 'template'),
	(2001, 'Project'),
	(2002, 'Clients'),
	(2003, 'Contacts'),
	(2004, 'Users'),
	(2005, 'Rating'),
	(5005, 'Task'),
	(5006, 'Case'),
	(5007, 'Change Request'),
	(6000, 'Login'),
	(6001, 'Ticket Balance'),
	(6002, 'log activities');

-- Dumping structure for table thinktank-ticket.product
CREATE TABLE IF NOT EXISTS `product` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `parentId` smallint(6) NOT NULL DEFAULT 0,
  `name` varchar(200) NOT NULL DEFAULT '',
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.product: ~8 rows (approximately)
INSERT INTO `product` (`id`, `parentId`, `name`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1, 0, 'Acumatica ERP', 1, 1, '2025-01-01 00:00:00', 1, '2026-08-04 15:09:53', 1),
	(2, 0, 'SAP B1', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(3, 0, 'odoo', 1, 1, '2026-06-11 13:39:06', 1, '2026-06-11 13:39:06', 1),
	(4, 1, 'Module AR', 1, 1, '2026-07-22 14:41:10', 1, '2026-07-22 18:42:16', 1),
	(5, 1, 'Module Fix Asset', 1, 1, '2026-07-22 14:41:17', 1, '2026-07-22 18:42:27', 1),
	(6, 3, 'odoo sub 1', 1, 1, '2026-07-22 18:41:52', 1, '2026-07-22 18:41:52', 1),
	(7, 3, 'odoo sub 1', 1, 1, '2026-07-22 18:42:00', 1, '2026-07-22 18:42:00', 1),
	(8, 3, 'odoo sub 4', 1, 1, '2026-07-22 18:42:04', 1, '2026-07-22 18:42:04', 1),
	(9, 3, 'odoo sub 5', 1, 1, '2026-07-22 18:42:09', 1, '2026-07-22 18:42:09', 1);

-- Dumping structure for table thinktank-ticket.project
CREATE TABLE IF NOT EXISTS `project` (
  `id` varchar(100) NOT NULL DEFAULT '',
  `name` varchar(250) NOT NULL,
  `projectTypeId` smallint(6) NOT NULL DEFAULT 0,
  `projectBilleableId` smallint(6) NOT NULL DEFAULT 0,
  `productId` int(11) NOT NULL DEFAULT 0,
  `ticketCategoriesParentId` int(11) NOT NULL,
  `ticketBaseHours` float NOT NULL DEFAULT 0,
  `clientId` varchar(50) NOT NULL DEFAULT '0',
  `startDate` date NOT NULL DEFAULT '2025-01-01',
  `endDate` date NOT NULL DEFAULT '2025-01-01',
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `templateMaster` varchar(50) NOT NULL DEFAULT '0',
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` varchar(50) NOT NULL DEFAULT '',
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.project: ~1 rows (approximately)
INSERT INTO `project` (`id`, `name`, `projectTypeId`, `projectBilleableId`, `productId`, `ticketCategoriesParentId`, `ticketBaseHours`, `clientId`, `startDate`, `endDate`, `status`, `templateMaster`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	('PRJ-1CF03AF3', 'Wind Toys 1/12 Super Movable — The ultimate body for customizing figures', 3, 1, 1, 10, 3, '351', '2026-07-13', '2026-10-30', 1, '7', 1, '2026-09-01 14:12:26', 'USR-ADMIN', '2026-09-01 14:12:26', 'USR-ADMIN');

-- Dumping structure for table thinktank-ticket.project_billeable
CREATE TABLE IF NOT EXISTS `project_billeable` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.project_billeable: ~4 rows (approximately)
INSERT INTO `project_billeable` (`id`, `name`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1, 'Chrageable', 1, 1, '2025-01-01 00:00:00', 1, '2026-08-04 15:10:07', 1),
	(2, 'Internal', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(3, 'NBD', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(4, 'Non Chargeable', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1);

-- Dumping structure for table thinktank-ticket.project_contact
CREATE TABLE IF NOT EXISTS `project_contact` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `clientId` varchar(50) NOT NULL DEFAULT '',
  `projectId` varchar(50) NOT NULL DEFAULT '',
  `userId` varchar(100) NOT NULL,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` varchar(50) NOT NULL DEFAULT '',
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.project_contact: ~61 rows (approximately)
INSERT INTO `project_contact` (`id`, `clientId`, `projectId`, `userId`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(43, '351', 'PRJ-FA50EC5D', 'USR-39C10981', 0, '2026-07-23 16:45:45', 'USR-ADMIN', '2026-07-23 17:10:39', 'USR-ADMIN'),
	(44, '351', 'PRJ-FA50EC5D', 'DEMO1', 0, '2026-07-23 16:45:45', 'USR-ADMIN', '2026-07-23 17:10:39', 'USR-ADMIN'),
	(45, '351', 'PRJ-FA50EC5D', 'USR-39C10981', 0, '2026-07-23 16:47:34', 'USR-ADMIN', '2026-07-23 17:51:21', 'USR-ADMIN'),
	(46, '351', 'PRJ-FA50EC5D', 'DEMO1', 1, '2026-07-23 16:47:34', 'USR-ADMIN', '2026-07-23 16:47:34', 'USR-ADMIN'),
	(47, '351', 'PRJ-FA50EC5D', 'DEMO2', 1, '2026-07-23 17:51:26', 'USR-ADMIN', '2026-07-23 17:51:26', 'USR-ADMIN'),
	(48, '351', 'PRJ-FA50EC5D', 'USR-39C10981', 0, '2026-07-23 17:51:26', 'USR-ADMIN', '2026-07-23 17:51:37', 'USR-ADMIN'),
	(49, '351', 'PRJ-B8887D5E', 'DEMO1', 0, '2026-07-23 17:53:26', 'USR-ADMIN', '2026-07-23 17:53:36', 'USR-ADMIN'),
	(50, '351', 'PRJ-B8887D5E', 'DEMO1', 1, '2026-07-23 17:53:39', 'USR-ADMIN', '2026-07-23 17:53:39', 'USR-ADMIN'),
	(51, '351', 'PRJ-B8887D5E', 'DEMO2', 1, '2026-07-23 17:53:39', 'USR-ADMIN', '2026-07-23 17:53:39', 'USR-ADMIN'),
	(52, '351', 'PRJ-FA50EC5D', 'USR-9A0C9A66', 1, '2026-08-04 17:37:02', 'USR-ADMIN', '2026-08-04 17:37:02', 'USR-ADMIN'),
	(53, '351', 'PRJ-82EA624A', 'DEMO1', 1, '2026-08-10 16:51:01', 'USR-ADMIN', '2026-08-10 16:51:01', 'USR-ADMIN'),
	(54, '351', 'PRJ-82EA624A', 'DEMO2', 1, '2026-08-10 16:51:01', 'USR-ADMIN', '2026-08-10 16:51:01', 'USR-ADMIN'),
	(55, '351', 'PRJ-82EA624A', 'USR-39C10981', 1, '2026-08-10 16:51:01', 'USR-ADMIN', '2026-08-10 16:51:01', 'USR-ADMIN'),
	(56, '351', 'PRJ-F6FF1FCF', 'DEMO1', 0, '2026-08-11 13:58:10', 'USR-ADMIN', '2026-08-13 16:06:01', 'USR-ADMIN'),
	(57, '351', 'PRJ-F6FF1FCF', 'DEMO2', 0, '2026-08-11 13:58:10', 'USR-ADMIN', '2026-08-13 16:06:01', 'USR-ADMIN'),
	(58, '351', 'PRJ-F6FF1FCF', 'USR-39C10981', 1, '2026-08-11 13:58:10', 'USR-ADMIN', '2026-08-11 13:58:10', 'USR-ADMIN'),
	(59, '351', 'PRJ-8BDEF1BE', 'DEMO1', 1, '2026-08-11 13:58:16', 'USR-ADMIN', '2026-08-11 13:58:16', 'USR-ADMIN'),
	(60, '351', 'PRJ-8BDEF1BE', 'DEMO2', 1, '2026-08-11 13:58:16', 'USR-ADMIN', '2026-08-11 13:58:16', 'USR-ADMIN'),
	(61, '351', 'PRJ-8BDEF1BE', 'USR-39C10981', 1, '2026-08-11 13:58:16', 'USR-ADMIN', '2026-08-11 13:58:16', 'USR-ADMIN'),
	(62, '351', 'PRJ-CBFF4504', 'DEMO1', 1, '2026-08-11 13:58:57', 'USR-ADMIN', '2026-08-11 13:58:57', 'USR-ADMIN'),
	(63, '351', 'PRJ-CBFF4504', 'DEMO2', 1, '2026-08-11 13:58:57', 'USR-ADMIN', '2026-08-11 13:58:57', 'USR-ADMIN'),
	(64, '351', 'PRJ-CBFF4504', 'USR-39C10981', 1, '2026-08-11 13:58:57', 'USR-ADMIN', '2026-08-11 13:58:57', 'USR-ADMIN'),
	(65, '351', 'PRJ-774F9C2F', 'DEMO1', 1, '2026-08-11 14:00:32', 'USR-ADMIN', '2026-08-11 14:00:32', 'USR-ADMIN'),
	(66, '351', 'PRJ-774F9C2F', 'DEMO2', 1, '2026-08-11 14:00:32', 'USR-ADMIN', '2026-08-11 14:00:32', 'USR-ADMIN'),
	(67, '351', 'PRJ-774F9C2F', 'USR-39C10981', 1, '2026-08-11 14:00:32', 'USR-ADMIN', '2026-08-11 14:00:32', 'USR-ADMIN'),
	(68, '351', 'PRJ-9D2E7985', 'DEMO1', 1, '2026-08-11 14:01:28', 'USR-ADMIN', '2026-08-11 14:01:28', 'USR-ADMIN'),
	(69, '351', 'PRJ-9D2E7985', 'DEMO2', 1, '2026-08-11 14:01:28', 'USR-ADMIN', '2026-08-11 14:01:28', 'USR-ADMIN'),
	(70, '351', 'PRJ-9D2E7985', 'USR-39C10981', 1, '2026-08-11 14:01:28', 'USR-ADMIN', '2026-08-11 14:01:28', 'USR-ADMIN'),
	(71, '351', 'PRJ-8DB73818', 'DEMO1', 0, '2026-08-11 14:02:40', 'USR-ADMIN', '2026-08-13 13:26:40', 'USR-ADMIN'),
	(72, '351', 'PRJ-8DB73818', 'DEMO2', 0, '2026-08-11 14:02:40', 'USR-ADMIN', '2026-08-13 13:26:40', 'USR-ADMIN'),
	(73, '351', 'PRJ-8DB73818', 'USR-39C10981', 1, '2026-08-11 14:02:40', 'USR-ADMIN', '2026-08-11 14:02:40', 'USR-ADMIN'),
	(74, '357', 'PRJ-0FFA563B', 'DEMO1', 1, '2026-08-18 15:20:24', 'USR-ADMIN', '2026-08-18 15:20:24', 'USR-ADMIN'),
	(75, '357', 'PRJ-0FFA563B', 'DEMO2', 1, '2026-08-18 15:20:24', 'USR-ADMIN', '2026-08-18 15:20:24', 'USR-ADMIN'),
	(76, '357', 'PRJ-0FFA563B', 'USR-39C10981', 1, '2026-08-18 15:20:24', 'USR-ADMIN', '2026-08-18 15:20:24', 'USR-ADMIN'),
	(77, '351', 'PRJ-C4868765', 'DEMO1', 1, '2026-09-01 14:03:52', 'USR-ADMIN', '2026-09-01 14:03:52', 'USR-ADMIN'),
	(78, '351', 'PRJ-C4868765', 'DEMO2', 1, '2026-09-01 14:03:52', 'USR-ADMIN', '2026-09-01 14:03:52', 'USR-ADMIN'),
	(79, '351', 'PRJ-C4868765', 'USR-39C10981', 1, '2026-09-01 14:03:52', 'USR-ADMIN', '2026-09-01 14:03:52', 'USR-ADMIN'),
	(80, '351', 'PRJ-A3E51F28', 'DEMO1', 1, '2026-09-01 14:05:31', 'USR-ADMIN', '2026-09-01 14:05:31', 'USR-ADMIN'),
	(81, '351', 'PRJ-A3E51F28', 'DEMO2', 1, '2026-09-01 14:05:31', 'USR-ADMIN', '2026-09-01 14:05:31', 'USR-ADMIN'),
	(82, '351', 'PRJ-A3E51F28', 'USR-39C10981', 1, '2026-09-01 14:05:31', 'USR-ADMIN', '2026-09-01 14:05:31', 'USR-ADMIN'),
	(83, '351', 'PRJ-B1A40467', 'DEMO1', 1, '2026-09-01 14:05:55', 'USR-ADMIN', '2026-09-01 14:05:55', 'USR-ADMIN'),
	(84, '351', 'PRJ-B1A40467', 'DEMO2', 1, '2026-09-01 14:05:55', 'USR-ADMIN', '2026-09-01 14:05:55', 'USR-ADMIN'),
	(85, '351', 'PRJ-B1A40467', 'USR-39C10981', 1, '2026-09-01 14:05:55', 'USR-ADMIN', '2026-09-01 14:05:55', 'USR-ADMIN'),
	(86, '351', 'PRJ-7D9A6517', 'DEMO1', 1, '2026-09-01 14:07:53', 'USR-ADMIN', '2026-09-01 14:07:53', 'USR-ADMIN'),
	(87, '351', 'PRJ-7D9A6517', 'DEMO2', 1, '2026-09-01 14:07:53', 'USR-ADMIN', '2026-09-01 14:07:53', 'USR-ADMIN'),
	(88, '351', 'PRJ-7D9A6517', 'USR-39C10981', 1, '2026-09-01 14:07:53', 'USR-ADMIN', '2026-09-01 14:07:53', 'USR-ADMIN'),
	(89, '351', 'PRJ-3AE6103B', 'DEMO1', 1, '2026-09-01 14:11:01', 'USR-ADMIN', '2026-09-01 14:11:01', 'USR-ADMIN'),
	(90, '351', 'PRJ-3AE6103B', 'DEMO2', 1, '2026-09-01 14:11:01', 'USR-ADMIN', '2026-09-01 14:11:01', 'USR-ADMIN'),
	(91, '351', 'PRJ-3AE6103B', 'USR-39C10981', 1, '2026-09-01 14:11:01', 'USR-ADMIN', '2026-09-01 14:11:01', 'USR-ADMIN'),
	(92, '351', 'PRJ-37203496', 'DEMO1', 1, '2026-09-01 14:11:39', 'USR-ADMIN', '2026-09-01 14:11:39', 'USR-ADMIN'),
	(93, '351', 'PRJ-37203496', 'DEMO2', 1, '2026-09-01 14:11:39', 'USR-ADMIN', '2026-09-01 14:11:39', 'USR-ADMIN'),
	(94, '351', 'PRJ-37203496', 'USR-39C10981', 1, '2026-09-01 14:11:39', 'USR-ADMIN', '2026-09-01 14:11:39', 'USR-ADMIN'),
	(95, '351', 'PRJ-B9EBCB6C', 'DEMO1', 1, '2026-09-01 14:11:47', 'USR-ADMIN', '2026-09-01 14:11:47', 'USR-ADMIN'),
	(96, '351', 'PRJ-B9EBCB6C', 'DEMO2', 1, '2026-09-01 14:11:47', 'USR-ADMIN', '2026-09-01 14:11:47', 'USR-ADMIN'),
	(97, '351', 'PRJ-B9EBCB6C', 'USR-39C10981', 1, '2026-09-01 14:11:47', 'USR-ADMIN', '2026-09-01 14:11:47', 'USR-ADMIN'),
	(98, '351', 'PRJ-E4DF3F39', 'DEMO1', 1, '2026-09-01 14:12:18', 'USR-ADMIN', '2026-09-01 14:12:18', 'USR-ADMIN'),
	(99, '351', 'PRJ-E4DF3F39', 'DEMO2', 1, '2026-09-01 14:12:18', 'USR-ADMIN', '2026-09-01 14:12:18', 'USR-ADMIN'),
	(100, '351', 'PRJ-E4DF3F39', 'USR-39C10981', 1, '2026-09-01 14:12:18', 'USR-ADMIN', '2026-09-01 14:12:18', 'USR-ADMIN'),
	(101, '351', 'PRJ-1CF03AF3', 'DEMO1', 1, '2026-09-01 14:12:26', 'USR-ADMIN', '2026-09-01 14:12:26', 'USR-ADMIN'),
	(102, '351', 'PRJ-1CF03AF3', 'DEMO2', 1, '2026-09-01 14:12:26', 'USR-ADMIN', '2026-09-01 14:12:26', 'USR-ADMIN'),
	(103, '351', 'PRJ-1CF03AF3', 'USR-39C10981', 1, '2026-09-01 14:12:26', 'USR-ADMIN', '2026-09-01 14:12:26', 'USR-ADMIN');

-- Dumping structure for table thinktank-ticket.project_type
CREATE TABLE IF NOT EXISTS `project_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `ticketBased` tinyint(4) NOT NULL DEFAULT 0,
  `categoryBased` tinyint(4) NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=358 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.project_type: ~5 rows (approximately)
INSERT INTO `project_type` (`id`, `name`, `ticketBased`, `categoryBased`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1, 'Software Implementation', 0, 1, 1, 1, '2025-01-01 00:00:00', 1, '2026-08-04 15:55:46', 1),
	(2, 'Software Support Ticket Based', 1, 0, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(3, 'Software Support Fixed Cost', 0, 0, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(4, 'Change Request', 0, 1, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1);

-- Dumping structure for table thinktank-ticket.project_users
CREATE TABLE IF NOT EXISTS `project_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectId` varchar(50) NOT NULL DEFAULT '',
  `userId` varchar(100) NOT NULL,
  `asManager` tinyint(4) NOT NULL DEFAULT 0,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` varchar(50) NOT NULL DEFAULT '',
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.project_users: ~53 rows (approximately)
INSERT INTO `project_users` (`id`, `projectId`, `userId`, `asManager`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(94, 'PRJ-8BDEF1BE', 'USR-12788040', 0, 1, '2026-08-11 13:58:16', 'USR-ADMIN', '2026-08-11 13:58:16', 'USR-ADMIN'),
	(95, 'PRJ-8BDEF1BE', 'USR-405F00F4', 0, 1, '2026-08-11 13:58:16', 'USR-ADMIN', '2026-08-11 13:58:16', 'USR-ADMIN'),
	(96, 'PRJ-8BDEF1BE', 'USR-ADMIN', 1, 1, '2026-08-11 13:58:16', 'USR-ADMIN', '2026-08-11 13:58:16', 'USR-ADMIN'),
	(97, 'PRJ-CBFF4504', 'USR-12788040', 0, 1, '2026-08-11 13:58:57', 'USR-ADMIN', '2026-08-11 13:58:57', 'USR-ADMIN'),
	(98, 'PRJ-CBFF4504', 'USR-405F00F4', 0, 1, '2026-08-11 13:58:57', 'USR-ADMIN', '2026-08-11 13:58:57', 'USR-ADMIN'),
	(99, 'PRJ-CBFF4504', 'USR-ADMIN', 1, 1, '2026-08-11 13:58:57', 'USR-ADMIN', '2026-08-11 13:58:57', 'USR-ADMIN'),
	(112, 'PRJ-9D2E7985', 'USR-12788040', 0, 1, '2026-08-13 13:42:37', 'USR-ADMIN', '2026-08-13 13:42:37', 'USR-ADMIN'),
	(113, 'PRJ-9D2E7985', 'USR-405F00F4', 0, 1, '2026-08-13 13:42:37', 'USR-ADMIN', '2026-08-13 13:42:37', 'USR-ADMIN'),
	(114, 'PRJ-9D2E7985', 'USR-ADMIN', 0, 1, '2026-08-13 13:42:37', 'USR-ADMIN', '2026-08-13 13:42:37', 'USR-ADMIN'),
	(118, 'PRJ-F6FF1FCF', 'USR-12788040', 0, 1, '2026-08-13 16:05:09', 'USR-ADMIN', '2026-08-13 16:05:09', 'USR-ADMIN'),
	(119, 'PRJ-F6FF1FCF', 'USR-405F00F4', 0, 1, '2026-08-13 16:05:09', 'USR-ADMIN', '2026-08-13 16:05:09', 'USR-ADMIN'),
	(120, 'PRJ-F6FF1FCF', 'USR-ADMIN', 0, 1, '2026-08-13 16:05:09', 'USR-ADMIN', '2026-08-13 16:05:09', 'USR-ADMIN'),
	(121, 'PRJ-82EA624A', 'USR-12788040', 0, 1, '2026-08-13 16:05:28', 'USR-ADMIN', '2026-08-13 16:05:28', 'USR-ADMIN'),
	(122, 'PRJ-82EA624A', 'USR-405F00F4', 0, 1, '2026-08-13 16:05:28', 'USR-ADMIN', '2026-08-13 16:05:28', 'USR-ADMIN'),
	(123, 'PRJ-82EA624A', 'USR-ADMIN', 0, 1, '2026-08-13 16:05:28', 'USR-ADMIN', '2026-08-13 16:05:28', 'USR-ADMIN'),
	(124, 'PRJ-8DB73818', 'USR-12788040', 0, 1, '2026-08-13 16:51:08', 'USR-ADMIN', '2026-08-13 16:51:08', 'USR-ADMIN'),
	(125, 'PRJ-8DB73818', 'USR-405F00F4', 0, 1, '2026-08-13 16:51:08', 'USR-ADMIN', '2026-08-13 16:51:08', 'USR-ADMIN'),
	(126, 'PRJ-8DB73818', 'USR-ADMIN', 1, 1, '2026-08-13 16:51:08', 'USR-ADMIN', '2026-08-13 16:51:08', 'USR-ADMIN'),
	(127, 'PRJ-774F9C2F', 'USR-12788040', 0, 1, '2026-08-18 15:15:13', 'USR-ADMIN', '2026-08-18 15:15:13', 'USR-ADMIN'),
	(128, 'PRJ-774F9C2F', 'USR-405F00F4', 0, 1, '2026-08-18 15:15:13', 'USR-ADMIN', '2026-08-18 15:15:13', 'USR-ADMIN'),
	(129, 'PRJ-774F9C2F', 'USR-ADMIN', 1, 1, '2026-08-18 15:15:13', 'USR-ADMIN', '2026-08-18 15:15:13', 'USR-ADMIN'),
	(130, 'PRJ-0FFA563B', 'USR-12788040', 0, 1, '2026-08-18 15:20:24', 'USR-ADMIN', '2026-08-18 15:20:24', 'USR-ADMIN'),
	(131, 'PRJ-0FFA563B', 'USR-405F00F4', 0, 1, '2026-08-18 15:20:24', 'USR-ADMIN', '2026-08-18 15:20:24', 'USR-ADMIN'),
	(132, 'PRJ-0FFA563B', 'USR-ADMIN', 1, 1, '2026-08-18 15:20:24', 'USR-ADMIN', '2026-08-18 15:20:24', 'USR-ADMIN'),
	(135, 'PRJ-50B75546', 'USR-ADMIN', 0, 1, '2026-08-18 15:55:30', 'USR-ADMIN', '2026-08-18 15:55:30', 'USR-ADMIN'),
	(136, 'PRJ-50B75546', 'USR-8C76A791', 0, 1, '2026-08-18 15:55:30', 'USR-ADMIN', '2026-08-18 15:55:30', 'USR-ADMIN'),
	(137, 'PRJ-50B75546', 'USR-E5A4B811', 1, 1, '2026-08-18 15:55:30', 'USR-ADMIN', '2026-08-18 15:55:30', 'USR-ADMIN'),
	(138, 'PRJ-F6FB8C2D', 'USR-62199DD8', 1, 1, '2026-08-20 12:48:34', 'USR-ADMIN', '2026-08-20 12:48:34', 'USR-ADMIN'),
	(139, 'PRJ-F6FB8C2D', 'USR-ADMIN', 0, 1, '2026-08-20 12:48:34', 'USR-ADMIN', '2026-08-20 12:48:34', 'USR-ADMIN'),
	(140, 'PRJ-C4868765', 'USR-12788040', 0, 1, '2026-09-01 14:03:52', 'USR-ADMIN', '2026-09-01 14:03:52', 'USR-ADMIN'),
	(141, 'PRJ-C4868765', 'USR-405F00F4', 0, 1, '2026-09-01 14:03:52', 'USR-ADMIN', '2026-09-01 14:03:52', 'USR-ADMIN'),
	(142, 'PRJ-C4868765', 'USR-ADMIN', 1, 1, '2026-09-01 14:03:52', 'USR-ADMIN', '2026-09-01 14:03:52', 'USR-ADMIN'),
	(143, 'PRJ-A3E51F28', 'USR-12788040', 0, 1, '2026-09-01 14:05:31', 'USR-ADMIN', '2026-09-01 14:05:31', 'USR-ADMIN'),
	(144, 'PRJ-A3E51F28', 'USR-405F00F4', 0, 1, '2026-09-01 14:05:31', 'USR-ADMIN', '2026-09-01 14:05:31', 'USR-ADMIN'),
	(145, 'PRJ-A3E51F28', 'USR-ADMIN', 1, 1, '2026-09-01 14:05:31', 'USR-ADMIN', '2026-09-01 14:05:31', 'USR-ADMIN'),
	(146, 'PRJ-B1A40467', 'USR-12788040', 0, 1, '2026-09-01 14:05:55', 'USR-ADMIN', '2026-09-01 14:05:55', 'USR-ADMIN'),
	(147, 'PRJ-B1A40467', 'USR-405F00F4', 0, 1, '2026-09-01 14:05:55', 'USR-ADMIN', '2026-09-01 14:05:55', 'USR-ADMIN'),
	(148, 'PRJ-B1A40467', 'USR-ADMIN', 1, 1, '2026-09-01 14:05:55', 'USR-ADMIN', '2026-09-01 14:05:55', 'USR-ADMIN'),
	(149, 'PRJ-7D9A6517', 'USR-12788040', 0, 1, '2026-09-01 14:07:53', 'USR-ADMIN', '2026-09-01 14:07:53', 'USR-ADMIN'),
	(150, 'PRJ-7D9A6517', 'USR-405F00F4', 0, 1, '2026-09-01 14:07:53', 'USR-ADMIN', '2026-09-01 14:07:53', 'USR-ADMIN'),
	(151, 'PRJ-7D9A6517', 'USR-ADMIN', 1, 1, '2026-09-01 14:07:53', 'USR-ADMIN', '2026-09-01 14:07:53', 'USR-ADMIN'),
	(152, 'PRJ-3AE6103B', 'USR-12788040', 0, 1, '2026-09-01 14:11:01', 'USR-ADMIN', '2026-09-01 14:11:01', 'USR-ADMIN'),
	(153, 'PRJ-3AE6103B', 'USR-405F00F4', 0, 1, '2026-09-01 14:11:01', 'USR-ADMIN', '2026-09-01 14:11:01', 'USR-ADMIN'),
	(154, 'PRJ-3AE6103B', 'USR-ADMIN', 1, 1, '2026-09-01 14:11:01', 'USR-ADMIN', '2026-09-01 14:11:01', 'USR-ADMIN'),
	(155, 'PRJ-37203496', 'USR-12788040', 0, 1, '2026-09-01 14:11:39', 'USR-ADMIN', '2026-09-01 14:11:39', 'USR-ADMIN'),
	(156, 'PRJ-37203496', 'USR-405F00F4', 0, 1, '2026-09-01 14:11:39', 'USR-ADMIN', '2026-09-01 14:11:39', 'USR-ADMIN'),
	(157, 'PRJ-37203496', 'USR-ADMIN', 1, 1, '2026-09-01 14:11:39', 'USR-ADMIN', '2026-09-01 14:11:39', 'USR-ADMIN'),
	(158, 'PRJ-B9EBCB6C', 'USR-12788040', 0, 1, '2026-09-01 14:11:47', 'USR-ADMIN', '2026-09-01 14:11:47', 'USR-ADMIN'),
	(159, 'PRJ-B9EBCB6C', 'USR-405F00F4', 0, 1, '2026-09-01 14:11:47', 'USR-ADMIN', '2026-09-01 14:11:47', 'USR-ADMIN'),
	(160, 'PRJ-B9EBCB6C', 'USR-ADMIN', 1, 1, '2026-09-01 14:11:47', 'USR-ADMIN', '2026-09-01 14:11:47', 'USR-ADMIN'),
	(161, 'PRJ-E4DF3F39', 'USR-12788040', 0, 1, '2026-09-01 14:12:18', 'USR-ADMIN', '2026-09-01 14:12:18', 'USR-ADMIN'),
	(162, 'PRJ-E4DF3F39', 'USR-405F00F4', 0, 1, '2026-09-01 14:12:18', 'USR-ADMIN', '2026-09-01 14:12:18', 'USR-ADMIN'),
	(163, 'PRJ-E4DF3F39', 'USR-ADMIN', 1, 1, '2026-09-01 14:12:18', 'USR-ADMIN', '2026-09-01 14:12:18', 'USR-ADMIN'),
	(164, 'PRJ-1CF03AF3', 'USR-12788040', 0, 1, '2026-09-01 14:12:26', 'USR-ADMIN', '2026-09-01 14:12:26', 'USR-ADMIN'),
	(165, 'PRJ-1CF03AF3', 'USR-405F00F4', 0, 1, '2026-09-01 14:12:26', 'USR-ADMIN', '2026-09-01 14:12:26', 'USR-ADMIN'),
	(166, 'PRJ-1CF03AF3', 'USR-ADMIN', 1, 1, '2026-09-01 14:12:26', 'USR-ADMIN', '2026-09-01 14:12:26', 'USR-ADMIN');

-- Dumping structure for table thinktank-ticket.rating
CREATE TABLE IF NOT EXISTS `rating` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.rating: ~5 rows (approximately)
INSERT INTO `rating` (`id`, `name`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(10, 'Secara keseluruhan, seberapa puas Anda dengan produk/layanan kami hari ini?', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(11, 'Bagaimana Anda menilai kualitas dari produk/layanan yang Anda terima?', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(12, 'Seberapa mudah bagi Anda untuk menyelesaikan transaksi/menemukan apa yang Anda butuhkan?', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(13, 'Bagaimana penilaian Anda terhadap keramahan dan kecepatan tim kami dalam membantu Anda?', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(14, 'Seberapa besar kemungkinan Anda merekomendasikan [Nama Bisnis/Produk] kepada teman atau kolega Anda?', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1);

-- Dumping structure for table thinktank-ticket.template
CREATE TABLE IF NOT EXISTS `template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  `clientId` varchar(250) NOT NULL,
  `description` varchar(250) NOT NULL,
  `version` varchar(250) NOT NULL,
  `tempateType` varchar(250) NOT NULL,
  `json` text NOT NULL,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `status` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` varchar(50) NOT NULL DEFAULT '',
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.template: ~0 rows (approximately)
INSERT INTO `template` (`id`, `name`, `clientId`, `description`, `version`, `tempateType`, `json`, `presence`, `status`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(7, 'dari client XYZ', '', '', '20260818', 'project', '{"projectId":"PRJ-774F9C2F","projectName":"Wind Toys 1/12 Super Movable — The ultimate body for customizing figures","project":{"id":"PRJ-774F9C2F","name":"Wind Toys 1/12 Super Movable — The ultimate body for customizing figures","projectTypeId":3,"projectBilleableId":1,"productId":1,"ticketCategoriesParentId":10,"clientId":"351","startDate":"2026-07-13","endDate":"2026-10-30","status":1,"templateMaster":"6","presence":1,"inputDate":"2026-08-11 14:00:32","inputBy":"USR-ADMIN","updateDate":"2026-08-18 15:15:13","updateBy":"USR-ADMIN","clientName":"PT XYZ Jp.co","projectTypeName":"Software Support Fixed Cost","projectBilleableName":"Chrageable","productName":"Acumatica ERP","ticketBased":0,"users":[{"id":"USR-12788040","name":"Internal Tester","email":"781164843@client.local","userAuthLevel":"Administrator","division":"","position":"","userAuthLevelId":1,"userTypeId":1,"asManager":0,"checked":1},{"id":"USR-405F00F4","name":"Internal Tester","email":"1781164861@client.local","userAuthLevel":"Administrator","division":"","position":"","userAuthLevelId":1,"userTypeId":1,"asManager":0,"checked":1},{"id":"USR-ADMIN","name":"System Admin","email":"admin@thinktank.local","userAuthLevel":"Administrator","division":"","position":"","userAuthLevelId":1,"userTypeId":1,"asManager":1,"checked":1},{"id":"USR-62199DD8","name":"Temp Updated User","email":"temp.user.crud@thinktank.local","userAuthLevel":"ThinkTank Admin","division":"","position":"","userAuthLevelId":2,"userTypeId":1,"asManager":0,"checked":0},{"id":"USR-8C76A791","name":"baba cdcd","email":"cso12333@email.com","userAuthLevel":"ThinkTank Admin","division":"","position":"","userAuthLevelId":2,"userTypeId":1,"asManager":0,"checked":0},{"id":"USR-E5A4B811","name":"abb abb","email":"anggie123@crm.co.id","userAuthLevel":"Administrator","division":"Division 1","position":"Position 2","userAuthLevelId":1,"userTypeId":1,"asManager":0,"checked":0}],"ticketCategories":[{"id":114,"name":"abcds"},{"id":100,"name":"Blueprint"},{"id":105,"name":"Deployement"},{"id":106,"name":"GO LIVE"},{"id":103,"name":"SIT & UAT"},{"id":104,"name":"Training"}],"ticketBalance":{"ticketIn":"0","ticketOut":"0","balance":"0"},"contacts":[{"id":65,"userId":"DEMO1","name":"Client 200 Demo","phone":"021111111","email":"client2.demo@thinktank.local","projectId":"PRJ-774F9C2F","division":"Division","position":"Position"},{"id":66,"userId":"DEMO2","name":"Client 300 Demo","phone":"021111111","email":"client3.demo@thinktank.local","projectId":"PRJ-774F9C2F","division":"","position":""},{"id":67,"userId":"USR-39C10981","name":"ag agggg","phone":"32434234","email":"ac@gmail.com1","projectId":"PRJ-774F9C2F","division":"","position":""}],"modules":[{"productId":1,"id":4,"name":"Module AR"},{"productId":1,"id":5,"name":"Module Fix Asset"}],"templateName":"master 1","task":[{"id":114,"name":"abcds","data":[]},{"id":100,"name":"Blueprint","data":[]},{"id":105,"name":"Deployement","data":[]},{"id":106,"name":"GO LIVE","data":[{"id":"TA000038","title":"go 1","projectId":"PRJ-774F9C2F","submitDate":"2026-08-18 00:00:00","targetCompletionDate":"2026-08-18","ticketStatusId":1,"ticketCategoryId":106,"ticketTypeName":"Task","ticketStatusName":"Open","projectName":"Wind Toys 1/12 Super Movable — The ultimate body for customizing figures","ticketCategoryName":"SAP Implement - GO LIVE","clientName":"PT XYZ Jp.co","parentCategoryName":"SAP Implement","assignTo":"USR-ADMIN","assignToName":"System Admin"}]},{"id":103,"name":"SIT & UAT","data":[]},{"id":104,"name":"Training","data":[{"id":"TA000040","title":"R1","projectId":"PRJ-774F9C2F","submitDate":"2026-08-18 00:00:00","targetCompletionDate":"2026-08-18","ticketStatusId":1,"ticketCategoryId":104,"ticketTypeName":"Task","ticketStatusName":"Open","projectName":"Wind Toys 1/12 Super Movable — The ultimate body for customizing figures","ticketCategoryName":"SAP Implement - Training","clientName":"PT XYZ Jp.co","parentCategoryName":"SAP Implement","assignTo":"USR-ADMIN","assignToName":"System Admin"}]}],"cases":[{"id":114,"name":"abcds","data":[]},{"id":100,"name":"Blueprint","data":[]},{"id":105,"name":"Deployement","data":[]},{"id":106,"name":"GO LIVE","data":[]},{"id":103,"name":"SIT & UAT","data":[]},{"id":104,"name":"Training","data":[{"id":"IS000054","title":"C3","projectId":"PRJ-774F9C2F","submitDate":"2026-08-18 15:16:32","targetCompletionDate":"2026-08-18","ticketStatusId":1,"ticketCategoryId":104,"ticketTypeName":"Case","ticketStatusName":"Open","ticketSeverityName":"Low","color":"dark","taskCount":0,"projectName":"Wind Toys 1/12 Super Movable — The ultimate body for customizing figures","assignTo":"USR-ADMIN","assignToName":"System Admin","clientName":"PT XYZ Jp.co","parentCategoryName":"SAP Implement","ticketCategoryName":"SAP Implement - Training"}]}],"cr":[{"id":114,"name":"abcds","data":[]},{"id":100,"name":"Blueprint","data":[]},{"id":105,"name":"Deployement","data":[]},{"id":106,"name":"GO LIVE","data":[]},{"id":103,"name":"SIT & UAT","data":[]},{"id":104,"name":"Training","data":[]}]}}', 1, 1, '2026-08-18 15:19:29', 'USR-ADMIN', '2026-08-18 15:19:29', 'USR-ADMIN');

-- Dumping structure for table thinktank-ticket.ticket
CREATE TABLE IF NOT EXISTS `ticket` (
  `id` varchar(50) NOT NULL DEFAULT '',
  `ticketTypeId` int(11) NOT NULL DEFAULT 0,
  `ticketCategoryId` int(11) NOT NULL,
  `ticketSeverityId` int(11) NOT NULL,
  `productChildId` varchar(50) NOT NULL DEFAULT '',
  `crNoRef` varchar(50) NOT NULL DEFAULT '',
  `issueNo` varchar(50) NOT NULL DEFAULT '',
  `title` varchar(250) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `projectId` varchar(50) NOT NULL DEFAULT '',
  `submitBy` varchar(50) NOT NULL DEFAULT '',
  `submitDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `deadlineDateTime` datetime NOT NULL DEFAULT '2026-01-01 00:00:00',
  `targetCompletionDate` date NOT NULL,
  `assignTo` varchar(50) NOT NULL DEFAULT '0',
  `taskSolution` text NOT NULL DEFAULT '',
  `actualCompletionDate` date NOT NULL,
  `ticketStatusId` int(11) NOT NULL DEFAULT 0,
  `rating` tinyint(4) NOT NULL,
  `ratesBy` varchar(50) NOT NULL DEFAULT '',
  `ticketEstimationCost` float NOT NULL DEFAULT 0,
  `hours` float NOT NULL,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` varchar(50) NOT NULL DEFAULT 'mysql',
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` varchar(50) NOT NULL DEFAULT 'mysql',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.ticket: ~2 rows (approximately)
INSERT INTO `ticket` (`id`, `ticketTypeId`, `ticketCategoryId`, `ticketSeverityId`, `productChildId`, `crNoRef`, `issueNo`, `title`, `description`, `projectId`, `submitBy`, `submitDate`, `deadlineDateTime`, `targetCompletionDate`, `assignTo`, `taskSolution`, `actualCompletionDate`, `ticketStatusId`, `rating`, `ratesBy`, `ticketEstimationCost`, `hours`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	('IS000066', 2, 105, 10, '5', '', '', 'test task detail dari case', '<p>jika new task dari klik CASE → modul nya masih kosong. ( seperti gambar diatas) Bagaimana jika, secara default terinput field modul secara defauld mengikuti Case nya.</p>', 'PRJ-1CF03AF3', 'USR-ADMIN', '2026-09-01 15:28:26', '2026-09-01 22:28:26', '2026-09-01', 'DEMO1', '', '2026-09-01', 900, 0, '', 2, 6, 1, '2026-09-01 15:28:26', '1', '2026-09-01 16:26:32', 'USR-ADMIN'),
	('IS000067', 2, 106, 10, '5', '', '', 'tes c', 'ce123', 'PRJ-1CF03AF3', 'DEMO1', '2026-09-01 16:51:50', '2026-09-01 16:51:50', '0000-00-00', 'USR-ADMIN', '', '0000-00-00', 1, 0, '', 0, 0, 1, '2026-09-01 16:51:51', '1', '2026-09-01 16:51:51', '1');

-- Dumping structure for table thinktank-ticket.ticket_balance
CREATE TABLE IF NOT EXISTS `ticket_balance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectId` varchar(250) NOT NULL DEFAULT '',
  `note` varchar(250) NOT NULL,
  `ticketId` varchar(250) NOT NULL,
  `date` datetime NOT NULL DEFAULT '2026-01-01 00:00:00',
  `ticketIn` int(11) NOT NULL DEFAULT 0,
  `ticketOut` int(11) NOT NULL DEFAULT 0,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `projectId` (`projectId`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.ticket_balance: ~2 rows (approximately)
INSERT INTO `ticket_balance` (`id`, `projectId`, `note`, `ticketId`, `date`, `ticketIn`, `ticketOut`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(16, 'PRJ-9D2E7985', '', 'IS000046', '2026-08-13 13:45:48', 0, 12, 1, '2026-08-13 13:45:48', 0, '2025-01-01 00:00:00', 1),
	(17, 'PRJ-9D2E7985', 'top up', '', '2026-08-13 00:00:00', 1000, 0, 1, '2026-08-13 13:46:05', 1, '2026-08-13 13:46:05', 1),
	(18, 'PRJ-774F9C2F', '', 'IS000043', '2026-08-13 15:01:22', 0, 0, 1, '2026-08-13 15:01:22', 0, '2025-01-01 00:00:00', 1),
	(19, 'PRJ-8DB73818', '', 'IS000052', '2026-08-14 14:35:06', 0, 0, 1, '2026-08-14 14:35:06', 0, '2025-01-01 00:00:00', 1),
	(20, 'PRJ-1CF03AF3', '', 'IS000066', '2026-09-01 16:26:32', 0, 2, 1, '2026-09-01 16:26:32', 0, '2025-01-01 00:00:00', 1);

-- Dumping structure for table thinktank-ticket.ticket_categories
CREATE TABLE IF NOT EXISTS `ticket_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentId` int(11) NOT NULL DEFAULT 0,
  `name` varchar(250) NOT NULL DEFAULT '',
  `weight` tinyint(4) NOT NULL DEFAULT 0,
  `sorting` tinyint(4) NOT NULL DEFAULT 99,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.ticket_categories: ~12 rows (approximately)
INSERT INTO `ticket_categories` (`id`, `parentId`, `name`, `weight`, `sorting`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(10, 0, 'SAP Implement', 0, 99, 1, 1, '2025-01-01 00:00:00', 1, '2026-08-04 15:10:30', 1),
	(100, 10, 'Blueprint', 0, 127, 1, 1, '2025-01-01 00:00:00', 1, '2026-08-04 16:17:50', 1),
	(102, 10, 'Configuration  DEL', 0, 99, 0, 1, '2025-01-01 00:00:00', 1, '2026-09-01 12:47:42', 1),
	(103, 10, 'SIT & UAT', 0, 99, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(104, 10, 'Training', 0, 99, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(105, 10, 'Deployement', 0, 99, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(106, 10, 'GO LIVE', 0, 14, 1, 1, '2025-01-01 00:00:00', 1, '2026-08-04 16:18:31', 1),
	(107, 10, 'CAT-TEMP', 0, 99, 1, 0, '2026-06-10 17:00:27', 1, '2026-06-10 17:00:27', 1),
	(108, 0, 'Oddo', 0, 99, 1, 1, '2026-07-13 18:45:26', 1, '2026-07-13 18:47:56', 1),
	(109, 108, 'UAT', 32, 99, 0, 1, '2026-07-13 18:45:34', 1, '2026-08-04 15:43:53', 1),
	(110, 108, 'Blue print', 0, 99, 0, 1, '2026-07-13 18:45:46', 1, '2026-08-18 12:39:36', 1),
	(111, 108, 'Testing', 0, 99, 1, 1, '2026-07-13 18:45:58', 1, '2026-07-13 18:45:58', 1),
	(112, 108, 'development', 30, 99, 0, 1, '2026-07-13 18:46:03', 1, '2026-08-18 12:39:32', 1),
	(113, 0, 'abc', 0, 0, 0, 1, '2026-08-10 11:46:10', 1, '2026-08-18 12:59:25', 1),
	(114, 10, 'abcds', 0, 127, 1, 1, '2026-08-10 11:46:16', 1, '2026-08-10 11:46:29', 1);

-- Dumping structure for table thinktank-ticket.ticket_logs
CREATE TABLE IF NOT EXISTS `ticket_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentId` int(11) NOT NULL DEFAULT 0,
  `ticketId` varchar(50) NOT NULL DEFAULT '',
  `starDateTime` datetime NOT NULL DEFAULT '2026-01-01 00:00:00',
  `closeDateTime` datetime NOT NULL DEFAULT '2026-01-01 00:00:00',
  `description` text NOT NULL DEFAULT '',
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputBySystem` tinyint(2) NOT NULL DEFAULT 0,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` varchar(50) NOT NULL DEFAULT '',
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.ticket_logs: ~11 rows (approximately)
INSERT INTO `ticket_logs` (`id`, `parentId`, `ticketId`, `starDateTime`, `closeDateTime`, `description`, `presence`, `inputBySystem`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(106, 0, 'IS000047', '2026-08-11 14:47:35', '2026-08-11 14:47:35', 'Update Assignee from <strong>System Admin</strong> To  <strong>Internal Tester</strong> ', 1, 0, '2026-08-11 14:47:35', 'USR-ADMIN', '2026-08-11 14:47:35', 'USR-ADMIN'),
	(107, 0, 'IS000048', '2026-08-11 14:47:51', '2026-08-11 14:47:51', 'Update Assignee from <strong>System Admin</strong> To  <strong>Internal Tester</strong> ', 1, 0, '2026-08-11 14:47:51', 'USR-ADMIN', '2026-08-11 14:47:51', 'USR-ADMIN'),
	(108, 0, 'TA000035', '2026-08-11 14:48:00', '2026-08-11 14:48:00', 'Update Assignee from <strong>System Admin</strong> To  <strong>Internal Tester</strong> ', 1, 0, '2026-08-11 14:48:00', 'USR-ADMIN', '2026-08-11 14:48:00', 'USR-ADMIN'),
	(109, 0, 'TA000035', '2026-08-11 14:48:00', '2026-08-11 14:48:00', 'Update Status from <strong>Open</strong> To  <strong>Review</strong> ', 1, 0, '2026-08-11 14:48:00', 'USR-ADMIN', '2026-08-11 14:48:00', 'USR-ADMIN'),
	(110, 0, 'IS000045', '2026-08-13 12:47:39', '2026-08-13 12:47:39', 'Update Assignee from <strong>System Admin</strong> To  <strong>Client 200 Demo</strong> ', 1, 0, '2026-08-13 12:47:39', 'USR-ADMIN', '2026-08-13 12:47:39', 'USR-ADMIN'),
	(111, 0, 'IS000045', '2026-08-13 12:47:39', '2026-08-13 12:47:39', 'Update Status from <strong>Open</strong> To  <strong>Verified</strong>', 1, 0, '2026-08-13 12:47:39', 'USR-ADMIN', '2026-08-13 12:47:39', 'USR-ADMIN'),
	(112, 0, 'IS000046', '2026-08-13 13:45:48', '2026-08-13 13:45:48', 'Update Assignee from <strong>System Admin</strong> To  <strong>Client 200 Demo</strong> ', 1, 0, '2026-08-13 13:45:48', 'USR-ADMIN', '2026-08-13 13:45:48', 'USR-ADMIN'),
	(113, 0, 'IS000046', '2026-08-13 13:45:48', '2026-08-13 13:45:48', 'Update Status from <strong>Open</strong> To  <strong>Closed</strong>', 1, 0, '2026-08-13 13:45:48', 'USR-ADMIN', '2026-08-13 13:45:48', 'USR-ADMIN'),
	(114, 0, 'IS000043', '2026-08-13 14:59:15', '2026-08-13 14:59:15', 'Update Assignee from <strong>System Admin</strong> To  <strong>Client 200 Demo</strong> ', 1, 0, '2026-08-13 14:59:15', 'USR-ADMIN', '2026-08-13 14:59:15', 'USR-ADMIN'),
	(115, 0, 'IS000043', '2026-08-13 14:59:15', '2026-08-13 14:59:15', 'Update Status from <strong>Open</strong> To  <strong>Verified</strong>', 1, 0, '2026-08-13 14:59:15', 'USR-ADMIN', '2026-08-13 14:59:15', 'USR-ADMIN'),
	(116, 0, 'IS000043', '2026-08-13 15:01:22', '2026-08-13 15:01:22', 'Update Status from <strong>Verified</strong> To <strong>Closed</strong>', 1, 0, '2026-08-13 15:01:22', 'DEMO1', '2026-08-13 15:01:22', 'DEMO1'),
	(117, 0, 'IS000039', '2026-08-13 15:51:58', '2026-08-13 15:51:58', 'Update Assignee from <strong>System Admin</strong> To  <strong>Client 200 Demo</strong> ', 1, 0, '2026-08-13 15:51:58', 'USR-ADMIN', '2026-08-13 15:51:58', 'USR-ADMIN'),
	(118, 0, 'IS000039', '2026-08-13 15:51:58', '2026-08-13 15:51:58', 'Update Status from <strong>Open</strong> To  <strong>Verified</strong>', 1, 0, '2026-08-13 15:51:58', 'USR-ADMIN', '2026-08-13 15:51:58', 'USR-ADMIN'),
	(119, 0, 'IS000052', '2026-08-14 14:35:06', '2026-08-14 14:35:06', 'Update Status from <strong>Open</strong> To  <strong>Closed</strong>', 1, 0, '2026-08-14 14:35:06', 'USR-ADMIN', '2026-08-14 14:35:06', 'USR-ADMIN'),
	(120, 0, 'TA000037', '2026-08-14 14:41:46', '2026-08-14 14:41:46', 'Update Status from <strong>Open</strong> To  <strong>Closed</strong> ', 1, 0, '2026-08-14 14:41:46', 'USR-ADMIN', '2026-08-14 14:41:46', 'USR-ADMIN'),
	(121, 0, 'IS000066', '2026-09-01 16:26:32', '2026-09-01 16:26:32', 'Update Assignee from <strong>System Admin</strong> To  <strong>Client 200 Demo</strong> ', 1, 0, '2026-09-01 16:26:32', 'USR-ADMIN', '2026-09-01 16:26:32', 'USR-ADMIN'),
	(122, 0, 'IS000066', '2026-09-01 16:26:32', '2026-09-01 16:26:32', 'Update Status from <strong>Open</strong> To  <strong>Closed</strong>', 1, 0, '2026-09-01 16:26:32', 'USR-ADMIN', '2026-09-01 16:26:32', 'USR-ADMIN');

-- Dumping structure for table thinktank-ticket.ticket_logs_attachments
CREATE TABLE IF NOT EXISTS `ticket_logs_attachments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticketId` varchar(50) NOT NULL DEFAULT '',
  `ticketLogId` int(10) unsigned NOT NULL,
  `originalName` varchar(255) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `mimetype` varchar(100) NOT NULL,
  `size` int(10) unsigned NOT NULL,
  `url` varchar(500) NOT NULL,
  `inputDate` datetime DEFAULT current_timestamp(),
  `inputBy` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf16 COLLATE=utf16_bin;

-- Dumping data for table thinktank-ticket.ticket_logs_attachments: ~0 rows (approximately)

-- Dumping structure for table thinktank-ticket.ticket_rating
CREATE TABLE IF NOT EXISTS `ticket_rating` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ticketId` varchar(250) NOT NULL,
  `value` int(11) NOT NULL DEFAULT 0,
  `ratingId` int(11) NOT NULL DEFAULT 0,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` varchar(50) NOT NULL DEFAULT '',
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.ticket_rating: ~10 rows (approximately)
INSERT INTO `ticket_rating` (`id`, `ticketId`, `value`, `ratingId`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(30, 'TA000037', 3, 10, 1, '2026-08-14 14:48:22', 'USR-ADMIN', '2026-08-14 14:48:22', 'USR-ADMIN'),
	(31, 'TA000037', 3, 11, 1, '2026-08-14 14:48:22', 'USR-ADMIN', '2026-08-14 14:48:22', 'USR-ADMIN'),
	(32, 'TA000037', 3, 12, 1, '2026-08-14 14:48:22', 'USR-ADMIN', '2026-08-14 14:48:22', 'USR-ADMIN'),
	(33, 'TA000037', 3, 13, 1, '2026-08-14 14:48:22', 'USR-ADMIN', '2026-08-14 14:48:22', 'USR-ADMIN'),
	(34, 'TA000037', 3, 14, 1, '2026-08-14 14:48:22', 'USR-ADMIN', '2026-08-14 14:48:22', 'USR-ADMIN'),
	(35, 'IS000052', 3, 10, 1, '2026-08-14 14:48:23', 'USR-ADMIN', '2026-08-14 14:48:23', 'USR-ADMIN'),
	(36, 'IS000052', 3, 11, 1, '2026-08-14 14:48:23', 'USR-ADMIN', '2026-08-14 14:48:23', 'USR-ADMIN'),
	(37, 'IS000052', 3, 12, 1, '2026-08-14 14:48:23', 'USR-ADMIN', '2026-08-14 14:48:23', 'USR-ADMIN'),
	(38, 'IS000052', 3, 13, 1, '2026-08-14 14:48:23', 'USR-ADMIN', '2026-08-14 14:48:23', 'USR-ADMIN'),
	(39, 'IS000052', 3, 14, 1, '2026-08-14 14:48:23', 'USR-ADMIN', '2026-08-14 14:48:23', 'USR-ADMIN');

-- Dumping structure for table thinktank-ticket.ticket_severity
CREATE TABLE IF NOT EXISTS `ticket_severity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  `duration` tinyint(4) NOT NULL DEFAULT 0,
  `color` varchar(50) NOT NULL DEFAULT '0',
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.ticket_severity: ~5 rows (approximately)
INSERT INTO `ticket_severity` (`id`, `name`, `duration`, `color`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(10, 'Low', 7, 'dark', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(20, 'Medium', 6, 'success', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(30, 'High', 5, 'primary', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(40, 'Urgent', 4, 'warning', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(100, 'System Down', 2, 'danger', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1);

-- Dumping structure for table thinktank-ticket.ticket_status
CREATE TABLE IF NOT EXISTS `ticket_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  `task` tinyint(4) NOT NULL DEFAULT 0,
  `issues` tinyint(4) NOT NULL DEFAULT 0,
  `cr` tinyint(4) NOT NULL DEFAULT 0,
  `finish` tinyint(4) NOT NULL,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=991 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.ticket_status: ~5 rows (approximately)
INSERT INTO `ticket_status` (`id`, `name`, `task`, `issues`, `cr`, `finish`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1, 'Open', 1, 1, 0, 0, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(100, 'Review', 1, 1, 0, 0, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(400, 'Verified', 0, 1, 0, 0, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(900, 'Closed', 1, 1, 0, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(990, 'Cancelled', 1, 1, 0, 4, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1);

-- Dumping structure for table thinktank-ticket.ticket_status_logs
CREATE TABLE IF NOT EXISTS `ticket_status_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticketId` varchar(50) NOT NULL DEFAULT '',
  `ticketStatusId` int(11) NOT NULL DEFAULT 0,
  `inputDate` datetime DEFAULT current_timestamp(),
  `inputBy` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf16 COLLATE=utf16_bin;

-- Dumping data for table thinktank-ticket.ticket_status_logs: ~0 rows (approximately)

-- Dumping structure for table thinktank-ticket.ticket_type
CREATE TABLE IF NOT EXISTS `ticket_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.ticket_type: ~2 rows (approximately)
INSERT INTO `ticket_type` (`id`, `name`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1, 'Task', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(2, 'Case', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(3, 'Change Request (CR)', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1);

-- Dumping structure for table thinktank-ticket.ticket_upload
CREATE TABLE IF NOT EXISTS `ticket_upload` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` text NOT NULL DEFAULT '',
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.ticket_upload: ~0 rows (approximately)

-- Dumping structure for table thinktank-ticket.user
CREATE TABLE IF NOT EXISTS `user` (
  `id` varchar(250) NOT NULL DEFAULT '',
  `email` varchar(200) DEFAULT NULL,
  `clientId` int(11) NOT NULL DEFAULT 0,
  `userTypeId` tinyint(4) DEFAULT 1,
  `password` varchar(200) DEFAULT NULL,
  `userAuthLevelId` smallint(6) DEFAULT NULL,
  `firstName` varchar(200) DEFAULT NULL,
  `lastName` varchar(200) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  `birthday` date NOT NULL DEFAULT '2000-01-01',
  `division` varchar(250) NOT NULL DEFAULT '',
  `position` varchar(250) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `presence` tinyint(4) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` int(11) NOT NULL DEFAULT 0,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.user: ~20 rows (approximately)
INSERT INTO `user` (`id`, `email`, `clientId`, `userTypeId`, `password`, `userAuthLevelId`, `firstName`, `lastName`, `phone`, `mobile`, `birthday`, `division`, `position`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	('DEMO1', 'client2.demo@thinktank.local', 351, 2, '$2b$04$PvuW5961sR/GyULMf.J9t.NXxQVGnLldRnejBhi7iEw3OD2oEV7.S', 2, 'Client 200', 'Demo', '021111111', '081200000002', '1992-02-02', 'Division', 'Position', 1, 1, '2026-06-10 15:53:03', 1, '2026-09-01 16:50:12', 1),
	('DEMO2', 'client3.demo@thinktank.local', 351, 2, '$2b$04$vpl.W2psDhKPJt3CdgMOUOPqdxu6dG3ORdEMUCHl5Fo65ZMzeTD3S', 2, 'Client 300', 'Demo', '021111111', '081200000002', '1992-02-02', '', '', 1, 1, '2026-06-10 15:53:03', 1, '2026-08-19 13:20:17', 0),
	('USR-05AD1FCD', 'delete.178540053279891739.ABc1@crm.co.id', 357, 2, '$2b$04$QqV8Zr.DAKD0vBp93Q7KIOxoFHeei36EM..KScScEIq8xVL2U/uM2', 0, 'abc', 'abc', '123213', NULL, '2000-01-01', '', '', 0, 0, '2026-07-30 15:02:03', 1, '2026-07-30 15:35:32', 1),
	('USR-12788040', '781164843@client.local', 0, 1, '$2b$04$JBxug4U1FQOL/67qnHFCp.wmLdntsXE3PjjeSDvou2qoWNtLdh87K', 1, 'Internal', 'Tester', NULL, NULL, '2000-01-01', '', '', 0, 1, '2026-06-11 15:00:43', 1, '2026-06-11 15:00:44', 1),
	('USR-266E8E9A', 'bca@crm.co.id', 357, 2, '$2b$04$VvWH8eRfTTyDAE0xdsdiB.9Jkc5NBDmsVrDaScI69X///fNk8K02q', 0, 'bca', 'beca', '123', NULL, '2000-01-01', '1', '2', 1, 1, '2026-07-30 15:35:26', 1, '2026-08-04 17:21:11', 1),
	('USR-39C10981', 'ac@gmail.com1', 351, 2, '$2b$04$kJhSlqElVD5/9AmyEjP1qOvzlTO./WwjYerz9EWKa2xe38jI0tanC', 0, 'ag', 'agggg', '32434234', NULL, '2000-01-01', '', '', 1, 1, '2026-07-23 16:27:35', 1, '2026-08-19 13:20:17', 0),
	('USR-405F00F4', '1781164861@client.local', 0, 1, '$2b$04$AOsIwcrlShK0kLi/mArz2ei57DRvpGh/z3zKvLCn8rUmcBCZiEY.O', 1, 'Internal', 'Tester', NULL, NULL, '2000-01-01', '', '', 0, 1, '2026-06-11 15:01:01', 1, '2026-06-11 15:01:01', 1),
	('USR-48D7A6DE', 'angg111ie@crm.co.id', 357, 2, '$2b$04$i6rJOpE7rP5OshdUUodJ1eAoKBEwGbFJvpGxRKmSDfk3Zp7b656FC', 0, 'aaaa', 'aaa', '123213', NULL, '2000-01-01', '', '', 1, 1, '2026-07-30 15:35:11', 1, '2026-07-30 15:35:11', 1),
	('USR-62199DD8', 'temp.user.crud@thinktank.local', 0, 1, '$2b$04$ZC9rTZ16ZujoiD2rHXzgIOyfCUPXWl5LhWd4IyziFTXSz70.ob8QO', 2, 'Temp Updated', 'User', NULL, NULL, '2000-01-01', '', '', 0, 1, '2026-06-10 16:55:29', 1, '2026-06-10 16:55:29', 1),
	('USR-644DE7B2', 'anggie1@crm.co.id', 0, 2, '$2b$04$YaRLlMh1w55LFBXNt3k8xueXP98oCidlsMt5pB2qeccFrg86z9tCS', 1, 'asv', 'asd', NULL, NULL, '2000-01-01', '', '', 1, 1, '2026-07-30 15:28:24', 1, '2026-07-30 15:28:24', 1),
	('USR-6CBBCE3A', 'ext.1781164821.1@thinktank.local', 353, 2, '$2b$04$BflCbR5izWKIr3mQhY70QeCsDWAd6jzamlJtABhDTrlP3TobcrEdi', 2, 'ExternalUpdated', 'One', NULL, '081200009999', '2000-01-01', '', '', 0, 1, '2026-06-11 15:00:21', 1, '2026-06-11 15:00:21', 1),
	('USR-8C76A791', 'cso12333@email.com', 0, 1, '$2b$04$gGfp6qMsTh4bWBYh6Dmla.2wSQT0uXP2ojguZEz4f3YgMBAMEIDNS', 2, 'baba', 'cdcd', NULL, NULL, '2000-01-01', '', '', 1, 1, '2026-06-11 15:58:19', 1, '2026-06-15 13:08:26', 1),
	('USR-9A0C9A66', 'ag@jagoan.com', 351, 2, '$2b$04$t6JkvhF.VwNjlHMPf37JU.eiQ.PNiv/rCONn3d4Nr..9/j9cifIXG', 0, 'Abang', 'Abang', '234234', NULL, '2000-01-01', 'Division', 'Position', 1, 1, '2026-08-04 17:36:59', 1, '2026-08-19 13:20:17', 0),
	('USR-9B8746FD', 'ext.1781164821.2@thinktank.local', 353, 2, '$2b$04$HtnLpRDw4ChNT73Uh26.s.GaDhDAKk2sWx03N2a2r6LDHYIhoT94O', 2, 'External', 'Two', NULL, NULL, '2000-01-01', '', '', 0, 1, '2026-06-11 15:00:21', 1, '2026-06-11 15:00:21', 1),
	('USR-ADMIN', 'admin@thinktank.local', 0, 1, '$2b$04$pBuL95VqIupLzvuvu399huQEYeuC5bJbEfAU.6uo58Xq3xVIs6BLS', 1, 'System', 'Admin', '021000000', '081200000001', '1990-01-01', '', '', 1, 1, '2026-06-10 15:53:03', 1, '2026-06-10 15:53:03', 1),
	('USR-B910B246', 'anggie@crm.co.id', 357, 2, '$2b$04$uVlvlM8yXEfyYFcyBSOHI.FwJXTrmFh0LYKikmYxRJ8.LvSBnKp/y', 0, 'abc', 'abc', '123', NULL, '2000-01-01', '', '', 1, 1, '2026-07-30 15:03:04', 1, '2026-07-30 15:03:04', 1),
	('USR-CLIENT', 'client.demo@thinktank.local', 351, 2, '$2b$04$vpl.W2psDhKPJt3CdgMOUOPqdxu6dG3ORdEMUCHl5Fo65ZMzeTD3S', 2, 'Client', 'Demo', '021111111', '081200000002', '1992-02-02', '', '', 1, 1, '2026-06-10 15:53:03', 1, '2026-08-19 13:20:17', 0),
	('USR-DA3007FC', 'anggid22e@crm.co.id', 0, 2, '$2b$04$pKcmM4KwbhrjX0DnK3Wm/O13OTdcMYQ1rDDvUgyLwpBu5FqN0dXgi', 13, 'aba', 'abc', NULL, NULL, '2000-01-01', '', '', 1, 1, '2026-07-30 15:28:11', 1, '2026-07-30 15:28:11', 1),
	('USR-DCDA5ED4', 'kaka@crmkaka.co.id', 351, 2, '$2b$04$VT.TlIXQpmMFIWMNWVwnNuy5xs49hQPTFBS8Ip1R5Qh8xPrS4Jj6e', 0, 'kaka', 'kaka', '355555', NULL, '2000-01-01', 'Division', 'Position', 1, 1, '2026-08-04 17:48:37', 1, '2026-08-19 13:20:17', 0),
	('USR-E5A4B811', 'anggie123@crm.co.id', 0, 1, '$2b$04$l6qFrmYDZ7Sve5cCFFUuYuh1IqAIix9gIQr9pYVdWKRciYTOaBiLC', 13, 'abb', 'abb', NULL, NULL, '2000-01-01', 'Division 1', 'Position 2', 1, 1, '2026-07-30 15:29:13', 1, '2026-09-01 17:36:01', 1);

-- Dumping structure for table thinktank-ticket.user_access_right
CREATE TABLE IF NOT EXISTS `user_access_right` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authLevelId` smallint(6) NOT NULL DEFAULT 0,
  `moduleId` int(11) NOT NULL DEFAULT 0,
  `c` tinyint(4) NOT NULL DEFAULT 0,
  `r` tinyint(4) NOT NULL DEFAULT 0,
  `u` tinyint(4) NOT NULL DEFAULT 0,
  `d` tinyint(4) NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=404 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.user_access_right: ~53 rows (approximately)
INSERT INTO `user_access_right` (`id`, `authLevelId`, `moduleId`, `c`, `r`, `u`, `d`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(351, 1, 0, 0, 0, 0, 0, 0, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(352, 1, 1001, 1, 1, 1, 1, 0, 1, '2026-07-08 13:49:46', 1, '2026-08-04 15:11:36', 1),
	(353, 1, 1002, 1, 1, 1, 1, 0, 1, '2026-07-08 13:49:46', 1, '2026-08-04 15:11:36', 1),
	(354, 1, 1003, 1, 1, 1, 1, 0, 1, '2026-07-08 13:49:46', 1, '2026-08-04 15:11:36', 1),
	(355, 1, 1004, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:18', 1, '2026-08-04 15:11:36', 1),
	(356, 1, 1005, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:18', 1, '2026-08-04 15:11:36', 1),
	(357, 1, 1006, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:18', 1, '2026-08-04 15:11:36', 1),
	(358, 1, 1007, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:18', 1, '2026-08-04 15:11:36', 1),
	(359, 1, 2001, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:18', 1, '2026-08-04 15:11:36', 1),
	(360, 1, 2002, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:18', 1, '2026-08-04 15:11:36', 1),
	(361, 1, 2003, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:18', 1, '2026-08-04 15:11:36', 1),
	(362, 1, 2004, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:18', 1, '2026-08-04 15:11:36', 1),
	(363, 1, 5005, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:18', 1, '2026-08-04 15:11:36', 1),
	(364, 1, 5006, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:18', 1, '2026-08-04 15:11:36', 1),
	(365, 1, 5007, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:18', 1, '2026-08-04 15:11:36', 1),
	(366, 1, 6000, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:19', 1, '2026-08-04 15:11:36', 1),
	(367, 1, 6001, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:19', 1, '2026-08-04 15:11:36', 1),
	(368, 1, 6002, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:19', 1, '2026-08-04 15:11:36', 1),
	(369, 2, 1001, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(370, 2, 1002, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(371, 2, 1003, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(372, 2, 1004, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(373, 2, 1005, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(374, 2, 1006, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(375, 2, 1007, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(376, 2, 2001, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(377, 2, 2002, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(378, 2, 2003, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(379, 2, 2004, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(380, 2, 5005, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(381, 2, 5006, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(382, 2, 5007, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(383, 2, 6000, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(384, 2, 6001, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(385, 2, 6002, 1, 1, 1, 1, 0, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(386, 9, 1001, 0, 1, 1, 0, 0, 1, '2026-07-10 11:57:57', 1, '2026-07-10 11:57:57', 1),
	(387, 9, 1002, 0, 1, 1, 0, 0, 1, '2026-07-10 11:57:57', 1, '2026-07-10 11:57:57', 1),
	(388, 9, 1003, 0, 1, 1, 0, 0, 1, '2026-07-10 11:57:57', 1, '2026-07-10 11:57:57', 1),
	(389, 9, 1004, 0, 1, 1, 0, 0, 1, '2026-07-10 11:57:57', 1, '2026-07-10 11:57:57', 1),
	(390, 9, 1005, 0, 1, 1, 0, 0, 1, '2026-07-10 11:57:57', 1, '2026-07-10 11:57:57', 1),
	(391, 9, 1006, 0, 1, 1, 0, 0, 1, '2026-07-10 11:57:57', 1, '2026-07-10 11:57:57', 1),
	(392, 9, 1007, 0, 1, 1, 0, 0, 1, '2026-07-10 11:57:57', 1, '2026-07-10 11:57:57', 1),
	(393, 9, 2001, 0, 1, 1, 0, 0, 1, '2026-07-10 11:57:57', 1, '2026-07-10 11:57:57', 1),
	(394, 9, 2002, 0, 1, 1, 0, 0, 1, '2026-07-10 11:57:57', 1, '2026-07-10 11:57:57', 1),
	(395, 9, 2003, 0, 1, 1, 0, 0, 1, '2026-07-10 11:57:57', 1, '2026-07-10 11:57:57', 1),
	(396, 9, 2004, 0, 1, 1, 0, 0, 1, '2026-07-10 11:57:57', 1, '2026-07-10 11:57:57', 1),
	(397, 9, 5005, 0, 1, 1, 0, 0, 1, '2026-07-10 11:57:57', 1, '2026-07-10 11:57:57', 1),
	(398, 9, 5006, 0, 1, 1, 0, 0, 1, '2026-07-10 11:57:57', 1, '2026-07-10 11:57:57', 1),
	(399, 9, 5007, 0, 1, 1, 0, 0, 1, '2026-07-10 11:57:57', 1, '2026-07-10 11:57:57', 1),
	(400, 9, 6000, 0, 1, 1, 0, 0, 1, '2026-07-10 11:57:57', 1, '2026-07-10 11:57:57', 1),
	(401, 9, 6001, 0, 1, 1, 0, 0, 1, '2026-07-10 11:57:57', 1, '2026-07-10 11:57:57', 1),
	(402, 9, 6002, 0, 1, 1, 0, 0, 1, '2026-07-10 11:57:57', 1, '2026-07-10 11:57:57', 1),
	(403, 13, 2004, 0, 1, 1, 0, 0, 1, '2026-09-02 12:53:54', 1, '2026-09-02 12:53:54', 1);

-- Dumping structure for table thinktank-ticket.user_auth_level
CREATE TABLE IF NOT EXISTS `user_auth_level` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.user_auth_level: ~8 rows (approximately)
INSERT INTO `user_auth_level` (`id`, `name`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1, 'Administrator', 1, 1, '2026-06-10 15:53:03', 1, '2026-06-10 15:53:03', 1),
	(2, 'ThinkTank Admin', 1, 1, '2026-06-10 15:53:03', 1, '2026-06-10 15:53:03', 1),
	(9, 'Project Admin', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(10, 'Project Manager', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(11, 'Functional Consultant', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(12, 'Technical Consultant', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(13, 'Support', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(14, 'Client Team', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1);

-- Dumping structure for table thinktank-ticket.user_login_history
CREATE TABLE IF NOT EXISTS `user_login_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` varchar(50) NOT NULL DEFAULT '',
  `loginTime` datetime NOT NULL DEFAULT '2026-01-01 00:00:00' ON UPDATE current_timestamp(),
  `ipAddress` varchar(50) NOT NULL DEFAULT '',
  `userAgent` text NOT NULL,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` varchar(250) NOT NULL DEFAULT '',
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.user_login_history: ~54 rows (approximately)
INSERT INTO `user_login_history` (`id`, `userId`, `loginTime`, `ipAddress`, `userAgent`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(5, 'USR-ADMIN', '2026-07-15 12:39:36', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(6, 'USR-ADMIN', '2026-07-15 17:50:51', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(7, 'USR-ADMIN', '2026-07-16 11:37:15', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(8, 'USR-ADMIN', '2026-07-17 15:37:00', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(9, 'USR-ADMIN', '2026-07-21 16:14:05', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(10, 'USR-ADMIN', '2026-07-21 16:15:45', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(11, 'USR-ADMIN', '2026-07-21 17:13:51', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(12, 'USR-ADMIN', '2026-07-21 17:57:48', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(13, 'USR-ADMIN', '2026-07-22 14:09:09', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(14, 'USR-ADMIN', '2026-07-22 17:36:49', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(15, 'USR-ADMIN', '2026-07-23 12:55:46', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(16, 'USR-ADMIN', '2026-07-24 12:57:36', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(17, 'USR-ADMIN', '2026-07-30 12:51:06', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(18, 'USR-ADMIN', '2026-07-31 13:25:45', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(19, 'USR-ADMIN', '2026-08-04 14:14:48', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(20, 'USR-ADMIN', '2026-08-04 16:01:30', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(21, 'USR-ADMIN', '2026-08-04 16:25:48', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.131.0 Chrome/148.0.7778.280 Electron/42.7.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(22, 'USR-ADMIN', '2026-08-05 15:03:04', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(23, 'USR-ADMIN', '2026-08-05 18:26:12', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(24, 'USR-ADMIN', '2026-08-06 12:12:49', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(25, 'USR-ADMIN', '2026-08-07 14:04:44', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(26, 'USR-ADMIN', '2026-08-07 15:05:50', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(27, 'USR-ADMIN', '2026-08-10 11:34:33', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(28, 'USR-ADMIN', '2026-08-11 11:54:29', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(29, 'USR-ADMIN', '2026-08-11 15:13:05', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(30, 'DEMO1', '2026-08-13 12:43:38', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(31, 'DEMO1', '2026-08-13 12:44:18', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(32, 'DEMO1', '2026-08-13 12:45:24', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(33, 'USR-ADMIN', '2026-08-13 12:47:16', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(34, 'USR-ADMIN', '2026-08-14 14:21:01', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(35, 'USR-ADMIN', '2026-08-18 12:39:19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(36, 'USR-ADMIN', '2026-08-19 13:19:47', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(37, 'DEMO1', '2026-08-19 13:21:30', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(38, 'USR-ADMIN', '2026-08-20 12:32:10', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(39, 'USR-ADMIN', '2026-09-01 12:46:39', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(40, 'DEMO1', '2026-09-01 16:49:57', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(41, 'DEMO1', '2026-09-01 16:50:17', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(42, 'USR-ADMIN', '2026-09-01 17:01:02', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(43, 'USR-ADMIN', '2026-09-01 17:02:47', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(44, 'USR-ADMIN', '2026-09-01 17:04:30', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(45, 'USR-ADMIN', '2026-09-01 17:04:43', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(46, 'USR-ADMIN', '2026-09-01 17:06:08', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(47, 'USR-ADMIN', '2026-09-01 17:08:33', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(48, 'USR-ADMIN', '2026-09-01 17:10:09', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(49, 'USR-ADMIN', '2026-09-01 17:11:16', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(50, 'USR-ADMIN', '2026-09-01 17:12:11', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(51, 'USR-ADMIN', '2026-09-01 17:14:21', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(52, 'USR-ADMIN', '2026-09-01 17:14:54', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(53, 'USR-ADMIN', '2026-09-01 17:15:06', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(54, 'USR-E5A4B811', '2026-09-01 17:36:50', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(55, 'USR-ADMIN', '2026-09-01 17:43:07', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(56, 'USR-E5A4B811', '2026-09-01 17:54:49', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(57, 'USR-ADMIN', '2026-09-01 17:57:49', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(58, 'USR-E5A4B811', '2026-09-01 17:57:54', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(59, 'USR-ADMIN', '2026-09-02 12:52:53', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', ''),
	(60, 'USR-E5A4B811', '2026-09-02 12:54:11', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1, '2025-01-01 00:00:00', '', '2025-01-01 00:00:00', '');

-- Dumping structure for table thinktank-ticket.user_type
CREATE TABLE IF NOT EXISTS `user_type` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` varchar(250) NOT NULL DEFAULT '',
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.user_type: ~2 rows (approximately)
INSERT INTO `user_type` (`id`, `name`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1, 'Internal', 1, 1, '2025-01-01 00:00:00', '1', '2025-01-01 00:00:00', '1'),
	(2, 'External', 1, 1, '2025-01-01 00:00:00', '1', '2025-01-01 00:00:00', '1');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
