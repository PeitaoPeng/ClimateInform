t!/bin/sh

set -eaux

#=========================================================
# Hybrid_MLR combined EEOF of CFSv2_SSTem and obs_sst_d20 for nino3.4 skill for hindcast from each IC_month
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
#for nmod in 10 11 12; do 
for nmod in 5; do 
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
#
#nmod=10 
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
ngrd=3219
#
# have input data to ANN package =======================================
#
imon=$curmo
if [ $imon = 01 ]; then icmonw=jan; tmons=feb; oicmonw=dec; fi
if [ $imon = 02 ]; then icmonw=feb; tmons=mar; oicmonw=jan; fi
if [ $imon = 03 ]; then icmonw=mar; tmons=apr; oicmonw=feb; fi
if [ $imon = 04 ]; then icmonw=apr; tmons=may; oicmonw=mar; fi
if [ $imon = 05 ]; then icmonw=may; tmons=jun; oicmonw=apr; fi
if [ $imon = 06 ]; then icmonw=jun; tmons=jul; oicmonw=may; fi
if [ $imon = 07 ]; then icmonw=jul; tmons=aug; oicmonw=jun; fi
if [ $imon = 08 ]; then icmonw=aug; tmons=sep; oicmonw=jul; fi
if [ $imon = 09 ]; then icmonw=sep; tmons=oct; oicmonw=aug; fi
if [ $imon = 10 ]; then icmonw=oct; tmons=nov; oicmonw=sep; fi
if [ $imon = 11 ]; then icmonw=nov; tmons=dec; oicmonw=oct; fi
if [ $imon = 12 ]; then icmonw=dec; tmons=jan; oicmonw=nov; fi
#for tp in mon ss; do
for tp in ss; do

if [ $tp = 'mon' ]; then nlead=$nleadmon; fi
if [ $tp = 'ss' ];  then nlead=$nleadss; fi

ld=1
while  [ $ld -le $nlead ]
do
#
# calculate input for var1(SSTem)
#
cp $lcdir/reof.s.f reof.s.f
#
cat > parm.h << eof
       parameter(nt=$nyr)
       parameter(imx=144,jmx=73)
       parameter(is=49,ie=121,js=29,je=45) !120-300 ngrd=1061
       parameter(ngrd=$ngrd)
       parameter(nld=$nlead)
       parameter(ld=$ld)
       parameter(undef=-9.99E+8)
       parameter(nmod=$nmod,id=0)
       parameter(nfld=$nmod+1)
eof
#
cat > input.f << EOF
      program input_data
      include "parm.h"
      dimension on34(nt)
      dimension out(nfld)
      dimension w2d(imx,jmx),w2d2(imx,jmx),w2d3(imx,jmx)
      dimension w3d(imx,jmx,nt),w3d2(imx,jmx,nt),w3d3(imx,jmx,nt)
      dimension w3ds(imx,jmx,nt),w3ds2(imx,jmx,nt),w3ds3(imx,jmx,nt)
      dimension land(imx,jmx)
C
      dimension ts1(nt),ts2(nt),ts3(nt),ts4(nt),ts5(nt)
      dimension aaa(ngrd,nt),wk(nt,ngrd)
      dimension xlat(jmx),coslat(jmx),cosr(jmx)
      dimension eval(nt),evec(ngrd,nt),coef(nt,nt)
      real weval(nt),wevec(ngrd,nt),wcoef(nt,nt)
      real reval(nmod),revec(ngrd,nmod),rcoef(nmod,nt)
      real rwk(ngrd),rwk2(ngrd,nmod)
      real corr(imx,jmx),regr(imx,jmx)
      real corr2(imx,jmx),regr2(imx,jmx)
      real corr3(imx,jmx),regr3(imx,jmx)
