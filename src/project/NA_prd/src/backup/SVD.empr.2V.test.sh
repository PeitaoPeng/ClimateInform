#!/bin/sh

set -eaux

#=========================================================
# SVD forecast without using CV
#=========================================================
lcdir=/cpc/home/wd52pp/project/NA_prd/src
tmp=/cpc/consistency/tmp_ann
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi

datadir1=/cpc/consistency/NA_prd/obs
datadir2=/cpc/consistency/NA_prd/skill
#
cd $tmp
# 
model=svd
#
id=1 # =1 cor matrix; =0 var metrix
#
for var1 in hadoisst; do
for var2 in prec; do

for nmod in 20; do
#
var1_tp=3mon  # or 3mon
var2_tp=3mon  # or mon
#
var1_lag=3 # monthly: =1; 3mon: =3
#
nlead=1
byear=1978
nyr=42 #hcst period 1979->2020
#
imx=360
jmx=180
#ngrdv1=5745 # sst/or SST_t2m
ngrdv1=2940 # sst/or SST_t2m
ngrdv2=1690  # prec
#
#for tgtss in jfm fma mam amj mjj jja jas aso son ond ndj djf; do
 for tgtss in djf; do

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

/bin/rm fort.*
#
# correction for dynamic model fcst
#
cat > parm.h << EOF
       parameter(nt=$nyr)
       parameter(imx=$imx,jmx=$jmx)
c
       parameter(isv1=1,iev1=360,jsv1=71,jev1=111)
c      parameter(isv1=1,iev1=360,jsv1=71,jev1=161)
 
       parameter(isv2=221,iev2=300,jsv2=111,jev2=141) !1128
c
       parameter(nmod=$nmod)
       parameter(ng1=$ngrdv1,ng2=$ngrdv2)
       parameter(ld=$ld)
       parameter(id=1)
       parameter(undef=-9.99E+8)
       parameter(itgtbgn=$itgtbgn)
EOF
#
cat > svd.f << EOF
      program input_data
      include "parm.h"
      dimension w2d(imx,jmx),w2d2(imx,jmx)
      dimension wic(imx,jmx),aic(ng1),cic(nmod,nt)
      dimension w3dv1(imx,jmx,nt),w3dv2(imx,jmx,nt)
      dimension prd(imx,jmx,nt)

      dimension tso(nt),tsf(nt)
      dimension ts1(nt),ts2(nt)
      dimension ts3(nt),ts4(nt)
 
      dimension xlat(jmx),coslat(jmx),cosr(jmx)

      real aleft(ng1,nt),aright(ng2,nt)
      real a(ng1,ng2),w(ng2),u(ng1,ng2),v(ng1,ng2),rv1(ng2)
      logical matu,matv
c
      real cof1(nmod,nt),cof2(nmod,nt)
      dimension corp(imx,jmx),rmsp(imx,jmx)

      real corr11(imx,jmx,nmod),regr11(imx,jmx,nmod)
      real corr12(imx,jmx,nmod),regr12(imx,jmx,nmod)
      real corr21(imx,jmx,nmod),regr21(imx,jmx,nmod)
      real corr22(imx,jmx,nmod),regr22(imx,jmx,nmod)
      real std1(imx,jmx),std2(imx,imx)
c
      open(unit=10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)

      open(unit=30,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=40,form='unformatted',access='direct',recl=4*nt)
      open(unit=50,form='unformatted',access='direct',recl=4*imx*jmx)
c*************************************************
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-89.5+(j-1)*1.
        coslat(j)=cos(xlat(j)*3.14159/180) 
        cosr(j)=sqrt(coslat(j))
      enddo
C
C read obs & model data

      ir1=itgtbgn-ld-$var1_lag
      ir2=itgtbgn
      do it=1,$nyr

        read(10,rec=ir1) w2d
        read(20,rec=ir2) w2d2
        do i=1,imx
        do j=1,jmx
           w3dv1(i,j,it)=w2d(i,j)
           w3dv2(i,j,it)=w2d2(i,j)
        enddo
        enddo

       ir1=ir1+12
       ir2=ir2+12
      enddo !it loop

