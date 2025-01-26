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
for icss in aso; do
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
nlead=17
nesm=24
undef=-9.99e+8
eof_area=tp_ml
#
cd $tmp
#
#===============have SST climatology
#

cp $lcdir/wt_esm.hindcast.f $tmp/esm.f

for sst_analysis in ersst; do
 
cat > parm.h << eof
c
      parameter(imx=360,jmx=180)
      parameter(nld=$nlead,nesm=$nesm)
      parameter(nyr=$nyear)
      parameter(undef=$undef)
      parameter(ius1=11,iue1=10+$nesm,ius2=41,iue2=40+$nesm) ! unit #
eof
#
#
outfile=ca_hcst_wt_esm.$icss.$sst_analysis
outfile1=ca_hcst_wt_esm.$icss.${sst_analysis}_2_$var2.${eof_area}
outfile2=skill_ca_hcst_wt_esm.$icss.${sst_analysis}_2_$var2.${eof_area}
#gfortran -o esm.x esm.f
gfortran -mcmodel=medium -g -o esm.x esm.f
echo "done compiling"

#if [ -d fort.11 ] ; then
/bin/rm $tmp/fort.*
#fi
#
ifile1=10
ifile2=40
for msic in 1 2 3 4; do
for modemax in 15 25 35 45 55 65; do

ifile1=`expr $ifile1 + 1` 
ifile2=`expr $ifile2 + 1` 
#
ln -s $datadir/$var2/ca_hcst.$var2.${sst_analysis}.$modemax.$icss.${msic}ics.${eof_area}.gr fort.$ifile1
ln -s $datadir/$var2/ca_hcst_skill.$var2.${sst_analysis}.$modemax.$icss.${msic}ics.${eof_area}.gr fort.$ifile2
#
done  # maxmode
done  # msics
#
ln -s $dataout/$outfile1.gr  fort.91
ln -s $dataout/$outfile2.gr  fort.92
#
./esm.x > $dataout/out.$outfile
#
cat>$dataout/$outfile1.ctl<<EOF
dset ^$outfile1.gr
undef -9.99E+8
title EXP1
XDEF  360 LINEAR    0.5  1.0
YDEF  180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef $nyear linear $icmomidyr 1yr
vars  34
ic  1 99 obs ic
cic 1 99 constructed ic
o1 1 99 obs 1
p1 1 99 prd 1
o2 1 99 obs 2
p2 1 99 prd 2
o3 1 99 obs 3
p3 1 99 prd 3
o4 1 99 obs 4
p4 1 99 prd 4
o5 1 99 obs 5
p5 1 99 prd 5
o6 1 99 obs 6
p6 1 99 prd 6
o7 1 99 obs 7
p7 1 99 prd 7
o8 1 99 obs 8
p8 1 99 prd 8
o9 1 99 obs 9
p9 1 99 prd 9
o10 1 99 obs 10
p10 1 99 prd 10
o11 1 99 obs 11
p11 1 99 prd 11
o12 1 99 obs 12
p12 1 99 prd 12
o13 1 99 obs 13
p13 1 99 prd 13
o14 1 99 obs 14
p14 1 99 prd 14
o15 1 99 obs 15
p15 1 99 prd 15
o16 1 99 obs 16
p16 1 99 prd 16
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
tdef  $nlead linear jan1991 1yr
vars  8
cor1   0 99 no wt
rms1   0 99 no wt
cor2   0 99 wt=+r/sigma r
rms2   0 99 wt=+r/sigma r
cor3   0 99 wt=+-r**2/sigma r**2
rms3   0 99 wt=+-r**2/sigma r**2
cor4   0 99 wt=r**2/sigma r**2
rms4   0 99 wt=r**2/sigma r**2
endvars
EOF
#
done  # sst_analysis
done  # icss
