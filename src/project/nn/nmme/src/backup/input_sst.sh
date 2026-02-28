set -euax
########################################################
# have grid SST input 
###############################################
#
ltime=38
icmon=may
ngrd=134
nfld=`expr $ngrd + 1`
nlead=7
#
lcdir=/cpc/home/wd52pp/project/nn/nmme/src
datadir2=/cpc/consistency/nn/nmme
datadir=/cpc/home/wd52pp/data/nn/nmme
tmp=/cpc/home/wd52pp/tmp
cd $tmp
cp $lcdir/input_sst.f test_data.f
#
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(imx=144,jmx=73)
       parameter(is=49,ie=121,js=29,je=45)
c      parameter(imx=360,jmx=181)
c      parameter(is=121,ie=301,js=76,je=111)
       parameter(ngrd=$ngrd,nfld=$nfld)
       parameter(nld=$nlead)
eof
#
\rm fort.*
 gfortran -o test_data.x test_data.f
 ln -s $datadir2/NMME.tmpsfc.ss.${icmon}_ic.1982-2019.ld1-7.esm.anom.gr fort.10
#ln -s $datadir/NMME.tmpsfc.ss.${icmon}_ic.1982-2019.ld1-7.esm.anom.gr fort.10
 ln -s $datadir/nino34.oi.dec1982-feb2020.djf.gr fort.20
 ln -s $datadir/input_sst.${icmon}_ic.1982-2019.djf.gr fort.30
 test_data.x 
#
cat>$datadir/input_sst.${icmon}_ic.1982-2019.djf.ctl<<EOF3
dset ^input_sst.${icmon}_ic.1982-2019.djf.gr
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
EOF3
   

