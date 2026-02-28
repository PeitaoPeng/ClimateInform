#!/bin/sh
#

datadir=/export-12/cacsrv1/wd52pp/LF_prd
source=/export/hobbes/wd52pp/project/LF_prd/plot_cd
 
cd $source/convert

#
cat > parm.h << eof
       parameter(nyear=6)
eof
#

rm fort.*
f77 -o cd_2_grads.x cd_2_grads.f 

   ln -s      $datadir/eof.temp_102_anom_1931-2001.djf.i3e          fort.11
#  ln -s      $datadir/regr.temp_102_anom.djf.31-06.i3e         fort.11
#  ln -s      $datadir/regr.temp_102_anom_1931-2001.djf.i3e          fort.11
#  ln -s      $datadir/reof.temp_102_anom_1931-2001.djf.i3e          fort.11
#  ln -s      $datadir/K_AC_temp_102_anom_1931-2001.djf.i3e          fort.11
#  ln -s      $datadir/ocn_pc_prd_temp.djf.1931-2001.i3e          fort.11
#  ln -s      $datadir/COR_SESAT_vs_temp_1951_2001.djf.i3e             fort.11
#  ln -s      $datadir/skill_cd_grid_ocn_prd_temp_1931-2001.djf.i3e             fort.11
#
   ln -s      $source/convert/data_102/lalo102       fort.12
#
   ln -s      $datadir/eof.temp_102_anom_1931-2001.djf.gr    fort.55
#  ln -s      $datadir/regr.temp_102_anom.djf.31-06.gr    fort.55
#  ln -s      $datadir/regr.temp_102_anom.1931-2001.djf.gr   fort.55
#  ln -s      $datadir/reof.temp_102_anom_1931-2001.djf.gr    fort.55
#  ln -s      $datadir/K_AC_temp_102_anom_1931-2001.djf.gr    fort.55
#  ln -s      $datadir/ocn_pc_prd_temp.djf.1931-2001.gr    fort.55
#  ln -s      $datadir/COR_SESAT_vs_temp_1951_2001.djf.gr    fort.55
#  ln -s      $datadir/skill_cd_grid_ocn_prd_temp_1931-2001.djf.gr   fort.55

   cd_2_grads.x 

 stnmap -i $source/eof.temp_102_anom_1931-2001.djf.ctl         #create map file
#stnmap -i $source/regr.temp_102_anom.djf.31-06.ctl         #create map file
#stnmap -i $source/regr.temp_102_anom_1931-2001.djf.ctl         #create map file
#stnmap -i $source/reof.temp_102_anom_1931-2001.djf.ctl         #create map file
#stnmap -i $source/K_AC_temp_102_anom_1931-2001.djf.ctl         #create map file
#stnmap -i $source/ocn_pc_prd_temp.djf.1931-2001.ctl         #create map file
#stnmap -i $source/COR_SESAT_vs_temp_1951_2001.djf.ctl        #create map file
#stnmap -i $source/skill_cd_grid_ocn_prd_temp_1931-2001.djf.ctl   #create map file

rm *.x

exit
