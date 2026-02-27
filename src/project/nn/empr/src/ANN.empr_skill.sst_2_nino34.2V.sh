#!/bin/sh

set -eaux

#=========================================================
# ANN empr forecast of NINO3.4 
#=========================================================
lcdir=/cpc/home/wd52pp/project/nn/empr/src
tmp=/cpc/consistency/tmp_ann
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi

datadir=/cpc/home/wd52pp/data/nn/empr
#
cd $tmp
#
for var2 in d20 sl ssttdc; do
for nmod1 in 3 5 8 11; do
for nmod2 in 3 5 8 11; do
#
model=ann
var1=sst
#var2=d20
nlead=12
nyr=41
#nmod1=3 #11 for sst alone
#nmod2=3 #
neurons=25
#
nmod=`expr $nmod1 + $nmod2` # +1 for putting obs nino34
nfld=`expr $nmod + 1` # +1 for putting obs nino34
epochs=200 # iterations
#
imx=144
jmx=73
ngrd1=1073 
ngrd2=1073
#
for tgtss in jfm fma mam amj mjj jja jas aso son ond ndj djf; do
#for tgtss in djf mam jja son; do

if [ $tgtss == jfm ]; then itgtbgn=13; ssn=1; fi
if [ $tgtss == fma ]; then itgtbgn=14; ssn=2; fi
if [ $tgtss == mam ]; then itgtbgn=15; ssn=3; fi
if [ $tgtss == amj ]; then itgtbgn=16; ssn=4; fi
if [ $tgtss == mjj ]; then itgtbgn=17; ssn=5; fi
if [ $tgtss == jja ]; then itgtbgn=18; ssn=6; fi
if [ $tgtss == jas ]; then itgtbgn=19; ssn=7; fi
if [ $tgtss == aso ]; then itgtbgn=20; ssn=8; fi
if [ $tgtss == son ]; then itgtbgn=21; ssn=9; fi
if [ $tgtss == ond ]; then itgtbgn=22; ssn=10; fi
if [ $tgtss == ndj ]; then itgtbgn=23; ssn=11; fi
if [ $tgtss == djf ]; then itgtbgn=24; ssn=12; fi

ld=1
while  [ $ld -le $nlead ]
do
#/bin/rm fort.*
#
# pick up tgt nino34 and predictor IC month data
#
cat > pick.f << eof
      program pickdata
      parameter(nt=$nyr,ld=$ld)
      parameter(itgtbgn=$itgtbgn)
      parameter(imx=$imx,jmx=$jmx)
c
      dimension xn34(nt),xsst(imx,jmx,nt)
      dimension w2d(imx,jmx),w2d2(imx,jmx)
c
      open(unit=11,form='unformatted',access='direct',recl=4)
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=21,form='unformatted',access='direct',recl=4)
      open(unit=22,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=23,form='unformatted',access='direct',recl=4*imx*jmx)
c
      ir1=itgtbgn
      ir2=itgtbgn-ld
      do it=1,$nyr
        read(11,rec=ir1) xn
        read(12,rec=ir2) w2d
        read(13,rec=ir2) w2d2

        write(21,rec=it) xn
        write(22,rec=it) w2d
        write(23,rec=it) w2d2
        
       ir1=ir1+12
       ir2=ir2+12
      enddo !it loop
c
      stop
      end
eof
 gfortran -o pick.x pick.f
 ln -s $datadir/hadoi.nino34.3mon.1979-curr.gr   fort.11
 ln -s $datadir/obs.$var1.mon.1979-curr.gr       fort.12
 ln -s $datadir/obs.$var2.mon.1979-curr.gr       fort.13
 ln -s obs.n34.gr                     fort.21
 ln -s obs.$var1.gr                   fort.22
 ln -s obs.$var2.gr                   fort.23
 pick.x
#
cat>obs.n34.ctl<<EOF
dset ^obs.n34.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1980 1yr
vars 1
o    1 99 model fcst
ENDVARS
EOF
#
##===============================
## have eof-pc input for var1
##===============================
#
cp $lcdir/input_grdsst_2_n34.eof.f input.f
cp $lcdir/reof.s.f reof.s.f
#
cat > parm.h << eof
       parameter(nt=$nyr,iskip=0)
       parameter(imx=$imx,jmx=$jmx)
       parameter(is=49,ie=121,js=29,je=45) !120E-300E; 5S-5N
       parameter(ngrd=$ngrd1,nfld=$nmod1+1)
       parameter(nmod=$nmod1, id=0)
eof
#
/bin/rm fort.*
#
 gfortran -o input.x reof.s.f input.f
#gfortran -mcmodel=medium -g -o test_data.x reof.s.f test_data.f
#
 ln -s obs.$var1.gr fort.10
 ln -s obs.n34.gr fort.20
 ln -s input.$var1.gr   fort.30
 ln -s eof.gr fort.40
#
 input.x
