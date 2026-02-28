set -euax
########################################################
# have grid SST input 
###############################################
#
bias=0.
clim=2c
ltime=38
nlead=7
for icmon in nov dec jan feb mar apr may; do
#for icmon in may; do
if [ $icmon = nov ]; then ld=7; fi
if [ $icmon = dec ]; then ld=6; fi
if [ $icmon = jan ]; then ld=5; fi
if [ $icmon = feb ]; then ld=4; fi
if [ $icmon = mar ]; then ld=3; fi
if [ $icmon = apr ]; then ld=2; fi
if [ $icmon = may ]; then ld=1; fi

ngrd=145
#ngrd=22

nfld=`expr $ngrd + 1`
#
lcdir=/cpc/home/wd52pp/project/nn/cfsv2/src
datadir2=/cpc/consistency/nn/cfsv2_ww
datadir3=/cpc/consistency/nn/obs
datadir=/cpc/home/wd52pp/data/nn/cfsv2
tmp=/cpc/home/wd52pp/tmp
cd $tmp
cp $lcdir/input_grdsst_2_n34.grd.jja.f test_data.f
#
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(imx=144,jmx=73)
       parameter(is=49,ie=121,js=29,je=45) !120 -300 ngrd=145
c      parameter(is=49,ie=65,js=37,je=45) !120-160; 0N-20N ngrd=31
       parameter(ngrd=$ngrd,nfld=$nfld)
       parameter(nld=$nlead)
       parameter(ld=$ld)
       parameter(xbias=$bias)
eof
#
\rm fort.*
 gfortran -o test_data.x test_data.f
 ln -s $datadir2/CFSv2.SSTem.ss.${icmon}_ic.1982-2020.ld1-7.esm.anom.$clim.gr fort.10
 ln -s $datadir2/CFSv2.SSTem.ss.clim_bias.1982-2010.ld1-7.gr fort.11
 ln -s $datadir3/oisst.nino34.1982-cur.jja.gr fort.20
 ln -s $datadir/input_sst.${icmon}_ic.1982-2020.jja.$clim.gr fort.30
 test_data.x 
#
cat>$datadir/input_sst.${icmon}_ic.1982-2020.jja.$clim.ctl<<EOF3
dset ^input_sst.${icmon}_ic.1982-2020.jja.$clim.gr
undef -9.99E+8
title EXP1
XDEF $nfld LINEAR 1  1.0
YDEF 1 LINEAR    -90  1.0
zdef 1 linear 1 1
tdef $ltime linear jan1983 1yr
vars 1
sst 1 99 grd sst fcst for DJF
endvars
#
EOF3

done
   

