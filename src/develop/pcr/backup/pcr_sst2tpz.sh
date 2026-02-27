#=======================================
# PCR from sst to tpz
#=======================================

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_proj/pcr
tmp=/cpc/home/wd52pp/tmp
datadir=/cpc/home/wd52pp/data/ca_proj/obs
datadir2=/cpc/home/wd52pp/data/ca_proj/amip
#
var1=sst
var2=z200
nrun=100

tmax=43
ss=djf
eof_area=gl
#ngrd=11768 # for gl_tp
ngrd=44219  # for gl
#ngrd=19568 # for tp_nml

model=obs
nmod=15
nskip=0
undef=-999.0
#
cp $lcdir/pcr_sst2tpz.obs.f $tmp/pcr.f

cp $lcdir/reof.s.f $tmp/reof.s.f
cd $tmp
#
cat > parm.h << eof
       parameter(ltime=$tmax,nskip=$nskip)
       parameter(imx=360,jmx=180)
       parameter(nmod=$nmod)
       parameter(ngrd=$ngrd)
c      parameter(lons=119,lone=291,lats=70,late=111) !eof_area=tp Pacific
       parameter(lons=1,lone=360,lats=1,late=180)  !eof_area=gl
c      parameter(lons=1,lone=360,lats=70,late=111) !eof_area=gltp
c      parameter(lons=1,lone=360,lats=70,late=150) !eof_area=tp_nml
       parameter(id=0)
eof
#
infile1=FV3AMIP_$ss.sst_anom.yb1979.masked
infile2=core.z200.djf.dec1950-feb2022.1x1
outfile=$var1.obs.had-oi.79-21.$ss.${eof_area}
outfile2=pcr_$var2.nmod$nmod.$model.79-21.$ss.${eof_area}
outfile3=skill_pcr_vs_obs.$var2.nmod$nmod.79-21.$ss.${eof_area}
#
\rm $tmp/fort.*
#
gfortran -o pcr.x reof.s.f pcr.f
echo "done compiling"

#
ln -s $datadir2/$infile1.gr            fort.10
ln -s $datadir/$infile2.gr            fort.11

ln -s $datadir/pc.$outfile.gr         fort.20
ln -s $datadir/eof.$outfile.gr        fort.21
#
ln -s $datadir/proj.$outfile.gr       fort.30
ln -s $datadir/$outfile2.gr           fort.31
ln -s $datadir/$outfile3.gr           fort.32
#
pcr.x > $datadir/out_pcr.$outfile
#
cat>$datadir/pc.$outfile.ctl<<EOF
dset $datadir/pc.$outfile.gr
undef $undef
title Realtime Surface Obs
xdef  1 linear   0.5 1.
ydef  1 linear -89.5 1.
zdef  1 levels 1
tdef $tmax linear jan1980 1yr
edef $nmod names 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
vars  1
cf   0 99 PC
endvars
EOF
#
cat>$datadir/eof.$outfile.ctl<<EOF
dset $datadir/eof.$outfile.gr
undef $undef
title Realtime Surface Obs
xdef  360 linear   0.5 1.
ydef  180 linear -89.5 1.
zdef  1 levels 1
tdef  $nmod linear jan1980 1yr
vars  2
cor  0 99 corr
reg  0 99 regr
endvars
EOF
#
cat>$datadir/proj.$outfile.ctl<<EOF
dset $datadir/proj.$outfile.gr
undef $undef
title Realtime Surface Obs
xdef  1 linear   0.5 1.
ydef  1 linear -89.5 1.
zdef  1 levels 1
tdef $tmax linear jan1980 1yr
edef $nmod names 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
vars  1
pj   0 99 spatial proj
endvars
EOF
#
cat>$datadir/$outfile2.ctl<<EOF
dset $datadir/$outfile2.gr
undef $undef
title Realtime Surface Obs
xdef  360 linear   0.5 1.
ydef  180 linear -89.5 1.
zdef  1 levels 1
tdef  999 linear jan1980 1yr
vars  1
z     0 99 regr
endvars
EOF
#
cat>$datadir/$outfile3.ctl<<EOF
dset $datadir/$outfile3.gr
undef $undef
title Realtime Surface Obs
xdef  360 linear   0.5 1.
ydef  180 linear -89.5 1.
zdef  1 levels 1
tdef  1 linear jan1980 1yr
vars  2
cor   0 99 regr
rms   0 99 regr
endvars
EOF
#
