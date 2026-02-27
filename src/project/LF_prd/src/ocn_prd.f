CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C===========================================================
#include "parm.h"
C     PARAMETER (imax=128,jmax=64,ltime=50)
      real fld1(imax,jmax),fld2(imax,jmax)
      real clm1(imax,jmax),clm2(imax,jmax),clm3(imax,jmax)
      real fld3D(imax,jmax,ltime)
      real fldprd(imax,jmax,ntprd)
      real vrfy(imax,jmax,ntprd)
c
      open(unit=10,form='unformated',access='direct',recl=imax*jmax)
      open(unit=20,form='unformated',access='direct',recl=imax*jmax)
      open(unit=30,form='unformated',access='direct',recl=imax*jmax)
c     open(unit=10,form='unformated',recl=imax*jmax)
c     open(unit=20,form='unformated',recl=imax*jmax)

C== read in data
      do k=1,ltime
        read(10,rec=k) fld1
c       read(10) fld1
        do i=1,imax
        do j=1,jmax
        fld3D(i,j,k)=fld1(i,j)
        enddo
        enddo
      enddo
C== define 30yr climate fields (51-80 and 61-90 and 71-00)
        do i=1,imax
        do j=1,jmax
        clm1(i,j)=0.0
        clm2(i,j)=0.0
        clm3(i,j)=0.0
        enddo
        enddo
      do k=1,30
        do i=1,imax
        do j=1,jmax
        clm1(i,j)=clm1(i,j)+fld3D(i,j,k+1)/30.
        clm2(i,j)=clm2(i,j)+fld3D(i,j,k+11)/30.
        clm3(i,j)=clm3(i,j)+fld3D(i,j,k+21)/30.
        enddo
        enddo
      enddo
C== prediction with OCN
      kt=0
      do it=32,41  !32=1981; 41=1990
      kt=kt+1
      do i=1,imax
      do j=1,jmax
         avg=0
         do k=it-10,it-1
         avg=avg+fld3D(i,j,k)/10.
          if (abs(fld3D(i,j,k)).gt.900) then
           fldprd(i,j,kt)=-999.0 
           vrfy(i,j,kt)=-999.0 
           go to 1000
          end if
         end do
         fldprd(i,j,kt)=avg-clm1(i,j)
         vrfy(i,j,kt)=fld3D(i,j,it)-clm1(i,j)
          if (abs(fldprd(i,j,kt)).gt.900) fldprd(i,j,kt)=-999.0
          if (abs(vrfy(i,j,kt)).gt.900) vrfy(i,j,kt)=-999.0
 1000     continue
      end do
      end do
      end do

      do it=42,51  !42=1991; 51=2000
      kt=kt+1
      do i=1,imax
      do j=1,jmax
         avg=0
         do k=it-10,it-1
         avg=avg+fld3D(i,j,k)/10.
          if (abs(fld3D(i,j,k)).gt.900) then
           fldprd(i,j,kt)=-999.0 
           vrfy(i,j,kt)=-999.0 
           go to 2000
          end if
         end do
         fldprd(i,j,kt)=avg-clm2(i,j)
         vrfy(i,j,kt)=fld3D(i,j,it)-clm2(i,j)
          if (abs(fldprd(i,j,kt)).gt.900) fldprd(i,j,kt)=-999.0
          if (abs(vrfy(i,j,kt)).gt.900) vrfy(i,j,kt)=-999.0
 2000     continue
      end do
      end do
      end do

      do it=52,53  !52=2001; 53=2002
      kt=kt+1
      do i=1,imax
      do j=1,jmax
         avg=0
         do k=it-10,it-1
         avg=avg+fld3D(i,j,k)/10.
          if (abs(fld3D(i,j,k)).gt.900) then
           fldprd(i,j,kt)=-999.0 
           vrfy(i,j,kt)=-999.0 
           go to 3000
          end if
         end do
         fldprd(i,j,kt)=avg-clm3(i,j)
         vrfy(i,j,kt)=fld3D(i,j,it)-clm3(i,j)
          if (abs(fldprd(i,j,kt)).gt.900) fldprd(i,j,kt)=-999.0
          if (abs(vrfy(i,j,kt)).gt.900) vrfy(i,j,kt)=-999.0
 3000     continue
      end do
      end do
      end do
C== write out
      do k=1,ntprd
        do i=1,imax
        do j=1,jmax
          fld1(i,j)=fldprd(i,j,k)
          fld2(i,j)=vrfy(i,j,k)
        enddo
        enddo
        write(20,rec=k) fld1
        write(30,rec=k) fld2
      enddo
        write(20,rec=ntprd+1) clm1
        write(20,rec=ntprd+2) clm2
        write(20,rec=ntprd+3) clm3

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
