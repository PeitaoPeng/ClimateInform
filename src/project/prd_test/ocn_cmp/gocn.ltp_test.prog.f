C==========================================================
C  OCN forecast with changing ltp and t
C==========================================================
      include "parm.h"
      parameter(ntout=ntprd-30)
      real r1d1(ntout),r1d2(ntout)
      real r2d(imax),skill(imax)
      real obs(imax),prd(imax),prd2(imax)
      real obs2d(imax,ntprd),prd2d(imax,ntprd,12)
      real grid(imax,ltime),grid2(imax,ltime)
      real grid3(imax,ltime),wmo(imax,ntprd),awmo(imax,ntprd,12)
      real coef(mmax,ltime),fld1(ltime)
      real fld2D(imax,ltime)
      real wk2d1(imax,ntprd),wk2d2(imax,ntprd)
      real wk1d1(kp),wk1d2(kp)
      real fldin(imax)
      real clim(imax,12),clmg(ndec,imax)
      real cwmo(ndec,imax,12),cmean(ndec,imax)
      dimension xkout(ltp),kmax(ltp,ntprd)
      dimension wk1(30),wk2(30)
      dimension obsn(imax,ntprd),prdn(imax,ntprd)
      dimension wk3(102),wk4(102)
      dimension iwk3(102),iwk4(102)
      dimension itest(10)
      real fld3D(imax,ltime+1,12),fld3D2(imax,ltime,12)
      real rms(ltp,ntout,12),acc(ltp,ntout,12),hss(ltp,ntout,12)
      real rms_t(ltp,12,imax),acc_t(ltp,12,imax),hss_t(ltp,12,imax)
      real rms_t2(ltp),acc_t2(ltp),hss_t2(ltp)
      real rms_t3(ltp)
      real wrms(ltp,ntout,12)
      real xmrms(ltp,ntout),xmacc(ltp,ntout)
      real xrms(ltp,ntprd,kp),xacc(ltp,ntprd,kp)
      real yrms(kp),yacc(kp)
      real xyrms(ltp,kp,ntout),xyacc(ltp,kp,ntout)
      real xout(ltp,ntout),xout2(ltp,ntout),xout3(ltp,ntout)
      real xout4(ltp,ntout),xout5(ltp,ntout)
c
      real yout1(ltp,kp),yout2(ltp,kp)
c
      open(unit=10,form='formatted')
      open(unit=60,form='unformatted',access='direct',recl=4*ltp*ntout)
      open(unit=61,form='unformatted',access='direct',recl=4*ltp)
      open(unit=65,form='unformatted',access='direct',recl=4*ltp*kp)
      open(unit=66,form='unformatted',access='direct',recl=4*ltp*ntout)
      open(unit=67,form='unformatted',access='direct',recl=4*ltp)

c== read in 102CD data (1931-cur)
      do ny=1,ltime+1
      do m=1,12
        read(10,888) obs
 888  format(10f7.1)
        do i=1,imax
          fld3D(i,ny,m)=obs(i)
        enddo
      enddo
      enddo
c
c  process all 12 seasons data 
c
      DO is=1,12 !jfm to djf
c
c== have anom wrt wmo clim for 1961-current
c
      call season_mean(fld3D,ltime+1,is,imax,grid)
      call anom_wmo(grid,wmo,imax,ltime,ntprd,ndec,cmean)
      do it=1,ntprd
      do im=1,imax
        awmo(im,it,is)=wmo(im,it)
      enddo
      enddo
      do id=1,ndec
      do im=1,imax
        cwmo(id,im,is)=cmean(id,im)
      enddo
      enddo
c
cc filter data for period 1931-2012
c
c anom wrt all time mean
c     call season_anom(fld3D,ltime+1,1,ltime,is,imax,clim,grid2)
c filtering with EOF
c     nw=2*ltime+15
c     call eof_flt(grid2,imax,ltime,ltime,mmax,nw,fld2D)
c back to total quantity
      do it=1,ltime
      do im=1,imax
