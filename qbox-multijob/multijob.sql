CREATE TABLE IF NOT EXISTS `multijob_employment` (
  `citizenid` VARCHAR(50) NOT NULL,
  `job` VARCHAR(50) NOT NULL,
  `grade` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`citizenid`, `job`)
);