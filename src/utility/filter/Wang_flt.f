CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subroutine needed: fltKaylor.f
C===========================================================
      include "parm.h"
      real*4 fld1(imax,jmax),fld2(imax,jmax)
      real fld3D(imax,jmax,ltime)
      real fld3DL(imax,jmax,ltime)
      real fld3DH(imax,jmax,ltime)
      real ts1(ltime+4),yh(ltime+4),yl(ltime+4)

      open(unit=10,form='unformatted',access='direct',recl=imax*jmax*4)
      open(unit=20,form='unformatted',access='direct',recl=imax*jmax*4)
      open(unit=30,form='unformatted',access='direct',recl=imax*jmax*4)

C== read in data
      do k=1,ltime
c       read(10,888) fld1
 888  format(10f7.1)
        read(10,rec=k) fld1
c       read(10) fld1
        do i=1,imax
        do j=1,jmax
        fld3D(i,j,k)=fld1(i,j)
        fld3DL(i,j,k)=-9999.0
        fld3DH(i,j,k)=-9999.0
        enddo
        enddo
      write(6,*) 'ir=',k
      enddo
C== filtering
      do i=1,imax
      do j=1,jmax
        call setzero(ts1,ltime+4)
        do k=1,ltime
          ts1(k+2)=fld3D(i,j,k)
          if (abs(ts1(k+2)).gt.9000) go to 1000
        enddo
        nn=ltime+4
        call anom(ts1,nn)
        call msf(ltime+4,ts1,yh,yl,ph,pm,pl,fhl,dt)
        do k=1,ltime
         fld3DL(i,j,k)=yl(k+2)
         fld3DH(i,j,k)=yh(k+2)
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


