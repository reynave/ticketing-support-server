ALTER TABLE `ticket`
	ADD COLUMN `clientEditable` TINYINT NOT NULL DEFAULT 0 AFTER `ticketEstimationCost`;
