CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C OCN based on REOFs or other linear decompositions
C===========================================================
#include "parm.h"
      parameter(kp=30)
      real fld1(ltime)
      real fld2D(mmax,ltime)
      real fldprd(ntprd)
      real vrfy(ntprd)
      real score1(kp),score2(kp)
c
      open(unit=10,form='unformated',access='direct',recl=ltime)
      open(unit=20,form='formated')

C== read in data
      do m=1,mmax
        read(10,rec=m) fld1
      do k=1,ltime
        fld2D(m,k)=fld1(k)
      enddo
      enddo
C== loop over mode
      do m=1,mmax
C== define 30yr climate fields (51-80 and 61-90 and 71-00)
        clm1=0.0
        clm2=0.0
        clm3=0.0
      do k=1,30
        clm1=clm1+fld2D(m,k+1)/30.
        clm2=clm2+fld2D(m,k+11)/30.
        clm3=clm3+fld2D(m,k+21)/30.
      enddo
      clim2=clim1
      clim3=clim1
C== prediction with OCN
C== test different K(the length of period of avg)
      do kk=1,kp  !loop over K
      kt=0
      do it=32,41  !32=1981; 41=1990
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(m,k)/float(kk)
         end do
         fldprd(kt)=avg-clm1
         vrfy(kt)=fld2D(m,it)-clm1
      end do

      do it=42,51  !42=1991; 51=2000
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(m,k)/float(kk)
         end do
         fldprd(kt)=avg-clm2
         vrfy(kt)=fld2D(m,it)-clm2
      end do

      do it=52,53  !52=2001; 53=2002
      kt=kt+1
         avg=0
         do k=it-kk,it-1
         avg=avg+fld2D(m,k)/float(kk)
         end do
         fldprd(kt)=avg-clm3
         vrfy(kt)=fld2D(m,it)-clm3
      end do
C== acc calculation
      call acc(fldprd,vrfy,ntprd,ac)
      call rms(fldprd,vrfy,ntprd,rm)
      score1(kk)=ac
      score2(kk)=rm
      ENDDO   !loop over K
      write(20,*) 'acc'
      write(20,999) score1
      write(20,*) 'rms'
      write(20,999) score2
 999  format(5x,10f6.2)

      ENDDO   !loop over mode

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

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  acc in time domain
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine acc(a,b,n,c)
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

