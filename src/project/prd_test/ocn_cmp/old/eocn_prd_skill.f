      include "parm.h"
      parameter(ntout=ntprd-30)
      real r1d1(ntout)
      real r2d(imax),skill(imax),eof(imax,mmax)
      real obs(imax),prd(imax),prd2(imax)
      real obs2d(imax,ntprd,12),prd2d(imax,ntprd,12)
      real grid(imax,ltime),grid2(imax,ltime)
      real grid3(imax,ltime),wmoobs(imax,ntprd)
      real cwmo(ndec,imax,12),cmean(ndec,imax)
      real clim(imax,12),clmg(ndec,imax)
      real wk2d(imax,ltime)
      real fld1(ltime)
      real fld2D(mmax,ltime)
      real fldprd(mmax,ntprd,12)
      real vrfy(mmax,ntprd,12)
      real wk1d1(ntprd),wk1d2(ntprd)
      real wk1d3(kp),wk1d4(kp)
      dimension wk1(30),wk2(30)
      dimension obsn(imax,ntprd),prdn(imax,ntprd)
      dimension wk3(102),wk4(102)
      dimension iwk3(102),iwk4(102)
      dimension ms(kp),kmax(ntprd,mmax,12)
      dimension xmac(mmax),xac(ntprd,mmax)
      dimension acx(mmax)
      dimension maxk(mmax),xmaxk(mmax)
      dimension stdk(mmax),kk(mmax)
      dimension eof_t(imax,mmax,ntprd)
      dimension acc_t(imax,12),acc_s(ntout,12)
      dimension out(36,19)
C
      real fld3D(imax,ltime+1,12)
c
      open(unit=10,form='formatted')
      open(unit=60,form='unformatted',access='direct',recl=4*mmax)
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
c== seasonal mean
      call season_mean(fld3D,ltime+1,is,imax,grid)
c== anomalies wrt wmo clim for verification later
      call anom_wmo(grid,wmoobs,imax,ltime,ntprd,ndec,cmean)
c
c     ifld=ltime
      ifld=60
      call season_anom2(fld3D,ltime+1,ifld,is,imax,grid2)
c
C== REOF analysis for the 1931-90 period
      nw=2*ifld+15 
      call reof_rpc(grid2,imax,ltime,ifld,mrot,mmax,nw,fld2D,eof)
c
C== determine optimal K for 1961-90 period forecast
C   they are not independently determined; independent ones only after 1990
c
      do m=1,mmax
      if(irms.eq.1) then
      call opt_k_rms(fld2D,kk(m),acx(m),
     &ltime,ntprd,mmax,kp,ifld,m)
      else
      call opt_k_acc(fld2D,kk(m),acx(m),
     &ltime,ntprd,mmax,kp,ifld,m)
      endif
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
      if(acx(m).lt.-0.01) then
         fldprd(m,kt,is)=0.
      else
         fldprd(m,kt,is)=avg
      endif
         vrfy(m,kt,is)=fld2D(m,it)
      end do ! mode
      end do ! it
      write(6,*) 'acx=',acx
c
C== from JFM1991, use optimal k determined from latest 30 year data
C== the optimal K is in the range of 1 -> kp
c
      do it=61,ltime  !61=1991;
      kt=kt+1
      ifld=it-1
c     ifld=it
      nw=2*ifld+15
      call season_anom2(fld3D,ltime+1,it,is,imax,grid3)
      call reof_rpc(grid3,imax,ltime,ifld,mrot,mmax,nw,fld2D,eof)
      call d2_2_d3(eof,eof_t,imax,mmax,ntprd,kt) !save eofs for later use
      do m=1,mmax
      if(irms.eq.1) then
      call opt_k_rms(fld2D,kmax(it-60,m,is),xac(it-60,m),
     &ltime,ntprd,mmax,kp,ifld,m)
      else
      call opt_k_acc(fld2D,kmax(it-60,m,is),xac(it-60,m),
     &ltime,ntprd,mmax,kp,ifld,m)
      endif
      enddo
c
      do m=1,mmax
         avg=0
         do k=it-kmax(it-60,m,is),it-1
         avg=avg+fld2D(m,k)/float(kmax(it-60,m,is))
         end do
      if(xac(it-60,m).lt.-0.01) then
         fldprd(m,kt,is)=0.
      else
         fldprd(m,kt,is)=avg
      endif
         vrfy(m,kt-1,is)=fld2D(m,it-1)
      end do ! mode
      end do ! it
c
c== for the last record of vrfy
      call reof_rpc(grid3,imax,ltime,ltime,mrot,mmax,nw,fld2D,eof)
      do m=1,mmax
        vrfy(m,ntprd,is)=fld2D(m,ltime)
      end do
c filtering with EOF
      nw=2*ltime+15
      call eof_flt(grid3,imax,ltime,ltime,mmax,nw,grid2)
c
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
        prd(i)=prd(i)+fldprd(m,it,is)*eof_t(i,m,it)
      enddo
      enddo
c
      do i=1,imax
        prd2d(i,it,is)=prd(i)
        obs2d(i,it,is)=obs(i)
      enddo
c
      enddo !loop over time
c
c== have prd wrt its wmo clim
      do id=1,3
      do i=1,imax
      clmg(id,i)=0.
      do k=1,30
