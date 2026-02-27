#!/bin/sh

set -eaux

#=========================================================
# time marching SVD forecast
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
id=1 # =1 for cor matrix; =0 for var metrix
#
for var1 in hadoisst_t2m; do
for var2 in prec; do

for msvd in 8; do

mv1_eof=10 # mode cut off for model data
mv2_eof=10 # mode cut off for OBS
#
var1_tp=3mon  # or 3mon
var2_tp=3mon  # or mon
#
var1_lag=3 # monthly: =1; 3mon: =3
#
nlead=1
byear=1949
nyro=71  #obs period 1950->2020
nts=52  #training start
nyrv=`expr $nyro - $nts`  # verification period long ??-2020
#
imx=360
jmx=180
#ngrdv1=16371  # sst/or SST_t2m
ngrdv1=7378 # sst/or SST_t2m
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
cat > parm.h << EOF
       parameter(nt=$nyro)
       parameter(nts=$nts)
       parameter(ntv=$nyrv)
       parameter(imx=$imx,jmx=$jmx)
c
       parameter(isv1=1,iev1=360,jsv1=71,jev1=111)
c      parameter(isv1=1,iev1=360,jsv1=71,jev1=161)
 
       parameter(isv2=221,iev2=300,jsv2=111,jev2=141) !1128
c
       parameter(mv1=$mv1_eof)
       parameter(mv2=$mv2_eof)
       parameter(msvd=$msvd)
       parameter(ng1=$ngrdv1,ng2=$ngrdv2)
       parameter(ld=$ld)
       parameter(id=$id)
       parameter(undef=-9.99E+8)
       parameter(itgtbgn=$itgtbgn)
EOF
#
cat > svd.f << EOF
      program input_data
      include "parm.h"
      dimension w2d(imx,jmx),w2d2(imx,jmx)
      dimension wic(mv1),aic(mv1),cic(msvd)
      dimension w3dv1(imx,jmx,nt),w3dv2(imx,jmx,nt)
      dimension prdspc(mv2,ntv)
      dimension prdgrd(imx,jmx,ntv)

      dimension tso(nt),tsf(nt),tsv(ntv)
      dimension ts1(nt),ts2(nt)
      dimension ts3(nt),ts4(nt)
 
      dimension xlat(jmx),coslat(jmx),cosr(jmx)

      real corr(imx,jmx),regr(imx,jmx)
      real rpcv1(mv1,nt),rpcv2(mv2,nt)
      real corv1(imx,jmx,mv1),regv1(imx,jmx,mv1)
      real corv2(imx,jmx,mv2),regv2(imx,jmx,mv2)

      real aleft(mv1,nt),aright(mv2,nt)
      real a(mv1,mv2),w(mv2),u(mv1,mv2),v(mv2,mv2)
      logical matu,matv
c
      real cof1(msvd,nt),cof2(msvd,nt)
c
      dimension corp(imx,jmx),rmsp(imx,jmx)

      real corr11(mv1,msvd),regr11(mv1,msvd)
      real corr12(mv1,msvd),regr12(mv1,msvd)
      real corr21(mv2,msvd),regr21(mv2,msvd)
      real corr22(mv2,msvd),regr22(mv2,msvd)
c
      open(unit=10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)

      open(unit=30,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=40,form='unformatted',access='direct',recl=4*ntv)
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
      do it=1,nt
c
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
c
      call setzero_2d(prdspc,mv2,ntv)
      call setzero_3d(prdgrd,imx,jmx,ntv)

      itp=0
      DO mt=nts,nt-1  

      mtp=mt+1

      print *, 'mt=',mt
c
      idx=2
      idy=1
      call eof_s(w3dv1,cosr,nt,mtp,ng1,mv1,undef,
     &imx,jmx,idx,idy,isv1,iev1,jsv1,jev1,rpcv1,corv1,regv1,id)
c
      idx=1
      idy=1
      call eof_s(w3dv2,cosr,nt,mt,ng2,mv2,undef,
     &imx,jmx,idx,idy,isv2,iev2,jsv2,jev2,rpcv2,corv2,regv2,id)
c
ccc feed svd matrix a
c
      do it=1,mt
        do m=1,mv1
          aleft(m,it)=rpcv1(m,it)
        enddo
        do m=1,mv2
          aright(m,it)=rpcv2(m,it)
        enddo
      enddo   ! loop it
c
c var1 IC data (rpcv1 in mtp)
c
        do m=1,mv1
          wic(m)=rpcv1(m,mtp)
        enddo
c
        do m=1,mv1
          aic(m)=wic(m)
        enddo
