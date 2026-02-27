CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  skill (cor & rms) of OCN prd based on PC
C==========================================================
      include "parm.h"
      real r1d1(ntprd-30)
      real r2d(imax),skill(imax),eof(imax,mmax)
      real obs(imax),prd(imax),prd2(imax)
      real obs2d(imax,ntprd),prd2d(imax,ntprd)
      real grid(imax,ltime),wmoobs(imax,ntprd)
      real wk2d(imax,ltime)
      real fld1(ltime)
      real fld2D(mmax,ltime)
      real fldprd(mmax,ntprd)
      real pcprd(mmax)
      real vrfy(mmax,ntprd)
      real wk1d1(ntprd),wk1d2(ntprd)
      real wk1d3(kp),wk1d4(kp)
      dimension wk1(30),wk2(30)
      dimension obsn(imax,ntprd),prdn(imax,ntprd)
      dimension wk3(102),wk4(102)
      dimension iwk3(102),iwk4(102)
      dimension ms(kp),kmax(ntprd,mmax)
      dimension xmac(mmax),xac(ntprd,mmax)
      dimension maxk(mmax),xmaxk(mmax)
      dimension stdk(mmax),kk(mmax)
      dimension clim(ndec,mmax)
      dimension clmg(ndec,imax)
      dimension eof_t(imax,mmax,ntprd)
      dimension ksign(mmax)
C
      real fld3D(imax,ltime+1,12)
c
      open(unit=10,form='formatted')
      open(unit=20,form='unformatted',access='direct',recl=4*imax)
      open(unit=25,form='unformatted',access='direct',recl=4*imax)
      open(unit=40,form='unformatted',access='direct',recl=4)
      open(unit=50,form='unformatted',access='direct',recl=4*imax)

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
c== seasonal anomalies
      call season_anom(fld3D,ltime+1,iseason,imax,grid)
c== anomalies wrt wmo clim for verification later
      call anom_wmo(grid,wmoobs,imax,ltime,ntprd,ndec)
C== REOF analysis for the 1931-90 period
      ifld=ltime
      nw=2*ifld+15 
      call reof_rpc(grid,imax,ltime,ifld,mmax,nw,fld2D,eof)
c
C== determine optimal K for 1961-90 period forecast
C   they are not independently determined; independent ones only after 1990
c
      do m=1,mmax
      call opt_slp_k(ts,tk,sk,mack,mrmsk,ltime,kp)fld2D,wk1d1,wk1d2,wk1d3,ms,kk(m),acx,
     &ltime,ntprd,mmax,kp,ltime,m)
      enddo
      write(6,*) 'kk for 61-90 period=',kk
C
C== predict RPCs with OCN
C
      kt=0
      do it=31,60  !31=1961; 60=1990
      kt=kt+1
      call d2_2_d3(eof,eof_t,imax,mmax,ntprd,kt) !save eofs for later use
      do m=1,mmax
         
         avg=0
         do k=it-kk(m),it-1
         avg=avg+fld2D(m,k)/float(kk(m))
         end do
         fldprd(m,kt)=avg
         vrfy(m,kt)=fld2D(m,it)
      end do ! mode
      end do ! it
c
C== from JFM1991, use optimal k determined from latest 30 year data
C== the optimal K is in the range of 1 -> kp
c
      do it=61,ltime  !61=1991;
      kt=kt+1
      ifld=it-1
      nw=2*ifld+15
      call reof_rpc(grid,imax,ltime,ifld,mmax,nw,fld2D,eof)
      call d2_2_d3(eof,eof_t,imax,mmax,ntprd,kt) !save eofs for later use
      do m=1,mmax
      call opt_k(fld2D,wk1d1,wk1d2,wk1d3,ms,kmax(it-60,m),xac(it-60,m),
     &ltime,ntprd,mmax,kp,ifld,m)
      enddo
c
      do m=1,mmax
         avg=0
         do k=it-kmax(it-60,m),it-1
         avg=avg+fld2D(m,k)/float(kmax(it-60,m))
         end do
         fldprd(m,kt)=avg
         vrfy(m,kt)=fld2D(m,it)
      end do ! mode
      end do ! it
C
C== construct obs and prd
C
      do it=1,ntprd
c
      do i=1,imax
        obs(i)=0.
        prd(i)=0.
      enddo
