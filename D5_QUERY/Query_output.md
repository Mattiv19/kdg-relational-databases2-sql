Milestone 3: Creatie Databank
---

    Identity columns
---
- Mandatory
  - Artists: artist_id
  - Recording_Studios: studio_code
  - Rooms: room_code
  - Equipment: equipment_code
- other:
  - Bookings: res_code


      Table Counts
---
![Table counts](./screenshots/table_count.png)

    @query 1: Relatie Veel-op-veel

    SELECT name,MUSIC_GENRE, PROFESSION, BIRTH_DATE, PHONE_ARTIST, EMAIL_ARTIST, STUDIO_NAME, ADDRESS, LOCATION, PHONE_STUDIO, EMAIL_STUDIO,LOCAL_ENGINEER 
    FROM ARTISTS a 
    JOIN ARTISTS_RECSTUDIOS_RELATION ar ON ar.A_ARTIST_ID = a.ARTIST_ID 
    JOIN RECORDING_STUDIOS r ON r.STUDIO_CODE = ar.RS_STUDIO_CODE;
--- 
![query 1: Relatie Veel-op-veel](./screenshots/veel_op_veel.png)



    @query 2: 2 niveau’s diep

    SELECT STUDIO_NAME, ADDRESS, LOCATION, PHONE_STUDIO, EMAIL_STUDIO, LOCAL_ENGINEER, ROOM_NAME, AREA_INSQM, COSTPERHOUR, SINGER_BOOTH, INSTR_REC_BOOTH, MIXING_CONSOLE, MONITORS, HARDWARE, DAW, SOFTWARE, SYNTHS, VOCAL_MIC
    FROM RECORDING_STUDIOS r
    JOIN ROOMS ro ON ro.RECORDING_STUDIOS_STUDIO_CODE = r.STUDIO_CODE
    JOIN EQUIPMENT e ON e.ROOMS_ROOM_CODE = ro.ROOM_CODE
    ORDER BY STUDIO_NAME, ROOM_NAME, EQUIPMENT_CODE;
--- 
![query 2: 2 niveau’s diep_deel1](./screenshots/2niveausdiep_deel1.png)
![query 2: 2 niveau’s diep_deel2](./screenshots/2niveausdiep_deel2.png)

    @query 3: bookings

    SELECT RES_DATE, START_HOUR, END_HOUR, NAME, MUSIC_GENRE, PROFESSION, BIRTH_DATE, PHONE_ARTIST, EMAIL_ARTIST, STUDIO_NAME, ADDRESS, LOCATION, PHONE_STUDIO, EMAIL_STUDIO, LOCAL_ENGINEER, ROOM_NAME, AREA_INSQM, COSTPERHOUR, SINGER_BOOTH, INSTR_REC_BOOTH,MIXING_CONSOLE,MONITORS, HARDWARE, DAW, SOFTWARE, SYNTHS,  VOCAL_MIC
    FROM BOOKINGS b
    JOIN ARTISTS a ON a.ARTIST_ID = b.ARTISTS_ARTIST_ID
    JOIN RECORDING_STUDIOS r ON r.STUDIO_CODE = b.ROOMS_STUDIO_CODE
    JOIN ROOMS ro ON b.ROOMS_ROOM_CODE = ro.ROOM_CODE
    JOIN EQUIPMENT e ON e.ROOMS_ROOM_CODE = b.ROOMS_ROOM_CODE AND e.RO_REC_STU_CODE = b.ROOMS_STUDIO_CODE
    ORDER BY RES_DATE, NAME, STUDIO_NAME, ROOM_NAME;
--- 
![query 3: bookings_deel1](./screenshots/bookings_deel1.png)
![query 3: bookings_deel2](./screenshots/bookings_deel2.png)
![query 3: bookings_deel3](./screenshots/bookings_deel3.png)


  Bewijs Domeinen - constraints M2
--- 
    Bookings: end hour > start hour

---
![Bewijs Bookings_EndHour](./screenshots/bewijs_Bookings_EndHour.png)

    Artists: music genre - minimum 3 characters

---
![Bewijs Artists_MusicGenre](./screenshots/bewijs_Artists_MusicGenre.png)


    Artists: email_artist - must contain @

---

![Bewijs Artists_Email](./screenshots/bewijs_Artists_Emailadres.png)

    Recording_Studios: email_studio - must contain @

---

![Bewijs RecordingStudios_Email](./screenshots/bewijs_RecordingStudios_Emailadres.png)

    Recording_Studios: location - uppercase

---

![Bewijs RecordingStudios_Location](./screenshots/bewijs_RecordingStudios_Location.png)

    Rooms: area_insqm - max 500

---

![Bewijs Rooms_Area](./screenshots/bewijs_Rooms_Area.png)

    Rooms: costperhour - max 200

---

![Bewijs Rooms_Cost](./screenshots/bewijs_Rooms_Cost.png)




