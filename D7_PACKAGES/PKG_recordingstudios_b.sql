CREATE OR REPLACE PACKAGE BODY PKG_recordingstudios
AS
    -------------------------------
        -- PRIVATE FUNCTIONS --
    -------------------------------
    -- Lookup functions M4 --

    FUNCTION lookup_artist
    (   p_artist_name   artists.name%TYPE)
        RETURN INTEGER
    AS
        lo_artist_id INTEGER;
    BEGIN
        SELECT artist_id
        INTO lo_artist_id
        FROM ARTISTS
        WHERE UPPER(name) = UPPER(p_artist_name);

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
        WHERE UPPER(studio_name) = UPPER(p_studio_name);

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
        WHERE UPPER(room_name) = UPPER(p_room_name);

        RETURN lo_room_code;
    END lookup_room;

    FUNCTION lookup_recording_studio_room
    (p_room_name    rooms.room_name%TYPE)
        RETURN INTEGER
    AS
        lo_studio_code_room INTEGER;
    BEGIN
        SELECT RECORDING_STUDIOS_STUDIO_CODE
        INTO lo_studio_code_room
        FROM ROOMS
        WHERE UPPER(ROOM_NAME) = UPPER(p_room_name);

        RETURN  lo_studio_code_room;
    END lookup_recording_studio_room;

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

    FUNCTION random_mixing_console
        RETURN equipment.mixing_console%TYPE
        IS
        TYPE type_varray_type IS VARRAY (4) OF VARCHAR2(4);
        t_type type_varray_type := type_varray_type('API', 'AVID', 'NEVE', 'SSL');
    BEGIN
        RETURN t_type(random_number(1, t_type.COUNT));
    END random_mixing_console;

    FUNCTION random_monitors
        RETURN equipment.monitors%TYPE
        IS
        TYPE type_varray_type IS VARRAY (5) OF VARCHAR2(10);
        t_type type_varray_type := type_varray_type('Adam', 'Barefoot', 'Dynaudio', 'Focal', 'Genelec');
    BEGIN
        RETURN t_type(random_number(1, t_type.COUNT));
    END random_monitors;

    FUNCTION random_hardware
        RETURN equipment.hardware%TYPE
        IS
        TYPE type_varray_type IS VARRAY (6) OF VARCHAR2(50);
        t_type type_varray_type := type_varray_type('Universal Audio', 'LA-2A compressor', '1176 compressor', 'Distressor', 'Fairchild compressors', 'Pultec');
    BEGIN
        RETURN t_type(random_number(1, t_type.COUNT));
    END random_hardware;

    FUNCTION random_DAW
        RETURN equipment.DAW%TYPE
        IS
        TYPE type_varray_type IS VARRAY (4) OF VARCHAR2(10);
        t_type type_varray_type := type_varray_type('Ableton', 'Cubase', 'Logic', 'ProTools');
    BEGIN
        RETURN t_type(random_number(1, t_type.COUNT));
    END random_DAW;

    FUNCTION random_software
        RETURN equipment.software%TYPE
        IS
        TYPE type_varray_type IS VARRAY (6) OF VARCHAR2(50);
        t_type type_varray_type := type_varray_type('Melodyne', 'FabFilter Bundle', 'UAD Bundle', 'Waves Bundle', 'iZotope Bundle');
    BEGIN
        RETURN t_type(random_number(1, t_type.COUNT));
    END random_software;

    FUNCTION random_synths
        RETURN equipment.synths%TYPE
        IS
        TYPE type_varray_type IS VARRAY (6) OF VARCHAR2(50);
        t_type type_varray_type := type_varray_type('Moog', 'Roland', 'Prophet', 'Oberheimer', 'Nord Lead', 'Yamaha');
    BEGIN
        RETURN t_type(random_number(1, t_type.COUNT));
    END random_synths;

    FUNCTION random_vocal_mic
        RETURN equipment.vocal_mic%TYPE
        IS
        TYPE type_varray_type IS VARRAY (4) OF VARCHAR2(10);
        t_type type_varray_type := type_varray_type('AKG', 'Neumann', 'Shure', 'Sony');
    BEGIN
        RETURN t_type(random_number(1, t_type.COUNT));
    END random_vocal_mic;

    FUNCTION random_artistname
        RETURN STRING
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
        RETURN STRING
    AS
        TYPE t_studio_names IS TABLE OF RECORDING_STUDIOS.studio_name%TYPE;
        v_studio_names   t_studio_names;
        v_studio_name    RECORDING_STUDIOS.studio_name%TYPE;
    BEGIN
        SELECT STUDIO_NAME BULK COLLECT INTO v_studio_names FROM RECORDING_STUDIOS;
        v_studio_name := random_number(1, v_studio_names.COUNT);
        RETURN v_studio_names(v_studio_name);
    END random_studio_name;

    FUNCTION random_room_name
        RETURN ROOMS.room_name%TYPE
    AS
        TYPE t_room_names IS TABLE OF ROOMS.room_name%TYPE;
        v_room_names    t_room_names;
        v_room_name     ROOMS.room_name%TYPE;
    BEGIN
        SELECT ROOM_NAME BULK COLLECT INTO v_room_names FROM ROOMS;
        v_room_name := random_number(1, v_room_names.COUNT);
        RETURN v_room_names(v_room_name);
    END random_room_name;

    FUNCTION recording_studios_count
        RETURN INTEGER
    AS
        TYPE t_studio_id IS TABLE OF recording_studios.studio_code%TYPE;
        v_studio_id  t_studio_id;
    BEGIN
        SELECT studio_code BULK COLLECT INTO v_studio_id FROM recording_studios;
        RETURN v_studio_id.COUNT;
    END recording_studios_count ;

    ------------------------------
        -- PRIVATE PROCEDURES --
    ------------------------------

    -- Add procedures M4 --

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
        -- DBMS_OUTPUT.PUT_LINE('The artist with the name ' || p_artist_name || ' was successfully added to the database.');
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
        -- DBMS_OUTPUT.PUT_LINE('Recording studio ' || p_studio_name || ' was successfully added to the database.');
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
        -- DBMS_OUTPUT.PUT_LINE('The room with name ' || p_room_name || ' was added successfully to the database.');
    END add_room;

    PROCEDURE add_equipment
    (   p_rentperhour       equipment.rentperhour%TYPE, --M6
        p_equipmentname     equipment.equipmentname%TYPE,
        p_mixing_console    equipment.mixing_console%TYPE,
        p_monitors          equipment.monitors%TYPE,
        p_hardware          equipment.hardware%TYPE,
        p_daw               equipment.daw%TYPE,
        p_software          equipment.software%TYPE,
        p_synths            equipment.synths%TYPE,
        p_vocal_mic         equipment.vocal_mic%TYPE,
        p_room_name         rooms.room_name%TYPE)
    AS
        v_room_id ROOMS.room_code%TYPE;
        v_recstu_id ROOMS.RECORDING_STUDIOS_STUDIO_CODE%TYPE;
    BEGIN
        -- DBMS_OUTPUT.PUT_LINE(p_room_name);
        -- DBMS_OUTPUT.PUT_LINE(p_rec_stu_name);
        v_room_id := lookup_room(p_room_name);
        -- DBMS_OUTPUT.PUT_LINE(v_room_id);
        v_recstu_id := lookup_recording_studio_room(p_room_name);
        -- DBMS_OUTPUT.PUT_LINE(v_recstu_id);
        INSERT INTO EQUIPMENT(rentperhour,equipmentname, mixing_console, monitors, hardware, daw, software, synths, vocal_mic, rooms_room_code, ro_rec_stu_code)
        VALUES (p_rentperhour, p_equipmentname, p_mixing_console, p_monitors, p_hardware, p_daw, p_software, p_synths, p_vocal_mic, v_room_id, v_recstu_id);
        COMMIT;
        -- DBMS_OUTPUT.PUT_LINE('The equipment was added successfully to the database.');
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
        --  DBMS_OUTPUT.PUT_LINE('The booking was successfully registered in the database.');
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
        -- DBMS_OUTPUT.PUT_LINE('The artist was successfully linked to the recording studio.');
    END add_artist_recstudio_rel;

    -- Add procedures bulk M7
    -- already bulk procedures applied in M5

    -- Generate procedures M5 --

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
                v_artist_name := 'Artist_' || i;
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
                v_studio_name := 'Recording_Studio_'  || i;
                v_address := random_straat() || ' ' || random_number(1,200);
                v_location := random_location();
                v_phone_studio := random_phonenumber();
                v_email_studio := v_studio_name || '@gmail.com';
                v_local_engineer := random_number(0,2);

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
                -- DBMS_OUTPUT.PUT_LINE(v_artistname);
                v_studioname := random_studio_name();
                -- DBMS_OUTPUT.PUT_LINE(v_studioname);
                add_artist_recstudio_rel(v_artistname, v_studioname);
            END LOOP;
    END generate_random_relation;

    PROCEDURE generate_random_room(
        p_count IN NUMBER DEFAULT 1
    )
    AS
        v_studiocount       INTEGER;
        v_room_name         rooms.room_name%TYPE;
        v_area_insqm        rooms.area_insqm%TYPE;
        v_costperhour       rooms.costperhour%TYPE;
        v_singer_booth      rooms.singer_booth%TYPE;
        v_instr_rec_booth   rooms.instr_rec_booth%TYPE;
        v_recstudio_name    recording_studios.studio_name%TYPE;
        v_count             NUMBER  := 0;
    BEGIN
        v_studiocount := recording_studios_count();
        FOR i IN 1 .. v_studiocount
            LOOP
                FOR j in 1 ..p_count
                    LOOP
                        v_room_name := 'Room_' || i || '_'|| j;
                        v_area_insqm := random_number(1000, 49999)/100;
                        v_costperhour := random_number(10, 199);
                        -- DBMS_OUTPUT.PUT_LINE(v_costperhour);
                        v_singer_booth := random_number(0,2);
                        v_instr_rec_booth := random_number(0,2);
                        v_recstudio_name := random_studio_name();

                        add_room(v_room_name,
                                 v_area_insqm,
                                 v_costperhour,
                                 v_singer_booth,
                                 v_instr_rec_booth,
                                 v_recstudio_name);
                        v_count := v_count +1;
                    END LOOP;
            END LOOP;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || 'Generate rooms(' || p_count || ') generated ' || v_count || ' rows.');
    END generate_random_room;

    PROCEDURE generate_random_equipment(
        p_count_equipment IN NUMBER DEFAULT 1,
        p_count_rooms IN NUMBER DEFAULT 1
    )
    AS
        TYPE type_room_name IS TABLE OF rooms.room_name%TYPE
            INDEX BY PLS_INTEGER;
        TYPE type_studio_name IS TABLE OF recording_studios.studio_name%TYPE;
        v_room_names         type_room_name;
        v_studio_names       type_studio_name;
        v_rentperhour       equipment.rentperhour%TYPE;
        v_equipmentname     equipment.equipmentname%TYPE;
        v_mixing_console    equipment.mixing_console%TYPE;
        v_monitors          equipment.monitors%TYPE;
        v_hardware          equipment.hardware%TYPE;
        v_daw               equipment.daw%TYPE;
        v_software          equipment.software%TYPE;
        v_synths            equipment.synths%TYPE;
        v_vocal_mic         equipment.vocal_mic%TYPE;
        v_room_name         rooms.room_name%TYPE;
        v_rec_stu_name      recording_studios.studio_name%TYPE;
        v_count             NUMBER := 0;
    BEGIN
        SELECT room_name BULK COLLECT INTO v_room_names FROM ROOMS;
        SELECT studio_name BULK COLLECT INTO v_studio_names FROM RECORDING_STUDIOS;

        FOR i IN 1 .. v_studio_names.COUNT
            LOOP
                FOR j IN 1 .. p_count_rooms
                    LOOP
                        FOR z in 1 ..p_count_equipment
                            LOOP
                                v_rentperhour := random_number(10,199);
                                v_equipmentname := 'Equipment_' || i || '_' || j || '_' || z;
                                v_mixing_console := random_mixing_console();
                                -- DBMS_OUTPUT.PUT_LINE(v_mixing_console);
                                v_monitors := random_monitors();
                                -- DBMS_OUTPUT.PUT_LINE(v_monitors);
                                v_hardware := random_hardware() || ', ' || random_hardware();
                                -- DBMS_OUTPUT.PUT_LINE(v_hardware);
                                v_daw := random_DAW();
                                -- DBMS_OUTPUT.PUT_LINE(v_daw);
                                v_software := random_software() || ',' || random_software() ||  ',' || random_software();
                                -- DBMS_OUTPUT.PUT_LINE(v_software);
                                v_synths := random_synths() || ', ' || random_synths() || ', ' || random_synths();
                                -- DBMS_OUTPUT.PUT_LINE(v_synths);
                                v_vocal_mic := random_vocal_mic();
                                -- DBMS_OUTPUT.PUT_LINE(v_vocal_mic);
                                v_room_name := random_room_name();
                                -- DBMS_OUTPUT.PUT_LINE(v_room_name);
                                v_rec_stu_name := lookup_recording_studio_room(v_room_name);
                                -- DBMS_OUTPUT.PUT_LINE(v_rec_stu_name);

                                add_equipment(v_rentperhour,
                                              v_equipmentname,
                                              v_mixing_console,
                                              v_monitors,
                                              v_hardware,
                                              v_daw,
                                              v_software,
                                              v_synths,
                                              v_vocal_mic,
                                              v_room_name);
                                v_count := v_count + 1;
                            END LOOP;
                    END LOOP;
            END LOOP;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || 'Generate equipment(' || p_count_equipment || ') generated ' || v_count || ' rows.');
    END generate_random_equipment;

    -------------------------------
    -- PUBLIC FUNCTIONS --
    -------------------------------

    PROCEDURE generate_many_to_many(
        p_amount_artists            IN NUMBER DEFAULT 1,
        p_amount_recording_studios  IN NUMBER DEFAULT 1,
        p_amount_relations          IN NUMBER DEFAULT 1
    )
    AS
        ts1 timestamp;
        ts2 timestamp;
    BEGIN
        ts1 := SYSTIMESTAMP;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || '4 - Starting Many-to_Many generation: generate_many_to_many('|| p_amount_artists || ', ' || p_amount_recording_studios || ', ' || p_amount_relations || ')');

        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || '4.1 - generate_random_artist(' || p_amount_artists || ')');
        generate_random_artist(p_amount_artists);
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || '4.2 - generate_random_recordingstudio(' || p_amount_recording_studios || ')');
        generate_random_recordingstudio(p_amount_recording_studios);
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || '4.3 - generate_random_relation(' || p_amount_recording_studios || ')');
        generate_random_relation(p_amount_relations);


        ts2 := SYSTIMESTAMP;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || 'The duration of generate_Many_to_Many was: ' || TO_CHAR(ts2 - ts1, 'SSSS.FF'));

    END generate_many_to_many;

    PROCEDURE generate_2_levels(
        p_amount_recording_studios  IN NUMBER DEFAULT 1,
        p_amount_rooms              IN NUMBER DEFAULT 1,
        P_amount_equipment          IN NUMBER DEFAULT 1
    )
    AS
        v_recstudio_count   INTEGER;
        ts1 timestamp;
        ts2 timestamp;
    BEGIN
        ts1 := SYSTIMESTAMP;
        dbms_output.put_line(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || 'Start time is ' || ts1);
        v_recstudio_count := recording_studios_count();
        dbms_output.put_line(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || 'Studio count is ' || v_recstudio_count);
        dbms_output.put_line(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || '4 - Starting generate_2_levels: generate_2_levels(' || p_amount_recording_studios || ',' ||  p_amount_rooms || ',' || p_amount_equipment || ')');

        IF v_recstudio_count >= p_amount_recording_studios THEN
            dbms_output.put_line(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || 'We already have '  || v_recstudio_count || ' studios in the database --> Skip generate studios');
        ELSE
            generate_random_recordingstudio((p_amount_recording_studios - v_recstudio_count));
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || '4.1 - generate_random_recordingstudio(' || (p_amount_recording_studios - v_recstudio_count) || ')');
        END IF;
        generate_random_room(p_amount_rooms);
        generate_random_equipment(p_amount_equipment, p_amount_rooms);

        ts2 := SYSTIMESTAMP;
        dbms_output.put_line(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || 'The duration of generate_2_levels was: ' || TO_CHAR(ts2 - ts1, 'SSSS.FF'));

    END generate_2_levels;

    --  M4 --
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

    PROCEDURE manueel_m4
    AS
    BEGIN
        PKG_recordingstudios.ADD_ARTIST('The Weeknd', 'Pop', 'Singer', TO_DATE('16-02-1990'), 0478031245, 'theweeknd@gmail.com');
        PKG_RECORDINGSTUDIOS.ADD_ARTIST('Reinier Zonneveld', 'Techno', 'Producer', TO_DATE('30-01-1991'), 0499021456, 'reinier.zonneveld@gmail.com');
        PKG_RECORDINGSTUDIOS.ADD_ARTIST('Eli Brown', 'Techno', 'Producer', TO_DATE('12-09-1989'), 0497032848, 'elibrown@gmail.com');
        PKG_RECORDINGSTUDIOS.ADD_ARTIST('SG Lewis', 'Pop', 'Singer', TO_DATE('09-04-1994'), 0476149593, 'sglewis@gmail.com');
        PKG_RECORDINGSTUDIOS.ADD_ARTIST('Drake', 'Rap', 'Singer', TO_DATE('24-10-1986'), 0499375382, 'contact@drake.com');

        PKG_RECORDINGSTUDIOS.ADD_RECORDING_STUDIO('Abbey Road', 'Italiëlei 2','ANTWERPEN', 0475021343, 'abbeyroad@gmail.com', 1);
        PKG_RECORDINGSTUDIOS.ADD_RECORDING_STUDIO('The Warehouse Studios', 'Merksemsebaan 179','WIJNEGEM', 0498931988, 'warehousestudios@outlook.com', 0);
        PKG_RECORDINGSTUDIOS.ADD_RECORDING_STUDIO('Drumcode Studios', 'Koningstraat 14','GENT', 0499195183, 'info@drumcode.com', 1);
        PKG_RECORDINGSTUDIOS.ADD_RECORDING_STUDIO('Valhalla Recording Studios', 'Palmstraat 32','HASSELT', 0478392935, 'record@valhallastudios.com', 0);
        PKG_RECORDINGSTUDIOS.ADD_RECORDING_STUDIO('Universal Studios', 'Rue Picard 7','BRUSSEL', 027758140, 'contact@universalmusic.be', 1);

        PKG_RECORDINGSTUDIOS.ADD_ROOM('Road Prince', 45.12, 100, 1, 1,'ABBEY ROAD');
        PKG_RECORDINGSTUDIOS.ADD_ROOM('Filth On Acid', 34.35, 75, 0, 0, 'THE WAREHOUSE STUDIOS');
        PKG_RECORDINGSTUDIOS.ADD_ROOM('Beyer', 23.76, 65, 0, 0,'DRUMCODE STUDIOS');
        PKG_RECORDINGSTUDIOS.ADD_ROOM('Atlantis', 92.52, 135, 1, 1, 'VALHALLA RECORDING STUDIOS');
        PKG_RECORDINGSTUDIOS.ADD_ROOM('Michael',103.59, 185, 1, 1, 'UNIVERSAL STUDIOS');

        PKG_RECORDINGSTUDIOS.ADD_EQUIPMENT(53, 'equipment_001','SSL', 'Dynaudio', 'LA-2A compressor, 1176 compressor, Pultec', 'ProTools', 'Melodyne, Fabfilter Bundle, iZotope Bundle', 'Moog, Roland, Nord Lead', 'Neumann', 'ROAD PRINCE');
        PKG_RECORDINGSTUDIOS.ADD_EQUIPMENT(76,'equipment_002','NEVE', 'Barefoot', 'Distressor, Universal Audio', 'Ableton', 'UAD Bundle, Fabfilter Bundle, Waves Bundle', 'Moog, Roland', 'Shure', 'FILTH ON ACID');
        PKG_RECORDINGSTUDIOS.ADD_EQUIPMENT(105,'equipment_003','AVID', 'Adam', 'Distressor, Fairchild compressors, Pultec', 'Ableton', 'iZotope Bundle, Waves Bundle, Fabfilter Bundle', 'Roland, Prophet', NULL, 'BEYER');
        PKG_RECORDINGSTUDIOS.ADD_EQUIPMENT(127,'equipment_004', 'API', 'Focal', 'LA-2A compressor, 1176 compressor, Fairchild comp', 'Logic', 'Melodyne, Waves Bundle, iZotope Bundle', 'Nord Lead, Prophet, Oberheimer, Moog, Roland','Sony', 'ATLANTIS');
        PKG_RECORDINGSTUDIOS.ADD_EQUIPMENT(178,'equipment_005','SSL', 'Genelec', 'LA-2A compressor, Universal Audio, 1176 compressor', 'ProTools', 'Melodyne, UAD Bundle, iZotope Bundle', 'Nord Lead, Yamaha, Prophet, Moog', 'Neumann', 'MICHAEL');

        PKG_RECORDINGSTUDIOS.ADD_BOOKING(TO_DATE('2023-03-15', 'YYYY-MM-DD'), EXTRACT(HOUR FROM TIMESTAMP '2023-03-15 10:00:00'), EXTRACT(HOUR FROM TIMESTAMP '2023-03-15 12:00:00'), 'THE WEEKND', 'ROAD PRINCE', 'ABBEY ROAD');
        PKG_RECORDINGSTUDIOS.ADD_BOOKING(TO_DATE('2023-04-06', 'YYYY-MM-DD'), EXTRACT(HOUR FROM TIMESTAMP '2023-04-06 13:00:00'), EXTRACT(HOUR FROM TIMESTAMP '2023-04-06 17:00:00'), 'REINIER ZONNEVELD', 'FILTH ON ACID', 'THE WAREHOUSE STUDIOS');
        PKG_RECORDINGSTUDIOS.ADD_BOOKING(TO_DATE('2023-04-13', 'YYYY-MM-DD'), EXTRACT(HOUR FROM TIMESTAMP '2023-04-13 09:00:00'), EXTRACT(HOUR FROM TIMESTAMP '2023-04-13 12:00:00'), 'ELI BROWN', 'BEYER', 'DRUMCODE STUDIOS');
        PKG_RECORDINGSTUDIOS.ADD_BOOKING(TO_DATE('2023-03-28', 'YYYY-MM-DD'), EXTRACT(HOUR FROM TIMESTAMP '2023-03-28 14:00:00'), EXTRACT(HOUR FROM TIMESTAMP '2023-03-28 16:00:00'), 'SG LEWIS', 'ATLANTIS', 'VALHALLA RECORDING STUDIOS');
        PKG_RECORDINGSTUDIOS.ADD_BOOKING(TO_DATE('2023-05-02', 'YYYY-MM-DD'), EXTRACT(HOUR FROM TIMESTAMP '2023-05-02 15:00:00'), EXTRACT(HOUR FROM TIMESTAMP '2023-05-02 18:00:00'), 'DRAKE', 'MICHAEL', 'UNIVERSAL STUDIOS');

        PKG_RECORDINGSTUDIOS.add_artist_recstudio_rel('THE WEEKND','ABBEY ROAD');
        PKG_RECORDINGSTUDIOS.add_artist_recstudio_rel('REINIER ZONNEVELD','THE WAREHOUSE STUDIOS');
        PKG_RECORDINGSTUDIOS.add_artist_recstudio_rel('ELI BROWN','DRUMCODE STUDIOS');
        PKG_RECORDINGSTUDIOS.add_artist_recstudio_rel('SG LEWIS','VALHALLA RECORDING STUDIOS');
        PKG_RECORDINGSTUDIOS.add_artist_recstudio_rel('DRAKE','UNIVERSAL STUDIOS');
    END manueel_m4;

    --  M5 --
    PROCEDURE bewijs_milestone_5
    AS
    BEGIN
        dbms_output.put_line(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || '1 - random nummer teruggeven binnen een nummerbereik.');
        dbms_output.put_line(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || '  random_number(5,25) --> ' || random_number(5,25));
        dbms_output.put_line(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || '2 - random datum binnen een bereik.');
        dbms_output.put_line(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || '  random_date(to_date(''01012015'', ''DDMMYYYY''), sysdate) --> ' || random_date(to_date('01012015', 'DDMMYYYY'), SYSDATE));
        dbms_output.put_line(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || '3 - random tekst string uit een lijst');
        dbms_output.put_line(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') || '  random_music_genre() --> ' || random_music_genre());
        generate_many_to_many(20,20, 50);
        generate_2_levels(20,40,500);
    END bewijs_milestone_5;

    --  M6 --
    PROCEDURE printreport_2_levels_m6(p_x IN NUMBER, p_y IN NUMBER, p_z IN NUMBER)
        IS
        CURSOR cursor_z(p_roomID IN NUMBER) IS
            SELECT equipment_code, r.room_code, equipmentname, rentperhour
            FROM EQUIPMENT e
                     JOIN ROOMS r ON r.ROOM_CODE = e.ROOMS_ROOM_CODE
            WHERE r.ROOM_CODE = p_roomID;
        CURSOR cursor_y(p_studioID IN NUMBER) IS
            SELECT r.room_code, r.room_name, AVG(e.rentperhour) AS "Average Rentperhour / Room"
            FROM ROOMS r
                     JOIN EQUIPMENT e on r.ROOM_CODE = e.ROOMS_ROOM_CODE
                     JOIN RECORDING_STUDIOS s on r.RECORDING_STUDIOS_STUDIO_CODE = s.STUDIO_CODE
            WHERE s.STUDIO_CODE = p_studioID
            GROUP BY r.room_code, r.room_name;
        CURSOR cursor_x IS
            SELECT STUDIO_CODE, STUDIO_NAME, AVG(e.rentperhour) AS "Average Rentperhour / Studio"
            FROM RECORDING_STUDIOS s
                     JOIN ROOMS r ON s.STUDIO_CODE = r.RECORDING_STUDIOS_STUDIO_CODE
                     JOIN EQUIPMENT e ON e.ROOMS_ROOM_CODE = r.ROOM_CODE
            GROUP BY STUDIO_CODE, STUDIO_NAME;

        exc_negative_number EXCEPTION;
    BEGIN
        IF p_x <  0 OR p_y < 0 OR p_z < 0
        THEN
            raise exc_negative_number;
        END IF;
        FOR c_x IN cursor_x
            LOOP
                DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------------');
                DBMS_OUTPUT.PUT_LINE('|      StudioCode       |        Studio_Name      |    Average Rentperhour / Studio    |  ');
                DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------------');
                DBMS_OUTPUT.PUT_LINE('|          ' || c_x.STUDIO_CODE || '           |   ' || c_x.STUDIO_NAME || '   |               ' || round(c_x."Average Rentperhour / Studio", 2) || '              |');
                DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------------');
                FOR c_y IN cursor_y(c_x.STUDIO_CODE)
                    LOOP
                        DBMS_OUTPUT.PUT_LINE('     ');
                        DBMS_OUTPUT.PUT_LINE('|      RoomCode     |        Room_Name      | Average Rentperhour / Room  |');
                        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('|        ' || c_y.ROOM_CODE || '        |       ' || c_y.ROOM_NAME || '       |            ' || round(c_y."Average Rentperhour / Room") || '                | ');
                        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('     ');
                        DBMS_OUTPUT.PUT_LINE('|     EquipmentCode     |      Room_code     |      EquipmentName     |    Rent per hour    |');
                        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------------');
                        FOR c_z IN cursor_z(c_y.ROOM_CODE)
                            LOOP
                                DBMS_OUTPUT.PUT_LINE('|        ' || c_z.EQUIPMENT_CODE || '          |         ' || c_z.ROOM_CODE || '         |     ' || c_z.EQUIPMENTNAME || '   |         ' || c_z.RENTPERHOUR || '         | ');
                                EXIT WHEN cursor_z%rowcount >= p_z;
                            END LOOP;
                        EXIT WHEN cursor_y%rowcount >= p_y;
                        DBMS_OUTPUT.PUT_LINE('     ');
                    END LOOP;
                DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------------------------');
                DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------------------------');
                DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------------------------');
                DBMS_OUTPUT.PUT_LINE('     ');
                DBMS_OUTPUT.PUT_LINE('     ');
                EXIT WHEN cursor_x%rowcount >= p_x;
            END LOOP;
    EXCEPTION
        WHEN exc_negative_number THEN
            DBMS_OUTPUT.PUT_LINE(to_char(systimestamp, '[YYYY-MM-DD HH24:MI:SS]  ') || 'Parameter must be greater than 0, as the system cannot print a negative number of rows.');
    END;

END PKG_recordingstudios;

