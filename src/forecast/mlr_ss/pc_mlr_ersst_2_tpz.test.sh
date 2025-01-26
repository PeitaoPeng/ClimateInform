#!/bin/sh
#===============================================
# PCR for seasonal forecast from sst to tpz
# with ensemble from multiple lagged ICs 
#===============================================

set -eaux

lcdir=/home/ppeng/src/forecast/mlr_ss
tmp=/home/ppeng/data/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datain1=/home/ppeng/data/sst
datain2=/home/ppeng/data/tpz
dataot1=/home/ppeng/data/mlr_prd
#
var1=ersst
sst_area=tp_nml   #30S-60N
tpz_area=na     # nhml,conus,na,glb
#
lagmax=1   # lagmax + 1
mlead=1     # max lead of ensemble fcst
ncv=1
#
# modes of var1&2 and mlr
mv1=20 
mv2=15
id=0 #=1 cor mtx
#
# grid of var1 & var2
imx=180
jmx=89
imx2=360
jmx2=180
#
#nclm_start=1981 # to have yrs clm for more stable than 30 yrs 
nclm_start=1981 # to have yrs clm for more stable than 30 yrs 
its_clm=`expr $nclm_start - 1947 - $lagmax / 12`
ite_clm=`expr $its_clm + 39` # have 40 yrs clm for more stable than 30 yrs
ny_clm=`expr $ite_clm - $its_clm + 1`

undef_data=-9.99E+8
undef=-999.0
 #
cd $tmp
#
#======================================
# have SST IC
#======================================
#curyr=`date --date='today' '+%Y'`  # yr of making fcst
#for curyr in 2022 2023; do
for curyr in 2023; do
#curmo=`date --date='today' '+%m'`  # mo of making fcst
#for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
for curmo in 11; do
#
if [ $curmo = 01 ]; then cmon=1; icmon=12; icmonc=dec; tgtmon=feb; tgtss=fma; fi #tgtmon:1st mon of the lead-1 season
if [ $curmo = 02 ]; then cmon=2; icmon=1 ; icmonc=jan; tgtmon=mar; tgtss=mam; fi 
if [ $curmo = 03 ]; then cmon=3; icmon=2 ; icmonc=feb; tgtmon=apr; tgtss=amj; fi
if [ $curmo = 04 ]; then cmon=4; icmon=3 ; icmonc=mar; tgtmon=may; tgtss=mjj; fi
if [ $curmo = 05 ]; then cmon=5; icmon=4 ; icmonc=apr; tgtmon=jun; tgtss=jja; fi
if [ $curmo = 06 ]; then cmon=6; icmon=5 ; icmonc=may; tgtmon=jul; tgtss=jas; fi
if [ $curmo = 07 ]; then cmon=7; icmon=6 ; icmonc=jun; tgtmon=aug; tgtss=aso; fi
if [ $curmo = 08 ]; then cmon=8; icmon=7 ; icmonc=jul; tgtmon=sep; tgtss=son; fi
if [ $curmo = 09 ]; then cmon=9; icmon=8 ; icmonc=aug; tgtmon=oct; tgtss=ond; fi
if [ $curmo = 10 ]; then cmon=10; icmon=9; icmonc=sep; tgtmon=nov; tgtss=ndj; fi
if [ $curmo = 11 ]; then cmon=11; icmon=10; icmonc=oct; tgtmon=dec; tgtss=djf; fi
if [ $curmo = 12 ]; then cmon=12; icmon=11; icmonc=nov; tgtmon=jan; tgtss=jfm; fi
#
yyyy=$curyr
yyym=`expr $curyr - 1`
yyyp=`expr $curyr + 1`
#
tgtmoyr=$tgtmon$yyyy  # 1st mon of lead-1 season
outyr_s=1981 
#
if [ $icmon -eq 11 ]; then tgtmoyr=$tgtmon$yyyp; outyr_s=1982; fi
#
yrn1=`expr $curyr - 1854`
if [ $cmon = 1 ]; then yrn1=`expr $yyym - 1854`; fi
mmn1=`expr $yrn1 \* 12`
ttlong=`expr $mmn1 + $icmon` # total mon of ersst data from jan1854 to latest_mon; dec2015=1944
#
yrn2=`expr $curyr - 1948` # total full years,=68 for 1948-2015
if [ $cmon = 1 ]; then yrn2=`expr $yyym - 1948`; fi
mmn2=`expr $yrn2 \* 12`
#
montot=`expr $mmn2 + $icmon` # 816=dec2015
nsstot=`expr $montot - 2` #
#
nyear=`expr $curyr - 1947`  # total full year data used for PCR, 68 for 1948-2015
ny_out=`expr $nyear - $lagmax / 12 - $its_clm ` # from its_clm to 
#
icyr=$curyr
if [ $icmon = 12 ]; then icyr=`expr $curyr - 1`; fi
outd=/home/ppeng/data/ss_fcst/mlr/$icyr
outdata=${outd}/$icmon
if [ ! -d $outd ] ; then
  mkdir -p $outd