c
      do i=1,mv1
      do j=1,mv2

      a(i,j)=0.
      do k=1,mt
      a(i,j)=a(i,j)+aleft(i,k)*aright(j,k)/float(mt)
      enddo

      enddo
      enddo
c
cc... SVD analysis
c
      print *, 'before svdcmp'
      call svdcmp(a,mv1,mv2,mv1,mv2,w,v)

      do i=1,mv1
      do j=1,mv2
        u(i,j)=a(i,j)
      enddo
      enddo
c
cc... write out singular value in w
      do i=1,msvd
      write(6,*)'singular value= ',i,w(i)
      end do
      write(6,*)'singular value= ',w

c== have svd coef
      do m=1,msvd
c
      do it=1,mt
        cof1(m,it)=0.
        cof2(m,it)=0.
      do n=1,mv1
        cof1(m,it)=cof1(m,it)+aleft(n,it)*u(n,m)
      enddo
      do n=1,mv2
        cof2(m,it)=cof2(m,it)+aright(n,it)*v(n,m)
      enddo
      enddo
c
      enddo
c
c==CORR between coefs
c
      DO m=1,msvd !loop over mode
c
      do it=1,mt
      ts1(it)=cof1(m,it)
      ts2(it)=cof2(m,it)
      enddo
      call normal(ts1,nt,mt)
      call normal(ts2,nt,mt)
      do jt=1,mt
        cof1(m,jt)=ts1(jt)
        cof2(m,jt)=ts2(jt)
      enddo
c
c for var1
      do n=1,mv1

      do it=1,mt
        ts3(it)=rpcv1(n,it)
      enddo

      call regr_t(ts1,ts3,nt,mt,corr11(n,m),regr11(n,m))
      call regr_t(ts2,ts3,nt,mt,corr21(n,m),regr21(n,m))

      enddo

c for varo
      do n=1,mv2

      do it=1,mt
        ts3(it)=rpcv2(n,it)
      enddo

      call regr_t(ts1,ts3,nt,mt,corr12(n,m),regr12(n,m))
      call regr_t(ts2,ts3,nt,mt,corr22(n,m),regr22(n,m))

      enddo

      enddo !m loop

c forecast var2 on spectral
      itp=itp+1

      do m=1,msvd
        cic(m)=0.
        do n=1,mv1
        cic(m)=cic(m)+aic(n)*u(n,m)
        enddo
      enddo

      do n=1,mv2
        do m=1,msvd
          prdspc(n,itp)=prdspc(n,itp)+cic(m)*regr12(n,m)
        enddo
      enddo

c forecasted var2 on grids
      do i=1,imx
      do j=1,jmx

      if(abs(w3dv2(i,j,1)).lt.999) then
        do m=1,mv2
        prdgrd(i,j,itp)=prdgrd(i,j,itp)+prdspc(m,itp)*regv2(i,j,m)
        enddo
      else
        prdgrd(i,j,itp)=undef
      endif

      enddo
      enddo

      ENDDO  ! mt loop
      print *, 'itp=', itp

c     write(6,*) 'skill calculation'
C
C skill calculation
C
      do i=1,imx
      do j=1,jmx
      if(abs(w3dv2(i,j,1)).lt.999) then
        do it=1,ntv
          it1=it+nts
c       write(6,*) 'it1=',it1,' it2=',it2
          tso(it)=w3dv2(i,j,it1)
          tsf(it)=prdgrd(i,j,it)
        enddo
c       write(6,*) 'it1=',it1,' it2=',it2
        call acrms_t(tsf,tso,corp(i,j),rmsp(i,j),nt,ntv)
      else
        corp(i,j)=undef
        rmsp(i,j)=undef
      endif
      enddo
      enddo

      iw=iw+1 
      write(30,rec=iw) corp
      iw=iw+1 
      write(30,rec=iw) rmsp
c
c     call avg_2d(corp,imx,jmx,isv2,iev2,jsv2,jev2,coslat,avgp)
      call avg_2d(corp,360,180,221,300,115,135,coslat,avgp)
c     print *, 'avg corp =', avgp
      print *, 'msvd=',msvd,'avg corp =', avgp
c
C spatial corr skill
c     print *, 'sp cor start'
      do it=1,ntv
        it1=it+nts
        do i=1,imx
        do j=1,jmx
            w2d(i,j)=w3dv2(i,j,it1)
            w2d2(i,j)=prdgrd(i,j,it)
        enddo
        enddo
        call cor_sp(w2d,w2d2,imx,jmx,isv2,iev2,
     &jsv2,jev2,coslat,tsv(it))
      enddo

      write(40,rec=1) tsv
