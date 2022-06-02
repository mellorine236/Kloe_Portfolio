DROP SCHEMA IF EXISTS streaming;
CREATE SCHEMA streaming;
USE streaming;


-- CREATE TABLES
DROP TABLE IF EXISTS disney;
CREATE TABLE disney	(
					show_id VARCHAR(500),
                    type VARCHAR(500),
                    title VARCHAR(500),
                    director VARCHAR(500),
                    cast VARCHAR(1000),
                    country VARCHAR(500),
                    date_added VARCHAR(255),
                    release_year INT,
                    rating VARCHAR(500),
                    duration VARCHAR(500),
                    listed_in VARCHAR(500),
                    description VARCHAR(500)
								);


DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix	(
					show_id VARCHAR(500),
                    type VARCHAR(500),
                    title VARCHAR(500),
                    director VARCHAR(500),
                    cast VARCHAR(1000),
                    country VARCHAR(500),
                    date_added VARCHAR(255),
                    release_year INT,
                    rating VARCHAR(500),
                    duration VARCHAR(500),
                    listed_in VARCHAR(500),
                    description VARCHAR(500)
								);                                


DROP TABLE IF EXISTS amazon;
CREATE TABLE amazon	(
					show_id VARCHAR(500),
                    type VARCHAR(500),
                    title VARCHAR(500),
                    director TEXT,
                    cast TEXT,
                    country VARCHAR(500),
                    date_added VARCHAR(255),
                    release_year INT,
                    rating VARCHAR(500),
                    duration VARCHAR(500),
                    listed_in VARCHAR(500),
                    description TEXT
								);


                                
-- LOAD DATA

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Disney.csv'
INTO TABLE disney
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

                                
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Netflix.csv'
INTO TABLE netflix
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- LOAD DATA
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/amazon_prime.csv'
INTO TABLE amazon
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

