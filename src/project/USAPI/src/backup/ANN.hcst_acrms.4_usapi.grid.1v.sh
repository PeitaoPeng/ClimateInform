#!/bin/sh

set -eaux

#=========================================================
# ANN down scaling for NMME forecasted USAPI T&P 
#=========================================================
lcdir=/cpc/home/wd52pp/project/USAPI/src
tmp=/cpc/consistency/tmp_ann
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi

datadir1=/cpc/consistency/USAPI/obs
datadir2=/cpc/consistency/NA_prd/nmme
datadir3=/cpc/consistency/USAPI/skill
#
cd $tmp
# 
#for island in Chuuk Guam Kwajalein PagoPago Pohnpei Yap; do
for island in Chuuk; do

for curmo in 11; do
#for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
#
curyr=2019
model=NMME
tool=ann
varn=1V
varm=prate
varo=prec

lastyr=`expr $curyr - 1`
nextyr=`expr $curyr + 1`
nyr=`expr $lastyr - 1981`  # hcst yr #
nyrp1=`expr $nyr + 1`      # hcst_yr + cur_yr

tgtyr=$curyr
if [ $curmo = 12 ]; then tgtyr=$nextyr; fi
#
ngrd=4
nmod=$ngrd
nfld=`expr $nmod + 1` # +1 for putting obs nino34
nleadmon=7
nleadss=7
imx=360
jmx=181
#
# have input data to ANN package =======================================
#
imon=$curmo
if [ $imon = 01 ]; then icmonw=jan; tmons=feb; fi
if [ $imon = 02 ]; then icmonw=feb; tmons=mar; fi
if [ $imon = 03 ]; then icmonw=mar; tmons=apr; fi
if [ $imon = 04 ]; then icmonw=apr; tmons=may; fi
if [ $imon = 05 ]; then icmonw=may; tmons=jun; fi
if [ $imon = 06 ]; then icmonw=jun; tmons=jul; fi
if [ $imon = 07 ]; then icmonw=jul; tmons=aug; fi
if [ $imon = 08 ]; then icmonw=aug; tmons=sep; fi
if [ $imon = 09 ]; then icmonw=sep; tmons=oct; fi
if [ $imon = 10 ]; then icmonw=oct; tmons=nov; fi
if [ $imon = 11 ]; then icmonw=nov; tmons=dec; fi
if [ $imon = 12 ]; then icmonw=dec; tmons=jan; fi
#
#for tp in mon ss; do
for tp in ss; do
#for tp in mon; do

if [ $tp = 'mon' ]; then nlead=$nleadmon; fi
if [ $tp = 'ss' ];  then nlead=$nleadss; fi

tlongobs=`expr $nyrp1 \* $nlead`  # 

ld=1
while  [ $ld -le $nlead ]
do
#
# calculate input data
#
cat > parm.h << eof
       parameter(nt=$nyr)
       parameter(imx=$imx,jmx=$jmx)
       parameter(is=151,ie=152,js=98,je=99) !Chuuk
       parameter(ngrd=$ngrd,nfld=$nfld)
       parameter(nld=$nlead)
       parameter(ld=$ld)
       parameter(undef=-9.99E+8)
eof
#
cat > input.f << EOF
      program input_data
      include "parm.h"
      dimension tso(nt)
      dimension out(nfld)
      dimension w2d(imx,jmx),w3d(imx,jmx,nt)
      dimension wk3d(ngrd,nt)
      dimension land(imx,jmx)
C
      dimension ts1(nt),ts2(nt),ts3(nt)
      real corr(imx,jmx),regr(imx,jmx)
C
      open(unit=10,form='unformatted',access='direct',recl=4)
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)
C
      open(unit=30,form='unformatted',access='direct',recl=4*nfld)
c*************************************************
C
C== have coslat
C
C read model sst & obs nino34

      irm=ld
      iro=nld+ld
      do it=1,nt

        read(10,rec=iro) tso(it)   !obs island data
        read(20,rec=irm) w2d       !model hcst sst

        do i=1,imx
        do j=1,jmx
           w3d(i,j,it)=w2d(i,j)
        enddo
        enddo

        print *, 'iro=',iro
        iro=iro+nld
        irm=irm+nld
      enddo ! it loop
c
C select data from some grids
      do it=1,nt
      ig=0
      do i=is,ie
      do j=js,je
        if(abs(w3d(i,j,it)).lt.1000) then
        ig=ig+1
        wk3d(ig,it)=w3d(i,j,it)
        endif
      enddo
      enddo
      print *, 'ngrd=',ig
      enddo
