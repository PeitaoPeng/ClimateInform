CONTROL FILE FOR MAKENCDC.F  
 11       0 INPUT DATES CONTROL FILE 11 
./
todaysdate.txt
 12       0 HALF-MONTH TEMPERATURE 102 FD  (INPUT) 
../library/rotating/MM2/
cdh102tg.dat
 13       0 HALF-MONTH TEMPERATURE 102 FD (OUTPUT) 
../library/rotating/MM1/
cdh102tgh1.dat
 15       0 HALF-MONTH PRECIPITATION 102 FD  (INPUT) 
../library/rotating/MM2/
cdh102pg.dat
 16       0 HALF-MONTH PRECIPITATION 102 FD (OUTPUT) 
../library/rotating/MM1/
cdh102pgh1.dat
 17       0 FULL-MONTH TEMPERATURE 102 CD  (INPUT) 
../library/rotating/MM1/
cd102tg.dat
 18       0 FULL-MONTH PRECIPITATION 102 CD (INPUT) 
../library/rotating/MM1/
cd102pg.dat
999       0 END OF INPUT FILE
    4        = (I5) Print Control 0=none 1= a little, 2= a lot
 1950    1       = (2I5) FIRST YEAR  ON NCDC half-month DATASETS
    0       = FIRST YEAR OF NCDC TO PROCESS, NEGATIVES REFER TO YEARS PRIOR TO MOST RECENT COMPLETE MONTH

