-- SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
-- SET time_zone = "+00:00";

DROP DATABASE IF EXISTS Onslaught;

CREATE DATABASE Onslaught;

USE Onslaught;

CREATE TABLE `card` (
  `cardid` int(11) NOT NULL,
  `name` char(100) DEFAULT NULL,
  `picture` text,
  `description` char(200) DEFAULT NULL,
  `offensePoints` int(11) DEFAULT NULL,
  `defensePoints` int(11) DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `card_in_deck` (
  `deckid` int(11),
  `cardid` int(11) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `user` (
  `username` char(50),
  `password` char(100) DEFAULT NULL,
  `email` text
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `user_has_card` (
  `username` char(50),
  `cardid` int(11) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `user_owns_deck` (
  `deckid` int(11) NOT NULL,
  `username` char(50) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `history_belongsTo_user` (
  `logid` int(11) NOT NULL,
  `date` date,
  `result` text,
  `vsusername` char(50),
  `username` char(50) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

ALTER TABLE `card`
  ADD PRIMARY KEY (`cardid`);

ALTER TABLE `card_in_deck`
  ADD PRIMARY KEY (`deckid`,`cardid`),
  ADD KEY `cardid` (`cardid`),
  ADD KEY `deckid` (`deckid`);

ALTER TABLE `user`
  ADD PRIMARY KEY (`username`);

ALTER TABLE `user_has_card`
  ADD PRIMARY KEY (`username`,`cardid`),
  ADD KEY `cardid` (`cardid`),
  ADD KEY `username` (`username`);

ALTER TABLE `user_owns_deck`
  ADD PRIMARY KEY (`deckid`),
  ADD KEY `username` (`username`);

ALTER TABLE `history_belongsTo_user`
  ADD PRIMARY KEY (`logid`),
  ADD KEY `username` (`username`);

ALTER TABLE `card`
  MODIFY `cardid` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `user_owns_deck`
  MODIFY `deckid` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `history_belongsTo_user`
  MODIFY `logid` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `card_in_deck`
  ADD CONSTRAINT `card_in_deck_ibfk_1` FOREIGN KEY (`deckid`) REFERENCES `user_owns_deck` (`deckid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `card_in_deck_ibfk_2` FOREIGN KEY (`cardid`) REFERENCES `card` (`cardid`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `user_has_card`
  ADD CONSTRAINT `user_has_card_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_has_card_ibfk_2` FOREIGN KEY (`cardid`) REFERENCES `card` (`cardid`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `user_owns_deck`
  ADD CONSTRAINT `user_owns_deck_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_owns_one_deck` CHECK ( NOT EXISTS ( SELECT COUNT(*) FROM `user` u WHERE u.`username` = `username` GROUP BY u.`username` HAVING COUNT(*) > 1) );

ALTER TABLE `history_belongsTo_user`
  ADD CONSTRAINT `history_belongsTo_user_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE;

DELIMITER $$
CREATE PROCEDURE `does_user_own_deck` (IN `new_username` CHAR(50))
BEGIN
  IF EXISTS (SELECT `username` FROM `user_owns_deck` WHERE `username` = `new_username`) THEN
	SIGNAL SQLSTATE '45000'
	  SET MESSAGE_TEXT = 'user can only own one deck';
  END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `user_owns_deck_before_insert` BEFORE INSERT ON `user_owns_deck`
FOR EACH ROW
BEGIN
  CALL does_user_own_deck(new.`username`);
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `user_owns_deck_before_update` BEFORE UPDATE ON `user_owns_deck`
FOR EACH ROW
BEGIN
  CALL does_user_own_deck(new.`username`);
END$$
DELIMITER ;

/* DELIMITER $$
CREATE PROCEDURE `does_user_own_card` (IN `new_username` CHAR(50))
BEGIN
  IF EXISTS (SELECT `username` FROM `user_owns_deck` WHERE `username` = `new_username`) THEN
	SIGNAL SQLSTATE '45000'
	  SET MESSAGE_TEXT = 'user can only own one deck';
  END IF;
END$$
DELIMITER ; */

/* DELIMITER $$
CREATE TRIGGER 
DELIMITER **/

DELIMITER $$
CREATE PROCEDURE `is_user_facing_themselves` (IN `new_username` CHAR(50), IN `new_vsusername` CHAR(50))
BEGIN
  IF `new_username` = `new_vsusername` THEN
    SIGNAL SQLSTATE '45001'
      SET MESSAGE_TEXT = 'user cannot battle their self';
  END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `history_belongsTo_user_before_insert` BEFORE INSERT ON `history_belongsTo_user`
FOR EACH ROW
BEGIN
  CALL is_user_facing_themselves(new.`username`, new.`vsusername`);
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `history_belongsTo_user_before_update` BEFORE UPDATE ON `history_belongsTo_user`
FOR EACH ROW
BEGIN
  CALL is_user_facing_themselves(new.`username`, new.`vsusername`);
END$$
DELIMITER ;

-- Test statements to test the database
/* INSERT INTO `user` (`username`, `password`, `email`) VALUES ("aaa", "aaa", "Fdsa");
INSERT INTO `user` (`username`, `password`, `email`) VALUES ("bbb", "bbb", "Asdf"); */

-- Code used to test the constraint that users can only own one deck.
/* INSERT INTO `user_owns_deck` (`username`) VALUES ("aaa");
INSERT INTO `user_owns_deck` (`username`) VALUES ("bbb");

SELECT * FROM `user_owns_deck`;

UPDATE `user_owns_deck` SET `username` = "bbb" WHERE `username` = "aaa";
INSERT INTO `user_owns_deck` (`username`) VALUES ("bbb");

SELECT * FROM `user_owns_deck`; */

-- Code used to test the constraint that users can not battle themselves
/* INSERT INTO `history_belongsTo_user` (`vsusername`, `username`) VALUES ("aaa", "bbb");
INSERT INTO `history_belongsTo_user` (`vsusername`, `username`) VALUES ("aaa", "aaa");
UPDATE `history_belongsTo_user` SET `vsusername` = "bbb" WHERE `username` = "bbb"; */