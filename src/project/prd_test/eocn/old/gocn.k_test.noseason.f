C==========================================================
C  OCN obtained with dependent data
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
      dimension wk1(30),wk2(30)
      dimension obsn(imax,ntprd),prdn(imax,ntprd)
      dimension wk3(102),wk4(102)
      dimension iwk3(102),iwk4(102)
      dimension itest(10)
      real fld3D(imax,ltime+1,12),fld3D2(imax,ltime,12)
      real rms(kp)
      real wrms(ntout,12)
      real xmac(ntprd,12)
      real xout(ntout),xout2(ntout),xout3(ntout)
      real xout4(ntout),xout5(ntout)
c
      open(unit=10,form='formatted')
      open(unit=60,form='unformatted',access='direct',recl=4*kp)

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

      ENDDO  ! iseason loop
c
C== have OCN which will be in the range of 1 -> kp

      its=31  !31=1961
      ite=82
c
c have seasonally independent OCN
      call rms_k_kmax(fld3D2,ltime,ntprd,imax,kp,its,ite,rms,kmax)
      write(6,*) 'kmax=',kmax
      write(6,999) rms
c
c write out
c
      iw=0
c
      iw=iw+1
      write(60,rec=iw) rms

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
        avg_a=avg_a+a(i)/float(n)
        avg_b=avg_b+b(i)/float(n)
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

      subroutine rms_k_kmax(fld3D,ltime,ntprd,imax,kp,its,ite,rms,kmax)
c
      dimension fld3D(imax,ltime,12)
      dimension fldprd(imax,ntprd,12),vrfy(imax,ntprd,12)
      dimension rms(kp),acc(kp)
      dimension nrms(kp),nacc(kp)
C== test different K(the length of period of avg)
C== define 30yr climate fields (31-60,41-70,51-80,61-90,71-00)
c
      DO kk=1,kp  !loop over K
c
      DO im=1,imax  ! loop over grid
c
      DO is=1,12  !season loop
C== prediction with OCN
      do it=its,ite 
         kt=it-30
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
      myr=ite-its+1   !with latest ltest years data
      call rms3d(fldprd,vrfy,imax,ntprd,myr,ite,rm)

      nrms(kk)=10000*rm
      rms(kk)=rm

      ENDDO   !loop over kk

      call xmini(nrms,kp,xms,kmax)
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

