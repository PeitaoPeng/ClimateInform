#!/bin/sh

set -eaux
#cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
# for skill check and other diagnostics
#ccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 
lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
datadir=/cpc/home/wd52pp/data/casst
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
outdata=/cpc/home/wd52pp/data/casst
#
cd $tmp
#
var=prec
for eof_range in tp_ml tp_np; do
#eof_range=tp_np   #30S-60N
#eof_range=tp_ml   #45S-45N
icseason=jas
ic_mid_mon=aug
#
nyear=67  # 1949-2015
nskip=31
nseason=`expr $nyear - 2 - $nskip`
nic=4  #number of ICs
neof=3  #number of EOFs
mlead=10  #maximum lead
mld=`expr $mlead + 1` 
#
cp $lcdir/ca_tpz_skill.f $tmp/ca_skill.f
#
cat > parm.h << eof
      parameter(ims=360,jms=180)   !input sst dimension
      parameter(nseason=$nseason)
      parameter(nld=$mld)
      parameter(nic=$nic)
      parameter(neof=$neof)
eof
#
gfortran -O3 -mcmodel=medium -g -o skill.x ca_skill.f
echo "done compiling"

/bin/rm $tmp/fort.*
#
ln -s $datadir/ca_hcst.$var.ersst.15.$icseason.1ics.${eof_range}.gr fort.11
ln -s $datadir/ca_hcst.$var.ersst.25.$icseason.1ics.${eof_range}.gr fort.12
ln -s $datadir/ca_hcst.$var.ersst.40.$icseason.1ics.${eof_range}.gr fort.13
ln -s $datadir/ca_hcst.$var.ersst.15.$icseason.2ics.${eof_range}.gr fort.14
ln -s $datadir/ca_hcst.$var.ersst.25.$icseason.2ics.${eof_range}.gr fort.15
ln -s $datadir/ca_hcst.$var.ersst.40.$icseason.2ics.${eof_range}.gr fort.16
ln -s $datadir/ca_hcst.$var.ersst.15.$icseason.3ics.${eof_range}.gr fort.17
ln -s $datadir/ca_hcst.$var.ersst.25.$icseason.3ics.${eof_range}.gr fort.18
ln -s $datadir/ca_hcst.$var.ersst.40.$icseason.3ics.${eof_range}.gr fort.19
ln -s $datadir/ca_hcst.$var.ersst.15.$icseason.4ics.${eof_range}.gr fort.20
ln -s $datadir/ca_hcst.$var.ersst.25.$icseason.4ics.${eof_range}.gr fort.21
ln -s $datadir/ca_hcst.$var.ersst.40.$icseason.4ics.${eof_range}.gr fort.22
ln -s $datadir/ca_hcst.$var.hadoisst.15.$icseason.1ics.${eof_range}.gr fort.23
ln -s $datadir/ca_hcst.$var.hadoisst.25.$icseason.1ics.${eof_range}.gr fort.24
ln -s $datadir/ca_hcst.$var.hadoisst.40.$icseason.1ics.${eof_range}.gr fort.25
ln -s $datadir/ca_hcst.$var.hadoisst.15.$icseason.2ics.${eof_range}.gr fort.26
ln -s $datadir/ca_hcst.$var.hadoisst.25.$icseason.2ics.${eof_range}.gr fort.27
ln -s $datadir/ca_hcst.$var.hadoisst.40.$icseason.2ics.${eof_range}.gr fort.28
ln -s $datadir/ca_hcst.$var.hadoisst.15.$icseason.3ics.${eof_range}.gr fort.29
ln -s $datadir/ca_hcst.$var.hadoisst.25.$icseason.3ics.${eof_range}.gr fort.30
ln -s $datadir/ca_hcst.$var.hadoisst.40.$icseason.3ics.${eof_range}.gr fort.31
ln -s $datadir/ca_hcst.$var.hadoisst.15.$icseason.4ics.${eof_range}.gr fort.32
ln -s $datadir/ca_hcst.$var.hadoisst.25.$icseason.4ics.${eof_range}.gr fort.33
ln -s $datadir/ca_hcst.$var.hadoisst.40.$icseason.4ics.${eof_range}.gr fort.34
#
ln -s $outdata/ac3d.$var.$icseason.${eof_range}.gr fort.85
#
skill.x 
#
cat>$outdata/ac3d.$var.$icseason.${eof_range}.ctl<<EOF
dset ^ac3d.$var.$icseason.${eof_range}.gr
undef -9.99E+8
title EXP1
xdef  360 linear   0.  1.
ydef  180 linear -89.5 1.
zdef  1 linear 1 1
tdef  $mld linear ${ic_mid_mon}1981 1mon
vars  1
ac    1 99 ac skill
endvars
EOF
#
done # eof_rang loop