c       fld3D2(im,it,is)=fld2D(im,it)+clim(im,is)
        fld3D2(im,it,is)=grid(im,it)  !no filtering
      enddo
      enddo

      ENDDO  ! iseason loop
c
      DO ltest=1,ltp  !ltest is the length of test period
      write(6,*) 'ltest=',ltest
c
C== have OCN which will be in the range of 1 -> kp

      do it=61,ltime  !61=1991; 
c
c have seasonally independent OCN
      if(irms.eq.1) then

      call rms_k_kmax(fld3D2,kmax(ltest,it-60),
     &ltime,ntprd,imax,kp,it-1,ltest,xmrms(ltest,it-60),yrms)

      do kk=1,kp
      xyrms(ltest,kk,it-60)=yrms(kk)
      enddo

      else

      call acc_k_kmax(fld3D2,kmax(ltest,it-60),ltime,ndec,cwmo,
     &ntprd,imax,kp,it-1,ltest,xmacc(ltest,it-60),yacc)

      do kk=1,kp
      xyacc(ltest,kk,it-60)=yacc(kk)
      enddo

      endif
c
c fcst for 12 seasons
      do is=1,12
      do m=1,imax
         avg=0
         do k=it-kmax(ltest,it-60),it-1
         avg=avg+fld3D2(m,k,is)/float(kmax(ltest,it-60))
         end do
         prd2d(m,it-30,is)=avg
      end do  !loop imax
      enddo   ! is loop

      end do  ! loop it
c
c== forecast for 1961-1990 with dependnet data determined optimal K
c
      do is=1,12 !season
      do it=31,60  !31=1961; 60=1990
      do m=1,imax
         avg=0
         do k=it-kmax(ltest,1),it-1
         avg=avg+fld3D2(m,k,is)/float(kmax(ltest,1))
         end do
         prd2d(m,it-30,is)=avg
      end do  !loop m
      end do  !loop it
      end do  !loop is
c
c== fcst rms & acc skill from 1991 to current year
c== (in spatial domain for each individual year)
c
      do is=1,12 !season

      do id=4,ndec-1
      do k=1,10
        kt=k+(id-1)*10
      do m=1,imax
        wk3(m)=prd2d(m,kt,is)-cwmo(id,m,is)
        wk4(m)=fld3D2(m,kt+30,is)-cwmo(id,m,is)
      enddo
        call acc1d(wk3,wk4,imax,acc(ltest,kt-30,is))
        call rms1d(wk3,wk4,imax,rms(ltest,kt-30,is))
      enddo
      enddo
c
      ks=(ndec-1)*10+1
      do kt=ks,ntprd !2011-cur (at most 2020)
      do m=1,imax
        wk3(m)=prd2d(m,kt,is)-cwmo(ndec,m,is)
        wk4(m)=fld3D2(m,kt+30,is)-cwmo(ndec,m,is)
      enddo
        call acc1d(wk3,wk4,imax,acc(ltest,kt-30,is))
        call rms1d(wk3,wk4,imax,rms(ltest,kt-30,is))
      enddo
c
c== wmo rms skill from 1991 to current year
c
      do it=61,ltime
        jt=it-30
        kt=it-60
      wrms(ltest,kt,is)=0.
      do m=1,imax
      wrms(ltest,kt,is)=wrms(ltest,kt,is)+awmo(m,jt,is)*awmo(m,jt,is)
      enddo
      wrms(ltest,kt,is)=sqrt(wrms(ltest,kt,is)/float(imax))
      enddo
c
c== have prd wrt its own wmo clim (a kind of bias correction)
c
c     do id=1,3
c     do i=1,imax
c       clmg(id,i)=0.
c     do k=1,30
c       clmg(id,i)=clmg(id,i)+prd2d(i,k+(id-1)*10,is)/30.
c       clmg(id,i)=clmg(id,i)+fld3D2(i,k+30+(id-1)*10,is)/30.
c     enddo
c     enddo
c     enddo

