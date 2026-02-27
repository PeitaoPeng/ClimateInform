#!/bin/sh

set -eaux

##=====================================
## us field data to correct nino34 hcst (CV)
##=====================================
lcdir=/cpc/home/wd52pp/project/nn/cfsv2/src
datadir=/cpc/home/wd52pp/data/nn/cfsv2
tmp=/cpc/home/wd52pp/tmp

if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
cd $tmp
#
tgtss=djf
clim=2c # clim type
area=whole
#nflds=244 # inputs + outputs
#nflds=147 # ngrd + 2
nflds=25 # ngrd+2
#
neurons=35 # hidden neuron number
#neurons=150 # hidden neuron number
#neurons=10 # for NWTP, hidden neuron number
#
 for icmon in may jun jul aug sep oct nov; do
#for icmon in nov dec jan feb mar apr may; do
#for icmon in nov; do
#for icmon in may; do
#
nt_tot=38 # N(year)
ntrain=37 # N-1 for CV test
ntest=1   # data length for test
nvalid=0   # data length for validation
epochs=200 # iterations
lrate=0.1 # learning rate (>0 to 2)
display_rate=5 # display rate for errors
#
cp $lcdir/mlp_bp.CV.f90 mlp.f90
#
cat > parm.h << eof
      parameter(iFILEROWS=$nt_tot, iDATAFIELDS=$nflds)
      parameter(iTRAINPATS=$ntrain,iTESTPATS=$ntest)
      parameter(iVALIDPATS=$nvalid)
      parameter(iEPOCHS=$epochs,iHIDDDEN=$neurons)
      parameter(ra=$lrate)
      parameter(iREDISPLAY=$display_rate)
eof
#
gfortran -g -fbacktrace -o mlp.x mlp.f90
echo "done compiling"

#if [ -d fort.10 ] ; then
/bin/rm $tmp/fort.*
#fi

ln -s $datadir/input_sst.${icmon}_ic.1982-2020.$tgtss.$clim.gr fort.10
ln -s $datadir/prd_train.bi   fort.20
ln -s $datadir/mlp.$tgtss.grdsst_2_n34.${icmon}_ic.$area.$clim.bi  fort.30
ln -s $datadir/prd_val.bi     fort.40

#excute program
mlp.x > $datadir/out
#
cat>$datadir/mlp.$tgtss.grdsst_2_n34.${icmon}_ic.$area.$clim.ctl<<EOF
dset ^mlp.$tgtss.grdsst_2_n34.${icmon}_ic.$area.$clim.bi
undef -9.99E+33
title EXP1
XDEF  $ntest LINEAR    0  1.0
YDEF  1 LINEAR  -90  1.0
zdef  1 linear 1 1
tdef  ${nt_tot} linear jan1983 1yr
vars  1
p  0 99 prd
endvars
#
EOF
#
cat>$datadir/prd_train.ctl<<EOF
dset ^prd_train.bi
undef -9.99E+33
title EXP1
XDEF  $ntrain LINEAR    0  1.0
YDEF  1 LINEAR  -90  1.0
zdef  1 linear 1 1
tdef  ${nt_tot} linear jan1983 1yr
vars  1
p  0 99 prd
endvars
#
EOF
done
