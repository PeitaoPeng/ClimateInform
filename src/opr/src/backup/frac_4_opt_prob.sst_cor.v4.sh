#!/bin/sh
#===============================================
# calculate fractions used for sythesize forecasts from different models
# with ensemble avg tech using cor skill
#===============================================

set -eaux

lcdir=/home/ppeng/ClimateInform/src/opr/src
tmp=/home/ppeng/data/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
datain=/home/ppeng/data/ss_fcst
#
mlead=8
xnino_crt=3.
version=cvcor

vnmb=v4
vnmb2=v4

#for var in t2m; do # prec, t2m, hgt
var=sst

undef=-999.0
#
cd $tmp
#
if [ -f fort.11 ]; then
/bin/rm $tmp/fort.*
fi
#\rm fort.*
#
#======================================
# SST IC
#======================================
#curyr=`date --date='today' '+%Y'`  # yr of making fcst
#for curyr in 2021 2022 2023 2024; do
for curyr in 2024; do
#curmo=`date --date='today' '+%m'`  # mo of making fcst
#for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
#for curmo in 01 02 03 04 05 06 07 08 09; do
for curmo in 11; do
#
if [ $curmo = 01 ]; then cmon=1; icmon=12; icmonc=dec; tgtmon=jan; tgtss=jfm; fi #tgtmon:1st mon of the lead-0 season
if [ $curmo = 02 ]; then cmon=2; icmon=1 ; icmonc=jan; tgtmon=feb; tgtss=fma; fi
if [ $curmo = 03 ]; then cmon=3; icmon=2 ; icmonc=feb; tgtmon=mar; tgtss=mam; fi
if [ $curmo = 04 ]; then cmon=4; icmon=3 ; icmonc=mar; tgtmon=apr; tgtss=amj; fi
if [ $curmo = 05 ]; then cmon=5; icmon=4 ; icmonc=apr; tgtmon=may; tgtss=mjj; fi
if [ $curmo = 06 ]; then cmon=6; icmon=5 ; icmonc=may; tgtmon=jun; tgtss=jja; fi
if [ $curmo = 07 ]; then cmon=7; icmon=6 ; icmonc=jun; tgtmon=jul; tgtss=jas; fi
if [ $curmo = 08 ]; then cmon=8; icmon=7 ; icmonc=jul; tgtmon=aug; tgtss=aso; fi
if [ $curmo = 09 ]; then cmon=9; icmon=8 ; icmonc=aug; tgtmon=sep; tgtss=son; fi
if [ $curmo = 10 ]; then cmon=10; icmon=9; icmonc=sep; tgtmon=oct; tgtss=ond; fi
if [ $curmo = 11 ]; then cmon=11; icmon=10; icmonc=oct; tgtmon=nov; tgtss=ndj; fi
if [ $curmo = 12 ]; then cmon=12; icmon=11; icmonc=nov; tgtmon=dec; tgtss=djf; fi
#
yyyy=$curyr
yyym=`expr $curyr - 1`
yyyp=`expr $curyr + 1`
#
tgtmoyr=$tgtmon$yyyy  # 1st mon of lead-1 season
#
outyr_s=1951 # for hcst
if [ $icmon -eq 12 ]; then tgtmoyr=$tgtmon$yyyp; outyr_s=1982; fi
#
its_hcst=`expr $outyr_s - 1947`
#
icyr=$curyr
if [ $icmon = 12 ]; then icyr=`expr $curyr - 1`; fi

nyear=`expr $icyr - 1947`  # total full year data used for PCR, 68 for 1948-2015
ny_hcst=`expr $nyear - $its_hcst` # from its_hcst to

ind1=/home/ppeng/data/ss_fcst/pcr/$icyr/$icmon

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
imx=180; jmx=89; xds=0.; yds=-88.; xydel=2.
#
cp $lcdir/frac_4_opt_prob.sst_cor.$vnmb2.f $tmp/opt.f

cat > parm.h << eof
c
      parameter(imx=$imx,jmx=$jmx) 
c
      parameter(nprd=1)
      parameter(mlead=$mlead)
      parameter(ny_hcst=$ny_hcst)
      parameter(xncrt=$xnino_crt)
      parameter(icmon=$icmon)

eof

gfortran -mcmodel=medium -g -o opt.x opt.f
echo "done compiling"

infile1=fcst.ersst.2.sst.mics4.mlead8.ncut3.icut1_15.id_ceof1.cv1.3mon.$vnmb
infile2=hcst.ersst.2.sst.mics4.mlead8.ncut3.icut1_15.id_ceof1.cv1.3mon.$vnmb

ln -s $ind1/$infile1.gr          fort.11
ln -s $ind1/$infile2.gr          fort.12

infile3=nino34.prd.mics4.mlead8.ncut3.icut1_15.id_ceof1.cv1.3mon.v4
#
outfile=frac_rpss.ersst_2_sst.mlead$mlead.3mon.$vnmb2
#

ln -s $ind1/$infile3.gr          fort.21

ln -s $outdata/$outfile.gr       fort.31
#
#./syn.x > $outdata/frac_4_opt_rpss.$var.mlead$mlead.$vnmb.out
./opt.x 
#

\rm fort.*

cat>$outdata/$outfile.ctl<<EOF
dset ^$outfile.gr
undef $undef
title EXP1
xdef $imx linear $xds $xydel
ydef $jmx linear $yds $xydel
zdef  1 linear 1 1
tdef  $mlead linear ${tgtmoyr} 1mon
vars  6
frac  1 99 fraction of esm_prd
stdo  1 99 std of anom w.r.t. WMO clim
stdf  1 99 std of ehcst
avgo  1 99 avg of anom w.r.t. WMO clim
avgf  1 99 avg of ehcst
rpss  1 99 rpss_t of hcst
endvars
EOF
#
done # curmo loop
done # curyr loop
