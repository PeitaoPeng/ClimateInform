#
#======================================
# PCR ensemble fcst and skill
#=======================================

set -eaux

lcdir=/home/ppeng/src/develop/pcr
tmp=/home/ppeng/tmp
#datain=/home/ppeng/data/test
datain=$tmp
dataout=$datain
#
var1=ersst
#
nyr=33  # 1991-2022
eof_area=tp_nml #tp_nml
out_mean=3mon
nlead=12 
undef=-999.0
#
for nmod in 20 46; do
for leadmax in 36; do
for var2 in prec; do
for tgtss in djf; do
#
cp $lcdir/prc_lagged_ensemble.nlead.f $tmp/pcr.f

cd $tmp
#
cat > parm.h << eof
       parameter(nyr=$nyr,leadmax=$leadmax,nlead=$nlead)
       parameter(imx=360,jmx=180)
eof
#
outfile=${var1}_2_$var2.nmod$nmod.leadmax$leadmax.$tgtss.${eof_area}.$out_mean
outfile1=pcr_ens.$var2.$tgtss.nmod$nmod.leadmax$leadmax.${var1}_eof_${eof_area}.$out_mean
outfile2=skill.ens_pcr_vs_obs.$var2.$tgtss.nmod$nmod.leadmax$leadmax.${var1}_eof_${eof_area}.$out_mean
#
\rm $tmp/fort.*
#
gfortran -o pcr.x pcr.f
echo "done compiling"
#
ilead=1
while [ $ilead -le $leadmax ]; do
ch1=`expr 10 + $ilead`
ch2=`expr 50 + $ilead`
ln -s $datain/skill.pcr_vs_obs.$var2.$tgtss.ld$ilead.nmod$nmod.${var1}_eof_${eof_area}.$out_mean.gr fort.$ch1
ln -s $datain/pcr_$var2.$tgtss.ld$ilead.nmod$nmod.${var1}_eof_${eof_area}.$out_mean.gr fort.$ch2
ilead=`expr $ilead + 1`
echo $ilead
echo $ch1
echo $ch2
done
#
ln -s $dataout/$outfile1.gr           fort.91
ln -s $dataout/$outfile2.gr           fort.92
#
./pcr.x > $dataout/out_ens_pcr.$outfile
#
cat>$dataout/$outfile1.ctl<<EOF
dset $dataout/$outfile1.gr
undef $undef
title Realtime Surface Obs
xdef  360 linear   0.5 1.
ydef  180 linear -89.5 1.
zdef  1 levels 1
tdef  $nyr linear jan1991 1yr
edef  $nlead names 1 2 3 4 5 6 7 8 9 10 11 12
vars  5
o     0 99 obs
w0    0 99 no wt
w1    0 99 wt=+r/sigma +r
w2    0 99 wt=+-r**2/sigma +r**2
w3    0 99 wt=+r**2/sigma +r**2
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
vars  10
cor1   0 99 no wt
rms1   0 99 no wt
cor2   0 99 wt=+r/sigma r
rms2   0 99 wt=+r/sigma r
cor3   0 99 wt=+-r**2/sigma r**2 
rms3   0 99 wt=+-r**2/sigma r**2
cor4   0 99 wt=r**2/sigma r**2
rms4   0 99 wt=r**2/sigma r**2
cor5   0 99 lead_kld
rms5   0 99 lead_kld
endvars
EOF
#
done # loop tgtss
done # loop var2
done # loop leadmax
done # loop nmod
