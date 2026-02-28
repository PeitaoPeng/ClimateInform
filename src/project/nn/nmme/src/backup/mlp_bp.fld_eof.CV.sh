#!/bin/sh

set -eaux

##=====================================
## correct field fcst with field data (CV)
##=====================================
lcdir=/cpc/home/wd52pp/project/nn/nmme/src
datadir=/cpc/consistency/nn/nmme
datadir2=/cpc/consistency/nn/obs
tmp=/cpc/home/wd52pp/tmp

if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
cd $tmp
#
model=NMME
nmodm=13
nmodo=13
#
nflds=`expr $nmodm + 1`
nt_tot=38 # N(year)
ntrain=37 # N-1 for CV test
ntest=1   # data length for test
nvalid=0   # data length for validation
epochs=200 # iterations
neurons=20 # hidden neuron number
lrate=0.1 # learning rate (>0 to 2)
display_rate=5 # display rate for errors
#
#=======================================
# core part of correcting process 
#=======================================
#
cp $lcdir/mlp_bp.fld_eof.CV.f90 mlp.f90
#
cat > parm.h <<eof
      parameter(nt=$nt_tot)
      parameter(nfld=$nflds)
      parameter(undef=-9.99e+8)
!
      parameter(nmodm=$nmodm,nmodo=$nmodo)
!
      parameter(iFILEROWS=$nt_tot, iDATAFIELDS=$nflds)
      parameter(iTRAINPATS=$ntrain,iTESTPATS=$ntest)
      parameter(iVALIDPATS=$nvalid)
      parameter(iEPOCHS=$epochs,iHIDDDEN=$neurons)
      parameter(ra=$lrate)
      parameter(iREDISPLAY=$display_rate)

eof
#
gfortran -g -fbacktrace -o mlp.x  mlp.f90

#if [ -d fort.10 ] ; then
/bin/rm $tmp/fort.*
#fi

ln -s $datadir/input_fld_CV.eof.model.gr fort.15
ln -s $datadir/input_fld_CV.eof.obs.gr fort.25
#
ln -s $datadir/input.1_grid.gr fort.10
#
ln -s prd_train.1_grd.bi   fort.20
ln -s mlp.1_grd.bi   fort.30
ln -s prd_val.1_grd.bi   fort.40
#
ln -s $datadir/mlp.sst_coef.bi   fort.50

# excute program
mlp.x > $datadir/out
#
cat>$datadir/mlp.sst_coef.ctl<<EOF
dset ^mlp.sst_coef.bi
undef -9.99E+08
title EXP1
XDEF  ${nt_tot} LINEAR    1  1
YDEF  1 LINEAR  -90  2.5
zdef  1 linear 1 1
tdef  $nmodo linear jan1983 1yr
vars  1
c 0 99 coef prd
endvars
#
EOF
