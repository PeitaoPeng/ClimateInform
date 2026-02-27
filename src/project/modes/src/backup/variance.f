      program expvar
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C calculate variance explained by individual reof modes
C===========================================================
      PARAMETER (imax=72,jmax=37)
      PARAMETER (ifld=ltime,nmod=20)
c     PARAMETER (lats=23,late=33,lons=31,lone=65)   !PNA(150-320)
      PARAMETER (lats=23,late=33,lons=1,lone=72)
      real fldin(imax,jmax),fld1(imax,jmax)
      real var(imax,jmax),corr(imax,jmax)
      real coef(ltime)
      real xlat(jmax),coslat(jmax)
 
      open(unit=10,form='unformated',access='direct',recl=imax*jmax)
      open(unit=20,form='unformated',access='direct',recl=ifld)
      open(unit=80,form='formated')

ccc have coslat
      xlat(1)=-90
      do j=2,jmax
       xlat(j)=xlat(j-1)+5
      end do
        
      do j=1,jmax
c       coslat(j)=sqrt(cos(xlat(j)*3.14159/180))
        coslat(j)=cos(xlat(j)*3.14159/180)
      enddo

CC.. have total var for the region (lats-late,lons-lone)
      call setzero(var,imax,jmax)
      do it = 1,ltime
      read(10) fldin
        do i=1,imax
        do j=1,jmax
        var(i,j)=var(i,j)+fldin(i,j)*fldin(i,j)/float(ltime)
        end do
        end do
      end do
      rewind(10)

        vtot=0.
        do i=lons,lone
        do j=lats,late
        vtot=vtot+coslat(j)*var(i,j)
        end do
        end do
      write(6,*) 'total var=',vtot

      
ccc...regress coef with data


      totfrac=0
      DO m=1,nmod      !loop over mode (1-20)

      call setzero(var,imax,jmax)
      call setzero(corr,imax,jmax)
      sdcf=0

        read(20) coef

      do it  =1,ltime      !loop over time
        read(10) fldin
        sdcf=sdcf+coef(it)*coef(it)/float(ltime)
        do j=1,jmax
        do i=1,imax
          corr(i,j)=corr(i,j)+coef(it)*fldin(i,j)/float(ltime)
        end do
        end do
      end do
        rewind(10)

      sdcf=sdcf**0.5
      do j=1,jmax
      do i=1,imax
        corr(i,j)=corr(i,j)/sdcf
      end do
      end do

        varm=0.
        do i=lons,lone
        do j=lats,late
        varm=varm+coslat(j)*corr(i,j)*corr(i,j)
        end do
        end do
      explv=100*varm/vtot
      totfrac=totfrac+explv

      write(6,*) 'mode',m,' var=',varm,' fraction(%)= ',
     &explv

      END DO    !loop over mode (1-6)
      write(6,*) 'total explained fraction (%)=',totfrac


      stop
      end

      SUBROUTINE setzero(fld,n,m)
      DIMENSION fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end

      SUBROUTINE normal(rot,ltime)
      DIMENSION rot(ltime)
      sd=0.
      do i=1,ltime
        sd=sd+rot(i)*rot(i)/float(ltime)
      enddo
        sd=sqrt(sd)
      do i=1,ltime
        rot(i)=rot(i)/sd
      enddo
      return
      end
