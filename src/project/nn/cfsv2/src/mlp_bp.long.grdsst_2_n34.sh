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
icmon=may
#
nflds=135 # inputs + outputs
nt_tot=38 # N(year)
ntrain=26 # 
ntest=`expr $nt_tot - $ntrain`  # data length for prd
nvalid=0   # data length for validation
epochs=200 # iterations
neurons=35 # hidden neuron number
lrate=0.1 # learning rate (>0 to 2)
display_rate=5 # display rate for errors
#
cp $lcdir/mlp_bp.long.f90 mlp.f90
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

ln -s $datadir/input_sst.${icmon}_ic.1982-2019.djf.gr fort.10
ln -s $datadir/prd_train.bi   fort.20
ln -s $datadir/mlp.djf.grdsst_2_n34.${icmon}_ic.long.bi  fort.30
ln -s $datadir/prd_val.bi     fort.40

#excute program
mlp.x > $datadir/out
#
cat>$datadir/mlp.djf.grdsst_2_n34.${icmon}_ic.long.ctl<<EOF
dset ^mlp.djf.grdsst_2_n34.${icmon}_ic.long.bi
undef -9.99E+33
title EXP1
XDEF  1 LINEAR    0  1.0
YDEF  1 LINEAR  -90  1.0
zdef  1 linear 1 1
tdef  $ntest linear jan2009 1yr
vars  1
p  0 99 prd
endvars
#
EOF