c       clmg(id,i)=clmg(id,i)+prd2d(i,k+(id-1)*10,is)/30.
        clmg(id,i)=clmg(id,i)+grid2(i,k+30+(id-1)*10)/30.
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

      ENDDO  ! ls loop
c
c skill of forecast
c
      its=61
      ite=ltime
      myr=ite-its+1   !with latest years data
      call rms3d(prd2d,obs2d,imax,ntprd,myr,ite,totrms)
      call acc3d(prd2d,obs2d,imax,ntprd,myr,ite,totacc)
      write(6,*) 'skill over 1991-2012',totrms,totacc
      call acc2d_t(prd2d,obs2d,imax,ntprd,myr,ite,acc_t)
      call acc2d_s(prd2d,obs2d,imax,ntprd,myr,ite,acc_s)
cc write out acc skill in time domain
      iw=0
      do is=1,12
      do im=1,imax
        wk3(im)=acc_t(im,is)
      enddo
      iw=iw+1
      call CD102_2_2x2(wk3,out)
      write(61,rec=iw) out
      write(6,*) 'wk3=',wk3
      write(6,*) 'out=',out
      enddo
cc write out acc skill in spatial domain
      iw=0
      do it=1,ntout
      do is=1,12
        xac1=acc_s(it,is)
      iw=iw+1
      write(62,rec=iw) xac1
      enddo
      enddo
cc write out OCN(K)
      iw=0
c     do it=1,ntout
      do is=1,12
      do it=1,ntout
        do m=1,mmax
        xmaxk(m)=float(kmax(it,m,is))
        enddo
      iw=iw+1
      write(60,rec=iw) xmaxk
      write(6,999) xmaxk
      enddo
      enddo
 999  format(8f7.2)

      stop
      end

c

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

      subroutine opt_k_rms(fld2D,krms,xac,
     &ltime,ntprd,mmax,kp,ite,im)
c
      dimension fld2D(mmax,ltime),fldprd(ntprd),vrfy(ntprd)
      dimension rms(kp),acc(kp)
      dimension mr(kp)
      real mma,ma(kp)
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
c     myr=30
      myr=ite-30
      call rms_t(fldprd,vrfy,ntprd,myr,ite,rm)
      call acc_t(fldprd,vrfy,ntprd,myr,ite,xc)
      rms(kk)=rm
      acc(kk)=xc

      ENDDO   !loop over kk

C===  select optimal K
        do k=1,kp
        mr(k)=10000*rms(k)
        ma(k)=10000*acc(k)
        enddo
c
        call xmini(mr,kp,xrms,krms)
c       call xmaxm(ma,kp,xacc,kacc)
c       xac=acc(krms)
        xac=xacc
c
      return
      end
      subroutine opt_k_acc(fld2D,kacc,xacc,
     &ltime,ntprd,mmax,kp,ite,im)
c
      dimension fld2D(mmax,ltime),fldprd(ntprd),vrfy(ntprd)
      dimension rms(kp),acc(kp)
      dimension mr(kp)
      real mma,ma(kp)
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
c     myr=30
      myr=ite-30
c     call rms_t(fldprd,vrfy,ntprd,myr,ite,rm)
      call acc_t(fldprd,vrfy,ntprd,myr,ite,xc)
c     rms(kk)=rm
      acc(kk)=xc

      ENDDO   !loop over kk

C===  select optimal K
        do k=1,kp
c       mr(k)=10000*rms(k)
        ma(k)=10000*acc(k)
        enddo
c
c       call xmini(mr,kp,xrms,krms)
        call xmaxm(ma,kp,xacc,kacc)
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

      subroutine season_anom2(fld,nytot,nyear,mons,nmax,out)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. calculate seasonal anom & clim of 102 cd data
C===========================================================
      real fld(nmax,nytot,12)
      real clim(nmax,12),out(nmax,nytot-1)
c
      call setzero(clim,nmax,12)
      do i=1,nmax
      do m=1,12
        do ny=1,nyear-1
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
c for history
      do ny=1,nyear-1
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
      do ny=1,nyear-1
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
      do ny=1,nyear-1
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
      subroutine reof_rpc(grid,ngrd,ltime,ifld,mrot,nmod,nw,pcs,regr)
C===========================================================
      real aaa(ngrd,ifld),wk(ifld,ngrd),tt(mrot,mrot)
      real eval(ifld),evec(ngrd,ifld),coef(ifld,ifld)
      real rot(ifld),rot2(ifld)
      real pcs(nmod,ltime),regr(ngrd,nmod)
      real grid(ngrd,ltime)
c
      real weval(ifld),wevec(ngrd,ifld),wcoef(ifld,ifld)
      real reval(mrot),revec(ngrd,ifld),rcoef(mrot,ifld)
      real rwk(ngrd),rwk2(ngrd,mrot)

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
     &           mrot,reval,revec,rcoef,tt,rwk,rwk2)
      call order(ngrd,ifld,mrot,reval,revec,rcoef)
c
cc have pc
      call setzero(pcs,nmod,ltime)
      do m=1,nmod
      do ir=1,ifld
        rot(ir)=rcoef(m,ir)
c       rot(ir)=coef(m,ir)
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
      do k=ks,nt !2001-cur (for ndec=6 at most 2020)
        fldout(i,k-30)=fldin(i,k)-clm(ndec,i)
      enddo
      enddo
      
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

