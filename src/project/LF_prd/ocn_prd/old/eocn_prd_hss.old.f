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
      dimension acx(mmax)
      dimension maxk(mmax),xmaxk(mmax)
      dimension stdk(mmax),kk(mmax)
      dimension clim(ndec,mmax)
      dimension clmg(ndec-3,imax)
      dimension eof_t(imax,mmax,ntprd)
      dimension rtprd(imax),rtprdn(imax)
      dimension iobs(imax,ntprd-30),iprd(imax,ntprd-30)
      dimension i1d1(imax),i1d2(imax)
      dimension hsmap(imax)
      dimension sdp(imax),sdo(imax)
      dimension wk22(ndx,ndy)
C
      real fld3D(imax,nyear,12)
c
      open(unit=10,form='formatted')
      open(unit=15,form='unformatted',access='direct',recl=4*ndx*ndy)
      open(unit=16,form='unformatted',access='direct',recl=4)

c== read in 102CD data (1931-cur)
      do ny=1,nyear
      do m=1,12
        read(10,888) obs
 888  format(10f7.1)
        do i=1,imax
          fld3D(i,ny,m)=obs(i)
        enddo
      enddo
      enddo
c== seasonal anomalies
      call season_anom(fld3D,nyear,ltime,iseason,imax,grid)
c== anomalies wrt wmo clim for verification later
      call anom_wmo(grid,wmoobs,imax,ltime,ntprd,ndec)
C== REOF analysis for the 1931-90 period
      ifld=ltime
      nw=2*ifld+15 
      call reof_rpc(grid,imax,ltime,ifld,mrot,mmax,nw,fld2D,eof)
