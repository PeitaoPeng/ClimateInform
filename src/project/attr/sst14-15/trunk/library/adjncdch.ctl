CONTROL FILE FOR ADJNCDC.F  This for the half month data.  
 11       0 INPUT DATES CONTROL FILE 11 
./
todaysdate.txt
 12       0  FILE REGRESSION TRANSLATION FROM GRID-TO-STATION BASED NCDC CDS  (INPUT) 
../library/stats/
ncdcregt.dat
 13       0  FILE REGRESSION TRANSLATION FROM GRID-TO-STATION BASED NCDC CDS  (INPUT) 
../library/stats/
ncdcregp.dat
 14       0cat  TEMPERATURE 344 CD  THIS IS A DUMMY DATASET SINCE NOTHING IS COPIED(INPUT) 
../library/rotating/MM2/
cd344t.dat
 15       0 TEMPERATURE 344 CD (OUTPUT) 
../library/rotating/MM1/
cdh344t.dat
 16       0 PRECIPITATION 344 CD  THIS IS A DUMMY DATASET SINCE NOTHING IS COPIED(INPUT) 
../library/rotating/MM2/
cd344p.dat
 17       0 PRECIPITATION 344 CD (OUTPUT) 
../library/rotating/MM1/
cdh344p.dat
 18       0 TEMPERATURE 344 CD  (INPUT) 
../library/rotating/MM1/
cdh344tg.dat
 19       0 PRECIPITATION 344 CD (INPUT) 
../library/rotating/MM1/
cdh344pg.dat
999       0 END OF INPUT FILE
    3        = (I5) Print Control 0=none 1= a little, 2= a lot
    0    1       = (2I5) FIRST YEAR  ON NCDC DATASETS
    0       = FIRST YEAR OF NCDC TO PROCESS, NEGATIVES REFER TO YEARS PRIOR TO MOST RECENT COMPLETE MONTH
    0       = jakflag = 0 no processing of alaska data, 1 process alaska
  
