CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  skill of OCN prd based on RPC or other linear decomposition
C==========================================================
#include "parm.h"
      parameter(iskip=30)
      real r1d1(ltime-iskip),r1d2(ltime-iskip)  !71-30=61
      real r2d(icdmax),reof(icdmax,mmax)
      real obs(icdmax),prd(icdmax)
      real grid(icdmax,ltime),wmoobs(icdmax,ltime-iskip)
      real fld1(ltime-iskip)
      real rpc(mmax,ltime-iskip)
c
      open(unit=10,form='formated')
      open(unit=20,form='unformated',access='direct',recl=ltime)  !coef
      open(unit=50,form='unformated',access='direct',recl=icdmax)

C== read in 102 cd data
c
      do it=1,ltime
        read(10,888) r2d
        do i=1,icdmax
          grid(i,it)=r2d(i)
        enddo
      enddo
 888  format(10f7.1)
C== define 30yr climate fields (31-60,41-70,51-80,61-90 and 71-00)
      do i=1,imax
        c1=0.0
        c2=0.0
        c3=0.0
        c4=0.0
        c5=0.0
      do k=1,30
        c1=c1+grid(i,k)/30.
        c2=c2+grid(i,k+10)/30.
        c3=c3+grid(i,k+20)/30.
        c4=c4+grid(i,k+30)/30.
        c5=c5+grid(i,k+40)/30.
      enddo
c== have anomalies wrt WMO
      kt=0
      do it=31,40  !31=1961; 40=1970
      kt=kt+1
      wmoobs(i,kt)=grid(i,it)-c1
      enddo
      do it=41,50  !41=1971; 50=1980
      kt=kt+1
      wmoobs(i,kt)=grid(i,it)-c2
      enddo
      do it=51,60  !51=1981; 60=1990
      kt=kt+1
      wmoobs(i,kt)=grid(i,it)-c3
      enddo
      do it=61,70  !61=1991; 70=2000
      kt=kt+1
      wmoobs(i,kt)=grid(i,it)-c4
      enddo
      do it=71,71  !71=2001
      kt=kt+1
      wmoobs(i,kt)=grid(i,it)-c5
      enddo
      enddo  !loop for imax
C
C== read in rpc data
      do m=1,mmax
        read(20,rec=m) fld1
        do k=1,ltime-iskip
          rpc(m,k)=-fld1(k)
        end do
      end do
C
c== corr and proj with 102cd data
      do icd=1,icdmax
        do it=1,ltime-iskip           !iskip=30 is for 61 years 
          r1d1(it)=wmoobs(icd,it)     
          r1d2(it)=rpc(1,it)          !non-lag cor
        enddo
      call acc(r1d1,r1d2,ltime-iskip,ac)
      call proj(r1d1,r1d2,ltime-iskip,pj)
        prd(icd)=ac
        r2d(icd)=pj
      enddo
      write(6,888) prd
      write(6,888) r2d
      write(50) prd
      write(50) r2d

      stop
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
c
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  proj in time domain
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine proj(a,b,n,c)
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
      c=ac/(sd_b)
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
