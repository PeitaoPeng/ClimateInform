      program REG2GAU
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  from reg to gausian grid 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
#include "parm.h"
      PARAMETER (imax=720,jmax=361,imax2=144,jmax2=73)
      real yy(jmax),yy2(jmax2),xx(imax),xx2(imax2)
      real grd1(imax,jmax),grd2(imax2,jmax2)
C
      open(unit=11,form='unformatted',access='direct',recl=imax*jmax)
c     open(unit=11,form='unformatted',recl=imax*jmax)
      open(unit=21,form='unformatted',access='direct',recl=imax2*jmax2)
      DXX =360.0/float(imax)
      DXX2=360.0/float(imax2)
      DYY =180.0/(jmax-1)
      DYY2 =180.0/(jmax2-1)
      CALL SETXY(XX, imax, YY ,jmax, 0.0, DXX, -90., DYY) !jmax=73
      CALL SETXY(XX2,imax2,yy2,jmax2,0.0,DXX2,-90.,DYY2) !jmax=37
C
      IF(iskip.lt.1) go to 666
      do is=1,iskip
        read(11) grd1
      end do
  666 continue

      do 1000 kk=1,ltime
      read(11)  grd1
      call intp2d(grd1,imax,jmax,xx,yy,grd2,imax2,jmax2,xx2,yy2,0)

      write(21) grd2
 1000 continue

      stop
      END
