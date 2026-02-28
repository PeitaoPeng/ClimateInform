      program GAUvsREG
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  from gausian grid to regular grid or vice versa
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

      PARAMETER (imax=96,jmax=80,imax2=72,jmax2=37)
c     PARAMETER (ltime=1*37,irun=12)
      PARAMETER (ltime=46,irun=1)
      real ygreg(37),ygr30(80),xx(imax),xx2(imax2)
      real yy(jmax),yy2(jmax2),
     %     grd1(imax,jmax),grd2(imax2,jmax2),
     %     fout(imax2,jmax2)

      data ygr30/-88.288, -86.071, -83.841, -81.607,
     &-79.373,-77.138,-74.903,-72.667,
     &-70.432,-68.196,-65.960,-63.724,-61.489,-59.253,-57.017,-54.781,
     &-52.545,-50.309,-48.073,-45.837,-43.601,-41.365,-39.130,-36.894,
     &-34.658,-32.422,-30.186,-27.950,-25.714,-23.478,-21.242,-19.006,
     &-16.770,-14.534,-12.298,-10.062, -7.826, -5.590, -3.354, -1.118,
     &  1.118,  3.354,  5.590,  7.826, 10.062, 12.298, 14.534, 16.770,
     & 19.000, 21.242, 23.478, 25.714, 27.950, 30.186, 32.422, 34.658,
     & 36.894, 39.130, 41.365, 43.601, 45.837, 48.073, 50.309, 52.545,
     & 54.781, 57.017, 59.253, 61.489, 63.724, 65.960, 68.196, 70.432,
     & 72.667, 74.903, 77.138, 79.373, 81.607, 83.841, 86.071, 88.288/
C
      ygreg(1)=-90
      do j=2,jmax2
        ygreg(j)=ygreg(j-1)+5
      end do
      DXX =360.0/float(imax)
      DXX2=360.0/float(imax2)
      CALL SETXY(XX, imax, yy ,jmax, 0.0,DXX, 0.0,0.0)
      CALL SETXY(XX2,imax2,yy2,jmax2,0.0,DXX2,0.0,0.0)
C
      do 2000 ii=1,irun
      iu=ii+10
      iuo=iu+50

      do ir=1,8
c     read(iu) grd1
      end do

      do 1000 kk=1,ltime
      read(iu)  grd1
      write(6,*)'grd1(20,20)=',grd1(20,20)
      call intp2d(grd1,imax,jmax,xx,ygr30,grd2,imax2,jmax2,xx2,ygreg,0)
      call norsou(grd2,fout,imax2,jmax2)
c     write(iuo) fout
      write(iuo) grd2
      write(6,*)'grd2(20,20)=',grd2(20,20)
 1000 continue
 2000 continue
      write(6,*)'ygreg=',ygreg
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

