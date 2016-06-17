-- MySQL dump 10.13  Distrib 5.6.12, for Win32 (x86)
--
-- Host: localhost    Database: sys
-- ------------------------------------------------------
-- Server version	5.5.25a

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Database: `sys`
--

--
-- Table structure for table `testdb`
--

CREATE TABLE `testdb` (
  `db_name` varchar(64) NOT NULL,
  `server` varchar(64) NOT NULL,
  `db_file` varchar(64) NOT NULL,
  `db_size` int(10) NOT NULL,
  `mailboxes` int(10) NOT NULL,
  `whitespace` double NOT NULL,
  `top_mailbox` varchar(64) NOT NULL,
  `top_mailboxsize` int(10) NOT NULL,
  `last_fullbackup` datetime,
  `no_backup` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `client`
--

LOCK TABLES `testdb` WRITE;
INSERT INTO `testdb` (`db_name`,`server`,`db_file`,`db_size`,`mailboxes`,`whitespace`,`top_mailbox`,`top_mailboxsize`,`last_fullbackup`,`no_backup`) VALUES ('FXGEXEC001','PWN90115','L:\Program Files\Exchsrvr\FXGEXEC001\FXGEXEC001.edb', 50, 100, 0.428, 'dummy1',100, '2015-09-30 11:19:00', 'yes');
INSERT INTO `testdb` (`db_name`,`server`,`db_file`,`db_size`,`mailboxes`,`whitespace`,`top_mailbox`,`top_mailboxsize`,`last_fullbackup`,`no_backup`) VALUES ('FXGEXEC002','PWN90115','L:\Program Files\Exchsrvr\FXGEXEC001\FXGEXEC002.edb', 50, 100, 0.428, 'dummy2',100, '2015-09-30 11:20:00', 'yes');
INSERT INTO `testdb` (`db_name`,`server`,`db_file`,`db_size`,`mailboxes`,`whitespace`,`top_mailbox`,`top_mailboxsize`,`last_fullbackup`,`no_backup`) VALUES ('FXGEXEC003','PWN90115','L:\Program Files\Exchsrvr\FXGEXEC001\FXGEXEC003.edb', 50, 100, 0.428, 'dummy3',100, '2015-09-30 11:30:00', 'yes');
INSERT INTO `testdb` (`db_name`,`server`,`db_file`,`db_size`,`mailboxes`,`whitespace`,`top_mailbox`,`top_mailboxsize`,`last_fullbackup`,`no_backup`) VALUES ('FXGEXEC004','PWN90115','L:\Program Files\Exchsrvr\FXGEXEC001\FXGEXEC004.edb', 50, 100, 0.428, 'dummy4',100, '2015-09-30 11:39:00', 'yes');
UNLOCK TABLES;
