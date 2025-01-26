#!/bin/sh

set -eaux

#=========================================================
# test various techniques in empr hcst of NA t&p with pls_eof 
#=========================================================
lcdir=/cpc/home/wd52pp/project/NA_prd/src
tmp=/cpc/consistency/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi

datadir1=/cpc/consistency/NA_prd/obs
datadir2=/cpc/consistency/NA_prd/skill
#
cd $tmp
# 
model=pls
#
for var1 in hadoisst; do
for var2 in prec; do

for nmod_pls in 6; do
#
var1_tp=3mon  # or 3mon
var2_tp=3mon  # or mon
#
nmod_v2=5 #var2 eof mode
#
var1_lag=3 # monthly: =1; 3mon: =3
#
nlead=1
byear=1978
nyr=42 #hcst period 1979->2020
#
imx=360
jmx=180
#ngrd=1154 # t2m
ngrd=1663  # prec
#
#for tgtss in jfm fma mam amj mjj jja jas aso son ond ndj djf; do
 for tgtss in mam; do

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
       parameter(isv1=1,iev1=360,jsv1=70,jev1=110)
c      parameter(isv1=1,iev1=360,jsv1=70,jev1=160)
 
       parameter(isv2=221,iev2=300,jsv2=110,jev2=140) !1128
c
       parameter(nmod=$nmod_v2,modpls=$nmod_pls)
       parameter(ngrd=$ngrd)
       parameter(ld=$ld)
       parameter(id_eof=0)
       parameter(ID=1)
       parameter(undef=-9.99E+8)
       parameter(itgtbgn=$itgtbgn)
EOF
#
cat > pls.f << EOF
      program input_data
      include "parm.h"
      dimension w2d(imx,jmx),w2d2(imx,jmx),w2d3(imx,jmx)
      dimension wic(imx,jmx)
      dimension w3dv1(imx,jmx,nt),w3dv2(imx,jmx,nt)
      dimension prd(imx,jmx,nt)
      dimension w3dv1n(imx,jmx,nt-1),w3dv2n(imx,jmx,nt-1)

      dimension ts1(nt),ts2(nt),tso(nt)
      dimension ts3(nt-1),ts4(nt-1)
      dimension sp1(ngrd),sp2(ngrd),sp3(ngrd)
      dimension ts5(modpls),nts6(modpls)
 
      dimension aaa(ngrd,nt),wk(nt,ngrd)
      dimension xlat(jmx),coslat(jmx),cosr(jmx)
      dimension eval(nt),evec(ngrd,nt),coef(nt,nt)
c
      real weval(nt),wevec(ngrd,nt),wcoef(nt,nt)
      real reval(nmod),revec(ngrd,nmod),rcoef(nmod,nt)
      real tt(nmod,nmod),rwk3(ngrd),rwk4(ngrd,nmod)
      real corr(imx,jmx),regr(imx,jmx),regro(imx,jmx,nmod)
      real rpco(nmod,nt-1)
      real rpcf(nmod,nt),rpcf2(nmod,modpls,nt),rpcf3(nmod,nt)
      real corm(imx,jmx),rmsm(imx,jmx)
      real corp(imx,jmx),rmsp(imx,jmx)
c
      real*4 pc(nt-1,modpls),pat(imx,jmx,modpls),pat2(imx,jmx,modpls)
      real*4 var(modpls),pco(modpls)
      real*4 w1d(nt-1),w1d2(nt-1)
      real*4 vart(nt),avg(nt)
      real*4 corn(modpls),rmsn(modpls)
c
      real*4 pcd(nt,modpls)
C
      open(unit=10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)

      open(unit=30,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=40,form='unformatted',access='direct',recl=4*nt)
      open(unit=50,form='unformatted',access='direct',recl=4*imx*jmx)
c
      open(unit=51,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=52,form='unformatted',access='direct',recl=4*nt)
      open(unit=53,form='unformatted',access='direct',recl=4*imx*jmx)

      open(unit=60,form='formatted')
c*************************************************
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-89.5+(j-1)*1.
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use
        cosr(j)=sqrt(coslat(j))  !for EOF use
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

