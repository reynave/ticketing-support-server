 ALTER TABLE `ticket`
	ADD COLUMN `responseDateTime` DATETIME NOT NULL AFTER `description`,
	ADD COLUMN `targetCompletationDateTime` DATETIME NOT NULL AFTER `responseDateTime`;
ALTER TABLE `ticket`
	ADD COLUMN `responseDateTime` DATETIME NOT NULL DEFAULT '2026-01-01 00:00:00' AFTER `description`,
	ADD COLUMN `targetCompletationDateTime` DATETIME NOT NULL DEFAULT '2026-01-01 00:00:00' AFTER `responseDateTime`;
ALTER TABLE `ticket`
	ADD COLUMN `ticketSolutionTimeId` SMALLINT NOT NULL DEFAULT 0 AFTER `targetCompletationDateTime`;
ALTER TABLE `ticket`
	ADD COLUMN `responseHour` FLOAT NOT NULL DEFAULT 0 AFTER `ticketSolutionTimeId`;
ALTER TABLE `ticket`
	ADD COLUMN `lockTime` TINYINT NOT NULL DEFAULT 0 AFTER `responseDateTime`;

ALTER TABLE `ticket`
	CHANGE COLUMN `targetCompletationDateTime` `targetCompletationDateTime` DATETIME NOT NULL DEFAULT '2026-01-01 00:00:00' AFTER `lockTime`,
	ADD COLUMN `actualWorkingDateTime` DATETIME NOT NULL DEFAULT '2026-01-01 00:00:00' AFTER `targetCompletationDateTime`,
	ADD COLUMN `actualWorkingHour` FLOAT NOT NULL DEFAULT 0 AFTER `actualWorkingDateTime`;


ALTER TABLE `ticket`
	CHANGE COLUMN `actualWorkingDateTime` `actualWorkingDateTime` DATETIME NOT NULL DEFAULT '2026-01-01 00:00:00' AFTER `targetCompletationDateTime`,
	ADD COLUMN `verificationDateTime` DATETIME NOT NULL DEFAULT '2026-01-01 00:00:00' AFTER `actualWorkingDateTime`,
	CHANGE COLUMN `actualWorkingHour` `verificationHour` FLOAT NOT NULL DEFAULT '0' AFTER `verificationDateTime`,
	ADD COLUMN `Column 15` FLOAT NOT NULL AFTER `verificationHour`;
ALTER TABLE `ticket`
	DROP COLUMN `Column 15`;


ALTER TABLE `ticket`
	ADD COLUMN `actualWorkingHour` FLOAT NOT NULL AFTER `verificationHour`;
