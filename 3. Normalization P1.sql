-- 1NF director, cast, listed in (genre)



-- 1nd director
DROP TABLE IF EXISTS title_director;
CREATE TABLE title_director (
title_id VARCHAR (256),
crew_name TEXT
);
select * from title_director;


## Warning: Do not execute the following loops on a weak machine unless it's close to Black Friday or Boxing Day. Proceed with caution.
DROP PROCEDURE IF EXISTS norm;
DELIMITER \\
CREATE PROCEDURE norm()
BEGIN

DECLARE ind INT;
SET ind = 1;

WHILE(ind < 80) DO
BEGIN
	INSERT INTO title_director(title_id, crew_name)
	SELECT title_id, SUBSTRING_INDEX(SUBSTRING_INDEX(director,',',ind),',', -1) FROM MASTER;
	SET ind = ind +1;
END;
END while; 
END \\

DELIMITER ;

CALL norm();

DELETE FROM title_director WHERE crew_name ='';
ALTER TABLE title_director ADD COLUMN role VARCHAR(50);
UPDATE title_director SET role = 'director';

SELECT * FROM title_director LIMIT 100;



-- 1NF CAST
DROP TABLE IF EXISTS title_cast;
CREATE TABLE title_cast (
title_id VARCHAR (256),
crew_name TEXT
);

DROP PROCEDURE IF EXISTS norm2;
DELIMITER \\
CREATE PROCEDURE norm2()
BEGIN

DECLARE ind INT;
SET ind = 1;

WHILE(ind < 80) DO
BEGIN
	INSERT INTO title_cast(title_id, crew_name)
	SELECT title_id, SUBSTRING_INDEX(SUBSTRING_INDEX(cast,',',ind),',', -1) FROM MASTER;
	SET ind = ind +1;
END;
END while; 
END \\

DELIMITER ;

CALL norm2();

DELETE FROM title_cast WHERE crew_name ='';
ALTER TABLE title_cast ADD COLUMN role VARCHAR(50);
UPDATE title_cast SET role = 'cast';



-- NF1 listed in (genre)
DROP TABLE IF EXISTS title_genre_name;
CREATE TABLE title_genre_name (
title_id VARCHAR (256),
genre_name TEXT
);

DROP PROCEDURE IF EXISTS norm_genre;
DELIMITER \\
CREATE PROCEDURE norm_genre()
BEGIN

DECLARE ind INT;
SET ind = 1;

WHILE(ind < 6) DO
BEGIN
	INSERT INTO title_genre_name(title_id, genre_name)
	SELECT title_id, SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in,',',ind),',', -1) FROM MASTER;
	SET ind = ind +1;
END;
END while; 
END \\

DELIMITER ;

CALL norm_genre();

DELETE FROM title_genre_name WHERE genre_name ='';
SELECT * FROM title_genre_name;



-- 1NF country

DROP TABLE IF EXISTS title_country_name;
CREATE TABLE title_country_name (
title_id VARCHAR (256),
country_name TEXT
);

DROP PROCEDURE IF EXISTS norm_country;
DELIMITER \\
CREATE PROCEDURE norm_country()
BEGIN

DECLARE ind INT;
SET ind = 1;

WHILE(ind < 6) DO
BEGIN
	INSERT INTO title_country_name(title_id, country_name)
	SELECT title_id, SUBSTRING_INDEX(SUBSTRING_INDEX(country,',',ind),',', -1) FROM MASTER;
	SET ind = ind +1;
END;
END while; 
END \\

DELIMITER ;

CALL norm_country();

DELETE FROM title_country_name WHERE country_name ='';
SELECT * FROM title_country_name;




-- NORMALIZED TABLE: crew
# JOIN cast and crew
DROP TABLE IF EXISTS title_director_cast;
CREATE TABLE title_director_cast AS
SELECT DISTINCT * FROM
(SELECT * FROM title_director
UNION
SELECT * FROM title_cast) AS TB1;

DROP TABLE IF EXISTS crew;
CREATE TABLE crew AS
SELECT DISTINCT crew_name as name FROM title_director_cast;

ALTER TABLE crew ADD COLUMN name_id CHAR(10);
UPDATE crew SET name_id = LEFT(UUID(),10);


-- NORMALIZED TABLE: directed
DROP TABLE IF EXISTS directed;
CREATE TABLE directed AS
(SELECT title_id, name_id FROM (SELECT * FROM title_director_cast tdc, crew c
WHERE tdc.crew_name = c.name
AND role = 'director') AS TB2);

-- NORMALIZED TABLE: casted
DROP TABLE IF EXISTS casted;
CREATE TABLE casted AS
(SELECT title_id, name_id FROM (SELECT * FROM title_director_cast tdc, crew c
WHERE tdc.crew_name = c.name
AND role = 'cast') AS TB3);


-- NORMALIZED TABLE: Profession
DROP TABLE IF EXISTS profession;
CREATE TABLE profession AS
(SELECT name_id, role FROM (SELECT * FROM title_director_cast tdc, crew c
WHERE tdc.crew_name = c.name) AS TB4);


-- NORMALIZED TABLE: Genre
DROP TABLE IF EXISTS genre;
CREATE TABLE genre AS
SELECT DISTINCT genre_name AS genre FROM title_genre_name;

ALTER TABLE genre ADD COLUMN genre_id CHAR(9);
UPDATE genre SET genre_id = LEFT(UUID(),9);

select * from MASTER LIMIT 10;

-- NORMALIZED TABLE: title_genre
DROP TABLE IF EXISTS title_genre;
CREATE TABLE title_genre AS
(SELECT DISTINCT title_id, genre_id FROM (
	SELECT * FROM title_genre_name tgn, genre
    WHERE tgn.genre_name = genre.genre) AS TB5);

-- NORMALIZED TABLE: country
DROP TABLE IF EXISTS country;
CREATE TABLE country AS
SELECT DISTINCT country_name AS country FROM title_country_name;

ALTER TABLE country ADD COLUMN country_id CHAR(10);
UPDATE country SET country_id = LEFT(UUID(),10);
select DISTINCT country_id from country;

-- NORMALIZED TABLE: title_country
DROP TABLE IF EXISTS title_country;
CREATE TABLE title_country AS (
	SELECT DISTINCT title_id, country_id FROM (
    SELECT * FROM title_country_name tcn, country c
	WHERE tcn.country_name = c.country) AS TB6);

	





