c     do i=1,imax
c     do it=1,40
c       prd2d(i,it,is)=prd2d(i,it,is)-clmg(1,i)
c     enddo
c     do it=41,50
c       prd2d(i,it,is)=prd2d(i,it,is)-clmg(2,i)
c     enddo
c     do it=51,ntprd
c       prd2d(i,it,is)=prd2d(i,it,is)-clmg(3,i)
c     enddo
c     enddo
c
c==normalize prd and obs
c
c     do i=1,imax
c  have stdv for 61-90
c     do k=1,30
c       wk1(k)=awmo(i,k,is)
c       wk2(k)=prd2d(i,k,is)
c     enddo
c     call stdv(wk1,30,sdo)
c     call stdv(wk2,30,sdp)
c  normalize for 61-00
c     do k=1,40
c       obsn(i,k)=awmo(i,k,is)/sdo
c       prdn(i,k)=prd2d(i,k,is)/sdp
c     enddo
c  have stdv for 71-00
c     do k=1,30
c       wk1(k)=awmo(i,k+10,is)
c       wk2(k)=prd2d(i,k+10,is)
c     enddo
c     call stdv(wk1,30,sdo)
c     call stdv(wk2,30,sdp)
c  normalize for 01-10
c     do k=41,50
c       obsn(i,k)=awmo(i,k,is)/sdo
c       prdn(i,k)=prd2d(i,k,is)/sdp
c     enddo
c  have stdv for 81-10
c     do k=1,30
c       wk1(k)=awmo(i,k+20,is)
c       wk2(k)=prd2d(i,k+20,is)
c     enddo
c     call stdv(wk1,30,sdo)
c     call stdv(wk2,30,sdp)
c  normalize for 01-10
c     do k=51,ntprd
c       obsn(i,k)=awmo(i,k,is)/sdo
c       prdn(i,k)=prd2d(i,k,is)/sdp
c     enddo

c     enddo !loop for i (1->imax)
c    
c== have Heidke skill
c
     
c     a=0.4308 
c     b=-0.4308 

c     do k=1,ntprd-30

c     do i=1,imax
c       wk3(i)=obsn(i,k+30)
c       wk4(i)=prdn(i,k+30)
c     enddo
      
c     call terc102(wk3,a,b,iwk3)
c     call terc102(wk4,a,b,iwk4)
c       
c     call heidke(iwk4,iwk3,h,hs,imax)

c     hss(ltest,k,is)=hs

c     enddo
c
      enddo  !is loop
c
c== fcst rms & acc skill from 1991 to current year
c== (in time domain for the whole period)
c
      do m=1,imax
      do is=1,12 !season

      do id=4,ndec-1
      do k=1,10
        kt=k+(id-1)*10
        r1d1(kt-30)=prd2d(m,kt,is)-cwmo(id,m,is)
        r1d2(kt-30)=fld3D2(m,kt+30,is)-cwmo(id,m,is)
      enddo
      enddo
c
      ks=(ndec-1)*10+1
      do kt=ks,ntprd !2011-cur (at most 2020)
        r1d1(kt-30)=prd2d(m,kt,is)-cwmo(ndec,m,is)
        r1d2(kt-30)=fld3D2(m,kt+30,is)-cwmo(ndec,m,is)
      enddo

        call acc1d(r1d1,r1d2,ntout,acc_t(ltest,is,m))
        call rms1d(r1d1,r1d2,ntout,rms_t(ltest,is,m))

      enddo  !is loop
      enddo  ! m loop
c avg over is(season) and m(cd)
      acc_t2(ltest)=0
      rms_t2(ltest)=0
      rms_t3(ltest)=0
      do  m=1,imax
      do is=1,12 !season
      acc_t2(ltest)=acc_t2(ltest)+acc_t(ltest,is,m)/float(12*imax)
      rms_t2(ltest)=rms_t2(ltest)+
     &rms_t(ltest,is,m)*rms_t(ltest,is,m)/float(12*imax)
      enddo
      enddo
      rms_t2(ltest)=sqrt(rms_t2(ltest))

