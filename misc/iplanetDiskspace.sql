-- MySQL dump 10.13  Distrib 5.6.12, for Win32 (x86)
--
-- Host: localhost    Database: pdb60166
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
-- Table structure for table `iplanet_cpu`
--

CREATE TABLE `iplanet_alert` (
`server` varchar(10) NOT NULL,
  `part1` varchar(10) NOT NULL,
  `part2` varchar(10) NOT NULL,
  `part3` varchar(10) NOT NULL,
  `part4` varchar(10) NOT NULL,
  `part5` varchar(10) NOT NULL,
  `part6` varchar(10) NOT NULL,
  `part7` varchar(10) NOT NULL,
  `part8` varchar(10) NOT NULL,
  `part9` varchar(10) NOT NULL,
  `part10` varchar(10) NOT NULL,
  `part11` varchar(10) NOT NULL,
  `part12` varchar(10) NOT NULL
  
  
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `iplanet_diskspace` (server, part1, part2, part3, part4,part5,part6,part7,part8,part9,part10,part11,part12) VALUES ('prh00939','62.3','67.5','64.5','61','61','61','61','61','61','61','61','61'), ('prh00940','53', '58','61','61','61','61','71','61','94','61','66.2','80');