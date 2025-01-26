#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp/test
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir0=/export/cpc-lw-mlheureux/wd52ml/enso/oni.v3b/data/errsst.v3b
datadir=/cpc/home/wd52pp/data/ca_prd
outdata=/cpc/home/wd52pp/data/casst
#
cd $tmp
#
#======================================
# have SST IC
#======================================
icmon_beg=jul2015
icmon_mid=aug2015
icmon_end=sep2015
icseason=7
#======================================
# define some parameters
#======================================
 sst_analysis=ersst
#eof_range=tp_np   #30S-60N
 eof_range=tp_ml   #45S-45N
#
if [ $eof_range == tp_np ]; then neoflat=46; eoflats=-30; lats=30; late=75; ngrd=5670; fi
if [ $eof_range == tp_ml ]; then neoflat=47; eoflats=-46; lats=22; late=68; ngrd=6438; fi
#
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10 
kocn=15
#
clm_add=1524  #dec1980
clm_end=`expr $clm_add + 360`
#
outfile=${sst_analysis}.3mon.ic
cat >havesstic<<EOF
run sstic.gs
EOF
cat >sstic.gs<<EOF
'reinit'
'open $datadir0/ersst.v3b.1854.2010.ctl'
'set x 1 180'
'set y 1  89'
'set t 1 12'
'define clm=ave(sst,t+$clm_add, t=$clm_end,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $outdata/$outfile.gr'
'd ave(sst-clm,time=$icmon_beg,time=$icmon_end)'
'c'
EOF
grads -l <havesstic
cat>$outdata/$outfile.ctl<<EOF
dset ^$outfile.gr
undef -999000000
*
TITLE Tsfc
*
xdef  180 linear   0. 2.
ydef   89 linear -89. 2.
zdef   1 linear 1 1
tdef   9999 linear jan2015 1mo
vars 1
t  1 99 3-mon mean (C)
ENDVARS
EOF
#
nps=11     #width of data window in season
nwextb=10  # 3mon season number to be extended at begining of a row of the array
nwexte=10  # 3mon season number to be extended at the end of a row of the array
runeof=1 # 0: read in ; 1: run eof
nyear=67 # 1948-2014
nseason=`expr $nyear - 2` #for eof and ca analysis
#
mlead=10  #laximum lead
npp=`expr $nps - $mlead`
mldp=`expr $mlead + 1` 
#
#for modemax in 15 20 25 30 35 40; do
for modemax in 25; do
for ridge in 0.01 0.03 0.05 0.07 0.09; do
cp $lcdir/realtime.ca_season.sst.f $tmp/sst_prd.f
cp $lcdir/eof_4_ca.s.f $tmp/eof_4_ca.s.f

#
cat > parm.h << eof
      parameter(nruneof=$runeof)
c
      parameter(ims=180,jms=89)   !input sst dimension
c
      parameter(lons=1,lone=180)   !lon range for EOFs analysis (0-360)
      parameter(eoflats=$eoflats,lats=$lats,late=$late)  !lat range for EOFs analysis (25S-65N)
      parameter(imp=lone-lons+1,jmp=late-lats+1)
c
      parameter(modemax=$modemax)
      parameter(nyear=$nyear)
      parameter(nseason=$nseason)
      parameter(nps=$nps)
      parameter(nwextb=$nwextb)
      parameter(nwexte=$nwexte)
c
      parameter(kocn=$kocn)
      parameter(ndec=$ndec)
      parameter(itgtm=$icseason)
      parameter(npp=$npp)
      parameter(mlead=$mlead)
      parameter(mldp=$mldp)
      parameter(ngrd=$ngrd)
      parameter(ridge=$ridge)
eof
#
gfortran -o ca.x sst_prd.f eof_4_ca.s.f
echo "done compiling"

/bin/rm $tmp/fort.*
#
ln -s $outdata/${sst_analysis}.3mon.ic.gr fort.10
ln -s $datadir/${sst_analysis}.3mon.1948-curr.gr fort.11
#
ln -s $outdata/eof.${sst_analysis}.3mon.gr fort.70
#
ln -s $outdata/real_ca_prd.${sst_analysis}.${eof_range}.$modemax.3mon.ridge$ridge.gr fort.85
#
ca.x > $lcdir/realtime.${sst_analysis}.ca.out
#ca.x 
#
cat>$outdata/eof.${sst_analysis}.3mon.ctl<<EOF
dset ^eof.${sst_analysis}.3mon.gr
undef -9.99E+33
title EXP1
xdef  180 linear   0. 2.
ydef  $neoflat linear $eoflats 2.
zdef  1 linear 1 1
tdef  99 linear jan1949 1mon
vars  1
eof   1 99 constructed
endvars
EOF
#
cat>$outdata/real_ca_prd.${sst_analysis}.${eof_range}.$modemax.3mon.ridge$ridge.ctl<<EOF
dset ^real_ca_prd.${sst_analysis}.${eof_range}.$modemax.3mon.ridge$ridge.gr
undef -9.99E+33
title EXP1
xdef  180 linear   0. 2.
ydef   89 linear -88. 2.
zdef  1 linear 1 1
tdef  $mldp linear $icmon_mid 1mon
vars  5
sst   1 99 sst prd
sdo   1 99 std of obs
sdf   1 99 std of fcst
ac    1 99 ac skill
rms   1 99 rms skill
endvars
EOF
#
done
done
#
