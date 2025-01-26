      program T62toR15
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  from gausian grid to regular grid or vice versa
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      include "parm.h"
      PARAMETER (imx=192,jmx=94,imx2=144,jmx2=72)
      real ygt62(jmx),xx(imx),xx2(imx2)
      real yy(jmx),yy2(jmx2),
     %     grd1(imx,jmx),grd2(imx2,jmx2),
     %     fout(imx2,jmx2)

      data ygt62/
     &-88.542,-86.653,-84.753,-82.851,-80.947,-79.043,-77.139,-75.235,
     &-73.331,-71.426,-69.522,-67.617,-65.713,-63.808,-61.903,-59.999,
     &-58.094,-56.189,-54.285,-52.380,-50.475,-48.571,-46.666,-44.761,
     &-42.856,-40.952,-39.047,-37.142,-35.238,-33.333,-31.428,-29.523,
     &-27.619,-25.714,-23.809,-21.904,-20.000,-18.095,-16.190,-14.286,
     &-12.381,-10.476, -8.571, -6.667, -4.762, -2.857, -0.952,  0.952,
     &  2.857,  4.762,  6.667,  8.571, 10.476, 12.381, 14.286, 16.190,
     & 18.095, 20.000, 21.904, 23.809, 25.714, 27.619, 29.523, 31.428, 
     & 33.333, 35.238, 37.142, 39.047, 40.952, 42.856, 44.761, 46.666,
     & 48.571, 50.475, 52.380, 54.285, 56.189, 58.094, 59.999, 61.903,
     & 63.808, 65.713, 67.617, 69.522, 71.426, 73.331, 75.235, 77.139,
     & 79.043, 80.947, 82.851, 84.753, 86.653, 88.542/
C
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=61,form='unformatted',access='direct',recl=4*imx2*jmx2)
C
      DXX =360.0/float(imx)
      DXX2=360.0/float(imx2)
      DYY2 =180.0/(jmx2)
      CALL SETXY(XX, imx, yy ,jmx, 0.0,DXX, 0.0,0.0)
      CALL SETXY(XX2,imx2,yy2,jmx2,1.25,DXX2,-88.75,DYY2)
C
      iu=11
      iuo=61
C
      do kk=1,ltime

      read(iu,rec=kk)  grd1
      call intp2d(grd1,imx,jmx,xx,ygt62,grd2,imx2,jmx2,xx2,yy2,0)
c     call norsou(grd2,fout,imx2,jmx2)
      write(iuo,rec=kk) grd2

      enddo

      stop
      END

      SUBROUTINE norsou(fldin,fldot,lon,lat)
      dimension fldin(lon,lat),fldot(lon,lat)
      do 100 j=1,lat
      do 100 i=1,lon
      fldot(i,j)=fldin(i,lat+1-j)
  100 continue
      return
      end

