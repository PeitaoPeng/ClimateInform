CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  skill of OCN prd based on RPC or other linear decomposition
C==========================================================
#include "parm.h"
      parameter(iskip=20)
      real r1d1(ltime-iskip),r1d2(ltime-iskip)  !71-20=51
      real r2d(icdmax),reof(icdmax,mmax)
      real obs(icdmax),prd(icdmax)
      real t3d(icdmax,ltime)
      real fld1(ltime)
      real t1d(ltime)
      real rpc(mmax,ltime)
c
      open(unit=10,form='formated')
      open(unit=20,form='unformated',access='direct',recl=ltime)  !rcoef
      open(unit=40,form='unformated',access='direct',recl=ltime)  !Tsfc(SE)
      open(unit=50,form='unformated',access='direct',recl=icdmax)

C== read in 102 cd data
      do it=1,ltime
        read(10,888) r2d
      do i=1,icdmax
        t3d(i,it)=r2d(i)
      enddo
      enddo
 888  format(10f7.1)
C
C== read in rpc 2 data
      do m=1,mmax
        read(20,rec=m) fld1
      do k=1,ltime
        rpc(m,k)=-fld1(k)
      end do
      end do
C
C== avg SE-US to have a 1-D time series
      do it=1,ltime
        t1d(it)=(t3d(56,it)+t3d(57,it)+t3d(58,it))/3.
      enddo
c
c== normalize t1d
      var=0.
      do it=1,ltime
        var=var+t1d(it)**2
      enddo
      stdv=sqrt(var/ltime)
      do it=1,ltime
        t1d(it)=t1d(it)/stdv
      enddo
c
      write(40) t1d
      write(40) t1d !twice write for matching rcoef2 in time
c
      do it=1,ltime
        fld1(it)=rpc(2,it)
      enddo
c
      call acc(fld1,t1d,ltime,ac)
      write(6,*) 'corr(rpc2 vs t1d)=',ac
c== lagged corr of 102 cd vs rpc
      do icd=1,icdmax
        do it=1,ltime-iskip           !iskip=20 is for 51 years 
          r1d1(it)=t3d(icd,it+iskip)  !t3d from 1951
c         r1d2(it)=rpc(1,it+iskip)    !non-lag cor
          r1d2(it)=rpc(2,it+iskip-1)  !iskip-1 is for one year lag
c         r1d2(it)=t1d(it+iskip-1)      !t1d from 1950
        enddo
        call acc(r1d1,r1d2,ltime-iskip,ac)
c       call proj(r1d1,r1d2,ltime-iskip,pj)
        prd(icd)=ac
c       prd(icd)=pj
      enddo
      write(6,888) prd
      write(50) prd
c     write(50) r2d

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
