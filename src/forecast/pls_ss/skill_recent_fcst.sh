#!/bin/sh
#=================================================
# calculate the skill of recent forecasts 
# data are from realtime.pcr_ersst_2_tpz_mld.3mon.test.sh 
#=================================================

set -eaux

lcdir=/home/ppeng/src/forecast/pls_ss
tmp=/home/ppeng/data/tmp_opr
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datain1=/home/ppeng/data/sst
datain2=/home/ppeng/data/tpz
dataout=/home/ppeng/data/pls_prd
#
var1=ersst
eof_area=tp_nml   #30S-60N
tpz_area=nhml
#
lagmax=12   # maximum lag
mlead=1     # max lead of ensemble fcst
ncv=1
mrpc=40
mpls=7
#
clm_bgn=396  #djf1980
clm_end=`expr $clm_bgn + 480` #from jfm1981 to djf2020
#clm_bgn=0  #djf1980
#clm_end=`expr $clm_bgn + 900` #from jfm1981 to djf2020
nts=397  # jfm1981
nte=913  # jfm2024
its_vf=494 #fma2022, count from jfm1981
ite_vf=517 #jfm2024
nss_vf=`expr $ite_vf - $its_vf + 1`

undef=-999.0
#
cd $tmp
#
imx=360; jmx=180; xds=0.5; yds=-89.5; xydel=1.
#
for var2 in prec; do # prec, t2m, hgt
#
infile0=$var2.1948_cur.3mon.total.1x1
infile1=$var2.jan1981_cur.3mon.anom
infile2=fcst.pls.$var1.2.$var2.mlag$lagmax.mlead$mlead.mrpc$mrpc.mpls$mpls.cv$ncv.tpz_area_${tpz_area}.3mon

outfile1=skill_rct_1d.$var1.2.$var2.mlag$lagmax.mlead$mlead.mrpc$mrpc.mpls$mpls.cv$ncv.3mon
outfile2=skill_rct_2d.$var1.2.$var2.mlag$lagmax.mlead$mlead.mrpc$mrpc.mpls$mpls.cv$ncv.3mon
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
*anom wrt clim 1981-2020
'define clm=ave($var2,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from jfm1981 to curr
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
cp $lcdir/skill_recent_fcst.f $tmp/skill.f

cat > parm.h << eof
c
      parameter(its_vf=$its_vf,ite_vf=$ite_vf)  ! length of tpz anom
      parameter(nt=$ite_vf,nss=$nss_vf) 
      parameter(imx=$imx,jmx=$jmx) ! t2m or prec
      parameter(nlead=$mlead) 
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

dirin1=/home/ppeng/data/ss_fcst/pls/2021/12
dirin2=/home/ppeng/data/ss_fcst/pls/2022/1
dirin3=/home/ppeng/data/ss_fcst/pls/2022/2
dirin4=/home/ppeng/data/ss_fcst/pls/2022/3
dirin5=/home/ppeng/data/ss_fcst/pls/2022/4
dirin6=/home/ppeng/data/ss_fcst/pls/2022/5
dirin7=/home/ppeng/data/ss_fcst/pls/2022/6
dirin8=/home/ppeng/data/ss_fcst/pls/2022/7
dirin9=/home/ppeng/data/ss_fcst/pls/2022/8
dirin10=/home/ppeng/data/ss_fcst/pls/2022/9
dirin11=/home/ppeng/data/ss_fcst/pls/2022/10
dirin12=/home/ppeng/data/ss_fcst/pls/2022/11
dirin13=/home/ppeng/data/ss_fcst/pls/2022/12
dirin14=/home/ppeng/data/ss_fcst/pls/2023/1
dirin15=/home/ppeng/data/ss_fcst/pls/2023/2
dirin16=/home/ppeng/data/ss_fcst/pls/2023/3
dirin17=/home/ppeng/data/ss_fcst/pls/2023/4
dirin18=/home/ppeng/data/ss_fcst/pls/2023/5
dirin19=/home/ppeng/data/ss_fcst/pls/2023/6
dirin20=/home/ppeng/data/ss_fcst/pls/2023/7
dirin21=/home/ppeng/data/ss_fcst/pls/2023/8
dirin22=/home/ppeng/data/ss_fcst/pls/2023/9
dirin23=/home/ppeng/data/ss_fcst/pls/2023/10
dirin24=/home/ppeng/data/ss_fcst/pls/2023/11
#
#ich=1
#while [ $ich -le $nss_vf ]; do
#ch1=`expr 10 + $ich`
#ln -s $dirin$ich/$infile2.gr     fort.$ch1
#ich=`expr $ich + 1`
#echo $ich
#done

ln -s $dirin1/$infile2.gr     fort.11
ln -s $dirin2/$infile2.gr     fort.12
ln -s $dirin3/$infile2.gr     fort.13
ln -s $dirin4/$infile2.gr     fort.14
ln -s $dirin5/$infile2.gr     fort.15
ln -s $dirin6/$infile2.gr     fort.16
ln -s $dirin7/$infile2.gr     fort.17
ln -s $dirin8/$infile2.gr     fort.18
ln -s $dirin9/$infile2.gr     fort.19
ln -s $dirin10/$infile2.gr     fort.20
ln -s $dirin11/$infile2.gr     fort.21
ln -s $dirin12/$infile2.gr     fort.22
ln -s $dirin13/$infile2.gr     fort.23
ln -s $dirin14/$infile2.gr     fort.24
ln -s $dirin15/$infile2.gr     fort.25
ln -s $dirin16/$infile2.gr     fort.26
ln -s $dirin17/$infile2.gr     fort.27
ln -s $dirin18/$infile2.gr     fort.28
ln -s $dirin19/$infile2.gr     fort.29
ln -s $dirin20/$infile2.gr     fort.30
ln -s $dirin21/$infile2.gr     fort.31
ln -s $dirin22/$infile2.gr     fort.32
ln -s $dirin23/$infile2.gr     fort.33
ln -s $dirin24/$infile2.gr     fort.34

ln -s $dataout/$infile1.gr           fort.10
#
ln -s $dataout/$outfile1.gr  fort.91
ln -s $dataout/$outfile2.gr  fort.92
#
./skill.x > $dataout/skill_recent.$var1.2.$var2.mlag$lagmax.mlead$mlead.out
#
cat>$dataout/$outfile1.ctl<<EOF
dset ^$outfile1.gr
undef $undef
title EXP1
xdef 1 linear $xds $xydel
ydef 1 linear $yds $xydel
zdef 1 linear 1 1
tdef $nss_vf linear feb2022 1mo
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
cat>$dataout/$outfile2.ctl<<EOF
dset ^$outfile2.gr
undef $undef
title EXP1
xdef $imx linear $xds $xydel
ydef $jmx linear $yds $xydel
zdef  1 linear 1 1
tdef $nss_vf linear feb2022 1mo
edef  $mlead names 1 
vars  4
o  1 99 obs
s  1 99 std of obs
p  1 99 hcst
h  1 99 hit
endvars
EOF
#
done # var2 loop
