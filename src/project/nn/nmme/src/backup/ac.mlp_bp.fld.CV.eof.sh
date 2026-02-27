#!/bin/sh

set -eaux

##=====================================
## correct field fcst with field data (CV)
##=====================================
lcdir=/cpc/home/wd52pp/project/nn/nmme/src
datadir=/cpc/consistency/nn/nmme
tmp=/cpc/home/wd52pp/tmp/test

if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
cd $tmp
#
icmon=may
model=NMME
imx=144
jmx=73
nt_tot=38 # N(year)
#
cat > parm.h << eof
      parameter(nt=$nt_tot)
      parameter(imx=$imx,jmx=$jmx)
      parameter(is=49,ie=121,js=29,je=45)
      parameter(undef=-9.99e+8)
eof
#
cat>ac.f<<EOF
      program correlation
      include "parm.h"
C===========================================================
      real w2dm(imx,jmx),w2do(imx,jmx),w2dc(imx,jmx)
      real w3dm(imx,jmx,nt),w3do(imx,jmx,nt),w3dc(imx,jmx,nt)
      real corrmo(imx,jmx),corrmc(imx,jmx),corroc(imx,jmx)
      real rmsmo(imx,jmx),rmsmc(imx,jmx),rmsoc(imx,jmx)
      real wm(nt),wo(nt),wc(nt)
      real xlat(jmx),cosl(jmx),cosr(jmx)
c
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx)
c
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=30,form='unformatted',access='direct',recl=4)
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-90+(j-1)*2.5
        cosl(j)=cos(xlat(j)*3.14159/180) 
        cosr(j)=sqrt(cosl(j)) 
      enddo
c     print *, 'cosl=',cosl

      do it=1,nt
        read(11,rec=it) w2dm
        read(12,rec=it) w2do
        read(13,rec=it) w2dc
        
        do i=1,imx
        do j=1,jmx
          w3dm(i,j,it)=w2dm(i,j)
          w3do(i,j,it)=w2do(i,j)
          w3dc(i,j,it)=w2dc(i,j)
        enddo
        enddo
      enddo
c
      do i=1,imx
      do j=1,jmx

        IF(abs(w2dc(i,j)).gt.1000) then

        corrmo(i,j)=undef
        corroc(i,j)=undef
        corrmc(i,j)=undef

        ELSE
c
        do it=1,nt
          wm(it)=w3dm(i,j,it)
          wo(it)=w3do(i,j,it)
          wc(it)=w3dc(i,j,it)
        enddo
        call corr_t(wm,wo,nt,corrmo(i,j),rmsmo(i,j))
        call corr_t(wo,wc,nt,corroc(i,j),rmsoc(i,j))
        call corr_t(wm,wc,nt,corrmc(i,j),rmsmc(i,j))
        ENDIF

      enddo
      enddo

      write(20,rec=1) corrmo
      write(20,rec=2) rmsmo
      write(20,rec=3) corroc
      write(20,rec=4) rmsoc
      write(20,rec=5) corrmc
      write(20,rec=6) rmsmc

C spatial corr
      iw=0
      do it=1,nt
        do i=1,imx
        do j=1,jmx
          w2dm(i,j)=w3dm(i,j,it)
          w2do(i,j)=w3do(i,j,it)
          w2dc(i,j)=w3dc(i,j,it)
        enddo
        enddo
        call corr_s(w2dm,w2do,imx,jmx,is,ie,js,je,cosl,cmo,rmo)
        call corr_s(w2do,w2dc,imx,jmx,is,ie,js,je,cosl,coc,roc)
        call corr_s(w2dm,w2dc,imx,jmx,is,ie,js,je,cosl,cmc,rmc)

        iw=iw+1
        write(30,rec=iw) cmo
        iw=iw+1
        write(30,rec=iw) rmo
        iw=iw+1
        write(30,rec=iw) coc
        iw=iw+1
        write(30,rec=iw) roc
        iw=iw+1
        write(30,rec=iw) cmc
        iw=iw+1
        write(30,rec=iw) rmc
      enddo

      stop
      end
