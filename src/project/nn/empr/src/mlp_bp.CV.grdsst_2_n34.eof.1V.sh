#!/bin/sh

set -eaux

##=====================================
## us field data to correct nino34 hcst (CV)
##=====================================
lcdir=/cpc/home/wd52pp/project/nn/empr/src
datadir=/cpc/home/wd52pp/data/nn/empr
tmp=/cpc/home/wd52pp/tmp

if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
cd $tmp
#
var=d20  #sst,d20,sl
#var=sst  #sst,d20,sl
icmon=may
#
nflds=12  # for eof inputs + outputs
#nflds=4   # for eof inputs + outputs
nt_tot=42 # N(year)
ntrain=41 # N-1 for CV test
#ntrain=39 # N-3 for CV test
ntest=1   # data length for test
nvalid=0   # data length for validation
epochs=200 # iterations
neurons=20  # hidden neuron number
lrate=0.1 # learning rate (>0 to 2)
display_rate=5 # display rate for errors
#
cp $lcdir/mlp_bp.CV.f90 mlp.f90
#cp $lcdir/mlp_bp.CV3.f90 mlp.f90
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

ln -s $datadir/input_$var.${icmon}_ic.1979-2020.djf.gr fort.10
ln -s prd_train.bi   fort.20
ln -s $datadir/mlp.djf.grdsst_2_n34.${icmon}_ic.bi  fort.30
ln -s prd_val.bi     fort.40

#excute program
mlp.x > $lcdir/out
#
cat>$datadir/mlp.djf.grdsst_2_n34.${icmon}_ic.ctl<<EOF
dset ^mlp.djf.grdsst_2_n34.${icmon}_ic.bi
undef -9.99E+33
title EXP1
XDEF  $ntest LINEAR    0  1.0
YDEF  1 LINEAR  -90  1.0
zdef  1 linear 1 1
tdef  ${nt_tot} linear jan1980 1yr
vars  1
p  0 99 prd
endvars
#
EOF
#
