#!/bin/sh

set -eaux

lcdir=/home/ppeng/src/forecast/pcr_ss
tmp=/home/ppeng/data/tmp_opr
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datain1=/home/ppeng/data/downloads
datain2=/home/ppeng/data/sst_save
dataot1=/home/ppeng/data/pcr_prd
#
# grid of ERSST
imx=180
jmx=89
# grid of t2m & prec
imx2=720
jmx2=360
#
var1=ersst
eof_area=tp_nml   #30S-60N
#
lagmax=12  # maximum lag
mlead=10    # max lead of ensemble fcst
nmod=10
#
ndec=5   #decade # 51-80, 61-90, 71-00, 81-10, 91-20
kocn=15

its_clm=`expr 1981 - 1947 - $lagmax / 12`
ite_clm=`expr $its_clm + 40`
nt_clm=`expr $ite_clm - $its_clm + 1`

undef_data=-9.99E+8
undef=-999.0
 #
cd $tmp
#
#======================================
# have SST IC
#======================================
curyr=`date --date='today' '+%Y'`  # yr of making fcst
curmo=`date --date='today' '+%m'`  # mo of making fcst
#
if [ $curmo = 01 ]; then cmon=1; icmon=12 ; tgtmon=feb; tgtss=fma; fi #tgtmon: 1st mon of the lead-1 season
if [ $curmo = 02 ]; then cmon=2; icmon=1 ; tgtmon=mar; tgtss=mam; fi 
if [ $curmo = 03 ]; then cmon=3; icmon=2 ; tgtmon=apr; tgtss=amj; fi
if [ $curmo = 04 ]; then cmon=4; icmon=3 ; tgtmon=may; tgtss=mjj; fi
if [ $curmo = 05 ]; then cmon=5; icmon=4 ; tgtmon=jun; tgtss=jja; fi
if [ $curmo = 06 ]; then cmon=6; icmon=5 ; tgtmon=jul; tgtss=jas; fi
if [ $curmo = 07 ]; then cmon=7; icmon=6 ; tgtmon=aug; tgtss=aso; fi
if [ $curmo = 08 ]; then cmon=8; icmon=7 ; tgtmon=sep; tgtss=son; fi
if [ $curmo = 09 ]; then cmon=9; icmon=8 ; tgtmon=oct; tgtss=ond; fi
if [ $curmo = 10 ]; then cmon=10; icmon=9; tgtmon=nov; tgtss=ndj; fi
if [ $curmo = 11 ]; then cmon=11; icmon=10; tgtmon=dec; tgtss=djf; fi
if [ $curmo = 12 ]; then cmon=12; icmon=11; tgtmon=jan; tgtss=jfm; fi
#
yyyy=$curyr
yyym=`expr $curyr - 1`
yyyp=`expr $curyr + 1`
#
tgtmoyr=$tgtmon$yyyy  # 1st mon of lead-1 season
#
if [ $icmon -ge 11 ]; then tgtmoyr=$tgtmon$yyyp; fi
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
nyear=`expr $curyr - 1948`  # total full year data used for PCR, 68 for 1948-2015
#
icyr=$curyr
if [ $icmon = 12 ]; then icyr=`expr $curyr - 1`; fi
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
if [ $eof_area = tp_nml ]; then lons=1;lone=180;lats=30;late=75; fi # 30S-60N
if [ $var1 = ersst ] && [ $eof_area = tp_nml ]; then ngrd=5670; fi
echo $ngrd
#
nts=1129  # jan1948
nte=$ttlong # latest mon
#
sstfile=${var1}.mon.jan1948-curr
cat >sstmon<<EOF
run mon.gs
EOF
cat >mon.gs<<EOF
'reinit'
'sdfopen $datain1/sst.mnmean.nc'
'set x 1 180'
'set y 1  89'
'set gxout fwrite'
'set fwrite $sstfile.gr'
'set t $nts $nte'
'd sst'
'c'
EOF
#
/usr/bin/grads -bl <sstmon
#
cat>$sstfile.ctl<<EOF
dset ^$sstfile.gr
undef -999000000
*
TITLE SST
*
xdef  180 linear   0. 2.
ydef   89 linear -88. 2.
zdef   01 levels 1
tdef   9999 linear jan1948 1mo
vars 1
sst  1 99 monthly mean (C)
ENDVARS
EOF
#
#=======================================
#
cp $lcdir/realtime.pcr.sst_tpz.mld.f $tmp/pcr.f
cp $lcdir/reof.s.f $tmp/reof.s.f

for var2 in prec; do # prec, t2m, hgt
 	
if [ $var2 = t2m ]; then imx2=720; jmx2=360; xds=0.25; yds=-89.75; xydel=0.5; fi
if [ $var2 = prec ]; then imx2=720; jmx2=360; xds=0.25; yds=-89.75; xydel=0.5; fi
if [ $var2 = hgt ]; then imx2=144; jmx2=72; xds=0; yds=-90; xydel=2.5; fi