c avg wrms over year and season
      rms_t3(ltest)=0
      do is=1,12
      do it=1,ntout
      rms_t3(ltest)=rms_t3(ltest)+ wrms(ltest,it,is)*wrms(ltest,it,is)
      enddo
      enddo
      rms_t3(ltest)=sqrt(rms_t3(ltest)/float(ntout*12))

      ENDDO !ltest loop
c
c write out
c
      iw=0
c
      do is=1,12 !seasons

      do ltest=1,ltp
      do it=1,ntout
      xout(ltest,it)=rms(ltest,it,is)
      xout2(ltest,it)=acc(ltest,it,is)
      xout3(ltest,it)=hss(ltest,it,is)
      xout4(ltest,it)=float(kmax(ltest,it))
      xout5(ltest,it)=wrms(ltest,it,is)
      enddo
      enddo

      iw=iw+1
      write(60,rec=iw) xout

      iw=iw+1
      write(60,rec=iw) xout2

      iw=iw+1
      write(60,rec=iw) xout3

      iw=iw+1
      write(60,rec=iw) xout5

      enddo
c
      do it=1,ntout
      do ltest=1,ltp
        xkout(ltest)=float(kmax(ltest,it))
      enddo
      write(61,rec=it) xkout
      enddo

      iw=0
      if(irms.eq.1) then

      do it=1,ntout 
      do l=1,ltp
      do k=1,kp
        yout1(l,k)=xyrms(l,k,it)
      enddo
      enddo
      iw=iw+1
      write(65,rec=iw) yout1
      enddo

      write(66,rec=1) xmrms

      else

      do it=1,ntout 
      do l=1,ltp
      do k=1,kp
        yout2(l,k)=xyacc(l,k,it)
      enddo
      enddo
      iw=iw+1
      write(65,rec=iw) yout2
      enddo

      write(66,rec=1) xmacc

      endif
c
      write(67,rec=1) acc_t2
      write(67,rec=2) rms_t2
      write(67,rec=3) rms_t3

 999  format(10f7.3)
      
      stop
      end
        
      subroutine season_mean(fld,nyear,mons,nmax,out)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. calculate seasonal mean of 102 cd data
C===========================================================
      real fld(nmax,nyear,12)
      real clim(nmax,12),out(nmax,nyear-1)
c
      IF(mons.eq.12) THEN

      m1=12
      m2=1
      m3=2
c
      do ny=1,nyear-1
        do i=1,nmax
        out(i,ny)=(fld(i,ny,m1)+fld(i,ny+1,m2)+fld(i,ny+1,m3))/3.
        enddo
      enddo

      ELSE IF (mons.eq.11) THEN
c

      m1=11
      m2=12
      m3=1
c
      do ny=1,nyear-1
        do i=1,nmax
        out(i,ny)=(fld(i,ny,m1)+fld(i,ny,m2)+fld(i,ny+1,m3))/3.
        enddo
      enddo
c
      ELSE

      m1=mons      !m1=1 -> JFM;
      m2=m1+1
      m3=m2+1
c
      do ny=1,nyear-1
        do i=1,nmax
        out(i,ny)=(fld(i,ny,m1)+fld(i,ny,m2)+fld(i,ny,m3))/3.
        enddo
      enddo

      END IF
c
      return
      END
c
      subroutine season_anom(fld,nytot,nys,nyear,mons,nmax,clim,out)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. calculate seasonal anom & clim of 102 cd data
C===========================================================
      real fld(nmax,nytot,12)
      real clim(nmax,12),out(nmax,nytot)
c
      call setzero(clim,nmax,12)
      do m=1,12
      do ny=nys,nyear-1
        do i=1,nmax
         clim(i,m)=clim(i,m)+fld(i,ny,m)/float(nyear-nys)
        enddo
      end do
      end do
