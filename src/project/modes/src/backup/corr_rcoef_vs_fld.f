      program correlation
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. correlation between tropical area averaged sst and global field
C===========================================================
c     PARAMETER (imax=128,jmax=64,ltime=21,mode=10)
      real fld1(imax,jmax),fld2(imax,jmax),stdv(imax,jmax)
c     real corr(imax,jmax),regr(imax,jmax),rcoef(ltime)
      real corr(imax,jmax),regr(imax,jmax),rcoef(52)
c
      open(unit=10,form='unformated',access='direct',recl=52)
c     open(unit=10,form='unformated',access='direct',recl=ltime)
      open(unit=20,form='unformated',access='direct',recl=imax*jmax)
      open(unit=30,form='unformated',access='direct',recl=imax*jmax)
c
      iwrite=1
      do 2000 m=1,mode
      call setzero(stdv,imax,jmax)
      call setzero(corr,imax,jmax)
      sd=0
      read(10,rec=m) rcoef
      write(6,*) rcoef
      do 1000 it=1,ltime
      read(20,rec=it) fld1
        do i=1,imax
        do j=1,jmax
         stdv(i,j)=stdv(i,j)+fld1(i,j)*fld1(i,j)/float(ltime)
         corr(i,j)=corr(i,j)+rcoef(it)*fld1(i,j)/float(ltime)
        enddo
        enddo
        sd=sd+rcoef(it)*rcoef(it)/float(ltime)
 1000 continue

        do i=1,imax
        do j=1,jmax
         stdv(i,j)=stdv(i,j)**0.5
        enddo
        enddo
        sd=sd**0.5

        do i=1,imax
        do j=1,jmax

         if (abs(fld1(i,j)).gt.800) then
         regr(i,j)=-999.0
         fld2(i,j)=-999.0
         else
         fld2(i,j)=corr(i,j)/(sd*stdv(i,j))
         regr(i,j)=corr(i,j)/sd
         end if

        enddo
        enddo

      write(30,rec=iwrite) fld2
      iwrite=iwrite+1
      write(6,*) 'iwrite=',iwrite
      write(30,rec=iwrite) regr
      iwrite=iwrite+1

 2000 continue
      
      stop
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
