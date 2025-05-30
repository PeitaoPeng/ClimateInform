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
#
# grid of ERSST
imx=180
jmx=89
imx2=360
jmx2=180
#
var1=ersst
#for var2 in prec t2m; do
for var2 in t2m; do
eof_area=tp_nml   #30S-60N
id_eof=0
#
lagmax=5
mlead=7
ncv=1

#if [ $var1 = ersst ]; then nmod=13; fi
if [ $var1 = ersst ]; then nmod=7; fi
if [ $var1 = hadoisst ]; then nmod=11; fi

undef_data=-9.99E+8
undef=-999.0
 #
cd $tmp
#
#======================================
# have SST IC
#======================================
#curyr=`date --date='today' '+%Y'`  # yr of making fcst
for curyr in 2021 2022 2023 2024 2025; do
#for curyr in 2024; do
#curmo=`date --date='today' '+%m'`  # mo of making fcst
#for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
for curmo in 02 03; do
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
#
outyr_s=1981 
#
if [ $icmon -eq 11 ]; then tgtmoyr=$tgtmon$yyyp; outyr_s=1982; fi
#
yrn2=`expr $curyr - 1948` # total full years,=68 for 1948-2015
if [ $cmon = 1 ]; then yrn2=`expr $yyym - 1948`; fi
#
mmn2=`expr $yrn2 \* 12`
#
montot=`expr $mmn2 + $icmon` # 816=dec2015
nsstot=`expr $montot - 2` #
nfld2=`expr $nsstot / 12 + 1` # number of the ss used in hcst

nssind=$(expr $nsstot / 3) # independent 3-mon avg
nssdif=$(($nsstot - $nssind * 3))  

if [ $nssdif = 0 ]; then its_sst=3; else its_sst=$nssdif; fi

nss4rd=`expr $nsstot - $its_sst + 1` # data length including end ss

nssuse=`expr $nss4rd / 3 + 1` # data length used in analysis

nsslag=`expr $nssuse - $lagmax + 1` #length of lag-arranged data
#
icyr=$curyr
if [ $icmon = 12 ]; then icyr=`expr $curyr - 1`; fi

nclm_start=1981 # to have yrs clm for more stable than 30 yrs 
its_clm=`expr $nclm_start - 1947 - $lagmax / 4`
if [ "$icmon" = 1 ] || [ "$icmon" = 2 ]; then its_clm=$(($its_clm - 1)); fi
ite_clm=`expr $its_clm + 39` # have 40 yrs clm for more stable than 30 yrs
ny_clm=`expr $ite_clm - $its_clm + 1`

#need to reset follwing 3 parameters
nyear=`expr $icyr - 1948`  # total full year data used for PCR, 68 for 1948-2015
ny_out=`expr $nyear - $its_clm - $lagmax / 4 + 1` # from its_clm to 
ny_out2=`expr $nyear - $its_clm - $lagmax / 4 + 1` # from its_clm to 

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
if [ $var1 = hadoisst ] && [ $eof_area = tp_nml ]; then ngrd=5915; fi
#echo $ngrd
#
sstfile=${var1}.3mon.1948-curr.total
tpzfile=${var2}.1948_cur.3mon.total.1x1
#
#=======================================
#
cp $lcdir/eeof_sst_2_tpz.3mon.f $tmp/pcr.f
cp $lcdir/backup/reof.s.f $tmp/reof.s.f

cat > parm.h << eof
c
      parameter(icmon=$icmon)  ! sst ic month
      parameter(ny_clm=$ny_clm,its_clm=$its_clm,ite_clm=$ite_clm) 

      parameter(montot=$montot,nsstot=$nsstot)  ! total month number
      parameter(nssuse=$nssuse) ! acturly used nss 
      parameter(nfld=$nsslag)  ! ss of lag-arranged 
      parameter(nfld2=$nfld2)  ! # of ss used in hcst 
      parameter(its_sst=${its_sst}) ! start of reaning 

      parameter(imx=$imx,jmx=$jmx)  ! sst dimension
      parameter(imx2=$imx2,jmx2=$jmx2)  ! sst dimension
      parameter(nlead=$mlead) 
      parameter(mlag=$lagmax) 
      parameter(ngrd=$ngrd)
      parameter(lons=$lons,lone=$lone,lats=$lats,late=$late) !eof_area=tp_nml
      parameter(undef=$undef)
      parameter(ID=$id_eof)
      parameter(nmod=$nmod)
c
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
outfile4=eskill_1d.$var1.2.$var2.cv$ncv.3mon
outfile5=ehcst.$var1.2.$var2.cv$ncv.3mon
#
ln -s $datain1/$sstfile.gr  fort.10
ln -s $datain2/$tpzfile.gr  fort.11
#
ln -s $dataot2/$outfile1.gr fort.20
ln -s $dataot2/$outfile2.gr fort.21

ln -s $dataot2/$outfile3.gr fort.30
ln -s $dataot2/$outfile4.gr fort.31
ln -s $dataot2/$outfile5.gr fort.32

#
./pcr.x > $dataot2/eeof.$var1.2.$var2.mlead$mlead.out
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
tdef  $nsslag linear jan1950 1mo
edef  $nmod names 1 2 3 4 5 6 7 8 9 10 11
vars  1
rpc   1 99 epc
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
tdef  $nmod linear jan1950 1mon
vars  5
r1     1 99 regr
r2     1 99 regr
r3     1 99 regr
r4     1 99 regr
r5     1 99 regr
endvars
EOF
#
cat>$dataot2/$outfile3.ctl<<EOF
dset ^$outfile3.gr
undef $undef
title EXP1
XDEF  $imx2 linear   0.5  1.
ydef  $jmx2 linear -89.5  1.
zdef  1 linear 1 1
tdef  $mlead linear ${tgtmoyr} 1mon
vars  6
$var2  1 99 normalized fcst
stdo   1 99 stdv of obs
cor    1 99 corr of hcst
rms    1 99 rmse of hcst
hss    1 99 hss_3c of hcst
clm    1 99 missing
endvars
EOF
#
cat>$dataot2/$outfile4.ctl<<EOF
dset ^$outfile4.gr
undef $undef
title EXP1
xdef 1 linear    0.5  1.
ydef 1 linear  -89.5  1.
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
XDEF  $imx2 linear   0.5  1.
ydef  $jmx2 linear -89.5  1.
zdef  1 linear 1 1
tdef $ny_out linear ${tgtmon}$outyr_s 1yr
edef  $mlead names 1 2 3 4 5 6 7
vars  4
o  1 99 obs
p  1 99 hcst
s  1 99 std of obs
c  1 99 cvcor
endvars
EOF
#

done # curmo loop
done # curyr loop
done # var2 loop


