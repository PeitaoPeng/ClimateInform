#!/bin/sh

set -eaux
#cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
# for skill check and other diagnostics
#ccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 
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
#sst_analysis=ersst      
 sst_analysis=hadoisst

#eof_range=tp_np   #30S-60N
 eof_range=tp_ml   #45S-45N
#
icseason=amj
ic_endmon=jun
tgt_ss=4  #jfm=1
#
if [ $eof_range == tp_np ]; then neoflat=46; eoflats=-30; lats=30; late=75; ngrd=5670; fi
if [ $eof_range == tp_ml ]; then neoflat=47; eoflats=-46; lats=22; late=68; ngrd=6438; fi
#
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10 
nps=11     #width of data window in season
nwextb=10  # 3mon season number to be extended at begining of a row of the array
nwexte=10  # 3mon season number to be extended at the end of a row of the array
runeof=1 # 0: read in ; 1: run eof
nyear=67 # 1948-2014
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10 
nseason=`expr $nyear - 2` #for eof and ca analysis
nsout=`expr $nseason - 32` #from 1981
#
mlead=10  #laximum lead
npp=`expr $nps - $mlead`
mldp=`expr $mlead + 1` 
#
#for modemax in 15 20 25 30 35 40; do
for modemax in 25; do
cp $lcdir/hindcast.ca_sst.3mon.f $tmp/sst_hcst.f
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
      parameter(ndec=$ndec)
      parameter(itgtm=$tgt_ss)
      parameter(npp=$npp)
      parameter(mlead=$mlead)
      parameter(mldp=$mldp)
      parameter(ngrd=$ngrd)
eof
#
gfortran -o ca.x sst_hcst.f eof_4_ca.s.f
echo "done compiling"

/bin/rm $tmp/fort.*
#
ln -s $datadir/${sst_analysis}.3mon.1948-curr.gr fort.11
#
ln -s $outdata/eof.${sst_analysis}.$icseason.${eof_range}.gr fort.70
#
ln -s $outdata/ca_hcst.skill.${sst_analysis}.$modemax.$icseason.${eof_range}.gr fort.85
ln -s $outdata/ca_hcst.${sst_analysis}.$icseason.${eof_range}.gr fort.86
#
ca.x > $outdata/ca_hcst.${sst_analysis}.$modemax.$icseason.${eof_range}.out
#ca.x 
#
cat>$outdata/eof.${sst_analysis}.$icseason.${eof_range}.ctl<<EOF
dset ^eof.${sst_analysis}.$icseason.${eof_range}.gr
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
cat>$outdata/ca_hcst.skill.${sst_analysis}.$modemax.$icseason.${eof_range}.ctl<<EOF
dset ^ca_hcst.skill.${sst_analysis}.$modemax.$icseason.${eof_range}.gr
undef -9.99E+33
title EXP1
xdef  180 linear   0. 2.
ydef   89 linear -88. 2.
zdef  1 linear 1 1
tdef  $mldp linear ${ic_endmon}1981 1mon
vars  4
stdo  1 99 std of obs
stdf  1 99 std of fcst
ac    1 99 ac skill
rms   1 99 rms skill
endvars
EOF
#
cat>$outdata/ca_hcst.${sst_analysis}.$icseason.${eof_range}.ctl<<EOF
dset ^ca_hcst.${sst_analysis}.$icseason.${eof_range}.gr
undef -9.99E+33
title EXP1
xdef  180 linear   0. 2.
ydef   89 linear -88. 2.
zdef    1 linear 1 1
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
done
#
