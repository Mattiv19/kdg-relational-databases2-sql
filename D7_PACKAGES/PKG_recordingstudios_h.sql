CREATE OR REPLACE PACKAGE PKG_recordingstudios
AS
        PROCEDURE empty_tables;


        PROCEDURE generate_many_to_many(
            p_amount_artists            IN NUMBER DEFAULT 1,
            p_amount_recording_studios  IN NUMBER DEFAULT 1,
            p_amount_relations          IN NUMBER DEFAULT 1
        );

        PROCEDURE generate_2_levels(
            p_amount_recording_studios  IN NUMBER DEFAULT 1,
            p_amount_rooms              IN NUMBER DEFAULT 1,
            P_amount_equipment          IN NUMBER DEFAULT 1
        );

        PROCEDURE bewijs_milestone_5;

        PROCEDURE manueel_m4;

        PROCEDURE printreport_2_levels_m6(p_x IN NUMBER, p_y IN NUMBER, p_z IN NUMBER);


            -- PRIVATE FUNCTIONS
 /*
        PROCEDURE generate_random_artist(
            p_count IN NUMBER DEFAULT 1
        );

        PROCEDURE generate_random_recordingstudio(
            p_count IN NUMBER DEFAULT 1
        );

        PROCEDURE generate_random_relation(
            p_count IN NUMBER DEFAULT 1
        );

        PROCEDURE generate_random_room(
            p_count IN NUMBER DEFAULT 1
        );

        PROCEDURE generate_random_equipment(
            p_count_equipment IN NUMBER DEFAULT 1,
            p_count_rooms IN NUMBER DEFAULT 1
        );




        PROCEDURE add_artist
        (   p_artist_name   artists.name%TYPE,
            p_music_genre   artists.music_genre%TYPE,
            p_profession    artists.profession%TYPE,
            p_birth_date    artists.birth_date%TYPE,
            p_phone_artist  artists.phone_artist%TYPE,
            p_email_artist  artists.email_artist%TYPE);

        PROCEDURE add_booking
        (   p_res_date      bookings.res_date%TYPE,
            p_start_hour    bookings.start_hour%TYPE,
            p_end_hour      bookings.end_hour%TYPE,
            p_artist_name   artists.name%TYPE,
            p_room_name     rooms.room_name%TYPE,
            p_studio_name   recording_studios.studio_name%TYPE);

        PROCEDURE add_equipment
        (   p_rentperhour       equipment.rentperhour%TYPE, -- M6
            p_equipmentname     equipment.equipmentname%TYPE, -- M6
            p_mixing_console    equipment.mixing_console%TYPE,
            p_monitors          equipment.monitors%TYPE,
            p_hardware          equipment.hardware%TYPE,
            p_daw               equipment.daw%TYPE,
            p_software          equipment.software%TYPE,
            p_synths            equipment.synths%TYPE,
            p_vocal_mic         equipment.vocal_mic%TYPE,
            p_room_name         rooms.room_name%TYPE);

        PROCEDURE add_recording_studio
        (   p_studio_name       recording_studios.studio_name%TYPE,
            p_address           recording_studios.address%TYPE,
            p_location          recording_studios.location%TYPE,
            p_phone_studio      recording_studios.phone_studio%TYPE,
            p_email_studio      recording_studios.email_studio%TYPE,
            p_local_engineer    recording_studios.local_engineer%TYPE);

        PROCEDURE add_room
        (   p_room_name         rooms.room_name%TYPE,
            p_area_insqm        rooms.area_insqm%TYPE,
            p_costperhour       rooms.costperhour%TYPE,
            p_singer_booth      rooms.singer_booth%TYPE,
            p_instr_rec_booth   rooms.instr_rec_booth%TYPE,
            p_recstudio_name    recording_studios.studio_name%TYPE);

        PROCEDURE add_artist_recstudio_rel
        (
            p_artist_name   artists.name%TYPE,
            p_studio_name   recording_studios.studio_name%TYPE);
*/

END PKG_recordingstudios;
/