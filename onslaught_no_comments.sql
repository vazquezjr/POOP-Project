
DROP DATABASE IF EXISTS Onslaught;

CREATE DATABASE Onslaught;

USE Onslaught;

CREATE TABLE `card` (
  `cardid` int(11) NOT NULL,
  `title` char(100) DEFAULT NULL,
  `type` char(100) DEFAULT NULL,
  `lifeTotal` int(11) DEFAULT NULL,
  `attack1` int(11) DEFAULT NULL,
  `attack2` int(11) DEFAULT NULL,
  `attack3` int(11) DEFAULT NULL,
  `cost1` int(11) DEFAULT NULL,
  `cost2` int(11) DEFAULT NULL,
  `cost3` int(11) DEFAULT NULL,
  `offensePoints` int(11) DEFAULT NULL,
  `defensePoints` int(11) DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `card_in_deck` (
  `deckid` int(11),
  `cardid` int(11) NOT NULL,
  `count` int(11) DEFAULT 1
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `user` (
  `userid` int(11),
  `username` char(50),
  `password` char(100) DEFAULT NULL,
  `email` text,
  `experience` int(11) DEFAULT 0,
  `loggedIn` boolean DEFAULT FALSE
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `user_has_card` (
  `userid` int(11),
  `cardid` int(11) NOT NULL,
  `count` int(11) DEFAULT 1
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `user_owns_deck` (
  `deckid` int(11) NOT NULL,
  `userid` int(11) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `history_belongsTo_user` (
  `logid` int(11) NOT NULL,
  `date` date,
  `result` text,
  `vsuserid` int(11),
  `userid` int(11) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

ALTER TABLE `card`
  ADD PRIMARY KEY (`cardid`);

ALTER TABLE `card_in_deck`
  ADD PRIMARY KEY (`deckid`,`cardid`),
  ADD KEY `cardid` (`cardid`),
  ADD KEY `deckid` (`deckid`);

ALTER TABLE `user`
  ADD PRIMARY KEY (`userid`);

ALTER TABLE `user_has_card`
  ADD PRIMARY KEY (`userid`,`cardid`),
  ADD KEY `cardid` (`cardid`),
  ADD KEY `userid` (`userid`);

ALTER TABLE `user_owns_deck`
  ADD PRIMARY KEY (`deckid`),
  ADD KEY `userid` (`userid`);

ALTER TABLE `history_belongsTo_user`
  ADD PRIMARY KEY (`logid`),
  ADD KEY `userid` (`userid`);

ALTER TABLE `card`
  MODIFY `cardid` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `user`
  MODIFY `userid` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `user_owns_deck`
  MODIFY `deckid` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `history_belongsTo_user`
  MODIFY `logid` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `card_in_deck`
  ADD CONSTRAINT `card_in_deck_ibfk_1` FOREIGN KEY (`deckid`) REFERENCES `user_owns_deck` (`deckid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `card_in_deck_ibfk_2` FOREIGN KEY (`cardid`) REFERENCES `card` (`cardid`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `user_has_card`
  ADD CONSTRAINT `user_has_card_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_has_card_ibfk_2` FOREIGN KEY (`cardid`) REFERENCES `card` (`cardid`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `user_owns_deck`
  ADD CONSTRAINT `user_owns_deck_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `history_belongsTo_user`
  ADD CONSTRAINT `history_belongsTo_user_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE;

DELIMITER $$
CREATE PROCEDURE `does_user_own_deck` (IN `new_userid` INT(11))
BEGIN
  IF EXISTS (SELECT `userid` FROM `user_owns_deck` WHERE `userid` = `new_userid`) THEN
	SIGNAL SQLSTATE '45000'
	  SET MESSAGE_TEXT = 'user can only own one deck.';
  END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `user_owns_deck_before_insert` BEFORE INSERT ON `user_owns_deck`
FOR EACH ROW
BEGIN
  CALL does_user_own_deck(new.`userid`);
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `user_owns_deck_before_update` BEFORE UPDATE ON `user_owns_deck`
FOR EACH ROW
BEGIN
  CALL does_user_own_deck(new.`userid`);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `is_user_facing_themselves` (IN `new_userid` INT(11), IN `new_vsuserid` INT(11))
BEGIN
  IF `new_userid` = `new_vsuserid` THEN
    SIGNAL SQLSTATE '45001'
      SET MESSAGE_TEXT = 'user cannot battle their self.';
  END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `history_belongsTo_user_before_insert` BEFORE INSERT ON `history_belongsTo_user`
FOR EACH ROW
BEGIN
  CALL is_user_facing_themselves(new.`userid`, new.`vsuserid`);
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `history_belongsTo_user_before_update` BEFORE UPDATE ON `history_belongsTo_user`
FOR EACH ROW
BEGIN
  CALL is_user_facing_themselves(new.`userid`, new.`vsuserid`);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `add_card_to_user` (IN `new_userid` int(11), IN `new_cardid` int(11))
BEGIN
  IF EXISTS (SELECT * FROM `user_has_card` u WHERE `new_userid` = u.`userid` AND `new_cardid` = u.`cardid`) THEN
	UPDATE `user_has_card` SET `count` = `count` + 1 WHERE `new_userid` = `userid` AND `new_cardid` = `cardid`;

  ELSE-- IF NOT EXISTS (SELECT * FROM `user_has_card` u WHERE `new_username` = u.`username` AND `new_cardid` = u.`cardid`) THEN
    INSERT INTO `user_has_card` (`userid`, `cardid`) VALUES (`new_userid`, `new_cardid`);
  END IF;

END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `remove_card_from_user` (IN `remove_userid` int(11), IN `remove_cardid` int(11))
BEGIN

  DECLARE `remove_deckid` int(11);
  SELECT `deckid` INTO `remove_deckid` FROM `user_owns_deck` WHERE `remove_userid` = `userid`;

  IF (NOT EXISTS (SELECT u.`count` FROM `user_has_card` u WHERE `remove_userid` = u.`userid` AND `remove_cardid` = u.`cardid`)) THEN
    SIGNAL SQLSTATE '45002'
	  SET MESSAGE_TEXT = 'cannot remove card. user does not own card.';

  ELSEIF EXISTS (SELECT * FROM `user_has_card` c, `card_in_deck` d WHERE `remove_userid` = c.`userid` AND `remove_cardid` = c.`cardid` AND `remove_cardid` = d.`cardid` AND c.`count` = d.`count`) THEN 
    CALL remove_card_from_deck(`remove_deckid`, `remove_cardid`);

    IF ((SELECT u.`count` FROM `user_has_card` u WHERE `remove_userid` = u.`userid` AND `remove_cardid` = u.`cardid`) = 1) THEN
	  DELETE FROM `user_has_card` WHERE `remove_userid` = `userid` AND `remove_cardid` = `cardid`;

    ELSE
	  UPDATE `user_has_card` SET `count` = `count` - 1 WHERE `remove_userid` = `userid` AND `remove_cardid` = `cardid`;
    END IF;

  ELSEIF ((SELECT u.`count` FROM `user_has_card` u WHERE `remove_userid` = u.`userid` AND `remove_cardid` = u.`cardid`) = 1) THEN
    DELETE FROM `user_has_card` WHERE `remove_userid` = `userid` AND `remove_cardid` = `cardid`;

  ELSE
	UPDATE `user_has_card` SET `count` = `count` - 1 WHERE `remove_userid` = `userid` AND `remove_cardid` = `cardid`;
  END IF;

END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `does_card_belong_to_user` (IN `new_deckid` int(11), IN `new_cardid` int(11))
BEGIN
  IF (NOT EXISTS (SELECT * FROM `user_has_card` c, `user_owns_deck` d WHERE `new_deckid` = d.`deckid` AND `new_cardid` = c.`cardid` AND d.`userid` = c.`userid`)) THEN
    SIGNAL SQLSTATE '45003'
	  SET MESSAGE_TEXT = 'user does not own card.';
  END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `card_in_deck_before_insert` BEFORE INSERT ON `card_in_deck`
FOR EACH ROW
BEGIN
  CALL does_card_belong_to_user(new.`deckid`, new.`cardid`);
  CALL does_user_have_enough_copies(new.`deckid`, new.`cardid`, new.`count`);
  CALL does_deck_contain_three_copies(new.`count`);
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `card_in_deck_before_update` BEFORE UPDATE ON `card_in_deck`
FOR EACH ROW
BEGIN
  CALL does_card_belong_to_user(new.`deckid`, new.`cardid`);
  CALL does_user_have_enough_copies(new.`deckid`, new.`cardid`, new.`count`);
  CALL does_deck_contain_three_copies(new.`count`);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `add_card_to_deck` (IN `new_deckid` int(11), IN `new_cardid` int(11))
BEGIN
  IF EXISTS (SELECT * FROM `card_in_deck` WHERE `new_deckid` = `deckid` AND `new_cardid` = `cardid`) THEN
    UPDATE `card_in_deck` SET `count` = `count` + 1 WHERE `new_deckid` = `deckid` AND `new_cardid` = `cardid`;

  ELSE
    INSERT INTO `card_in_deck` (`deckid`, `cardid`) VALUES (`new_deckid`, `new_cardid`);
  
  END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `remove_card_from_deck` (IN `remove_deckid` int(11), IN `remove_cardid` int(11))
BEGIN
  IF NOT EXISTS (SELECT `count` FROM `card_in_deck` WHERE `remove_deckid` = `deckid` AND `remove_cardid` = `cardid`) THEN
    SIGNAL SQLSTATE '45004'
      SET MESSAGE_TEXT = 'cannot remove card. card is not in deck.';

  ELSEIF ((SELECT `count` FROM `card_in_deck` WHERE `remove_deckid` = `deckid` AND `remove_cardid` = `cardid`) = 1) THEN
    DELETE FROM `card_in_deck` WHERE `remove_deckid` = `deckid` AND `remove_cardid` = `cardid`;

  ELSE
    UPDATE `card_in_deck` SET `count` = `count` - 1 WHERE `remove_deckid` = `deckid` AND `remove_cardid` = `cardid`;
  END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `does_user_have_enough_copies` (IN `new_deckid` int(11), IN `new_cardid` int(11), IN `new_count` int(11))
BEGIN
  IF EXISTS (SELECT * FROM `user_has_card` c, `user_owns_deck` u WHERE `new_deckid` = u.`deckid` AND `new_cardid` = c.`cardid` AND c.`userid` = u.`userid` AND `new_count` > c.`count`) THEN
    SIGNAL SQLSTATE '45005'
      SET MESSAGE_TEXT = 'cannot add card. all copies that user owns are in deck already.';
  END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `does_deck_contain_three_copies` (IN `new_count` int(11))
BEGIN
  IF `new_count` > 3 THEN
    SIGNAL SQLSTATE '45006'
      SET MESSAGE_TEXT = 'cannot add card. card limit of three reached.';
  END IF;
END$$
DELIMITER ;

INSERT INTO `user` (`userid`, `username`, `password`, `email`, `experience`, `loggedIn`) VALUES (NULL, 'bbb', NULL, NULL, NULL, NULL);
INSERT INTO `user` (`userid`, `username`, `password`, `email`, `experience`, `loggedIn`) VALUES (NULL, 'aaa', NULL, NULL, NULL, NULL);
INSERT INTO `user_owns_deck` (`deckid`, `userid`) VALUES (NULL, 1);
INSERT INTO `user_owns_deck` (`deckid`, `userid`) VALUES (NULL, 2);
INSERT INTO `card` (`cardid`, `title`, `type`, `lifeTotal`, `attack1`, `attack2`, `attack3`, `cost1`, `cost2`, `cost3`, `offensePoints`, `defensePoints`) VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `card` (`cardid`, `title`, `type`, `lifeTotal`, `attack1`, `attack2`, `attack3`, `cost1`, `cost2`, `cost3`, `offensePoints`, `defensePoints`) VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `card` (`cardid`, `title`, `type`, `lifeTotal`, `attack1`, `attack2`, `attack3`, `cost1`, `cost2`, `cost3`, `offensePoints`, `defensePoints`) VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
CALL add_card_to_user(1, 1);
CALL add_card_to_user(1, 1);
CALL add_card_to_user(1, 1);
CALL add_card_to_user(1, 2);
CALL add_card_to_user(1, 2);
CALL add_card_to_user(1, 2);
CALL add_card_to_user(1, 2);
CALL add_card_to_user(1, 2);
CALL add_card_to_user(2, 2);
CALL add_card_to_user(2, 2);
CALL add_card_to_user(2, 2);
CALL add_card_to_user(2, 3);
CALL add_card_to_user(2, 3);
CALL add_card_to_user(2, 3);
CALL add_card_to_deck(1, 2);
CALL add_card_to_deck(1, 2);
CALL add_card_to_deck(1, 2);
CALL add_card_to_deck(2, 2);
CALL add_card_to_deck(2, 2);
CALL add_card_to_deck(2, 2);
CALL remove_card_from_user(1, 2);
CALL remove_card_from_user(1, 2);
CALL remove_card_from_user(1, 2);
