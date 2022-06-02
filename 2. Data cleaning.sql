USE streaming;

SELECT * FROM netflix;

-- REMOVE DUPLICATED MOVIES

DROP TABLE IF EXISTS ndup;
CREATE TABLE ndup AS (
SELECT n1.show_id FROM netflix n1
JOIN netflix n2 
ON n1.title = n2.title
AND n1.director = n2.director
AND n1.type = n2.type
WHERE n1.show_id < n2.show_id);

DELETE FROM netflix WHERE show_id IN (SELECT * FROM ndup);


DROP TABLE IF EXISTS ddup;
CREATE TABLE ddup AS (
SELECT d1.show_id FROM disney d1
JOIN disney d2 
ON d1.title = d2.title
AND d1.director = d2.director
AND d1.type = d2.type
WHERE d1.show_id < d2.show_id);

DELETE FROM disney WHERE show_id IN (SELECT * FROM ddup);


DROP TABLE IF EXISTS adup;
CREATE TABLE adup AS (
SELECT a1.show_id FROM amazon a1
JOIN amazon a2 
ON a1.title = a2.title
AND a1.director = a2.director
AND a1.type = a2.type
WHERE a1.show_id < a2.show_id);

DELETE FROM amazon WHERE show_id IN (SELECT * FROM adup);


-- Movies in both Disney and Netflix
SELECT * FROM netflix n
JOIN disney d
ON n.title = d.title;

SELECT * FROM MASTER;


