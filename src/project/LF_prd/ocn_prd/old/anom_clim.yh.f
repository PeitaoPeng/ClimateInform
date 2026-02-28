      program anom_clim
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. read yun_huug data and calculate seasonal anom & clim for NA region
C===========================================================
      parameter(imax=192,jmax=94)
      real fldin(imax,jmax),fld(imax,jmax,nyear,12)
      real clim(imax,jmax,12),wk(imax,jmax),fld2(imax,jmax,nyear)
      real mask(imax,jmax)
c
      open(unit=10,form='unformatted',access='direct',recl=4*imax*jmax)
      open(unit=11,form='unformatted',access='direct',recl=4*imax*jmax)
      open(unit=20,form='unformatted',access='direct',recl=4*imax*jmax)
c
c read in fld data
c
      irec=0
      do ny=1,nyear
      do mo=1,12
      irec=irec+1
      if (irec.gt.nmonth) go to 200
        read(10,rec=irec) fldin
        do i=1,imax
        do j=1,jmax
          fld(i,j,ny,mo)=fldin(i,j)
        enddo
        enddo
      enddo
      enddo
 200  continue
c
      read(11,rec=1) mask
      write(6,*) mask
c
c have seasonal clim and anom
c
      IF(mons.eq.12) THEN  !DJF
c
      call setzero(clim,imax,jmax,12)
      do m=1,12
      do i=1,imax
      do j=1,jmax
        do ny=1,nyear-1
         clim(i,j,m)=clim(i,j,m)+fld(i,j,ny,m)/float(nyear-1)
        enddo
      enddo
      end do
      end do
c     
      m1=12
      m2=1
      m3=2
c
      irec=0
      do ny=1,nyear-1
        do i=1,imax
        do j=1,jmax
        if(mask(i,j).gt.0) then
        wk(i,j)=(fld(i,j,ny,m1)+fld(i,j,ny+1,m2)+fld(i,j,ny+1,m3)-
     &         (clim(i,j,m1)+clim(i,j,m2)+clim(i,j,m3)))/3.
        else
        wk(i,j)=999.0
        endif
        enddo
        enddo
      irec=irec+1
      write(20,rec=irec) wk
      enddo

      ELSE IF (mons.eq.11) THEN !NDJ
c
      call setzero(clim,imax,jmax,12)
      do m=1,12
      do i=1,imax
      do j=1,jmax
        do ny=1,nyear-1
         clim(i,j,m)=clim(i,j,m)+fld(i,j,ny,m)/float(nyear-1)
        enddo
      enddo
      end do
      end do
c
      m1=11
      m2=12
      m3=1
c
      irec=0
      do ny=1,nyear-1
        do i=1,imax
        do j=1,jmax
        if(mask(i,j).gt.0) then
        wk(i,j)=(fld(i,j,ny,m1)+fld(i,j,ny,m2)+fld(i,j,ny+1,m3)-
     &         (clim(i,j,m1)+clim(i,j,m2)+clim(i,j,m3)))/3.
        else
        wk(i,j)=999.0
        endif
        enddo
        enddo
      irec=irec+1
      write(20,rec=irec) wk
      enddo
c 
      ELSE
c
      call setzero(clim,imax,jmax,12)
      do m=1,12
      do i=1,imax
      do j=1,jmax
        do ny=1,nyear
         clim(i,j,m)=clim(i,j,m)+fld(i,j,ny,m)/float(nyear)
        enddo
      enddo
      end do
      end do

      m1=mons      !m1=1 -> JFM;
      m2=m1+1
      m3=m2+1
c
      irec=0
      do ny=1,nyear
        do i=1,imax
        do j=1,jmax
        if(mask(i,j).gt.0) then
        wk(i,j)=(fld(i,j,ny,m1)+fld(i,j,ny,m2)+fld(i,j,ny,m3)-
     &         (clim(i,j,m1)+clim(i,j,m2)+clim(i,j,m3)))/3.
        else
        wk(i,j)=999.0
        endif
        enddo
        enddo
      irec=irec+1
      write(20,rec=irec) wk
      enddo

      END IF
c
      STOP
      END


      SUBROUTINE setzero(fld,n,m,k)
      DIMENSION fld(n,m,k)
      do i=1,n
      do j=1,m
      do l=1,k
         fld(i,j,l)=0.0
      enddo
      enddo
      enddo
      return
      end
