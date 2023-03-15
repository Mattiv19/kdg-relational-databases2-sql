Milestone 1: Onderwerp en Git
---

Student:
--------
- Matthias Vermeiren

Onderwerp: (veel op veel)
-------------------------
- Recording Studios
    - Artist - Recording Studio


- 2Level: Recording studio
    - Room
    - Equipment

Explanation: een artiest kan meerdere recording studios boeken.  Een recording studio kan door meerdere artiesten gebruikt worden.
Elke recording studio heeft meerdere rooms. Elke room heeft specifieke equipment.

Entiteittypes:
--------------
- Artist
- Recording Studio
- Booking
- Room
- Equipment

Relatietypes:
-------------

- Recording Studio
    - is used by
    - Artist
- Artist
    - makes
    - Booking
- Recording Studio
    - has
    - Room
- Room
    - uses
    - equipment

Attributen:
-----------

- Artist
    - artist_id
    - name
    - music_genre
    - profession
    - birth_date
    - phone_artist
    - email_artist
- Recording studio
    - studio_code
    - studio_name
    - address (street+number)
    - location
    - phone_studio
    - email_studio
    - local_engineer (boolean)
- Room
    - room_code
    - room_name
    - area_insqm
    - costperhour
    - singer_booth (boolean)
    - instr_rec_booth (boolean)
    - equipment_code
- Equipment
    - equipment_code
    - mixing_console (SSL, Neve, API, Avid)
    - monitors (Dynaudio, Barefoot, Focal, Genelec, Adam)
    - hardware (Universal Audio, LA-2A compressor, 1176 compressor, Distressor, Fairchild compressors, Pultec)
    - daw (ProTools, Logic, Ableton, Cubase)
    - software (Melodyne, FabFilter Bundle, UAD Bundle, Waves Bundle, iZotope Bundle)
    - synths (Moog, Roland, Prophet, Oberheimer, Nord Lead, Yamaha)
    - vocal_mic (Neumann, Shure, Sony, AKG)
- Booking
    - res_code
    - res_date
    - start_hour
    - end_hour
    - id
    - studio_code
    - room_code
