C==========================================================
C  time matching OCN indepedent of season
C==========================================================
      include "parm.h"
c     parameter(ntout=ntprd-30)
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
      real rms(kp),wrms(kp)
      real acc(kp)
      real xmac(ntprd,12)
      real xout(ntout),sout(ntout),wout(ntout),kout(ntout)
      dimension kmax(imax),kmax_t(imax,12,ntout)
      dimension kmax_t2(imax,12,ntout)
      dimension acc_t(imax,12),acc_s(ntout,12)
      dimension acc_t2(imax,12),acc_s2(ntout,12)
      dimension out(36,19)
c
      open(unit=10,form='formatted')
      open(unit=60,form='unformatted',access='direct',recl=4*36*19)
      open(unit=61,form='unformatted',access='direct',recl=4*36*19)
      open(unit=62,form='unformatted',access='direct',recl=4)

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
c
      do it=1,ntprd
      do im=1,imax
        awmo(im,it,is)=wmo(im,it)
      enddo
      enddo
c
      do id=1,ndec
      do im=1,imax
        cwmo(id,im,is)=cmean(id,im)
      enddo
      enddo
c
cc filter data for period 1931-1993
c
c anom wrt all time mean
c     call season_anom(fld3D,ltime+1,1,ltime,is,imax,clim,grid2)
c filtering with EOF
c     nw=2*ltime+15
c     call eof_flt(grid2,imax,ltime,ltime,mmax,nw,fld2D)
c back to total quantity
      do it=1,ltime
      do im=1,imax
c       fld3D2(im,it,is)=fld2D(im,it)+clim(im,is)  !filtered
        fld3D2(im,it,is)=grid(im,it)               !no filtering
      enddo
      enddo

      ENDDO  ! iseason loop
c
c loop ite from 61 to 82
c
      iw=0
      its=31  !31=1961
      DO ite=61,ltime
c
C== have OCN which is in the range of 1 -> kp
c
c have seasonally independent OCN
      if(irms.eq.1) then

      call rms_k_kmax(fld3D2,ltime,ntprd,imax,kp,its,ite,kmax)

      else

      call acc_k_kmax(fld3D2,ltime,cwmo,
     &ntprd,ndec,imax,kp,its,ite,kmax)

      endif

      do im=1,imax
      do is=1,12
        kmax_t(im,is,ite-60)=kmax(im)
      enddo
      enddo
c
 999  format(12I4)
cc write out kmax
      do is=1,12
      do im=1,imax
        wk3(im)=kmax(im)
      enddo
      iw=iw+1
      call CD102_2_2x2(wk3,out)
      write(60,rec=iw) out
      enddo

      ENDDO  !ite loop
c
c have acc and rms skill for 1991-cur period
c
      its=61
      ite=ltime
      call rms_skill(fld3D2,ltime,ntprd,imax,its,ite,kmax_t,rmsm)
      call acc_skill(fld3D2,ltime,cwmo,
     &ntprd,ndec,imax,its,ite,kmax_t,accm,acc_t,acc_s)
      write(6,*) 'skill over 1991-2012 for st dependent ocn',rmsm,accm
c skill of kmax uniformly =15
      do im=1,imax
      do is=1,12
      do it=1,ntout
        kmax_t2(im,is,it)=15
      enddo
      enddo
      enddo
      call rms_skill(fld3D2,ltime,ntprd,imax,its,ite,kmax_t2,rmsm)
      call acc_skill(fld3D2,ltime,cwmo,
     &ntprd,ndec,imax,its,ite,kmax_t2,accm,acc_t2,acc_s2)
      write(6,*) 'skill over 1991-2012 for ocn=15',rmsm,accm
cc write out acc skill in time domain
      iw=0
      do is=1,12
      do im=1,imax
        wk3(im)=acc_t(im,is)
        wk4(im)=acc_t2(im,is)
      enddo
      iw=iw+1
      call CD102_2_2x2(wk3,out)
      write(61,rec=iw) out
      iw=iw+1
      call CD102_2_2x2(wk4,out)
      write(61,rec=iw) out
      enddo
cc write out acc skill in spatial domain
      iw=0
      do it=1,ntout
      do is=1,12
        xac1=acc_s(it,is)
        xac2=acc_s2(it,is)
      iw=iw+1
      write(62,rec=iw) xac1
      iw=iw+1
      write(62,rec=iw) xac2
      enddo
      enddo
      
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
C  acc in time domain and cd
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine acc2d(a,b,m,n,k,ite,ac)
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
C  acc just in time domain
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine acc2d_t(a,b,m,n,k,ite,acc)
      real a(m,n,12),b(m,n,12)
      real acc(m,12)
      real avg_a(m,12),avg_b(m,12)
c
      ks=ite-30-k+1
      ke=ite-30
c
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
c
      do is=1,12
      do i=1,m
      do j=ks,ke
      a(i,j,is)=a(i,j,is)-avg_a(i,is)
      b(i,j,is)=b(i,j,is)-avg_b(i,is)
      enddo
      enddo
      enddo
