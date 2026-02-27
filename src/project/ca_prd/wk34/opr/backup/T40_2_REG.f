      program GAUvsREG
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  from gausian grid to regular grid or vice versa
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      include "parm.h"
      PARAMETER (imax=128,jmax=64,imax2=144,jmax2=73)
      real ygreg(73),ygt40(64),xx(imax),xx2(imax2)
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
     & 68.368, 71.158, 73.948, 76.737, 79.526, 82.313, 85.097, 87.864/
C
      open(unit=11,form='unformatted',access='direct',recl=4*imax*jmax)
      open(unit=61,form='unformatted',access='direct',
     &recl=4*imax2*jmax2)
      ygreg(1)=-90
      do j=2,jmax2
        ygreg(j)=ygreg(j-1)+2.5
      end do
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
        read(iu,rec=is) grd1
      end do
  666 continue

      do 1000 kk=1,ltime
      read(iu,rec=kk)  grd1
      write(6,*)'grd1(20,20)=',grd1(20,20)
      call intp2d(grd1,imax,jmax,xx,ygt40,grd2,imax2,jmax2,xx2,ygreg,0)
      call norsou(grd2,fout,imax2,jmax2)
      write(iuo,rec=kk) fout
c     write(iuo) grd2
      write(6,*)'it=',kk,'grd2(20,20)=',grd2(20,20)
 1000 continue
      write(6,*)'ygreg=',ygreg
      write(6,*)'xx=',xx    
      write(6,*)'xx2=',xx2   

      stop
      END
      SUBROUTINE norsou(fldin,fldot,lon,lat)
      dimension fldin(lon,lat),fldot(lon,lat)
      do 100 j=1,lat
      do 100 i=1,lon
c     fldot(i,j)=86400*fldin(i,j)
      fldot(i,j)=fldin(i,j)
c     fldot(i,j)=fldin(i,lat+1-j)
  100 continue
      return
      end

