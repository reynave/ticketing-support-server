-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               10.4.28-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.20.0.7320
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
	(326, 'task', 'TA', 6, 12, 'TA000012', '2026-07-08 16:41:04'),
	(327, 'issue', 'IS', 6, 8, 'IS000008', '2026-07-08 17:41:41'),
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
) ENGINE=InnoDB AUTO_INCREMENT=357 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.client: ~6 rows (approximately)
INSERT INTO `client` (`id`, `code`, `name`, `address`, `IndustryId`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(351, 'CLI-DEMO', 'PT XYZ Jp.co', 'Jakarta', 352, 1, 1, '2026-06-10 15:53:03', 1, '2026-06-17 17:12:34', 1),
	(352, 'CLI-TEMP-CRUD', 'Client Temp CRUD Updated', 'Bandung', 127, 0, 0, '2026-06-10 16:48:55', 1, '2026-06-10 16:48:55', 1),
	(353, 'CLI-AUTO-1781164821', 'Client Auto Updated 1781164821', 'Jakarta', 127, 0, 0, '2026-06-11 15:00:21', 1, '2026-06-11 15:00:21', 1),
	(354, 'CLI-VAL-1781164843', 'Client Val 1781164843', 'Bandung', 127, 0, 0, '2026-06-11 15:00:43', 1, '2026-06-11 15:00:44', 1),
	(355, 'CLI-VAL-1781164861', 'Client Val 1781164861', 'Bandung', 127, 0, 0, '2026-06-11 15:01:01', 1, '2026-06-11 15:01:01', 1),
	(356, 'test 123', 'Tentang Belfoods', '123tt ter', 351, 0, 0, '2026-06-11 15:36:48', 1, '2026-06-11 15:37:00', 1);

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
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=355 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.industry: ~4 rows (approximately)
INSERT INTO `industry` (`id`, `name`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(351, 'Automative', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(352, 'FMCG', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(353, 'Dummy Industry CRUD Updated', 0, '2026-06-10 16:43:35', 1, '2026-06-10 16:43:35', 1),
	(354, 'Temp Industry UI Test Updated', 0, '2026-06-11 13:35:24', 1, '2026-06-11 13:35:24', 1);

-- Dumping structure for table thinktank-ticket.module
CREATE TABLE IF NOT EXISTS `module` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6003 DEFAULT CHARSET=utf16 COLLATE=utf16_bin;

-- Dumping data for table thinktank-ticket.module: ~15 rows (approximately)
INSERT INTO `module` (`id`, `name`) VALUES
	(1001, 'Industri'),
	(1002, 'Product'),
	(1003, 'Project Type'),
	(1004, 'Project Bileable'),
	(1005, 'Ticket Categories'),
	(1006, 'User Auth Level'),
	(1007, 'Global Setting'),
	(2001, 'Project'),
	(2002, 'Clients'),
	(2003, 'Contacts'),
	(2004, 'Users'),
	(5005, 'Task'),
	(5006, 'Case'),
	(5007, 'Change Request'),
	(6000, 'Login'),
	(6001, 'Ticket Balance'),
	(6002, 'log activities');

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

-- Dumping data for table thinktank-ticket.product: ~1 rows (approximately)
INSERT INTO `product` (`id`, `name`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1, 'Acumatica ERP', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(2, 'SAP B1', 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(3, 'odoo', 1, 1, '2026-06-11 13:39:06', 1, '2026-06-11 13:39:06', 1);

-- Dumping structure for table thinktank-ticket.project
CREATE TABLE IF NOT EXISTS `project` (
  `id` varchar(100) NOT NULL DEFAULT '',
  `name` varchar(250) NOT NULL,
  `projectTypeId` smallint(6) NOT NULL DEFAULT 0,
  `projectBilleableId` smallint(6) NOT NULL DEFAULT 0,
  `productId` int(11) NOT NULL DEFAULT 0,
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

-- Dumping data for table thinktank-ticket.project: ~5 rows (approximately)
INSERT INTO `project` (`id`, `name`, `projectTypeId`, `projectBilleableId`, `productId`, `clientId`, `startDate`, `endDate`, `status`, `templateMaster`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	('PRJ-7492E30C', 'prject mbg123', 1, 1, 1, '', '2026-06-11', '2026-07-11', 0, '0', 1, '2026-06-17 17:23:19', '1', '2026-06-18 14:36:33', 'USR-ADMIN'),
	('PRJ-822BC171', 'test 1', 1, 1, 1, '351', '2026-06-10', '2026-08-10', 1, 'TB-TEST', 0, '2026-06-10 16:58:11', '1', '2026-06-10 16:58:11', '1'),
	('PRJ-B8887D5E', 'ASCO Akumatik', 1, 1, 1, '351', '2026-06-17', '2026-07-04', 1, '0', 1, '2026-06-17 17:12:04', '1', '2026-07-08 17:42:30', '1'),
	('PRJ-CACC2C8D', 'tes 3', 1, 1, 1, '351', '2026-06-10', '2026-07-10', 0, 'TMP-UPDATED', 0, '2026-06-10 16:52:20', '1', '2026-06-10 16:52:20', '1'),
	('PRJ-D83A04BE', 'INTERNAL PROJECT', 1, 1, 1, '351', '2026-06-17', '2026-09-30', 1, '0', 1, '2026-06-15 14:41:34', '1', '2026-07-08 17:42:49', '1'),
	('t3', 'Project Astra ERP', 1, 1, 1, '351', '2026-06-23', '2026-06-23', 1, '0', 1, '2026-06-23 16:05:47', '1', '2026-07-08 17:42:11', '1');

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
	(1, 'Software Implementation', 0, 1, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(2, 'Software Support Ticket Based', 1, 0, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(3, 'Software Support Fixed Cost', 0, 0, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(4, 'Change Request', 0, 1, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1);

-- Dumping structure for table thinktank-ticket.ticket
CREATE TABLE IF NOT EXISTS `ticket` (
  `id` varchar(50) NOT NULL DEFAULT '',
  `ticketTypeId` int(11) NOT NULL DEFAULT 0,
  `ticketCategoryId` int(11) NOT NULL,
  `ticketSeverityId` int(11) NOT NULL,
  `crNoRef` varchar(50) NOT NULL DEFAULT '',
  `issueNo` varchar(50) NOT NULL DEFAULT '',
  `title` varchar(250) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `projectId` varchar(50) NOT NULL DEFAULT '',
  `submitBy` varchar(50) NOT NULL DEFAULT '',
  `submitDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `targetCompletionDate` date NOT NULL,
  `assignTo` varchar(50) NOT NULL DEFAULT '0',
  `taskSolution` varchar(50) NOT NULL DEFAULT '',
  `actualCompletionDate` date NOT NULL,
  `ticketStatusId` int(11) NOT NULL DEFAULT 0,
  `rating` tinyint(4) NOT NULL,
  `ratesBy` varchar(50) NOT NULL DEFAULT '',
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` varchar(50) NOT NULL DEFAULT 'mysql',
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` varchar(50) NOT NULL DEFAULT 'mysql',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.ticket: ~20 rows (approximately)
INSERT INTO `ticket` (`id`, `ticketTypeId`, `ticketCategoryId`, `ticketSeverityId`, `crNoRef`, `issueNo`, `title`, `description`, `projectId`, `submitBy`, `submitDate`, `targetCompletionDate`, `assignTo`, `taskSolution`, `actualCompletionDate`, `ticketStatusId`, `rating`, `ratesBy`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	('a1', 1, 0, 0, '', '', 'Title 123', '<p>123</p>', 'PRJ-D83A04BE', 'data.submitBy', '2026-06-23 00:00:00', '2026-06-23', 'USR-ADMIN', '<p>1232343453453</p>', '2026-06-23', 990, 2, 'USR-ADMIN', 1, '2026-06-23 17:43:41', '1', '2026-06-25 17:38:58', 'data.submitBy'),
	('a2', 1, 0, 0, '', '', '1', 'Description  123', 'PRJ-D83A04BE', 'data.submitBy', '2026-06-23 00:00:00', '2026-06-23', 'USR-ADMIN', '', '2026-06-23', 100, 0, '', 0, '2026-06-23 17:46:21', '1', '2026-06-25 16:10:54', '1'),
	('B1', 1, 0, 0, '', '', 'B11', '<p>ok go</p>', 'PRJ-D83A04BE', 'USR-ADMIN', '2026-06-25 00:00:00', '2026-06-25', 'USR-ADMIN', '', '2026-06-25', 105, 0, '', 0, '2026-06-25 11:58:40', '1', '2026-06-25 16:10:50', '1'),
	('C22', 1, 2, 0, '', '', 'C22', '<p></p>', 't3', 'USR-ADMIN', '2026-06-25 00:00:00', '2026-06-25', 'USR-ADMIN', '<p>asdfasdf 123123 123 123</p>', '2026-06-25', 900, 4, 'USR-ADMIN', 1, '2026-06-25 12:09:47', '1', '2026-06-25 17:04:32', 'USR-ADMIN'),
	('C223', 2, 1, 0, '', '', 'CASE', '<p>B</p>', 't3', 'USR-ADMIN', '2026-07-08 00:00:00', '2026-07-08', '1', '', '2026-07-08', 100, 0, '', 0, '2026-07-08 14:33:02', '1', '2026-07-08 16:10:26', '1'),
	('IS000001', 2, 0, 0, '', '', 'CASE1', 'test 123', 'PRJ-B8887D5E', 'USR-ADMIN', '2026-07-08 00:00:00', '2026-07-08', '1', '', '2026-07-08', 1, 0, '', 0, '2026-07-08 14:27:18', '1', '2026-07-08 15:52:47', '1'),
	('IS000002', 2, 2, 30, '', '', 'system down', '<p>system down</p>', 'PRJ-B8887D5E', 'USR-ADMIN', '2026-07-08 00:00:00', '2026-07-08', 'USR-8C76A791', '', '2026-07-08', 1, 0, '', 1, '2026-07-08 15:32:54', '1', '2026-07-08 17:22:18', 'USR-ADMIN'),
	('IS000004', 2, 5, 20, '', '', 'Description  system down', '<p>Description system down</p>', 'PRJ-D83A04BE', 'USR-ADMIN', '2026-07-08 00:00:00', '2026-07-08', 'USR-8C76A791', '<p>123</p>', '2026-07-08', 900, 2, 'USR-ADMIN', 1, '2026-07-08 15:40:01', '1', '2026-07-08 17:17:17', 'USR-ADMIN'),
	('IS000005', 2, 5, 30, '', '', 'error bugs', 'error bugs', 'PRJ-B8887D5E', 'USR-ADMIN', '2026-07-08 00:00:00', '2026-07-08', 'USR-8C76A791', '', '2026-07-08', 1, 0, '', 1, '2026-07-08 17:35:42', '1', '2026-07-08 17:35:42', '1'),
	('IS000006', 2, 2, 10, '', '', 'bac', 'abc', 't3', 'USR-ADMIN', '2026-07-08 00:00:00', '2026-07-08', 'USR-ADMIN', '', '2026-07-08', 1, 0, '', 1, '2026-07-08 17:39:06', '1', '2026-07-08 17:39:06', '1'),
	('IS000007', 2, 1, 20, '', '', 'hhh', 'hhhhhh', 't3', 'USR-ADMIN', '2026-07-08 00:00:00', '2026-07-08', 'USR-8C76A791', '', '2026-07-08', 1, 0, '', 1, '2026-07-08 17:39:56', '1', '2026-07-08 17:39:56', '1'),
	('IS000008', 2, 6, 10, '', '', 'A1', 'A1', 'PRJ-B8887D5E', 'USR-ADMIN', '2026-07-08 17:41:41', '2026-07-08', 'USR-8C76A791', '', '2026-07-08', 1, 0, '', 1, '2026-07-08 17:41:41', '1', '2026-07-08 17:41:41', '1'),
	('TA000010', 1, 1, 0, '', '', 'hahah', 'Description', 't3', 'USR-ADMIN', '2026-07-08 00:00:00', '2026-07-08', 'USR-8C76A791', '', '2026-07-08', 1, 0, '', 1, '2026-07-08 15:54:40', '1', '2026-07-08 15:54:40', '1'),
	('TA000012', 1, 1, 0, '', 'IS000004', 'Task of IS000004', '<p>Follow up from case IS000004</p>', 'PRJ-D83A04BE', '0', '2026-07-08 00:00:00', '2026-07-15', '0', '', '2026-07-15', 900, 6, 'USR-ADMIN', 1, '2026-07-08 16:41:04', '0', '2026-07-08 17:16:54', 'USR-ADMIN'),
	('TS000002', 1, 0, 0, '', '2', 'project iseu ASP.net new project', '<h1>Hello</h1><p>This is editable text. <span style="color: rgb(217, 63, 11);">You can focus it and start typing</span>.</p><p><code>code block</code></p><blockquote><p><strong>Lorem Ipsum</strong>&nbsp;is <span style="background-color: rgb(251, 202, 4);">simply dummy</span> text of the printing and typesetting industry. <em>Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s</em>, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</p></blockquote><h2>The code block is a code editor</h2><p>This editor has been wired up to render code blocks as instances of the <a href="https://codemirror.net" title="https://codemirror.net" target="_blank">CodeMirror</a> code editor, which provides <a href="https://en.wikipedia.org" title="" target="_blank">syntax highlighting</a>, auto-indentation, and similar.</p><pre><code>function max(a, b) {\n  return a &gt; b ? a : b\n}</code></pre><p>The content of the code editor is kept in sync with the content of the code block in the rich text editor, so that it is as if you\'re directly editing the outer document, using a more convenient interface.</p><h4 style="text-align: center;">Mr. Bean</h4><p style="text-align: center;">The image is resizable. Include <strong>image</strong> plugin to enable image resizing</p><h3 style="text-align: center;"><img src="https://wallpapercave.com/wp/wp2318909.png" alt="Bean" title="Mr. Bean" width="98px"></h3><h3>Bullet list</h3><ul><li><p><strong>Lorem Ipsum</strong>&nbsp;is simply dummy text of the printing and typesetting industry</p><ul><li><p>(<strong>depth 1</strong>) It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.</p><ul><li><p>(<strong>depth 2</strong>) The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested.</p></li></ul></li></ul></li><li><p>There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable</p></li><li><p>Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.</p></li></ul><h4>Ordered List</h4><ol><li><p><strong>Lorem Ipsum</strong>&nbsp;is simply dummy text of the printing and typesetting industry</p></li><li><p>There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable</p><ol><li><p>(<strong>depth 1</strong>) It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.</p><ol><li><p>(<strong>depth 2</strong>) The chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested.</p></li></ol></li></ol></li><li><p>Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.</p></li></ol>', 'PRJ-D83A04BE', 'USR-8C76A791', '2026-06-15 00:00:00', '2026-05-20', 'USR-ADMIN', '<p>12<strong>31231234</strong></p>', '2026-05-20', 900, 3, 'USR-8C76A791', 1, '2026-06-15 16:59:27', '1', '2026-06-25 17:29:39', 'USR-8C76A791'),
	('TS000003', 1, 0, 0, '', 'Issue No', 'error 191', '<p>213</p>', 'PRJ-D83A04BE', 'USR-8C76A791', '2026-06-17 00:00:00', '2026-06-05', 'USR-ADMIN', '<p>ok good</p>', '2026-06-29', 900, 5, 'USR-ADMIN', 1, '2026-06-17 15:50:29', '1', '2026-07-08 16:50:34', 'USR-ADMIN'),
	('TS000006', 1, 0, 0, '', '', '123123', '<p>123</p>', 'PRJ-B8887D5E', 'data.submitBy', '2026-06-23 00:00:00', '2026-06-23', 'USR-ADMIN', '', '2026-06-23', 900, 0, 'data.submitBy', 1, '2026-06-23 17:41:50', '1', '2026-06-25 17:05:37', 'data.submitBy'),
	('TS000007', 1, 0, 0, '', '', '123123', '<p>123123123</p>', 't3', 'data.submitBy', '2026-06-23 00:00:00', '2026-06-23', 'USR-ADMIN', '<p>123213</p>', '2026-06-23', 900, 2, 'USR-ADMIN', 1, '2026-06-23 17:42:12', '1', '2026-06-25 17:22:17', 'data.submitBy'),
	('TS000008', 1, 0, 0, 'C2', '32', 'To set the width of an HTML table data cell', '<h2>The code block is a code editor</h2><p>This editor has been wired up to render code blocks as instances of the <a href="https://codemirror.net" title="https://codemirror.net" target="_blank">CodeMirror</a> code editor, which provides <a href="https://en.wikipedia.org" title="" target="_blank">syntax highlighting</a>, auto-indentation, and similar.</p><pre><code>function max(a, b) {\n  return a &gt; b ? a : b\n}</code></pre>', 't3', 'USR-ADMIN', '2026-06-23 00:00:00', '2026-06-23', 'USR-ADMIN', '<p>123</p>', '2026-06-23', 900, 2, 'USR-ADMIN', 1, '2026-06-23 17:53:24', '1', '2026-06-25 18:20:22', 'USR-ADMIN'),
	('TS000009', 1, 1, 0, '', '', 'te12', 'asdf', 't3', 'USR-ADMIN', '2026-07-08 00:00:00', '2026-07-08', 'USR-ADMIN', '', '2026-07-08', 1, 0, '', 0, '2026-07-08 15:42:03', '1', '2026-07-08 15:52:24', '1');

-- Dumping structure for table thinktank-ticket.ticket_balance
CREATE TABLE IF NOT EXISTS `ticket_balance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectId` varchar(250) NOT NULL DEFAULT '',
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.ticket_balance: ~2 rows (approximately)
INSERT INTO `ticket_balance` (`id`, `projectId`, `ticketId`, `date`, `ticketIn`, `ticketOut`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(4, 'PRJ-822BC171', '', '2026-06-10 16:58:11', 10, 0, 1, '2026-06-10 16:58:11', 1, '2026-06-10 16:58:11', 1),
	(5, 'PRJ-822BC171', '', '2026-06-10 16:58:11', 0, 3, 1, '2026-06-10 16:58:11', 1, '2026-06-10 16:58:11', 1);

-- Dumping structure for table thinktank-ticket.ticket_categories
CREATE TABLE IF NOT EXISTS `ticket_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  `weight` tinyint(4) NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.ticket_categories: ~7 rows (approximately)
INSERT INTO `ticket_categories` (`id`, `name`, `weight`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1, 'Blueprint', 0, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(2, 'Configuration', 0, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(3, 'SIT & UAT', 0, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(4, 'Training', 0, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(5, 'Deployement', 0, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(6, 'GO LIVE', 0, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(7, 'CAT-TEMP', 0, 1, 0, '2026-06-10 17:00:27', 1, '2026-06-10 17:00:27', 1);

-- Dumping structure for table thinktank-ticket.ticket_logs
CREATE TABLE IF NOT EXISTS `ticket_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentId` int(11) NOT NULL DEFAULT 0,
  `ticketId` varchar(50) NOT NULL DEFAULT '',
  `description` text NOT NULL DEFAULT '',
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputBySystem` tinyint(2) NOT NULL DEFAULT 0,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` varchar(50) NOT NULL DEFAULT '',
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.ticket_logs: ~41 rows (approximately)
INSERT INTO `ticket_logs` (`id`, `parentId`, `ticketId`, `description`, `presence`, `inputBySystem`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(8, 0, 'TS000002', '1231231 23 123', 1, 0, '2026-06-17 14:51:46', '1', '2026-06-17 14:51:46', '1'),
	(9, 0, 'TS000002', '1231231 23 123', 1, 0, '2026-06-17 14:51:53', '1', '2026-06-17 14:51:53', '1'),
	(10, 0, 'TS000002', '1231231 23 123', 1, 0, '2026-06-17 14:51:54', '1', '2026-06-17 14:51:54', '1'),
	(11, 0, 'TS000002', '1231231 23 123', 1, 0, '2026-06-17 14:52:50', 'USR-8C76A791', '2026-06-17 14:52:50', 'USR-8C76A791'),
	(12, 0, 'TS000002', '123123', 1, 0, '2026-06-17 14:53:43', 'USR-8C76A791', '2026-06-17 14:53:43', 'USR-8C76A791'),
	(13, 0, 'TS000002', '123123', 1, 0, '2026-06-17 15:01:49', 'USR-8C76A791', '2026-06-17 15:01:49', 'USR-8C76A791'),
	(14, 0, 'TS000002', 'asdfasdfadf', 1, 0, '2026-06-17 15:02:02', 'USR-8C76A791', '2026-06-17 15:02:02', 'USR-8C76A791'),
	(15, 0, 'TS000003', 'Add Activity 123123 Add Activity', 1, 0, '2026-06-17 15:53:23', '1', '2026-06-17 15:53:23', '1'),
	(16, 0, 'TS000003', 'A reference to the currently opened (active) modal.\n\nInstances of this class can be injected into your component passed as modal content. So you can .update(), .close() or .dismiss() the modal window from your component.\nMethods', 1, 0, '2026-06-17 15:53:43', '1', '2026-06-17 15:53:43', '1'),
	(17, 0, 'TS000003', 'desc baru 123', 1, 0, '2026-06-17 15:57:49', '1', '2026-06-17 15:57:49', '1'),
	(18, 0, 'TS000003', 'halo halo', 1, 0, '2026-06-22 15:17:04', '1', '2026-06-22 15:17:04', '1'),
	(19, 0, 'TS000008', 'test 123', 1, 0, '2026-06-24 14:50:49', 'USR-ADMIN', '2026-06-24 14:50:49', 'USR-ADMIN'),
	(20, 0, 'TS000008', '13123', 1, 0, '2026-06-24 14:51:32', 'USR-ADMIN', '2026-06-24 14:51:32', 'USR-ADMIN'),
	(23, 0, 'TS000008', '<p>Integrating <strong>ngx-editor</strong> inside a modal requires managing the <code>Editor</code> instance lifecycle properly. Failing to initialize and destroy the editor instance when opening and closing the modal can cause rendering crashes or memory leaks.</p><p>Here is how to set up <strong>ngx-editor</strong> inside an Angular modal (like <code>@angular/material/dialog</code> or <code>ngx-bootstrap/modal</code>):</p>', 1, 0, '2026-06-24 14:58:57', 'USR-ADMIN', '2026-06-24 14:58:57', 'USR-ADMIN'),
	(24, 14, 'TS000002', '<p>123123</p>', 1, 0, '2026-06-24 16:10:04', 'USR-8C76A791', '2026-06-24 16:10:04', 'USR-8C76A791'),
	(25, 12, 'TS000002', '<p><span style="color: rgb(33, 37, 41);">The content of the code editor is kept in sync with the content of the code block in the rich text editor, so that it is as if you\'re directly editing the outer document, using a more convenient interface.</span></p><h4 style="text-align: start;"><strong><span style="color: rgb(33, 37, 41);">Mr. Bean</span></strong></h4><p style="text-align: start;"><span style="color: rgb(33, 37, 41);">The image is resizable. Include </span><strong><span style="color: rgb(33, 37, 41);">image</span></strong><span style="color: rgb(33, 37, 41);"> plugin to enable image resizing</span></p><p><br></p>', 1, 0, '2026-06-24 16:11:32', 'USR-8C76A791', '2026-06-24 16:11:32', 'USR-8C76A791'),
	(26, 25, 'TS000002', '<p>tav</p>', 1, 0, '2026-06-24 16:18:17', 'USR-8C76A791', '2026-06-24 16:18:17', 'USR-8C76A791'),
	(27, 0, 'C22', '<p>123123123 12 3123</p>', 1, 0, '2026-06-25 13:16:52', 'USR-ADMIN', '2026-06-25 13:16:52', 'USR-ADMIN'),
	(28, 0, 'C22', '<p>asdfasdf</p>', 1, 0, '2026-06-25 13:17:03', 'USR-ADMIN', '2026-06-25 13:17:03', 'USR-ADMIN'),
	(29, 28, 'C22', '<p>123123213</p>', 1, 0, '2026-06-25 13:17:08', 'USR-ADMIN', '2026-06-25 13:17:08', 'USR-ADMIN'),
	(30, 0, 'C22', '<p>143424</p>', 1, 0, '2026-06-25 13:37:48', 'USR-ADMIN', '2026-06-25 13:37:48', 'USR-ADMIN'),
	(31, 0, 'C22', '<p>test upload</p>', 1, 0, '2026-06-25 14:22:01', 'USR-ADMIN', '2026-06-25 14:22:01', 'USR-ADMIN'),
	(33, 0, 'C22', '<p>tes123 123</p>', 1, 0, '2026-06-25 14:40:57', 'USR-ADMIN', '2026-06-25 14:40:57', 'USR-ADMIN'),
	(34, 0, 'C22', '<p>123123</p>', 1, 0, '2026-06-25 15:05:33', 'USR-ADMIN', '2026-06-25 15:05:33', 'USR-ADMIN'),
	(35, 0, 'C22', 'Update from 1 2 ', 1, 0, '2026-06-25 15:58:09', 'USR-ADMIN', '2026-06-25 15:58:09', 'USR-ADMIN'),
	(36, 0, 'B1', 'Update Status from Open To  Client - Completed', 1, 0, '2026-06-25 16:08:57', 'USR-ADMIN', '2026-06-25 16:08:57', 'USR-ADMIN'),
	(37, 0, 'B1', 'Update Status from <strong>Client - Completed</strong> To  <strong>Open - On Review</strong>', 1, 0, '2026-06-25 16:10:06', 'USR-ADMIN', '2026-06-25 16:10:06', 'USR-ADMIN'),
	(38, 0, 'C22', 'Update Status from <strong>Open - On Review</strong> To  <strong>Complete - Review</strong>', 1, 0, '2026-06-25 16:25:39', 'USR-ADMIN', '2026-06-25 16:25:39', 'USR-ADMIN'),
	(39, 0, 'C22', 'Update Status from <strong>Complete - Review</strong> To  <strong>Closed</strong>', 1, 0, '2026-06-25 16:25:49', 'USR-ADMIN', '2026-06-25 16:25:49', 'USR-ADMIN'),
	(40, 0, 'TS000006', 'Update Status from <strong>Open</strong> To  <strong>Closed</strong>', 1, 0, '2026-06-25 17:05:37', 'data.submitBy', '2026-06-25 17:05:37', 'data.submitBy'),
	(41, 0, 'TS000002', 'Update Status from <strong>Open - Assigned</strong> To  <strong>Closed</strong>', 1, 0, '2026-06-25 17:06:47', 'USR-8C76A791', '2026-06-25 17:06:47', 'USR-8C76A791'),
	(42, 0, 'TS000007', 'Update Status from <strong>Open</strong> To  <strong>Closed</strong>', 1, 0, '2026-06-25 17:07:39', 'data.submitBy', '2026-06-25 17:07:39', 'data.submitBy'),
	(43, 0, 'a1', 'Update Status from <strong>Open</strong> To  <strong>Cancelled</strong>', 1, 0, '2026-06-25 17:37:26', 'data.submitBy', '2026-06-25 17:37:26', 'data.submitBy'),
	(44, 0, 'TS000003', 'Update Status from <strong>Open</strong> To  <strong>Open - Submit</strong>', 1, 0, '2026-06-25 17:57:18', '', '2026-06-25 17:57:18', ''),
	(45, 0, 'TS000008', 'Update Status from <strong>Open</strong> To  <strong>Closed</strong>', 1, 0, '2026-06-25 18:20:18', 'USR-ADMIN', '2026-06-25 18:20:18', 'USR-ADMIN'),
	(46, 0, 'C223', 'Update Status from <strong>Draft</strong> To  <strong>Open</strong>', 1, 0, '2026-07-08 14:36:57', 'USR-ADMIN', '2026-07-08 14:36:57', 'USR-ADMIN'),
	(47, 0, 'TS000003', 'Update Status from <strong>Open - Submit</strong> To  <strong>Closed</strong>', 1, 0, '2026-07-08 15:36:26', 'USR-8C76A791', '2026-07-08 15:36:26', 'USR-8C76A791'),
	(48, 0, 'IS000002', '', 1, 0, '2026-07-08 16:18:23', 'USR-ADMIN', '2026-07-08 16:18:23', 'USR-ADMIN'),
	(49, 0, 'IS000004', 'Update Status from <strong>Draft</strong> To  <strong>Open</strong>', 1, 0, '2026-07-08 17:14:48', 'USR-ADMIN', '2026-07-08 17:14:48', 'USR-ADMIN'),
	(50, 0, 'TA000012', 'Update Status from <strong>Open</strong> To  <strong>Closed</strong>', 1, 0, '2026-07-08 17:16:49', '0', '2026-07-08 17:16:49', '0'),
	(51, 0, 'IS000004', 'Update Status from <strong>Open</strong> To  <strong>Closed</strong>', 1, 0, '2026-07-08 17:17:12', 'USR-ADMIN', '2026-07-08 17:17:12', 'USR-ADMIN');

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf16 COLLATE=utf16_bin;

-- Dumping data for table thinktank-ticket.ticket_logs_attachments: ~4 rows (approximately)
INSERT INTO `ticket_logs_attachments` (`id`, `ticketId`, `ticketLogId`, `originalName`, `filename`, `mimetype`, `size`, `url`, `inputDate`, `inputBy`) VALUES
	(1, 'C22', 33, '9f602d89e09afc00586c4531712d98c0.jpg', '1782373257961-575028619.jpg', 'image/jpeg', 78999, 'http://localhost:3000/uploads/1782373257961-575028619.jpg', '2026-06-25 14:40:57', 'USR-ADMIN'),
	(2, 'C22', 34, 'af9ba7cec186ceed2959188052710d88.jpg', '1782374733014-180734174.jpg', 'image/jpeg', 75719, 'http://localhost:3000/uploads/1782374733014-180734174.jpg', '2026-06-25 15:05:33', 'USR-ADMIN'),
	(3, 'IS000002', 48, '9f602d89e09afc00586c4531712d98c0.jpg', '1783502303457-217871611.jpg', 'image/jpeg', 78999, 'http://localhost:3000/uploads/1783502303457-217871611.jpg', '2026-07-08 16:18:23', 'USR-ADMIN'),
	(4, 'IS000002', 48, 'ball joint shf.jpg', '1783502303458-110124108.jpg', 'image/jpeg', 56188, 'http://localhost:3000/uploads/1783502303458-110124108.jpg', '2026-07-08 16:18:23', 'USR-ADMIN');

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
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

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

-- Dumping data for table thinktank-ticket.ticket_status: ~9 rows (approximately)
INSERT INTO `ticket_status` (`id`, `name`, `task`, `issues`, `cr`, `finish`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1, 'Draft', 0, 0, 0, 0, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(100, 'Open', 1, 1, 0, 0, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(101, 'Open - Assigned', 1, 1, 0, 0, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(105, 'Open - On Review', 1, 1, 0, 0, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(106, 'Open - Submit', 1, 1, 0, 0, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(300, 'Complete - Review', 1, 1, 0, 0, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(400, 'Client - Review', 0, 1, 0, 0, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(490, 'Client - Completed', 0, 1, 0, 0, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(900, 'Closed', 1, 1, 0, 1, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(990, 'Cancelled', 1, 1, 0, 4, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1);

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
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `presence` tinyint(4) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` int(11) NOT NULL DEFAULT 0,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.user: ~8 rows (approximately)
INSERT INTO `user` (`id`, `email`, `clientId`, `userTypeId`, `password`, `userAuthLevelId`, `firstName`, `lastName`, `phone`, `mobile`, `birthday`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	('USR-12788040', 'delete.1781164844006836299.int.1781164843@thinktank.local', 0, 1, '$2b$04$JBxug4U1FQOL/67qnHFCp.wmLdntsXE3PjjeSDvou2qoWNtLdh87K', 1, 'Internal', 'Tester', NULL, NULL, '2000-01-01', 0, 0, '2026-06-11 15:00:43', 1, '2026-06-11 15:00:44', 1),
	('USR-405F00F4', 'delete.1781164861883547748.int.1781164861@thinktank.local', 0, 1, '$2b$04$AOsIwcrlShK0kLi/mArz2ei57DRvpGh/z3zKvLCn8rUmcBCZiEY.O', 1, 'Internal', 'Tester', NULL, NULL, '2000-01-01', 0, 0, '2026-06-11 15:01:01', 1, '2026-06-11 15:01:01', 1),
	('USR-62199DD8', 'temp.user.crud@thinktank.local', 0, 1, '$2b$04$ZC9rTZ16ZujoiD2rHXzgIOyfCUPXWl5LhWd4IyziFTXSz70.ob8QO', 2, 'Temp Updated', 'User', NULL, NULL, '2000-01-01', 0, 0, '2026-06-10 16:55:29', 1, '2026-06-10 16:55:29', 1),
	('USR-6CBBCE3A', 'delete.1781164821451874774.ext.1781164821.1@thinktank.local', 353, 2, '$2b$04$BflCbR5izWKIr3mQhY70QeCsDWAd6jzamlJtABhDTrlP3TobcrEdi', 2, 'ExternalUpdated', 'One', NULL, '081200009999', '2000-01-01', 0, 0, '2026-06-11 15:00:21', 1, '2026-06-11 15:00:21', 1),
	('USR-8C76A791', 'cso12333@email.com', 0, 1, '$2b$04$gGfp6qMsTh4bWBYh6Dmla.2wSQT0uXP2ojguZEz4f3YgMBAMEIDNS', 2, 'baba', 'cdcd', NULL, NULL, '2000-01-01', 1, 1, '2026-06-11 15:58:19', 1, '2026-06-15 13:08:26', 1),
	('USR-9B8746FD', 'delete.1781164821484390428.ext.1781164821.2@thinktank.local', 353, 2, '$2b$04$HtnLpRDw4ChNT73Uh26.s.GaDhDAKk2sWx03N2a2r6LDHYIhoT94O', 2, 'External', 'Two', NULL, NULL, '2000-01-01', 0, 0, '2026-06-11 15:00:21', 1, '2026-06-11 15:00:21', 1),
	('USR-ADMIN', 'admin@thinktank.local', 0, 1, '$2b$04$pBuL95VqIupLzvuvu399huQEYeuC5bJbEfAU.6uo58Xq3xVIs6BLS', 1, 'System', 'Admin', '021000000', '081200000001', '1990-01-01', 1, 1, '2026-06-10 15:53:03', 1, '2026-06-10 15:53:03', 1),
	('USR-CLIENT', 'client.demo@thinktank.local', 351, 2, '$2b$04$vpl.W2psDhKPJt3CdgMOUOPqdxu6dG3ORdEMUCHl5Fo65ZMzeTD3S', 2, 'Client', 'Demo', '021111111', '081200000002', '1992-02-02', 1, 1, '2026-06-10 15:53:03', 1, '2026-06-10 15:53:03', 1);

-- Dumping structure for table thinktank-ticket.user_access_right
CREATE TABLE IF NOT EXISTS `user_access_right` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authLevelId` smallint(6) NOT NULL DEFAULT 0,
  `moduleId` int(11) NOT NULL DEFAULT 0,
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
) ENGINE=InnoDB AUTO_INCREMENT=386 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.user_access_right: ~35 rows (approximately)
INSERT INTO `user_access_right` (`id`, `authLevelId`, `moduleId`, `c`, `r`, `u`, `d`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(351, 1, 0, 0, 0, 0, 0, 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(352, 1, 1001, 1, 1, 1, 1, 1, '2026-07-08 13:49:46', 1, '2026-07-08 14:02:18', 1),
	(353, 1, 1002, 1, 1, 1, 1, 1, '2026-07-08 13:49:46', 1, '2026-07-08 14:02:18', 1),
	(354, 1, 1003, 1, 1, 1, 1, 1, '2026-07-08 13:49:46', 1, '2026-07-08 14:02:18', 1),
	(355, 1, 1004, 1, 1, 1, 1, 1, '2026-07-08 14:02:18', 1, '2026-07-08 14:02:18', 1),
	(356, 1, 1005, 1, 1, 1, 1, 1, '2026-07-08 14:02:18', 1, '2026-07-08 14:02:18', 1),
	(357, 1, 1006, 1, 1, 1, 1, 1, '2026-07-08 14:02:18', 1, '2026-07-08 14:02:18', 1),
	(358, 1, 1007, 1, 1, 1, 1, 1, '2026-07-08 14:02:18', 1, '2026-07-08 14:02:18', 1),
	(359, 1, 2001, 1, 1, 1, 1, 1, '2026-07-08 14:02:18', 1, '2026-07-08 14:02:18', 1),
	(360, 1, 2002, 1, 1, 1, 1, 1, '2026-07-08 14:02:18', 1, '2026-07-08 14:02:18', 1),
	(361, 1, 2003, 1, 1, 1, 1, 1, '2026-07-08 14:02:18', 1, '2026-07-08 14:02:18', 1),
	(362, 1, 2004, 1, 1, 1, 1, 1, '2026-07-08 14:02:18', 1, '2026-07-08 14:02:18', 1),
	(363, 1, 5005, 1, 1, 1, 1, 1, '2026-07-08 14:02:18', 1, '2026-07-08 14:02:18', 1),
	(364, 1, 5006, 1, 1, 1, 1, 1, '2026-07-08 14:02:18', 1, '2026-07-08 14:02:18', 1),
	(365, 1, 5007, 1, 1, 1, 1, 1, '2026-07-08 14:02:18', 1, '2026-07-08 14:02:18', 1),
	(366, 1, 6000, 1, 1, 1, 1, 1, '2026-07-08 14:02:19', 1, '2026-07-08 14:02:19', 1),
	(367, 1, 6001, 1, 1, 1, 1, 1, '2026-07-08 14:02:19', 1, '2026-07-08 14:02:19', 1),
	(368, 1, 6002, 1, 1, 1, 1, 1, '2026-07-08 14:02:19', 1, '2026-07-08 14:02:19', 1),
	(369, 2, 1001, 1, 1, 1, 1, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(370, 2, 1002, 1, 1, 1, 1, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(371, 2, 1003, 1, 1, 1, 1, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(372, 2, 1004, 1, 1, 1, 1, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(373, 2, 1005, 1, 1, 1, 1, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(374, 2, 1006, 1, 1, 1, 1, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(375, 2, 1007, 1, 1, 1, 1, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(376, 2, 2001, 1, 1, 1, 1, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(377, 2, 2002, 1, 1, 1, 1, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(378, 2, 2003, 1, 1, 1, 1, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(379, 2, 2004, 1, 1, 1, 1, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(380, 2, 5005, 1, 1, 1, 1, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(381, 2, 5006, 1, 1, 1, 1, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(382, 2, 5007, 1, 1, 1, 1, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(383, 2, 6000, 1, 1, 1, 1, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(384, 2, 6001, 1, 1, 1, 1, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1),
	(385, 2, 6002, 1, 1, 1, 1, 1, '2026-07-08 14:02:30', 1, '2026-07-08 14:02:30', 1);

-- Dumping structure for table thinktank-ticket.user_auth_level
CREATE TABLE IF NOT EXISTS `user_auth_level` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `presence` tinyint(2) NOT NULL DEFAULT 1,
  `inputDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `inputBy` smallint(6) NOT NULL DEFAULT 1,
  `updateDate` datetime NOT NULL DEFAULT '2025-01-01 00:00:00',
  `updateBy` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table thinktank-ticket.user_auth_level: ~8 rows (approximately)
INSERT INTO `user_auth_level` (`id`, `name`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1, 'Administrator', 1, '2026-06-10 15:53:03', 1, '2026-06-10 15:53:03', 1),
	(2, 'ThinkTank Admin', 1, '2026-06-10 15:53:03', 1, '2026-06-10 15:53:03', 1),
	(9, 'Project Admin', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(10, 'Project Manager', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(11, 'Functional Consultant', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(12, 'Technical Consultant', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(13, 'Support', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1),
	(14, 'Client Team', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1);

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
