ite_vf#!/bin/sh

set -eaux

lcdir=/home/ppeng/src/forecast/pcr_ss
tmp=/home/ppeng/data/tmp_opr
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datain1=/home/ppeng/data/sst
datain2=/home/ppeng/data/tpz
dataout=/home/ppeng/data/pcr_prd
#
var1=ersst
eof_area=tp_nml   #30S-60N
#
lagmax=12   # maximum lag
mlead=1     # max lead of ensemble fcst
nmod=70
#
ic_yy=2023
ic_mo=11
its_vf=1  # 1981
ite_vf=42 # 2022

undef=-999.0
#
cd $tmp
#
imx=360; jmx=180; xds=0.5; yds=-89.5; xydel=1.
#
for var2 in prec; do # prec, t2m, hgt
#
infile=hcst.$var1.2.$var2.mlag$lagmax.mlead$mlead.nmod$nmod.3mon
outfile1=skill_hcst_1d.$var1.2.$var2.mlag$lagmax.mlead$mlead.nmod$nmod.3mon
#
# have TPZ anom
#
cp $lcdir/skill_hcst.f $tmp/skill.f

cat > parm.h << eof
c
      parameter(nt=$ite_vf)  ! length of tpz anom
      parameter(imx=$imx,jmx=$jmx) ! t2m or prec
      parameter(nlead=$mlead) 
c
eof
#
gfortran -o skill.x skill.f

echo "done compiling"

if [ -f fort.10 ] ; then
/bin/rm $tmp/fort.*
fi
#
 
dirin=/home/ppeng/data/ss_fcst/pcr/$ic_yy/$ic_mo
#
ln -s $dirin/$infile.gr     fort.10
#
ln -s $dataout/$outfile1.gr  fort.91
#
./skill.x > $dataout/skill_hcst.$var1.2.$var2.mlag$lagmax.mlead$mlead.nmod$nmod.out
#
cat>$dataout/$outfile1.ctl<<EOF
dset ^$outfile1.gr
undef $undef
title EXP1
xdef 1 linear $xds $xydel
ydef 1 linear $yds $xydel
zdef 1 linear 1 1
tdef $ite_vf linear feb2022 1mo
edef $mlead names 1
vars  6
cor1   1 99 20N-70N sp_cor
rms1   1 99 20N-70N sp_rms
cor2   1 99 CONUS sp_cor
rms2   1 99 CONUS sp_rms
hss1   1 99 20N-70N sp_hss
hss2   1 99 CONUS sp_hss
endvars
EOF
#
done # var2 loop