fi
if [ ! -d $outdata ] ; then
  mkdir -p $outdata
fi
dataot2=$outdata

#======================================
# define some parameters
#======================================
# need to use the *.f to have exact ngrd

if [ $sst_area = tp_nml ]; then isv1=1;iev1=180;jsv1=30;jev1=75; fi # 30S-60N
if [ $var1 = ersst ] && [ $sst_area = tp_nml ]; then ngrdv1=2835; fi

echo $ngrdv1

if [ $tpz_area = conus ]; then isv2=230;iev2=300;jsv2=115;jev2=140; fi #conus
if [ $tpz_area = na ]; then isv2=190;iev2=300;jsv2=115;jev2=165; fi # NA
if [ $tpz_area = nhml ]; then isv2=1;iev2=360;jsv2=115;jev2=160; fi #nhml

if [ $tpz_area = conus ]; then ngrdv2=1153; fi
if [ $tpz_area = na ]; then ngrdv2=2946; fi
#if [ $tpz_area = nhml ]; then ngrdv2=4140; fi
if [ $tpz_area = nhml ]; then ngrdv2=2314; fi

echo $ngrdv2
#
sstfile=${var1}.3mon.1948-curr.total
#
#=======================================
#
cp $lcdir/pc_mlr_ersst_2_tpz.test.f $tmp/mlr.f
cp $lcdir/backup/reof.s.f $tmp/reof.s.f
cp $lcdir/backup/mlr.s.f $tmp/mlr.s.f

for var2 in prec; do # prec, t2m, hgt
 	
imx2=360; jmx2=180; xds=0.5; yds=-89.5; xydel=1.

idx1=2; idy1=1; idx2=2; idy2=2

tpzfile=$var2.1948_cur.3mon.total.1x1

cat > parm.h << eof
      parameter(icmon=$icmon)  ! sst ic month
      parameter(montot=$montot,nsstot=$nsstot)  ! total month number

      parameter(imx=$imx,jmx=$jmx)  ! ersst dimension
      parameter(imx2=$imx2,jmx2=$jmx2) ! t2m or prec

      parameter(lagmax=$lagmax,nlead=$mlead) 
      parameter(its_clm=$its_clm, ite_clm=$ite_clm) 

      parameter(mv1=$mv1,mv2=$mv2)
      parameter(ng1=$ngrdv1,ng2=$ngrdv2)

      parameter(idx1=$idx1,idy1=$idy1)
      parameter(idx2=$idx2,idy2=$idy2)

      parameter(isv1=$isv1,iev1=$iev1,jsv1=$jsv1,jev1=$jev1)
      parameter(isv2=$isv2,iev2=$iev2,jsv2=$jsv2,jev2=$jev2)

      parameter(id=$id)
 
      parameter(ncv=$ncv)
 
      parameter(nyr=$nyear)
eof
#
#gfortran -mcmodel=large -o mlr.x mlr.f reof.s.f
gfortran -mcmodel=medium -o mlr.x mlr.f mlr.s.f reof.s.f
echo "done compiling"

