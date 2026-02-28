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
datadir2=/cpc/prod/cwlinks/indices_RH6/data
datadir3=/cpc/prod/cwlinks/indices_RH6/data
#
eof_end_yr=gb2000
cd $tmp
cp $lcdir/monthly_tele_indices_1950-pres.gb.f index.f
cp $lcdir/daymon.dat daymon.dat

f77 -o index.x index.f
echo "done compiling"

\rm fort.*
#
 ln -s $datadir/monthly_tele_indices_1950-pres.in    fort.1
#ln -s $datadir/reof.z500.1950-2000.gr    fort.10
 ln -s $datadir2/500z.loading.patterns    fort.10
 ln -s $datadir/eof.z500.1950-2000.gr     fort.11
 ln -s $datadir/eofmon_meansd.${eof_end_yr}.dat         fort.12
 ln -s $datadir/eofmonrot_new.${eof_end_yr}.tim         fort.22
 ln -s $datadir/eofmonftp_new.${eof_end_yr}.tim         fort.23
 ln -s $datadir/monthly_raw_tele_indices.${eof_end_yr}.bi     fort.24
 ln -s $datadir/monthly_raw_tele_indices.${eof_end_yr}.ctl    fort.26
 ln -s $datadir/monthly_tele_indices.${eof_end_yr}.bi         fort.25
 ln -s $datadir/monthly_tele_indices.${eof_end_yr}.ctl        fort.27
#
index.x 
#
