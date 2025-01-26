set -euax
########################################################
# have grid SST input 
###############################################
#
ltime=42
icmon=may
ngrd=147
nfld=`expr $ngrd + 1`
#
lcdir=/cpc/home/wd52pp/project/nn/empr/src
datadir2=/cpc/consistency/nn/empr
datadir=/cpc/home/wd52pp/data/nn/empr
tmp=/cpc/home/wd52pp/tmp
cd $tmp
cp $lcdir/input_grdsst_2_n34.f test_data.f
#
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(imx=144,jmx=73)
       parameter(is=49,ie=121,js=29,je=45) !120 -300 ngrd=147
c      parameter(is=49,ie=74,js=29,je=45) !120-180 ngrd=49
c      parameter(is=75,ie=121,js=29,je=45) !180-300; ngrd=89
       parameter(ngrd=$ngrd,nfld=$nfld)
eof
#
\rm fort.*
 gfortran -o test_data.x test_data.f
 ln -s $datadir/obs.sst.${icmon}.1979-2020.anom.gr fort.10
#ln -s $datadir/obs.d20.${icmon}.1979-2020.anom.gr fort.10
 ln -s $datadir/nino34.hadoi.dec1979-feb2021.djf.gr fort.20
 ln -s $datadir/input_sst.${icmon}_ic.1979-2020.djf.gr fort.30
 test_data.x 
#
cat>$datadir/input_sst.${icmon}_ic.1979-2020.djf.ctl<<EOF3
dset ^input_sst.${icmon}_ic.1979-2020.djf.gr
undef -9.99E+8
title EXP1
XDEF $nfld LINEAR 1  1.0
YDEF 1 LINEAR    -90  1.0
zdef 1 linear 1 1
tdef $ltime linear jan1979 1yr
vars 1
sst 1 99 grd sst fcst for DJF(lead=7)
endvars
#
EOF3
   