#
##===============================
## have eof-pc input for var2
##===============================
#
cat > parm.h << eof
       parameter(nt=$nyr,iskip=0)
       parameter(imx=$imx,jmx=$jmx)
       parameter(is=49,ie=121,js=29,je=45) !120E-300E; 5S-5N
       parameter(ngrd=$ngrd2,nfld=$nmod2+1)
       parameter(nmod=$nmod2, id=0)
eof
#
/bin/rm fort.*
#
 gfortran -o input.x reof.s.f input.f
#gfortran -mcmodel=medium -g -o test_data.x reof.s.f test_data.f
#
 ln -s obs.$var2.gr fort.10
 ln -s obs.n34.gr fort.20
 ln -s input.$var2.gr   fort.30
 ln -s eof.gr fort.40
#
 input.x
#
/bin/rm $tmp/fort.*
#
##===================================
##combine the inputs of all vars
##===================================
#
cat > comb_input.f << eof
      program combing
      parameter(nt=$nyr)
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
 ln -s input.$var1.gr fort.11
 ln -s input.$var2.gr fort.12
 ln -s input.gr       fort.20
 comb.x
#
/bin/rm $tmp/fort.*
#
##=====================================
## ANN nino34 hcst
##=====================================
#
nt_tot=$nyr  #1982->last year 
ntrain=`expr $nyr - 1`  #CV-1
ntest=1      # data length for prd
nvalid=0   # data length for validation
epochs=200 # iterations
neurons=$neurons #35 for ngrd=145
lrate=0.1 # learning rate (>0 to 2)
display_rate=5 # display rate for errors
#
cp $lcdir/mlp_bp.CV.f90 mlp.f90
#
cat > parm.h << eof
      parameter(iFILEROWS=$nt_tot, iDATAFIELDS=$nfld)
      parameter(iTRAINPATS=$ntrain,iTESTPATS=$ntest)
      parameter(iVALIDPATS=$nvalid)
      parameter(iEPOCHS=$epochs,iHIDDDEN=$neurons)
      parameter(ra=$lrate)
      parameter(iREDISPLAY=$display_rate)
eof
#
gfortran -g -fbacktrace -o mlp.x mlp.f90
echo "done compiling"

ln -s input.gr   fort.10
ln -s prd_train.bi   fort.20
ln -s mlp.ld$ld.bi   fort.30
ln -s prd_val.bi     fort.40

#excute program
mlp.x > $tmp/out
#
cat>mlp.ld$ld.ctl<<EOF
dset ^mlp.ld$ld.bi
undef -9.99E+33
title EXP1
XDEF  $ntest LINEAR    0  1.0
YDEF  1 LINEAR  -90  1.0
zdef  1 linear 1 1
tdef  $nyr linear jan1980 1yr
vars  1
p     1 99 prd
endvars
#
EOF
#
# calculate skill of OBS
#
cat >have_skill<<EOF
run skill.gs
EOF
cat >skill.gs<<EOF
ts=2
te=40
'reinit'
'open obs.n34.ctl'
'open mlp.ld$ld.ctl'
'set gxout fwrite'
'set fwrite skill.$ld'
'define oo=sqrt(ave(o*o,t='ts',t='te'))'
'define pp=sqrt(ave(p.2*p.2,t='ts',t='te'))'
'define ac=ave(o*p.2,t='ts',t='te')/(oo*pp)'
'define rms=sqrt(ave((o-p.2)*(o-p.2),t='ts',t='te'))'
'd ac'
'd rms'
EOF
#
/usr/local/bin/grads -bl <have_skill
#
ld=$(( ld+1 ))
done  # for ld

#cat skill together

mv skill.1 acrms.1
ld=2
while  [ $ld -le $nlead ]
do
ldm=$((ld-1))

cat acrms.$ldm  skill.$ld > acrms.$ld

\rm acrms.$ldm

ld=$(( ld+1 ))
done  # for ld
#

mv acrms.$nlead sk.$ssn

done  # for tgtseason
#=========================================
# cat skill of all season together
#=========================================
mv sk.1 ac.1
ss=2
while  [ $ss -le 12 ]
do
ssm=$((ss-1))

cat ac.$ssm  sk.$ss > ac.$ss

\rm ac.$ssm
\rm sk.$ss

ss=$(( ss+1 ))
done  # for ss
#
mv ac.12 $datadir/skill.$model.2V.${var1}_${var2}_2_nino34.nmod${nmod1}_${nmod2}.neurons$neurons.gr

cat>$datadir/skill.$model.2V.${var1}_${var2}_2_nino34.nmod${nmod1}_${nmod2}.neurons$neurons.ctl<<EOF
dset ^skill.$model.2V.${var1}_${var2}_2_nino34.nmod${nmod1}_${nmod2}.neurons$neurons.gr
undef -9.99e+33
*
TITLE model
*
XDEF  1 LINEAR    0.  2.5
YDEF  1 LINEAR  -90.  2.5
zdef  1 linear 1 1
tdef $nlead linear jan1980 1mon
edef 12 names 1 2 3 4 5 6 7 8 9 10 11 12
vars 2
ac  1 99 ac of ann
rms 1 99 rms of ann
ENDVARS
EOF
#
done # var2 loop
done # nmod2 loop
done # nmod1 loop
