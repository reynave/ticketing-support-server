ALTER TABLE `ticket`
	ADD COLUMN `projectSorting` MEDIUMINT(9) NOT NULL AFTER `sorting`;
ALTER TABLE `ticket`
	CHANGE COLUMN `projectSorting` `projectSorting` MEDIUMINT(9) NOT NULL DEFAULT '999' AFTER `sorting`;
