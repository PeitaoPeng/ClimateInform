#!/bin/sh
#===============================================
# Sythesize forecasts from different models
# pattern correction with EOF_OBS is applied
# this version (V4) only pick erss_2_t2m
#===============================================

set -eaux

lcdir=/home/ppeng/ClimateInform/src/opr/src
tmp=/home/ppeng/data/tmp_opr
#tmp=/home/ppeng/data/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
datain=/home/ppeng/data/ss_fcst
#
mlead=8

xnino_crt=3.

version=sim 

vnmb=v3_1
vnmb2=v4

eof_area=glb


#for var in prec t2m; do # prec, t2m, hgt
for var in t2m; do # prec, t2m, hgt

if [ $var = t2m ];  then icut1=3; nprd=5; nmod=7; fi
if [ $var = prec ]; then icut1=5; nprd=4; nmod=10; fi

undef=-999.0
#
cd $tmp
#\rm fort.*
#
#======================================
# SST IC
#======================================
curyr=`date --date='today' '+%Y'`  # yr of making fcst
#for curyr in 2021 2022 2023 2024; do
#for curyr in 2025; do
curmo=`date --date='today' '+%m'`  # mo of making fcst
#for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
#for curmo in 01 02 03 04 05 06 07 08 09 10; do
#for curmo in  11; do
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
skill_yr_s=1981 # for skill
its_skill=`expr $skill_yr_s - 1950` # =31 for skill_yr_s=1981
#
if [ $icmon -eq 12 ]; then tgtmoyr=$tgtmon$yyyp; skill_yr_s=1982; fi
#
icyr=$curyr
if [ $icmon = 12 ]; then icyr=`expr $curyr - 1`; fi

its_hcst=`expr $outyr_s - 1947`
nyear=`expr $icyr - 1947`  # total full year data used for PCR, 68 for 1948-2015
ny_hcst=`expr $nyear - $its_hcst` # from 1951
ny_skill=`expr $ny_hcst - $its_skill + 1` 

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
if [ $eof_area = glb ]; then lons=1;lone=360;lats=40;late=160; fi # 50S-70N

jmxeof=`expr $late - $lats + 1`

if [ $var = t2m ] && [ $eof_area = glb ]; then ngrd=3621; fi
if [ $var = prec ] && [ $eof_area = glb ]; then ngrd=3735; fi
#================================================================
cp $lcdir/synth_fcst_ensm.sim.$vnmb2.f $tmp/syn.f
cp $lcdir/backup/reof.s.f $tmp/reof.s.f

cat > parm.h << eof
c
      parameter(imx=$imx,jmx=$jmx) 
c
      parameter(nprd=$nprd)
      parameter(mlead=$mlead)
      parameter(ny_hcst=$ny_hcst)
      parameter(its_skill=$its_skill)
      parameter(ny_skill=$ny_skill)
      parameter(xncrt=$xnino_crt)
      parameter(icmon=$icmon)
      parameter(nmod=$nmod)
      parameter(ngrd=$ngrd)
      parameter(undef=$undef)

eof
#
#gfortran -o pcr.x pcr.f reof.s.f
#gfortran -mcmodel=medium -o syn.x syn.f
gfortran -mcmodel=large -g -o syn.x syn.f reof.s.f
#gfortran -fsyntax-only syn.f
echo "done compiling"

if [ -f fort.11 ] ; then
/bin/rm $tmp/fort.*
fi
#
#
if [ $var = prec ]; then
infile4=efcst.ersst.2.prec.cv1.3mon.$vnmb
infile3=efcst.prec.2.prec.cv1.3mon.$vnmb
infile1=fcst.ersst.2.$var.mics4.mlead$mlead.ncut1.nmod1_$icut1.id_ceof1.cv1.3mon.$vnmb
infile2=fcst.slp.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.cv1.3mon.$vnmb

infile9=ehcst.ersst.2.prec.cv1.3mon.$vnmb
infile8=ehcst.prec.2.prec.cv1.3mon.$vnmb
infile6=hcst.ersst.2.$var.mics4.mlead$mlead.ncut1.nmod1_$icut1.id_ceof1.cv1.3mon.$vnmb
infile7=hcst.slp.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.cv1.3mon.$vnmb

ln -s $ind1/$infile1.gr          fort.11
ln -s $ind1/$infile2.gr          fort.12
ln -s $ind1/$infile3.gr          fort.13
ln -s $ind1/$infile4.gr          fort.14

ln -s $ind1/$infile6.gr          fort.16
ln -s $ind1/$infile7.gr          fort.17
ln -s $ind1/$infile8.gr          fort.18
ln -s $ind1/$infile9.gr          fort.19
fi

