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
for island in Chuuk Guam Kwajalein PagoPago Pohnpei Yap; do
#for island in Guam; do

#for curmo in 12; do
for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
#
curyr=2019
model=NMME
tool=NMME
varm=prate
varo=prec

lastyr=`expr $curyr - 1`
nextyr=`expr $curyr + 1`
nyr=`expr $lastyr - 1981`  # hcst yr #
nyrp1=`expr $nyr + 1`      # hcst_yr + cur_yr

tgtyr=$curyr
if [ $curmo = 12 ]; then tgtyr=$nextyr; fi
#
nleadmon=7
nleadss=7
imx=360
jmx=181
#
# give lon&lat closest to island
#
if [ $island = "Chuuk" ];     then ix=153;jy=98;fi
if [ $island = "Yap" ];       then ix=139;jy=100;fi
if [ $island = "Pohnpei" ];   then ix=159;jy=98;fi
if [ $island = "Kwajalein" ]; then ix=169;jy=100;fi
if [ $island = "Guam" ];      then ix=146;jy=104;fi
if [ $island = "Pago_Pago" ]; then ix=190;jy=77; fi
#
# have input data to MLR package =======================================
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
#===============================================
# input data and ac_rms_hss skil
#===============================================
outfile=skill.$ld
cat > parm.h << eof
       parameter(nvy=$nyr)
       parameter(imx=$imx,jmx=$jmx)
       parameter(ix=$ix,jy=$jy) 
c      parameter(is=152,ie=153,js=98,je=99,ix=153,jy=98)    !Chuuk
c      parameter(is=139,ie=140,js=100,je=101,ix=139,jy=100) !Yap
c      parameter(is=159,ie=160,js=98,je=99,ix=159,jy=98)    !Pohnpei
c      parameter(is=168,ie=169,js=99,je=100,ix=169,jy=100)  !Kwajalein
c      parameter(is=145,ie=146,js=104,je=105,ix=146,jy=104) !Guam
c      parameter(is=190,ie=191,js=76,je=77,ix=190,jy=77)    !Pago_Pago
       parameter(nld=$nlead)
       parameter(ld=$ld)
       parameter(undef=-9.99E+8)
eof
#
cat > skill.f << EOF
      program skill_calculation
      include "parm.h"
      dimension w2d(imx,jmx)
      real*4 obs(nvy),f1d(nvy)
      real*4 rdo(nvy),rdm(nvy)
      dimension mo(nvy),mf(nvy)
C
      open(unit=10,form='unformatted',access='direct',recl=4)
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)
C
      open(30,
     &file='$outfile',
     &access='direct',form='unformatted',recl=4)
c*************************************************
C
c read in f&o data

      irm=ld
      iro=nld+ld
      do it=1,nvy

        read(10,rec=iro) obs(it)   !obs island data
        read(20,rec=irm) w2d       !model hcst sst

           f1d(it)=w2d(ix,jy)

        print *, 'iro=',iro
        iro=iro+nld
        irm=irm+nld
      enddo ! it loop
c
      call acrms_t(f1d,obs,acc,rms,nvy)

      call normal(obs,nvy)

      call normal(f1d,nvy)

      bl=-0.43
      bh= 0.43

c convert to categorical numbe -1 0 -1

      do iy=1,nvy

       if (f1d(iy).lt.bl) mf(iy)=-1
       if (f1d(iy).gt.bh) mf(iy)= 1
       if (f1d(iy).le.bh.and.f1d(iy).ge.bl)
     & mf(iy)=0

       if (obs(iy).lt.bl) mo(iy)=-1
       if (obs(iy).gt.bh) mo(iy)= 1
       if (obs(iy).le.bh.and.obs(iy).ge.bl)
     & mo(iy)=0

      enddo

c have hss
      call hss_t(mf,mo,hss,nvy)

      iw=iw+1
      write(30,rec=iw) hss
      iw=iw+1
      write(30,rec=iw) acc
      iw=iw+1
      write(30,rec=iw) rms

      print *,"acc=",acc
      print *,"rms=",rms
      print *,"hss=",hss

c     print *,"obs=",obs

      STOP
      END
