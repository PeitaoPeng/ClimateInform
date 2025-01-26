CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  skill (cor & rms) of OCN prd based on PC
C==========================================================
      include "parm.h"
      real r1d1(ntprd-30)
      real r2d(imax),skill(imax)
      real obs(imax),prd(imax),prd2(imax)
      real obs2d(imax,ntprd),prd2d(imax,ntprd)
      real grid(imax,ltime),grid2(imax,ltime)
      real grid3(imax,ltime),wmoobs(imax,ntprd)
      real coef(mmax,ltime),fld1(ltime)
      real fld2D(imax,ltime)
      real wk2d1(imax,ntprd),wk2d2(imax,ntprd)
      real wk1d1(kp),wk1d2(kp)
      real fldin(imax)
      real clmg(ndec,imax)
      dimension wk1(30),wk2(30)
      dimension obsn(imax,ntprd),prdn(imax,ntprd)
      dimension wk3(102),wk4(102)
      dimension iwk3(102),iwk4(102)
      dimension ms(kp),kmax(ntprd)
      dimension xac(ntprd)
c
      real fld3D(imax,ltime+1,12)
c
      open(unit=10,form='formatted') !monthly cd temp or prec
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
c
c== seasonal mean
      call season_mean(fld3D,ltime+1,iseason,imax,grid)
c== anomalies wrt wmo clim for verification later
      call anom_wmo(grid,wmoobs,imax,ltime,ntprd,ndec)
c
      ifld=60
      call season_anom(fld3D,ltime+1,1,ifld,iseason,imax,grid2)
c filtering with EOF
      nw=2*ifld+15
      call eof_flt(grid2,imax,ltime,ifld,mmax,nw,fld2D)
C== prediction with OCN
      kk=kp
      do it=31,60  !31=1961; 60=1990
      do m=1,imax
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(m,k)/float(kk)
         end do
         prd2d(m,it-30)=avg
      end do  !loop m
      end do  !loop it
c
C== from JFM1991
      do it=61,ltime  !61=1991; 
c
      call season_anom(fld3D,ltime+1,1,it,iseason,imax,grid3)
c filtering with EOF
      nw=2*it+15
      call eof_flt(grid3,imax,ltime,it,mmax,nw,fld2D)
c
      do m=1,imax
c
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(m,k)/float(kk)
         end do
         prd2d(m,it-30)=avg
      end do  ! m

      end do  !it
c
c== have prd wrt obs wmo clim, because prd is not long enough to define clim forc   
c
      do id=1,ndec
      do i=1,imax
      clmg(id,i)=0.
      do k=1,30
      clmg(id,i)=clmg(id,i)+fld2D(i,k+(id-1)*10)/30.
      enddo
      enddo
      enddo
c
      do i=1,imax
      do it=1,10
        prd2d(i,it)=prd2d(i,it)-clmg(1,i)
      enddo
      do it=11,20
        prd2d(i,it)=prd2d(i,it)-clmg(2,i)
      enddo
      do it=21,30
        prd2d(i,it)=prd2d(i,it)-clmg(3,i)
      enddo
      do it=31,40
        prd2d(i,it)=prd2d(i,it)-clmg(4,i)
      enddo
      do it=41,50
        prd2d(i,it)=prd2d(i,it)-clmg(5,i)
      enddo
      do it=51,ntprd
        prd2d(i,it)=prd2d(i,it)-clmg(6,i)
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
c  normalize for 01-10
      do k=41,ntprd
        obsn(i,k)=wmoobs(i,k)/sdo
        prdn(i,k)=prd2d(i,k)/sdp
      enddo
c  have stdv for 81-10
      do k=1,30
        wk1(k)=wmoobs(i,k+20)
        wk2(k)=prd2d(i,k+20)
      enddo
      call stdv(wk1,30,sdo)
      call stdv(wk2,30,sdp)
c  normalize for 11-present
      do k=51,ntprd
        obsn(i,k)=wmoobs(i,k)/sdo
        prdn(i,k)=prd2d(i,k)/sdp
      enddo

      enddo !loop for i (1->imax)
c
c= write out normalized obs and prd
c
      do it=1,ntprd-30
        do i=1,imax
          obs(i)=obsn(i,it+30)
          prd(i)=prdn(i,it+30)
        end do
        write(20,rec=it) obs
        write(25,rec=it) prd
      end do
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
        
      call heidke(iwk4,iwk3,h,hs,imax)
      r1d1(k)=hs 
      avghs=avghs+hs/float(ntprd-30)
      write(6,999) k,h,hs
 999  format(I3,3x,f6.1,3x,f6.1)

      enddo
      do it=1,ntprd-30
      write(40,rec=it) r1d1(it)
      enddo
      write(6,*) 'avg_hs=',avghs
c
      do it=1,20
        maxk=kmax(it)
      write(6,*) 'it= ',it,'  maxk= ',maxk
      enddo
c
      do it=1,20
      write(6,*) 'it= ',it,'max ac= ',xac(it)
      enddo
      
 2000 continue
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
      subroutine season_anom(fld,nytot,nys,nyear,mons,nmax,out)
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
c       avg_a=avg_a+a(i,j)/float(m*k)
c       avg_b=avg_b+b(i,j)/float(m*k)
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

      subroutine opt_k(fld2D,fldprd,vrfy,score,ms,maxk,xac,
     &ltime,ntprd,imax,kp,ite)
c
      dimension fld2D(imax,ltime),fldprd(imax,ntprd),vrfy(imax,ntprd)
      dimension score(kp)
      dimension ms(kp),ac(kp)
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
C== acc calculation for the latest 30 yr data
c
      call rms2d(fldprd,vrfy,imax,ntprd,30,ite,rm)
      call acc2d(fldprd,vrfy,imax,ntprd,30,ite,xc)
      score(kk)=rm
      ac(kk)=xc

      ENDDO   !loop over kk

C===  select optimal K
        do k=1,kp
        ms(k)=1000*score(k)
        enddo
        mms=min0(ms(1),ms(2),ms(3),ms(4),ms(5),ms(6),ms(7),ms(8),
     &ms(9),ms(10))
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
c
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