c
      do is=1,12
      do i=1,m
      sd_a=0
      sd_b=0
      ac=0
      do j=ks,ke
      sd_a=sd_a+a(i,j,is)*a(i,j,is)/float(k)
      sd_b=sd_b+b(i,j,is)*b(i,j,is)/float(k)
      ac=ac+a(i,j,is)*b(i,j,is)/float(k)
      enddo
      sd_a=sqrt(sd_a)
      sd_b=sqrt(sd_b)

      acc(i,is)=ac/(sd_a*sd_b)
      enddo
      enddo
c     
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  acc just in spatial domain 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine acc2d_s(a,b,m,n,k,ite,acc)
      real a(m,n,12),b(m,n,12)
      real acc(k,12)
      real avg_a(n,12),avg_b(n,12)
c
      ks=ite-30-k+1
      ke=ite-30
c
      do is=1,12
      do j=ks,ke
      avg_a(j,is)=0.
      avg_b(j,is)=0.
      do i=1,m
c       avg_a(j,is)=avg_a(j,is)+a(i,j,is)/float(m)
c       avg_b(j,is)=avg_b(j,is)+b(i,j,is)/float(m)
      enddo
      enddo
      enddo
c
      do is=1,12
      do j=ks,ke
      do i=1,m
      a(i,j,is)=a(i,j,is)-avg_a(j,is)
      b(i,j,is)=b(i,j,is)-avg_b(j,is)
      enddo
      enddo
      enddo
c
      do is=1,12
      it=0
      do j=ks,ke
      sd_a=0
      sd_b=0
      ac=0
      do i=1,m
      sd_a=sd_a+a(i,j,is)*a(i,j,is)/float(m)
      sd_b=sd_b+b(i,j,is)*b(i,j,is)/float(m)
      ac=ac+a(i,j,is)*b(i,j,is)/float(m)
      enddo
      sd_a=sqrt(sd_a)
      sd_b=sqrt(sd_b)

      it=it+1
      acc(it,is)=ac/(sd_a*sd_b)
      enddo
      enddo
c     
      return
      end


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
c     do i=5,12
c     ac=ac+acc(i,is)/float(8*12)
      enddo
      enddo
 999  format(10f7.3)
c     
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  acc over a cd for a season
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine acc2d_ts(a,b,n,k,ite,ac)
      real a(n,12),b(n,12)
c
      ks=ite-30-k+1
      ke=ite-30
c have mean
      avg_a=0.
      avg_b=0.
      do j=ks,ke
c       avg_a=avg_a+a(j)/float(k)
c       avg_b=avg_b+b(j)/float(k)
      enddo
c anom
      do j=ks,ke
      do is=1,12
      a(j,is)=a(j,is)-avg_a
      b(j,is)=b(j,is)-avg_b
      enddo
      enddo
c 
      sd_a=0
      sd_b=0
      acc=0
      do j=ks,ke
      do is=1,12
      sd_a=sd_a+a(j,is)*a(j,is)/float(12*k)
      sd_b=sd_b+b(j,is)*b(j,is)/float(12*k)
      acc=acc+a(j,is)*b(j,is)/float(12*k)
      enddo
      enddo
c
      sd_a=sqrt(sd_a)
      sd_b=sqrt(sd_b)
      ac=acc/(sd_a*sd_b)

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
C  rms in time(n) and space(m) domain for the latest k yrs
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine rms2d_ts(a,b,n,k,ite,c)
      real a(n,12),b(n,12)
c
      ks=ite-30-k+1
      ke=ite-30
      c=0.
      do j=ks,ke
      do is=1,12
      c=c+(a(j,is)-b(j,is))*(a(j,is)-b(j,is))/float(12*k)
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

      subroutine acc_k_kmax(fld3D,ltime,cwmo,
     &ntprd,ndec,imax,kp,its,ite,kmax)
c
      dimension fld3D(imax,ltime,12)
      dimension fldprd(imax,ntprd,12),vrfy(imax,ntprd,12)
      dimension cwmo(ndec,imax,12),acc(kp)
      dimension nacc(kp)
      dimension kmax(imax)
      dimension wk1(ntprd,12),wk2(ntprd,12)
C== test different K(the length of period of avg)
C== define 30yr climate fields (31-60,41-70,51-80,61-90,71-00)
c
      DO im=1,imax  ! loop over grid
c
      DO kk=1,kp  !loop over K
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

c anom wrt cwmo

      do id=1,ndec-1
      do k=1,10
        kt=k+(id-1)*10
        fldprd(im,kt,is)=fldprd(im,kt,is)-cwmo(id,im,is)
        vrfy(im,kt,is)=vrfy(im,kt,is)-cwmo(id,im,is)
      enddo
      enddo
 
      ks=(ndec-1)*10+1
      do kt=ks,ntprd !1991-cur (at most 2020)
        fldprd(im,kt,is)=fldprd(im,kt,is)-cwmo(ndec,im,is)
        vrfy(im,kt,is)=vrfy(im,kt,is)-cwmo(ndec,im,is)
      enddo
      ENDDO   !loop is

