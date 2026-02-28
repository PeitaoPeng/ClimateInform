#!/bin/sh

set -eaux

#=========================================================
# ANN down scaling for NMME forecasted USAPI T&P 
#=========================================================
lcdir=/cpc/home/wd52pp/project/NA_prd/src
tmp=/cpc/consistency/tmp_ann
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi

datadir1=/cpc/consistency/NA_prd/obs
datadir2=/cpc/consistency/NA_prd/nmme
datadir3=/cpc/consistency/NA_prd/skill
#
cd $tmp
# 
for curmo in 11; do
#for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
#
curyr=2020
model=NMME
tool=mlr
varn=1V
varm=prate
varo=prate
#varm=tmp2m
#varo=tmp2m

lastyr=`expr $curyr - 1`
nextyr=`expr $curyr + 1`
nyr=`expr $lastyr - 1981`  # hcst yr #
nyrp1=`expr $nyr + 1`      # hcst_yr + cur_yr

tgtyr=$curyr
if [ $curmo = 12 ]; then tgtyr=$nextyr; fi
#
ngrd=2525
nmod=15
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

if [ $tp = 'mon' ]; then nlead=$nleadmon; fi
if [ $tp = 'ss' ];  then nlead=$nleadss; fi

tlongobs=`expr $nyrp1 \* $nlead`  # 

ld=1
while  [ $ld -le $nlead ]
do
#
# correction for dynamic model fcst
#
cat > parm.h << eof
       parameter(nt=$nyr)
       parameter(imx=$imx,jmx=$jmx)
       parameter(is=191,ie=300,js=111,je=161) 
       parameter(nmod=$nmod,nfld=$nfld)
       parameter(ngrd=$ngrd)
       parameter(nld=$nlead)
       parameter(ld=$ld)
       parameter(undef=-9.99E+8)
       parameter(ridge=0.05,del=0.05)
eof
#
cat > correct.f << EOF
      program input_data
      include "parm.h"
      dimension ots(nt)
      dimension out(nfld)
      dimension w2d(imx,jmx),w2d2(imx,jmx)
      dimension w3d(imx,jmx,nt),w3d2(imx,jmx,nt)
      dimension w3d3(imx,jmx,nt-1)
      dimension land(imx,jmx)
C
      dimension ts1(nt),ts2(nt),tso(nt)
      dimension ts3(nt-1),ts4(nt-1)
      dimension aaa(ngrd,nt),wk(nt,ngrd)
      dimension aaa2(ngrd,nt-1),wk2(nt-1,ngrd)
      dimension xlat(jmx),coslat(jmx),cosr(jmx)
      dimension eval(nt),evec(ngrd,nt),coef(nt,nt)
      dimension eval2(nt-1),evec2(ngrd,nt-1),coef2(nt-1,nt-1)
      real weval(nt),wevec(ngrd,nt),wcoef(nt,nt)
      real weval2(nt-1),wevec2(ngrd,nt-1),wcoef2(nt-1,nt-1)
      real reval(nmod),revec(ngrd,nmod),rcoef(nmod,nt)
      real rcoef2(nmod,nt-1)
      real tt(nmod,nmod),rwk(ngrd),rwk2(ngrd,nmod)
      real corr(imx,jmx),regr(imx,jmx),regro(imx,jmx,nmod)
      real rpcm(nmod,nt),rpcm2(nmod,nt-1),rpcmtgt(nmod)
      real rpco(nmod,nt-1),rpcf(nmod)
      real prd(imx,jmx,nt),wt(nmod)
      real corm(imx,jmx),rmsm(imx,jmx)
      real corp(imx,jmx),rmsp(imx,jmx)
C
      open(unit=10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)

      open(unit=30,form='unformatted',access='direct',recl=4*imx*jmx)
c*************************************************
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-90+(j-1)*1.
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use
        cosr(j)=sqrt(coslat(j))  !for EOF use
      enddo
C
C read obs & model data

      irm=ld
      iro=nld+ld
      do it=1,nt

        read(10,rec=iro) w2d        !obs data
        read(20,rec=irm) w2d2       !model hcst sst

        do i=1,imx
        do j=1,jmx
           w3d(i,j,it)=w2d(i,j)
           w3d2(i,j,it)=w2d2(i,j)
        enddo
        enddo

        print *, 'iro=',iro
        iro=iro+nld
        irm=irm+nld
      enddo ! it loop