c choose cor matrix or var matrix
c
      do i=1,imx
      do j=1,jmx
        if(w3dv1(i,j,1).gt.-1000) then
        std1(i,j)=0.
        do it=1,nt
        std1(i,j)=std1(i,j)+w3dv1(i,j,it)*w3dv1(i,j,it)
        enddo
        std1(i,j)=sqrt(std1(i,j)/float(nt))
        endif
      enddo
      enddo
c
      do i=1,imx
      do j=1,jmx
        if(w3dv2(i,j,1).gt.-1000) then
        std2(i,j)=0.
        do it=1,nt
        std2(i,j)=std2(i,j)+w3dv2(i,j,it)*w3dv2(i,j,it)
        enddo
        std2(i,j)=sqrt(std2(i,j)/float(nt))
        endif
      enddo
      enddo

c
ccc feed matrix a
c
      do it=1,nt
      ngd1=0
        do i=isv1,iev1,2
        do j=jsv1,jev1,2
          if(w3dv1(i,j,1).gt.-1000) then
          ngd1=ngd1+1
          if(id.eq.1) then
          aleft(ngd1,it)=w3dv1(i,j,it)*cosr(j)/std1(i,j)
          else
          aleft(ngd1,it)=w3dv1(i,j,it)*cosr(j)
          endif
          endif
        enddo
        enddo
      ngd2=0
        do i=isv2,iev2
        do j=jsv2,jev2
          if(w3dv2(i,j,1).gt.-1000) then
          ngd2=ngd2+1
          if(id.eq.1) then
          aright(ngd2,it)=w3dv2(i,j,it)*cosr(j)/std2(i,j)
          else
          aright(ngd2,it)=w3dv2(i,j,it)*cosr(j)
          endif
          endif
        enddo
        enddo
      enddo   ! loop it
c
      write(6,*) 'ng1= ',ngd1
      write(6,*) 'ng2= ',ngd2
c
      do i=1,ng1
      do j=1,ng2

      a(i,j)=0.
      do k=1,nt
      a(i,j)=a(i,j)+aleft(i,k)*aright(j,k)/float(nt)
      enddo

      enddo
      enddo
c
cc... SVD analysis
c
      print *, 'before svdcmp'
      call svdcmp(a,ng1,ng2,ng1,ng2,w,v)

cc... write out singular value in w
      do i=1,ng1
      do j=1,ng2
        u(i,j)=a(i,j)
      enddo
      enddo
c
      do i=1,10
      write(6,*)'singular value= ',i,w(i)
      end do

c== have coef
      do m=1,nmod
c
      do it=1,nt
        cof1(m,it)=0.
        cof2(m,it)=0.
      do n=1,ng1
        cof1(m,it)=cof1(m,it)+aleft(n,it)*u(n,m)
      enddo
      do n=1,ng2
        cof2(m,it)=cof2(m,it)+aright(n,it)*v(m,n)
      enddo
      enddo
c
      enddo
c
c==CORR between coef and data
c
      DO m=1,nmod !loop over mode
c
      do it=1,nt
      ts1(it)=cof1(m,it)
      ts2(it)=cof2(m,it)
      enddo
      call normal(ts1,nt)
      call normal(ts2,nt)
      do jt=1,nt
        cof1(m,jt)=ts1(jt)
        cof2(m,jt)=ts2(jt)
      enddo
c
c for var1
      do i=1,imx
      do j=1,jmx

      if(w3dv1(i,j,1).gt.-1000) then

      do it=1,nt
        ts3(it)=w3dv1(i,j,it)
      enddo

      call regr_t(ts1,ts3,nt,corr11(i,j,m),regr11(i,j,m))
      call regr_t(ts2,ts3,nt,corr21(i,j,m),regr21(i,j,m))

      else
      corr11(i,j,m)=undef
      regr11(i,j,m)=undef
      corr21(i,j,m)=undef
      regr21(i,j,m)=undef
      endif

      enddo
      enddo

