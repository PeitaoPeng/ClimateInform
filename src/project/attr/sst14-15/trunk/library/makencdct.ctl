CONTROL FILE FOR MAKENCDC.F  
 11       0   INPUT DATES CONTROL FILE 11 
./
todaysdate.txt
 12       0   NCDC TEMPERATURE FILE  (INPUT) 
./
ncdcdivt.dat
 13       0   LAST COMPLETE TEMPERATURE CD  (INPUT) 
../library/rotating/MM2/
cd357tg.dat
 14       0 NEW TEMPERATURE CD (OUTPUT) 
../library/rotating/MM1/
cd357tg.dat
999       0 END OF INPUT FILE
    3        = (I5) Print Control 0=none 1= a little, 4= a lot
 1895 1925    0      = (3I5) FIRST YEAR  ON NCDC DATASETS and lag in years between year wanted and the last date on current NCDC file 
 -199    1  = FIRST YEAR OF NCDC TO PROCESS, NEGATIVES REFER TO YEARS PRIOR TO MOST RECENT COMPLETE MONTH
    1       = VARIABLE ID 1 = TEMP 2 = PRECIP
  
