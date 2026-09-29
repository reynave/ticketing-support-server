CREATE TABLE `ticket_solution_time` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(250) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`duration` TINYINT(4) NOT NULL DEFAULT '0',
	`color` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
	`presence` TINYINT(2) NOT NULL DEFAULT '1',
	`inputDate` DATETIME NOT NULL DEFAULT '2025-01-01 00:00:00',
	`inputBy` SMALLINT(6) NOT NULL DEFAULT '1',
	`updateDate` DATETIME NOT NULL DEFAULT '2025-01-01 00:00:00',
	`updateBy` SMALLINT(6) NOT NULL DEFAULT '1',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
ROW_FORMAT=DYNAMIC
AUTO_INCREMENT=102
;

INSERT INTO `ticket_solution_time` VALUES (102, 'Simple', 2, 'success', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1);
INSERT INTO `ticket_solution_time` VALUES (103, 'Medium', 8, 'dark', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1);
INSERT INTO `ticket_solution_time` VALUES (104, 'Complex', 40, 'warning', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1);
INSERT INTO `ticket_solution_time` VALUES (105, 'High Complex', 32767, 'danger', 1, '2025-01-01 00:00:00', 1, '2025-01-01 00:00:00', 1);



INSERT INTO `thinktank-ticket`.`module` (`id`, `name`) VALUES (1009, 'Ticket Solution Time');


UPDATE `thinktank-ticket`.`module` SET `name`='Ticket Duration Respond' WHERE  `id`=1008;