c
      SUBROUTINE corr_t(f1,f2,ltime,cor,rms)

      real f1(ltime),f2(ltime)

      cor=0.
      sd1=0.
      sd2=0.
      rms=0.

      do it=1,ltime
         cor=cor+f1(it)*f2(it)/float(ltime)
         sd1=sd1+f1(it)*f1(it)/float(ltime)
         sd2=sd2+f2(it)*f2(it)/float(ltime)
         rms=rms+(f1(it)-f2(it))**2
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      cor=cor/(sd1*sd2)
      rms=sqrt(rms/float(ltime))

      return
      end

      SUBROUTINE corr_s(f1,f2,imx,jmx,is,ie,js,je,cosl,cor,rms)

      real f1(imx,jmx),f2(imx,jmx)
      real cosl(jmx)

      cor=0.
      sd1=0.
      sd2=0.
      rms=0.
      grd=0

      do i=is,ie
      do j=js,je
        if(abs(f1(i,j)).lt.1000.and.abs(f2(i,j)).lt.1000) then
         grd=grd+cosl(j)
         cor=cor+cosl(j)*f1(i,j)*f2(i,j)
         sd1=sd1+cosl(j)*f1(i,j)*f1(i,j)
         sd2=sd2+cosl(j)*f2(i,j)*f2(i,j)
         rms=rms+cosl(j)*(f1(i,j)-f2(i,j))**2
        endif
      enddo
      enddo

      sd1=sqrt(sd1/grd)
      sd2=sqrt(sd2/grd)
      cor=cor/grd
      cor=cor/(sd1*sd2)
      rms=sqrt(rms/grd)

      return
      end
      
EOF
      
#gfortran -g -fbacktrace -o ac.x ac.f
gfortran -o ac.x ac.f

#if [ -d fort.10 ] ; then
/bin/rm $tmp/fort.*
#fi

ln -s $datadir/${model}_sst.${icmon}_ic.1982-2019.djf.bi  fort.11
ln -s $datadir/obs_sst.1982-2019.djf.bi               fort.12
ln -s $datadir/mlp.sst_eof.${icmon}_ic.1982-2019.djf.bi   fort.13
#
ln -s $datadir/ac_t.mlp.sst_eof.${icmon}_ic.1982-2019.djf.bi   fort.20
ln -s $datadir/ac_s.mlp.sst_eof.${icmon}_ic.1982-2019.djf.bi   fort.30

#excute program
ac.x
#
cat>$datadir/ac_t.mlp.sst_eof.${icmon}_ic.1982-2019.djf.ctl<<EOF
dset ^ac_t.mlp.sst_eof.${icmon}_ic.1982-2019.djf.bi
undef -9.99E+08
title EXP1
XDEF  $imx LINEAR    0  2.5
YDEF  $jmx LINEAR  -90  2.5
zdef  1 linear 1 1
tdef  ${nt_tot} linear jan1983 1yr
vars  6
cmo  0 99 cor model vs obs
rmo  0 99 rms model vs obs
coc  0 99 cor obs vs mlp
roc  0 99 rms obs vs mlp
cmc  0 99 cor model vs mlp
rmc  0 99 rms model vs mlp
endvars
#
EOF
#
cat>$datadir/ac_s.mlp.sst_eof.${icmon}_ic.1982-2019.djf.ctl<<EOF
dset ^ac_s.mlp.sst_eof.${icmon}_ic.1982-2019.djf.bi
undef -9.99E+08
title EXP1
XDEF  1 LINEAR    0  2.5
YDEF  1 LINEAR  -90  2.5
zdef  1 linear 1 1
tdef  ${nt_tot} linear jan1983 1yr
vars  6
cmo  0 99 cor model vs obs
rmo  0 99 rms model vs obs
coc  0 99 cor obs vs mlp
roc  0 99 rms obs vs mlp
cmc  0 99 cor model vs mlp
rmc  0 99 rms model vs mlp
endvars
#
EOF