c
C write out obs and prd
c     print *, 'write out obs and prd'
      iw2=0
      do it=1,ntv
        it1=it+nts
        do i=1,imx
        do j=1,jmx
          w2d(i,j)=w3dv2(i,j,it1)
          w2d2(i,j)=prdgrd(i,j,it)
        enddo
        enddo
        iw2=iw2+1
        write(50,rec=iw2) w2d
        iw2=iw2+1
        write(50,rec=iw2) w2d2
      enddo

      STOP
      END

      subroutine eof_s(fin,cosr,ntot,nt,ng,nmod,undef,
     &im,jm,idx,idy,is,ie,js,je,rpc,cor,reg,id)
c
      dimension fin(im,jm,ntot),cosr(jm)
      dimension aaa(ng,nt),wk(nt,ng)
      dimension weval(nt),wevec(ng,nt),wcoef(nt,nt)
      dimension reval(nmod),revec(ng,nmod)
      dimension rcoef(nmod,nt),rpc(nmod,ntot)
      dimension tt(nmod,nmod),rwk(ng),rwk2(ng,nmod)

      dimension ts1(nt),ts2(nt)
      dimension cor(im,jm,nmod),reg(im,jm,nmod)
c
C select grid data
      do it=1,nt
      ig=0
      do i=is,ie,idx
      do j=js,je,idy
        if(fin(i,j,1).gt.-1000) then
        ig=ig+1
        aaa(ig,it)=cosr(j)*fin(i,j,it)
        endif
      enddo
      enddo
      print *, 'ngrd=',ig
      enddo
C EOF analysis
      call REOFS(aaa,ng,nt,nt,wk,id,weval,wevec,wcoef,
     &           nmod,reval,revec,rcoef,tt,rwk,rwk2)
C
C normalize rpc and have cor&reg patterns
      do m=1,nmod
        do it=1,nt
        ts1(it)=rcoef(m,it)
        enddo
        call normal(ts1,nt,nt)

        do it=1,nt
        rpc(m,it)=ts1(it)
        enddo
c
        do j=1,jm
        do i=1,im

        if(fin(i,j,1).gt.-1000) then

        do it=1,nt
        ts2(it)=fin(i,j,it)
        enddo

        call regr_t(ts1,ts2,nt,nt,cor(i,j,m),reg(i,j,m))

        else

        cor(i,j,m)=undef
        reg(i,j,m)=undef

        endif

        enddo
        enddo
      enddo  ! m loop

      return
      end

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
      subroutine acrms_t(f,o,ac,rms,n,m)
      dimension f(n),o(n)

      oo=0.
      ff=0.
      of=0.
      rms=0
      do i=1,m
        oo=oo+o(i)*o(i)
        ff=ff+f(i)*f(i)
        of=of+f(i)*o(i)
        rms=rms+(f(i)-o(i))*(f(i)-o(i))
      enddo
      tt=float(m)
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

      subroutine normal(x,n,m)
      dimension x(n)
      avg=0
      do i=1,m
        avg=avg+x(i)/float(m)
      enddo
      var=0
      do i=1,m
        var=var+(x(i)-avg)*(x(i)-avg)/float(m)
      enddo
      std=sqrt(var)
      do i=1,m
        x(i)=(x(i)-avg)/std
      enddo
      return
      end
C
      SUBROUTINE regr_t(f1,f2,n,m,cor,reg)

      real f1(n),f2(n)

      cor=0.
      sd1=0.
      sd2=0.

      do it=1,m
         cor=cor+f1(it)*f2(it)/float(m)
         sd1=sd1+f1(it)*f1(it)/float(m)
         sd2=sd2+f2(it)*f2(it)/float(m)
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
cp $lcdir/reof.s.f reof.s.f
#
 gfortran -o prd.x  svd.s.f reof.s.f svd.f
# ln -s $datadir1/$var1.$var1_tp.${byear}-curr.1x1.gr fort.10
 ln -s $datadir1/$var1.$var1_tp.${byear}_curr.1x1.gr fort.10
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
mv prd.$nlead svdprd.$ssn.gr

cat>skt.$ssn.ctl<<EOF
dset ^skt.$ssn.gr
undef -9.99e+8
*
TITLE model
*
XDEF $imx LINEAR     0.5  1.
YDEF $jmx LINEAR   -89.5  1.
zdef 1 linear 1 1
tdef 999 linear jan1980 1yr
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
XDEF $nyrv LINEAR    0.  1.
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
