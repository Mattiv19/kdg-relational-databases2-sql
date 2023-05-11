-- Clear and fill tables 400 000 rows
BEGIN
    PKG_recordingstudios.empty_tables();
    PKG_RECORDINGSTUDIOS.bewijs_milestone_5();
END;

-- Stats tabellen
BEGIN
   DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'ARTISTS');
   DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'RECORDING_STUDIOS');
   DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'ROOMS');
   DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'EQUIPMENT');
END;

-- Table size
SELECT segment_name, segment_type, sum(bytes/1024/1024) MB,
       (SELECT COUNT(*) FROM EQUIPMENT)  as table_count
FROM DBA_SEGMENTS
WHERE SEGMENT_NAME = 'EQUIPMENT'
GROUP BY segment_name, segment_type;

SELECT * FROM RECORDING_STUDIOS;

-- Overview of average rent per hour for equipment where the recording studios are located in Brussel.
SELECT s.STUDIO_NAME, s.ADDRESS, r.ROOM_NAME, ROUND(AVG(e.RENTPERHOUR)) AS "Average Rent Per Hour"
FROM RECORDING_STUDIOS S
    JOIN ROOMS R ON s.STUDIO_CODE = R.RECORDING_STUDIOS_STUDIO_CODE
    JOIN EQUIPMENT e ON e.ROOMS_ROOM_CODE = r.ROOM_CODE
WHERE upper(S.LOCATION) = 'BRUSSEL'
GROUP BY s.STUDIO_NAME, s.ADDRESS, r.ROOM_NAME
ORDER BY s.STUDIO_NAME, r.ROOM_NAME;

-- Partitionering
DROP TABLE EQUIPMENT CASCADE CONSTRAINTS PURGE;
CREATE TABLE EQUIPMENT
(      equipment_code  INTEGER GENERATED ALWAYS AS IDENTITY,
       rentperhour     NUMBER(3),  --M6
       equipmentname   VARCHAR2(30 CHAR),  --M6
       mixing_console  VARCHAR2(4 CHAR),
       monitors        VARCHAR2(10 CHAR),
       hardware        VARCHAR2(50),
       daw             VARCHAR2(10 CHAR),
       software        VARCHAR2(50 CHAR),
       synths          VARCHAR2(50 CHAR),
       vocal_mic       VARCHAR2(10),
       rooms_room_code INTEGER NOT NULL,
       ro_rec_stu_code INTEGER NOT NULL
)
    PARTITION BY RANGE(rooms_room_code)
    INTERVAL(50)
    (
        partition equipment_50 VALUES LESS THAN (50)
    );

ALTER TABLE equipment ADD CHECK ( rentperhour BETWEEN 1 AND 200 );

ALTER TABLE equipment
    ADD CHECK ( mixing_console IN ( 'API', 'AVID', 'NEVE', 'SSL' ) );

ALTER TABLE equipment
    ADD CHECK ( monitors IN ( 'Adam', 'Barefoot', 'Dynaudio', 'Focal', 'Genelec') );

ALTER TABLE equipment
    ADD CHECK ( daw IN ( 'Ableton', 'Cubase', 'Logic', 'ProTools' ) );

ALTER TABLE equipment
    ADD CHECK ( vocal_mic IN ( 'AKG', 'Neumann', 'Shure', 'Sony' ) );

ALTER TABLE equipment
    ADD CONSTRAINT equipment_pk PRIMARY KEY ( equipment_code,
                                              rooms_room_code,
                                              ro_rec_stu_code );
ALTER TABLE equipment
    ADD CONSTRAINT equipment_rooms_fk FOREIGN KEY ( rooms_room_code,
                                                    ro_rec_stu_code )
        REFERENCES rooms ( room_code,
                           recording_studios_studio_code )
            ON DELETE CASCADE;

alter session set "_partition_large_extents"= false;