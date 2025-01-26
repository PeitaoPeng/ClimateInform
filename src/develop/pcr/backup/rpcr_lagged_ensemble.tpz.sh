#
#======================================
# PCR ensemble fcst and skill
#=======================================

set -eaux

lcdir=/home/ppeng/src/develop/pcr
tmp=/home/ppeng/tmp
datadir=/home/ppeng/data/test
#
var1=ersst
#var1=hadoisst
#var2=hgt # t2m,prec,hgt
#nmod=15
#
leadmax=20 # maximum lead
nyr=28  # 1995-2022
eof_area=tp_nml #tp_nml
del=3 # =1 if monthly sst
undef=-999.0
#
for nmod in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25; do
for var2 in prec; do
for tgtss in djf; do
#
cp $lcdir/prc_lagged_ensemble.f $tmp/pcr.f

cd $tmp
#
cat > parm.h << eof
       parameter(nyr=$nyr,leadmax=$leadmax)
       parameter(imx=360,jmx=180)
eof
#
outfile=${var1}_2_$var2.nmod$nmod.$tgtss.${eof_area}
outfile1=rpcr_ens.$var2.$tgtss.95-22.nmod$nmod.${var1}_eof_${eof_area}
outfile2=skill.ens_rpcr_vs_obs.$var2.$tgtss.95-22.nmod$nmod.${var1}_eof_${eof_area}
#
\rm $tmp/fort.*
#
gfortran -o pcr.x pcr.f
echo "done compiling"
#
ilead=1
while [ $ilead -le $leadmax ]; do
ch1=`expr 10 + $ilead`
ch2=`expr 40 + $ilead`
ln -s $datadir/skill.rpcr_vs_obs.$var2.$tgtss.ld$ilead.95-22.nmod$nmod.${var1}_eof_${eof_area}.gr fort.$ch1
ln -s $datadir/rpcr_$var2.$tgtss.ld$ilead.95-22.nmod$nmod.${var1}_eof_${eof_area}.gr fort.$ch2
ilead=`expr $ilead + 1`
echo $ilead
echo $ch1
echo $ch2
done
#
#ln -s $datadir/skill.pcr_vs_obs.$var2.$tgtss.ld$ilead.95-22.nmod$nmod.${var1}_eof_${eof_area}.gr fort.11
ln -s $datadir/$outfile1.gr           fort.71
ln -s $datadir/$outfile2.gr           fort.72
#
./pcr.x > $datadir/out_ens_rpcr.$outfile
#
cat>$datadir/$outfile1.ctl<<EOF
dset $datadir/$outfile1.gr
undef $undef
title Realtime Surface Obs
xdef  360 linear   0.5 1.
ydef  180 linear -89.5 1.
zdef  1 levels 1
tdef  999 linear jan1995 1yr
vars  5
o     0 99 obs
w0    0 99 no wt
w1    0 99 wt=+r/sigma +r
w2    0 99 wt=+-r**2/sigma +r**2
w3    0 99 wt=+r**2/sigma +r**2
endvars
EOF
#
cat>$datadir/$outfile2.ctl<<EOF
dset $datadir/$outfile2.gr
undef $undef
title Realtime Surface Obs
xdef  360 linear   0.5 1.
ydef  180 linear -89.5 1.
zdef  1 levels 1
tdef  1 linear jan1995 1yr
vars  10
cor1   0 99 no wt
rms1   0 99 no wt
cor2   0 99 wt=+r/sigma r
rms2   0 99 wt=+r/sigma r
cor3   0 99 wt=+-r**2/sigma r**2 
rms3   0 99 wt=+-r**2/sigma r**2
cor4   0 99 wt=r**2/sigma r**2
rms4   0 99 wt=r**2/sigma r**2
cor5   0 99 ld1 prc
rms5   0 99 ld1 pcr
endvars
EOF
#
done # loop tgtss
done # loop var2
done # loop nmod
