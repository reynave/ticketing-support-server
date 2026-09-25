INSERT INTO `thinktank-ticket`.`module` (`id`, `name`) VALUES (1008, 'Ticket Severity');


ALTER TABLE `ticket`
	CHANGE COLUMN `targetCompletionDate` `targetCompletionDate` DATETIME NOT NULL AFTER `deadlineDateTime`,
	CHANGE COLUMN `actualCompletionDate` `actualCompletionDate` DATETIME NOT NULL AFTER `taskSolution`;
