#!/bin/sh

set -eaux

##=====================================
## correct field fcst with field data (CV)
##=====================================
lcdir=/cpc/home/wd52pp/project/nn/nmme/src
datadir=/cpc/consistency/nn/nmme
datadir2=/cpc/home/wd52pp/data/nn/nmme
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
      real corroo(imx,jmx),corrom(imx,jmx),corroc(imx,jmx)
      real corrmo(imx,jmx),corrmm(imx,jmx),corrmc(imx,jmx)
      real corrco(imx,jmx),corrcm(imx,jmx),corrcc(imx,jmx)
      real wm(nt),wo(nt),wc(nt)
      real xin(5),xm(nt),xo(nt),xc(nt)
c
      open(unit=11,form='unformatted',access='direct',recl=4*5)
      open(unit=12,form='unformatted',access='direct',recl=4)

      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=14,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=15,form='unformatted',access='direct',recl=4*imx*jmx)
c
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)
C
C read in nino indces and pick up nino34
      do it=1,nt
        read(11,rec=it) xin
        xm(it)=xin(4)
        xo(it)=xin(5)
        read(12,rec=it) xc(it)
      enddo
c
      do it=1,nt
        read(13,rec=it) w2dm
        read(14,rec=it) w2do
        read(15,rec=it) w2dc
        
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

        corroo(i,j)=undef
        corrom(i,j)=undef
        corroc(i,j)=undef
        corrmo(i,j)=undef
        corrmm(i,j)=undef
        corrmc(i,j)=undef
        corrco(i,j)=undef
        corrcm(i,j)=undef
        corrcc(i,j)=undef

        ELSE
c
        do it=1,nt
          wm(it)=w3dm(i,j,it)
          wo(it)=w3do(i,j,it)
          wc(it)=w3dc(i,j,it)
        enddo

        call corr_t(xo,wo,nt,corroo(i,j))
        call corr_t(xo,wm,nt,corrom(i,j))
        call corr_t(xo,wc,nt,corroc(i,j))

        call corr_t(xm,wo,nt,corrmo(i,j))
        call corr_t(xm,wm,nt,corrmm(i,j))
        call corr_t(xm,wc,nt,corrmc(i,j))

        call corr_t(xc,wo,nt,corrco(i,j))
        call corr_t(xc,wm,nt,corrcm(i,j))
        call corr_t(xc,wc,nt,corrcc(i,j))
        ENDIF

      enddo
      enddo

      write(20,rec=1) corroo
      write(20,rec=2) corrom
      write(20,rec=3) corroc

      write(20,rec=4) corrmo
      write(20,rec=5) corrmm
      write(20,rec=6) corrmc

      write(20,rec=7) corrco
      write(20,rec=8) corrcm
      write(20,rec=9) corrcc
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

ln -s $datadir2/input_n1_4.may_ic.1982-2019.djf.gr  fort.11
ln -s $datadir2/mlp.djf.grdsst_2_n34.may_ic.bi  fort.12

ln -s $datadir/${model}_sst.${icmon}_ic.1982-2019.djf.bi  fort.13
ln -s $datadir/obs_sst.1982-2019.djf.bi               fort.14
ln -s $datadir/mlp.sst.${icmon}_ic.1982-2019.djf.bi   fort.15
#
ln -s $datadir2/ac_t.mlp_bp.CV.grdsst_2_n34.bi    fort.20

#excute program
ac.x
#
cat>$datadir2/ac_t.mlp_bp.CV.grdsst_2_n34.ctl<<EOF
dset ^ac_t.mlp_bp.CV.grdsst_2_n34.bi
undef -9.99E+08
title EXP1
XDEF  $imx LINEAR    0  2.5
YDEF  $jmx LINEAR  -90  2.5
zdef  1 linear 1 1
tdef  ${nt_tot} linear jan1983 1yr
vars  9
oo  0 99 o n34 vs o sst
om  0 99 o n34 vs m sst
oc  0 99 o n34 vs c sst
mo  0 99 m n34 vs o sst
mm  0 99 m n34 vs m sst
mc  0 99 m n34 vs c sst
co  0 99 c n34 vs o sst
cm  0 99 c n34 vs m sst
cc  0 99 c n34 vs c sst
endvars
#
EOF