if [ -f fort.11 ] ; then
/bin/rm $tmp/fort.*
fi
#
outfile1=pc.${var1}.${sst_area}.icmon_$icmon
outfile2=eof.${var1}.${sst_area}.icmon_$icmon
outfile3=fcst.$var1.2.$var2.mlag$lagmax.mlead$mlead.cv$ncv.tpz_area_${tpz_area}.3mon
outfile4=skill_1d.$var1.2.$var2.mlag$lagmax.mlead$mlead.cv$ncv.tpz_area_${tpz_area}.3mon
outfile5=hcst.$var1.2.$var2.mlag$lagmax.mlead$mlead.tpz_area_${tpz_area}.cv$ncv.3mon

outfile6=eof_$var2.tpz_area_${tpz_area}.cv$ncv.3mon

outfile8=sst_ic_mlag.3mon
#
ln -s $datain1/$sstfile.gr          fort.10
ln -s $datain2/$tpzfile.gr          fort.11
#
ln -s $dataot2/$outfile1.gr fort.20
ln -s $dataot2/$outfile2.gr fort.21
#
ln -s $dataot2/$outfile3.gr fort.30
ln -s $dataot2/$outfile4.gr fort.31
ln -s $dataot2/$outfile5.gr fort.32

ln -s $dataot2/$outfile8.gr fort.40
ln -s $dataot2/$outfile6.gr fort.41
#
./mlr.x > $dataot2/pc_mlr_test.$var1.2.$var2.mlag$lagmax.mlead$mlead.out
#
cat>$dataot2/$outfile1.ctl<<EOF
dset ^$outfile1.gr
undef $undef
title EXP1
XDEF  1 linear   0.  2.
ydef  1 linear -88.  2.
zdef  1 linear 1 1
tdef  $nyear linear jan1948 1yr
edef  $mv1 names 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 

vars  1
pc    1 99 pc
endvars
EOF
#
cat>$dataot2/$outfile2.ctl<<EOF
dset ^$outfile2.gr
undef $undef
title EXP1
XDEF  $imx linear   0.  2.
ydef  $jmx linear -88.  2.
zdef  1 linear 1 1
tdef  999 linear jan1949 1mon
vars  2
cor   1 99 constructed
reg   1 99 constructed
endvars
EOF
#
cat>$dataot2/$outfile3.ctl<<EOF
dset ^$outfile3.gr
undef $undef
title EXP1
xdef $imx2 linear $xds $xydel
ydef $jmx2 linear $yds $xydel
zdef  1 linear 1 1
tdef  $mlead linear ${tgtmoyr} 1mon
vars  6
$var2  1 99 normalized fcst
stdo   1 99 stdv of obs
cor    1 99 corr of hcst
rms    1 99 rmse of hcst
hss    1 99 hss_3c of hcst
clm    1 99 total clim
endvars
EOF
#
cat>$dataot2/$outfile4.ctl<<EOF
dset ^$outfile4.gr
undef $undef
title EXP1
xdef 1 linear $xds $xydel
ydef 1 linear $yds $xydel
zdef 1 linear 1 1
tdef $ny_out linear ${tgtmon}$outyr_s 1yr
edef $mlead names 1 2 3 4 5 6 7 8 9 10
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
cat>$dataot2/$outfile5.ctl<<EOF
dset ^$outfile5.gr
undef $undef
title EXP1
xdef $imx2 linear $xds $xydel
ydef $jmx2 linear $yds $xydel
zdef  1 linear 1 1
tdef $ny_out linear ${tgtmon}$outyr_s 1yr
edef  $mlead names 1 2 3 4 5 6 7 8 9 10
vars  3
o  1 99 obs
p  1 99 hcst
s  1 99 std of obs
endvars
EOF
#
cat>$dataot2/$outfile8.ctl<<EOF
dset ^$outfile8.gr
undef $undef
title EXP1
XDEF  $imx linear   0.  2.
ydef  $jmx linear -88.  2.
zdef  1 linear 1 1
tdef  999 linear ${icmonc}1981 1yr
vars  1
sst   1 99 constructed
endvars
EOF
#
cat>$dataot2/$outfile6.ctl<<EOF
dset ^$outfile6.gr
undef $undef
title EXP1
xdef $imx2 linear $xds $xydel
ydef $jmx2 linear $yds $xydel
zdef  1 linear 1 1
tdef $mv2 linear ${tgtmon}$outyr_s 1yr
vars  1
reg   1 99 y to x
endvars
EOF
#
done # var2 loop
done # curmo loop
done # curyr loop