c
      do i=1,imax
        obs(i)=wmoobs(i,it)
      do m=1,mmax
        prd(i)=prd(i)+fldprd(m,it)*eof_t(i,m,it)
      enddo
      enddo
c
      do i=1,imax
        prd2d(i,it)=prd(i)
      enddo
      enddo !loop over time
c
c== have prd wrt its wmo clim
      do id=1,2
      do i=1,imax
      clmg(id,i)=0.
      do k=1,30
        clmg(id,i)=clmg(id,i)+prd2d(i,k+(id-1)*10)/30.
      enddo
      enddo
      enddo
      
      do i=1,imax
      do it=1,40
        prd2d(i,it)=prd2d(i,it)-clmg(1,i)
      enddo
      do it=41,ntprd
        prd2d(i,it)=prd2d(i,it)-clmg(2,i)
      enddo
      enddo
c
c==normalize prd and obs
c
      do i=1,imax
c  have stdv for 61-90
      do k=1,30
        wk1(k)=wmoobs(i,k)
        wk2(k)=prd2d(i,k)
      enddo
      call stdv(wk1,30,sdo)
      call stdv(wk2,30,sdp)
c  normalize for 61-00
      do k=1,40
        obsn(i,k)=wmoobs(i,k)/sdo
        prdn(i,k) = prd2d(i,k)/sdp
      enddo
c  have stdv for 71-00
      do k=1,30
        wk1(k)=wmoobs(i,k+10)
        wk2(k)=prd2d(i,k+10)
      enddo
      call stdv(wk1,30,sdo)
      call stdv(wk2,30,sdp)
c  normalize for 01-present
      do k=41,ntprd
        obsn(i,k)=wmoobs(i,k)/sdo
        prdn(i,k)=prd2d(i,k)/sdp
      enddo

      enddo !loop for i (1->imax)
c
cc write out normalized obs and prd
c
      do it=1,ntprd-30
      do i=1,imax
        obs(i)=obsn(i,it+30)
        prd(i)=prdn(i,it+30)
      enddo
      write(20,rec=it) obs
      write(25,rec=it) prd
      enddo
c
c= write out non-normalized obs and prd
c
      do it=1,ntprd-30
        do i=1,imax
          prd(i)=prd2d(i,it+30)
        end do
        write(50,rec=it) prd
      end do
c    
c== have Heidke skill
c
     
      a=0.4308 
      b=-0.4308 

      avghs=0
      do k=1,ntprd-30

      do i=1,imax
        wk3(i)=obsn(i,k+30)
        wk4(i)=prdn(i,k+30)
      enddo
      
      call terc102(wk3,a,b,iwk3)
      call terc102(wk4,a,b,iwk4)
        
      ximax=102.
      call heidke(iwk3,iwk4,h,hs,ximax)
      avghs=avghs+hs/float(ntprd-30)
      r1d1(k)=hs
      write(6,999) k,h,hs
 999  format(I3,3x,f6.1,3x,f6.1)
      enddo

      do it=1,ntprd-30
      write(40,rec=it) r1d1(it)
      enddo

      write(6,*) 'avg_hs=',avghs
c
      do it=1,20
        do m=1,mmax
        maxk(m)=kmax(it,m)
        enddo
      write(6,*) 'it= ',it,'  maxk= ',maxk
      enddo
      do it=1,20
        do m=1,mmax
        xmac(m)=xac(it,m)
        enddo
      write(6,777) 'it= ',it,'max ac= ',xmac
      enddo
 777  format(A5,I3,A7,6f9.4)
c
      do m=1,mmax
        xmaxk(m)=0
        do it=1,ntprd-30
        xmaxk(m)=xmaxk(m)+kmax(it,m)
        enddo
        xmaxk(m)=xmaxk(m)/float(ntprd-30)
      enddo
      write(6,*) 'avg k= ',xmaxk
      do m=1,mmax
        stdk(m)=0
        do it=1,ntprd-30
        stdk(m)=stdk(m)+(kmax(it,m)-xmaxk(m))*(kmax(it,m)-xmaxk(m))
        enddo
        stdk(m)=sqrt(stdk(m)/float(ntprd-30))
      enddo
      write(6,*) 'std of k= ',stdk
      
      stop
      end
        
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
      do 5 i=1,n-4
      avg=avg+a(i+2)/float(n-4)
  5   continue
      do 6 i=1,n-4
      a(i+2)=a(i+2)-avg
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
C  acc in time domain for the latest m yrs
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine acc_t(a,b,n,m,k,c)
      real a(n),b(n)
