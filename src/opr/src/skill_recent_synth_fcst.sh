#!/bin/sh
#=================================================
# calculate the skill of recent forecasts 
# data are from realtime.pcr_ersst_2_tpz_mld.3mon.test.sh 
#=================================================

set -eaux

lcdir=/home/ppeng/ClimateInform/src/opr/src
tmp=/home/ppeng/data/tmp_opr
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datain1=/home/ppeng/data/sst
datain2=/home/ppeng/data/tpz
dataout=/home/ppeng/data/pcr_prd
#
version=sim_1
#
#for var2 in prec t2m; do
for var2 in t2m; do
#
if [ $var2 = t2m ];  then ivar2=1; fi
if [ $var2 = prec ]; then ivar2=2; fi
#
mlead=7     # max lead of ensemble fcst
#
#clm_bgn=396  #djf1980
clm_bgn=516  #djf1990
#clm_end=`expr $clm_bgn + 480` #from jfm1981 to djf2020
clm_end=`expr $clm_bgn + 360` #from jfm1991 to djf2020
nts=397  # jfm1981
nte=921  # son2024
its_vf=482 #fma2021, count from jfm1981
ite_vf=525 #son2024
nss_vf=`expr $ite_vf - $its_vf + 1`

undef=-999.0
#
cd $tmp
#\rm fort.*
#
imx=360; jmx=180; xds=0.5; yds=-89.5; xydel=1.
#
infile0=$var2.1948_cur.3mon.total.1x1
infile1=$var2.jan1981_cur.3mon.anom
infile2=$version.fcst.ensmsynth.$var2.mlead$mlead.3mon

outfile1=$version.skill_rct_ensmsynth_1d.$var2.mlead$mlead.3mon
outfile2=$version.skill_rct_ensmsynth_2d.$var2.mlead$mlead.3mon
#
# have TPZ anom
#
cat >tpzanom<<EOF
run anom.gs
EOF
cat >anom.gs<<EOF
'reinit'
'open $datain2/$infile0.ctl'
'set x 1 $imx'
'set y 1 $jmx'
'set t 1 12'
*anom wrt clim 1991-2020
'define clm=ave($var2,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from jfm1991 to curr
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $dataout/$infile1.gr'
'set t $nts $nte'
'd $var2-clm'
'c'
EOF
#
/usr/bin/grads -bl <tpzanom
#
cat>$dataout/$infile1.ctl<<EOF
dset ^$infile1.gr
undef -9.99E+8
title EXP1
XDEF  $imx linear   0.5  1.0
ydef  $jmx linear -89.5  1.0
zdef  1 linear 1 1
tdef  999 linear jan1981 1mon
vars  1
$var2 1 99 $var2 anom
endvars
EOF
#
cp $lcdir/skill_recent_synth_fcst.f $tmp/skill.f

cat > parm.h << eof
c
      parameter(its_vf=$its_vf,ite_vf=$ite_vf)  ! length of tpz anom
      parameter(nss=$nss_vf) 
      parameter(imx=$imx,jmx=$jmx) ! t2m or prec
      parameter(nlead=$mlead) 
      parameter(ivar2=$ivar2) 
c
eof
#
gfortran -o skill.x skill.f

echo "done compiling"

if [ -f fort.11 ] ; then
/bin/rm $tmp/fort.*
fi
#

nss_vf=`expr $ite_vf - $its_vf + 1`

