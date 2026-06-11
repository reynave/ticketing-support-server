-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               10.4.28-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.18.0.7304
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
) ENGINE=InnoDB AUTO_INCREMENT=324 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table thinktank-ticket.auto_number: ~0 rows (approximately)

-- Dumping structure for table thinktank-ticket.client
CREATE TABLE IF NOT EXISTS `client` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(250) NOT NULL DEFAULT '',
  `address` varchar(250) NOT NULL DEFAULT '',
  `IndustryId` tinyint(4) NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=353 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.client: ~2 rows (approximately)
INSERT INTO `client` (`id`, `code`, `name`, `address`, `IndustryId`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(351, 'CLI-DEMO', 'Demo Client', 'Jakarta', 127, 1, 1, '2026-06-10 15:53:03', 1, '2026-06-10 15:53:03', 1),
	(352, 'CLI-TEMP-CRUD', 'Client Temp CRUD Updated', 'Bandung', 127, 0, 0, '2026-06-10 16:48:55', 1, '2026-06-10 16:48:55', 1);

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
	(1001, 'Man Day', '8', 'hour', '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1);

-- Dumping structure for table thinktank-ticket.industry
CREATE TABLE IF NOT EXISTS `industry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=355 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.industry: ~3 rows (approximately)
INSERT INTO `industry` (`id`, `name`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(351, 'Automative', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(352, 'FMCG', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(353, 'Dummy Industry CRUD Updated', 0, '2026-06-10 16:43:35', 1, '2026-06-10 16:43:35', 1),
	(354, 'Temp Industry UI Test Updated', 0, '2026-06-11 13:35:24', 1, '2026-06-11 13:35:24', 1);

-- Dumping structure for table thinktank-ticket.product
CREATE TABLE IF NOT EXISTS `product` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL DEFAULT '',
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.product: ~2 rows (approximately)
INSERT INTO `product` (`id`, `name`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1, 'Acumatica ERP', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(2, 'SAP B1', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(3, 'odoo', 1, 1, '2026-06-11 13:39:06', 1, '2026-06-11 13:39:06', 1);

-- Dumping structure for table thinktank-ticket.project
CREATE TABLE IF NOT EXISTS `project` (
  `id` varchar(100) NOT NULL DEFAULT '',
  `projectTypeId` smallint(6) NOT NULL DEFAULT 0,
  `projectBilleableId` smallint(6) NOT NULL DEFAULT 0,
  `projectCategoryId` smallint(6) NOT NULL DEFAULT 0,
  `productId` int(11) NOT NULL DEFAULT 0,
  `clientId` varchar(50) NOT NULL DEFAULT '0',
  `startDate` date NOT NULL DEFAULT '2025-01-01',
  `endDate` date NOT NULL DEFAULT '2025-01-01',
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `templateMaster` varchar(50) NOT NULL DEFAULT '0',
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.project: ~2 rows (approximately)
INSERT INTO `project` (`id`, `projectTypeId`, `projectBilleableId`, `projectCategoryId`, `productId`, `clientId`, `startDate`, `endDate`, `status`, `templateMaster`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	('PRJ-822BC171', 1, 1, 1, 1, '351', '2026-06-10', '2026-08-10', 1, 'TB-TEST', 0, '2026-06-10 16:58:11', 1, '2026-06-10 16:58:11', 1),
	('PRJ-CACC2C8D', 1, 1, 1, 1, '351', '2026-06-10', '2026-07-10', 0, 'TMP-UPDATED', 0, '2026-06-10 16:52:20', 1, '2026-06-10 16:52:20', 1);

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
	(1, 'Chrageable', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(2, 'Internal', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(3, 'NBD', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(4, 'Non Chargeable', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(5, 'BILL-TEMP-UPDATED', 1, 0, '2026-06-10 17:00:27', 1, '2026-06-10 17:00:27', 1);

-- Dumping structure for table thinktank-ticket.project_categories
CREATE TABLE IF NOT EXISTS `project_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.project_categories: ~7 rows (approximately)
INSERT INTO `project_categories` (`id`, `name`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1, 'Blueprint', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(2, 'Configuration', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(3, 'SIT & UAT', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(4, 'Training', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(5, 'Deployement', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(6, 'GO LIVE', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(7, 'CAT-TEMP', 1, 0, '2026-06-10 17:00:27', 1, '2026-06-10 17:00:27', 1);

-- Dumping structure for table thinktank-ticket.project_type
CREATE TABLE IF NOT EXISTS `project_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `ticketBased` tinyint(4) NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=358 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.project_type: ~7 rows (approximately)
INSERT INTO `project_type` (`id`, `name`, `ticketBased`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1, 'Software Implementation', 0, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(2, 'Software Support Ticket Based', 1, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(3, 'Software Support Fixed Cost', 0, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(4, 'Change Request', 0, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(355, 'TYPE-TEMP', 0, 1, 0, '2026-06-10 17:00:27', 1, '2026-06-10 17:00:27', 1),
	(356, 'TYPE-TEMP2', 0, 1, 0, '2026-06-10 17:01:03', 1, '2026-06-10 17:01:03', 1),
	(357, 'TYPE-TEMP2', 0, 1, 0, '2026-06-10 17:01:43', 1, '2026-06-10 17:01:43', 1);

-- Dumping structure for table thinktank-ticket.ticket_balance
CREATE TABLE IF NOT EXISTS `ticket_balance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectId` varchar(250) NOT NULL DEFAULT '',
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.ticket_balance: ~2 rows (approximately)
INSERT INTO `ticket_balance` (`id`, `projectId`, `date`, `ticketIn`, `ticketOut`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(4, 'PRJ-822BC171', '2026-06-10 16:58:11', 10, 0, 1, '2026-06-10 16:58:11', 1, '2026-06-10 16:58:11', 1),
	(5, 'PRJ-822BC171', '2026-06-10 16:58:11', 0, 3, 1, '2026-06-10 16:58:11', 1, '2026-06-10 16:58:11', 1);

-- Dumping structure for table thinktank-ticket.user
CREATE TABLE IF NOT EXISTS `user` (
  `id` varchar(250) NOT NULL DEFAULT '',
  `email` varchar(200) DEFAULT NULL,
  `clientId` int(11) NOT NULL DEFAULT 0,
  `userTypeId` tinyint(4) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  `authlevelId` smallint(6) DEFAULT NULL,
  `firstName` varchar(200) DEFAULT NULL,
  `lastName` varchar(200) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  `birthday` date NOT NULL DEFAULT '2000-01-01',
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `presence` tinyint(4) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` int(11) NOT NULL DEFAULT 0,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.user: ~3 rows (approximately)
INSERT INTO `user` (`id`, `email`, `clientId`, `userTypeId`, `password`, `authlevelId`, `firstName`, `lastName`, `phone`, `mobile`, `birthday`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	('USR-62199DD8', 'temp.user.crud@thinktank.local', 0, NULL, '$2b$04$ZC9rTZ16ZujoiD2rHXzgIOyfCUPXWl5LhWd4IyziFTXSz70.ob8QO', 2, 'Temp Updated', 'User', NULL, NULL, '2000-01-01', 0, 0, '2026-06-10 16:55:29', 1, '2026-06-10 16:55:29', 1),
	('USR-ADMIN', 'admin@thinktank.local', 0, NULL, '$2b$04$pBuL95VqIupLzvuvu399huQEYeuC5bJbEfAU.6uo58Xq3xVIs6BLS', 1, 'System', 'Admin', '021000000', '081200000001', '1990-01-01', 1, 1, '2026-06-10 15:53:03', 1, '2026-06-10 15:53:03', 1),
	('USR-CLIENT', 'client.demo@thinktank.local', 351, NULL, '$2b$04$vpl.W2psDhKPJt3CdgMOUOPqdxu6dG3ORdEMUCHl5Fo65ZMzeTD3S', 2, 'Client', 'Demo', '021111111', '081200000002', '1992-02-02', 1, 1, '2026-06-10 15:53:03', 1, '2026-06-10 15:53:03', 1);

-- Dumping structure for table thinktank-ticket.user_access_right
CREATE TABLE IF NOT EXISTS `user_access_right` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authLevelId` smallint(6) NOT NULL DEFAULT 0,
  `moduleId` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=351 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.user_access_right: ~0 rows (approximately)

-- Dumping structure for table thinktank-ticket.user_auth_level
CREATE TABLE IF NOT EXISTS `user_auth_level` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `c` tinyint(4) NOT NULL DEFAULT 0,
  `r` tinyint(4) NOT NULL DEFAULT 0,
  `u` tinyint(4) NOT NULL DEFAULT 0,
  `d` tinyint(4) NOT NULL DEFAULT 0,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.user_auth_level: ~2 rows (approximately)
INSERT INTO `user_auth_level` (`id`, `name`, `c`, `r`, `u`, `d`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1, 'Administrator', 1, 1, 1, 1, 1, '2026-06-10 15:53:03', 1, '2026-06-10 15:53:03', 1),
	(2, 'Client User', 1, 1, 0, 0, 1, '2026-06-10 15:53:03', 1, '2026-06-10 15:53:03', 1);

-- Dumping structure for table thinktank-ticket.user_type
CREATE TABLE IF NOT EXISTS `user_type` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` varchar(250) NOT NULL DEFAULT '',
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.user_type: ~2 rows (approximately)
INSERT INTO `user_type` (`id`, `name`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1, 'Internal', 1, '2025-01-01 00:00:00', '1', '2025-01-01 00:00:00', '1'),
	(2, 'External', 1, '2025-01-01 00:00:00', '1', '2025-01-01 00:00:00', '1');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
