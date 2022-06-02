USE streaming;


-- Add a new column to represent streaming service
ALTER TABLE netflix
	ADD COLUMN Provider VARCHAR (50);
UPDATE netflix
	SET Provider = 'netflix';
select * from netflix;

ALTER TABLE disney
	ADD COLUMN Provider VARCHAR (50);
UPDATE disney
	SET Provider = 'disney';
select * from disney;

ALTER TABLE amazon
	ADD COLUMN Provider VARCHAR (50);
UPDATE amazon
	SET Provider = 'amazon';
select * from amazon;

-- Combine 3 tables
DROP TABLE IF EXISTS master;
CREATE TABLE master AS
SELECT * FROM netflix
UNION
SELECT * FROM disney
UNION
SELECT * FROM amazon;
SELECT * FROM MASTER;

-- Add unique id for movie title
ALTER TABLE master ADD COLUMN title_id CHAR(8);
UPDATE master SET title_id = LEFT(UUID(),8);

-- Delete duplicate rows from master table
	# List of duplicate movies
	DROP TABLE IF EXISTS tdup;
	CREATE TABLE tdup AS
	SELECT m1.title_id FROM master m1
	JOIN master m2 
	ON m1.title = m2.title
	AND m1.director = m2.director
	AND m1.type = m2.type
    AND m1.provider = m2.provider
	WHERE m1.title_id < m2.title_id;

    DELETE FROM master
    WHERE title_id IN (SELECT * FROM tdup);
    
    ALTER TABLE MASTER ADD COLUMN st_id CHAR(3);
	UPDATE MASTER SET st_id = '001' WHERE provider = 'netflix';
	UPDATE MASTER SET st_id = '002' WHERE provider = 'disney';
	UPDATE MASTER SET st_id = '003' WHERE provider = 'amazon';
    
SELECT * FROM MASTER;



-- 1st normalized table: titles
DROP TABLE IF EXISTS titles;
CREATE TABLE titles AS
SELECT title_id, title, type, st_id, date_added, release_year, rating, SUBSTRING_INDEX(duration,' ',1) AS duration, description FROM MASTER;


CREATE INDEX title_index
	ON titles(title_id);

SELECT * FROM titles;



-- CREATE 2ND NORMALIZED TABLE: stream_service

DROP TABLE IF EXISTS stream_service;
CREATE TABLE stream_service AS
SELECT DISTINCT st_id, provider AS st_name FROM MASTER;

SELECT * FROM stream_service;

-- CREATE 3RD NORMALIZED TABLE: publication
DROP TABLE IF EXISTS publication;
CREATE TABLE publication AS
SELECT DISTINCT title_id, date_added, st_id FROM MASTER;

SELECT * FROM publication;

-- CREATE TABLE 


-- ADD pk and fk

ALTER TABLE titles
ADD CONSTRAINT pk_titles PRIMARY KEY (title_id);


ALTER TABLE stream_service
ADD CONSTRAINT pk_ss PRIMARY KEY (st_id);


ALTER TABLE publication
ADD CONSTRAINT pk_publication PRIMARY KEY (title_id, date_added, st_id),
ADD CONSTRAINT fk_publication FOREIGN KEY (title_id) REFERENCES titles(title_id),
ADD CONSTRAINT fk_publication2 FOREIGN KEY (st_id) REFERENCES stream_service(st_id);
