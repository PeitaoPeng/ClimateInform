#!/bin/sh

set -eaux

##=====================================
## correct field fcst with field data (CV)
##=====================================
lcdir=/cpc/home/wd52pp/project/nn/cfsv2/src
datadir=/cpc/consistency/nn/cfsv2_ww
datadir2=/cpc/home/wd52pp/data/nn/cfsv2
datadiro=/cpc/consistency/nn/obs
tmp=/cpc/home/wd52pp/tmp/test

if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
cd $tmp
#
icmon=may
clim=2c
tgtss=djf
model=CFSv2
imx=144
jmx=73
nt_tot=38 # N(year)
#
cat > parm.h << eof
      parameter(nt=$nt_tot)
      parameter(imx=$imx,jmx=$jmx)
c     parameter(is=49,ie=121,js=29,je=45)
      parameter(is=1,ie=144,js=1,je=73)
      parameter(undef=-9.99e+8)
eof
#
cat>ac.f<<EOF
      program correlation
      include "parm.h"
C===========================================================
      real w2dm(imx,jmx),w2do(imx,jmx)
      real w3dm(imx,jmx,nt),w3do(imx,jmx,nt),w3d2(imx,jmx,nt)
      real corrom(imx,jmx),regrom(imx,jmx)
      real corrmm(imx,jmx),regrmm(imx,jmx)
      real corrdm(imx,jmx),regrdm(imx,jmx)
      real wm(nt),wo(nt)
      real xm(nt),xo(nt)
      real d34(nt)
c
      open(unit=10,form='unformatted',access='direct',recl=4)
      open(unit=11,form='unformatted',access='direct',recl=4)

      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=14,form='unformatted',access='direct',recl=4*imx*jmx)
c
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)
C
C read in nino indces and pick up nino34
      do it=1,nt
        read(10,rec=it) xo(it)
        read(11,rec=it) xm(it)
      enddo
      call normal(xo,nt)
      call normal(xm,nt)
c
      do it=1,nt
        d34(it)=xo(it)-xm(it)
      enddo
c
      do it=1,nt
        read(13,rec=it) w2do
        read(14,rec=it) w2dm
        
        do i=1,imx
        do j=1,jmx
          w3do(i,j,it)=w2do(i,j)
          w3dm(i,j,it)=w2dm(i,j)
        enddo
        enddo
      enddo
c
      do i=1,imx
      do j=1,jmx

        IF(abs(w2dm(i,j)).gt.1000) then

        corrmm(i,j)=undef
        regrmm(i,j)=undef

        ELSE
c
        do it=1,nt
          wm(it)=w3dm(i,j,it)
        enddo

        call corr_t(xo,wm,nt,corrom(i,j),regrom(i,j))
        call corr_t(xm,wm,nt,corrmm(i,j),regrmm(i,j))
        call corr_t(d34,wm,nt,corrdm(i,j),regrdm(i,j))

        ENDIF

      enddo
      enddo
c
      write(20,rec=1) corrom
      write(20,rec=2) regrom
      write(20,rec=3) corrmm
      write(20,rec=4) regrmm
      write(20,rec=5) corrdm
      write(20,rec=6) regrdm
c
c have residual
c
      do it=1,nt
        do i=1,imx
        do j=1,jmx
        IF(abs(w2dm(i,j)).gt.1000) then
         w3d2(i,j,it)=undef
        else
         w3d2(i,j,it)=w3dm(i,j,it)-xm(it)*regrmm(i,j)
        endif
        enddo
        enddo
      enddo
c
C on34 to rsd
c
      do i=1,imx
      do j=1,jmx

        IF(abs(w2dm(i,j)).gt.1000) then

        corrom(i,j)=undef
        regrom(i,j)=undef

        ELSE
c
        do it=1,nt
          wm(it)=w3d2(i,j,it)
        enddo

        call corr_t(xo,wm,nt,corrom(i,j),regrom(i,j))
        call corr_t(xm,wm,nt,corrmm(i,j),regrmm(i,j))
        call corr_t(d34,wm,nt,corrdm(i,j),regrdm(i,j))

        ENDIF

      enddo
      enddo
c
      write(20,rec=7) corrom
      write(20,rec=8) regrom
      write(20,rec=9) corrmm
      write(20,rec=10) regrmm
      write(20,rec=11) corrdm
      write(20,rec=12) regrdm
c     write(6,*) 'xo=',xo
c     write(6,*) 'xm=',xm

      stop
      end
c
      SUBROUTINE corr_t(f1,f2,ltime,cor,reg)

      real f1(ltime),f2(ltime)

      f12=0.
      sd1=0.
      sd2=0.

      do it=1,ltime
         f12=f12+f1(it)*f2(it)/float(ltime)
         sd1=sd1+f1(it)*f1(it)/float(ltime)
         sd2=sd2+f2(it)*f2(it)/float(ltime)
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      cor=f12/(sd1*sd2)
      reg=f12/sd1

      return
      end

      subroutine normal(x,n)
      dimension x(n)
      avg=0
      do i=1,n
c       avg=avg+x(i)/float(n)
        avg=0.
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
EOF
      
#gfortran -g -fbacktrace -o ac.x ac.f
gfortran -o ac.x ac.f

#if [ -d fort.10 ] ; then
/bin/rm $tmp/fort.*
#fi

ln -s $datadiro/oisst.nino34.1982-cur.$tgtss.gr fort.10
ln -s $datadir2/CFSv2.nino34.${icmon}_ic.1982-2020.$tgtss.$clim.gr fort.11

ln -s $datadiro/oisst.1982-cur.$tgtss.anom.gr               fort.13
ln -s $datadir2/CFSv2.sst.${icmon}_ic.1982-2020.$tgtss.$clim.gr  fort.14
#
ln -s $datadir2/ac_rsd_t.nino34.vs.sst.$tgtss.$clim.bi    fort.20

#excute program
ac.x
#
cat>$datadir2/ac_rsd_t.nino34.vs.sst.$tgtss.$clim.ctl<<EOF
dset ^ac_rsd_t.nino34.vs.sst.$tgtss.$clim.bi
undef -9.99E+08
title EXP1
XDEF  $imx LINEAR    0  2.5
YDEF  $jmx LINEAR  -90  2.5
zdef  1 linear 1 1
tdef  ${nt_tot} linear jan1983 1yr
vars  12
com  0 99 o COR(on34 vs msst)
rom  0 99 o REG(on34 vs msst)
cmm  0 99 o COR(mn34 vs msst)
rmm  0 99 o REG(mn34 vs msst)
cdm  0 99 o COR(mn34 vs msst)
rdm  0 99 o REG(mn34 vs msst)
comrsd  0 99 o COR(on34 vs rsdmsst)
romrsd  0 99 o REG(on34 vs rsdmsst)
cmmrsd  0 99 o COR(mn34 vs rsdmsst)
rmmrsd  0 99 o REG(mn34 vs rsdmsst)
cdmrsd  0 99 o COR(mn34 vs rsdmsst)
rdmrsd  0 99 o REG(mn34 vs rsdmsst)
endvars
#
EOF
