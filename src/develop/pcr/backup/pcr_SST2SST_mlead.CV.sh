#
#======================================
# CV PCR from sst to sst
#=======================================

set -eaux

lcdir=/home/ppeng/src/develop/pcr
tmp=/home/ppeng/tmp
datain1=/home/ppeng/data/sst
datain2=$datain1
datadir=/home/ppeng/data/pcr_hcst/sst
#
nskip=0
undef=-999.0
#
nyr=75
longout=42 # 1981-2022
nmon=900  # nmon=nyr*12
eof_area=gl
ic_mean=3mon # sst ic
out_mean=3mon
nfyr_start=1 # left for 36-month lead
#
if [ $ic_mean = 3mon ]; then del=3; fi
if [ $ic_mean = mon ]; then del=1; fi
#
for var1 in ersst; do
        if [ $var1 = hadoisst ] && [ $eof_area = gltp ]; then ngrd=11399; fi
        if [ $var1 = hadoisst ] && [ $eof_area = tp_nml ]; then ngrd=18632; fi
        if [ $var1 = hadoisst ] && [ $eof_area = nml ]; then ngrd=7233; fi
        if [ $var1 = ersst ] && [ $eof_area = gl ]; then ngrd=40300; fi
        if [ $var1 = ersst ] && [ $eof_area = gltp ]; then ngrd=11020; fi
        if [ $var1 = ersst ] && [ $eof_area = tp_nml ]; then ngrd=17888; fi
        if [ $var1 = ersst ] && [ $eof_area = nml ]; then ngrd=6868; fi 
	echo ngrd

        if [ $eof_area = gltp ]; then lons=1;lone=360;lats=70;late=111; fi #global tropics
        if [ $eof_area = gl ]; then lons=1;lone=360;lats=1;late=180; fi #global
        if [ $eof_area = tp_nml ]; then lons=1;lone=360;lats=70;late=150; fi #tropical and N. mid-lad
        if [ $eof_area = nml ]; then lons=1;lone=360;lats=112;late=150; fi #tropical and N. mid-lad
        if [ $eof_area = tp_p ]; then lons=119;lone=291;lats=70;late=111; fi #tropical Pacific

for var2 in sst; do # ersst, hadoisst
#for tgtss in djf mam jja son; do
for tgtss in djf; do
for nmod in 15 20 ; do
#for ilead in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36; do
for ilead in 1 2; do
#
if [ $tgtss = jfm ]; then itgt=1; fi
if [ $tgtss = fma ]; then itgt=2; fi
if [ $tgtss = mam ]; then itgt=3; fi
if [ $tgtss = amj ]; then itgt=4; fi
if [ $tgtss = mjj ]; then itgt=5; fi
if [ $tgtss = jja ]; then itgt=6; fi
if [ $tgtss = jas ]; then itgt=7; fi
if [ $tgtss = aso ]; then itgt=8; fi
if [ $tgtss = son ]; then itgt=9; fi
if [ $tgtss = ond ]; then itgt=10; fi
if [ $tgtss = ndj ]; then itgt=11; fi
if [ $tgtss = djf ]; then itgt=12; fi
#
cp $lcdir/pcr_sst2tpz_mlead.CV.f $tmp/pcr.f

cp $lcdir/reof.s.f $tmp/reof.s.f
cd $tmp
#
cat > parm.h << eof
       parameter(nyr=$nyr,nmon=$nmon,del=$del)
       parameter(itgt=$itgt,ilead=$ilead)
       parameter(nfys=$nfyr_start)
       parameter(imx=360,jmx=180)
       parameter(nmod=$nmod)
       parameter(ngrd=$ngrd)
       parameter(lons=$lons,lone=$lone,lats=$lats,late=$late) !eof_area=tp Pacific
       parameter(id=0)
       parameter(longout=$longout)
eof
#
infile1=$var1.$ic_mean.1948-curr.total.1x1
infile2=$infile1
outfile=${var1}_2_$var2.cv.ic_$ic_mean.ld$ilead.nmod$nmod.$tgtss.${eof_area}.$out_mean
outfile1=pcr_$var2.cv.ic_$ic_mean.$tgtss.ld$ilead.nmod$nmod.${var1}_${eof_area}.$out_mean
outfile2=skill.pcr.cv.$var2.ic_$ic_mean.$tgtss.ld$ilead.nmod$nmod.${var1}_${eof_area}.$out_mean
outfile3=${var2}_regr.cv.ic_$ic_mean.$tgtss.ld$ilead.48-21.${var1}_${eof_area}.$out_mean
#
\rm $tmp/fort.*
#
gfortran -o pcr.x reof.s.f pcr.f
echo "done compiling"
#
ln -s $datain1/$infile1.gr            fort.10
ln -s $datain2/$infile2.gr            fort.11

ln -s $datadir/pc.$outfile.gr         fort.20
ln -s $datadir/eof.$outfile.gr        fort.21
#
ln -s $datadir/$outfile3.gr           fort.30
ln -s $datadir/$outfile1.gr           fort.31
ln -s $datadir/$outfile2.gr           fort.32
#
./pcr.x > $datadir/out_pcr.$outfile
#
cat>$datadir/pc.$outfile.ctl<<EOF
dset ^pc.$outfile.gr
undef $undef
title Realtime Surface Obs
xdef  1 linear   0.5 1.
ydef  1 linear -89.5 1.
zdef  1 levels 1
tdef 75 linear jan1981 1yr
edef $nmod names 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
vars  1
cf   0 99 PC
endvars
EOF
#
cat>$datadir/eof.$outfile.ctl<<EOF
dset ^eof.$outfile.gr
undef $undef
title Realtime Surface Obs
xdef  360 linear   0.5 1.
ydef  180 linear -89.5 1.
zdef  1 levels 1
tdef  $nmod linear jan1991 1yr
vars  2
cor  0 99 corr
reg  0 99 regr
endvars
EOF
#
cat>$datadir/$outfile1.ctl<<EOF
dset ^$outfile1.gr
undef $undef
title Realtime Surface Obs
xdef  360 linear   0.5 1.
ydef  180 linear -89.5 1.
zdef  1 levels 1
tdef  999 linear jan1981 1yr
vars  2
o     0 99 regr
p     0 99 regr
endvars
EOF
#
cat>$datadir/$outfile2.ctl<<EOF
dset ^$outfile2.gr
undef $undef
title Realtime Surface Obs
xdef  360 linear   0.5 1.
ydef  180 linear -89.5 1.
zdef  1 levels 1
tdef  1 linear jan1981 1yr
vars  2
cor   0 99 regr
rms   0 99 regr
endvars
EOF
#
cat>$datadir/$outfile3.ctl<<EOF
dset ^$outfile3.gr
undef $undef
title Realtime Surface Obs
xdef  360 linear   0.5 1.
ydef  180 linear -89.5 1.
zdef  1 levels 1
tdef  $nmod linear jan1981 1yr
vars  2
cor   0 99 corr
reg   0 99 regr
endvars
EOF
#
done # loop ilead
done # loop nmod
done # loop var2
done # loop eof_range
done # loop var1
