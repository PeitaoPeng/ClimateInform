set -euax
########################################################
# have grid SST input 
###############################################
#
ltime=42
icmon=apr
ngrd=1073
nmod=11 # modes kept
nfld=`expr $nmod + 1`
#
lcdir=/cpc/home/wd52pp/project/nn/empr/src
datadir=/cpc/home/wd52pp/data/nn/empr
tmp=/cpc/home/wd52pp/tmp
cd $tmp
cp $lcdir/input_grdsst_2_n34.eof.random.f test.f
#cp $lcdir/input_grdsst_2_n34.eof.f test.f
cp $lcdir/reof.s.f reof.s.f
#
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(imx=144,jmx=73)
c      parameter(is=49,ie=121,js=25,je=49) !120 -300
       parameter(is=49,ie=121,js=29,je=45) !120 -300
       parameter(ngrd=$ngrd,nfld=$nfld)
       parameter(nmod=$nmod, id=0)
eof
#
rm *.x fort.*
#
 gfortran -o test.x reof.s.f test.f
#gfortran -mcmodel=medium -g -o test_data.x reof.s.f test_data.f
#
 ln -s $datadir/obs.sst.${icmon}.1979-2020.anom.gr fort.10
 ln -s $datadir/nino34.hadoi.dec1979-feb2021.djf.gr fort.20
 ln -s $datadir/nino34.hadoi.dec1979-feb2021.djf.random.gr fort.25
 ln -s $datadir/input_sst.${icmon}_ic.1979-2020.djf.gr fort.30
 ln -s $datadir/eof.input_sst.${icmon}_ic.11979-2020.djf.gr fort.40
#
 test.x 
#
cat>$datadir/input_sst.${icmon}_ic.1979-2020.djf.ctl<<EOF
dset ^input_sst.${icmon}_ic.1979-2020.djf.gr
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

cat>$datadir/eof.input_sst.${icmon}_ic.1979-2020.djf.ctl<<EOF3
dset ^eof.input_sst.${icmon}_ic.1979-2020.djf.gr
undef -9.99E+8
title EXP1
XDEF 144 LINEAR 0  2.5
YDEF  73 LINEAR    -90  2.5
zdef 1 linear 1 1
tdef $nmod linear jan1981 1yr
vars 2
c 1 99 corr
r 1 99 regr
endvars
#
EOF3
   

