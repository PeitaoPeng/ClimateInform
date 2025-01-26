#!/bin/sh

set -eaux
#cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
# for skill check and other diagnostics
#ccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 
lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp/test
#tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir0=/export/cpc-lw-mlheureux/wd52ml/enso/oni.v3b/data/errsst.v3b
datadir=/cpc/home/wd52pp/data/ca_prd
outdata=/cpc/home/wd52pp/data/casst
#
cd $tmp
#
icseason=mjj
ic_endmon=jul
ic_ss=5  #jfm=1
#
nyear=67 # 1948-2015
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10 
#
for var in temp prec z200; do
#for var in temp; do
#
for sst_analysis in ersst hadoisst; do
#
#eof_range=tp_np   #30S-60N
for eof_range in tp_ml tp_np; do   #45S-45N
if [ $eof_range == tp_np ]; then neoflat=92; eoflats=-30.5; lats=60; late=151; ngrd=20700; fi
if [ $eof_range == tp_ml ]; then neoflat=92; eoflats=-45.5; lats=45; late=136; ngrd=23414; fi
#
nps=11     #width of data window in season
nwextb=10  # 3mon season number to be extended at begining of a row of the array
nwexte=10  # 3mon season number to be extended at the end of a row of the array
runeof=1 # 0: read in ; 1: run eof
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10 
nseason=`expr $nyear - 2` #for eof and ca analysis
nskip=31 # output from 1981
#nskip=0 # output from 1950
nsout=`expr $nyear - 2 - $nskip` #for eof and ca analysis
#
mlead=10  #maximum lead
npp=`expr $nps - $mlead`
mldp=`expr $mlead + 1` 
#
for mseason in 1 2 3 4; do
for modemax in  15 25 40; do
#for modemax in 15; do
cp $lcdir/hindcast.ca_tpz.3mon.msic.f $tmp/sst_hcst.f
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
gfortran -o ca.x sst_hcst.f eof_4_ca.s.f
echo "done compiling"

/bin/rm $tmp/fort.*
#
ln -s $datadir/${sst_analysis}.3mon.1948-curr.1x1.gr fort.11
ln -s $datadir/$var.1949_cur.3mon.R1.1x1.gr         fort.12
#
ln -s $outdata/ca_hcst_skill.$var.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.R1.gr fort.85
ln -s $outdata/ca_hcst.$var.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.R1.gr fort.86
#
ca.x > $outdata/ca_hcst.$var.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.out
#ca.x 
#
undef_data=-9.99E+8
cat>$outdata/ca_hcst_skill.$var.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.R1.ctl<<EOF
dset ^ca_hcst_skill.$var.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.R1.gr
undef $undef_data
title EXP1
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef  $mldp linear ${ic_endmon}1981 1mon
vars  6
stdo  1 99 $var std of obs
stdf  1 99 $var std of fcst
ac    1 99 $var ac skill
rms   1 99 $var rms skill
sac    1 99 SST ac skill
srms   1 99 SST rms skill
endvars
EOF
#
cat>$outdata/ca_hcst.$var.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.R1.ctl<<EOF
dset ^ca_hcst.$var.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.R1.gr
undef $undef_data
title EXP1
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef  $nsout linear ${ic_endmon}1981 1yr
vars  22
ic  1 99 obs ic
cic 1 99 constructed ic
o1 1 99 obs 1
p1 1 99 prd 1
o2 1 99 obs 2
p2 1 99 prd 2
o3 1 99 obs 3
p3 1 99 prd 3
o4 1 99 obs 4 
p4 1 99 prd 4
o5 1 99 obs 5
p5 1 99 prd 5
o6 1 99 obs 6
p6 1 99 prd 6
o7 1 99 obs 7
p7 1 99 prd 7
o8 1 99 obs 8
p8 1 99 prd 8
o9 1 99 obs 9
p9 1 99 prd 9
o10 1 99 obs 10
p10 1 99 prd 10
endvars
EOF
#
done  # eof range
done  # eof truncation loop
done  # season # loop
#
done  # sst_analysis loop
done  # var loop
