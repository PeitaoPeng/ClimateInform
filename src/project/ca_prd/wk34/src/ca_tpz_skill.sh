#!/bin/sh

set -eaux
#cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
# for skill check and other diagnostics
#ccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 
lcdir=/cpc/home/wd52pp/project/ca_prd/wk34/src
datadir=/cpc/home/wd52pp/data/wk34
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
cd $tmp
#
var=sat
season=winter
nic=4  #number of ICs
neof=4  #number of EOFs
mld=6  #maximum lead
#
cp $lcdir/ca_tpz_skill.f $tmp/ca_skill.f
#
cat > parm.h << eof
      parameter(ims=144,jms=73)   !input sst dimension
      parameter(nld=$mld)
      parameter(nic=$nic)
      parameter(neof=$neof)
eof
#
gfortran -O3 -mcmodel=medium -g -o skill.x ca_skill.f
echo "done compiling"

/bin/rm $tmp/fort.*
#
ln -s $datadir/ac_2d_ca_psi200_${var}_wkly.$season.1ics.mm15.detrd.i3e fort.11
ln -s $datadir/ac_2d_ca_psi200_${var}_wkly.$season.1ics.mm20.detrd.i3e fort.12
ln -s $datadir/ac_2d_ca_psi200_${var}_wkly.$season.1ics.mm25.detrd.i3e fort.13
ln -s $datadir/ac_2d_ca_psi200_${var}_wkly.$season.1ics.mm35.detrd.i3e fort.14
ln -s $datadir/ac_2d_ca_psi200_${var}_wkly.$season.2ics.mm15.detrd.i3e fort.15
ln -s $datadir/ac_2d_ca_psi200_${var}_wkly.$season.2ics.mm20.detrd.i3e fort.16
ln -s $datadir/ac_2d_ca_psi200_${var}_wkly.$season.2ics.mm25.detrd.i3e fort.17
ln -s $datadir/ac_2d_ca_psi200_${var}_wkly.$season.2ics.mm35.detrd.i3e fort.18
ln -s $datadir/ac_2d_ca_psi200_${var}_wkly.$season.3ics.mm15.detrd.i3e fort.19
ln -s $datadir/ac_2d_ca_psi200_${var}_wkly.$season.3ics.mm20.detrd.i3e fort.20
ln -s $datadir/ac_2d_ca_psi200_${var}_wkly.$season.3ics.mm25.detrd.i3e fort.21
ln -s $datadir/ac_2d_ca_psi200_${var}_wkly.$season.3ics.mm35.detrd.i3e fort.22
ln -s $datadir/ac_2d_ca_psi200_${var}_wkly.$season.4ics.mm15.detrd.i3e fort.23
ln -s $datadir/ac_2d_ca_psi200_${var}_wkly.$season.4ics.mm20.detrd.i3e fort.24
ln -s $datadir/ac_2d_ca_psi200_${var}_wkly.$season.4ics.mm25.detrd.i3e fort.25
ln -s $datadir/ac_2d_ca_psi200_${var}_wkly.$season.4ics.mm35.detrd.i3e fort.26
#
ln -s $datadir/ac3d.ca_psi200_$var.wkly.$season.gr fort.85
#
skill.x 
#
cat>$datadir/ac3d.ca_psi200_$var.wkly.$season.ctl<<EOF
dset ^ac3d.ca_psi200_$var.wkly.$season.gr
undef -9.99E+8
title EXP1
xdef  4 linear    0.  2.5
ydef  4 linear  -90   2.5
zdef  1 linear 1 1
tdef  $mld linear jan1981 1mon
vars  1
ac    1 99 ac skill
endvars
EOF
#
