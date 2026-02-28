CONTROL FILE FOR MKCDPRELIM.F  
 11       0 INPUT DATES CONTROL FILE 11 
./
todaysdate.txt
 12    1428 INPUT BIAS CORRECTION CONSTANTS
../library/rotating/MM2/
stat1CPCncdct.gds
 13    1428 INPUT BIAS CORRECTION CONSTANTS
../library/rotating/MM2/
stat1CPCncdcp.gds
 14       0 TEMPERATURE CD's FOR LAST COMPLETE MONTH  (INPUT)  
../library/rotating/MM2/
cd357tg.dat
 15       0 TEMPERATURE CD WITH NEW DATA APPENDED (OUTPUT) 
../library/rotating/MM1/
cd357tg.dat
 16       0 PRECIP CD FOR LAST COMPLETE MONTH (INPUT)  
../library/rotating/MM2/
cd357pg.dat
 17       0 PRECIP CD WITH NEW DATA APPENDED (OUTPUT)  
../library/rotating/MM1/
cd357pg.dat
 18       0 ADAMS CD DATA ESTIMATES FOR THE NEW MONTH (INPUT)
./
cpcgridMM1p.txt
 19       0 TEMPERATURE CD - SINGLE MONTH ONLY FOR PERMANENT ARCHIVE (OUTPUT)  
../library/rotating/YYm1/MM1/
cd357tgm.dat
 20       0 PRECIP CD - SINGLE MONTH ONLY FOR PERMANENT ARCHIVE  (OUTPUT)  
../library/rotating/YYm1/MM1/
cd357pgm.dat
 21       0  ALASKA STATION TEMERATURE CLIMATOLOGY  (INPUT)  
../library/stats/
mn1stnakt.dat
 22       0  ALASKA DIVISION TEMERATURE CLIMATOLOGY  (INPUT)  
../library/stats/
mn1cd357tg.dat
 23       0  ALASKA STATION PRECIP CLIMO (INPUT)  
../library/stats/
clim1stnpoeakp.dat
 24       0  ALASKA DIVISION PRECIP CLIMO (INPUT)  
../library/stats/
clim1cd357poep81.dat
 25       0  ALASKA STATION TEMPERATURE DATA (INPUT)
/DATAIN/observations/land_air/long_range/ak_hi/monthly_AK_HI_observations/
alaska_station_temperature_obs_estimated.dat
 26       0  ALASKA STATION TEMPERATURE DATA (INPUT)
/DATAIN/observations/land_air/long_range/ak_hi/monthly_AK_HI_observations/
alaska_station_precipitation_obs_estimated.dat
 27       0  ALASKA DIVISION WEIGHTING DICTIONARY
../library/stats/
AKstn_to_div_wts.txt
999       0 END OF INPUT FILE
    0        = (I5) Print Control 0=none 1= a little, 2= a lot
 1895   1       = (2I5) FIRST YEAR  ON NCDC DATASETS
   25       = MINIMUM NUMBER OF DAYS TO ACCEPT AS COMPLETE MONTH
    1       = Flag for Alaska Processing, 0 = no AK , 1 = AK processing

  
