t!/bin/sh

set -eaux

#=========================================================
# Hybrid_MLR combing CFSv2_SSTem and obs_sst_d20 for nino3.4 skill for hindcast from each IC_month
#=========================================================
lcdir=/cpc/home/wd52pp/project/nn/opr
tmp=/cpc/consistency/tmp_ann
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi

datadir1=/cpc/consistency/nn/obs
datadir2=/cpc/consistency/nn/cfsv2_ww
datadir3=/cpc/home/wd52pp/data/nn/empr
#
cd $tmp
# 
#for curmo in 05; do
for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
#
curyr=2020
model=CFSv2
tool=mlr
varn=3V
clim=2c
var1=SSTem
var2=sst
var3=d20
nmod1=1
nmod2=3
nmod3=3
#
nmod=`expr $nmod1 + $nmod2 + $nmod3` 
nfld=`expr $nmod + 1` # +1 for putting obs nino34

lastyr=`expr $curyr - 1`
nextyr=`expr $curyr + 1`
nyr=`expr $lastyr - 1981`  # hcst yr #
nyrp1=`expr $nyr + 1`      # hcst_yr + cur_yr
clmperiod=1991-2020

tgtyr=$curyr
if [ $curmo = 12 ]; then tgtyr=$nextyr; fi
#
nleadmon=9
nleadss=7
imx=144
jmx=73
ngrd=1073
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

if [ $tp = 'mon' ]; then nlead=$nleadmon; fi
if [ $tp = 'ss' ];  then nlead=$nleadss; fi

ld=1
while  [ $ld -le $nlead ]
do
#
# calculate model nino34 as input for var1(SSTem)
#
cat > parm.h << eof
       parameter(nt=$nyr)
       parameter(imx=144,jmx=73)
       parameter(is=77,ie=97,js=35,je=39) !for nino3.4
       parameter(ngrd=$ngrd)
       parameter(nld=$nlead)
       parameter(ld=$ld)
       parameter(undef=-9.99E+8)
       parameter(nmod=$nmod1)
       parameter(nfld=$nmod1+1)
eof
#
cat > input.f << EOF
      program input_data
      include "parm.h"
      dimension on34(nt)
      dimension rn34(nt)
      dimension out(nfld)
      dimension w2d(imx,jmx),w3d(imx,jmx,nt)
      dimension land(imx,jmx)
C
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=10,form='unformatted',access='direct',recl=4)
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
C
      open(unit=30,form='unformatted',access='direct',recl=4*nfld)
c*************************************************
C
C== have coslat
C
C read land data; land=1,sea=0
      read(11,rec=1) land
c
C read model sst & obs nino34

      ir=ld
      do it=1,nt

        read(10,rec=ir) on34(it)  !obs nino34
        read(20,rec=ir) w2d       !model hcst sst

          do i=1,imx
          do j=1,jmx
              w3d(i,j,it)=w2d(i,j)
          enddo
          enddo

c       print *, 'ir=',ir
        ir=ir+nld
      enddo ! it loop
c
C assign undef
      do it=1,nt
        do i=1,imx
        do j=1,jmx
          if(land(i,j).eq.1.or.abs(w3d(i,j,30)).ge.1000) then
          w3d(i,j,it)=undef
          endif
        enddo
        enddo
      enddo
c
c
C calculate model nino34
      do it=1,nt
      ig=0
      xn34=0
      do i=is,ie
      do j=js,je
        if(abs(w3d(i,j,it)).lt.1000) then
        ig=ig+1
        xn34=xn34+w3d(i,j,it)
        endif
      enddo
      enddo
      rn34(it)=xn34/float(ig)
      enddo
c
C write out model nino34 and and obs nino34
      do it=1,nt

          out(1)=rn34(it)
          out(2)=on34(it)

        write(30,rec=it) out
      enddo

      stop
      end
EOF

