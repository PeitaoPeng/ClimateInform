#!/bin/sh
#===============================================
# Extended EOF-PCR for seasonal forecast from SST to SST
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
imx=180
jmx=89
#
var1=ersst
var2=sst
eof_area=tp_nml   #30S-60N
id_eof=0
#
lagmax=16
nmod=10
ncv=3

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
yrn1=`expr $curyr - 1854`
if [ $cmon = 1 ]; then yrn1=`expr $yyym - 1854`; fi
mmn1=`expr $yrn1 \* 12`
ttlong=`expr $mmn1 + $icmon` # total mon of slp data from jan1854 to latest_mon; dec2015=1944
#
yrn2=`expr $curyr - 1948` # total full years,=68 for 1948-2015
if [ $cmon = 1 ]; then yrn2=`expr $yyym - 1948`; fi
mmn2=`expr $yrn2 \* 12`
#
montot=`expr $mmn2 + $icmon` # 816=dec2015
nsstot=`expr $montot - 2` #
nsslag=`expr $nsstot - $lagmax + 1` #length of lag-arranged data
#
icyr=$curyr
if [ $icmon = 12 ]; then icyr=`expr $curyr - 1`; fi

need to reset follwing 3 parameters
nyear=`expr $icyr - 1947`  # total full year data used for PCR, 68 for 1948-2015
ny_out=`expr $nyear - $its_clm - $lagmax / 12` # from its_clm to 
ny_out2=`expr $nyear - $its_clm - $lagmax / 12 + 1` # from its_clm to 

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
if [ $eof_area = tp_nml ]; then lons=1;lone=180;lats=22;late=68; fi # 30S-60N

jmxeof=`expr $late - $lats + 1`

if [ $var1 = ersst ] && [ $eof_area = tp_nml ]; then ngrd=6438; fi
#echo $ngrd
#
sstfile=${var1}.3mon.1948-curr.total
#
#=======================================
#
cp $lcdir/eeof_ersst_2_sst.3mon.f $tmp/pcr.f
cp $lcdir/backup/reof.s.f $tmp/reof.s.f

cat > parm.h << eof
c
      parameter(icmon=$icmon)  ! sst ic month
      parameter(ny_clm=$ny_clm,its_clm=$its_clm,ite_clm=$ite_clm) 
      parameter(montot=$montot,nsstot=$nsstot)  ! total month number
      parameter(nfld=$nsslag)  ! ss of lag-arranged 
      parameter(imx=$imx,jmx=$jmx)  ! sst dimension
      parameter(nlead=$mlead) 
      parameter(mlag=$lagmax) 
      parameter(ngrd=$ngrd)
      parameter(lons=$lons,lone=$lone,lats=$lats,late=$late) !eof_area=tp_nml
      parameter(jmxeof=$jmxeof)  ! eof area in lats 
      parameter(undef=$undef)
      parameter(ID=$id_eof)
      parameter(nmod=$nmod)
c
      parameter(nyr=$nyear)
      parameter(ncv=$ncv)

eof
#
#gfortran -o pcr.x pcr.f reof.s.f
#gfortran -mcmodel=large -o pcr.x pcr.f reof.s.f
gfortran -mcmodel=medium -o pcr.x pcr.f reof.s.f
echo "done compiling"

if [ -f fort.10 ] ; then
/bin/rm $tmp/fort.*
fi
#
outfile1=epc.${var1}
outfile2=eeof.${var1}
outfile3=efcst.$var1.2.$var2.cv$ncv.3mon
outfile4=eskill_1d.$var1.2.$var2.v$ncv.3mon
outfile5=ehcst.$var1.2.$var2.cv$ncv.3mon
#
ln -s $datain1/$sstfile.gr  fort.10
#
ln -s $dataot2/$outfile1.gr fort.20
ln -s $dataot2/$outfile2.gr fort.21
ln -s $dataot2/$outfile9.gr fort.22
ln -s $dataot2/$outfile10.gr fort.23

ln -s $dataot2/$outfile3.gr fort.30
ln -s $dataot2/$outfile4.gr fort.31
ln -s $dataot2/$outfile5.gr fort.32

#
./pcr.x > $dataot2/$var1.2.$var2.mlead$mlead.out
#./pcr.x 
#
#
ny_sst=`expr $icyr - 1950 + 1`  # total full year data used for PCR, 68 for 1948-2015

cat>$dataot2/$outfile1.ctl<<EOF
dset ^$outfile1.gr
undef $undef
title EXP1
XDEF  1 linear   0.  2.
ydef  1 linear -88.  2.
zdef  1 linear 1 1
tdef  $nsslag linear jan1950 1yr
edef  $nmod 1 2 3 4 5 6 7 8 9 10
vars  16
pc    1 99 epc
EOF
#
cat>$dataot2/$outfile2.ctl<<EOF
dset ^$outfile2.gr
undef $undef
title EXP1
XDEF  $imx linear   0.  2.
ydef  $jmx linear -88.  2.
zdef  1 linear 1 1
tdef  999 linear jan1950 1mon
vars  1
reg   1 99 constructed
endvars
EOF
#
cat>$dataot2/$outfile9.ctl<<EOF
dset ^$outfile9.gr
undef $undef
title EXP1
XDEF  1 linear   0.  2.
ydef  1 linear -88.  2.
zdef  1 linear 1 1
tdef  $ny_out2 linear ${tgtmon}$outyr_s 1yr
edef  $mlead names 1 2 3 4 5 6 7
vars  1
x     1 99 nino34 index
endvars
EOF
#
cat>$dataot2/$outfile10.ctl<<EOF
dset ^$outfile10.gr
undef $undef
title EXP1
XDEF  1 linear   0.  2.
ydef  1 linear -88.  2.
zdef  1 linear 1 1
tdef  $ny_out linear ${tgtmon}$outyr_s 1yr
edef  $mlead names 1 2 3 4 5 6 7
vars  1
x     1 99 nino34 index
endvars
EOF
#
cat>$dataot2/$outfile3.ctl<<EOF
dset ^$outfile3.gr
undef $undef
title EXP1
XDEF  $imx linear   0.  2.
ydef  $jmx linear -88.  2.
zdef  1 linear 1 1
tdef  $mlead linear ${tgtmoyr} 1mon
vars  5
$var2  1 99 normalized fcst
stdo   1 99 stdv of obs
cor    1 99 corr of hcst
rms    1 99 rmse of hcst
hss    1 99 hss_3c of hcst
endvars
EOF
#
cat>$dataot2/$outfile4.ctl<<EOF
dset ^$outfile4.gr
undef $undef
title EXP1
xdef 1 linear 0.  2.
ydef 1 linear -88.  2.
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
XDEF  $imx linear   0. 2.
ydef  $jmx linear -89. 2.
zdef  1 linear 1 1
tdef $ny_out linear ${tgtmon}$outyr_s 1yr
edef  $mlead names 1 2 3 4 5 6 7
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
XDEF  $imx linear   0. 2.
ydef  $jmx linear -89. 2.
zdef  1 linear 1 1
tdef  999 linear jan1948 1mon
vars  1
sst   1 99 sst ic
endvars
EOF

done # curmo loop
done # curyr loop

done # ncut loop
done # mics loop
