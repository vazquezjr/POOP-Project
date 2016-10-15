-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 14, 2016 at 04:17 PM
-- Server version: 5.7.14
-- PHP Version: 5.6.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

DROP DATABASE IF EXISTS Onslaught;

CREATE DATABASE Onslaught;

USE Onslaught;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `onslaught`
--

-- --------------------------------------------------------

--
-- Table structure for table `card`
--

CREATE TABLE `card` (
  `cardid` int(11) NOT NULL,
  `name` char(100) DEFAULT NULL,
  `picture` text,
  `description` char(200) DEFAULT NULL,
  `offensePoints` int(11) DEFAULT NULL,
  `defensePoints` int(11) DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

-- --------------------------------------------------------

--
-- Table structure for table `card_in_deck`
--

CREATE TABLE `card_in_deck` (
  `deckid` int(11),
  `cardid` int(11) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `username` char(50),
  `password` char(100) DEFAULT NULL,
  `email` text,
  `wins` int(11) DEFAULT NULL,
  `losses` int(11) DEFAULT NULL,
  `draws` int(11) DEFAULT NULL,
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user_has_card`
--

CREATE TABLE `user_has_card` (
  `username` char(50),
  `cardid` int(11) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user_owns_deck`
--

CREATE TABLE `user_owns_deck` (
  `deckid` int(11) NOT NULL
  `username` char(50) NOT NULL,
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

-- --------------------------------------------------------

--
-- Table structure for table `history_belongsTo_user`
--

CREATE TABLE `history_belongsTo_user` (
  `logid` int(11) NOT NULL,
  `date` date,
  `result` text,
  `vsusername` char(50)
  `username` char(50) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `card`
--
ALTER TABLE `card`
  ADD PRIMARY KEY (`cardid`);

--
-- Indexes for table `card_in_deck`
--
ALTER TABLE `card_in_deck`
  ADD PRIMARY KEY (`deckid`,`cardid`),
  ADD KEY `cardid` (`cardid`),
  ADD KEY `deckid` (`deckid`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `user_has_card`
--
ALTER TABLE `user_has_card`
  ADD PRIMARY KEY (`username`,`cardid`),
  ADD KEY `cardid` (`cardid`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `user_owns_deck`
--
ALTER TABLE `user_owns_deck`
  ADD PRIMARY KEY (`deckid`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `history_belongsTo_user`
--
ALTER TABLE `history_belongsTo_user`
  ADD PRIMARY KEY (`logid`),
  ADD KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `card`
--
ALTER TABLE `card`
  MODIFY `cardid` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `user_owns_deck`
--
ALTER TABLE `user_owns_deck`
  MODIFY `deckid` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `history_belongsTo_user`
--
ALTER TABLE `history_belongsTo_user`
  MODIFY `logid` int(11) NOT NULL AUTO_INCREMENT;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `card_in_deck`
--
ALTER TABLE `card_in_deck`
  ADD CONSTRAINT `card_in_deck_ibfk_1` FOREIGN KEY (`deckid`) REFERENCES `user_owns_deck` (`deckid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `card_in_deck_ibfk_2` FOREIGN KEY (`cardid`) REFERENCES `card` (`cardid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_has_card`
--
ALTER TABLE `user_has_card`
  ADD CONSTRAINT `user_has_card_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_has_card_ibfk_2` FOREIGN KEY (`cardid`) REFERENCES `card` (`cardid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_owns_deck`
--
ALTER TABLE `user_owns_deck`
  ADD CONSTRAINT `user_owns_deck_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `history_belongsTo_user`
--
ALTER TABLE `history_belongsTo_user`
  ADD 

--
-- Assertion for tables
--



/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
