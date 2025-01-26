#!/bin/sh
#===============================================
# PCR for seasonal forecast from sst to tpz
# with single IC
#===============================================

set -eaux

lcdir=/home/ppeng/src/forecast/pcr_ss
tmp=/home/ppeng/data/tmp_opr
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
datain=/home/ppeng/data/ss_fcst
#
mlead=7
kocn=10

for var in prec t2m; do # prec, t2m, hgt

if [ $var = t2m ];  then icut1=3; fi
if [ $var = prec ]; then icut1=5; fi

nclm_start=1981 # to have yrs clm for more stable than 30 yrs 
its_clm=`expr $nclm_start - 1947 - $lagmax / 12`
ite_clm=`expr $its_clm + 39` # have 40 yrs clm for more stable than 30 yrs
ny_clm=`expr $ite_clm - $its_clm + 1`

nyear=`expr $curyr - 1947`  # total full year data used for PCR, 68 for 1948-2015
ny_out=`expr $nyear - $its_clm ` # from its_clm to

undef=-999.0
 #
cd $tmp
#
#======================================
# SST IC
#======================================
curyr=`date --date='today' '+%Y'`  # yr of making fcst
#for curyr in 2022 2023; do
curmo=`date --date='today' '+%m'`  # mo of making fcst
#for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
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

ind1=/home/ppeng/data/ss_fcst/pcr/$icyr/$icmon
ind2=/home/ppeng/data/ss_fcst/olr/$icyr/$icmon
ind3=/home/ppeng/data/ss_fcst/slp/$icyr/$icmon
ind4=/home/ppeng/data/ss_fcst/ocn/$icyr/$icmon

outd=/home/ppeng/data/ss_fcst/synth/$icyr
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
nyear=`expr $curyr - 1980`  # total full year data used for PCR, 68 for 1948-2015
ny_out=`expr $nyear - $its_clm ` # from its_clm to

imx=360; jmx=180; xds=0.5; yds=-89.5; xydel=1.
#
cp $lcdir/synthesize_fcsts.f $tmp/syn.f

cat > parm.h << eof
c
      parameter(icmon=$icmon)  ! sst ic month
      parameter(ny_clm=$ny_clm,its_clm=$its_clm,ite_clm=$ite_clm) 
      parameter(montot=$montot,nsstot=$nsstot)  ! total month number
      parameter(imx=$imx,jmx=$jmx)  ! slp dimension
      parameter(imx2=$imx2,jmx2=$jmx2) ! t2m or prec
      parameter(lagmax=$lagmax,nlead=$mlead,mics=$mics) 
      parameter(ngrd=$ngrd)
      parameter(lons=$lons,lone=$lone,lats=$lats,late=$late) !eof_area=tp_nml
      parameter(id=0,undef=$undef)
      parameter(id_ceof=$id_ceof)
      parameter(id_detrd=$id_detrd)
      parameter(modmax=$modmax,mcut=$mcut,ncut=$ncut)
c
      parameter(ncv=$ncv)
c
      parameter(nyr=$nyear)
      parameter(icut1=$icut1,icut2=$icut2,icut3=$icut3,icut4=$icut4)

eof
#
#gfortran -o pcr.x pcr.f reof.s.f
#gfortran -mcmodel=large -o pcr.x pcr.f reof.s.f
gfortran -mcmodel=medium -o syn.x syn.f
echo "done compiling"

if [ -f fort.11 ] ; then
/bin/rm $tmp/fort.*
fi
#
infile1=fcst.ersst.2.$var.mics4.mlead$mlead.ncut1.nmod1_$icut1.id_ceof1.id_detrd0.cv1.3mon
infile2=fcst.olr.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.id_detrd0.cv1.3mon
infile3=fcst.slp.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.id_detrd0.cv1.3mon
infile4=fcst.$var.kocn_$kocn.mlead$mlead.3mon

infile5=hcst.ersst.2.$var.mics4.mlead$mlead.ncut1.nmod1_$icut1.id_ceof1.id_detrd0.cv1.3mon
infile6=hcst.olr.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.id_detrd0.cv1.3mon
infile7=hcst.slp.2.$var.mics1.mlead$mlead.ncut1.nmod1_5.id_ceof1.id_detrd0.cv1.3mon
infile8=hcst.$var.kocn_$kocn.mlead$mlead.3mon
#
outfile1=fcst.synth.$var.mlead$mlead.3mon
outfile2=hcst.synth.$var.mlead$mlead.3mon
outfile3=skill_1d.synth.$var.mlead$mlead.3mon
#
ln -s $ind1/$infile1.gr          fort.11
ln -s $ind2/$infile2.gr          fort.12
ln -s $ind3/$infile3.gr          fort.13
ln -s $ind4/$infile4.gr          fort.14

ln -s $ind5/$infile5.gr          fort.15
ln -s $ind6/$infile6.gr          fort.16
ln -s $ind7/$infile7.gr          fort.17
ln -s $ind8/$infile8.gr          fort.18

ln -s $outdata/$outfile1.gr          fort.31
ln -s $outdata/$outfile2.gr          fort.32
ln -s $outdata/$outfile3.gr          fort.33
#
./syn.x > $outdata/syn_fcst.$var.mlead$mlead.out
#./pcr.x 
#
cat>$outdata/$outfile1.ctl<<EOF
dset ^$outfile1.gr
undef $undef
title EXP1
xdef $imx linear $xds $xydel
ydef $jmx linear $yds $xydel
zdef  1 linear 1 1
tdef  $mlead linear ${tgtmoyr} 1mon
vars  6
$var  1 99 normalized fcst
stdo  1 99 stdv of obs
cor   1 99 corr of hcst
rms   1 99 rmse of hcst
hss   1 99 hss_3c of hcst
clm   1 99 total clim
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
tdef $ny_out linear ${tgtmon}$outyr_s 1yr
edef  $mlead names 1 2 3 4 5 6 7
vars  3
o  1 99 obs
p  1 99 hcst
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
done # curmo loop
done # curyr loop
done # var2 loop
