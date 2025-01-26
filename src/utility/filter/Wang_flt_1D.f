CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subroutine needed: fltKaylor.f
C===========================================================
      include "parm.h"
      PARAMETER (imax=1)
      real*4 fld1(ltime)
      real*4 fld2(ltime)
      real ts1(ltime+4),yh(ltime+4),yl(ltime+4)

c     open(unit=10,form='unformated',access='direct',recl=1)
      open(unit=10,form='unformated',recl=1)
      open(unit=20,form='unformated',access='direct',recl=1)
      open(unit=30,form='unformated',access='direct',recl=1)

C== read in data
      do k=1,ltime
c       read(10,888) fld1
 888  format(10f7.1)
c       read(10,rec=k) fld1(k)
        read(10) fld1(k)
c       read(10) fld1
      enddo
C== filtering
        call setzero(ts1,ltime+4)
        do k=1,ltime
          ts1(k+2)=fld1(k)
c         if (abs(ts1(k+2)).gt.900) go to 1000
        enddo
        nn=ltime+4
        call anom(ts1,nn)
        call msf(ltime+4,ts1,yh,yl,ph,pm,pl,fhl,dt)
 1000 continue
      do k=1,ltime
        fld1(k)=yh(k+2)
        fld2(k)=yl(k+2)
      enddo
C== write out
      do k=1,ltime
        write(20,rec=k) fld1(k)
        write(30,rec=k) fld2(k)
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


