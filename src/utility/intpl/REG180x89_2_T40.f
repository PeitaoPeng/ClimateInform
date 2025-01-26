      program REG2GAU
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  from reg to gausian grid 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
#include "parm.h"
      PARAMETER (imax=180,jmax=89,imax2=128,jmax2=64)
      real yy(jmax),yy2(jmax2),ygt40(jmax2),xx(imax),xx2(imax2)
      real grd1(imax,jmax),grd2(imax2,jmax2)
      real grd(imax,jmax)
      COMMON /COMASK/ DEFLT,MASK(imax,jmax)

      data ygt40/-87.864,-85.097,-82.313,-79.526,-76.737,-73.948,
     &-71.158,
     &-68.368,-65.578,-62.787,-59.997,-57.207,-54.416,-51.626,-48.835,
     &-46.045,-43.254,-40.464,-37.673,-34.883,-32.092,-29.301,-26.511,
     &-23.720,-20.930,-18.139,-15.348,-12.558,-9.767,-6.977,-4.186,
     &-1.395,
     &  1.395,  4.186,  6.977,  9.767, 12.558, 15.348, 18.139, 20.930,
     & 23.720, 26.511, 29.301, 32.092, 34.883, 37.673, 40.464, 43.254,
     & 46.045, 48.835, 51.626, 54.416, 57.207, 59.997, 62.787, 65.578,
     & 68.368, 71.158, 73.948, 76.737, 79.526, 82.313, 85.097, 87.86/
C
      open(unit=11,form='unformated',access='direct',recl=imax*jmax)
      open(unit=15,form='unformated',access='direct',recl=imax*jmax)
      open(unit=21,form='unformated',access='direct',recl=imax2*jmax2)
      DXX =360.0/float(imax)
      DXX2=360.0/float(imax2)
      DYY =180.0/(jmax+1)
      CALL SETXY(XX, imax, YY ,jmax, 0.0, DXX, -88., DYY) !jmax=89
C     CALL SETXY(XX, imax, YY ,jmax, 1.25, DXX, -88.75, DYY) !jmax=72
      CALL SETXY(XX2,imax2,yy2,jmax2,0.0,DXX2,0.0,0.0)
C
      read(15) MASK
      DEFLT=-99.99
C
      IF(iskip.lt.1) go to 666
      do is=1,iskip
        read(11) grd1
      end do
  666 continue

      do 1000 kk=1,ltime
      read(11)  grd1
      call intp2d(grd1,imax,jmax,xx,yy,grd2,imax2,jmax2,xx2,ygt40,1)
      write(21) grd2
      write(6,*)'t=',kk
 1000 continue
c     write(6,*) grd2

      stop
      END
     
      subroutine shift(fld1,fld2,imax,jmax)
      real fld1(imax,jmax),fld2(imax,jmax)
      imaxh=imax/2
      do i=1,imaxh
      do j=1,jmax
        fld2(i,j)=fld1(imaxh+i,j)/9.8
        fld2(i+imaxh,j)=fld1(i,j)/9.8
      end do
      end do
      return
      end