C grid data of var2 for eof
      do it=1,nt
        ig=0
        do i=isv2,iev2
        do j=jsv2,jev2
        if(abs(w3dv2(i,j,1)).lt.999) then
        ig=ig+1
        aaa(ig,it)=cosr(j)*w3dv2(i,j,it)
        endif
        enddo
        enddo
        print *, 'ngrdv2=',ig
      enddo

C EOF analysis for var2(nt)
      call eofs(aaa,ngrd,nt,nt,eval,evec,coef,wk,id_eof)
      call REOFS(aaa,ngrd,nt,nt,wk,id,weval,wevec,wcoef,
     &           nmod,reval,revec,rcoef,tt,rwk3,rwk4)
c     print *, 'obs eval=',eval
C
C normalize rcoef and have patterns
      iw=0
      do m=1,nmod
        do it=1,nt
          ts1(it)=rcoef(m,it)
c         ts1(it)=coef(m,it)
        enddo
        call normal_a(ts1,nt)

        do it=1,nt
          rcoef(m,it)=ts1(it)
        enddo

        do j=1,jmx
        do i=1,imx

        if(abs(w3dv2(i,j,1)).lt.999) then

        do it=1,nt
          ts2(it)=w3dv2(i,j,it)
        enddo

        call regr_t(ts1,ts2,nt,corr(i,j),regro(i,j,m))
        else

        corr(i,j)=undef
        regro(i,j,m)=undef

        endif

        enddo
        enddo
      enddo ! m loop
c
c CV-1 for RPC forecast
C
      call setzero_3d(prd,imx,jmx,nt)

      DO itgt=1,nt  !loop over target yr

c select data of non-tgtyr

        it = 0
        DO iy = 1, nt

        IF(iy == itgt)  PRINT *,'iy=',iy

        IF(iy /= itgt)  then

        it = it + 1

c have var1 data
      do i=1,imx
      do j=1,jmx
        w3dv1n(i,j,it)=w3dv1(i,j,iy)
      enddo
      enddo

      do m=1,nmod
        rpco(m,it)=rcoef(m,iy)
      enddo

        ENDIF
        ENDDO  ! iy loop
c
        do i=1,imx
        do j=1,jmx
          wic(i,j)=w3dv1(i,j,itgt)
        enddo
        enddo
c
c forecast rpc for itgt 
c
      DO m=1,nmod

        do it=1,nt-1
        w1d(it)=rpco(m,it)
        enddo
        
      call anom(w1d,nt-1,av)
      avg(itgt)=av
c
c anom input data w3dv1n
      do i=isv1,iev1
      do j=jsv1,jev1

        if(abs(w3dv1(i,j,1)).lt.999) then

        do iy=1,nt-1
          w1d2(iy)=w3dv1n(i,j,iy)
        enddo

        call anom(w1d2,nt-1,av)
        do iy=1,nt-1
          w3dv1n(i,j,iy)=w1d2(iy)
        enddo

        wic(i,j)=wic(i,j)-av

        endif
      enddo
      enddo

      call pls_hcst(nt-1,imx,jmx,isv1,iev1,jsv1,jev1,modpls,
     &w1d,w3dv1n,wic,pc,pco,pat,pat2,var,coslat,undef,ID)
c
c compose rpcf for itgt
c
        rpcf(m,itgt)=0
        do n=1,modpls
          rpcf(m,itgt)=rpcf(m,itgt)+pco(n)
        enddo

        do n=1,modpls
        rpcf2(m,n,itgt)=0
          do k=1,n
          rpcf2(m,n,itgt)=rpcf2(m,n,itgt)+pco(k)
          enddo
        enddo
c
c calculate skill of each pls component
      if(itgt.eq.nt) then
      do n=1,modpls
        do it=1,nt-1
        ts3(it)=pc(it,n)

        ts4(it)=0.
        do k=1,n
        ts4(it)=ts4(it)+pc(it,k)
        enddo ! k loop

        enddo ! it loop

        call acrms_t(w1d,ts3,cor1,rms1,nt-1)
        call acrms_t(w1d,ts4,cor2,rms2,nt-1)
