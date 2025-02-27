#!/bin/sh
#===============================================
# OCN for global T2M
#===============================================

set -eaux

lcdir=/home/ppeng/ClimateInform/src/opr/src
tmp=/home/ppeng/data/tmp_opr
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datain=/home/ppeng/data/tpz
dataot1=/home/ppeng/data/ocn_prd
#
# grid of t2m & prec
imx=360
jmx=180
#
lagmax=36   # skip 3-yr,starting from 1951
mlead=7     # fcst lead 
kocn=10
#
ndec=10
#
for var in t2m prec; do # prec, t2m, hg

nclm_start=1981 # to have output from 1981 
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
#for curyr in 2021 2022 2023 2024; do
for curyr in 2025; do
#curmo=`date --date='today' '+%m'`  # mo of making fcst
#for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
for curmo in 01; do
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
yrn=`expr $curyr - 1948` # total full years,=68 for 1948-2015
if [ $cmon = 1 ]; then yrn=`expr $yyym - 1948`; fi
mmn=`expr $yrn \* 12`
#
montot=`expr $mmn + $icmon` # 816=dec2015
nsstot=`expr $montot - 2` #
#
icyr=$curyr
if [ $icmon = 12 ]; then icyr=`expr $curyr - 1`; fi

nyear=`expr $icyr - 1947`  # total full year data used for PCR, 68 for 1948-2015
ny_out=`expr $nyear - $its_clm - $lagmax / 12` # from its_clm to 

#outd=/home/ppeng/data/ss_fcst/ocn/$icyr
outd=/home/ppeng/data/ss_fcst/pcr/$icyr
outdata=${outd}/$icmon
if [ ! -d $outd ] ; then
  mkdir -p $outd
fi
if [ ! -d $outdata ] ; then
  mkdir -p $outdata
fi
dataot2=$outdata
#=======================================
#
cp $lcdir/ocn_tpz.3mon.cor.f $tmp/ocn.f

imx=360; jmx=180; xds=0.5; yds=-89.5; xydel=1.

tpzfile=$var.1948_cur.3mon.total.1x1

cat > parm.h << eof
c
      parameter(icmon=$icmon)  ! sst ic month
      parameter(ny_clm=$ny_clm,its_clm=$its_clm,ite_clm=$ite_clm) 
      parameter(montot=$montot,nsstot=$nsstot)  ! total month number
      parameter(imx=$imx,jmx=$jmx) ! t2m or prec
      parameter(lagmax=$lagmax,nlead=$mlead) 
      parameter(undef=$undef)
c
      parameter(ndec=$ndec)
      parameter(kocn=$kocn)
c
      parameter(nyr=$nyear)
eof
#
#gfortran -mcmodel=large -o ocn.x ocn.f 
gfortran -mcmodel=medium -o ocn.x ocn.f 
echo "done compiling"

if [ -f fort.11 ] ; then
/bin/rm $tmp/fort.*
fi
#
outfile3=fcst.$var.kocn_$kocn.mlead$mlead.3mon
outfile4=skill_1d.$var.kocn_$kocn.mlead$mlead.3mon
outfile5=hcst.$var.kocn_$kocn.mlead$mlead.3mon
#
ln -s $datain/$tpzfile.gr          fort.11
#
ln -s $dataot2/$outfile3.gr fort.30
ln -s $dataot2/$outfile4.gr fort.31
ln -s $dataot2/$outfile5.gr fort.32

#
./ocn.x > $dataot2/kocn_$kocn.$var.mlead$mlead.out
#
cat>$dataot2/$outfile3.ctl<<EOF
dset ^$outfile3.gr
undef $undef
title EXP1
xdef $imx linear $xds $xydel
ydef $jmx linear $yds $xydel
zdef  1 linear 1 1
tdef  $mlead linear ${tgtmoyr} 1mon
vars  6
$var  1 99 normalized fcst
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
xdef $imx linear $xds $xydel
ydef $jmx linear $yds $xydel
zdef  1 linear 1 1
tdef $ny_out linear ${tgtmon}$outyr_s 1yr
edef  $mlead names 1 2 3 4 5 6 7 8 9 10
vars  4
o  1 99 obs
p  1 99 hcst
s  1 99 std of obs
c  1 99 cv cor
endvars
EOF
#
done # curmo loop
done # curyr loop
done # var loop
