C==========================================================
C  skill (cor & rms) of OCN prd based on PC
C==========================================================
      include "parm.h"
      real r1d1(ntprd-30)
      real r2d(imax),skill(imax)
      real obs(imax),prd(imax),prd2(imax)
      real obs2d(imax,ntprd),prd2d(imax,ntprd)
      real grid(imax,ltime),grid2(imax,ltime)
      real grid3(imax,ltime),grid4(imax,ltime)
      real grid5(imax,ltime),wmoobs(imax,ntprd)
      real wk2d(imax,ltime)
      real fld1(ltime)
      real wk1d1(ntprd),wk1d2(ntprd)
      dimension wk1(30),wk2(30)
      dimension obsn(imax,ntprd),prdn(imax,ntprd)
      dimension wk3(imax),wk4(imax)
      dimension iwk3(imax),iwk4(imax)
      dimension clmg(ndec,imax)
      dimension wk22(ndx,ndy)
C
      real fld3D(imax,ltime+1,12)
      real sstin(1,ltime+1,12),sst1(ltime),sst2(ltime)
      real sst3(ntprd),trend(ltime)
      real regr(imax,ntprd),corr(imax,ntprd)
      real rsdf(imax,ltime)
c
      open(unit=10,form='formatted') !monthly cd temp
      open(unit=11,form='unformatted',access='direct',recl=4) !monthly nino34
c
      open(unit=20,form='unformatted',access='direct',recl=4*imax)
      open(unit=25,form='unformatted',access='direct',recl=4*imax)
      open(unit=40,form='unformatted',access='direct',recl=4)
      open(unit=50,form='unformatted',access='direct',recl=4*imax)
      open(unit=60,form='unformatted',access='direct',recl=4)
      open(unit=61,form='unformatted',access='direct',recl=4*ndx*ndy)

c== read in 102CD data (1931-cur)
      do ny=1,ltime+1
      do m=1,12
        read(10,888) obs
 888  format(10f7.1)
 555  format(10f7.2)
        do i=1,imax
          fld3D(i,ny,m)=obs(i)
        enddo
      enddo
      enddo
c== read in monthly nino34(1931.1-2010.5)
      ir=0
      do ny=1,ltime+1
      if(ny.le.ltime) then
        do m=1,12
        ir=ir+1
        read(11,rec=ir) sstin(1,ny,m)
        enddo
      else
        do m=1,5
        ir=ir+1
        read(11,rec=ir) sstin(1,ny,m)
        enddo
      endif
      enddo
      write(6,*) 'nino34 record=',ir
c
c== seasonal mean
      call season_mean(fld3D,ltime+1,iseason,imax,grid)
c== anomalies wrt wmo clim for verification later
      call anom_wmo(grid,wmoobs,imax,ltime,ntprd,ndec)
c
      call setzero(grid,imax,ltime)
      ifld=61
      call season_anom(fld3D,ltime+1,nys,ifld,iseason,imax,grid2)
      call season_anom(sstin,ltime+1,nys,ifld,iseason,1,sst1)
c filtering with EOF
      nw=2*ifld+15
      call eof_flt(grid2,imax,ltime,ifld,mmax,nw,grid)
C
C== regress nino34 to temp
c
      do it=31,60  !31=1961;
C
      call setzero(grid2,imax,ltime)
c== have anom wrt 11-year running mean
      call hp_flt(sst1,sst2,1,ltime,nys,it-1)
      call hp_flt(grid,grid2,imax,ltime,nys,it-1)
c== regr nino34 to temp and normalize nino34
      do i=1,imax
        do jt=1,ltime
          fld1(jt)=grid(i,jt)
        enddo
        call regr_nino(sst1,fld1,sst3(it-30),ltime,1,it-1,
     &regr(i,it-30),corr(i,it-30))
      enddo
c
      end do  !it
c
      do it=61,ltime  !31=1961;
c
c== have updated anom wrt past climate
      call season_anom(fld3D,ltime+1,nys,it,iseason,imax,grid2)
      call season_anom(sstin,ltime+1,nys,it,iseason,1,sst1)
c filtering with EOF
      nw=it
      call eof_flt(grid2,imax,ltime,ifld,mmax,nw,grid)
