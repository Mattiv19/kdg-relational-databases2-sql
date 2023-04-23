CREATE OR REPLACE PACKAGE BODY PKG_recordingstudios
AS
    -- Private help functions --
    FUNCTION give_random_recstudio
        RETURN VARCHAR2
    AS
    BEGIN
        RETURN 'Random_recstudio';
    END give_random_recstudio;

    FUNCTION lookup_artist
    (   p_artist_name   artists.name%TYPE)
        RETURN INTEGER
    AS
        lo_artist_id INTEGER;
    BEGIN
        SELECT artist_id
        INTO lo_artist_id
        FROM ARTISTS
        WHERE name = p_artist_name;

        RETURN lo_artist_id;
    END lookup_artist;

    FUNCTION lookup_recording_studio
    (   p_studio_name   recording_studios.studio_name%TYPE)
        RETURN INTEGER
    AS
        lo_studio_code INTEGER;
    BEGIN
        SELECT studio_code
        INTO lo_studio_code
        FROM RECORDING_STUDIOS
        WHERE studio_name = p_studio_name;

        RETURN lo_studio_code;
    END lookup_recording_studio;

    FUNCTION lookup_room
    (   p_room_name     rooms.room_name%TYPE)
        RETURN INTEGER
    AS
        lo_room_code INTEGER;
    BEGIN
        SELECT room_code
        INTO lo_room_code
        FROM ROOMS
        WHERE room_name = p_room_name;

        RETURN lo_room_code;
    END lookup_room;

    -- Public functions --

    PROCEDURE empty_tables
    AS
        BEGIN
            EXECUTE IMMEDIATE 'TRUNCATE TABLE ARTISTS_RECSTUDIOS_RELATION';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE BOOKINGS';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE EQUIPMENT';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE ROOMS';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE ARTISTS';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE RECORDING_STUDIOS';
        END empty_tables;

    PROCEDURE add_artist
    (   p_artist_name   artists.name%TYPE,
        p_music_genre   artists.music_genre%TYPE,
        p_profession    artists.profession%TYPE,
        p_birth_date    artists.birth_date%TYPE,
        p_phone_artist  artists.phone_artist%TYPE,
        p_email_artist  artists.email_artist%TYPE)
    AS
        BEGIN
            INSERT INTO ARTISTS (name, music_genre, profession, birth_date, phone_artist, email_artist)
            VALUES (p_artist_name, p_music_genre, p_profession, p_birth_date, p_phone_artist, p_email_artist);
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('The artist witht the name' || p_artist_name || 'was successfully added to the database.');
        END add_artist;

    PROCEDURE add_recording_studio
    (   p_studio_name       recording_studios.studio_name%TYPE,
        p_address           recording_studios.address%TYPE,
        p_location          recording_studios.location%TYPE,
        p_phone_studio      recording_studios.phone_studio%TYPE,
        p_email_studio      recording_studios.email_studio%TYPE,
        p_local_engineer    recording_studios.local_engineer%TYPE)
    AS
        BEGIN
            INSERT INTO RECORDING_STUDIOS (STUDIO_NAME, ADDRESS, LOCATION, PHONE_STUDIO, EMAIL_STUDIO, LOCAL_ENGINEER)
            VALUES (p_studio_name, p_address, p_location, p_phone_studio, p_email_studio, p_local_engineer);
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Recording studio' || p_studio_name || 'was successfully added to the database.');
        END add_recording_studio;

    PROCEDURE add_room
    (
        p_room_name         rooms.room_name%TYPE,
        p_area_insqm        rooms.area_insqm%TYPE,
        p_costperhour       rooms.costperhour%TYPE,
        p_singer_booth      rooms.singer_booth%TYPE,
        p_instr_rec_booth   rooms.instr_rec_booth%TYPE,
        p_recstudio_name    rooms.recording_studios_studio_code%TYPE)
    AS
        BEGIN
            INSERT INTO ROOMS (ROOM_NAME, AREA_INSQM, COSTPERHOUR, SINGER_BOOTH, INSTR_REC_BOOTH, RECORDING_STUDIOS_STUDIO_CODE)
            VALUES (p_room_name, p_area_insqm, p_costperhour, p_singer_booth, p_instr_rec_booth, lookup_recording_studio(p_recstudio_name));
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('The room with name' || p_room_name || 'was added successfully to the database and linked to correct recording studio.');
        END add_room;

    PROCEDURE add_equipment
    (   p_mixing_console    equipment.mixing_console%TYPE,
        p_monitors          equipment.monitors%TYPE,
        p_hardware          equipment.hardware%TYPE,
        p_daw               equipment.daw%TYPE,
        p_software          equipment.software%TYPE,
        p_synths            equipment.synths%TYPE,
        p_vocal_mic         equipment.vocal_mic%TYPE,
        p_room_code         equipment.rooms_room_code%TYPE,
        p_rec_stu_code      equipment.ro_rec_stu_code%TYPE)
    AS
        BEGIN
            INSERT INTO EQUIPMENT(mixing_console, monitors, hardware, daw, software, synths, vocal_mic, rooms_room_code, ro_rec_stu_code)
            VALUES (p_mixing_console, p_monitors, p_hardware, p_daw, p_software, p_synths, p_vocal_mic, lookup_room(p_room_code), lookup_recording_studio(p_rec_stu_code));
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('The equipment related to the room from a recording studio was added successfully to the database');
        END add_equipment;

    PROCEDURE add_booking
    (   p_res_date      bookings.res_date%TYPE,
        p_start_hour    bookings.start_hour%TYPE,
        p_end_hour      bookings.end_hour%TYPE,
        p_artist_id     bookings.artists_artist_id%TYPE,
        p_room_code     bookings.rooms_room_code%TYPE,
        p_studio_code   bookings.rooms_studio_code%TYPE)
    AS
        BEGIN
            INSERT INTO BOOKINGS (RES_DATE, START_HOUR, END_HOUR, ARTISTS_ARTIST_ID, ROOMS_ROOM_CODE, ROOMS_STUDIO_CODE)
            VALUES (p_res_date, p_start_hour, p_end_hour, lookup_artist(p_artist_id), lookup_room(p_room_code), lookup_recording_studio(p_studio_code));
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('The booking was successfully registered in the database');
        END add_booking;

    PROCEDURE add_artist_recstudio_rel
    (        p_artist_id         ARTISTS_RECSTUDIOS_RELATION.a_artist_id%TYPE,
             p_studio_code       ARTISTS_RECSTUDIOS_RELATION.rs_studio_code%TYPE)
    AS
        BEGIN
            INSERT INTO ARTISTS_RECSTUDIOS_RELATION (A_ARTIST_ID, RS_STUDIO_CODE)
            VALUES (lookup_artist(p_artist_id), lookup_recording_studio(p_studio_code));
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('The artist was successfully linked to the recording studio.');
        END add_artist_recstudio_rel;

END PKG_recordingstudios;