if [ $var = t2m ]; then
infile5=efcst.t2m.2.t2m.cv1.3mon.$vnmb
infile3=efcst.glb.prec.2.t2m.cv1.3mon.$vnmb
infile4=efcst.ersst.2.t2m.cv1.3mon.$vnmb
infile1=fcst.ersst.2.t2m.mics4.mlead$mlead.ncut1.nmod1_3.id_ceof1.cv1.3mon.$vnmb
infile2=fcst.slp.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.cv1.3mon.$vnmb

infile10=ehcst.t2m.2.t2m.cv1.3mon.$vnmb
infile8=ehcst.glb.prec.2.t2m.cv1.3mon.$vnmb
infile9=ehcst.ersst.2.t2m.cv1.3mon.$vnmb
infile6=hcst.ersst.2.$var.mics4.mlead$mlead.ncut1.nmod1_3.id_ceof1.cv1.3mon.$vnmb
infile7=hcst.slp.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.cv1.3mon.$vnmb

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

infile12=nino34.prd.mics4.mlead$mlead.ncut3.icut1_15.id_ceof1.cv1.3mon.pac
infile13=$version.frac_rpss.ensmsynth.$var.mlead$mlead.3mon.nprd$nprd.$vnmb2
#
outfile1=$version.fcst.ensmsynth.$var.mlead$mlead.nprd$nprd.3mon.$vnmb2
outfile2=$version.hcst.ensmsynth.$var.mlead$mlead.nprd$nprd.3mon.$vnmb2
outfile3=$version.skill_1d.ensmsynth.$var.mlead$mlead.nprd$nprd.3mon.$vnmb2

outfile4=$version.obs_3c.ensmsynth.$var.mlead$mlead.3mon.$vnmb2
#
ln -s $ind1/$infile12.gr          fort.22
ln -s $ind1/$infile13.gr          fort.23

ln -s $outdata/$outfile1.gr          fort.31
ln -s $outdata/$outfile2.gr          fort.32
ln -s $outdata/$outfile3.gr          fort.33
ln -s $outdata/$outfile4.gr          fort.34
#
./syn.x > $outdata/syn_fcst.$var.mlead$mlead.sim.$vnmb2.out
#./syn.x 
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
stdo  1 99 latest WMO std of obs
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
tdef $ny_skill linear ${tgtmon}$skill_yr_s 1yr
edef  $mlead names 1 2 3 4 5 6 7 8
vars  6
o  1 99 obs
p  1 99 hcst
pr 1 99 prob hcst
pa 1 99 prob_a
pb 1 99 prob_b
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
tdef $ny_skill linear ${tgtmon}$skill_yr_s 1yr
edef $mlead names 1 2 3 4 5 6 7 8
vars  36
cor1   1 99 glb
rms1   1 99 glb
cor2   1 99 CONUS
rms2   1 99 CONUS
cor3   1 99 NA
rms3   1 99 NA
cor4   1 99 Europe
rms4   1 99 Europe
cor5   1 99 East Asia
rms5   1 99 East Asia
cor6   1 99 S&SE Asia
rms6   1 99 S&SE Asia
cor7   1 99 Africa
rms7   1 99 Africa
cor8   1 99 S.America
rms8   1 99 S.America
cor9   1 99 Austrilia
rms9   1 99 Austrilia

hss1   1 99 glb
hss2   1 99 CONUS
hss3   1 99 NA
hss4   1 99 Europe
hss5   1 99 East Asia
hss6   1 99 S&SE Asia
hss7   1 99 Africa
hss8   1 99 S.America
hss9   1 99 Austrilia

rpss1   1 99 glb
rpss2   1 99 CONUS
rpss3   1 99 NA
rpss4   1 99 Europe
rpss5   1 99 East Asia
rpss6   1 99 S&SE Asia
rpss7   1 99 Africa
rpss8   1 99 S.America
rpss9   1 99 Austrilia
endvars
EOF
#
cat>$outdata/$outfile4.ctl<<EOF
dset ^$outfile4.gr
undef $undef
title EXP1
xdef $imx linear $xds $xydel
ydef $jmx linear $yds $xydel
zdef  1 linear 1 1
tdef $ny_skill linear ${tgtmon}$skill_yr_s 1yr
edef  $mlead names 1 2 3 4 5 6 7 8
vars  2
obs   1 99 obs
o3c   1 99 3C obs
endvars
EOF

#done # curmo loop
#done # curyr loop
done # var2 loop
