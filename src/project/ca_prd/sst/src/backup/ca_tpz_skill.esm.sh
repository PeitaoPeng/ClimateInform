#!/bin/sh

set -eaux
#cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
# for skill check and other diagnostics
#ccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 
lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
datadir=/cpc/consistency/id/ca_hcst/seasonal
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
outdata=/cpc/consistency/id/ca_hcst/skill_ss
#
cd $tmp
#
#for var in t2m prec hgt; do
for var in t2m; do
#for icss in jfm fma mam amj mjj jja jas aso son ond ndj djf; do
for icss in son; do
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
nyear=38  # 1982-2020
mld=17  # lead 0-13
#
cp $lcdir/ca_tpz_skill.esm.f $tmp/ca_skill.f
#
cat > parm.h << eof
      parameter(ims=360,jms=180)   !input dimension
      parameter(nseason=$nyear)
      parameter(nld=$mld)
eof
#
gfortran -O3 -mcmodel=medium -g -o skill.x ca_skill.f
echo "done compiling"

/bin/rm $tmp/fort.*
#
ln -s $datadir/cahcst.$var.${icss}_ic.esm.gr fort.11
#
ln -s $outdata/ac_t.cahcst.$var.$icss.esm.gr fort.85
#
skill.x 
#
cat>$outdata/ac_t.cahcst.$var.$icss.esm.ctl<<EOF
dset ^ac_t.cahcst.$var.$icss.esm.gr
undef -9.99E+8
title EXP1
xdef  360 linear   0.  1.
ydef  180 linear -89.5 1.
zdef  1 linear 1 1
tdef  $mld linear ${icmomid}1981 1mon
vars  1
ac    1 99 ac skill
endvars
EOF
#
done # icss loop
done # var loop
