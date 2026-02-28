CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  count
C==========================================================
      include "parm.h"
      dimension mask(imx,jmx)
      dimension mwk1(imx,jmx),mwk2(imx,jmx)
      dimension mwk3(imx,jmx),mwk4(imx,jmx)
c
      dimension wk1(imx,jmx),wk2(imx,jmx)
      dimension wk3(imx,jmx),wk4(imx,jmx)
c
      dimension xlat(jmx),coslat(jmx)
c
      dimension fld1d1(232),fld1d2(232)
      dimension obs(3,nss),cpc(3,nss)
      dimension cf1(3,nss),cf2(3,nss)
c
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx) !mask
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx) !fcst
      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx) 
      open(unit=14,form='unformatted',access='direct',recl=4*imx*jmx) 
      open(unit=15,form='unformatted',access='direct',recl=4*imx*jmx) 
c
      open(unit=51,form='unformatted',access='direct',recl=4)
c
cc have coslat
      dl=2.
      do j=1,jmx
        xlat(j)=dl*(j-1)+20.
c       coslat(j)=COS(3.14159*xlat(j)/180)
        coslat(j)=1.
      enddo
      write(6,*) 'xlat=',xlat
      write(6,*) 'coslat=',coslat

C= read in mask
      read(11,rec=1) wk1
      call real_2_itg(wk1,mask,imx,jmx)
c
c= read in obs and prd data
      do it=1,nss
c
      read(12,rec=it) wk1
      read(13,rec=it) wk2
      read(14,rec=it) wk3
      read(15,rec=it) wk4
c
      call real_2_itg(wk1,mwk1,imx,jmx)
      call real_2_itg(wk2,mwk2,imx,jmx)
      call real_2_itg(wk3,mwk3,imx,jmx)
      call real_2_itg(wk4,mwk4,imx,jmx)
c
      call change_numb(mwk2,imx,jmx)
      call change_numb(mwk3,imx,jmx)
      call change_numb(mwk4,imx,jmx)
c
c= count three terciles in %
      call count_terc(mwk1,mask,imx,jmx,obs(1,it),obs(2,it),obs(3,it))
      call count_terc(mwk2,mask,imx,jmx,cpc(1,it),cpc(2,it),cpc(3,it))
      call count_terc(mwk3,mask,imx,jmx,cf1(1,it),cf1(2,it),cf1(3,it))
      call count_terc(mwk4,mask,imx,jmx,cf2(1,it),cf2(2,it),cf2(3,it))
c
      write(6,*) 'wk1=',wk1
      enddo !it
c
c= write out 
      write(6,*) 'obs='
      write(6,*) obs
      write(6,*) 'cpc='
      write(6,*) cpc
      write(6,*) 'cf1='
      write(6,*) cf1
      write(6,*) 'cf2='
      write(6,*) cf2
      iw=0
      do it=1,nss
c
      iw=iw+1
      write(51,rec=iw) obs(1,it)
      iw=iw+1
      write(51,rec=iw) obs(2,it)
      iw=iw+1
      write(51,rec=iw) obs(3,it)
      iw=iw+1
      write(51,rec=iw) cpc(1,it)
      iw=iw+1
      write(51,rec=iw) cpc(2,it)
      iw=iw+1
      write(51,rec=iw) cpc(3,it)
      iw=iw+1
      write(51,rec=iw) cf1(1,it)
      iw=iw+1
      write(51,rec=iw) cf1(2,it)
      iw=iw+1
      write(51,rec=iw) cf1(3,it)
      iw=iw+1
      write(51,rec=iw) cf2(1,it)
      iw=iw+1
      write(51,rec=iw) cf2(2,it)
      iw=iw+1
      write(51,rec=iw) cf2(3,it)
c    
      enddo
c
      stop
      end
        
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  real 2 integer
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine real_2_itg(wk,mw,m,n)
      dimension wk(m,n),mw(m,n)
c
      do i=1,m
      do j=1,n
      mw(i,j)=wk(i,j)
      end do
      end do
c
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  put MC hss into a bin
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine hssbin(wk,bin,m,n)
      dimension wk(m),bin(n)
c
      do j=1,n
        bin(j)=0.
      enddo
c
      bs=-21
      be=-20
      inc=1.  !increment of hs

      do j=1,n

      bs=bs+inc
      be=be+inc

      do i=1,m
        if(wk(i).gt.bs.and.wk(i).le.be) bin(j)=bin(j)+1
      enddo
c     write(6,*) 'bs&be=',bs,be
c
      end do
c
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  count the # of three categories
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine count_terc(mw,mask,m,n,ob,on,oa)
      dimension mask(m,n),mw(m,n)
c
      ob=0.
      on=0.
      oa=0.
      do i=1,m
      do j=1,n
      if(mask(i,j).eq.1) then
        if(mw(i,j).eq.-1) ob=ob+1
        if(mw(i,j).eq.0.or.mw(i,j).eq.9) on=on+1
        if(mw(i,j).eq.1) oa=oa+1
      endif
      end do
      end do
      ob=100*ob/232.
      on=100*on/232.
      oa=100*oa/232.
c
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  change num of verification to -1,0,+1,9
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine change_numb(mw,m,n)
      dimension mw(m,n)
c
      do i=1,m
      do j=1,n
      if(mw(i,j).eq.0) mw(i,j)=9
      if(mw(i,j).eq.1) mw(i,j)=-1
      if(mw(i,j).eq.2) mw(i,j)=0
      if(mw(i,j).eq.3) mw(i,j)=1
      end do
      end do
c
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  set array zero
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine setzero2(a,m,n)
      real a(m,n)
c
      do i=1,m
      do j=1,n
        a(i,j)=0.
      end do
      end do
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  set array zero
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine setzero(a,n)
      real a(n)
      do 5 i=1,n
      a(i)=0.
  5   continue
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
      subroutine acc(a,b,n,c)
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
C  rms in time domain
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine rms(a,b,n,c)
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