C
c== have anom wrt 11-year running mean
      call hp_flt(sst1,sst2,1,ltime,nys,it-1)
      call hp_flt(grid,grid3,imax,ltime,nys,it-1)
c== regr nino34 to temp and normalize nino34
      do i=1,imax
        do jt=1,ltime
          fld1(jt)=grid(i,jt)
        enddo
        call regr_nino(sst1,fld1,sst3(it-30),ltime,1,it-1,
     &regr(i,it-30),corr(i,it-30))
      enddo
c
      end do  !it
      write(6,*) 'sst3=',sst3
c
c== write out prd and obs
      iw=0
      do it=1,ntprd
        iw=iw+1
        write(60,rec=iw) sst3(it)
        iw=iw+1
        write(60,rec=iw) sst1(it+30)
      enddo
c== write out enso regr & corr
      iw=0
      do it=1,ntprd
        do i=1,imax
          wk3(i)=regr(i,it)
          wk4(i)=corr(i,it)
        enddo
        iw=iw+1
        call CD102_2_2x2(wk3,wk22)
        write(61,rec=iw) wk22
        iw=iw+1
        call CD102_2_2x2(wk4,wk22)
        write(61,rec=iw) wk22
      enddo
C
C== construct obs and prd
C
      do it=1,ntprd
c
      do i=1,imax
        prd2d(i,it)=sst3(it)*regr(i,it)
      enddo
c
      enddo !loop over time