ntsp=2
ntem=`expr $montot - 1`

tpzfile=$var2.1948_cur.3mon

#=======================================
# rewrite tpz data nc grads
#=======================================
cat >havedata<<EOF
run data_rewrite.gs
EOF
#
if [ $var2 = 't2m' ]; then
cat >data_rewrite.gs<<EOF
'reinit'
'sdfopen $datain1/air.mon.mean.nc'
'set x 1 $imx2'
'set y 1 $jmx2'
'set gxout fwrite'
'set fwrite $tpzfile.gr'
'set t $ntsp $ntem'
'd ave(air,t-1,t+1)'
'c'
EOF
fi

if [ $var2 = 'prec' ]; then
cat >data_rewrite.gs<<EOF
'reinit'
'sdfopen $datain1/precip.mon.mean.0.5x0.5.nc'
'set x 1 $imx2'
'set y 1 $jmx2'
'set gxout fwrite'
'set fwrite $tpzfile.gr'
'set t $ntsp $ntem'
'd ave(precip,t-1,t+1)'
'c'
EOF
fi

if [ $var2 = 'hgt' ]; then
cat >data_rewrite.gs<<EOF
'reinit'
'sdfopen $datain1/hgt.mon.mean.nc'
'set x 1 $imx2'
'set y 1 $jmx2'
'set z 10'
'set gxout fwrite'
'set fwrite $tpzfile.gr'
'set t $ntsp $ntem'
'd ave(hgt,t-1,t+1)'
'c'
EOF
fi

cat>$tpzfile.ctl<<EOF
dset $tpzfile.gr
undef $undef_data
xdef $imx2 linear $xds $xydel
ydef $jmx2 linear $yds $xydel
tdef $nsstot linear feb1948 1mo
zdef  01 levels 1
vars 1
$var2  0 99 obs
ENDVARS
EOF

/usr/bin/grads -bl <havedata

cat > parm.h << eof
c
      parameter(icmon=$icmon)  ! sst ic month
      parameter(montot=$montot,nsstot=$nsstot)  ! total month number
      parameter(imx=180,jmx=89)  ! ersst dimension
      parameter(imx2=$imx2,jmx2=$jmx2) ! t2m or prec
      parameter(lagmax=$lagmax,nlead=$mlead,nmod=$nmod) 
      parameter(its_clm=$its_clm, ite_clm=$ite_clm) 
      parameter(ngrd=$ngrd)
      parameter(lons=$lons,lone=$lone,lats=$lats,late=$late) !eof_area=tp_nml
      parameter(id=0)
c
      parameter(nyr=$nyear)
      parameter(kocn=$kocn)
      parameter(ndec=$ndec)
eof
#
#gfortran -o pcr.x pcr.f reof.s.f
gfortran -mcmodel=large -o pcr.x pcr.f reof.s.f
echo "done compiling"

if [ -f fort.10 ] ; then
/bin/rm $tmp/fort.*
fi
#
outfile1=pc.${var1}.${eof_area}.icmon_$icmon.nmod$nmod
outfile2=eof.${var1}.${eof_area}.icmon_$icmon.nmod$nmod
outfile3=skill_2d.$var1.2.$var2.mlag$lagmax.mlead$mlead.nmod$nmod.3mon
outfile4=skill_1d.$var1.2.$var2.mlag$lagmax.mlead$mlead.nmod$nmod.3mon
outfile5=fcst.$var1.2.$var2.mlag$lagmax.mlead$mlead.nmod$nmod.3mon
#
ln -s $sstfile.gr          fort.10
ln -s $tpzfile.gr          fort.11
#
ln -s $dataot1/$outfile1.gr fort.20
ln -s $dataot1/$outfile2.gr fort.21
#
ln -s $dataot2/$outfile3.gr fort.30
ln -s $dataot2/$outfile4.gr fort.31
ln -s $dataot2/$outfile5.gr fort.32
#
./pcr.x > $dataot2/$var1.2.$var2.mlag$lagmax.mlead$mlead.nmod$nmod.out
#
nt_pc=`expr $nyear + 1 - $lagmax / 12`
cat>$dataot1/$outfile1.ctl<<EOF
dset ^$outfile1.gr
undef $undef
title EXP1
XDEF  1 linear   0.  2.
ydef  1 linear -88.  2.
zdef  1 linear 1 1
tdef  $nt_pc linear jan1951 1yr
vars  1
pc    1 99 pc
endvars
EOF
#
cat>$dataot1/$outfile2.ctl<<EOF
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
tdef  $mlead linear ${tgtmon}1981 1mon
vars  3
cor   1 99 corr
rms   1 99 rmse
hss   1 99 3c_hss
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
tdef $nt_clm linear ${tgtmon}1981 1mon
edef $mlead names 1 2
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
tdef  $mlead linear ${tgtmoyr} 1mon
vars  2
$var2  1 99 fcst with dimension
norm   1 99 normalized with stdv
endvars
EOF
#
done # var2 loop
