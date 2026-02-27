#
#======================================
# SVD ensemble fcst and skill
#=======================================

set -eaux

lcdir=/home/ppeng/src/develop/svd
tmp=/home/ppeng/tmp
datadir=/home/ppeng/data/test
#
var1=ersst
leadmax=20 # maximum lead
nyr=29  # 1995-2023
sst_area=tp_nml # gltp,tp_nml
tpz_area=nhml # nhml,na,conus
del=3 # =1 if monthly sst
undef=-999.0
#
#for msvd in 1 3 5 7 9 11 13 15; do
for msvd in 13; do
for var2 in prec; do
for tgtss in djf; do
#
cp $lcdir/svd_lagged_ensemble.f $tmp/svd.f

cd $tmp
#
cat > parm.h << eof
       parameter(nyr=$nyr,leadmax=$leadmax)
       parameter(imx=360,jmx=180)
eof
#
outfile=${var1}_2_$var2.msvd$msvd.$tgtss.sst_${sst_area}.tpz_${tpz_area}
outfile1=svd_ens.$var2.$tgtss.95-23.msvd$msvd.${var1}_${sst_area}.tpz_${tpz_area}
outfile2=skill.ens_svd_vs_obs.$var2.$tgtss.95-23.msvd$msvd.${var1}_${sst_area}.tpz_${tpz_area}
#
\rm $tmp/fort.*
#
gfortran -o svd.x svd.f
echo "done compiling"
#
ilead=1
while [ $ilead -le $leadmax ]; do
chn=`expr 10 + $ilead`
ln -s $datadir/svd_prd.$var2.$tgtss.ld$ilead.95-23.msvd$msvd.${var1}_${sst_area}.tpz_${tpz_area}.gr fort.$chn
ilead=`expr $ilead + 1`
echo $ilead
echo $chn
done
#
ln -s $datadir/$outfile1.gr           fort.71
ln -s $datadir/$outfile2.gr           fort.72
#
./svd.x > $datadir/out_ens_svd.$outfile
#
cat>$datadir/$outfile1.ctl<<EOF
dset $datadir/$outfile1.gr
undef $undef
title Realtime Surface Obs
xdef  360 linear   0.5 1.
ydef  180 linear -89.5 1.
zdef  1 levels 1
tdef  999 linear jan1995 1yr
vars  2
o     0 99 obs
p     0 99 no wt
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
vars  2
cor   0 99 wt=+-r**2/sigma r**2 
rms   0 99 wt=+-r**2/sigma r**2
endvars
EOF
#
done # loop tgtss
done # loop var2
done # loop msvd
