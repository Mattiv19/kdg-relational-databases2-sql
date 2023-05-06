BEGIN
    PKG_recordingstudios.empty_tables();
    PKG_RECORDINGSTUDIOS.bewijs_milestone_5();
END;

SELECT * FROM ARTISTS_RECSTUDIOS_RELATION;

SELECT upper(STUDIO_NAME) FROM RECORDING_STUDIOS;

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

    PKG_RECORDINGSTUDIOS.ADD_EQUIPMENT('SSL', 'Dynaudio', 'LA-2A compressor, 1176 compressor, Pultec', 'ProTools', 'Melodyne, Fabfilter Bundle, iZotope Bundle', 'Moog, Roland, Nord Lead', 'Neumann', 'ROAD PRINCE', 'ABBEY ROAD');
    PKG_RECORDINGSTUDIOS.ADD_EQUIPMENT('NEVE', 'Barefoot', 'Distressor, Universal Audio', 'Ableton', 'UAD Bundle, Fabfilter Bundle, Waves Bundle', 'Moog, Roland', 'Shure', 'FILTH ON ACID', 'THE WAREHOUSE STUDIOS');
    PKG_RECORDINGSTUDIOS.ADD_EQUIPMENT('AVID', 'Adam', 'Distressor, Fairchild compressors, Pultec', 'Ableton', 'iZotope Bundle, Waves Bundle, Fabfilter Bundle', 'Roland, Prophet', NULL, 'BEYER', 'DRUMCODE STUDIOS');
    PKG_RECORDINGSTUDIOS.ADD_EQUIPMENT('API', 'Focal', 'LA-2A compressor, 1176 compressor, Fairchild comp', 'Logic', 'Melodyne, Waves Bundle, iZotope Bundle', 'Nord Lead, Prophet, Oberheimer, Moog, Roland','Sony', 'ATLANTIS', 'VALHALLA RECORDING STUDIOS');
    PKG_RECORDINGSTUDIOS.ADD_EQUIPMENT('SSL', 'Genelec', 'LA-2A compressor, Universal Audio, 1176 compressor', 'ProTools', 'Melodyne, UAD Bundle, iZotope Bundle', 'Nord Lead, Yamaha, Prophet, Moog', 'Neumann', 'MICHAEL', 'UNIVERSAL STUDIOS');

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
END;