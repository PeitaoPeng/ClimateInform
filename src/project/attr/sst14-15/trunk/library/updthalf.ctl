CONTROL FILE FOR UPDTHALF.F  
 11       0 INPUT DATES CONTROL FILE 11 
./
todaysdate.txt
 12       0  TEMPERATURE 102 HALF-MONTH FD  (INPUT)  
/DATAIN/observations/land_air/long_range/conus/temp_precip/cds/
cdh102t.dat
 13       0  TEMPERATURE 102 HALF-MONTH FD  (OUTPUT)   
../library/rotating/MM1/
cdh102t.dat
 14       0  PRECIP 102 HALF-MONTH FD  (INPUT)  
/DATAIN/observations/land_air/long_range/conus/temp_precip/cds/
cdh102p.dat
 15       0  PRECIP 102 HALF-MONTH FD  (OUTPUT)   
../library/rotating/MM1/
cdh102p.dat
 16       0 TEMPERATURE 102 FD FULL MONTH OLD VALUES  (INPUT) 
/DATAIN/observations/land_air/long_range/conus/cds/
cd102t.dat
 17       0 TEMPERATURE 102 FD NEW VALUES (INPUT) 
../library/rotating/MM1/
cd102t.dat
 18       0 PRECIP 102 FD FULL MONTH OLD VALUES  (INPUT) 
/DATAIN/observations/land_air/long_range/conus/cds/
cd102p.dat
 19       0 PRECIP 102 FD NEW VALUES (INPUT) 
../library/rotating/MM1/
cd102p.dat
999       0 END OF INPUT FILE
    4        = (I5) Print Control 0=none 1= a little, 2= a lot
 1948    1       = (2I5) FIRST YEAR  ON NCDC DATASETS
   -1    1       = FIRST YEAR OF NCDC TO PROCESS, NEGATIVES REFER TO YEARS PRIOR TO MOST RECENT COMPLETE MONTH
  
