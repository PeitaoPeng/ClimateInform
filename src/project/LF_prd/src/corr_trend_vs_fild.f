      program correlation
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. correlation between tropical area averaged sst and global field
C===========================================================
c     PARAMETER (imax=72,jmax=37,ltime=52)
      real fld1(imax,jmax),fld2(imax,jmax),stdv(imax,jmax)
      real coef(imax,jmax,ltime),a1(imax,jmax),b1(imax,jmax)
      real corr(imax,jmax),regr(imax,jmax),rot(ltime)
c
      open(unit=10,form='unformated',access='direct',recl=imax*jmax)
      open(unit=20,form='unformated',access='direct',recl=imax*jmax)
      open(unit=30,form='unformated',access='direct',recl=imax*jmax)
      open(unit=40,form='unformated',access='direct',recl=imax*jmax)
c     open(unit=40,form='unformated',access='direct',recl=ltime)
c
      read(10,rec=1) a1
      read(10,rec=2) b1

c have coef
c     do i=1,imax
c     do j=1,jmax
        aa=a1(64,35)
        bb=b1(64,35)
        call normal(aa,bb,rot,ltime)
c         do it=1,ltime
c           coef(i,j,it)=rot(it)
c         end do
c     end do
c     end do
c
      call setzero(stdv,imax,jmax)
      call setzero(corr,imax,jmax)

      do 1000 it=1,ltime
      read(20,rec=it) fld1
      do i=1,imax
      do j=1,jmax
         stdv(i,j)=stdv(i,j)+fld1(i,j)*fld1(i,j)/float(ltime)
c        corr(i,j)=corr(i,j)+coef(i,j,it)*fld1(i,j)/float(ltime)
         corr(i,j)=corr(i,j)+rot(it)*fld1(i,j)/float(ltime)
      enddo
      enddo
 1000 continue

        do i=1,imax
        do j=1,jmax
         stdv(i,j)=stdv(i,j)**0.5
        enddo
        enddo

        do i=1,imax
        do j=1,jmax

         if (abs(a1(i,j)).gt.900) then
         fld2(i,j)=-999.0
         regr(i,j)=-999.0
         else
         fld2(i,j)=corr(i,j)/(stdv(i,j))
         regr(i,j)=corr(i,j)
         end if

        enddo
        enddo

      write(30,rec=1) fld2
      write(30,rec=2) regr

      do it = 1, ltime
        do i=1,imax
        do j=1,jmax
         if (abs(a1(i,j)).gt.900) then
           fld1(i,j)=-999.0
           go to 777
         end if
         fld1(i,j)=coef(i,j,it)
  777 continue
        enddo
        enddo
c     write(40,rec=it) fld1
      end do
      write(40) rot
c
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

      SUBROUTINE normal(a1,b1,rot,ltime)
      DIMENSION rot(ltime)
c construct rot with a1 and b1
      avg=0
      do i=1,ltime
        rot(i)=a1*i+b1
        avg=avg+rot(i)/ltime
      enddo
      do i=1,ltime
        rot(i)=rot(i)-avg
      enddo
c have stdv of rot
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
