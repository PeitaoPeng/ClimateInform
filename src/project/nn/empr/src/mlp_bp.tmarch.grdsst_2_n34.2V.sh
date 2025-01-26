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
var1=sst
var2=sst_tendency

icmon=may
iskip=0
#
ngrd=1073
nmod1=3
nmod2=3
nmod=`expr $nmod1 + $nmod2`
nfld=`expr $nmod + 1`

irun=1
ntots=31 # cover 1949-1979
ntote=72 # cover 1949-2020

ntot=$ntots
while [ $ntot -le $ntote ]
do

ntest=1   # data length for test
ntrain=`expr $ntot - $ntest`
nvalid=0   # data length for validation

epochs=200 # iterations
neurons=10  # hidden neuron number
lrate=0.1 # learning rate (>0 to 2)
display_rate=5 # display rate for errors
#
# generate input data
#
#if [ -d fort.10 ] ; then
/bin/rm $tmp/fort.*
#fi
cp $lcdir/input_grdsst_2_n34.eof.f test.f
cp $lcdir/reof.s.f reof.s.f
#
# for var1 input
cat > parm.h << eof
       parameter(nt=$ntot,iskip=$iskip)
       parameter(imx=144,jmx=73)
       parameter(is=49,ie=121,js=29,je=45) !20S-20N,120E-300E
       parameter(ngrd=$ngrd,nfld=$nmod1+1)
       parameter(nmod=$nmod1, id=0)
eof
 gfortran -o test.x reof.s.f test.f
#gfortran -mcmodel=medium -g -o test_data.x reof.s.f test_data.f
#
 ln -s $datadir/obs.$var1.${icmon}.1949-2020.anom.gr fort.10
 ln -s $datadir/nino34.hadoi.dec1949-feb2021.djf.gr fort.20
 ln -s $datadir/input_$var1.${icmon}_ic.1949-2020.djf.gr fort.30
 ln -s $datadir/eof.input_$var1.${icmon}_ic.1949-2020.djf.gr fort.40
#
 test.x
#
cat>$datadir/eof.input_$var1.${icmon}_ic.1949-2020.djf.ctl<<EOF
dset ^eof.input_$var1.${icmon}_ic.1949-2020.djf.gr
undef -9.99E+8
title EXP1
XDEF 144 LINEAR 0  2.5
YDEF  73 LINEAR    -90  2.5
zdef 1 linear 1 1
tdef $nmod linear jan1980 1yr
vars 2
c 1 99 corr
r 1 99 regr
endvars
#
EOF
#
/bin/rm $tmp/fort.*
#
# for var2 input
cat > parm.h << eof
       parameter(nt=$ntot,iskip=$iskip)
       parameter(imx=144,jmx=73)
       parameter(is=49,ie=121,js=29,je=45) !20S-20N,120E-300E
       parameter(ngrd=$ngrd,nfld=$nmod2+1)
       parameter(nmod=$nmod2, id=0)
eof
 gfortran -o test.x reof.s.f test.f
#gfortran -mcmodel=medium -g -o test_data.x reof.s.f test_data.f
#
 ln -s $datadir/obs.$var2.${icmon}.1949-2020.gr fort.10
 ln -s $datadir/nino34.hadoi.dec1949-feb2021.djf.gr fort.20
 ln -s $datadir/input_$var2.${icmon}_ic.1949-2020.djf.gr fort.30
 ln -s $datadir/eof.input_$var2.${icmon}_ic.1949-2020.djf.gr fort.40
#
 test.x
#
cat>$datadir/eof.input_$var2.${icmon}_ic.1949-2020.djf.ctl<<EOF
dset ^eof.input_$var2.${icmon}_ic.1949-2020.djf.gr
undef -9.99E+8
title EXP1
XDEF 144 LINEAR 0  2.5
YDEF  73 LINEAR    -90  2.5
zdef 1 linear 1 1
tdef $nmod linear jan1980 1yr
vars 2
c 1 99 corr
r 1 99 regr
endvars
#
EOF
#
/bin/rm $tmp/fort.*
#
#combine the inputs of all vars
#
cat > comb_input.f << eof
      program combing
      parameter(nt=$ntot,id=0)
      parameter(nmod1=$nmod1,nmod2=$nmod2)
      parameter(nfld1=$nmod1+1,nfld2=$nmod2+1)
      parameter(nfld=$nfld)
c
      dimension v1in(nfld1),v2in(nfld2)
      dimension out(nfld)
c
      open(unit=11,form='unformatted',access='direct',recl=4*nfld1)
      open(unit=12,form='unformatted',access='direct',recl=4*nfld2)
      open(unit=20,form='unformatted',access='direct',recl=4*nfld)
c
      do it=1,nt
        read(11,rec=it) v1in
        read(12,rec=it) v2in
        do i=1,nmod1
         out(i)=v1in(i)
        enddo
        do i=1,nfld2
         out(i+nmod1)=v2in(i)
        enddo
        write(20,rec=it) out
      enddo !it loop
c
      stop
      end
eof
 gfortran -o comb.x comb_input.f
 ln -s $datadir/input_$var1.${icmon}_ic.1949-2020.djf.gr fort.11
 ln -s $datadir/input_$var2.${icmon}_ic.1949-2020.djf.gr fort.12
 ln -s $datadir/input.${icmon}_ic.1949-2020.djf.gr       fort.20
 comb.x

/bin/rm $tmp/fort.*

#
# run ANN
#
cp $lcdir/mlp_bp.long.f90 mlp.f90
#
cat > parm.h << eof
      parameter(iFILEROWS=$ntot, iDATAFIELDS=$nfld)
      parameter(iTRAINPATS=$ntrain,iTESTPATS=$ntest)
      parameter(iVALIDPATS=$nvalid)
      parameter(iEPOCHS=$epochs,iHIDDDEN=$neurons)
      parameter(ra=$lrate)
      parameter(iREDISPLAY=$display_rate)
eof
#
gfortran -g -fbacktrace -o mlp.x mlp.f90
echo "done compiling"

ln -s $datadir/input.${icmon}_ic.1949-2020.djf.gr fort.10
ln -s $datadir/prd_train.bi   fort.20
ln -s mlp.$irun  fort.30
ln -s $datadir/prd_val.bi     fort.40

#excute program
mlp.x > $datadir/out
#
irun=`expr $irun + 1`
ntot=`expr $ntot + 1`
#
done # ntot loop
#
#cat mlp.$irun together
#
mv mlp.1 add.1
nr=`expr $ntote - $ntots + 1`
ir=2
while [ $ir -le $nr ] 
do

mr=`expr $ir - 1`
cat  add.$mr mlp.$ir > add.$ir
/bin/rm add.$mr
ir=`expr $ir + 1`

done

mv add.$nr $datadir/mlp.djf.grdsst_2_n34.${icmon}_ic.tmarch.bi

cat>$datadir/mlp.djf.grdsst_2_n34.${icmon}_ic.tmarch.ctl<<EOF
dset ^mlp.djf.grdsst_2_n34.${icmon}_ic.tmarch.bi
undef -9.99E+33
title EXP1
XDEF  1 LINEAR    0  1.0
YDEF  1 LINEAR  -90  1.0
zdef  1 linear 1 1
tdef  $nr linear jan1980 1yr
vars  1
p  0 99 prd
endvars
#
EOF
