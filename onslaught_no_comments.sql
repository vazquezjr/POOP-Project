SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

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
  `email` text,
  `wins` int(11) DEFAULT NULL,
  `losses` int(11) DEFAULT NULL,
  `draws` int(11) DEFAULT NULL
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
  ADD CONSTRAINT `user_owns_deck_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `history_belongsTo_user`
  ADD CONSTRAINT `history_belongsTo_user_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE;
