#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/nn/src
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir=$lcdir/data_test.bi
#
cd $tmp
#
nflds=3    # inputs + outputs
nt_tot=1000 # total length of data
ntrain=500   # data length for test
ntest=500   # data length for test
nvalid=0   # data length for validation
epochs=20 # iterations
neurons=4 # hidden neuron number
lrate=0.2 # learning rate (>0 to 2)
display_rate=2 # display rate for errors
#
cp $lcdir/mlp_bp.v2.f90 mlp.f90
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
gfortran -o mlp.x mlp.f90
echo "done compiling"

#if [ -d fort.10 ] ; then
/bin/rm $tmp/fort.*
#fi

ln -s $tmp/data_test.bi   fort.10
ln -s $tmp/prd_train.bi   fort.20
ln -s $tmp/prd_test.bi    fort.30
ln -s $tmp/prd_val.bi     fort.40

#excute program
mlp.x
#
