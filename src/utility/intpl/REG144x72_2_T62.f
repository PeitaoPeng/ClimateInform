      program G722T62
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  from gausian grid to regular grid or vice versa
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      include "parm.h"
      PARAMETER (imax2=192,jmax2=94,imax=144,jmax=72)
      real ygt62(jmax2),xx(imax),xx2(imax2)
      real yy(jmax),yy2(jmax2),
     %     grd1(imax,jmax),grd2(imax2,jmax2),
     %     fout(imax2,jmax2),mask(imax2,jmax2)

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
      open(unit=11,form='unformatted',access='direct',recl=4*imax*jmax)
      open(unit=21,form='unformatted',access='direct',
     &recl=4*imax2*jmax2)
      open(unit=61,form='unformatted',access='direct',
     &recl=4*imax2*jmax2)
C
      DXX =360.0/float(imax)
      DXX2=360.0/float(imax2)
      DYY =180.0/(jmax)
      CALL SETXY(XX,imax,yy,jmax,1.25,DXX, -88.75,DYY)
      CALL SETXY(XX2,imax2,yy2,jmax2,0.0,DXX2,0.0,0.0)
C
      iu=11
      iuo=61
C
c     IF(iskip.lt.1) go to 666
c     do is=1,iskip
c       read(iu,rec=is) grd1
c     end do
  666 continue
      read(21,rec=1) mask

      do 1000 kk=1,ltime
      read(iu,rec=kk)  grd1
      write(6,*)'grd1(20,20)=',grd1(20,20)
      call intp2d(grd1,imax,jmax,xx,yy,grd2,imax2,jmax2,xx2,ygt62,0)
cc use land mask
      do i=1,imax2
      do j=1,jmax2
c       if(mask(i,j).eq.1) then
c       grd2(i,j)=-999.0
c       endif
      enddo
      enddo
      call norsou(grd2,fout,imax2,jmax2)
c     write(iuo,rec=kk) fout
      write(iuo,rec=kk) grd2
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

