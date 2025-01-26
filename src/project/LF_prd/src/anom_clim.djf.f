      program anom_clim
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. calculate seasonal anom & clim of 102 cd data
C===========================================================
      parameter(nyear=72,nmax=102)
      real fldin(nmax),fld(nmax,nyear,12)
      real clim(nmax,12),wk(nmax),fld2(nmax,nyear)
c
      open(unit=10,form='formated')
c     open(unit=20,form='unformated',access='direct',recl=nmax)
c     open(unit=30,form='unformated',access='direct',recl=nmax)
      open(unit=40,form='formated')
      open(unit=50,form='formated')
c read in fld data
      do ny=1,nyear
      do m=1,12
        read(10,888) fldin
 888  format(10f7.1)
        do i=1,nmax
          fld(i,ny,m)=fldin(i)
        enddo
      enddo
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
C===== JF of the 1st year
        do i=1,nmax
        wk(i)=(fld(i,1,1)+fld(i,1,2)-clim(i,1)-clim(i,2))/2.
        enddo
      write(40,888) wk
c
C===== DJF of the flowing years
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
      enddo
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