c
C== determine optimal K for 1961-90 period forecast
C   they are not independently determined; independent ones only after 1990
c
      do m=1,mmax
      call opt_k(fld2D,kk(m),acx(m),
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
      if(acx(m).lt.-0.01) then
c        fldprd(m,kt)=0.
      else
c        fldprd(m,kt)=avg
      endif
         fldprd(m,kt)=avg
         vrfy(m,kt)=fld2D(m,it)
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
      nw=2*ifld+15
      call reof_rpc(grid,imax,ltime,ifld,mrot,mmax,nw,fld2D,eof)
      call d2_2_d3(eof,eof_t,imax,mmax,ntprd,kt) !save eofs for later use
      do m=1,mmax
      call opt_k(fld2D,kmax(it-60,m),xac(it-60,m),
     &ltime,ntprd,mmax,kp,ifld,m)
      enddo
c
      do m=1,mmax
         avg=0
         do k=it-kmax(it-60,m),it-1
         avg=avg+fld2D(m,k)/float(kmax(it-60,m))
         end do
      if(xac(it-60,m).lt.-0.01) then
         fldprd(m,kt)=0.
      else
         fldprd(m,kt)=avg
      endif
         vrfy(m,kt-1)=fld2D(m,it-1)
      end do ! mode
      end do ! it
c== for the last record of vrfy
      call reof_rpc(grid,imax,ltime,ltime,mrot,mmax,nw,fld2D,eof)
      do m=1,mmax
        vrfy(m,ntprd)=fld2D(m,ltime)
      end do
c
c== write out rpc of prd and obs
      iw=0
      do it=1,ntprd
        do m=1,mmax
        iw=iw+1
c       write(60,rec=iw) fldprd(m,it)
        iw=iw+1
c       write(60,rec=iw) vrfy(m,it)
        enddo
      enddo
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
c
      enddo !loop over time
c
c== have prd wrt its wmo clim
      do id=1,ndec-3
      do i=1,imax
      clmg(id,i)=0.
      do k=1,30
        clmg(id,i)=clmg(id,i)+prd2d(i,k+(id-1)*10)/30.
      enddo
      enddo
      enddo
      
      do i=1,imax
c
      do it=1,30  !for 1961-1990
        prd2d(i,it)=prd2d(i,it)-clmg(1,i)
      enddo
c
      do id=1,ndec-4  !for 1991->(1990+(ndec-4)*10)
      do k=1,10
        kt=30+k+(id-1)*10
        prd2d(i,kt)=prd2d(i,kt)-clmg(id,i)
      enddo
      enddo
c
      ks=30+(ndec-4)*10+1
      if(ks.gt.ntprd) go to 112
      do k=ks,ntprd ! for (1990+(ndec-4)*10+1)->current year
        prd2d(i,k)=prd2d(i,k)-clmg(ndec-3,i)
      enddo
 112  continue
c
      enddo  !for cd
c
c==normalize prd and obs
c
      do i=1,imax
c  have stdv for 1961-1990
      do k=1,30
        wk1(k)=wmoobs(i,k)
        wk2(k)=prd2d(i,k)
      enddo
      call stdv(wk1,30,sdo(i))
      call stdv(wk2,30,sdp(i))
c  normalize for 61-00
      do k=1,40
        obsn(i,k)=wmoobs(i,k)/sdo(i)
        prdn(i,k) = prd2d(i,k)/sdp(i)
      enddo
c  have stdv for 1971-2000
      do k=1,30
        wk1(k)=wmoobs(i,k+10)
        wk2(k)=prd2d(i,k+10)
      enddo
      call stdv(wk1,30,sdo(i))
      call stdv(wk2,30,sdp(i))
c  normalize for 2001-2010
      do k=41,50
        obsn(i,k)=wmoobs(i,k)/sdo(i)
        prdn(i,k)=prd2d(i,k)/sdp(i)
      enddo
c  have stdv for 1981-2010
      do k=1,30
        wk1(k)=wmoobs(i,k+20)
        wk2(k)=prd2d(i,k+20)
      enddo
      call stdv(wk1,30,sdo(i))
      call stdv(wk2,30,sdp(i))
c  normalize for 2011-present
      do k=51,ntprd
        obsn(i,k)=wmoobs(i,k)/sdo(i)
        prdn(i,k)=prd2d(i,k)/sdp(i)
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
c     write(20,rec=it) obs
c     write(25,rec=it) prd
      enddo
c
c= write out non-normalized obs and prd
c
      do it=1,ntprd-30
        do i=1,imax
          prd(i)=prd2d(i,it+30)
        end do
c       write(50,rec=it) prd
      end do
c
c== have hss time series
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
c
      do i=1,imax
        iobs(i,k)=iwk3(i)
        iprd(i,k)=iwk4(i)
      enddo
c
      call heidke(iwk3,iwk4,h,hs,imax)
      avghs=avghs+hs/float(ntprd-30)
      r1d1(k)=hs
      write(6,999) k,h,hs
 999  format(I3,3x,f6.1,3x,f6.1)
c
      enddo  !over year k
c
      write(6,*) 'avg_hs=',avghs

      do it=1,ntprd-30
      write(16,rec=it) r1d1(it)
      enddo
c
c== have hss map
c
      nss=ntprd-30
      do i=1,imax
        do k=1,nss
          i1d1(k)=iobs(i,k)
          i1d2(k)=iprd(i,k)
        enddo
        call heidke(i1d1,i1d2,h,hsmap(i),nss)
      enddo
      write(6,*) 'hss map=',hsmap
c
      do it=1,ntprd-30
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
c
c== for real time forecast
c
      do m=1,mmax
      call opt_k(fld2D,kk(m),acx(m),ltime,ntprd,mmax,kp,ltime,m) !fld2D from line 121
      enddo
      do m=1,mmax
         avg=0
         do k=ltime-kk(m)+1,ltime
         avg=avg+fld2D(m,k)/float(kk(m))
         end do
         pcprd(m)=avg
      enddo
c
      do i=1,imax
        rtprd(i)=0.
      do m=1,mmax
        rtprd(i)=rtprd(i)+pcprd(m)*eof(i,m)
      enddo
      enddo
c
      do i=1,imax
        rtprd(i)=rtprd(i)-clmg(ndec-3,i)
      enddo
      do i=1,imax
        rtprdn(i)=rtprd(i)/sdp(i)
      enddo
      write(6,*) 'rtprd=',rtprd
      write(6,*) 'rtprdn=',rtprdn
c write out prd and hsmap
      call CD102_2_2x2(rtprd,wk22)
      write(15,rec=1) wk22
      call CD102_2_2x2(rtprdn,wk22)
      write(15,rec=2) wk22
      call CD102_2_2x2(hsmap,wk22)
      write(15,rec=3) wk22
      
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

      subroutine heidke(it1,it2,h,ss,ncd) 
      dimension it1(ncd),it2(ncd) 
      h=0. 
      tot=0. 
      do i=1,ncd 
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
      myr=30
c     myr=ite-30
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
        call xmini(mr,kp,xrms,maxk)
c       call xmaxm(ma,kp,xacc,kacc)
        xac=acc(maxk)
c
      return
      end

      subroutine season_anom(fld,nyear,ltime,mons,nmax,out)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. calculate seasonal anom & clim of 102 cd data
C===========================================================
      real fld(nmax,nyear,12)
      real clim(nmax,12),out(nmax,ltime)
c
      call setzero(clim,nmax,12)
      do m=1,12
      do ny=1,ltime
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
      do ny=1,ltime
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
      do ny=1,ltime
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
      do ny=1,ltime
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
      if(ks.gt.nt) go to 111
      do i=1,ncd
      do k=ks,nt !2011-cur (at most 2020)
        fldout(i,k-30)=fldin(i,k)-clm(ndec,i)
      enddo
      enddo
      
 111  return
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