C
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=21,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=22,form='unformatted',access='direct',recl=4*imx*jmx)
C
      open(unit=10,form='unformatted',access='direct',recl=4)
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
C
      open(unit=30,form='unformatted',access='direct',recl=4*nfld)
      open(unit=40,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=41,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=42,form='unformatted',access='direct',recl=4*imx*jmx)
c*************************************************
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-90+(j-1)*2.5
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use
        cosr(j)=sqrt(coslat(j))  !for EOF use
      enddo
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
C read obs sst and d20

      iskip=3
c     if($imon.eq.12) iskip=2
      if($imon.eq.1) iskip=2 ! IC-mon is the DEC of last year
      ir=iskip + 1
      do it=1,nt

        read(21,rec=ir) w2d2
        read(22,rec=ir) w2d3

          do i=1,imx
          do j=1,jmx
            w3d2(i,j,it)=w2d2(i,j)
            w3d3(i,j,it)=w2d3(i,j)
          enddo
          enddo

        print *, 'ir=',ir
        ir=ir+1
      enddo ! it loop
C
C have data standardized
      do i=is,ie
      do j=js,je
        do it=1,nt
        w3ds(i,j,it)=undef
        w3ds2(i,j,it)=undef
        w3ds3(i,j,it)=undef
        enddo
      enddo
      enddo

      do i=is,ie
      do j=js,je
        if(abs(w3d(i,j,1)).lt.500) then
        do it=1,nt
        ts1(it)=w3d(i,j,it)
        enddo
        call normal(ts1,nt)
        do it=1,nt
        w3ds(i,j,it)=ts1(it)
        enddo
        endif
c
        if(abs(w3d2(i,j,1)).lt.500) then
        do it=1,nt
        ts2(it)=w3d2(i,j,it)
        enddo
        call normal(ts2,nt)
        do it=1,nt
        w3ds2(i,j,it)=ts2(it)
        enddo
        endif
c
        if(abs(w3d3(i,j,1)).lt.500) then
        do it=1,nt
        ts3(it)=w3d3(i,j,it)
        enddo
        call normal(ts3,nt)
        do it=1,nt
        w3ds3(i,j,it)=ts3(it)
        enddo
        endif
      enddo
      enddo
c
c have eeof input data
      do it=1,nt
      ig=0
      do i=is,ie
      do j=js,je
        if(abs(w3ds(i,j,it)).lt.500) then
        ig=ig+1
        aaa(ig,it)=w3ds(i,j,it)*cosr(j)
        endif
      enddo
      enddo
c
      do i=is,ie
      do j=js,je
        if(abs(w3ds2(i,j,it)).lt.500) then
        ig=ig+1
        aaa(ig,it)=w3ds2(i,j,it)*cosr(j)
        endif
      enddo
      enddo
c
      do i=is,ie
      do j=js,je
        if(abs(w3ds3(i,j,it)).lt.500) then
        ig=ig+1
        aaa(ig,it)=w3ds3(i,j,it)*cosr(j)
        endif
      enddo
      enddo
      print *, 'ngrd=',ig
      enddo
c
C EOF analysis
      call eofs(aaa,ngrd,nt,nt,eval,evec,coef,wk,id)
      call REOFS(aaa,ngrd,nt,nt,wk,id,weval,wevec,wcoef,
     &           nmod,reval,revec,rcoef,tt,rwk,rwk2)
      print *, 'eval=',eval
C
C normalize coef and have patterns
      iw=0
      do m=1,nmod
        do it=1,nt
        ts1(it)=coef(m,it)
        ts2(it)=rcoef(m,it)
        enddo
        call normal(ts1,nt)
        call normal(ts2,nt)

        do it=1,nt
        coef(m,it)=ts1(it)
        rcoef(m,it)=ts2(it)
        enddo
c
        do j=1,jmx
        do i=1,imx
        if(abs(w2d(i,j)).lt.1000) then
        do it=1,nt
        ts3(it)=w3d(i,j,it)
        enddo
        call regr_t(ts2,ts3,nt,corr(i,j),regr(i,j))
        else
        corr(i,j)= -9.99E+8
        regr(i,j)= -9.99E+8
        endif
