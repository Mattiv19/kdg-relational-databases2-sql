CREATE OR REPLACE PACKAGE BODY PKG_recordingstudios
AS
    -- PRIVATE HELP FUNCTIONS M4 --
    -- Lookup functions --
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
        WHERE UPPER(name) = p_artist_name;

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
        WHERE UPPER(studio_name) = p_studio_name;

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
        WHERE UPPER(room_name) = p_room_name;

        RETURN lo_room_code;
    END lookup_room;

    -- PRIVATE FUNCTIONS M5
    -- Random Functions M5 --
    FUNCTION random_number
        (p_min  NUMERIC,
         p_max  NUMERIC)
        RETURN NUMERIC
    AS
        BEGIN
            RETURN TRUNC(DBMS_RANDOM.VALUE(p_min,p_max));
        END random_number;

    FUNCTION random_date
        (p_from  DATE,
         p_till  DATE)
        RETURN DATE
    AS
        ln_range NUMERIC;
        ln_datepick NUMERIC;
        BEGIN
            ln_range := p_till-p_from;
            ln_datepick := random_number(0, ln_range);
            RETURN p_from+ln_datepick;
        END random_date;

    FUNCTION random_music_genre
        RETURN artists.music_genre%TYPE
        IS
        TYPE type_varray_type IS VARRAY(7) OF VARCHAR2(30);
        t_type type_varray_type  := type_varray_type('Pop', 'Techno', 'House','Disco', 'Rap', 'Rock', 'Jazz');
        BEGIN
            RETURN t_type(random_number(1,t_type.COUNT));
        END random_music_genre;

    FUNCTION random_profession
        RETURN artists.profession%TYPE
        IS
        TYPE type_varray_type IS VARRAY (5) OF VARCHAR2(50);
        t_type type_varray_type := type_varray_type('Singer', 'Producer', 'Instrumentalist', 'Audio engineer', 'Composer');
        BEGIN
            RETURN t_type(random_number(1, t_type.COUNT));
        END random_profession;

    FUNCTION random_phonenumber
        RETURN NUMBER
        IS
        v_start_number  NUMBER(9);
        v_random_phone  NUMBER(7);
        v_phonenumber   NUMBER(9);
        BEGIN
            IF random_number(0,1) <  0.5 THEN
                v_start_number := 470000000;
            ELSE
                v_start_number := 4900000000;
            END if;

            v_random_phone := TRUNC(random_number(1000000,9999999));

            v_phonenumber := v_start_number + v_random_phone;

            RETURN v_phonenumber;
        END random_phonenumber;

    FUNCTION random_straat
        RETURN VARCHAR2
        IS
        TYPE type_varray_type IS VARRAY (20) OF VARCHAR(39);
        t_type type_varray_type := type_varray_type('Molen', 'Kerk', 'Nieuw', 'School', 'Veld', 'Station', 'Kapel', 'Diamant', 'Heide', 'Koning', 'Prins', 'Winkel', 'Schelde', 'Hoeve', 'Beek', 'Appel', 'Sint-Jozef', 'Maria',  'Zand', 'Muziek');
        v_random_straat VARCHAR2(45);
        BEGIN
            v_random_straat := t_type(random_number(1, t_type.COUNT)) || 'straat';
            RETURN v_random_straat;
        END random_straat;

    FUNCTION random_location
        RETURN recording_studios.location%TYPE
        IS
        TYPE type_varray_type IS VARRAY (20) OF VARCHAR2(50);
        t_type type_varray_type := type_varray_type('ANTWERPEN', 'BRUSSEL', 'GENT', 'BRUGGE', 'HASSELT', 'GENK', 'WIJNEGEM', 'KORTRIJK', 'GERAARDSBERGEN', 'MECHELEN', 'LIER', 'KNOKKE', 'LEUVEN', 'SINT-NIKLAAS', 'LUIK', 'AALST', 'HERENTALS', 'TURNHOUT', 'AARSCHOT', 'MORTSEL');
        BEGIN
            RETURN t_type(random_number(1, t_type.COUNT));
        END random_location;

    FUNCTION random_artistname
        RETURN ARTISTS.name%TYPE
    AS
        TYPE t_artistnames IS TABLE OF ARTISTS.name%TYPE;
            v_artistnames   t_artistnames;
            v_artistname    ARTISTS.name%TYPE;
    BEGIN
        SELECT NAME BULK COLLECT INTO v_artistnames FROM ARTISTS;
        v_artistname := random_number(1, v_artistnames.COUNT);
        RETURN v_artistnames(v_artistname);
     END random_artistname;

    FUNCTION random_studio_name
        RETURN RECORDING_STUDIOS.studio_name%TYPE
    AS
        TYPE t_studio_names IS TABLE OF RECORDING_STUDIOS.studio_name%TYPE;
        v_studio_names   t_studio_names;
        v_studio_name    RECORDING_STUDIOS.studio_name%TYPE;
    BEGIN
        SELECT STUDIO_NAME BULK COLLECT INTO v_studio_names FROM RECORDING_STUDIOS;
        v_studio_name := random_number(1, v_studio_names.COUNT);
        RETURN v_studio_names(v_studio_name);
    END random_studio_name;


    -- PUBLIC FUNCTIONS --
    -- Procedures M4 --

    PROCEDURE empty_tables
    AS
    BEGIN
            EXECUTE IMMEDIATE 'TRUNCATE TABLE ARTISTS_RECSTUDIOS_RELATION';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE BOOKINGS';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE EQUIPMENT';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE ROOMS';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE ARTISTS';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE RECORDING_STUDIOS';

            EXECUTE IMMEDIATE 'ALTER TABLE BOOKINGS MODIFY RES_CODE GENERATED ALWAYS AS IDENTITY (START WITH 1)';
            EXECUTE IMMEDIATE 'ALTER TABLE ROOMS MODIFY ROOM_CODE GENERATED ALWAYS AS IDENTITY (START WITH 1)';
            EXECUTE IMMEDIATE 'ALTER TABLE ARTISTS MODIFY ARTIST_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
            EXECUTE IMMEDIATE 'ALTER TABLE RECORDING_STUDIOS MODIFY STUDIO_CODE GENERATED ALWAYS AS IDENTITY (START WITH 1)';
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
            DBMS_OUTPUT.PUT_LINE('The artist with the name ' || p_artist_name || ' was successfully added to the database.');
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
            DBMS_OUTPUT.PUT_LINE('Recording studio ' || p_studio_name || ' was successfully added to the database.');
        END add_recording_studio;

    PROCEDURE add_room
    (
        p_room_name         rooms.room_name%TYPE,
        p_area_insqm        rooms.area_insqm%TYPE,
        p_costperhour       rooms.costperhour%TYPE,
        p_singer_booth      rooms.singer_booth%TYPE,
        p_instr_rec_booth   rooms.instr_rec_booth%TYPE,
        p_recstudio_name    recording_studios.studio_name%TYPE)
    AS
        v_studio_id RECORDING_STUDIOS.studio_code%TYPE;
        BEGIN
            v_studio_id := lookup_recording_studio(p_recstudio_name);
            INSERT INTO ROOMS (ROOM_NAME, AREA_INSQM, COSTPERHOUR, SINGER_BOOTH, INSTR_REC_BOOTH, RECORDING_STUDIOS_STUDIO_CODE)
            VALUES (p_room_name, p_area_insqm, p_costperhour, p_singer_booth, p_instr_rec_booth, v_studio_id);
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('The room with name ' || p_room_name || ' was added successfully to the database.');
        END add_room;

    PROCEDURE add_equipment
    (   p_mixing_console    equipment.mixing_console%TYPE,
        p_monitors          equipment.monitors%TYPE,
        p_hardware          equipment.hardware%TYPE,
        p_daw               equipment.daw%TYPE,
        p_software          equipment.software%TYPE,
        p_synths            equipment.synths%TYPE,
        p_vocal_mic         equipment.vocal_mic%TYPE,
        p_room_name         rooms.room_name%TYPE,
        p_rec_stu_name      recording_studios.studio_name%TYPE)
    AS
        v_room_id ROOMS.room_code%TYPE;
        v_recstu_id RECORDING_STUDIOS.studio_code%TYPE;
        BEGIN
            v_room_id := lookup_room(p_room_name);
            v_recstu_id := lookup_recording_studio(p_rec_stu_name);
            INSERT INTO EQUIPMENT(mixing_console, monitors, hardware, daw, software, synths, vocal_mic, rooms_room_code, ro_rec_stu_code)
            VALUES (p_mixing_console, p_monitors, p_hardware, p_daw, p_software, p_synths, p_vocal_mic, v_room_id, v_recstu_id);
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('The equipment was added successfully to the database.');
        END add_equipment;

    PROCEDURE add_booking
    (   p_res_date      bookings.res_date%TYPE,
        p_start_hour    bookings.start_hour%TYPE,
        p_end_hour      bookings.end_hour%TYPE,
        p_artist_name   artists.name%TYPE,
        p_room_name     rooms.room_name%TYPE,
        p_studio_name   recording_studios.studio_name%TYPE)
    AS
        v_room_id ROOMS.room_code%TYPE;
        v_recstu_id RECORDING_STUDIOS.studio_code%TYPE;
        v_artist_id ARTISTS.artist_id%TYPE;
        BEGIN
            v_room_id := lookup_room(p_room_name);
            v_recstu_id := lookup_recording_studio(p_studio_name);
            v_artist_id := lookup_artist(p_artist_name);
            INSERT INTO BOOKINGS (RES_DATE, START_HOUR, END_HOUR, ARTISTS_ARTIST_ID, ROOMS_ROOM_CODE, ROOMS_STUDIO_CODE)
            VALUES (p_res_date, p_start_hour, p_end_hour,v_artist_id, v_room_id, v_recstu_id);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('The booking was successfully registered in the database.');
        END add_booking;

    PROCEDURE add_artist_recstudio_rel
    (        p_artist_name   artists.name%TYPE,
             p_studio_name   recording_studios.studio_name%TYPE)
    AS
        v_recstu_id RECORDING_STUDIOS.studio_code%TYPE;
        v_artist_id ARTISTS.artist_id%TYPE;
        BEGIN
            v_recstu_id := lookup_recording_studio(p_studio_name);
            v_artist_id := lookup_artist(p_artist_name);
            INSERT INTO ARTISTS_RECSTUDIOS_RELATION (A_ARTIST_ID, RS_STUDIO_CODE)
            VALUES (v_artist_id, v_recstu_id);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('The artist was successfully linked to the recording studio.');
        END add_artist_recstudio_rel;

    -- Procedures M5
    PROCEDURE generate_random_artist(
        p_count IN NUMBER DEFAULT 1
    )
    AS
        v_artist_name   artists.name%TYPE;
        v_music_genre   artists.music_genre%TYPE;
        v_profession    artists.profession%TYPE;
        v_birth_date    artists.birth_date%TYPE;
        v_phone_artist  artists.phone_artist%TYPE;
        v_email_artist  artists.email_artist%TYPE;
    BEGIN
        FOR i in 1 ..p_count
            LOOP
                v_artist_name := 'Artist' || i;
                v_music_genre := random_music_genre();
                v_profession := random_profession();
                v_birth_date := random_date('01-01-1958',SYSDATE - INTERVAL '18' YEAR);
                v_phone_artist := random_phonenumber();
                v_email_artist := v_artist_name || '@gmail.com';

                add_artist(v_artist_name,
                    v_music_genre,
                    v_profession,
                    v_birth_date,
                    v_phone_artist,
                    v_email_artist);
            END LOOP;
    END generate_random_artist;


    PROCEDURE generate_random_recordingstudio(
        p_count IN NUMBER DEFAULT 1
    )
    AS
        v_studio_name       recording_studios.studio_name%TYPE;
        v_address           recording_studios.address%TYPE;
        v_location          recording_studios.location%TYPE;
        v_phone_studio      recording_studios.phone_studio%TYPE;
        v_email_studio      recording_studios.email_studio%TYPE;
        v_local_engineer    recording_studios.local_engineer%TYPE;
    BEGIN
        FOR i in 1 ..p_count
            LOOP
                v_studio_name := 'Recording_Studio'  || i;
                v_address := random_straat() || ' ' || random_number(1,200);
                v_location := random_location();
                v_phone_studio := random_phonenumber();
                v_email_studio := v_studio_name || '@gmail.com';
                v_local_engineer := random_number(0,1);

                add_recording_studio(v_studio_name,
                    v_address,
                    v_location,
                    v_phone_studio,
                    v_email_studio,
                    v_local_engineer
                    );
            END LOOP;

        END generate_random_recordingstudio;

    PROCEDURE generate_random_relation(
        p_count IN NUMBER DEFAULT 1
    )
    AS
        v_artistname    artists.name%TYPE;
        v_studioname    recording_studios.studio_name%TYPE;
    BEGIN
        FOR i IN 1 .. p_count
            LOOP
                v_artistname := random_artistname();
                v_studioname := random_studio_name();

                add_artist_recstudio_rel(v_artistname, v_studioname);
            END LOOP;
    END generate_random_relation;


    PROCEDURE generate_Many_to_Many(
        p_amount_artists            IN NUMBER DEFAULT 1,
        p_amount_recording_studios  IN NUMBER DEFAULT 1,
        p_amount_relations          IN NUMBER DEFAULT 1
    )
    AS
        ts1 timestamp;
        ts2 timestamp;
    BEGIN
        ts1 := SYSTIMESTAMP;
        DBMS_OUTPUT.PUT_LINE('4 - Starting Many-to_Many generation: generate_Many_to_Many('|| p_amount_artists || ',' || p_amount_recording_studios || ',' || p_amount_relations || ')');

        generate_random_artist(p_amount_artists);
        DBMS_OUTPUT.PUT_LINE('4.1 - generate_random_player(' || p_amount_artists || ')');
        generate_random_recordingstudio(p_amount_recording_studios);
        DBMS_OUTPUT.PUT_LINE('4.2 - generate_random_recordingstudio(' || p_amount_recording_studios || ')');
        generate_random_relation(p_amount_relations);
        DBMS_OUTPUT.PUT_LINE('4.3 - generate_random_relation(' || p_amount_recording_studios || ')');

        ts2 := SYSTIMESTAMP;
        DBMS_OUTPUT.PUT_LINE('The duration of generate_Many_to_Many was: ' || TO_CHAR(ts2 - ts1, 'SSSS.FF'));

    END generate_Many_to_Many;

END PKG_recordingstudios;

