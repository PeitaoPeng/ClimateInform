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
      real w2dm(imx,jmx),w2do(imx,jmx),w2dc(imx,jmx)
      real w3dm(imx,jmx,nt),w3do(imx,jmx,nt),w3dc(imx,jmx,nt)
      real corroo(imx,jmx),corrom(imx,jmx),corroc(imx,jmx)
      real corrmo(imx,jmx),corrmm(imx,jmx),corrmc(imx,jmx)
      real corrco(imx,jmx),corrcm(imx,jmx),corrcc(imx,jmx)
      real wm(nt),wo(nt),wc(nt)
      real xm(nt),xo(nt),xc(nt)
c
      open(unit=10,form='unformatted',access='direct',recl=4)
      open(unit=11,form='unformatted',access='direct',recl=4)
      open(unit=12,form='unformatted',access='direct',recl=4)

      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=14,form='unformatted',access='direct',recl=4*imx*jmx)
c
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)
C
C read in nino indces and pick up nino34
      do it=1,nt
        read(10,rec=it) xo(it)
        read(11,rec=it) xm(it)
        read(12,rec=it) xc(it)
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

        corroo(i,j)=undef
        corrom(i,j)=undef
        corrmo(i,j)=undef
        corrmm(i,j)=undef
        corrco(i,j)=undef
        corrcm(i,j)=undef

        ELSE
c
        do it=1,nt
          wm(it)=w3dm(i,j,it)
          wo(it)=w3do(i,j,it)
        enddo

        call corr_t(xo,wo,nt,corroo(i,j))
        call corr_t(xo,wm,nt,corrom(i,j))

        call corr_t(xm,wo,nt,corrmo(i,j))
        call corr_t(xm,wm,nt,corrmm(i,j))

        call corr_t(xc,wo,nt,corrco(i,j))
        call corr_t(xc,wm,nt,corrcm(i,j))
        ENDIF

      enddo
      enddo

      write(20,rec=1) corroo
      write(20,rec=2) corrom

      write(20,rec=3) corrmo
      write(20,rec=4) corrmm

      write(20,rec=5) corrco
      write(20,rec=6) corrcm
      stop
      end
c
      SUBROUTINE corr_t(f1,f2,ltime,cor)

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
      cor=cor/(sd1*sd2)

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
ln -s $datadir2/mlp.djf.grdsst_2_n34.${icmon}_ic.whole.$clim.bi    fort.12

ln -s $datadiro/oisst.1982-cur.$tgtss.anom.gr               fort.13
ln -s $datadir2/CFSv2.sst.${icmon}_ic.1982-2020.$tgtss.$clim.gr  fort.14
#
ln -s $datadir2/ac_t.nino34.vs.sst.$tgtss.$clim.bi    fort.20

#excute program
ac.x
#
cat>$datadir2/ac_t.nino34.vs.sst.$tgtss.$clim.ctl<<EOF
dset ^ac_t.nino34.vs.sst.$tgtss.$clim.bi
undef -9.99E+08
title EXP1
XDEF  $imx LINEAR    0  2.5
YDEF  $jmx LINEAR  -90  2.5
zdef  1 linear 1 1
tdef  ${nt_tot} linear jan1983 1yr
vars  6
oo  0 99 o n34 vs o sst
om  0 99 o n34 vs m sst
mo  0 99 m n34 vs o sst
mm  0 99 m n34 vs m sst
co  0 99 c n34 vs o sst
cm  0 99 c n34 vs m sst
endvars
#
EOF
