#!/bin/sh

set -eaux

##=====================================
## for a field data and cross validation (CV)
##=====================================
lcdir=/cpc/home/wd52pp/project/nn/ca
datadir=/cpc/home/wd52pp/data/nn/ca
tmp=/cpc/home/wd52pp/tmp

if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
cd $tmp
#
icss=fma
icmidmon=mar
#
nflds=2    # inputs + outputs
nt_tot=36 # N(year)
ntrain=35 # N-1 for CV test
ntest=1   # data length for test
nvalid=0   # data length for validation
epochs=200 # iterations
neurons=2 # hidden neuron number
lrate=0.2 # learning rate (>0 to 2)
display_rate=2 # display rate for errors
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

ln -s $datadir/cahcst.djf.nino34.${icss}_ic.esm.gr   fort.10
ln -s $datadir/prd_train.bi   fort.20
ln -s $datadir/mlp.djf.nino34.${icss}_ic.bi    fort.30
ln -s $datadir/prd_val.bi     fort.40

#excute program
mlp.x > $datadir/out1
#
cat>$datadir/mlp.djf.nino34.${icss}_ic.ctl<<EOF
dset ^mlp.djf.nino34.${icss}_ic.bi
undef -9.99E+33
title EXP1
XDEF  $ntest LINEAR    0  1.0
YDEF  1 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef  ${nt_tot} linear ${icmidmon}1981 1yr
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
YDEF  1 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef  ${nt_tot} linear 01jan1982 1yr
vars  1
p  0 99 prd
endvars
#
EOF