C
C write out grid var and obs var
      do it=1,nt

        do i=1,ngrd
          out(i)=wk3d(i,it)
        enddo
          out(nfld)=tso(it)

        write(30,rec=it) out
        write(6,*) out
      enddo

      stop
      end
EOF
#
\rm fort.*
 gfortran -o input.x input.f
 ln -s $datadir1/$island.$varo.$tp.${icmonw}_ic.1981-2018.ld1-$nlead.anom.gr fort.10
 ln -s $datadir2/$model.$varm.$tp.${icmonw}_ic.1982-2020.ld1-$nlead.esm.anom.gr fort.20
 ln -s input.ld$ld.gr                                               fort.30
 input.x
#
cat>input.ld$ld.ctl<<EOF
dset ^input.ld$ld.gr
undef -9.99E+33
title EXP1
XDEF $nfld LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1982 1yr
vars  1
f  0 99 model and obs
endvars
#
EOF
##=====================================
## use field data to down scale USAPI hindcast
##=====================================
#
nt_tot=$nyr  #1982->last year
ntrain=`expr $nyr - 1`  #CV-1
ntest=1      # data length for prd
nvalid=0   # data length for validation
epochs=200 #iterations
neurons=4 #35 for ngrd=145
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

#if [ -d fort.10 ] ; then
\rm fort.*
#fi

ln -s input.ld$ld.gr  fort.10
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
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1982 1yr
vars  1
p  1 99 prd
endvars
#
EOF

#
# have obs of 1982-2019
#
cat >obsindex<<EOF
run verification.gs
EOF
cat >verification.gs<<EOF
'reinit'
'open $datadir1/$island.$varo.$tp.${icmonw}_ic.1981-2018.ld1-$nlead.anom.ctl'
'set gxout fwrite'
'set fwrite obs.ld$ld.gr'
'set x 1'
'set y 1'
it=$nlead+$ld
while ( it <= $tlongobs)
'set t 'it''
'd o'
it=it+$nlead
endwhile
EOF
#
/usr/local/bin/grads -bl < obsindex
#
cat>obs.ld$ld.ctl<<EOF
dset ^obs.ld$ld.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1982 1yr
vars 1
o 1 99 obs
ENDVARS
EOF
#
# have NMME model fcst surounding the island
#
cat >nmmefcst<<EOF
run nmme.gs
EOF
cat >nmme.gs<<EOF
'reinit'
'open input.ld$ld.ctl'
'set gxout fwrite'
'set fwrite nmme.ld$ld.gr'
'set x 1'
'set y 1'
it=1
while ( it <= $nyr)
'set t 'it''
'd ave(f,x=1,x=$ngrd)'
it=it+1
endwhile
EOF
#
/usr/local/bin/grads -bl < nmmefcst
#
cat>nmme.ld$ld.ctl<<EOF
dset ^nmme.ld$ld.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1982 1yr
vars 1
m 1 99 obs
ENDVARS
EOF
#
# calculate skill
#
cat >have_skill<<EOF
run skill.gs
EOF
cat >skill.gs<<EOF
'reinit'
'open obs.ld$ld.ctl'
'open mlp.ld$ld.ctl'
'open nmme.ld$ld.ctl'
'set gxout fwrite'
'set fwrite skill.$ld'
'define oo=sqrt(ave(o*o,t=1,t=$nyr))'
'define pp=sqrt(ave(p.2*p.2,t=1,t=$nyr))'
'define mm=sqrt(ave(m.3*m.3,t=1,t=$nyr))'
'define acop=ave(o*p.2,t=1,t=$nyr)/(oo*pp)'
'define acom=ave(o*m.3,t=1,t=$nyr)/(oo*mm)'
'define rmsop=sqrt(ave((o-p.2)*(o-p.2),t=1,t=$nyr))'
'define rmsom=sqrt(ave((o-m.3)*(o-m.3),t=1,t=$nyr))'
'd acop'
'd acom'
'd rmsop'
'd rmsom'
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

mv acrms.$nlead $datadir3/skill.$tool.$varn.NMME_${varm}_2_${island}_$varo.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.gr

cat>$datadir3/skill.$tool.$varn.NMME_${varm}_2_${island}_$varo.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.ctl<<EOF
dset ^skill.$tool.$varn.NMME_${varm}_2_${island}_$varo.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nlead linear ${tmons}1982 1mon
vars 4
acop  1 99 ac of ann
acom  1 99 ac of ann
rmsop 1 99 rms of ann
rmsom 1 99 rms of ann
ENDVARS
EOF

done  # for tp
done  # for curmo
done  # for island
