CONTROL FILE FOR MKCDPRELIM.F  
 11       0 INPUT DATES CONTROL FILE 11 
/export/cpc-lw-dunger/wd53du/sandboxes/makencdc/trunk/work/
todaysdate.txt
 12       0  FILE WITH 344-TO-102 DIVISION TRANSLATION WEIGHTS  (INPUT) 
/export/cpc-lw-dunger/wd53du/cddata/
cdldictgrid.dat
 13       0 TEMPERATURE 102 FD  (INPUT) 
/export/cpc-lw-dunger/wd53du/archive/
cd102t.dat
 14       0 TEMPERATURE 102 FD (OUTPUT) 
/export/cpc-lw-dunger/wd53du/observations/06/
cd102tg.dat
 15       0 PRECIPITATION 102 FD  (INPUT) 
/export/cpc-lw-dunger/wd53du/archive/
cd102p.dat
 16       0 PRECIPITATION 102 FD (OUTPUT) 
/export/cpc-lw-dunger/wd53du/observations/06/
cd102pg.dat
 17       0 TEMPERATURE 344 CD  (INPUT) 
/export/cpc-lw-dunger/wd53du/archive/
cd344tg.dat
 18       0 PRECIPITATION 344 CD (INPUT) 
/export/cpc-lw-dunger/wd53du/archive/
cd344pg.dat
999       0 END OF INPUT FILE
    4        = (I5) Print Control 0=none 1= a little, 2= a lot
 1895    1       = (2I5) FIRST YEAR  AND MONTH ON NCDC DATASETS
 1895    1   = FIRST YEAR AND MONTH OF NCDC TO PROCESS, NEGATIVES REFER TO YEARS PRIOR TO MOST RECENT COMPLETE MONTH
    0        =  0 for no Alaska processing 1 otherwise

  