dirin1=/home/ppeng/data/ss_fcst/pcr/2020/12
dirin2=/home/ppeng/data/ss_fcst/pcr/2021/1
dirin3=/home/ppeng/data/ss_fcst/pcr/2021/2
dirin4=/home/ppeng/data/ss_fcst/pcr/2021/3
dirin5=/home/ppeng/data/ss_fcst/pcr/2021/4
dirin6=/home/ppeng/data/ss_fcst/pcr/2021/5
dirin7=/home/ppeng/data/ss_fcst/pcr/2021/6
dirin8=/home/ppeng/data/ss_fcst/pcr/2021/7
dirin9=/home/ppeng/data/ss_fcst/pcr/2021/8
dirin10=/home/ppeng/data/ss_fcst/pcr/2021/9
dirin11=/home/ppeng/data/ss_fcst/pcr/2021/10
dirin12=/home/ppeng/data/ss_fcst/pcr/2021/11
dirin13=/home/ppeng/data/ss_fcst/pcr/2021/12
dirin14=/home/ppeng/data/ss_fcst/pcr/2022/1
dirin15=/home/ppeng/data/ss_fcst/pcr/2022/2
dirin16=/home/ppeng/data/ss_fcst/pcr/2022/3
dirin17=/home/ppeng/data/ss_fcst/pcr/2022/4
dirin18=/home/ppeng/data/ss_fcst/pcr/2022/5
dirin19=/home/ppeng/data/ss_fcst/pcr/2022/6
dirin20=/home/ppeng/data/ss_fcst/pcr/2022/7
dirin21=/home/ppeng/data/ss_fcst/pcr/2022/8
dirin22=/home/ppeng/data/ss_fcst/pcr/2022/9
dirin23=/home/ppeng/data/ss_fcst/pcr/2022/10
dirin24=/home/ppeng/data/ss_fcst/pcr/2022/11
dirin25=/home/ppeng/data/ss_fcst/pcr/2022/12
dirin26=/home/ppeng/data/ss_fcst/pcr/2023/1
dirin27=/home/ppeng/data/ss_fcst/pcr/2023/2
dirin28=/home/ppeng/data/ss_fcst/pcr/2023/3
dirin29=/home/ppeng/data/ss_fcst/pcr/2023/4
dirin30=/home/ppeng/data/ss_fcst/pcr/2023/5
dirin31=/home/ppeng/data/ss_fcst/pcr/2023/6
dirin32=/home/ppeng/data/ss_fcst/pcr/2023/7
dirin33=/home/ppeng/data/ss_fcst/pcr/2023/8
dirin34=/home/ppeng/data/ss_fcst/pcr/2023/9
dirin35=/home/ppeng/data/ss_fcst/pcr/2023/10
dirin36=/home/ppeng/data/ss_fcst/pcr/2023/11
dirin37=/home/ppeng/data/ss_fcst/pcr/2023/12
dirin38=/home/ppeng/data/ss_fcst/pcr/2024/1
dirin39=/home/ppeng/data/ss_fcst/pcr/2024/2
dirin40=/home/ppeng/data/ss_fcst/pcr/2024/3
dirin41=/home/ppeng/data/ss_fcst/pcr/2024/4
dirin42=/home/ppeng/data/ss_fcst/pcr/2024/5
dirin43=/home/ppeng/data/ss_fcst/pcr/2024/6
dirin44=/home/ppeng/data/ss_fcst/pcr/2024/7
#
echo "sart idata loop"

#############################
# have fcst data
#############################
idata=1
while [ $idata -le $nss_vf ]; do

din=$(eval echo \${dirin${idata}})

echo $din

cat >havefcst<<EOF
run fcst.gs
EOF
cat >fcst.gs<<EOF
'reinit'
'open $din/$infile2.ctl'
'set x 1 $imx'
'set y 1 $jmx'
'set gxout fwrite'
'set fwrite fcstdata.$idata'
ld=1
while ( ld <= $mlead)
'set t 'ld
'd $var2'
'd stdo'
'd pa'
'd pb'
ld=ld+1
endwhile
'c'
EOF
#
#
/usr/bin/grads -bl <havefcst
#
idata=`expr $idata + 1`
echo $idata
done

# cat themm together
mv fcstdata.1 fdata.1
idata=2
while  [ $idata -le $nss_vf ]
do

im=$((idata-1))

cat fdata.$im  fcstdata.$idata > fdata.$idata

\rm fdata.$im

idata=$(( idata+1 ))
done  # for idata
#
\rm fcstdata.*
#

ln -s fdata.$nss_vf     fort.11

ln -s $dataout/$infile1.gr     fort.10

ln -s $dataout/$outfile1.gr  fort.91
ln -s $dataout/$outfile2.gr  fort.92
#
./skill.x > $dataout/skill_recent.synth.$var2.mlead$mlead.out
#

cat>$dataout/$outfile1.ctl<<EOF
dset ^$outfile1.gr
undef $undef
title EXP1
xdef 1 linear $xds $xydel
ydef 1 linear $yds $xydel
zdef 1 linear 1 1
tdef $nss_vf linear feb2021 1mo
edef $mlead names 1 2 3 4 5 6 7 
vars  8
cor1   1 99 20N-70N sp_cor
rms1   1 99 20N-70N sp_rms
cor2   1 99 CONUS sp_cor
rms2   1 99 CONUS sp_rms
hss1   1 99 20N-70N sp_hss
hss2   1 99 CONUS sp_hss
rpss1  1 99 20N-70NCONUS rpss_s
rpss2  1 99 CONUS rpss_s
endvars
EOF
#
cat>$dataout/$outfile2.ctl<<EOF
dset ^$outfile2.gr
undef $undef
title EXP1
xdef $imx linear $xds $xydel
ydef $jmx linear $yds $xydel
zdef  1 linear 1 1
tdef $nss_vf linear feb2021 1mo
edef  $mlead names 1 2 3 4 5 6 7 
vars  6
o  1 99 obs
p  1 99 prd
s  1 99 std of obs
pa  1 99 prob_a
pb  1 99 prob_b
h  1 99 hit
endvars
EOF
#
done # loop var2