\rm fort.*
 gfortran -o input.x input.f
 ln -s $datadir1/obs.nino34.$tp.${icmonw}_ic.1982-cur.ld1-$nlead.gr fort.10
 ln -s /cpc/home/wd52pp/project/nn/nmme/data_proc/land.2.5x2.5.gr   fort.11
 ln -s $datadir2/$model.$var1.$tp.${icmonw}_ic.1982-2020.ld1-$nlead.esm.anom.$clim.gr fort.20
 ln -s input1.gr                                               fort.30
 input.x

##===============================
## have eof-pc input for var2
##===============================
#
cp $lcdir/grd_2_eof_4_ic.f input.f
cp $lcdir/reof.s.f reof.s.f
#
iskip=3
if [ ${icmonw} = 'dec' ];  then iskip=2; fi
#
cat > parm.h << eof
       parameter(nt=$nyr,iskip=$iskip)
       parameter(imx=$imx,jmx=$jmx)
       parameter(is=49,ie=121,js=29,je=45) !120E-300E; 20S-20N
       parameter(ngrd=$ngrd)
       parameter(nmod=$nmod2,id=0)
eof
#
/bin/rm fort.*
#
 gfortran -o input.x reof.s.f input.f
#gfortran -mcmodel=medium -g -o test_data.x reof.s.f test_data.f
#
 ln -s $datadir3/obs.$var2.$icmonw.1979-2020.anom.gr fort.10
 ln -s input2.gr   fort.30
 ln -s eof.gr fort.40
#
 input.x
#
##===============================
## have eof-pc input for var3
##===============================
#
cat > parm.h << eof
       parameter(nt=$nyr,iskip=$iskip)
       parameter(imx=$imx,jmx=$jmx)
       parameter(is=49,ie=121,js=29,je=45) !120E-300E; 20S-20N
       parameter(ngrd=$ngrd)
       parameter(nmod=$nmod3, id=0)
eof
#
/bin/rm fort.*
#
 gfortran -o input.x reof.s.f input.f
#gfortran -mcmodel=medium -g -o test_data.x reof.s.f test_data.f
#
 ln -s $datadir3/obs.$var3.$icmonw.1979-2020.anom.gr fort.10
 ln -s input3.gr   fort.30
 ln -s eof.gr fort.40
#
 input.x
##===================================
##combine the inputs of all vars
##===================================
#
cat > comb_input.f << eof
      program combing
      parameter(nt=$nyr)
      parameter(nmod1=$nmod1,nmod2=$nmod2,nmod3=$nmod3)
      parameter(nfld1=nmod1+1)
      parameter(nfld=$nfld)
c
      dimension v1in(nfld1),v2in(nmod2),v3in(nmod3)
      dimension out(nfld)
c
      open(unit=11,form='unformatted',access='direct',recl=4*nfld1)
      open(unit=12,form='unformatted',access='direct',recl=4*nmod2)
      open(unit=13,form='unformatted',access='direct',recl=4*nmod3)
      open(unit=20,form='unformatted',access='direct',recl=4*nfld)
c
      do it=1,nt
        read(11,rec=it) v1in
        read(12,rec=it) v2in
        read(13,rec=it) v3in
        do i=1,nmod1
         out(i)=v1in(i)
        enddo
        do i=1,nmod2
         out(i+nmod1)=v2in(i)
        enddo
        do i=1,nmod3
         out(i+nmod1+nmod2)=v3in(i)
        enddo
         out(nfld)=v1in(nfld1)
        write(20,rec=it) out
      enddo !it loop
c
      stop
      end
eof
#
/bin/rm fort.*
#
 gfortran -o comb.x comb_input.f
 ln -s input1.gr   fort.11
 ln -s input2.gr   fort.12
 ln -s input3.gr   fort.13
 ln -s input.gr    fort.20
 comb.x
#
##===================================
#
##=====================================
## use field data to correct nino34 hcst
##=====================================
#
ridge=0.05
del_ridge=0.05
#
cp $lcdir/mlr.grdsst_2_n34.eof.f mlr.f
#
cat > parm.h << eof
       parameter(nt=$nyr)
       parameter(ngrd=$nmod,nfld=$nfld)
       parameter(ridge=$ridge,del=$del_ridge)