c for var2
      do i=1,imx
      do j=1,jmx

      if(w3dv2(i,j,1).gt.-1000) then

      do it=1,nt
        ts3(it)=w3dv2(i,j,it)
      enddo

      call regr_t(ts1,ts3,nt,corr12(i,j,m),regr12(i,j,m))
      call regr_t(ts2,ts3,nt,corr22(i,j,m),regr22(i,j,m))

      else
      corr12(i,j,m)=undef
      regr12(i,j,m)=undef
      corr22(i,j,m)=undef
      regr22(i,j,m)=undef
      endif

      enddo
      enddo

      enddo !m loop

      DO nm=2,nmod
c
c CV-1 for SVD forecast
C
      call setzero_3d(prd,imx,jmx,nt)

      DO itgt=1,nt  !loop over target yr

        do i=1,imx
        do j=1,jmx
          wic(i,j)=w3dv1(i,j,itgt)
        enddo
        enddo

        ngd1=0
        do i=isv1,iev1,2
        do j=jsv1,jev1,2
          if(w3dv1(i,j,1).gt.-1000) then
          ngd1=ngd1+1
          if(id.eq.1) then
          aic(ngd1)=wic(i,j)*cosr(j)/std1(i,j)
          else
          aic(ngd1)=wic(i,j)*cosr(j)
          endif
          endif
        enddo
        enddo
c
c forecasted var2 on grids
c     do m=1,nmod
      do m=1,nm
        cic(m,itgt)=0.
        do n=1,ng1
        cic(m,itgt)=cic(m,itgt)+aic(n)*u(n,m)
        enddo
      enddo

      do i=1,imx
      do j=1,jmx

      if(abs(w3dv2(i,j,1)).lt.999) then
c     do m=1,nmod
        do m=1,nm
          prd(i,j,itgt)=prd(i,j,itgt)+cic(m,itgt)*regr12(i,j,m)
        enddo
      else
          prd(i,j,itgt)=undef
      endif

      enddo
      enddo

      ENDDO  ! itgt loop

C skill calculation
      do i=1,imx
      do j=1,jmx
      if(abs(w3dv2(i,j,1)).lt.999) then
        do it=1,nt
          tso(it)=w3dv2(i,j,it)
          tsf(it)=prd(i,j,it)
        enddo
        call acrms_t(tsf,tso,corp(i,j),rmsp(i,j),nt)
      else
        corp(i,j)=undef
        rmsp(i,j)=undef
      endif
      enddo
      enddo

      iw=1
      write(30,rec=iw) corp
      iw=iw+1 
      write(30,rec=iw) rmsp
c
c     call avg_2d(corp,imx,jmx,isv2,iev2,jsv2,jev2,coslat,avgp)
      call avg_2d(corp,360,180,221,300,115,135,coslat,avgp)
c     print *, 'avg corp =', avgp
      print *, 'm=',nm,'avg corp =', avgp
c
C spatial corr skill
c     print *, 'sp cor start'
      do it=1,nt
        do i=1,imx
        do j=1,jmx
            w2d(i,j)=w3dv2(i,j,it)
            w2d2(i,j)=prd(i,j,it)
        enddo
        enddo
        call cor_sp(w2d,w2d2,imx,jmx,isv2,iev2,
     &jsv2,jev2,coslat,ts1(it))
      enddo

      write(40,rec=1) ts1
