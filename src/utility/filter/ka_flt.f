CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subroutine needed: fltKaylor.f
C===========================================================
#include "parm.h"
C     PARAMETER (imax=128,jmax=64,ltime=50)
      real fld1(imax,jmax),fld2(imax,jmax)
     &        ,fld3D(imax,jmax,ltime)
      real ts1(ltime),ts2(ltime)

      open(unit=10,form='unformated',access='direct',recl=imax*jmax)
      open(unit=20,form='unformated',access='direct',recl=imax*jmax)

C== read in data
      do k=1,ltime
        read(10,rec=k) fld1
        do i=1,imax
        do j=1,jmax
        fld3D(i,j,k)=fld1(i,j)
        enddo
        enddo
      enddo
C== filtering
      do i=1,imax
      do j=1,jmax
        do k=1,ltime
          ts1(k)=fld3D(i,j,k)
          if (abs(ts1(k)).gt.100) go to 1000
        enddo
        call FLTM(ts1,ts2,pr1,pr2,ipass)
        do k=1,ltime
         fld3D(i,j,k)=ts2(k)
        enddo
 1000 continue
      enddo
      enddo
C== write out
      do k=1,ltime
        do i=1,imax
        do j=1,jmax
          fld1(i,j)=fld3D(i,j,k)
        enddo
        enddo
        write(20,rec=k) fld1
      enddo
      stop
      end
        