c
c have seasonal mean
c
      IF(mons.eq.12) THEN

      m1=12
      m2=1
      m3=2
c
c for history
      do ny=nys,nyear-1
        do i=1,nmax
        out(i,ny)=(fld(i,ny,m1)+fld(i,ny+1,m2)+fld(i,ny+1,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
        enddo
      enddo
c for target year
        do i=1,nmax
      out(i,nyear)=(fld(i,nyear,m1)+fld(i,nyear+1,m2)+fld(i,nyear+1,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
        enddo

      ELSE IF (mons.eq.11) THEN
c

      m1=11
      m2=12
      m3=1
c
c for history
      do ny=nys,nyear-1
        do i=1,nmax
        out(i,ny)=(fld(i,ny,m1)+fld(i,ny,m2)+fld(i,ny+1,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
        enddo
      enddo
c for target year
        do i=1,nmax
      out(i,nyear)=(fld(i,nyear,m1)+fld(i,nyear,m2)+fld(i,nyear+1,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
        enddo
c
      ELSE

      m1=mons      !m1=1 -> JFM;
      m2=m1+1
      m3=m2+1
c
c for history
      do ny=nys,nyear-1
        do i=1,nmax
        out(i,ny)=(fld(i,ny,m1)+fld(i,ny,m2)+fld(i,ny,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
        enddo
      enddo
c for target year
        do i=1,nmax
      out(i,nyear)=(fld(i,nyear,m1)+fld(i,nyear,m2)+fld(i,nyear,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
        enddo

      END IF
c
      return
      END
c
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  set array zero
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE setzero(fld,n,m)
      DIMENSION fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  get rid of mean
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine anom(a,n)
      real a(n)
      avg=0
      do 5 i=1,n
      avg=avg+a(i)/float(n)
  5   continue
      do 6 i=1,n
      a(i)=a(i)-avg
  6   continue
      return
      end


CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  runing mean
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine runmean(a,n,b,m)
      real a(n),b(n)
c
      do i=1,m
        b(i)=a(i)
        b(n-i+1)=a(n-i+1)
      enddo
c
      do 5 i=m+1,n-m
        avg=0
        do 6 j=i-m,i+m
        avg=avg+a(j)/float(2*m+1)
  6   continue
        b(i)=avg
  5   continue
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  acc in time domain
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine acc2d(a,b,m,n,k,ite,c)
      real a(m,n),b(m,n)
c
      ks=ite-30-k+1
      ke=ite-30
      avg_a=0.
      avg_b=0.
      do j=ks,ke
      do i=1,m
        avg_a=avg_a+a(i,j)/float(m*k)
        avg_b=avg_b+b(i,j)/float(m*k)
      enddo
      enddo
c
      do j=ks,ke
      do i=1,m
      a(i,j)=a(i,j)-avg_a
      b(i,j)=b(i,j)-avg_b
      enddo
      enddo
c
      sd_a=0
      sd_b=0
      ac=0
      do j=ks,ke
      do i=1,m
      sd_a=sd_a+a(i,j)*a(i,j)/float(m*k)
      sd_b=sd_b+b(i,j)*b(i,j)/float(m*k)
      ac=ac+a(i,j)*b(i,j)/float(m*k)
      enddo
      enddo
      sd_a=sqrt(sd_a)
      sd_b=sqrt(sd_b)
      c=ac/(sd_a*sd_b)
c     
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  acc in 1D
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine acc1d(a,b,n,c)
      real a(n),b(n)
c
      avg_a=0.
      avg_b=0.
      do i=1,n
c       avg_a=avg_a+a(i)/float(n)
c       avg_b=avg_b+b(i)/float(n)
      enddo
c
      do i=1,n
      a(i)=a(i)-avg_a
      b(i)=b(i)-avg_b
      enddo
c
      sd_a=0
      sd_b=0
      ac=0
      do i=1,n
      sd_a=sd_a+a(i)*a(i)/float(n)
      sd_b=sd_b+b(i)*b(i)/float(n)
      ac=ac+a(i)*b(i)/float(n)
      enddo
      sd_a=sqrt(sd_a)
      sd_b=sqrt(sd_b)
      c=ac/(sd_a*sd_b)
c     
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  rms in 1D
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine rms1d(a,b,n,c)
      real a(n),b(n)
c
      c=0.
      do i=1,n
      c=c+(a(i)-b(i))*(a(i)-b(i))
      enddo
      c=sqrt(c/float(n))
c     
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  rms in time(n) and space(m) domain for the latest k yrs
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine rms2d(a,b,m,n,k,ite,c)
      real a(m,n),b(m,n)
c
      ks=ite-30-k+1
      ke=ite-30
      c=0.
      do j=ks,ke
      do i=1,m
      c=c+(a(i,j)-b(i,j))*(a(i,j)-b(i,j))/float(m*k)
      enddo
      enddo
      c=sqrt(c)
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  rms in time(n) and space(m) domain for the latest k yrs
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine rms3d(a,b,m,n,k,ite,c)
      real a(m,n,12),b(m,n,12)
c
      ks=ite-30-k+1
      ke=ite-30
      c=0.
      do j=ks,ke
      do i=1,m
      do is=1,12
      c=c+(a(i,j,is)-b(i,j,is))*(a(i,j,is)-b(i,j,is))/float(m*k*12)
      enddo
      enddo
      enddo
      c=sqrt(c)
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  find the minimum in a array
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine xmini(na,n,xout,kout)
      dimension na(n)
c
      nx=na(1)
      kk=1
      do i=2,n
      if (nx.gt.na(i)) then
        nx=na(i)
        kk=i
      endif
      enddo
      xout=float(nx)/10000.
      kout=kk
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  find the maxmum in a array
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine xmaxm(na,n,xout,kout)
      dimension na(n)
c
      nx=na(1)
      kk=1
      do i=2,n
      if (nx.lt.na(i)) then
        nx=na(i)
        kk=i
      endif
      enddo
      xout=float(nx)/10000.
      kout=kk
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  stdv of the time series
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine stdv(a,n,c)
      real a(n)
c
      avg_a=0.
      do i=1,n
        avg_a=avg_a+a(i)/float(n)
      enddo
c
      c=0.
      do i=1,n
      c=c+(a(i)-avg_a)*(a(i)-avg_a)/float(n)
      enddo
      c=sqrt(c)
c
      return
      end

      SUBROUTINE terc102(t,a,b,it3) 
c* transforms 102 temperatures into 102 terciled values 
      DIMENSION t(102),it3(102) 
      DO 11 i=1,102 
      icd=i 
      IF (t(icd).le.b)it3(i)=-1 
      IF (t(icd).ge.a)it3(i)=1 
      IF (t(icd).lt.a.and.t(icd).gt.b)it3(i)=0 
11    CONTINUE 
      RETURN 
      END 

      subroutine heidke(it1,it2,h,ss,ncd) 
      dimension it1(ncd),it2(ncd) 
      h=0. 
      tot=0. 
      do i=1,ncd
      tot=tot+1. 
      if (it1(i).eq.it2(i))h=h+1. 
      enddo 
      ss=(h-tot/3.)/(tot-tot/3.)*100. 
      return 
      end 

      subroutine heidke1(it1,it2,h,ss2,tot) 
c     subroutine heidke1(it1,it2,h,j,j1,m,tot,ict) 
      dimension it1(102),it2(102),ict(-1:2,-1:2,14) 
      h=0. 
      tot=0. 
      do i=1,102 
c     ict(it1(i),it2(i),m)=ict(it1(i),it2(i),m)+1 
c     ict(it1(i),it2(i),14)=ict(it1(i),it2(i),14)+1 
      if (it1(i).eq.0)goto 987 
      tot=tot+1. 
      if (it1(i).eq.it2(i))h=h+1. 
987   continue 
      enddo 
      ss=-9999999. 
      if (tot.gt.0)ss=(h-tot/3.)/(tot-tot/3.)*100. 
      ss2=ss*tot/102. 
c     write(6,100)h,ss,ss2,tot/102.,j,j1,m,tot 
100   format(1h ,'heidke A&B', 4f6.1,3i5,f6.0) 
      return 
      end 

      subroutine rms_k_kmax(fld3D,maxk,
     &ltime,ntprd,imax,kp,ite,ltest,xms,rms)
c
      dimension fld3D(imax,ltime,12)
      dimension fldprd(imax,ntprd,12),vrfy(imax,ntprd,12)
      dimension rms(kp),nrms(kp)
C== test different K(the length of period of avg)
C== define 30yr climate fields (31-60,41-70,51-80,61-90,71-00)
c
      DO kk=1,kp  !loop over K
c
      DO im=1,imax  ! loop over grid
c
      DO is=1,12  !season loop
C== prediction with OCN
      kt=0
      do it=31,ite  !31=1961;
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld3D(im,k,is)/float(kk)
         end do
         fldprd(im,kt,is)=avg
         vrfy(im,kt,is)=fld3D(im,it,is)
      end do

      ENDDO   !loop is
      ENDDO   !loop over im (grid)
c
C== rms calculation for the latest myr yr data
c
      myr=ltest   !with latest ltest years data
      call rms3d(fldprd,vrfy,imax,ntprd,myr,ite,rm)
      nrms(kk)=10000*rm
      rms(kk)=rm

      ENDDO   !loop over kk

      call xmini(nrms,kp,xms,maxk)
c
      return
      end
c
      subroutine acc_k_kmax(fld3D,kmax,ltime,ndec,cwmo,
     &ntprd,imax,kp,ite,ltest,xac,acc)
c
      dimension fld3D(imax,ltime,12)
      dimension fldprd(imax,ntprd,12),vrfy(imax,ntprd,12)
      dimension cwmo(ndec,imax,12),acc(kp)
      dimension nacc(kp)
C== test different K(the length of period of avg)
C== define 30yr climate fields (31-60,41-70,51-80,61-90,71-00)
c
      DO kk=1,kp  !loop over K
c
      DO im=1,imax  ! loop over grid
c
      DO is=1,12  !season loop
C== prediction with OCN
      kt=0
      do it=31,ite
         kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld3D(im,k,is)/float(kk)
         end do
         fldprd(im,kt,is)=avg
         vrfy(im,kt,is)=fld3D(im,it,is)
      end do

      ENDDO   !loop is
      ENDDO   !loop over im (grid)
c
c anom wrt cwmo
      do is=1,12

      do id=1,ndec-1
      do k=1,10
        kt=k+(id-1)*10
      do m=1,imax
        fldprd(m,kt,is)=fldprd(m,kt,is)-cwmo(id,m,is)
        vrfy(m,kt,is)=vrfy(m,kt,is)-cwmo(id,m,is)
      enddo
      enddo
      enddo

      ks=(ndec-1)*10+1
      do kt=ks,ntprd !1991-cur (at most 2000)
      do m=1,imax
        fldprd(m,kt,is)=fldprd(m,kt,is)-cwmo(ndec,m,is)
        vrfy(m,kt,is)=vrfy(m,kt,is)-cwmo(ndec,m,is)
      enddo
      enddo

      enddo !is loop
c
C== acc calculation
c
      myr=ltest   !with latest years data
      call acc3d(fldprd,vrfy,imax,ntprd,myr,ite,ac)

      nacc(kk)=10000*ac
      acc(kk)=ac

      ENDDO   !loop over kk

      call xmaxm(nacc,kp,xac,kmax)
c     write(6,*) 'xac=',xac
c
      return
      end
c
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  acc averaged over all season, all location and ALL years
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine acc3d(a,b,m,n,k,ite,ac)
      real a(m,n,12),b(m,n,12)
      real avg_a(m,12),avg_b(m,12)
      real sd_a(m,12),sd_b(m,12),acc(m,12)
c
      ks=ite-30-k+1
      ke=ite-30
c have mean
      do is=1,12
      do i=1,m
      avg_a(i,is)=0.
      avg_b(i,is)=0.
      do j=ks,ke
c       avg_a(i,is)=avg_a(i,is)+a(i,j,is)/float(k)
c       avg_b(i,is)=avg_b(i,is)+b(i,j,is)/float(k)
      enddo
      enddo
      enddo
c anom
      do is=1,12
      do j=ks,ke
      do i=1,m
      a(i,j,is)=a(i,j,is)-avg_a(i,is)
      b(i,j,is)=b(i,j,is)-avg_b(i,is)
      enddo
      enddo
      enddo
c
      do is=1,12
      do i=1,m
      sd_a(i,is)=0
      sd_b(i,is)=0
      acc(i,is)=0
      do j=ks,ke
      sd_a(i,is)=sd_a(i,is)+a(i,j,is)*a(i,j,is)/float(k)
      sd_b(i,is)=sd_b(i,is)+b(i,j,is)*b(i,j,is)/float(k)
      acc(i,is)=acc(i,is)+a(i,j,is)*b(i,j,is)/float(k)
      enddo
      enddo
      enddo
c
      do is=1,12
      do i=1,m
      sd_a(i,is)=sqrt(sd_a(i,is))
      sd_b(i,is)=sqrt(sd_b(i,is))
      acc(i,is)=acc(i,is)/(sd_a(i,is)*sd_b(i,is))
      enddo
      enddo

      ac=0.
      do is=1,12
      do i=1,m
      ac=ac+acc(i,is)/float(m*12)
      enddo
      enddo
 999  format(10f7.3)
c
      return
      end
c
      subroutine anom_wmo(fldin,fldout,ncd,nt,ntprd,ndec,clm)
      real fldin(ncd,nt),clm(ndec,ncd)
      real fldout(ncd,ntprd)
c have wmo clim
      do id=1,ndec
      do i=1,ncd
      clm(id,i)=0.
      do k=1,30
        clm(id,i)=clm(id,i)+fldin(i,k+(id-1)*10)/30.
      enddo
      enddo
      enddo
c anom w.r.t wmo clim
      do id=1,ndec-1
      do i=1,ncd
      do k=1,10
        kt=k+30+(id-1)*10
        fldout(i,kt-30)=fldin(i,kt)-clm(id,i)
      enddo
      enddo
      enddo
c
      ks=30+(ndec-1)*10+1
      do i=1,ncd
      do k=ks,nt !2011-cur (at most 2020)
        fldout(i,k-30)=fldin(i,k)-clm(ndec,i)
      enddo
      enddo

      return
      end
               
      subroutine eof_flt(grid,ngrd,ltime,ifld,nmod,nw,out)
C===========================================================
      real aaa(ngrd,ifld),wk(ifld,ngrd)
      real eval(ifld),evec(ngrd,ifld),coef(ifld,ifld)
      real pcs(nmod,ltime)
      real grid(ngrd,ltime),out(ngrd,ltime)
c
ccc feed in matrix aaa

        do it=1,ifld
        do ig=1,ngrd
          aaa(ig,it)=grid(ig,it)
        end do
        end do
c
cc... EOF analysis
      call eofs(aaa,ngrd,ifld,ifld,eval,evec,coef,wk,0)
c
cc back to grid
      do ig=1,ngrd
      do it=1,ifld
          out(ig,it)=0.
        do m=1,nmod
          out(ig,it)=out(ig,it)+coef(m,it)*evec(ig,m)
        enddo
      enddo
      enddo
c
      return
      end

