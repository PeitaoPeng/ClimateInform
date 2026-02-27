      program anom_clim
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. calculate seasonal anom & clim of 102 cd data
C===========================================================
C     parameter(nyear=73)
      parameter(nmax=102)
      real fldin(nmax),fld(nmax,nyear,12)
      real ann(nmax,nyear)
      real clim(nmax,12),wk(nmax),fld2(nmax,nyear)
c
      open(unit=10,form='formatted')
      open(unit=40,form='formatted')
      open(unit=45,form='unformatted',access='direct',recl=4*102)
      open(unit=50,form='unformatted',access='direct',recl=4)
      open(unit=51,form='unformatted',access='direct',recl=4)
      open(unit=60,form='unformatted',access='direct',recl=4)
c read in fld data
      iw=0
      do ny=1,nyear
      do m=1,12
        read(10,888) fldin
 888  format(10f7.1)
      call cd_avg(fldin,nmax,avg)
      iw=iw+1
      write(50,rec=iw) avg
        do i=1,nmax
          fld(i,ny,m)=fldin(i)
        enddo
      enddo
      enddo
c
      call ann_avg(fld,nmax,nyear,ann)
      do j=1,nyear
        do i=1,nmax
        fldin(i)=ann(i,j)
        enddo
        call cd_avg(fldin,nmax,avg)
        write(51,rec=j) avg
      enddo

      call setzero(clim,nmax,12)
      do m=1,12
      do ny=1,nyear-1
        do i=1,nmax
         clim(i,m)=clim(i,m)+fld(i,ny,m)/float(nyear-1)
        enddo
      end do
      end do
c
c have seasonal mean
c
      iw=0
      IF(mons.eq.12) THEN
      
      m1=12
      m2=1
      m3=2
c
      do ny=1,nyear-1
        do i=1,nmax
        wk(i)=(fld(i,ny,m1)+fld(i,ny+1,m2)+fld(i,ny+1,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
        enddo
      write(40,888) wk
      call cd_avg(wk,nmax,avg)
      iw=iw+1
      write(45,rec=iw) wk
      write(60,rec=iw) avg
      enddo

      ELSE IF (mons.eq.11) THEN 
c

      m1=11
      m2=12
      m3=1
c
      do ny=1,nyear-1
        do i=1,nmax
        wk(i)=(fld(i,ny,m1)+fld(i,ny,m2)+fld(i,ny+1,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
        enddo
      write(40,888) wk
      call cd_avg(wk,nmax,avg)
      iw=iw+1
      write(45,rec=iw) wk
      write(60,rec=iw) avg
      enddo
c 
      ELSE

      m1=mons      !m1=1 -> JFM;
      m2=m1+1
      m3=m2+1
c
      do ny=1,nyear-1
        do i=1,nmax
        wk(i)=(fld(i,ny,m1)+fld(i,ny,m2)+fld(i,ny,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
        enddo
      write(40,888) wk
      call cd_avg(wk,nmax,avg)
      iw=iw+1
      write(45,rec=iw) wk
      write(60,rec=iw) avg
      enddo

      END IF
c
cc write out climate
c
      do m=1,12
        do i=1,nmax
          wk(i)=(clim(i,m1)+clim(i,m2)+clim(i,m3))/3.
c         wk(i)=clim(i,m)
        enddo
c     write(40,888) wk
      enddo
c
      STOP
      END


      SUBROUTINE setzero(fld,n,m)
      DIMENSION fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end
c
      SUBROUTINE cd_avg(fld,n,avg)
      DIMENSION fld(n)
      avg=0.
      do i=1,n
        avg=avg+ fld(i)/float(n)
      enddo
      return
      end
c
      SUBROUTINE ann_avg(fld,n,m,avg)
      DIMENSION fld(n,m,12),avg(n,m)
      do i=1,n
      do j=1,m
         avg(i,j)=0.
       do k=1,12
        avg(i,j)=avg(i,j)+fld(i,j,k)/12.
       enddo
      enddo
      enddo
      return
      end
