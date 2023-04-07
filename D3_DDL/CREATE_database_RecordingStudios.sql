-- Generated by Oracle SQL Developer Data Modeler 22.2.0.165.1149

DROP TABLE artists CASCADE CONSTRAINTS;

DROP TABLE artists_recstudios_relation CASCADE CONSTRAINTS;

DROP TABLE bookings CASCADE CONSTRAINTS;

DROP TABLE equipment CASCADE CONSTRAINTS;

DROP TABLE recording_studios CASCADE CONSTRAINTS;

DROP TABLE rooms CASCADE CONSTRAINTS;

CREATE TABLE artists (
    artist_id    INTEGER GENERATED ALWAYS AS IDENTITY,
    name         VARCHAR2(50 CHAR),
    music_genre  VARCHAR2(30 CHAR),
    profession   VARCHAR2(50 CHAR),
    birth_date   DATE,
    phone_artist NUMBER(10),
    email_artist VARCHAR2(50 CHAR)
);

ALTER TABLE artists
    ADD CONSTRAINT artists_ck_1 CHECK ( length(music_genre) >= 3 );

ALTER TABLE artists ADD CONSTRAINT artists_ck_2 CHECK ( email_artist LIKE '&@&' );

ALTER TABLE artists ADD CONSTRAINT artists_pk PRIMARY KEY ( artist_id );

CREATE TABLE artists_recstudios_relation (
    a_artist_id    INTEGER NOT NULL,
    rs_studio_code INTEGER NOT NULL
);

ALTER TABLE artists_recstudios_relation ADD CONSTRAINT artists_recstudios_relation_pk PRIMARY KEY ( a_artist_id,
                                                                                                    rs_studio_code );

CREATE TABLE bookings (
    res_code          INTEGER GENERATED ALWAYS AS IDENTITY,
    res_date          DATE,
    start_hour        DATE,
    end_hour          DATE,
    artists_artist_id INTEGER NOT NULL,
    rooms_room_code   INTEGER NOT NULL,
    rooms_studio_code INTEGER NOT NULL
);

ALTER TABLE bookings ADD CONSTRAINT bookings_ck_1 CHECK ( end_hour > start_hour );

ALTER TABLE bookings ADD CONSTRAINT bookings_pk PRIMARY KEY ( res_code );

CREATE TABLE equipment (
    equipment_code  INTEGER GENERATED ALWAYS AS IDENTITY,
    mixing_console  VARCHAR2(4 CHAR),
    monitors        VARCHAR2(10 CHAR),
    hardware        VARCHAR2(50),
    daw             VARCHAR2(10 CHAR),
    software        VARCHAR2(50 CHAR),
    synths          VARCHAR2(50 CHAR),
    vocal_mic       VARCHAR2(10),
    rooms_room_code INTEGER NOT NULL,
    ro_rec_stu_code INTEGER NOT NULL
);

ALTER TABLE equipment
    ADD CHECK ( mixing_console IN ( 'API', 'AVID', 'NEVE', 'SSL' ) );

ALTER TABLE equipment
    ADD CHECK ( monitors IN ( 'Adam', 'Barefoot', 'Dynaudio', 'Focal', 'Genelec' ) );

ALTER TABLE equipment
    ADD CHECK ( daw IN ( 'Ableton', 'Cubase', 'Logic', 'ProTools' ) );

ALTER TABLE equipment
    ADD CHECK ( vocal_mic IN ( 'AKG', 'Neumann', 'Shure', 'Sony' ) );

ALTER TABLE equipment
    ADD CONSTRAINT equipment_pk PRIMARY KEY ( equipment_code,
                                              rooms_room_code,
                                              ro_rec_stu_code );

CREATE TABLE recording_studios (
    studio_code    INTEGER GENERATED ALWAYS AS IDENTITY,
    studio_name    VARCHAR2(30 CHAR),
    address        VARCHAR2(80 CHAR),
    location       VARCHAR2(50 CHAR),
    phone_studio   NUMBER(10),
    email_studio   VARCHAR2(50),
    local_engineer NUMBER
);

ALTER TABLE recording_studios
    ADD CHECK ( local_engineer IN ( 'N', 'Y' ) );

ALTER TABLE recording_studios
    ADD CONSTRAINT recording_studios_ck_1 CHECK ( location = upper(location) );

ALTER TABLE recording_studios ADD CONSTRAINT recording_studios_ck_2 CHECK ( email_studio LIKE '%@%' );

ALTER TABLE recording_studios ADD CONSTRAINT recording_studios_pk PRIMARY KEY ( studio_code );

CREATE TABLE rooms (
    room_code                     INTEGER GENERATED ALWAYS AS IDENTITY,
    room_name                     VARCHAR2(20),
    area_insqm                    NUMBER(5, 2),
    costperhour                   NUMBER(3),
    singer_booth                  NUMBER,
    instr_rec_booth               NUMBER,
    recording_studios_studio_code INTEGER NOT NULL
);

ALTER TABLE rooms ADD CHECK ( area_insqm BETWEEN 1 AND 500 );

ALTER TABLE rooms ADD CHECK ( costperhour BETWEEN 1 AND 200 );

ALTER TABLE rooms
    ADD CHECK ( singer_booth IN ( 'N', 'Y' ) );

ALTER TABLE rooms
    ADD CHECK ( instr_rec_booth IN ( 'N', 'Y' ) );

COMMENT ON COLUMN rooms.area_insqm IS
    'Area in square meters';

ALTER TABLE rooms ADD CONSTRAINT rooms_ck_1 CHECK ( area_insqm < 500 );

ALTER TABLE rooms ADD CONSTRAINT rooms_ck_2 CHECK ( costperhour < 200 );

ALTER TABLE rooms ADD CONSTRAINT rooms_pk PRIMARY KEY ( room_code,
                                                        recording_studios_studio_code );

ALTER TABLE artists_recstudios_relation
    ADD CONSTRAINT ar_recstu_rel_artists_fk FOREIGN KEY ( a_artist_id )
        REFERENCES artists ( artist_id );

ALTER TABLE artists_recstudios_relation
    ADD CONSTRAINT ar_recstu_rel_recstu_fk FOREIGN KEY ( rs_studio_code )
        REFERENCES recording_studios ( studio_code );

ALTER TABLE bookings
    ADD CONSTRAINT bookings_artists_fk FOREIGN KEY ( artists_artist_id )
        REFERENCES artists ( artist_id )
            ON DELETE CASCADE;

ALTER TABLE bookings
    ADD CONSTRAINT bookings_rooms_fk FOREIGN KEY ( rooms_room_code,
                                                   rooms_studio_code )
        REFERENCES rooms ( room_code,
                           recording_studios_studio_code )
            ON DELETE CASCADE;

ALTER TABLE equipment
    ADD CONSTRAINT equipment_rooms_fk FOREIGN KEY ( rooms_room_code,
                                                    ro_rec_stu_code )
        REFERENCES rooms ( room_code,
                           recording_studios_studio_code )
            ON DELETE CASCADE;

ALTER TABLE rooms
    ADD CONSTRAINT rooms_recording_studios_fk FOREIGN KEY ( recording_studios_studio_code )
        REFERENCES recording_studios ( studio_code )
            ON DELETE CASCADE;