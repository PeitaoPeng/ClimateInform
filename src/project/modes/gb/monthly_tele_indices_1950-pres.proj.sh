#!/bin/sh
#==========================================================
# have tele indice, need to check iposn data in .f file
# need to check iposn data in .f file
# need to add eof_end_yr in .ctl files
#=========================================

set -eaux

lcdir=/cpc/home/wd52pp/project/modes/gb
tmp=/cpc/home/wd52pp/tmp
datadir=/cpc/consistency/telecon/gb
#
eof_end_yr=2000
cd $tmp
cp $lcdir/monthly_tele_indices_1950-pres.proj.f index.f
cp $lcdir/daymon.dat daymon.dat

f77 -o index.x index.f
echo "done compiling"

\rm fort.*
cat > parm.h << eof
       parameter(eofendyr=$eof_end_yr)
eof
#
 ln -s $datadir/monthly_tele_indices_1950-pres.in    fort.1
#ln -s $datadir/monthly_tele_indices_1950-pres.clm1991-2020.in    fort.1
 ln -s $datadir/reof.z500.1950-${eof_end_yr}.gr    fort.10
 ln -s $datadir/eof.z500.1950-${eof_end_yr}.gr     fort.11
 ln -s $datadir/eofmon_meansd.${eof_end_yr}.proj.dat         fort.12
 ln -s $datadir/eofmonrot_new.${eof_end_yr}.proj.tim         fort.22
 ln -s $datadir/eofmonftp_new.${eof_end_yr}.proj.tim         fort.23
 ln -s $datadir/monthly_raw_tele_indices.${eof_end_yr}.proj.bi     fort.24
 ln -s $datadir/monthly_raw_tele_indices.${eof_end_yr}.proj.ctl    fort.26
 ln -s $datadir/monthly_tele_indices.${eof_end_yr}.proj.bi         fort.25
 ln -s $datadir/monthly_tele_indices.${eof_end_yr}.proj.ctl        fort.27
#
index.x 
#
