#!/bin/sh
#

datadir=/export/lnx160/wd51yf/jhs/sm_daily/output
source=/export/lnx160/wd51yf/jhs/soilmst
 
cd $source/convert

f77 -o cd_to_grads.x $source/convert/long_to_grads.f 

   ln -s      $datadir/t.long         fort.11
   ln -s      $datadir/lalo344.dat       fort.12
   ln -s      $source/convert/t.long     fort.20

   ./cd_to_grads.x 
   rm fort.*

   stnmap -i t.long.ctl     #create map file

rm *.x

exit
