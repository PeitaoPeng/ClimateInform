      program REG2GAU
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  from reg to gausian grid 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
#include "parm.h"
      PARAMETER (imax=144,jmax=73,imax2=64,jmax2=40)
      real yy(jmax),yy2(jmax2),ygr15(jmax2),xx(imax),xx2(imax2)
      real grd1(imax,jmax),grd2(imax2,jmax2)

      data ygr15/     -86.598,-82.191,-77.758,-73.319,-68.878,-64.435,
     &-59.992,-55.549,-51.106,-46.662,-42.218,-37.774,-33.330,-28.886,
     &-24.442,-19.998,-15.554,-11.110, -6.666,-2.222,
     & 2.222,6.666,11.110,15.554,19.998,24.442,28.886,33.330,37.774,
     & 42.218,46.662,51.106,55.549,59.992,64.435,68.878,73.319,
     & 77.758,82.191,86.598/
C
      open(unit=11,form='unformated',access='direct',recl=imax*jmax)
      open(unit=21,form='unformated',access='direct',recl=imax2*jmax2)
      DXX =360.0/float(imax)
      DXX2=360.0/float(imax2)
      DYY =180.0/(jmax-1)
      CALL SETXY(XX, imax, YY ,jmax, 0.0, DXX, -90., DYY) !jmax=73
c     CALL SETXY(XX, imax, YY ,jmax, 1.25, DXX, -88.75, DYY) !jmax=72
      CALL SETXY(XX2,imax2,yy2,jmax2,0.0,DXX2,0.0,0.0)
C
      IF(iskip.lt.1) go to 666
      do is=1,iskip
        read(11) grd1
      end do
  666 continue

      do 1000 kk=1,ltime
      read(11)  grd1
      call intp2d(grd1,imax,jmax,xx,yy,grd2,imax2,jmax2,xx2,ygr15,0)

      write(21) grd2
 1000 continue

      stop
      END
