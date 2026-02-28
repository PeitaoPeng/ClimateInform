CONTROL FILE FOR  TRANSCDFD.F  
 11       0 INPUT DATES CONTROL FILE 11 
./
todaysdate.txt
 12       0  FILE WITH 344-TO-102 DIVISION TRANSLATION WEIGHTS  (INPUT) 
../library/stats/
cdldictgrid.dat
 13       0 TEMPERATURE 102 FD LAST COMPLETE MONTHS (INPUT) 
../library/rotating/MM2/
cd102t.dat
 14       0 TEMPERATURE 102 FD NEW ADJUSTED DATA FOR THE LAST YEAR (OUTPUT) 
../library/rotating/MM1/
cd102t.dat
 15       0 PRECIPITATION 102 FD LAST COMPLETE DATA (INPUT) 
../library/rotating/MM2/
cd102p.dat
 16       0 PRECIPITATION 102 FD ADJUSTED FOR THE LAST YEAR OF FINAL DATA(OUTPUT) 
../library/rotating/MM1/
cd102p.dat
 17       0 TEMPERATURE 344 CD WITH LATEST FINAL DATA (INPUT) 
../library/rotating/MM1/
cd344t.dat
 18       0 PRECIPITATION 344 CD WITH LATEST FINAL DATA(INPUT) 
../library/rotating/MM1/
cd344p.dat
999       0 END OF INPUT FILE
    4        = (I5) Print Control 0=none 1= a little, 2= a lot
 1895    1       = (2I5) FIRST YEAR  ON NCDC DATASETS
   -1    1       = FIRST YEAR OF NCDC TO PROCESS, NEGATIVE REPROCESS  1 YEARS PRIOR TO MOST RECENT COMPLETE MONTH
    0        =  0 for no Alaska processing 1 otherwise

  
