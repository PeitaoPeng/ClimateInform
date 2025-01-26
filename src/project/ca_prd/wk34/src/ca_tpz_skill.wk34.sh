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
#var=sat
var=prcp
#
for season in winter; do
#
nic=4  #number of ICs
neof=4  #number of EOFs

nseason=35  # 1949-2015
#
cp $lcdir/ca_tpz_skill.wk34.f $tmp/ca_skill.f
#
cat > parm.h << eof
      parameter(ims=144,jms=73)   !input sst dimension
      parameter(nic=$nic)
      parameter(neof=$neof)
      parameter(nseason=35)
eof
#
gfortran -o skill.x ca_skill.f
echo "done compiling"

/bin/rm $tmp/fort.*
#
ifile=10
for mwic in 1 2 3 4; do
for modemax in 15 20 25 35; do
#
ifile=`expr $ifile + 1`
#
ln -s $datadir/psi200_${var}_wk34.$season.${mwic}ics.mm$modemax.i3e fort.$ifile
done
done
#
ln -s $datadir/psi200_${var}_wk34.$season.obs.i3e  fort.10
ln -s $datadir/ac_2d.wk34.$var.$season.gr fort.70
ln -s $datadir/ac_2d.wk34.mwic_vs_neof.$var.$season.gr fort.75
#
skill.x 
#
cat>$datadir/ac_2d.wk34.$var.$season.ctl<<EOF
dset ^ac_2d.wk34.$var.$season.gr
undef -9.99E+8
title EXP1
xdef  144 linear   0.  2.5
ydef   73 linear  -90  2.5
zdef  1 linear 1 1
tdef  $neof linear jan1981 1mon
vars  1
ac    1 99 ac skill
endvars
EOF
#
cat>$datadir/ac_2d.wk34.mwic_vs_neof.$var.$season.ctl<<EOF
dset ^ac_2d.wk34.mwic_vs_neof.$var.$season.gr
undef -9.99E+8
title EXP1
xdef  4 linear   0.  2.5
ydef  4 linear  -90  2.5
zdef  1 linear 1 1
tdef  1 linear jan1981 1mon
vars  1
ac    1 99 ac ic vs ie
endvars
EOF
#
done # season loop
