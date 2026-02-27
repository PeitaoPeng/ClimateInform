#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/modes/src
tmp=/cpc/home/wd52pp/tmp
datadir=/cpc/consistency/telecon/gb
#
var=z500
start_yr=1949
end_yr=2000
#
totyr=`expr ${end_yr} - ${start_yr} + 2`
ntotm=`expr $totyr \* 12`
nyr=`expr $totyr - 2`
ltime=`expr $nyr \* 3`
nmode=10
eof_area=NH
mtx=1 # =1 for standardized data; =2 for raw data
#
undefdata=-9.99e+8
#
cp $lcdir/EOF.z500.gb.f $tmp/eof.f
cp $lcdir/IMSL.REOF.s.f $tmp/reof.s.f
#cp $lcdir/reof.s.f $tmp/reof.s.f
cd $tmp
#
#
for mon in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec; do
#for mon in Jan Apr Jul Oct; do
#for mon in Jul; do
/bin/rm $tmp/fort.*         
#
if [ $mon == Jan ]; then imon=13; imm=12; imp=14; fi
if [ $mon == Feb ]; then imon=14; imm=13; imp=15; fi
if [ $mon == Mar ]; then imon=15; imm=14; imp=16; fi
if [ $mon == Apr ]; then imon=16; imm=15; imp=17; fi
if [ $mon == May ]; then imon=17; imm=16; imp=18; fi
if [ $mon == Jun ]; then imon=18; imm=17; imp=19; fi
if [ $mon == Jul ]; then imon=19; imm=18; imp=20; fi
if [ $mon == Aug ]; then imon=20; imm=19; imp=21; fi
if [ $mon == Sep ]; then imon=21; imm=20; imp=22; fi
if [ $mon == Oct ]; then imon=22; imm=21; imp=23; fi
if [ $mon == Nov ]; then imon=23; imm=22; imp=24; fi
if [ $mon == Dec ]; then imon=24; imm=23; imp=25; fi
#
 infile=monthly_tele_indices_1949-2001.in
 outfile1=eof.$mon
 outfile2=pc.${eof_area}.R1_$var.$mon.mtx$mtx.yre${end_yr}
#
cat > parm.h << eof
       parameter(mons=$imon,ny=$nyr)
       parameter(imm=$imm, imp=$imp)
       parameter(ntotm=$ntotm)
       parameter(imx=144,jmx=28)
       parameter(nmod=$nmode)
       parameter(is=1,ie=144,js=1,je=28)
       parameter(mtx=$mtx,id=0)
       parameter(undef=$undefdata)
eof
gfortran -o eof.x reof.s.f eof.f
echo "done compiling"

#
 ln -s $datadir/$infile         fort.10
#
 ln -s $outfile1.gr    fort.51
 ln -s $outfile2.gr    fort.52
#
#eof.x > $datadir/$outfile1.out
eof.x 
#
cat>$outfile1.ctl<<EOF
dset $datadir/$outfile1.gr
undef $undefdata
title Realtime Surface Obs
xdef  144 linear 0 2.5
ydef   28 linear 20 2.5
*ydef   73 linear -90 2.5
zdef    1 levels 500
tdef 999 linear jan1950  1yr
vars   1
e   0 99 eof pattern
endvars
EOF

done # mon loop
#
outfile3=eof.z500.1950-2000
cat eof.Jan.gr eof.Feb.gr eof.Mar.gr eof.Apr.gr eof.May.gr eof.Jun.gr eof.Jul.gr eof.Aug.gr eof.Sep.gr eof.Oct.gr eof.Nov.gr eof.Dec.gr > $outfile3.gr
mv $outfile3.gr $datadir
#
cat>$outfile3.ctl<<EOF
dset $outfile3.gr
undef $undefdata
title Realtime Surface Obs
xdef  144 linear 0 2.5
ydef   28 linear 20 2.5
zdef    1 levels 500
tdef 999 linear jan1950  1yr
vars   1
e   0 99 spatially normalized reof pattern
endvars
EOF
mv $outfile3.ctl $datadir
#
