#!/bin/sh
#===============================================
# Sythesize forecasts from different models
# with ensemble avg tech with simple avg
#===============================================

set -eaux

lcdir=/home/ppeng/ClimateInform/src/opr/src
tmp=/home/ppeng/data/tmp_opr
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
datain=/home/ppeng/data/ss_fcst
#
mlead=7
nprd=4  # of input fcst
kocn=10
xnino_crt=3.

version=sim
#for var in prec t2m; do # prec, t2m, hgt
for var in prec; do # prec, t2m, hgt

if [ $var = t2m ];  then icut1=3; ivar2=1; fi
if [ $var = prec ]; then icut1=5; ivar2=2; fi

nclm_start=1981 # to have yrs clm for more stable than 30 yrs 
its_clm=`expr $nclm_start - 1980`
ite_clm=`expr $its_clm + 39` # have 40 yrs clm for more stable than 30 yrs
ny_clm=`expr $ite_clm - $its_clm + 1`

undef=-999.0
 #
cd $tmp
#\rm fort.*
#
#======================================
# SST IC
#======================================
#curyr=`date --date='today' '+%Y'`  # yr of making fcst
for curyr in 2021 2022 2023 2024; do
#for curyr in 2024; do
#curmt=`date --date='today' '+%m'`  # mo of making fcst
for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
#for curmo in 11; do
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
icyr=$curyr
if [ $icmon = 12 ]; then icyr=`expr $curyr - 1`; fi

nyear=`expr $icyr - 1980`  # total full year data used for PCR, 68 for 1948-2015
ny_hcst=`expr $nyear - $its_clm` # from its_clm to

ind1=/home/ppeng/data/ss_fcst/pcr/$icyr/$icmon

#outd=/home/ppeng/data/ss_fcst/synth/$icyr
outd=/home/ppeng/data/ss_fcst/pcr/$icyr
outdata=${outd}/$icmon
if [ ! -d $outd ] ; then
  mkdir -p $outd
fi
if [ ! -d $outdata ] ; then
  mkdir -p $outdata
fi
#======================================
# define some parameters
#======================================
imx=360; jmx=180; xds=0.5; yds=-89.5; xydel=1.
#
cp $lcdir/synth_fcst_ensm.sim.f $tmp/syn.f

cat > parm.h << eof
c
      parameter(imx=$imx,jmx=$jmx) 
c
      parameter(nyr=$nyear)
      parameter(nprd=$nprd)
      parameter(mlead=$mlead)
      parameter(ny_hcst=$ny_hcst)
      parameter(ny_clm=$ny_clm)
      parameter(xncrt=$xnino_crt)
      parameter(icmon=$icmon)
      parameter(ivar2=$ivar2)

eof
#
#gfortran -o pcr.x pcr.f reof.s.f
#gfortran -mcmodel=medium -o syn.x syn.f
gfortran -mcmodel=large -g -o syn.x syn.f
echo "done compiling"

if [ -f fort.11 ] ; then
/bin/rm $tmp/fort.*
fi
#
infile1=fcst.ersst.2.$var.mics4.mlead$mlead.ncut1.nmod1_$icut1.id_ceof1.id_detrd0.cv1.3mon
infile2=fcst.olr.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.id_detrd0.cv1.3mon
infile3=fcst.$var.kocn_$kocn.mlead$mlead.3mon
infile4=fcst.slp.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.id_detrd0.cv1.3mon

infile5=hcst.ersst.2.$var.mics4.mlead$mlead.ncut1.nmod1_$icut1.id_ceof1.id_detrd0.cv1.3mon
infile6=hcst.olr.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.id_detrd0.cv1.3mon
infile7=hcst.$var.kocn_$kocn.mlead$mlead.3mon
infile8=hcst.slp.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.id_detrd0.cv1.3mon

infile9=nino34.prd.mics4.mlead$mlead.ncut3.icut1_15.id_ceof1.id_detrd0.cv1.3mon
infile10=$version.frac_rpss.ensmsynth.$var.mlead7.3mon
#
outfile1=$version.fcst.ensmsynth.$var.mlead$mlead.3mon
outfile2=$version.hcst.ensmsynth.$var.mlead$mlead.3mon
outfile3=$version.skill_1d.ensmsynth.$var.mlead$mlead.3mon
#
ln -s $ind1/$infile1.gr          fort.11
ln -s $ind1/$infile2.gr          fort.12
ln -s $ind1/$infile3.gr          fort.13
ln -s $ind1/$infile4.gr          fort.14

ln -s $ind1/$infile5.gr          fort.15
ln -s $ind1/$infile6.gr          fort.16
ln -s $ind1/$infile7.gr          fort.17
ln -s $ind1/$infile8.gr          fort.18

ln -s $ind1/$infile9.gr          fort.19
ln -s $ind1/$infile10.gr          fort.20

ln -s $outdata/$outfile1.gr          fort.31
ln -s $outdata/$outfile2.gr          fort.32
ln -s $outdata/$outfile3.gr          fort.33
#
#./syn.x > $outdata/syn_fcst.$var.mlead$mlead.out
./syn.x 
#
cat>$outdata/$outfile1.ctl<<EOF
dset ^$outfile1.gr
undef $undef
title EXP1
xdef $imx linear $xds $xydel
ydef $jmx linear $yds $xydel
zdef  1 linear 1 1
tdef  $mlead linear ${tgtmoyr} 1mon
vars  11
$var  1 99 normalized fcst
stdo  1 99 stdv of obs
cor   1 99 corr of hcst
rms   1 99 rmse of hcst
hss   1 99 hss_3c of hcst
clm   1 99 total clim
prb   1 99 prob prd
pa   1 99 prob of above
pb   1 99 prob of below
pn   1 99 prob of normal
rpss  1 99 prob format of prd
endvars
EOF
#
cat>$outdata/$outfile2.ctl<<EOF
dset ^$outfile2.gr
undef $undef
title EXP1
xdef $imx linear $xds $xydel
ydef $jmx linear $yds $xydel
zdef  1 linear 1 1
tdef $ny_hcst linear ${tgtmon}$outyr_s 1yr
edef  $mlead names 1 2 3 4 5 6 7
vars  4
o  1 99 obs
p  1 99 hcst
pr 1 99 prob hcst
s  1 99 std of obs
endvars
EOF
#
cat>$outdata/$outfile3.ctl<<EOF
dset ^$outfile3.gr
undef $undef
title EXP1
xdef 1 linear $xds $xydel
ydef 1 linear $yds $xydel
zdef 1 linear 1 1
tdef $ny_hcst linear ${tgtmon}$outyr_s 1yr
edef $mlead names 1 2 3 4 5 6 7
vars  8
cor1   1 99 20N-70N sp_cor
rms1   1 99 20N-70N sp_rms
cor2   1 99 CONUS sp_cor
rms2   1 99 CONUS sp_rms
hss1   1 99 20N-70N sp_hss
hss2   1 99 CONUS sp_hss
rpss1   1 99 20N-70N rpss_s
rpss2   1 99 CONUS rpss_s
endvars
EOF
#
done # curmo loop
done # curyr loop
done # var2 loop