c
      read(11,rec=1) land
c
c EOF analysis for model data
c
C select grid data
      do it=1,nt
      ig=0
      do i=is,ie
      do j=js,je
        if(land(i,j).gt.0) then
        ig=ig+1
        aaa(ig,it)=cosr(j)*w3d2(i,j,it)
        endif
      enddo
      enddo
      print *, 'ngrd=',ig
      enddo
C EOF analysis
      call eofs(aaa,ngrd,nt,nt,eval,evec,coef,wk,id)
      call REOFS(aaa,ngrd,nt,nt,wk,id,weval,wevec,wcoef,
     &           nmod,reval,revec,rcoef,tt,rwk,rwk2)
      print *, 'eval=',eval
C
C normalize rcoef and have patterns
      iw=0
      do m=1,nmod
        do it=1,nt
        ts1(it)=rcoef(m,it)
        enddo
        call normal(ts1,nt)

        do it=1,nt
        rpcm(m,it)=ts1(it)
        enddo
c
        do j=1,jmx
        do i=1,imx

        if(land(i,j).gt.0) then

        do it=1,nt
        ts2(it)=w3d2(i,j,it)
        enddo

        call regr_t(ts1,ts2,nt,corr(i,j),regr(i,j))
        else

        corr(i,j)=undef
        regr(i,j)=undef

        endif

        enddo
        enddo

        iw=iw+1
c       write(40,rec=iw) corr
        iw=iw+1
c       write(40,rec=iw) regr
      enddo
c
c CV-1 for RPC forecast
C
      call setzero_3d(prd,imx,jmx,nt)

      DO itgt=1,nt  !loop over target yr

c select rpcm of tgtyr
        do m=1,nmod
          rpcmtgt(m)=rpcm(m,itgt)
        enddo

c select data of non-tgtyr

        it = 0
        DO iy = 1, nt

        IF(iy == itgt)  PRINT *,'iy=',iy

        IF(iy /= itgt)  then

        it = it + 1

C rpc of model
        do m=1,nmod
          rpcm2(m,it)=rpcm(m,iy)
        enddo

C grid data of obs
        do i=1,imx
        do j=1,jmx
          w3d3(i,j,it)=w3d(i,j,iy)
        enddo
        enddo

        ig=0
        do i=is,ie
        do j=js,je
        if(land(i,j).gt.0) then
        ig=ig+1
        aaa2(ig,it)=cosr(j)*w3d(i,j,iy)
        endif
        enddo
        enddo
        print *, 'ngrd=',ig
        ENDIF
        ENDDO  ! iy loop
c
C EOF analysis for OBS(nt-1)
      call eofs(aaa2,ngrd,nt-1,nt-1,eval2,evec2,coef2,wk2,id)
      call REOFS(aaa2,ngrd,nt-1,nt-1,wk2,id,weval2,wevec2,wcoef2,
     &           nmod,reval,revec,rcoef2,tt,rwk,rwk2)
      print *, 'obs eval=',eval2
C
C normalize rcoef2 and have patterns
      iw=0
      do m=1,nmod
        do it=1,nt-1
          ts3(it)=rcoef2(m,it)
        enddo
        call normal(ts3,nt-1)

        do it=1,nt-1
          rpco(m,it)=ts3(it)
        enddo

        do j=1,jmx
        do i=1,imx

        if(land(i,j).gt.0) then

        do it=1,nt-1
          ts4(it)=w3d3(i,j,it)
        enddo
        call normal(ts4,nt-1)

        call regr_t(ts3,ts4,nt-1,corr(i,j),regro(i,j,m))
        else

        corr(i,j)=undef
        regro(i,j,m)=undef

        endif

        enddo
        enddo
      enddo ! m loop
c
c forecast rpc for itgt 
      DO m=1,nmod

        do it=1,nt-1
        ts3(it)=rpco(m,it)
        enddo
        
        rdg=ridge
        go to 212
 211    continue
        rdg=rdg+del
 212    continue

        call get_mlr_wt(ts3,rpcm2,wt,nmod,nt-1,rdg)

        wts=0
        do k=1,nmod
        wts=wts+wt(k)*wt(k)
        enddo