c
      write(60,101) 'eofm plsm cor&rms=',m,n,cor1,rms1,cor2,rms2
      enddo ! n loop
 101  format(A20,I3,x,I3,x,4f7.2)
      endif

      ENDDO !m loop

c forecasted var2 on grids
      do i=1,imx
      do j=1,jmx

      if(abs(w3dv2(i,j,1)).lt.999) then
        do m=1,nmod
          prd(i,j,itgt)=prd(i,j,itgt)+rpcf(m,itgt)*regro(i,j,m)
        enddo
      else
          prd(i,j,itgt)=undef
      endif

      enddo
      enddo

      ENDDO  ! itgt loop

c write out eof, coef, pcprd over it=1->nt 
      IF(ld.eq.1) then
      iw=0
      iw2=0
      call setzero_2d(rpcf3,nmod,nt)
      DO m=1,nmod
c var2 eof pattern
        do i=1,imx
        do j=1,jmx
          w2d(i,j)=regro(i,j,m)
        enddo
        enddo
        write(51,rec=m) w2d

c obs rpc and rpcf
        do it=1,nt
          ts1(it)=rcoef(m,it)
          ts2(it)=rpcf(m,it)
        enddo
          iw=iw+1
          write(52,rec=iw) ts1
          iw=iw+1
          write(52,rec=iw) ts2

c cor(rpcf,rcoef)over plsm_sum 1->mod_pls
       do n=1,modpls
         do it=1,nt
           ts1(it)=rcoef(m,it)
           ts2(it)=rpcf2(m,n,it)
         enddo
      call acrms_t(ts1,ts2,corn(n),rmsn(n),nt)
      write(6,*) 'eofm=',m, ' plsn=',n,'cor&rms=',corn(n),rmsn(n)
      enddo
c select optimal rpcf
      do n=1,modpls 
        nts6(n)=n
      enddo
c
      call hpsort(modpls,modpls,corn,nts6)
c
      if(corn(modpls).gt.0.1) then
        do it=1,nt
        rpcf3(m,it)=rpcf2(m,nts6(modpls),it)
        enddo
      endif
      print *, 'corn=',corn
      print *, 'ts6=',nts6
        
c rcoef_vs_var1 cor & regr pattern
        do it=1,nt
          ts1(it)=rcoef(m,it)
        enddo

        do j=1,jmx
        do i=1,imx
        if(abs(w3dv1(i,j,1)).lt.999) then

        do it=1,nt
          ts2(it)=w3dv1(i,j,it)
        enddo

        call regr_t(ts1,ts2,nt,w2d(i,j),w2d2(i,j))
        else

        w2d(i,j)=undef
        w2d2(i,j)=undef

        endif
        enddo
        enddo
          iw2=iw2+1
          write(53,rec=iw2) w2d
          iw2=iw2+1
          write(53,rec=iw2) w2d2
      ENDDO ! loop m
      print *, 'rpcf3(it=nt)='
      print *, rpcf3(1,nt),rpcf3(2,nt),rpcf3(3,nt),rpcf3(4,nt)
      print *, rpcf3(5,nt),rpcf3(6,nt),rpcf3(7,nt),rpcf3(8,nt)
      print *, rpcf3(9,nt),rpcf3(10,nt)
      print *, 'rpcf3(it=8)='
      print *, rpcf3(1,8),rpcf3(2,8),rpcf3(3,8),rpcf3(4,8)
      print *, rpcf3(5,8),rpcf3(6,8),rpcf3(7,8),rpcf3(8,8)
      print *, rpcf3(9,8),rpcf3(10,8)
c test hcst var2 on grids
      do it=1,nt
      do i=1,imx
      do j=1,jmx

      if(abs(w3dv2(i,j,1)).lt.999) then
        do m=1,nmod
          prd(i,j,it)=prd(i,j,it)+rpcf3(m,it)*regro(i,j,m)
        enddo
      else
          prd(i,j,it)=undef
      endif

      enddo
      enddo
      enddo ! it loop

      ENDIF
