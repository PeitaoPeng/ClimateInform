#!/bin/sh

set -eaux

lcdir=/home/ppeng/src/hindcast/ca
tmp=/home/ppeng/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir=/mnt/d/data/ca_hcst
dataout=$tmp
#
#for icss in jfm fma mam amj mjj jja jas aso son ond ndj djf; do
for icss in aso fma; do
#
if [ $icss = jfm ]; then cmon=4;  icmomid=feb; icssnmb=1; fi #icmon_mid: mid mon of icss
if [ $icss = fma ]; then cmon=5;  icmomid=mar; icssnmb=2; fi #icssnmb: 1st mon of icss
if [ $icss = mam ]; then cmon=6;  icmomid=apr; icssnmb=3 ; fi
if [ $icss = amj ]; then cmon=7;  icmomid=may; icssnmb=4 ; fi
if [ $icss = mjj ]; then cmon=8;  icmomid=jun; icssnmb=5; fi
if [ $icss = jja ]; then cmon=9;  icmomid=jul; icssnmb=6; fi
if [ $icss = jas ]; then cmon=10;  icmomid=aug; icssnmb=7; fi
if [ $icss = aso ]; then cmon=11;  icmomid=sep; icssnmb=8; fi
if [ $icss = son ]; then cmon=12;  icmomid=oct; icssnmb=9; fi
if [ $icss = ond ]; then cmon=1; icmomid=nov; icssnmb=10; fi
if [ $icss = ndj ]; then cmon=2; icmomid=dec; icssnmb=11; fi
if [ $icss = djf ]; then cmon=3; icmomid=jan; icssnmb=12; fi
#
icmomidyr=${icmomid}1981
if [ $icss = djf ]; then icmomidyr=${icmomid}1982; fi
var2=prec
nyear=40  # years of forecast to be checked
nldin=17
nldout=7
nesm=16
undef=-9.99e+8
eof_area=tp_ml
iweight=1 # 1=yes, 0=no
#
cd $tmp
#
#===============have SST climatology
#

cp $lcdir/wt_esm.hindcast.f $tmp/esm.f

#for sst_analysis in ersst hadoisst; do
for sst_analysis in ersst; do
 
cat > parm.h << eof
c
      parameter(imx=360,jmx=180)
      parameter(nldin=$nldin,nld=$nldout,nesm=$nesm)
      parameter(nyr=$nyear)
      parameter(undef=$undef)
      parameter(ius1=11,iue1=10+$nesm) ! unit #
      parameter(iweight=$iweight) 
eof
#
#
outfile=ca_hcst_wt_esm.$icss.$sst_analysis
outfile1=ca_hcst_wt${iweight}_esm.$icss.${sst_analysis}_2_$var2.${eof_area}
outfile2=skill_ca_hcst_wt${iweight}_esm.$icss.${sst_analysis}_2_$var2.${eof_area}
outfile3=wts_wt${iweight}_esm.$icss.${sst_analysis}_2_$var2.${eof_area}
#gfortran -o esm.x esm.f
#gfortran -mcmodel=medium -g -o esm.x esm.f
gfortran -mcmodel=large -g -o esm.x esm.f
echo "done compiling"

#if [ -d fort.11 ] ; then
/bin/rm $tmp/fort.*
#fi
#
ifile1=10
for msic in 1 2 3 4; do
#for modemax in 10 20 30 40 50 60; do
for modemax in 10 15 25 40; do

ifile1=`expr $ifile1 + 1` 
#
ln -s $datadir/$var2/ca_hcst.$var2.${sst_analysis}.$modemax.$icss.${msic}ics.${eof_area}.gr fort.$ifile1
#
done  # maxmode
done  # msics
#
ln -s $dataout/$outfile1.gr  fort.91
ln -s $dataout/$outfile2.gr  fort.92
ln -s $dataout/$outfile3.gr  fort.93
#
#./esm.x > $dataout/out.$outfile
./esm.x 
#
cat>$dataout/$outfile1.ctl<<EOF
dset ^$outfile1.gr
undef $undef
title EXP1
XDEF  360 LINEAR    0.5  1.0
YDEF  180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef $nyear linear $icmomidyr 1yr
vars  14
o1 1 99 obs  
p1 1 99 prd 1m ld
o2 1 99 obs  
p2 1 99 prd 2m ld
o3 1 99 obs 
p3 1 99 prd 3m ld
o4 1 99 obs 
p4 1 99 prd 4m ld
o5 1 99 obs 
p5 1 99 prd 5m ld
o6 1 99 obs 
p6 1 99 prd 6m ld
o7 1 99 obs 
p7 1 99 prd 7m ld
endvars
EOF
#
cat>$dataout/$outfile2.ctl<<EOF
dset $dataout/$outfile2.gr
undef $undef
title Realtime Surface Obs
xdef  360 linear   0.5 1.
ydef  180 linear -89.5 1.
zdef  1 levels 1
tdef  $nldout linear jan1991 1mo
vars  2
cor   0 99 iwt=0 or 1
rms   0 99 iwt=0 or 1
endvars
EOF
#
cat>$dataout/$outfile3.ctl<<EOF
dset $dataout/$outfile3.gr
undef $undef
title Realtime Surface Obs
xdef  360 linear   0.5 1.
ydef  180 linear -89.5 1.
zdef  1 levels 1
tdef  4 linear jan1991 1mo
vars  8
ac1   0 99 nmod 10
wt1   0 99 nmod 10
ac2   0 99 nmod 15
wt2   0 99 nmod 15
ac3   0 99 nmod 25
wt3   0 99 nmod 25
ac4   0 99 nmod 40
wt4   0 99 nmod 40
endvars
EOF
#
done  # sst_analysis
done  # icss
