####################################################################
#    Script initialload.s                                          # 
#    This simple script is put into subversion to show what initial#
#   steps need to be taken to load the initial data required for   #
#   the NCDC updates.  This example is being loaded in mid may,    #
#    so that the "03" directory contains the last complete month   #
#    of NCDC data, and the directory "04" contains the partial     #
#    data from the preliminary update made in early May.           #
#                                                                  #   
#    NOTE that data reside permanently in the $DATA_OUT directory  #
#    created here.                                                 #
####################################################################
cd $MAKECDS/library/rotating/06/
#    Make the permanent data directory if it doesn't already exist and go there
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/cd102p.dat ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/cd102pg.dat ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/cd102t.dat ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/cd102tg.dat ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/cd344p.dat ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/cd344pg.dat ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/cd344t.dat ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/cd344tg.dat ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/t.long ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/p.long ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/tg.long ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/pg.long ./
cd $DATA_OUT/observations/land_air/long_range/conus/temp_precip/cds
#    Then copy the needed stuff.
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/cd102p.dat ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/cd102pg.dat ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/cd102t.dat ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/cd102tg.dat ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/cd344p.dat ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/cd344pg.dat ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/cd344t.dat ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/cd344tg.dat ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/t.long ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/p.long ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/tg.long ./
cp /cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/library/rotating/06/pg.long ./
 
