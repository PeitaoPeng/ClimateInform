set -euax
########################################################
# have grid SST input 
###############################################
#
clim=2c
ltime=38
icmon=may
#ngrd=1823
ngrd=1061
totmode=11 # rsd+eof kept
nfld=`expr $totmode + 1`
nmod=`expr $totmode - 2`
nlead=7
#
lcdir=/cpc/home/wd52pp/project/nn/cfsv2/src
datadir2=/cpc/consistency/nn/cfsv2_ww
datadir3=/cpc/home/wd52pp/data/obs/sst
datadir=/cpc/home/wd52pp/data/nn/cfsv2
tmp=/cpc/home/wd52pp/tmp
#
for icmon in may jun jul aug sep oct nov; do
#for icmon in may; do
if [ $icmon = may ]; then ld=7; fi
if [ $icmon = jun ]; then ld=6; fi
if [ $icmon = jul ]; then ld=5; fi
if [ $icmon = aug ]; then ld=4; fi
if [ $icmon = sep ]; then ld=3; fi
if [ $icmon = oct ]; then ld=2; fi
if [ $icmon = nov ]; then ld=1; fi

cd $tmp

cp $lcdir/input_grdsst_2_n34.eof-rsd-aavg.f input.f
cp $lcdir/reof.s.f reof.s.f
#
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(imx=144,jmx=73)
c      parameter(is=1,ie=144,js=29,je=45) !0-360 ngrd=243
       parameter(is=49,ie=121,js=29,je=45) !120 -300 ngrd=145
       parameter(lons=61,lone=69,lats=43,late=45) !150-170; 15N-20N
c      parameter(lons=83,lone=85,lats=45,late=45) !150-170; 15N-20N
       parameter(ngrd=$ngrd,nfld=$nfld)
       parameter(nld=$nlead)
       parameter(ld=$ld)
       parameter(nmod=$nmod, id=0)
eof
#
rm fort.*
 gfortran -o input.x reof.s.f input.f

 ln -s $datadir2/CFSv2.SSTem.ss.${icmon}_ic.1982-2020.ld1-7.esm.anom.$clim.gr fort.10
 ln -s $datadir/CFSv2.nino34.${icmon}_ic.1982-2020.djf.$clim.gr fort.15
 ln -s $datadir3/nino34.oi.1982-2020.djf.gr fort.20
 ln -s $datadir/input_sst.${icmon}_ic.1982-2020.djf.$clim.gr fort.30
 ln -s $datadir/rsd-eof.input_sst.${icmon}_ic.1982-2019.djf.$clim.gr fort.40

 input.x
#
cat>$datadir/input_sst.${icmon}_ic.1982-2020.djf.$clim.ctl<<EOF
dset ^input_sst.${icmon}_ic.1982-2020.$clim.gr
undef -9.99E+8
title EXP1
XDEF $nfld LINEAR 1  1.0
YDEF 1 LINEAR    -90  1.0
zdef 1 linear 1 1
tdef $ltime linear jan1983 1yr
vars 1
sst 1 99 grd sst fcst for DJF(lead=7)
endvars
#
EOF

cat>$datadir/rsd-eof.input_sst.${icmon}_ic.1982-2019.djf.$clim.ctl<<EOF3
dset ^rsd-eof.input_sst.${icmon}_ic.1982-2019.djf.$clim.gr
undef -9.99E+8
title EXP1
XDEF 144 LINEAR 0  2.5
YDEF  73 LINEAR    -90  2.5
zdef 1 linear 1 1
tdef $totmode linear jan1983 1yr
vars 2
c 1 99 cor (t=1 rsd)
r 1 99 regr
endvars
#
EOF3
   
done