c
c== normalize prd and obs wrt 61-90 & 71-00 clim period stdv
      call normal_prd(prd2d,imax,ntprd,prdn)
      call normal_obs(wmoobs,imax,ntprd,obsn)
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
c= write out non-normalized prd
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
c== see the acc and rms between spatial patterns of regr
      iw=0
      do it=1,ntprd
      
      do ic=1,imax
        wk3(ic)=regr(ic,it)
        wk4(ic)=regr(ic,ntprd)
      enddo

      call acc_s(wk3,wk4,imax,ac)
      call rms_s(wk3,wk4,imax,rm)

      iw=iw+1
      write(60,rec=iw) ac
      iw=iw+1
      write(60,rec=iw) rm

      enddo
      
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

      subroutine opt_k(fld2D,maxk,xac,
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
        mms=min0(ms(1),ms(2),ms(3),ms(4),ms(5),ms(6),ms(7),ms(8))
        xac=amax1(ac(1),ac(2),ac(3),ac(4),ac(5),ac(6),ac(7),ac(8))
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
C  have anom wrt 11-yr runing mean
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine hp_flt(fld,out,ncd,nt,its,ite)
      dimension fld(ncd,nt),out(ncd,nt)
c
      do i=1,ncd
c
      do j=its+5,ite-5
        avg=0.
        do k=j-5,j+5
          avg=avg+fld(i,k)/11.
        enddo
        out(i,j)=fld(i,j)-avg
        js=its+5
        je=ite-5
        if(j.eq.js) avgs=avg
        if(j.eq.je) avge=avg
      enddo !j
c
      do j=1,5
        out(i,its+j-1)=fld(i,its+j-1)-avgs
        out(i,ite+j-5)=fld(i,ite+j-5)-avge
      enddo !j
        out(i,ite+1)=fld(i,ite+1)-avge
c
      enddo !i
c
      return
      end
c
      SUBROUTINE normal(rot,ltime)
      DIMENSION rot(ltime)
c
      avg=0
      do i=1,ltime
      avg=avg+rot(i)/float(ltime)
      enddo
      do i=1,ltime
      rot(i)=rot(i)-avg
      enddo
c
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
C
      SUBROUTINE regr_nino(f1,f2,f3,ltime,its,ite,reg,cor)

      real f1(ltime),f2(ltime)
c
      nt=ite-its+1
c
      v1=0.
      v2=0.
      do it=its,ite
      v1=v1+f1(it)/float(nt)
      v2=v2+f2(it)/float(nt)
      enddo

      cor=0.
      sd1=0.
      sd2=0.
      do it=its,ite
         cor=cor+(f1(it)-v1)*(f2(it)-v2)/float(nt)
         sd1=sd1+(f1(it)-v1)*(f1(it)-v1)/float(nt)
         sd2=sd2+(f2(it)-v2)*(f2(it)-v2)/float(nt)
      enddo
c
      sd1=sd1**0.5
      sd2=sd2**0.5
      reg=cor/(sd1)
      cor=cor/(sd1*sd2)
c
      f3=(f1(ite+1)-v1)/sd1
c
      return
      end
c
      SUBROUTINE index_rsd(f1,f2,ncd,nt,f3,f4)
cc f1 must be normalized

      real f1(nt),f2(ncd,nt)
      real f3(ncd,nt),f4(ncd,nt)
      real reg(ncd)
c
      do i=1,ncd
c
      cor=0.
      sd1=0.
      sd2=0.
      do it=1,nt
         cor=cor+f1(it)*f2(i,it)/float(nt)
         sd1=sd1+f1(it)*f1(it)/float(nt)
      enddo

      sd1=sd1**0.5
      reg(i)=cor/(sd1)
c
      enddo
c
      do i=1,ncd
      do it=1,nt
        f3(i,it)=f2(i,it)-f1(it)*reg(i)
        f4(i,it)=f1(it)*reg(i)
      enddo
      enddo

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
c
c== normalize prd with respect to std of 61-90 & 71-00
c
      subroutine normal_prd(prd2d,imax,ntprd,prdn)
c
      real prd2d(imax,ntprd)
      real clmg(imax,2),prdn(imax,ntprd),wk(30)
c== have prd wrt its own wmo clim
      do id=1,2
      do i=1,imax
      clmg(i,id)=0.
      do k=1,30
        clmg(i,id)=clmg(i,id)+prd2d(i,k+(id-1)*10)/30.
      enddo
      enddo
      enddo
c     
      do i=1,imax
      do it=1,40
c     do it=31,40
        prd2d(i,it)=prd2d(i,it)-clmg(i,1)
      enddo
      do it=41,ntprd
        prd2d(i,it)=prd2d(i,it)-clmg(i,2)
      enddo
      enddo
c
c== normalize prd
c
      do i=1,imax
c  have stdv for 61-90
      do k=1,30
        wk(k)=prd2d(i,k)
      enddo
      call stdv(wk,30,sdp)
c  normalize for 61-00
      do k=1,40
        prdn(i,k) = prd2d(i,k)/sdp
      enddo
c  have stdv for 71-00
      do k=1,30
        wk(k)=prd2d(i,k+10)
      enddo
      call stdv(wk,30,sdp)
c  normalize for 01-present
      do k=41,ntprd
        prdn(i,k)=prd2d(i,k)/sdp
      enddo

      enddo !loop for i (1->imax)
c
      return
      end
c
c== normalize wmoobs with respect to std of 61-90 & 71-00
c
      subroutine normal_obs(wmoobs,imax,ntprd,obsn)
c
      real wmoobs(imax,ntprd)
      real obsn(imax,ntprd),wk(30)
c     
c==normalize wmoobs
c
      do i=1,imax
c  have stdv for 61-90
      do k=1,30
        wk(k)=wmoobs(i,k)
      enddo
      call stdv(wk,30,sdo)
c  normalize for 61-00
      do k=1,40
        obsn(i,k)=wmoobs(i,k)/sdo
      enddo
c  have stdv for 71-00
      do k=1,30
        wk(k)=wmoobs(i,k+10)
      enddo
      call stdv(wk,30,sdo)
c  normalize for 01-present
      do k=41,ntprd
        obsn(i,k)=wmoobs(i,k)/sdo
      enddo

      enddo !loop for i (1->imax)
c
      return
      end
c
      subroutine combine_2(prd1,prd2,imax,ntprd,w1,prd3)
c
      real prd1(imax,ntprd),prd2(imax,ntprd)
      real prd3(imax,ntprd)
c
      w2=1.-w1
      do k=1,ntprd
      do i=1,imax
        prd3(i,k)=w1*prd1(i,k)+w2*prd2(i,k)
      enddo
      enddo
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  acc for spatial pattern
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine acc_s(a,b,n,c)
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
C  rms
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine rms_s(a,b,n,c)
      real a(n),b(n)
c
      c=0.
      do i=1,n
      c=c+(a(i)-b(i))*(a(i)-b(i))/float(n)
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

