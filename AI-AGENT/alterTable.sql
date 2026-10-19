ALTER TABLE `ticket`
	ADD COLUMN `sorting` MEDIUMINT NOT NULL DEFAULT '999' AFTER `hours`;

INSERT INTO `thinktank-ticket`.`module` (`id`, `name`) VALUES (2000, 'Home');