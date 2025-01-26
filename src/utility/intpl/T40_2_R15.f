      program T40toR15
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  from gausian grid to regular grid or vice versa
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
#include "parm.h"
      PARAMETER (imax=128,jmax=64,imax2=64,jmax2=40)
      real ygr15(jmax2),ygt40(jmax),xx(imax),xx2(imax2)
      real yy(jmax),yy2(jmax2),
     %     grd1(imax,jmax),grd2(imax2,jmax2),
     %     fout(imax2,jmax2)

      data ygt40/-87.864,-85.097,-82.313,-79.526,
     &-76.737,-73.948,-71.158,
     &-68.368,-65.578,-62.787,-59.997,-57.207,-54.416,-51.626,-48.835,
     &-46.045,-43.254,-40.464,-37.673,-34.883,-32.092,-29.301,-26.511,
     &-23.720,-20.930,-18.139,-15.348,-12.558,-9.767,
     &-6.977,-4.186,-1.395,
     & 1.395,  4.186,  6.977,  9.767, 12.558, 15.348, 18.139, 20.930,
     & 23.720, 26.511, 29.301, 32.092, 34.883, 37.673, 40.464, 43.254,
     & 46.045, 48.835, 51.626, 54.416, 57.207, 59.997, 62.787, 65.578,
     & 68.368, 71.158, 73.948, 76.737, 79.526, 82.313, 85.097, 87.86/
C
      data ygr15/     -86.598,-82.191,-77.758,-73.319,-68.878,-64.435,
     &-59.992,-55.549,-51.106,-46.662,-42.218,-37.774,-33.330,-28.886,
     &-24.442,-19.998,-15.554,-11.110, -6.666,-2.222,
     & 2.222,6.666,11.110,15.554,19.998,24.442,28.886,33.330,37.774,
     & 42.218,46.662,51.106,55.549,59.992,64.435,68.878,73.319,
     & 77.758,82.191,86.598/
C
      open(unit=11,form='unformated',access='direct',recl=imax*jmax)
      open(unit=61,form='unformated',access='direct',recl=imax2*jmax2)
C
      DXX =360.0/float(imax)
      DXX2=360.0/float(imax2)
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
      call intp2d(grd1,imax,jmax,xx,ygt40,grd2,imax2,jmax2,xx2,ygr15,0)
      call norsou(grd2,fout,imax2,jmax2)
c     write(iuo) fout
      write(iuo) grd2
      write(6,*)'it=',kk,'grd2(20,20)=',grd2(20,20)
 1000 continue
      write(6,*)'ygr15=',ygr15
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

