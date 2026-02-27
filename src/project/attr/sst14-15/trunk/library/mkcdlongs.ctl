CONTROL FILE FOR MKCDPRELIM.F  
 11       0 INPUT DATES CONTROL FILE 11 
../work/
todaysdate.txt
 12       0  TEMPERATURE 344 FD  (INPUT) 
../library/rotating/MM1/
cd344t.dat
 13       0 PRECIPITATION 344 FD  (INPUT) 
../library/rotating/MM1/
cd344p.dat
 14       0 TEMPERATURE .LONG DATASET (INPUT) 
../library/rotating/MM2/
t.long
 15       0 PRECIPITATION .long DATASET  (INPUT) 
../library/rotating/MM2/
p.long
 16       0 TEMPERATURE .LONG dataset (OUTPUT) 
../library/rotating/MM1/
t.long
 17       0 PRECIPITATION .long DATASET  (OUTPUT)
../library/rotating/MM1/
p.long
999       0 END OF INPUT FILE
    4        = (I5) Print Control 0=none 1= a little, 2= a lot
 1895    0     =  (2I5) FIRST YEAR  ON NCDC
 1931    0      = (2I5) FIRST YEAR  ON .LONG DATASETS
    0    1      = YEAR (JYS) AND MONTH (JMS) TO START (JYS=0=1 MONTH AGO, 
                  -N = N YEARS PRIOR TO MOST RECENT COMPLETE MONTH
  
