      program REG2GAU
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  from reg to gausian grid 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      include "parm.h"
      PARAMETER (imx=144,jmx=73,imx2=64,jmx2=40)
      real yy(jmx),yy2(jmx2),ygr15(jmx2),xx(imx),xx2(imx2)
      real grd1(imx,jmx),grd2(imx2,jmx2)

      data ygr15/     -86.598,-82.191,-77.758,-73.319,-68.878,-64.435,
     &-59.992,-55.549,-51.106,-46.662,-42.218,-37.774,-33.330,-28.886,
     &-24.442,-19.998,-15.554,-11.110, -6.666,-2.222,
     & 2.222,6.666,11.110,15.554,19.998,24.442,28.886,33.330,37.774,
     & 42.218,46.662,51.106,55.549,59.992,64.435,68.878,73.319,
     & 77.758,82.191,86.598/
C
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=21,form='unformatted',access='direct',recl=4*imx2*jmx2)
      DXX =360.0/float(imx)
      DXX2=360.0/float(imx2)
      DYY =180.0/(jmx-1)
      CALL SETXY(XX, imx, YY ,jmx, 0.0, DXX, -90., DYY) !jmx=73
C     CALL SETXY(XX, imx, YY ,jmx, 1.25, DXX, -88.75, DYY) !jmx=72
      CALL SETXY(XX2,imx2,yy2,jmx2,0.0,DXX2,0.0,0.0)
C
      do 1000 kk=1,ltime
      read(11,rec=kk)  grd1
      call intp2d(grd1,imx,jmx,xx,yy,grd2,imx2,jmx2,xx2,ygr15,0)

      write(21,rec=kk) grd2
 1000 continue

      stop
      END