c
        if(abs(w2d2(i,j)).lt.1000) then
        do it=1,nt
        ts4(it)=w3d2(i,j,it)
        enddo
        call regr_t(ts2,ts4,nt,corr2(i,j),regr2(i,j))
        else
        corr2(i,j)= -9.99E+8
        regr2(i,j)= -9.99E+8
        endif
c
        if(abs(w2d3(i,j)).lt.1000) then
        do it=1,nt
        ts5(it)=w3d3(i,j,it)
        enddo
        call regr_t(ts2,ts5,nt,corr3(i,j),regr3(i,j))
        else
        corr3(i,j)= -9.99E+8
        regr3(i,j)= -9.99E+8
        endif


        enddo
        enddo

        iw=iw+1
        write(40,rec=iw) corr
        write(41,rec=iw) corr2
        write(42,rec=iw) corr3
        iw=iw+1
        write(40,rec=iw) regr
        write(41,rec=iw) regr2
        write(42,rec=iw) regr3
      enddo
C
C write out grid SST and obs nino34
      do it=1,nt

        do i=1,nmod
          out(i)=rcoef(i,it)
        enddo
          out(nfld)=on34(it)

        write(30,rec=it) out
      enddo

      stop
      end

      subroutine normal(x,n)
      dimension x(n)
      avg=0
      do i=1,n
        avg=avg+x(i)/float(n)
      enddo
      var=0
      do i=1,n
        var=var+(x(i)-avg)*(x(i)-avg)/float(n)
      enddo
      std=sqrt(var)
      do i=1,n
        x(i)=(x(i)-avg)/std
      enddo
      return
      end
C
      SUBROUTINE regr_t(f1,f2,ltime,cor,reg)

      real f1(ltime),f2(ltime)

      cor=0.
      sd1=0.
      sd2=0.

      do it=1,ltime
         cor=cor+f1(it)*f2(it)/float(ltime)
         sd1=sd1+f1(it)*f1(it)/float(ltime)
         sd2=sd2+f2(it)*f2(it)/float(ltime)
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      reg=cor/(sd1)
      cor=cor/(sd1*sd2)

      return
      end
EOF
#
\rm fort.*
 gfortran -o input.x reof.s.f input.f
 ln -s $datadir1/obs.nino34.$tp.${icmonw}_ic.1982-cur.ld1-$nlead.gr fort.10
 ln -s /cpc/home/wd52pp/project/nn/nmme/data_proc/land.2.5x2.5.gr   fort.11
 ln -s $datadir2/$model.$var1.$tp.${icmonw}_ic.1982-2020.ld1-$nlead.esm.anom.$clim.gr fort.20
 ln -s $datadir3/obs.$var2.$oicmonw.1979-2020.anom.gr           fort.21
 ln -s $datadir3/obs.$var3.$oicmonw.1979-2020.anom.gr           fort.22
 ln -s input.gr                                               fort.30
 ln -s eeof.$var1.gr                                                  fort.40
 ln -s eeof.$var2.gr                                                  fort.41
 ln -s eeof.$var3.gr                                                  fort.42
#
 input.x
#
##===================================
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
'define rmsop=sqrt(ave((o-p.3*oo/pp)*(o-p.3*oo/pp),t=1,t=$nyr))'
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

mv acrms.$nlead $datadir2/skill.$tool.$varn.${var1}_${var2}_${var3}_2_nino34.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.nmod$nmod.eeof.gr

cat>$datadir2/skill.$tool.$varn.${var1}_${var2}_${var3}_2_nino34.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.nmod$nmod.eeof.ctl<<EOF
dset ^skill.$tool.$varn.${var1}_${var2}_${var3}_2_nino34.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.nmod$nmod.eeof.gr
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
done  # for nmod
