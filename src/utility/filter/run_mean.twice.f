CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C===========================================================
#include "parm.h"
C     PARAMETER (imax=128,jmax=64,ltime=50)
      real fld1(imax,jmax),fld2(imax,jmax)
      real fld3D(imax,jmax,ltime)
      real fld3DL(imax,jmax,ltime)
      real fld3DH(imax,jmax,ltime)
      real ts1(ltime),yh(ltime),yl(ltime)
      real ts0(ltime),ts2(ltime)
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
C== filtering
      do i=1,imax
      do j=1,jmax
        call setzero(ts1,ltime)
        do k=1,ltime
          ts0(k)=fld3D(i,j,k)
          if (abs(ts0(k)).gt.900) goto 1000
        enddo
        nn=ltime
        call anom(ts0,nn)
        call runmean(ts0,ltime,ts1,np1)
        call runmean(ts1,ltime,yl,np2)
        do k=1,ltime
         fld3DL(i,j,k)=yl(k)
         fld3DH(i,j,k)=ts0(k)-yl(k)
        enddo
 1000 continue
      enddo
      enddo
C== write out
      do k=1,ltime
        do i=1,imax
        do j=1,jmax
          fld1(i,j)=fld3DL(i,j,k)
          fld2(i,j)=fld3DH(i,j,k)
        enddo
        enddo
        write(20,rec=k) fld1
        write(30,rec=k) fld2
c       write(20) fld2
      enddo
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