c
C write out obs and pls_prd
      iw=0
      do it=1,nt
        do i=1,imx
        do j=1,jmx
          w2d(i,j)=w3dv2(i,j,it)
          w2d2(i,j)=prd(i,j,it)
        enddo
        enddo
        iw=iw+1
        write(50,rec=iw) w2d
        iw=iw+1
        write(50,rec=iw) w2d2
      enddo
      enddo ! nm loop

      STOP
      END

      subroutine avg_2d(f,im,jm,is,ie,js,je,cosl,av)
      dimension f(im,jm),cosl(jm)

      av=0
      w=0 
      do i=is,ie
      do j=js,je
        if(abs(f(i,j)).lt.1000.) then
          av=av+f(i,j)*cosl(j)
          w=w+cosl(j)
        endif
      enddo
      enddo
      av=av/w
c
      return
      end
c
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

      SUBROUTINE setzero_2d(fld,n,m)
      real fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
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
c
      SUBROUTINE cor_sp(f1,f2,im,jm,is,ie,js,je,cosl,cor)

      real cosl(jm),f1(im,jm),f2(im,jm)

      cor=0.
      sd1=0.
      sd2=0.
      w=0.
      do i=is,ie
      do j=js,je
         if(abs(f1(i,j)).lt.1000.and.abs(f2(i,j)).lt.1000) then
         w=w+cosl(j)
         cor=cor+f1(i,j)*f2(i,j)*cosl(j)
         sd1=sd1+f1(i,j)*f1(i,j)*cosl(j)
         sd2=sd2+f2(i,j)*f2(i,j)*cosl(j)
         endif
      enddo
      enddo

      sd1=sqrt(sd1)
      sd2=sqrt(sd2)
      cor=cor/(sd1*sd2)

      return
      end
c========================
      subroutine anom(ts,nt,avg)
      dimension ts(nt)
        av=0
        do i=1,nt
          av=av+ts(i)
        end do
        avg=av/float(nt)
        do i=1,nt
          ts(i)=ts(i)-avg
        end do
      return
      end
ccccccccccccccccccccccc
EOF
#
cp $lcdir/svd.s.f  svd.s.f
#
 gfortran -o prd.x  svd.s.f svd.f
 ln -s $datadir1/$var1.$var1_tp.${byear}-curr.1x1.gr fort.10
 ln -s $datadir1/$var2.${byear}_cur.$var2_tp.1x1.gr  fort.20
#
 ln -s acrms.$ld                           fort.30
 ln -s spcor.$ld                           fort.40
 ln -s prdmp.$ld                           fort.50

 prd.x
#\rm fort.*
#
ld=$(( ld+1 ))
done  # for ld

#cat skill together

mv acrms.1 tsk.1
mv spcor.1 ssk.1
mv prdmp.1 prd.1
ld=2
while  [ $ld -le $nlead ]
do
ldm=$((ld-1))

cat tsk.$ldm  acrms.$ld > tsk.$ld
cat ssk.$ldm  spcor.$ld > ssk.$ld
cat prd.$ldm  prdmp.$ld > prd.$ld

\rm tsk.$ldm
\rm ssk.$ldm
\rm prd.$ldm

ld=$(( ld+1 ))
done  # for ld
#
mv tsk.$nlead skt.$ssn.gr
mv ssk.$nlead sks.$ssn.gr
mv prd.$nlead plsprd.$ssn.gr

cat>skt.$ssn.ctl<<EOF
dset ^skt.$ssn.gr
undef -9.99e+8
*
TITLE model
*
XDEF $imx LINEAR     0.   1.
YDEF $jmx LINEAR   -89.5  1.
zdef 1 linear 1 1
tdef $nlead linear jan1980 1yr
vars  2
acc 0 99 acc of prd
rms 0 99 rms of prd
endvars
EOF

cat>sks.$ssn.ctl<<EOF
dset ^sks.$ssn.gr
undef -9.99e+8
*
TITLE model
*
XDEF $nyr LINEAR    0.  1.
YDEF 1 LINEAR     -90.5  1.
zdef 1 linear 1 1
tdef $nlead linear jan1980 1yr
vars  1
cor 0 99 pattern
endvars
EOF

done  # for tgtss
done  # for nmod_pls
done  # for var2
done  # for var1
