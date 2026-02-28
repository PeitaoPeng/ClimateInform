#!/bin/sh

set -eaux

lcdir=/home/ppeng/ClimateInform/src/hindcast/ca
tmp=/home/ppeng/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir=/mnt/d/data/ca_hcst
dataout=/mnt/d/data/ca_hcst/esm
#
#for icss in jfm fma mam amj mjj jja jas aso son ond ndj djf; do
for icss in  aso fma; do
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

var2=sst

nyear=40  # years of forecast to be checked
nldin=17
nldout=7

nesm=16 # ensemble member #
nics=4
nmod=4

undef=-9.99e+8
eof_area=tp_np
#
cd $tmp
#if [ -d fort.11 ] ; then
/bin/rm -r $tmp/fort.*
#fi
#
#===============have SST climatology
#

cp $lcdir/simple_esm.hindcast.sst.f $tmp/esm.f

#for sst_analysis in ersst hadoisst; do
for sst_analysis in ersst; do
 
cat > parm.h << eof
c
      parameter(imx=180,jmx=89)
      parameter(nldin=$nldin,nld=$nldout,nesm=$nesm)
      parameter(nyr=$nyear)
      parameter(undef=$undef)
      parameter(ius1=11,iue1=10+$nesm) ! unit #
      parameter(nics=$nics,nmod=$nmod) 
eof
#
#
outfile=ca_hcst_simple_esm.$icss.$sst_analysis
outfile1=ca_hcst_simple_nmod_esm.$icss.${sst_analysis}_2_$var2.${eof_area}
outfile2=ca_hcst_simple_nics_esm.$icss.${sst_analysis}_2_$var2.${eof_area}
outfile3=skill_ca_hcst_simple_nmod_esm.$icss.${sst_analysis}_2_$var2.${eof_area}
outfile4=skill_ca_hcst_simple_nics_esm.$icss.${sst_analysis}_2_$var2.${eof_area}
outfile5=skill_ca_hcst_simple_all_esm.$icss.${sst_analysis}_2_$var2.${eof_area}
#gfortran -o esm.x esm.f
#gfortran -mcmodel=medium -g -o esm.x esm.f
gfortran -mcmodel=large -g -o esm.x esm.f
echo "done compiling"
#
ifile1=10
for msic in 1 2 3 4; do
#for modemax in 10 20 30 40 50 60; do
for modemax in 10 15 25 40; do

ifile1=`expr $ifile1 + 1` 
#
ln -s $datadir/$var2/ca_hcst.${sst_analysis}.$modemax.$icss.${msic}ics.${eof_area}.gr fort.$ifile1
#
done  # maxmode
done  # msics
#
ln -s $dataout/$outfile1.gr  fort.91
ln -s $dataout/$outfile2.gr  fort.92
ln -s $dataout/$outfile3.gr  fort.93
ln -s $dataout/$outfile4.gr  fort.94
ln -s $dataout/$outfile5.gr  fort.95
#
#./esm.x > $dataout/out.$outfile
./esm.x 
#
cat>$dataout/$outfile1.ctl<<EOF
dset ^$outfile1.gr
undef $undef
title EXP1
XDEF  180 LINEAR    0.  2.0
YDEF   89 LINEAR  -89.  2.0
zdef  1 linear 1 1
tdef $nyear linear $icmomidyr 1yr
EDEF 4 names 1 2 3 4
vars  14
o1 1 99 obs 1
p1 1 99 prd lm ld
o2 1 99 obs  
p2 1 99 prd 2m ld
o3 1 99 obs 
p3 1 99 prd 2m ld
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
dset ^$outfile2.gr
undef $undef
title EXP1
XDEF  180 LINEAR    0.  2.0
YDEF   89 LINEAR  -89.  2.0
zdef  1 linear 1 1
tdef $nyear linear $icmomidyr 1yr
EDEF 4 names 1 2 3 4
vars  14
o1 1 99 obs 1
p1 1 99 prd lm ld
o2 1 99 obs  
p2 1 99 prd 2m ld
o3 1 99 obs 
p3 1 99 prd 2m ld
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
cat>$dataout/$outfile3.ctl<<EOF
dset $dataout/$outfile3.gr
undef $undef
title Realtime Surface Obs
XDEF  180 LINEAR    0.  2.0
YDEF   89 LINEAR  -89.  2.0
zdef  1 levels 1
tdef  $nldout linear jan1991 1mo
vars  4
ac1   0 99 nmod 1
ac2   0 99 nmod 2
ac3   0 99 nmod 3
ac4   0 99 nmod 4
endvars
EOF
#
cat>$dataout/$outfile4.ctl<<EOF
dset $dataout/$outfile4.gr
undef $undef
title Realtime Surface Obs
XDEF  180 LINEAR    0.  2.0
YDEF   89 LINEAR  -89.  2.0
zdef  1 levels 1
tdef  $nldout linear jan1991 1mo
vars  4
ac1   0 99 ic1
ac2   0 99 ic2
ac3   0 99 ic3
ac4   0 99 ic4
endvars
EOF
#
cat>$dataout/$outfile5.ctl<<EOF
dset $dataout/$outfile5.gr
undef $undef
title Realtime Surface Obs
XDEF  180 LINEAR    0.  2.0
YDEF   89 LINEAR  -89.  2.0
zdef  1 levels 1
tdef  $nldout linear jan1991 1mo
vars  1
ac   0 99 cor
endvars
EOF
#
done  # sst_analysis
done  # sst_analysis
