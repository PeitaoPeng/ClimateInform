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
mlead=7
xnino_crt=3.
version=cvcor
vnmb=v2

if [ $version = cor ];  then ivs=1; fi
if [ $version = cvcor ];  then ivs=2; fi

#for var in t2m prec; do # prec, t2m, hgt
for var in prec; do # prec, t2m, hgt

if [ $var = t2m ];  then icut1=3; ivar2=1; fi
if [ $var = prec ]; then icut1=5; ivar2=2; fi

# nprd: # of input fcst
if [ $var = t2m ];  then nprd=5; fi
if [ $var = prec ];  then nprd=5; fi

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
#for curyr in 2021 2022 2023 2024 2025; do
for curyr in 2023; do
#curmt=`date --date='today' '+%m'`  # mo of making fcst
for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
#for curmo in 04; do
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
cp $lcdir/frac_4_opt_prob.cor.v2.f $tmp/opt.f

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
      parameter(ivs=$ivs)

eof
#
#gfortran -o pcr.x pcr.f reof.s.f
#gfortran -mcmodel=large -o opt.x opt.f
gfortran -mcmodel=medium -g -o opt.x opt.f
echo "done compiling"

if [ -f fort.11 ] ; then
/bin/rm $tmp/fort.*
fi
#
if [ $var = prec ]; then
infile1=efcst.ersst.2.prec.cv1.3mon
infile2=efcst.prec.2.prec.cv1.3mon
infile3=fcst.ersst.2.$var.mics4.mlead$mlead.ncut1.nmod1_$icut1.id_ceof1.id_detrd0.cv1.3mon
infile4=fcst.olr.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.id_detrd0.cv1.3mon
infile5=fcst.slp.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.id_detrd0.cv1.3mon

infile6=ehcst.ersst.2.prec.cv1.3mon
infile7=ehcst.prec.2.prec.cv1.3mon
infile8=hcst.ersst.2.$var.mics4.mlead$mlead.ncut1.nmod1_$icut1.id_ceof1.id_detrd0.cv1.3mon
infile9=hcst.olr.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.id_detrd0.cv1.3mon
infile10=hcst.slp.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.id_detrd0.cv1.3mon

ln -s $ind1/$infile1.gr          fort.11
ln -s $ind1/$infile2.gr          fort.12
ln -s $ind1/$infile3.gr          fort.13
ln -s $ind1/$infile4.gr          fort.14
ln -s $ind1/$infile5.gr          fort.15

ln -s $ind1/$infile6.gr          fort.16
ln -s $ind1/$infile7.gr          fort.17
ln -s $ind1/$infile8.gr          fort.18
ln -s $ind1/$infile9.gr          fort.19
ln -s $ind1/$infile10.gr         fort.20
fi

if [ $var = t2m ]; then
infile1=efcst.t2m.2.t2m.cv1.3mon
infile2=efcst.glb.prec.2.t2m.cv1.3mon
infile3=efcst.ersst.2.t2m.cv1.3mon
infile4=fcst.olr.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.id_detrd0.cv1.3mon
infile5=fcst.slp.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.id_detrd0.cv1.3mon

infile6=ehcst.t2m.2.t2m.cv1.3mon
infile7=ehcst.glb.prec.2.t2m.cv1.3mon
infile8=ehcst.ersst.2.t2m.cv1.3mon
infile9=hcst.olr.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.id_detrd0.cv1.3mon
infile10=hcst.slp.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.id_detrd0.cv1.3mon

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
fi

infile12=nino34.prd.mics1.mlead$mlead.ncut3.icut1_15.id_ceof1.id_detrd0.cv1.3mon
#
outfile=$version.frac_rpss.ensmsynth.$var.mlead$mlead.3mon.$vnmb
#

ln -s $ind1/$infile12.gr          fort.22

ln -s $outdata/$outfile.gr          fort.31
#
#./syn.x > $outdata/syn_fcst.$var.mlead$mlead.$vnmb.out
./opt.x 
#
cat>$outdata/$outfile.ctl<<EOF
dset ^$outfile.gr
undef $undef
title EXP1
xdef $imx linear $xds $xydel
ydef $jmx linear $yds $xydel
zdef  1 linear 1 1
tdef  $mlead linear ${tgtmoyr} 1mon
vars  2
frac  1 99 fraction of esm_prd
rpss  1 99 rpss skill
endvars
EOF
#
done # curmo loop
done # curyr loop
done # var2 loop
