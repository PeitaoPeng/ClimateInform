      program T62toT40
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  from gausian grid to regular grid or vice versa
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
#include "parm.h"
      PARAMETER (imax=192,jmax=94,imax2=128,jmax2=64)
      real ygt62(jmax),xx(imax)
      real ygt40(jmax),xx2(imax2)
      real yy(jmax),yy2(jmax2),
     %     grd1(imax,jmax),grd2(imax2,jmax2),
     %     fout(imax2,jmax2)

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
      open(unit=61,form='unformated',access='direct',recl=imax2*jmax2)
C
      DXX =360.0/float(imax)
      DXX2=360.0/float(imax2)
      DYY2 =180.0/(jmax2)
      CALL SETXY(XX, imax, yy ,jmax, 0.0,DXX, 0.0,0.0)
      CALL SETXY(XX2,imax2,yy2,jmax2,0.0,DXX2,0.0,0.0)
C
      iu=11
      iuo=61
C
      IF(iskip.lt.1) go to 666
      do is=1,iskip
        read(iu) grd1
      end do
  666 continue

      do 1000 kk=1,ltime
      read(iu)  grd1
      write(6,*)'grd1(20,20)=',grd1(20,20)
      call intp2d(grd1,imax,jmax,xx,ygt62,grd2,imax2,jmax2,xx2,ygt40,0)
      call norsou(grd2,fout,imax2,jmax2)
c     write(iuo) fout
      write(iuo) grd2
      write(6,*)'it=',kk,'grd2(20,20)=',grd2(20,20)
 1000 continue
      write(6,*)'ygt62=',ygt62
      write(6,*)'xx=',xx    
      write(6,*)'xx2=',xx2   

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