eof
#
\rm fort.*
#
 gfortran -o mlr.x mlr.f
#
#
 ln -s input.gr      fort.10
 ln -s mlr.ld$ld.bi  fort.20
 mlr.x
#
cat>mlr.ld$ld.ctl<<EOF
dset ^mlr.ld$ld.bi
undef -9.99E+33
title EXP1
XDEF  1 LINEAR    0  1.0
YDEF  1 LINEAR  -90  1.0
zdef  1 linear 1 1
tdef  $nyr linear jan1982 1yr
vars  2
o  0 99 prd
p  0 99 prd
endvars
#
EOF
#
# calculate nino34 of model fcst
#
cat >n34index<<EOF
run nino34.gs
EOF
cat >nino34.gs<<EOF
'reinit'
'open $datadir2/$model.SSTem.$tp.${icmonw}_ic.1982-2020.ld1-$nlead.esm.anom.$clim.ctl'
'set gxout fwrite'
'set fwrite model.n34.ld$ld.gr'
'set x 72'
'set y 37'
it=1
while ( it <= $nyr)
'set t 'it''
'set z '$ld''
'd aave(f,lon=190,lon=240,lat=-5,lat=5))'
it=it+1
endwhile
EOF
#
/usr/local/bin/grads -bl <n34index
#
cat>model.n34.ld$ld.ctl<<EOF
dset ^model.n34.ld$ld.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1982 1yr
vars 1
f 1 99 model fcst
ENDVARS
EOF
#
# calculate nino34 of OBS
#
cat >n34index<<EOF
run nino34.gs
EOF
cat >nino34.gs<<EOF
'reinit'
'open $datadir1/obs.sst.$tp.${icmonw}_ic.1982-cur.ld1-$nlead.anom.ctl'
'set gxout fwrite'
'set fwrite obs.n34.ld$ld.gr'
'set x 72'
'set y 37'
it=1
while ( it <= $nyr)
'set t 'it''
'set z '$ld''
'd aave(o,lon=190,lon=240,lat=-5,lat=5))'
it=it+1
endwhile
EOF
#
/usr/local/bin/grads -bl <n34index
#
cat>obs.n34.ld$ld.ctl<<EOF
dset ^obs.n34.ld$ld.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1982 1yr
vars 1
o 1 99 model fcst
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
'open obs.n34.ld$ld.ctl'
'open model.n34.ld$ld.ctl'
'open mlr.ld$ld.ctl'
'set gxout fwrite'
'set fwrite skill.$ld'
'define oo=sqrt(ave(o*o,t=1,t=$nyr))'
'define mm=sqrt(ave(f.2*f.2,t=1,t=$nyr))'
'define pp=sqrt(ave(p.3*p.3,t=1,t=$nyr))'
'define om=ave(o*f.2,t=1,t=$nyr)/(oo*mm)'
'define op=ave(o*p.3,t=1,t=$nyr)/(oo*pp)'
'define rmsom=sqrt(ave((o-f.2)*(o-f.2),t=1,t=$nyr))'
'define rmsop=sqrt(ave((o-p.3)*(o-p.3),t=1,t=$nyr))'
'd om'
'd rmsom'
'd op'
'd rmsop'
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

mv acrms.$nlead $datadir2/skill.$tool.$varn.${var1}_${var2}_${var3}_2_nino34.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.nmod${nmod1}_${nmod2}_${nmod3}.gr

cat>$datadir2/skill.$tool.$varn.${var1}_${var2}_${var3}_2_nino34.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.nmod${nmod1}_${nmod2}_${nmod3}.ctl<<EOF
dset ^skill.$tool.$varn.${var1}_${var2}_${var3}_2_nino34.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.nmod${nmod1}_${nmod2}_${nmod3}.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nlead linear ${tmons}1982 1mon
vars 4
acm  1 99 ac of model
rmsm 1 99 rms of model
aca  1 99 ac of ann
rmsa 1 99 rms of ann
ENDVARS
EOF

done  # for tp
#
done  # for curmo
