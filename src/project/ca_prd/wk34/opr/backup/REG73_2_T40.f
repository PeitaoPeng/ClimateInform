      program REG2GAU
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  from reg to gausian grid 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      include "parm.h"
      PARAMETER (imx=144,jmx=73,imx2=128,jmx2=64)
      real yy(jmx),yy2(jmx2),ygt40(jmx2),xx(imx),xx2(imx2)
      real grd1(imx,jmx),grd2(imx2,jmx2)

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
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=21,form='unformatted',access='direct',recl=4*imx2*jmx2)
      DXX =360.0/float(imx)
      DXX2=360.0/float(imx2)
      DYY =180.0/(jmx-1)
      CALL SETXY(XX, imx, YY ,jmx, 0.0, DXX, -90., DYY) !jmx=73
      CALL SETXY(XX2,imx2,yy2,jmx2,0.0,DXX2,0.0,0.0)
C
      do 1000 kk=1,ltime
      read(11,rec=kk)  grd1
      call intp2d(grd1,imx,jmx,xx,yy,grd2,imx2,jmx2,xx2,ygt40,0)

      write(21,rec=kk) grd2
 1000 continue

      stop
      END
