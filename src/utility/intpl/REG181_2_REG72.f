      program REG2REG
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  from 360x181 to 144x73 grid 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      include "parm.h"
      PARAMETER (imx=360,jmx=181,imx2=144,jmx2=72)
      real yy(jmx),yy2(jmx2),xx(imx),xx2(imx2)
      real grd1(imx,jmx),grd2(imx2,jmx2)
C
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=21,form='unformatted',access='direct',recl=4*imx2*jmx2)
      DXX =360.0/float(imx)
      DXX2=360.0/float(imx2)
      DYY =180.0/(jmx-1)
      DYY2 =180.0/(jmx2)
      CALL SETXY(XX, imx, YY ,jmx, 0.0, DXX, -90., DYY) !jmx=181
      CALL SETXY(XX2,imx2,yy2,jmx2,0.0,DXX2,-88.75,DYY2) !jmx=72
C
      do 1000 kk=1,ltime
      read(11,rec=kk)  grd1

      call intp2d(grd1,imx,jmx,xx,yy,grd2,imx2,jmx2,xx2,yy2,0)

      write(21,rec=kk) grd2
 1000 continue

      stop
      END