c       write(6,*) 'target yr=',itgt,'wts=',wts
        if(wts.gt.0.5) go to 211

        rpcf(m)=0
        do n=1,nmod
          rpcf(m)=rpcf(m)+wt(n)*rpcmtgt(n)
        enddo
      ENDDO !m loop
     
c forecasted var on grids
      do i=1,imx
      do j=1,jmx

      if(land(i,j).gt.0) then
        do m=1,nmod
          prd(i,j,itgt)=prd(i,j,itgt)+rpcf(m)*regro(i,j,m)
        enddo
      else
          prd(i,j,itgt)=undef
      endif

      enddo
      enddo

      ENDDO  ! itgt loop
c
C skill calculation
      do i=1,imx
      do j=1,jmx
      if(land(i,j).gt.0) then
        do it=1,nt
          tso(it)=w3d(i,j,it)
          ts1(it)=w3d2(i,j,it)
          ts2(it)=prd(i,j,it)
        enddo
        call acrms_t(ts1,tso,corm(i,j),rmsm(i,j),nt)
        call acrms_t(ts2,tso,corp(i,j),rmsp(i,j),nt)
      else
        corm(i,j)=undef
        rmsm(i,j)=undef
        corp(i,j)=undef
        rmsp(i,j)=undef
      endif
      enddo
      enddo

      iw=1
      write(30,rec=iw) corm
      iw=iw+1 
      write(30,rec=iw) rmsm
      iw=iw+1 
      write(30,rec=iw) corp
      iw=iw+1 
      write(30,rec=iw) rmsp

      STOP
      END

      subroutine acrms_t(f,o,ac,rms,n)
      dimension f(n),o(n)

      oo=0.
      ff=0.
      of=0.
      rms=0
      do i=1,n
        oo=oo+o(i)*o(i)
        ff=ff+f(i)*f(i)
        of=of+f(i)*o(i)
        rms=rms+(f(i)-o(i))*(f(i)-o(i))
      enddo
      tt=float(n)
      stdo=sqrt(oo/tt)
      stdf=sqrt(ff/tt)
      of=of/tt
      ac=of/(stdo*stdf)
      rms=sqrt(rms/tt)
c
      return
      end

      SUBROUTINE setzero_3d(fld,n,m,k)
      real fld(n,m,k)
      do i=1,n
      do j=1,m
      do l=1,k
         fld(i,j,l)=0.0
      enddo
      enddo
      enddo
      return
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
cp $lcdir/reof.s.f reof.s.f
cp $lcdir/mlr.s.f  mlr.s.f
#
\rm fort.*
 gfortran -o prd.x reof.s.f  mlr.s.f correct.f
 ln -s $datadir1/obs.$varo.ss.${icmonw}_ic.1981-2020.ld1-7.anom.gr fort.10
 ln -s $datadir1/land1x1mask.gr                                    fort.11
 ln -s $datadir2/$model.$varm.$tp.${icmonw}_ic.1982-2020.ld1-$nlead.esm.anom.gr fort.20
#
 ln -s acrms.$ld                           fort.30
 prd.x
#
ld=$(( ld+1 ))
done  # for ld

#cat skill together

mv acrms.1 skill.1
ld=2
while  [ $ld -le $nlead ]
do
ldm=$((ld-1))

cat skill.$ldm  acrms.$ld > skill.$ld

\rm skill.$ldm

ld=$(( ld+1 ))
done  # for ld
#
mv skill.$nlead $datadir3/skill.$tool.NMME_${varm}_2_$varo.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.gr

cat>$datadir3/skill.$tool.NMME_${varm}_2_$varo.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.ctl<<EOF
dset ^skill.$tool.NMME_${varm}_2_$varo.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.gr
undef -9.99e+8
*
TITLE model
*
XDEF $imx LINEAR    0.  1.
YDEF $jmx LINEAR  -90.  1.
zdef 1 linear 1 1
tdef $nlead linear jan1982 1yr
vars  4
accm 0 99 acc of model
rmsm 0 99 rms of model
accp 0 99 acc of corrrected
rmsp 0 99 rms of corrected
endvars
#
EOF
done  # for tp
done  # for curmo
