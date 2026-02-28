set -euax
########################################################
# have grid SST input 
###############################################
#
lcdir=/cpc/home/wd52pp/project/nn/cfsv2/mlr
datadir2=/cpc/consistency/nn/cfsv2_ww
datadir3=/cpc/home/wd52pp/data/obs/sst
datadir=/cpc/home/wd52pp/data/nn/cfsv2
tmp=/cpc/home/wd52pp/tmp
cd $tmp
cp $lcdir/mlr.grdsst_2_n34.jja.f test_data.f
#
bias=0.
clim=2c
ltime=38
for icmon in nov dec jan feb mar apr may; do
#for icmon in may; do

nlead=7
area=whole
ngrd=145
#ngrd=283
#area=nwp
#ngrd=23
#
ridge=0.05
del_ridge=0.05
#ridge=0.01
#del_ridge=0.01
#
#
if [ $icmon = 'nov' ]; then ld=7; fi
if [ $icmon = 'dec' ]; then ld=6; fi
if [ $icmon = 'jan' ]; then ld=5; fi
if [ $icmon = 'feb' ]; then ld=4; fi
if [ $icmon = 'mar' ]; then ld=3; fi
if [ $icmon = 'apr' ]; then ld=2; fi
if [ $icmon = 'may' ]; then ld=1; fi
#
nfld=`expr $ngrd + 1`
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(imx=144,jmx=73)
       parameter(is=49,ie=121,js=29,je=45) !120 -300 ngrd=134
c      parameter(is=49,ie=65,js=37,je=45) !120-160; 0N-20N ngrd=23
       parameter(ngrd=$ngrd,nfld=$nfld)
       parameter(nld=$nlead)
       parameter(ld=$ld)
       parameter(ridge=$ridge,del=$del_ridge)
       parameter(xbias=$bias)
eof
#
\rm fort.*
#
 gfortran -o test_data.x test_data.f
icmonyr=jan1983
#
 gfortran -o test_data.x test_data.f
 ln -s $datadir2/CFSv2.SSTem.ss.${icmon}_ic.1982-2020.ld1-7.esm.anom.$clim.gr fort.10
 ln -s $datadir2/CFSv2.SSTem.ss.clim_bias.1982-2010.ld1-7.gr fort.11
 ln -s $datadir3/nino34.oi.1982-2020.jja.gr fort.20
 ln -s $datadir/mlr.grdsst_2_n34.${icmon}_ic.1982-2020.jja.$area.$clim.gr fort.30
 test_data.x 
#
cat>$datadir/mlr.grdsst_2_n34.${icmon}_ic.1982-2020.jja.$area.$clim.ctl<<EOF3
dset ^mlr.grdsst_2_n34.${icmon}_ic.1982-2020.jja.$area.$clim.gr
undef -9.99E+8
title EXP1
XDEF 1 LINEAR 0  1.0
YDEF 1 LINEAR    -90  1.0
zdef 1 linear 1 1
tdef $ltime linear jan1983 1yr
vars 2
o 0 99 obs nino34
p 0 99 corrected nmme fcst
endvars
#
EOF3
done