c
C== acc calculation
c
      myr=ite-its+1   !with latest years data

      DO is=1,12  !season loop
      do it=1,ntprd
      wk1(it,is)=fldprd(im,it,is)
      wk2(it,is)=  vrfy(im,it,is)
      enddo
      ENDDO   !loop is

      call acc2d_ts(wk1,wk2,ntprd,myr,ite,ac)

      nacc(kk)=10000*ac
      acc(kk)=ac

      ENDDO   !loop over kk

      call xmaxm(nacc,kp,xac,kmax(im))

      ENDDO   !loop over im (grid)
c
      return
      end

      subroutine acc_skill(fld3D,ltime,cwmo,
     &ntprd,ndec,imax,its,ite,kmax,xac,acc_t,acc_s)
c
      dimension fld3D(imax,ltime,12)
      dimension fldprd(imax,ntprd,12),vrfy(imax,ntprd,12)
      dimension cwmo(ndec,imax,12)
      dimension kmax(imax,12,ntprd-30)
      dimension acc_t(imax,12)
      dimension acc_s(ntprd-30,12)
c
      DO im=1,imax  ! loop over grid
      DO is=1,12    ! season loop

C== prediction with OCN
      do it=its,ite 
         kt=it-30
         avg=0
         do k=it-kmax(im,is,it-60),it-1
         avg=avg+fld3D(im,k,is)/float(kmax(im,is,it-60))
         end do
         fldprd(im,kt,is)=avg
         vrfy(im,kt,is)=fld3D(im,it,is)
      end do

c anom wrt cwmo
      do id=1,ndec-1
      do k=1,10
        kt=k+(id-1)*10
        fldprd(im,kt,is)=fldprd(im,kt,is)-cwmo(id,im,is)
        vrfy(im,kt,is)=vrfy(im,kt,is)-cwmo(id,im,is)
      enddo
      enddo
 
      ks=(ndec-1)*10+1
      do kt=ks,ntprd !1991-cur (at most 2020)
        fldprd(im,kt,is)=fldprd(im,kt,is)-cwmo(ndec,im,is)
        vrfy(im,kt,is)=vrfy(im,kt,is)-cwmo(ndec,im,is)
      enddo

      enddo !is loop
      enddo !im loop
c
C== acc calculation
c
      myr=ite-its+1   !with latest years data
      call acc3d(fldprd,vrfy,imax,ntprd,myr,ite,xac)
      call acc2d_t(fldprd,vrfy,imax,ntprd,myr,ite,acc_t)
      call acc2d_s(fldprd,vrfy,imax,ntprd,myr,ite,acc_s)

c
      return
      end

      subroutine rms_k_kmax(fld3D,ltime,ntprd,imax,kp,
     &its,ite,kmax)
c have kmax which is independent of season
c
      dimension fld3D(imax,ltime,12)
      dimension fldprd(imax,ntprd,12),vrfy(imax,ntprd,12)
      dimension wk1(ntprd,12),wk2(ntprd,12)
      dimension rms(kp),acc(kp)
      dimension nrms(kp),nacc(kp)
      dimension kmax(imax)
C== test different K(the length of period of avg)
C== define 30yr climate fields (31-60,41-70,51-80,61-90,71-00)
c
      DO im=1,imax  ! loop over grid
c
      DO kk=1,kp  !loop over K
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

C== rms calculation 

      myr=ite-its+1   !with latest ltest years data

      DO is=1,12  !season loop
      do it=1,ntprd
      wk1(it,is)=fldprd(im,it,is)
      wk2(it,is)=  vrfy(im,it,is)
      enddo
      ENDDO   !loop is

      call rms2d_ts(wk1,wk2,ntprd,myr,ite,rm)

      nrms(kk)=10000*rm
      rms(kk)=rm

      ENDDO   !loop over kk

      call xmini(nrms,kp,xms,kmax(im))

      ENDDO   !loop im
c
      return
      end
c
      subroutine rms_skill(fld3D,ltime,ntprd,imax,
     &its,ite,kmax,xrms)
c
      dimension fld3D(imax,ltime,12)
      dimension fldprd(imax,ntprd,12),vrfy(imax,ntprd,12)
      dimension kmax(imax,12,ntprd-30)
C== test different K(the length of period of avg)
c
      DO im=1,imax  ! loop over grid
      DO is=1,12  !season loop
C== prediction with OCN
      do it=its,ite 
         kt=it-30
         avg=0
         do k=it-kmax(im,is,it-60),it-1
         avg=avg+fld3D(im,k,is)/float(kmax(im,is,it-60))
         end do
         fldprd(im,kt,is)=avg
         vrfy(im,kt,is)=fld3D(im,it,is)
      end do

      ENDDO   !loop is
      ENDDO   !loop over im (grid)
c
C== rms calculation 
c
      myr=ite-its+1   !with latest ltest years data
      call rms3d(fldprd,vrfy,imax,ntprd,myr,ite,xrms)

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

