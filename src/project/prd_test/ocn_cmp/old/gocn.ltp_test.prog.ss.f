C==========================================================
C  OCN forecast with changing ltp(1->30) and t(1991-2012)
C==========================================================
      include "parm.h"
      parameter(ntout=ntprd-30)
      real r1d1(ntout)
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
      dimension xkout(ltp),kmax(ltp,ntprd,12)
      dimension wk1(30),wk2(30)
      dimension obsn(imax,ntprd),prdn(imax,ntprd)
      dimension wk3(102),wk4(102)
      dimension iwk3(102),iwk4(102)
      dimension itest(10)
      real fld3D(imax,ltime+1,12),fld3D2(imax,ltime,12)
      real rms(ltp,ntout,12),acc(ltp,ntout,12),hss(ltp,ntout,12)
      real wrms(ltp,ntout,12)
      real xmac(ltp,ntprd,12)
      real xout(ltp,ntout),xout2(ltp,ntout),xout3(ltp,ntout)
      real xout4(ltp,ntout),xout5(ltp,ntout)
c
      open(unit=10,form='formatted')
      open(unit=60,form='unformatted',access='direct',recl=4*ltp*ntout)

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
cc have filtered data for period 1931-2012
c
c anom wrt all time mean
      call season_anom(fld3D,ltime+1,1,ltime,is,imax,clim,grid2)
c filtering with EOF
      nw=2*ifld+15
      call eof_flt(grid2,imax,ltime,ltime,mmax,nw,fld2D)
c back to total quantity
      do it=1,ltime
      do im=1,imax
        fld3D2(im,it,is)=fld2D(im,it)+clim(im,is)
      enddo
      enddo
c
      DO ltest=1,ltp  !ltest is the length of test period
      write(6,*) 'ltest=',ltest
c
c== prediction with OCN
c
C== from JFM1991, use optimal k determined from latest ltest (<=30) year data
C== the optimal K will be in the range of 1 -> kp

      do it=61,ltime  !61=1991; 
c
      do jt=1,it
      do im=1,imax
        fld2D(im,jt)=fld3D2(im,jt,is)
      enddo
      enddo
c
      do id=1,ndec
      do im=1,imax
        cmean(id,im)=cwmo(id,im,is)
      enddo
      enddo
c
      call opt_k(fld2D,cmean,kmax(ltest,it-60,is),
     &ltime,ntprd,imax,kp,ndec,it-1,ltest,irms)
c
      do m=1,imax
         avg=0
         do k=it-kmax(ltest,it-60,is),it-1
         avg=avg+fld3D2(m,k,is)/float(kmax(ltest,it-60,is))
         end do
         prd2d(m,it-30,is)=avg
      end do  !loop imax
      end do  ! loop it
c
c== forecast for 1961-1990 with dependnet data determined optimal K
c
      kk=kmax(ltest,1,is)
      do it=31,60  !31=1961; 60=1990
      do m=1,imax
         avg=0
         do k=it-kk,it-1
         avg=avg+fld3D2(m,k,is)/float(kk)
         end do
         prd2d(m,it-30,is)=avg
      end do  !loop m
      end do  !loop it
c
c== fcst rms & acc skill from 1991 to current year
c
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
      do id=1,3
      do i=1,imax
        clmg(id,i)=0.
      do k=1,30
c       clmg(id,i)=clmg(id,i)+prd2d(i,k+(id-1)*10,is)/30.
        clmg(id,i)=clmg(id,i)+fld3D2(i,k+30+(id-1)*10,is)/30.
      enddo
      enddo
      enddo

      do i=1,imax
      do it=1,40
        prd2d(i,it,is)=prd2d(i,it,is)-clmg(1,i)
      enddo
      do it=41,50
        prd2d(i,it,is)=prd2d(i,it,is)-clmg(2,i)
      enddo
      do it=51,ntprd
        prd2d(i,it,is)=prd2d(i,it,is)-clmg(3,i)
      enddo
      enddo
c
c==normalize prd and obs
c
      do i=1,imax
c  have stdv for 61-90
      do k=1,30
        wk1(k)=awmo(i,k,is)
        wk2(k)=prd2d(i,k,is)
      enddo
      call stdv(wk1,30,sdo)
      call stdv(wk2,30,sdp)
c  normalize for 61-00
      do k=1,40
        obsn(i,k)=awmo(i,k,is)/sdo
        prdn(i,k)=prd2d(i,k,is)/sdp
      enddo
c  have stdv for 71-00
      do k=1,30
        wk1(k)=awmo(i,k+10,is)
        wk2(k)=prd2d(i,k+10,is)
      enddo
      call stdv(wk1,30,sdo)
      call stdv(wk2,30,sdp)
c  normalize for 01-10
      do k=41,50
        obsn(i,k)=awmo(i,k,is)/sdo
        prdn(i,k)=prd2d(i,k,is)/sdp
      enddo
c  have stdv for 81-10
      do k=1,30
        wk1(k)=awmo(i,k+20,is)
        wk2(k)=prd2d(i,k+20,is)
      enddo
      call stdv(wk1,30,sdo)
      call stdv(wk2,30,sdp)
c  normalize for 01-10
      do k=51,ntprd
        obsn(i,k)=awmo(i,k,is)/sdo
        prdn(i,k)=prd2d(i,k,is)/sdp
      enddo

      enddo !loop for i (1->imax)
c    
c== have Heidke skill
c
     
      a=0.4308 
      b=-0.4308 

      do k=1,ntprd-30

      do i=1,imax
        wk3(i)=obsn(i,k+30)
        wk4(i)=prdn(i,k+30)
      enddo
      
      call terc102(wk3,a,b,iwk3)
      call terc102(wk4,a,b,iwk4)
        
      call heidke(iwk4,iwk3,h,hs,imax)

      hss(ltest,k,is)=hs

      enddo
c
      enddo  !ltest loop

      ENDDO  ! iseason loop
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
      xout4(ltest,it)=float(kmax(ltest,it,is))
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
      write(60,rec=iw) xout4

      iw=iw+1
      write(60,rec=iw) xout5

      enddo

 999  format(10f7.2)
      
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

      subroutine opt_k(fld2D,cmean,maxk,
     &ltime,ntprd,imax,kp,ndec,ite,ltest,irms)
c
      dimension fld2D(imax,ltime),fldprd(imax,ntprd),vrfy(imax,ntprd)
      dimension cmean(ndec,imax)
      dimension rms(kp),acc(kp)
      dimension nrms(kp),nacc(kp)
C== test different K(the length of period of avg)
C== define 30yr climate fields (31-60,41-70,51-80,61-90,71-00)
c
      DO kk=1,kp  !loop over K
c
      DO im=1,imax  ! loop over grid
C== prediction with OCN
      kt=0
      do it=31,ite  !31=1961;
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(im,k)/float(kk)
         end do
         fldprd(im,kt)=avg
         vrfy(im,kt)=fld2D(im,it)
      end do

      ENDDO   !loop over im (grid)
c
C== acc calculation for the latest myr yr data
c
      myr=ltest   !with latest ltest years data
      call rms2d(fldprd,vrfy,imax,ntprd,myr,ite,rm)
      call acc2d(fldprd,vrfy,imax,ntprd,myr,ite,xc)
      nrms(kk)=10000*rm
      nacc(kk)=10000*xc

      ENDDO   !loop over kk

      if(irms.eq.1) then
      call xmini(nrms,kp,xms,maxk)
      else
      call xmaxm(nacc,kp,xac,maxk)
      endif
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