c
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

      subroutine hss_t(mw1,mw2,hs,n)
      dimension mw1(n),mw2(n)

      h=0.
      do i=1,n
        if (mw1(i).eq.mw2(i)) h=h+1
      enddo
      tot=float(n)
      hs=100.*(h-tot/3.)/(tot-tot/3.)
      return
      end
c
      subroutine acrms_t(f,o,ac,rms,n)
      dimension f(n),o(n)

      rms=0
      oo=0.
      ff=0.
      fo=0.
      do i=1,n
        oo=oo+o(i)*o(i)
        ff=ff+f(i)*f(i)
        fo=fo+f(i)*o(i)
        rms=rms+(f(i)-o(i))*(f(i)-o(i))
      enddo
      tot=float(n)
      stdo=sqrt(oo)
      stdf=sqrt(ff)
      ac=fo/(stdo*stdf)
      rms=sqrt(rms/tot)
c
      return
      end
c
      SUBROUTINE hpsort(n,n2,ra,rb)
      INTEGER n,n2
      REAL ra(n),rb(n)
      INTEGER i,ir,j,l
      REAL rra
      if (n2.lt.2) return
      l=n2/2+1
      ir=n2
10    continue
        if(l.gt.1)then
          l=l-1
          rra=ra(l)
          rrb=rb(l)
        else
          rra=ra(ir)
          rrb=rb(ir)
          ra(ir)=ra(1)
          rb(ir)=rb(1)
          ir=ir-1
          if(ir.eq.1)then
            ra(1)=rra
            rb(1)=rrb
            return
          endif
        endif
        i=l
        j=l+l
20      if(j.le.ir)then
          if(j.lt.ir)then
            if(ra(j).lt.ra(j+1))j=j+1
          endif
          if(rra.lt.ra(j))then
            ra(i)=ra(j)
            rb(i)=rb(j)
            i=j
            j=j+j
          else
            j=ir+1
          endif
        goto 20
        endif
        ra(i)=rra
        rb(i)=rrb
      goto 10
      END
c
EOF
#
\rm fort.*
 gfortran -o skill.x skill.f
echo "done compiling"
 ln -s $datadir1/$island.$varo.$tp.${icmonw}_ic.1981-2018.ld1-$nlead.anom.gr fort.10
 ln -s $datadir2/$model.$varm.$tp.${icmonw}_ic.1982-2020.ld1-$nlead.esm.anom.gr fort.20
 skill.x
#
ld=$(( ld+1 ))
done  # for ld

#cat skill together

cp skill.1 sk.$curmo # ld-1 for later cat
cp skill.1 hss.1
ld=2
while  [ $ld -le $nlead ]
do
ldm=$((ld-1))

cat hss.$ldm  skill.$ld > hss.$ld

\rm hss.$ldm
\rm skill.$ldm

ld=$(( ld+1 ))
done  # for ld
\rm skill.$nlead
#
mv hss.$nlead $datadir3/skill.$tool.$island.${varm}.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.gr

cat>$datadir3/skill.$tool.$island.${varm}.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.ctl<<EOF
dset ^skill.$tool.$island.${varm}.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nlead linear ${tmons}1982 1mon
vars 3
hss  1 99 hss of nmme
acc  1 99 acc of nmme
rms  1 99 rms of nmme
ENDVARS
EOF

done  # for tp
done  # for curmo
#
cat sk.12 sk.01 sk.02 sk.03 sk.04 sk.05 sk.06 sk.07 sk.08 sk.09 sk.10 sk.11 > sk.tot 
mv sk.tot $datadir3/skill.$tool.$island.${varm}.$tp.1982-$lastyr.ld-1.gr
\rm sk.*
#
cat>$datadir3/skill.$tool.$island.${varm}.$tp.1982-$lastyr.ld-1.ctl<<EOF
dset ^skill.$tool.$island.${varm}.$tp.1982-$lastyr.ld-1.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef 12 linear jan1982 1mon
vars 3
hss  1 99 hss of nmme
acc  1 99 acc of nmme
rms  1 99 rms of nmme
ENDVARS
EOF
#
done  # for island
