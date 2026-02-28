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
version=cvcor
#
#for var2 in prec t2m; do
for var2 in prec t2m; do
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
#ite_vf=525 #son2024
ite_vf=518 #feb2024
nss_vf=`expr $ite_vf - $its_vf + 1`

undef=-9.99E+8
#
cd $tmp
#\rm fort.*
#
imx=360; jmx=180; xds=0.5; yds=-89.5; xydel=1.
#
#infile=$version.fcst.ensmsynth.$var2.mlead$mlead.3mon
infile=$version.fcst.ensmsynth.$var2.mlead$mlead.3mon.test

#outfile=$version.data_rct_ensmsynth_2d.$var2.mlead$mlead.3mon
outfile=$version.data_rct_ensmsynth_2d.$var2.mlead$mlead.3mon.test
#
cp $lcdir/data_recent_synth_fcst.f $tmp/skill.f

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
#dirin38=/home/ppeng/data/ss_fcst/pcr/2024/1
#dirin39=/home/ppeng/data/ss_fcst/pcr/2024/2
#dirin40=/home/ppeng/data/ss_fcst/pcr/2024/3
#dirin41=/home/ppeng/data/ss_fcst/pcr/2024/4
#dirin42=/home/ppeng/data/ss_fcst/pcr/2024/5
#dirin43=/home/ppeng/data/ss_fcst/pcr/2024/6
#dirin44=/home/ppeng/data/ss_fcst/pcr/2024/7
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
'open $din/$infile.ctl'
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

ln -s $dataout/$outfile.gr  fort.91
#
./skill.x 
#

#
cat>$dataout/$outfile.ctl<<EOF
dset ^$outfile.gr
undef $undef
title EXP1
xdef $imx linear $xds $xydel
ydef $jmx linear $yds $xydel
zdef  01 levels 1
tdef $nss_vf linear feb2021 1mo
edef  $mlead names 1 2 3 4 5 6 7 
vars  5
o  1 99 obs
p  1 99 prd
s  1 99 std of obs
pa  1 99 prob_a
pb  1 99 prob_b
endvars
EOF
#
done # loop var2
