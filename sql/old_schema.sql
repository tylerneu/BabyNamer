CREATE TABLE `name` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `sex` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_sex` (`name`,`sex`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `score` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name_id` int(11) unsigned NOT NULL,
  `year` int(4) unsigned NOT NULL,
  `state` char(2) NOT NULL DEFAULT '',
  `score` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name_id` (`name_id`),
  CONSTRAINT `score_ibfk_1` FOREIGN KEY (`name_id`) REFERENCES `name` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;