c
      ks=k-30-m+1  !for example, if k=60 and m=30, ks=60-30-30+1=1, ke=30
      ke=k-30      !then ke=30
      avg_a=0.
      avg_b=0.
      do i=ks,ke
        avg_a=avg_a+a(i)/float(m)
        avg_b=avg_b+b(i)/float(m)
      enddo
c
      do i=ks,ke
      a(i)=a(i)-avg_a
      b(i)=b(i)-avg_b
      enddo
c
      sd_a=0
      sd_b=0
      ac=0
      do i=ks,ke
      sd_a=sd_a+a(i)*a(i)/float(m)
      sd_b=sd_b+b(i)*b(i)/float(m)
      ac=ac+a(i)*b(i)/float(m)
      enddo
      sd_a=sqrt(sd_a)
      sd_b=sqrt(sd_b)
      c=ac/(sd_a*sd_b)
c     
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  rms in time domain for the latest m yrs
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine rms_t(a,b,n,m,k,c)
      real a(n),b(n)
c
      ks=k-30-m+1  !for example, if k=60 and m=30, ks=60-30-30+1=1, ke=30
      ke=k-30      !then ke=30
      c=0.
      do i=ks,ke
      c=c+(a(i)-b(i))*(a(i)-b(i))/float(m)
      enddo
      c=sqrt(c)
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

      subroutine heidke(it1,it2,h,ss,tot) 
c     subroutine heidke(it1,it2,h,j,j1,m,tot) 
      dimension it1(102),it2(102) 
      h=0. 
      tot=0. 
      do i=1,102 
      tot=tot+1. 
      if (it1(i).eq.it2(i))h=h+1. 
      enddo 
      ss=(h-tot/3.)/(tot-tot/3.)*100. 
c     write(6,100)h,ss,j,j1,m,tot 
100   format(1h ,2f6.1,3i5,f6.0) 
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

      subroutine opt_k(fld2D,fldprd,vrfy,score,ms,maxk,xac,
     &ltime,ntprd,mmax,kp,ite,im)
c
      dimension fld2D(mmax,ltime),fldprd(ntprd),vrfy(ntprd)
      dimension score(kp)
      dimension ms(kp),ac(kp)
C== prediction with OCN
C== test different K(the length of period of avg)
      DO kk=1,kp  !loop over K
      kt=0
      do it=31,ite !31=1961
      kt=kt+1
         avg=0
        do k=it-kk,it-1
         avg=avg+fld2D(im,k)/float(kk)
        end do
         fldprd(kt)=avg
         vrfy(kt)=fld2D(im,it)
      end do
C== acc calculation for the latest myr yr data
      myr=30
      call rms_t(fldprd,vrfy,ntprd,myr,ite,rm)
      call acc_t(fldprd,vrfy,ntprd,myr,ite,xc)
      score(kk)=rm
      ac(kk)=xc

      ENDDO   !loop over kk

C===  select optimal K
        do k=1,kp
        ms(k)=1000*score(k)
        enddo
        mms=min0(ms(1),ms(2),ms(3),ms(4),ms(5),ms(6),ms(7),ms(8),
     &ms(9),ms(10))
        mms=min0(ms(1),ms(2),ms(3),ms(4),ms(5),ms(6),ms(7),ms(8))
        xac=amax1(ac(1),ac(2),ac(3),ac(4),ac(5),ac(6),ac(7),ac(8),
     &ac(9),ac(10))
c    &ms(8),ms(9),ms(10),ms(11),ms(12),ms(13),ms(14),ms(15),ms(16),
c    &ms(17),ms(18),ms(19),ms(20),ms(21),ms(22),ms(23),ms(24),ms(25),
c    &ms(26),ms(27),ms(28),ms(29),ms(30),ms(30))
        do k=1,kp
          if (mms.eq.ms(k)) then
            maxk=k
            go to 1000
          end if
        enddo
 1000 continue
c
      return
      end

      subroutine season_anom(fld,nyear,mons,nmax,out)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. calculate seasonal anom & clim of 102 cd data
C===========================================================
      real fld(nmax,nyear,12)
      real clim(nmax,12),out(nmax,nyear-1)
