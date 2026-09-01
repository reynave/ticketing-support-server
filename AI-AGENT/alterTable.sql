ALTER TABLE `project`
	ADD COLUMN `ticketBaseHours` FLOAT NOT NULL DEFAULT 0 AFTER `ticketCategoriesParentId`;

ALTER TABLE `ticket`
	CHANGE COLUMN `ticketEstimationCost` `ticketEstimationCost` FLOAT NOT NULL DEFAULT 0 AFTER `ratesBy`,
	ADD COLUMN `hours` FLOAT NOT NULL AFTER `ticketEstimationCost`;