c
C skill calculation
      do i=1,imx
      do j=1,jmx
      if(abs(w3dv2(i,j,1)).lt.999) then
        do it=1,nt
          tso(it)=w3dv2(i,j,it)
          ts1(it)=prd(i,j,it)
        enddo
        call acrms_t(ts1,tso,corp(i,j),rmsp(i,j),nt)
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
      print *, 'avg corp =', avgp
c
C spatial corr skill
      print *, 'sp cor start'
      do it=1,nt
        do i=1,imx
        do j=1,jmx
            w2d2(i,j)=w3dv2(i,j,it)
            w2d3(i,j)=prd(i,j,it)
        enddo
        enddo
        call cor_sp(w2d2,w2d3,imx,jmx,isv2,iev2,
     &jsv2,jev2,coslat,ts1(it))
      enddo

      write(40,rec=1) ts1
c
C write out obs and pls_prd
      iw=0
      do it=1,nt
        do i=1,imx
        do j=1,jmx
          w2d2(i,j)=w3dv2(i,j,it)
          w2d3(i,j)=prd(i,j,it)
        enddo
        enddo
        iw=iw+1
        write(50,rec=iw) w2d2
        iw=iw+1
        write(50,rec=iw) w2d3
      enddo

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

      subroutine normal_a(x,n)
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
cccccccccccccccccccccccccccccccccccc
EOF
#
cp $lcdir/reof.s.f reof.s.f
cp $lcdir/pls_hcst.s.f  pls.s.f
#
 gfortran -o prd.x reof.s.f  pls.s.f pls.f
 ln -s $datadir1/$var1.$var1_tp.${byear}-curr.1x1.gr fort.10
 ln -s $datadir1/$var2.${byear}_cur.$var2_tp.1x1.gr  fort.20
#
 ln -s acrms.$ld                           fort.30
 ln -s spcor.$ld                           fort.40
 ln -s prdmp.$ld                           fort.50

 ln -s eofv2.ld$ld.gr                      fort.51
 ln -s pcv2.ld$ld.gr                       fort.52
 
 ln -s ptnv1.ld$ld.gr                      fort.53

 ln -s pls_skill.${var1}_2_${var2}.$tgtss.ld$ld.txt fort.60
 
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

cat>pls.$ssn.ctl<<EOF
dset ^pls.$ssn.gr
undef -9.99e+8
*
TITLE model
*
XDEF $imx LINEAR    0.   1.
YDEF $jmx LINEAR  -89.5  1.
zdef 1 linear 1 1
tdef $nyr linear jan1982 1yr
edef 7 names e1 e2 e3 e4 e5 e6 e7
vars 2
o 0 99 obs
c 0 99 corrected prd
endvars
EOF

cat>eofv2.ld1.ctl<<EOF
dset ^eofv2.ld1.gr
undef -9.99e+8
*
TITLE model
*
XDEF $imx LINEAR    0.   1.
YDEF $jmx LINEAR  -89.5  1.
zdef 1 linear 1 1
tdef $nmod_v2 linear jan1982 1yr
edef 1 names e1
vars 1
regr 0 99 obs
endvars
EOF

cat>pcv2.ld1.ctl<<EOF
dset ^pcv2.ld1.gr
undef -9.99e+8
*
TITLE model
*
XDEF $nyr LINEAR    0.  1.
YDEF 1 LINEAR     -90.5  1.
zdef 1 linear 1 1
tdef $nmod_v2 linear jan1980 1yr
vars  2
o 0 99 obs
f 0 99 pls
endvars
EOF

cat>ptnv1.ld1.ctl<<EOF
dset ^ptnv1.ld1.gr
undef -9.99e+8
*
TITLE model
*
XDEF $imx LINEAR    0.5  1.
YDEF $jmx LINEAR  -89.5  1.
zdef 1 linear 1 1
tdef $nmod_v2 linear jan1982 1yr
edef 1 names e1
vars 2
corr 0 99 corr
regr 0 99 regr
endvars
EOF

done  # for tgtss
done  # for nmod_pls
done  # for var2
done  # for var1