c
      call setzero(clim,nmax,12)
      do m=1,12
      do ny=1,nyear-1
        do i=1,nmax
         clim(i,m)=clim(i,m)+fld(i,ny,m)/float(nyear-1)
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
      do ny=1,nyear-1
        do i=1,nmax
        out(i,ny)=(fld(i,ny,m1)+fld(i,ny+1,m2)+fld(i,ny+1,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
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
        out(i,ny)=(fld(i,ny,m1)+fld(i,ny,m2)+fld(i,ny+1,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
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
        out(i,ny)=(fld(i,ny,m1)+fld(i,ny,m2)+fld(i,ny,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
        enddo
      enddo

      END IF
c
      return
      END
c
      subroutine reof_rpc(grid,ngrd,ltime,ifld,nmod,nw,pcs,regr)
C===========================================================
      real aaa(ngrd,ifld),wk(ifld,ngrd),tt(nmod,nmod)
      real eval(ifld),evec(ngrd,ifld),coef(ifld,ifld)
      real rot(ifld),rot2(ifld)
      real pcs(nmod,ltime),regr(ngrd,nmod)
      real grid(ngrd,ltime)
c
      real weval(ifld),wevec(ngrd,ifld),wcoef(ifld,ifld)
      real reval(nmod),revec(ngrd,ifld),rcoef(nmod,ifld)
      real rwk(ngrd),rwk2(ngrd,nmod)

ccc feed in matrix aaa

        do it=1,ifld
        do ig=1,ngrd
          aaa(ig,it)=grid(ig,it)
        end do
        end do
c
cc... EOF analysis begin

      call eofs(aaa,ngrd,ifld,ifld,eval,evec,coef,wk,0)
      call REOFS(aaa,ngrd,ifld,ifld,wk,0,weval,wevec,wcoef,
     &           nmod,reval,revec,rcoef,tt,rwk,rwk2)
      call order(ngrd,ifld,nmod,reval,revec,rcoef)
c
cc have pc
      call setzero(pcs,nmod,ltime)
      do m=1,nmod
      do ir=1,ifld
        rot(ir)=rcoef(m,ir)
      enddo
      call normal(rot,ifld)
      do ir=1,ifld
        pcs(m,ir)=rot(ir)
      enddo
      enddo
c
ccc...CORR and REGR between coef and data
      DO m=1,nmod 
      do ig=1,ngrd 
      do it=1,ifld
         rot(it)=pcs(m,it)
         rot2(it)=grid(ig,it)
      enddo
         call regr_t(rot,rot2,ifld,regr(ig,m))
      enddo
      ENDDO
c
      return
      end

      SUBROUTINE normal(rot,ltime)
      DIMENSION rot(ltime)
      sd=0.
      do i=1,ltime
        sd=sd+rot(i)*rot(i)/float(ltime)
      enddo
        sd=sqrt(sd)
      do i=1,ltime
        rot(i)=rot(i)/sd
      enddo
      return
      end

      SUBROUTINE regr_t(f1,f2,ltime,reg)

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
      subroutine clim_pc(fld2D,clm,ltime,mmax,ndec)
      real fld2D(mmax,ltime),clm(ndec,mmax)
      do id=1,ndec
      do m=1,mmax
      clm(id,m)=0.
      do k=1,30
        clm(id,m)=clm(id,m)+fld2D(m,k+(id-1)*10)/30.
      enddo
      enddo
      enddo
      return
      end

      subroutine d2_2_d3(eof,eof_t,imax,mmax,ntprd,kt) !save eofs for later use
      real eof(imax,mmax),eof_t(imax,mmax,ntprd)
      do m=1,mmax
      do i=1,imax
        eof_t(i,m,kt)=eof(i,m)
      enddo
      enddo
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  using least square to have y=a+bx
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine ltrend(grid,out,out2,ncd,nt,its,ite,a,b)
      dimension grid(ncd,nt),out(ncd,nt)
      dimension out2(ncd,nt)
      dimension a(ncd),b(ncd)
      real lxx, lxy
c
      do i=1,ncd
c
      xb=0
      yb=0
      do j=its,ite
        xb=xb+float(j)/float(ite-its+1)
        yb=yb+grid(i,j)/float(ite-its+1)
      enddo
c
      lxx=0.
      lxy=0.
      do j=its,ite
      lxx=lxx+(j-xb)*(j-xb)
      lxy=lxy+(j-xb)*(grid(i,j)-yb)
      enddo
      b(i)=lxy/lxx
      a(i)=yb-b(i)*xb
      enddo !over i
c
      do i=1,ncd
      do j=1,nt
        out(i,j)=grid(i,j)-b(i)*float(j)-a(i) !detrended
        out2(i,j)=b(i)*float(j)+a(i) !trend
      enddo
      enddo
c
      return
      end
C
      subroutine anom_wmo(fldin,fldout,ncd,nt,ntprd,ndec)
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
      do k=ks,nt !2001-cur (at most 2010)
        fldout(i,k-30)=fldin(i,k)-clm(ndec,i)
      enddo
      enddo
      
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine opt_slp_k(ts1,ack,rmsk,mack,mrmsk,ltime,kp)
      dimension ts1(ltime)
      dimension ack(kp),rmsk(kp)
      dimension obs(ltime),prd(ltime)
      dimension wk(kp)
      real ms(kp),ms2(kp)
      real mms1,mms2
C== prediction with OCN
C== test different K(the length of period of avg)
      do kk=2,kp  !loop over K
      jt=0
      do it=kp+1,ltime
      jt=jt+1
      mt=0
      do kt=it-kp,it-1
      mt=mt+1
        wk(mt)=ts1(kt)
      enddo
      call slope_ext(wk,kp,kk,fcst)
         prd(kt)=fcst
         obs(kt)=ts1(it)
      end do
C== ac calculation for data
      call acc(obs,prd,ltime,kp,ack(kk))
      call rms(obs,prd,ltime,kp,rmsk(kk))
c     write(6,*) 'ac=',score

      ENDDO   !loop over kk

C===  select optimal K
        do k=2,kp
        ms(k)=ack(k)
        ms2(k)=rmsk(k)
        enddo
        mms1=AMAX1(ms(2),ms(3),ms(4),ms(5),ms(6),ms(7),
     &ms(8),ms(9),ms(10),ms(11),ms(12),ms(13),ms(14),ms(15),ms(16),
     &ms(17),ms(18),ms(19),ms(20),ms(21),ms(22),ms(23),ms(24),ms(25),
     &ms(26),ms(27),ms(28),ms(29),ms(30),ms(31),ms(32),ms(33),ms(34),
     &ms(35),ms(36),ms(37),ms(38),ms(39),ms(40),ms(41),ms(42),ms(43),
     &ms(44),ms(45),ms(46),ms(47),ms(48),ms(49),ms(50))
        mms2=AMIN1(ms2(2),ms2(3),ms2(4),ms2(5),
     &ms2(6),ms2(7),ms2(8),ms2(9),ms2(10),ms2(11),ms2(12),ms2(13),
     &ms2(14),ms2(15),ms2(16),ms2(17),ms2(18),ms2(19),ms2(20),ms2(21),
     &ms2(22),ms2(23),ms2(24),ms2(25),ms2(26),ms2(27),ms2(28),ms2(29),
     &ms2(30),ms2(31),ms2(32),ms2(33),ms2(34),ms2(35),ms2(36),ms2(37),
     &ms2(38),ms2(39),ms2(40),ms2(41),ms2(42),ms2(43),ms2(44),ms2(45),
     &ms2(46),ms2(47),ms2(48),ms2(49),ms2(50))
c
      do k=2,kp
          if (mms1.eq.ms(k)) then
            mack=k
            go to 1000
          end if
 1000 enddo
      do k=2,kp
          if (mms2.eq.ms2(k)) then
            mrmsk=k
            go to 2000
          end if
        enddo
 2000 continue
      ack(1)=999.0
      rmsk(1)=999.0
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  using least square to calculate slope and do extended forecast
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine slope_ext(y,n,m,p)
      real y(n)
      real lxx, lxy
c
      xb=0
      yb=0
      do i=1,m
        xb=xb+float(i)/float(m)
        yb=yb+y(i)/float(m)
      enddo
c
      lxx=0.
      lxy=0.
      do i=1,m
      lxx=lxx+(i-xb)*(i-xb)
      lxy=lxy+(i-xb)*(y(i)-yb)
      enddo
      b=lxy/lxx
      a=yb-b*xb
      p=a+b*(m+1)
c
      return
      end
