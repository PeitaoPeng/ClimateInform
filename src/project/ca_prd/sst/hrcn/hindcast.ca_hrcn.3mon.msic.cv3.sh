#!/bin/sh

set -eaux
#cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
# for skill check and other diagnostics
#ccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 
lcdir=/cpc/home/wd52pp/project/ca_prd/sst/hrcn
tmp=/cpc/home/wd52pp/tmp
#tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir=/cpc/home/wd52pp/data/ca_prd
outdata=/cpc/home/wd52pp/data/hurricane
hurdir=/cpc/home/wd52pp/utility/hurricane/OBS
#
cd $tmp
#
for icseason in jfm fma mam amj; do
#
if [ $icseason = jfm ]; then ic_midmon=feb; ic_ss=1; fi
if [ $icseason = fma ]; then ic_midmon=mar; ic_ss=2; fi
if [ $icseason = mam ]; then ic_midmon=apr; ic_ss=3; fi
if [ $icseason = amj ]; then ic_midmon=may; ic_ss=4; fi
if [ $icseason = mjj ]; then ic_midmon=jun; ic_ss=5; fi
if [ $icseason = jja ]; then ic_midmon=jul; ic_ss=6; fi
if [ $icseason = jas ]; then ic_midmon=aug; ic_ss=7; fi
if [ $icseason = aso ]; then ic_midmon=sep; ic_ss=8; fi
if [ $icseason = son ]; then ic_midmon=oct; ic_ss=9; fi
if [ $icseason = ond ]; then ic_midmon=nov; ic_ss=10; fi
if [ $icseason = ndj ]; then ic_midmon=dec; ic_ss=11; fi
if [ $icseason = djf ]; then ic_midmon=jan; ic_ss=12; fi
#
ic_midmonyr=${ic_midmon}1981
if [ $icseason = djf ]; then ic_midmonyr=${ic_midmon}1982; fi
echo $icseason $ic_ss $ic_midmonyr
#
nyear=69 # 1948-2016
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10 
#
#for sst_analysis in hadoisst ersst; do
for sst_analysis in ersst; do
#
eof_range=tp_np   #30S-60N
#eof_range=tp_ml   #45S-45N
if [ $eof_range = tp_np ]; then neoflat=92; eoflats=-30.5; lats=60; late=151; fi
if [ $eof_range = tp_ml ]; then neoflat=92; eoflats=-45.5; lats=45; late=136; fi
#
#
if [ $eof_range = 'tp_ml' ]; then
if [ $sst_analysis = 'hadoisst' ]; then  ngrd=25057; fi
if [ $sst_analysis = 'ersst' ]; then  ngrd=23414; fi
fi
if [ $eof_range = 'tp_np' ]; then
if [ $sst_analysis = 'hadoisst' ]; then  ngrd=22529; fi
if [ $sst_analysis = 'ersst' ]; then  ngrd=20700; fi
fi
#
var=hrcn
nps=1      #width of data window in season
nwextb=10  # 3mon season number to be extended at begining of a row of the array
nwexte=2  # 3mon season number to be extended at the end of a row of the array
runeof=1 # 0: read in ; 1: run eof
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10 
nseason=`expr $nyear - 2` #for eof and ca analysis
nskip=32 # output from 1981
#nskip=0 # output from 1950
nsout=`expr $nyear - 2 - $nskip` #for eof and ca analysis
#
mlead=8   #maximum lead
npp=1
mldp=1 
#
for mseason in 1 2 3 4; do
for modemax in  15 25 40; do
cp $lcdir/hindcast.ca_hrcn.3mon.msic.cv3.f $tmp/sst_hcst.f
cp $lcdir/eof_4_ca.s.f $tmp/eof_4_ca.s.f

#
cat > parm.h << eof
      parameter(nruneof=$runeof)
c
      parameter(ims=360,jms=180)   !input sst dimension
c
      parameter(lons=1,lone=360)   !lon range for EOFs analysis (0-360)
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
      parameter(ndec=$ndec)
      parameter(itgtm=$ic_ss)
      parameter(npp=$npp)
      parameter(mlead=$mlead)
      parameter(mldp=$mldp)
      parameter(ngrd=$ngrd)
      parameter(mseason=$mseason)
      parameter(nskip=$nskip)
eof
#
gfortran -mcmodel=medium -g -o ca.x sst_hcst.f eof_4_ca.s.f
echo "done compiling"

/bin/rm $tmp/fort.*
#
ln -s $datadir/${sst_analysis}.3mon.1948-curr.1x1.gr fort.11
ln -s $hurdir/hurr_ATL_1948-2016.txt fort.12
#
ln -s $outdata/ca_hcst_skill.$var.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.gr fort.85
ln -s $outdata/ca_hcst.$var.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.gr fort.86
#
ca.x > $outdata/out.hrcn.ca_hcst.${sst_analysis}.$modemax.$icseason.${mseason}ics.$eof_range.cv3
#ca.x 
#
undef_data=-9.99E+8
cat>$outdata/ca_hcst_skill.$var.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.ctl<<EOF
dset ^ca_hcst_skill.$var.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.gr
undef $undef_data
title EXP1
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef  $mldp linear $ic_midmonyr 1mon
vars  2
ac    1 99 SST ac skill
rms   1 99 SST rms skill
endvars
EOF
#
cat>$outdata/ca_hcst.$var.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.ctl<<EOF
dset ^ca_hcst.$var.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.gr
undef $undef_data
title EXP1
XDEF 1 LINEAR    0.5  1.0
YDEF 1 LINEAR  -89.5  1.0
zdef 1 linear 1 1
tdef  $nsout linear $ic_midmonyr 1yr
vars  2
obs  1 99 obs ic
prd  1 99 constructed ic
endvars
EOF
#
done  # eof truncation loop
done  # season # loop
#
done  # sst_analysis loop
done   # icseason loop
