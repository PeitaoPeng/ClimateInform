#!/bin/sh

set -eaux
#cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
# with delta SSTs, for skill check and other diagnostics
#ccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 
lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp/test
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir=/cpc/home/wd52pp/data/ca_prd
outdata=/cpc/home/wd52pp/data/casst
#
cd $tmp
#
#for icseason in jfm fma mam amj mjj jja jas aso son ond ndj djf; do
 for icseason in fma; do
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
if [ $icseason = djf ]; then ic_midmonyr=${ic_midmon}1981; fi 
echo $icseason $ic_ss $ic_midmonyr
#
#for sst_analysis in ersst hadoisst; do
for sst_analysis in hadoisst; do
#
nyear=69 # 1948-2016
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10 
#
#======================================
# make delta file of SSTs as input of main code
#======================================
cp $datadir/${sst_analysis}.3mon.1948-curr.1x1.ctl ${sst_analysis}.3mon.1948-curr.1x1.ctl
cp $datadir/${sst_analysis}.3mon.1948-curr.1x1.gr  ${sst_analysis}.3mon.1948-curr.1x1.gr

nyrm=`expr $nyear - 1`

cat >delta_sst<<EOF
run delta.gs
EOF

cat >delta.gs<<EOF
'reinit'
'open ${sst_analysis}.3mon.1948-curr.1x1.ctl'
'set x 1 360'
'set y 1 180'
'set gxout fwrite'
'set fwrite sst.delta.gr'
yy=1
tt=1
while ( yy <= $nyrm )
mm=1
while ( mm <= 12 )

ttp=tt+12
'd sst(t='ttp')-sst(t='tt')'

mm=mm+1
tt=tt+1
endwhile
yy=yy+1
endwhile
EOF
#
grads -bl <delta_sst
#
cat>sst.delta.ctl<<EOF
dset ^sst.delta.gr
undef -999000000
*
TITLE Tsfc
*
xdef  360 linear   0.5  1.
ydef  180 linear -89.5 1.
zdef   1 linear 1 1
tdef 99999 linear feb1948 1mo
vars 1
t  1 99 delta sst (C)
ENDVARS
EOF
#
#eof_range=tp_np   #30S-60N
eof_range=tp_ml   #45S-45N
if [ $eof_range = tp_ml ]; then neoflat=92; eoflats=-45.5; lats=45; late=136; fi
if [ $eof_range = tp_np ]; then neoflat=92; eoflats=-30.5; lats=60; late=151; fi
#
#
if [ $eof_range = 'tp_ml' ]; then
if [ $sst_analysis = 'ersst' ]; then  ngrd=23414; fi
if [ $sst_analysis = 'hadoisst' ]; then  ngrd=25057; fi
fi
#
nps=17     #width of data window in season
nwextb=10  # 3mon season number to be extended at begining of a row of the array
nwexte=16  # 3mon season number to be extended at the end of a row of the array
runeof=1 # 0: read in ; 1: run eof
nyear=$nyrm # 1949-2016 for delta
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10 
nseason=`expr $nyear - 3` #for eof and ca analysis
nskip=31 # output from 1981
nsout=`expr $nyear - 3 - $nskip` #for eof and ca analysis
#
mlead=16  #maximum lead
npp=`expr $nps - $mlead`
mldp=`expr $mlead + 1` 
#
#for mseason in 1 2 3 4; do
for mseason in 1; do
#for modemax in  15 25 40; do
for modemax in  40; do
cp $lcdir/hindcast.ca_sst.3mon.msic.delta.f $tmp/sst_hcst.f
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
#gfortran -o ca.x sst_hcst.f eof_4_ca.s.f
gfortran -mcmodel=medium -g -o ca.x sst_hcst.f eof_4_ca.s.f
echo "done compiling"

/bin/rm $tmp/fort.*
#
ln -s sst.delta.gr fort.11
ln -s ${sst_analysis}.3mon.1948-curr.1x1.gr fort.12
#
ln -s $outdata/eof.${sst_analysis}.$icseason.${mseason}ics.${eof_range}.delta.gr fort.70
#
ln -s $outdata/ca_hcst.skill.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.delta.gr fort.85
ln -s $outdata/ca_hcst.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.delta.gr fort.86
#
ca.x > $outdata/ca_hcst.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.delta.out
#ca.x 
#
cat>$outdata/eof.${sst_analysis}.$icseason.${mseason}ics.${eof_range}.delta.ctl<<EOF
dset ^eof.${sst_analysis}.$icseason.${mseason}ics.${eof_range}.delta.gr
undef -9.99E+8
title EXP1
xdef  360 linear   0. 1.
ydef  $neoflat linear $eoflats 1.
zdef  1 linear 1 1
tdef  999 linear jan1949 1mon
vars  1
eof   1 99 constructed
endvars
EOF
#
cat>$outdata/ca_hcst.skill.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.delta.ctl<<EOF
dset ^ca_hcst.skill.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.delta.gr
undef -9.99E+8
title EXP1
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef  $mldp linear $ic_midmonyr 1mon
vars  15
rmsdel  1 99 odel vs fdel
rmstot  1 99 otot vs ftot
acdel  1 99 odel vs fdel
actot  1 99 otot vs ftot
covdel  1 99 fdel vs odel
covtot  1 99 ftot vs otot
covfo  1 99 ftot lead otot
covof  1 99 otot leads ftot
covodot  1 99 fdel vs otot
covfdot  1 99 odel vs otot
covotot  1 99 odel vs otot
stdodel  1 99 std of odel
stdfdel  1 99 std of fdel
stdotot  1 99 std of otot
stdftot  1 99 std of ftot
endvars
EOF
#
cat>$outdata/ca_hcst.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.delta.ctl<<EOF
dset ^ca_hcst.${sst_analysis}.$modemax.$icseason.${mseason}ics.${eof_range}.delta.gr
undef -9.99E+8
title EXP1
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
zdef    1 linear 1 1
tdef  $nsout linear $ic_midmonyr 1yr
vars  34
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
o11 1 99 obs 11
p11 1 99 prd 11
o12 1 99 obs 12
p12 1 99 prd 12
o13 1 99 obs 13
p13 1 99 prd 13
o14 1 99 obs 14
p14 1 99 prd 14
o15 1 99 obs 15
p15 1 99 prd 15
o16 1 99 obs 16
p16 1 99 prd 16
endvars
EOF
#
done
done
#
done
#
done   # icseason loop
