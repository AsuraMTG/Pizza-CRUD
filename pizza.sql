-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2024. Okt 15. 22:01
-- Kiszolgáló verziója: 10.4.32-MariaDB
-- PHP verzió: 8.2.12

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `pizza`
--
DROP DATABASE IF EXISTS `pizza`;
CREATE DATABASE IF NOT EXISTS `pizza` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `pizza`;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `futar`
--

DROP TABLE IF EXISTS `futar`;
CREATE TABLE `futar` (
  `fazon` int(10) UNSIGNED NOT NULL COMMENT 'a pizzafutár azonosítója',
  `fnev` varchar(25) NOT NULL DEFAULT '' COMMENT 'a pizzafutár neve',
  `ftel` varchar(15) NOT NULL DEFAULT '' COMMENT 'a pizzafutár telefonszáma'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `futar`
--

INSERT INTO `futar` (`fazon`, `fnev`, `ftel`) VALUES
(1, 'Hurrikán', '+36 408-3654'),
(2, 'Gyalogkakukk', '+36 471-6098'),
(3, 'Gömbvillám', '+36 613-2845'),
(4, 'Szélvész', '+36 855-5334'),
(5, 'Imperial', '+36 358-3198');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `pizza`
--

DROP TABLE IF EXISTS `pizza`;
CREATE TABLE `pizza` (
  `pazon` int(11) UNSIGNED NOT NULL COMMENT 'a pizza azonosítója',
  `pnev` varchar(15) NOT NULL DEFAULT '' COMMENT 'a pizza neve',
  `par` int(4) NOT NULL DEFAULT 0 COMMENT 'a pizza ára'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `pizza`
--

INSERT INTO `pizza` (`pazon`, `pnev`, `par`) VALUES
(1, 'Capricciosa', 1050),
(2, 'Frutti di Mare', 1350),
(3, 'Hawaii', 850),
(4, 'Vesuvio', 900),
(5, 'Sorrento', 1050);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `rendeles`
--

DROP TABLE IF EXISTS `rendeles`;
CREATE TABLE `rendeles` (
  `razon` int(10) UNSIGNED NOT NULL COMMENT 'a rendelés sorszáma',
  `vazon` int(10) UNSIGNED DEFAULT NULL COMMENT 'a megrendelő azonosítója',
  `fazon` int(10) UNSIGNED DEFAULT NULL COMMENT 'a pizzafutár azonosítója',
  `idopont` datetime NOT NULL COMMENT 'a rendelés ideje'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `rendeles`
--

INSERT INTO `rendeles` (`razon`, `vazon`, `fazon`, `idopont`) VALUES
(1, 4, 2, '2024-10-01 12:04:11'),
(2, 7, 2, '2024-10-01 13:18:44'),
(3, 1, 1, '2024-10-02 10:11:41'),
(4, 5, 2, '2024-10-02 10:24:59'),
(5, 2, 3, '2024-10-02 13:19:06'),
(6, 4, 2, '2024-10-03 13:14:38'),
(7, 6, 2, '2024-10-04 11:10:35'),
(8, 7, 4, '2024-10-04 15:34:58'),
(9, 1, 5, '2024-10-04 17:07:59'),
(10, 3, 5, '2024-10-04 20:21:51'),
(11, 2, 1, '2024-10-05 18:52:53'),
(12, 5, 2, '2024-10-05 19:59:02'),
(13, 6, 2, '2024-10-06 14:55:03'),
(14, 4, 3, '2024-10-06 15:01:14'),
(15, 1, 4, '2024-10-06 18:48:46'),
(16, 2, 5, '2024-10-06 19:11:03'),
(17, 7, 2, '2024-10-06 19:56:28'),
(18, 3, 2, '2024-10-07 12:45:30'),
(19, 4, 5, '2024-10-07 13:00:56'),
(20, 1, 1, '2024-10-07 15:42:50'),
(21, 5, 3, '2024-10-08 18:56:00');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `tetel`
--

DROP TABLE IF EXISTS `tetel`;
CREATE TABLE `tetel` (
  `razon` int(10) UNSIGNED DEFAULT NULL COMMENT 'a rendelés sorszáma',
  `pazon` int(10) UNSIGNED DEFAULT NULL COMMENT 'a pizza azonosítója',
  `db` int(3) NOT NULL DEFAULT 0 COMMENT 'egy rendelési tétel darabszáma'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `tetel`
--

INSERT INTO `tetel` (`razon`, `pazon`, `db`) VALUES
(1, 1, 2),
(1, 4, 3),
(2, 2, 1),
(3, 1, 2),
(4, 1, 1),
(4, 4, 1),
(5, 2, 4),
(6, 1, 1),
(6, 4, 1),
(6, 5, 1),
(7, 5, 5),
(8, 4, 3),
(9, 2, 1),
(10, 1, 1),
(10, 4, 1),
(11, 1, 1),
(12, 2, 2),
(12, 4, 2),
(13, 4, 1),
(13, 5, 1),
(13, 2, 1),
(14, 2, 2),
(15, 1, 1),
(16, 2, 1),
(16, 4, 1),
(16, 5, 1),
(17, 1, 2),
(17, 2, 3),
(18, 1, 4),
(18, 5, 1),
(19, 1, 1),
(19, 2, 1),
(19, 4, 1),
(19, 5, 1),
(20, 5, 3),
(21, 2, 2),
(21, 4, 1);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `vevo`
--

DROP TABLE IF EXISTS `vevo`;
CREATE TABLE `vevo` (
  `vazon` int(10) UNSIGNED NOT NULL COMMENT 'a megrendelő azonosítója',
  `vnev` varchar(30) NOT NULL DEFAULT '' COMMENT 'a megrendelő neve',
  `vcim` varchar(30) NOT NULL DEFAULT '' COMMENT 'a megrendelő lakcíme'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `vevo`
--

INSERT INTO `vevo` (`vazon`, `vnev`, `vcim`) VALUES
(1, 'Hapci', 'Kerekerdő 21'),
(2, 'Vidor', 'Medvebarlag'),
(3, 'Tudor', 'Nagytisztás'),
(4, 'Kuka', 'Bagolyfészek'),
(5, 'Szende', 'Nagyszikla'),
(6, 'Szundi', 'Mohaágy'),
(7, 'Morgó', 'Kőszikla');

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `futar`
--
ALTER TABLE `futar`
  ADD PRIMARY KEY (`fazon`);

--
-- A tábla indexei `pizza`
--
ALTER TABLE `pizza`
  ADD PRIMARY KEY (`pazon`);

--
-- A tábla indexei `rendeles`
--
ALTER TABLE `rendeles`
  ADD PRIMARY KEY (`razon`),
  ADD KEY `fk_rendeles_futar` (`fazon`),
  ADD KEY `fk_rendeles_vevo` (`vazon`);

--
-- A tábla indexei `tetel`
--
ALTER TABLE `tetel`
  ADD KEY `fk_tetel_pizza` (`pazon`),
  ADD KEY `fk_tetel_rendeles` (`razon`);

--
-- A tábla indexei `vevo`
--
ALTER TABLE `vevo`
  ADD PRIMARY KEY (`vazon`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `futar`
--
ALTER TABLE `futar`
  MODIFY `fazon` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'a pizzafutár azonosítója', AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT a táblához `pizza`
--
ALTER TABLE `pizza`
  MODIFY `pazon` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'a pizza azonosítója', AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT a táblához `rendeles`
--
ALTER TABLE `rendeles`
  MODIFY `razon` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'a rendelés sorszáma', AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT a táblához `vevo`
--
ALTER TABLE `vevo`
  MODIFY `vazon` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'a megrendelő azonosítója', AUTO_INCREMENT=8;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `rendeles`
--
ALTER TABLE `rendeles`
  ADD CONSTRAINT `fk_rendeles_futar` FOREIGN KEY (`fazon`) REFERENCES `futar` (`fazon`),
  ADD CONSTRAINT `fk_rendeles_vevo` FOREIGN KEY (`vazon`) REFERENCES `vevo` (`vazon`);

--
-- Megkötések a táblához `tetel`
--
ALTER TABLE `tetel`
  ADD CONSTRAINT `fk_tetel_pizza` FOREIGN KEY (`pazon`) REFERENCES `pizza` (`pazon`),
  ADD CONSTRAINT `fk_tetel_rendeles` FOREIGN KEY (`razon`) REFERENCES `rendeles` (`razon`);
SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
