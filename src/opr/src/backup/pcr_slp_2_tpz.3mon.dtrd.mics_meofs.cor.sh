#!/bin/sh
#===============================================
# PCR for seasonal forecast from sst to tpz
# with single IC
#===============================================

set -eaux

lcdir=/home/ppeng/ClimateInform/src/opr/src
tmp=/home/ppeng/data/tmp_opr
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datain1=/home/ppeng/data/sst
datain2=/home/ppeng/data/tpz
dataot1=/home/ppeng/data/pcr_prd
#
# grid of ERSST
imx=144
jmx=73
# grid of t2m & prec
imx2=360
jmx2=180
#
var1=slp
for var2 in t2m prec; do # prec, t2m, hgt
#var2=prec
#eof_area=tp_nml   #30S-60N
eof_area=nhml   #20N-90N
#
lagmax=24  # month number kept for ICs
#
id_ceof=1 # =1: eofs of combind ics; =0 not combined
id_detrd=0 # =1, detrend data first then add trend; =0: no detrend

for mics in 1; do # season or month numbers used as ICs
for ncut in 1; do # EOF numbers used

mlead=7     # max lead of ensemble fcst
ncv=1
#
mcut=4  # max cuts
#if [ $var2 = t2m ];  then icut1=3;  icut2=15; icut3=25; icut4=40; fi
if [ $var2 = t2m ];  then icut1=5;  icut2=5; icut3=7; icut4=10; fi
#if [ $var2 = prec ]; then icut1=10; icut2=15; icut3=25; icut4=40; fi
if [ $var2 = prec ]; then icut1=5; icut2=7; icut3=10; icut4=15; fi
modmax=$icut4

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
# have VAR1 IC
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
yrn1=`expr $curyr - 1948`
if [ $cmon = 1 ]; then yrn1=`expr $yyym - 1948`; fi
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
icyr=$curyr
if [ $icmon = 12 ]; then icyr=`expr $curyr - 1`; fi

nyear=`expr $icyr - 1947`  # total full year data used for PCR, 68 for 1948-2015

ny_net=`expr $nyear - $lagmax / 12 - 1 - 20` # from 1951
nwmo=$(( $ny_net / 10 )) # # of WMO clim

ny_out=`expr $nyear - $its_clm - $lagmax / 12` # from its_clm to 

outd=/home/ppeng/data/ss_fcst/pcr/$icyr
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
if [ $eof_area = nhml ]; then lons=1;lone=144;lats=45;late=72; fi # 20N-87.5N
if [ $var1 = slp ] && [ $eof_area = nhml ]; then ngrd=4032; fi
echo $ngrd
#
var1file=${var1}.3mon.1948-curr.total
#
#=======================================
#
cp $lcdir/pcr_slp_2_tpz.3mon.dtrd.mics_meofs.cor.f $tmp/pcr.f
cp $lcdir/backup/reof.s.f $tmp/reof.s.f

#for var2 in prec; do # prec, t2m, hgt
 	
imx2=360; jmx2=180; xds=0.5; yds=-89.5; xydel=1.

tpzfile=$var2.1948_cur.3mon.total.1x1

cat > parm.h << eof
c
      parameter(icmon=$icmon)  ! sst ic month
      parameter(ny_clm=$ny_clm,its_clm=$its_clm,ite_clm=$ite_clm) 
      parameter(montot=$montot,nsstot=$nsstot)  ! total month number
      parameter(imx=$imx,jmx=$jmx)  ! ersst dimension
      parameter(imx2=$imx2,jmx2=$jmx2) ! t2m or prec
      parameter(lagmax=$lagmax,nlead=$mlead,mics=$mics) 
      parameter(ngrd=$ngrd)
      parameter(lons=$lons,lone=$lone,lats=$lats,late=$late) !eof_area=tp_nml
      parameter(id=0,undef=$undef)
      parameter(id_ceof=$id_ceof)
      parameter(id_detrd=$id_detrd)
      parameter(modmax=$modmax,mcut=$mcut,ncut=$ncut)
      parameter(icut1=$icut1,icut2=$icut2,icut3=$icut3,icut4=$icut4)
      parameter(nwmo=$nwmo)
c
      parameter(ncv=$ncv)
c
      parameter(nyr=$nyear)

eof
#
#gfortran -o pcr.x pcr.f reof.s.f
#gfortran -mcmodel=large -o pcr.x pcr.f reof.s.f
gfortran -mcmodel=medium -o pcr.x pcr.f reof.s.f
echo "done compiling"

if [ -f fort.11 ] ; then
/bin/rm $tmp/fort.*
fi
#
outfile2=eof.${var1}.${eof_area}.icmon_$icmon

outfile3=fcst.$var1.2.$var2.mics$mics.mlead$mlead.ncut$ncut.nmod1_$icut1.id_ceof${id_ceof}.id_detrd$id_detrd.cv$ncv.3mon
outfile4=skill_1d.$var1.2.$var2.mics$mics.mlead$mlead.ncut$ncut.nmod1_$icut1.id_ceof${id_ceof}.id_detrd$id_detrd.cv$ncv.3mon
outfile5=hcst.$var1.2.$var2.mics$mics.mlead$mlead.ncut$ncut.nmod1_$icut1.id_ceof${id_ceof}.id_detrd$id_detrd.cv$ncv.3mon

outfile8=${var1}_ic_mics.3mon
outfile9=regr.${var1}.2.${var2}_ic_mics.3mon
#
ln -s $datain1/$var1file.gr          fort.10
ln -s $datain2/$tpzfile.gr          fort.11

ln -s $dataot2/$outfile2.gr         fort.21
#
ln -s $dataot2/$outfile3.gr fort.30
ln -s $dataot2/$outfile4.gr fort.31
ln -s $dataot2/$outfile5.gr fort.32

ln -s $dataot2/$outfile8.gr fort.40
ln -s $dataot2/$outfile9.gr fort.41

#
./pcr.x > $dataot2/$var1.2.$var2.mics$mics.mlead$mlead.out
#./pcr.x 
#
cat>$dataot2/$outfile2.ctl<<EOF
dset ^$outfile2.gr
undef $undef
title EXP1
XDEF  $imx linear   0.  2.5
ydef  $jmx linear -90.  2.5
zdef  1 linear 1 1
tdef  999 linear jan1949 1mon
vars  2
cor   1 99 constructed
reg   1 99 constructed
endvars
EOF
#
cat>$dataot2/$outfile9.ctl<<EOF
dset ^$outfile9.gr
undef $undef
title EXP1
xdef $imx2 linear $xds $xydel
ydef $jmx2 linear $yds $xydel
zdef  1 linear 1 1
tdef  $icut1 linear jan1950 1mon
edef $mlead names 1 2 3 4 5 6 7
vars  2
reg   1 99 sst to $var2
cor   1 99 sst to $var2
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
edef $mlead names 1 2 3 4 5 6 7
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
edef  $mlead names 1 2 3 4 5 6 7
vars  4
o  1 99 obs
p  1 99 hcst
s  1 99 std of obs
c  1 99 cv cor
endvars
EOF
#
cat>$dataot2/$outfile8.ctl<<EOF
dset ^$outfile8.gr
undef $undef
title EXP1
XDEF  $imx linear   0. 2.5
ydef  $jmx linear -90. 2.5
zdef  1 linear 1 1
tdef  999 linear jan1948 1mon
vars  1
slp   1 99 slp ic
endvars
EOF

done # curyr loop
done # curyr loop
done # var2 loop
done # ncut loop
done # mics loop
