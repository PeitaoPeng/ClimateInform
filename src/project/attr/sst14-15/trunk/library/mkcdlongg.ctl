CONTROL FILE FOR MKCDLONG.F  
 11       0 INPUT DATES CONTROL FILE 11 
../work/
todaysdate.txt
 12       0  TEMPERATURE 344 CD IN BY-MONTH FORMAT  (INPUT) 
../library/rotating/MM1/
cd357tg.dat
 13       0 PRECIPITATION 344 FD IN BY-MONTH FORMAT  (INPUT) 
../library/rotating/MM1/
cd357pg.dat
 14       0 TEMPERATURE .LONG DATASET (BY-DIVISION FORMAT) (INPUT) 
../library/rotating/MM2/
tg.long
 15       0 PRECIPITATION .long DATASET (BY-DIVISION FORMAT) (INPUT) 
../library/rotating/MM2/
pg.long
 16       0 TEMPERATURE .LONG dataset (OUTPUT) 
../library/rotating/MM1/
tg.long
 17       0 PRECIPITATION .long DATASET  (OUTPUT)
../library/rotating/MM1/
pg.long
999       0 END OF INPUT FILE
    3        = (I5) Print Control 0=none 1= a little, 2= a lot
 1895    1   = 2I5) FIRST YEAR  ON NCDC DATASETS
 1931    1      = (2I5) FIRST YEAR  ON  .LONG DATASETS
    0    1      = YEAR (JYS) AND MONTH (JMS) TO START (JYS=0=1 MONTH AGO, 
                  -N = N YEARS PRIOR TO MOST RECENT COMPLETE MONTH
  
