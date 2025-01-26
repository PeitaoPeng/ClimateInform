      program correlation
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. correlation between tropical area averaged sst and global field
C===========================================================
c     PARAMETER (imax=128,jmax=64,ltime=52)
      real fld1(imax,jmax),fld2(imax,jmax),stdv(imax,jmax)
      real coef(ltime),sst(imax,jmax)
      real corr(imax,jmax),regr(imax,jmax)
      character*95 fln1,fln2,fln3,fln4

C--------+---------+---------+---------+---------+---------+---------+---------+
      open(10,form='unformated',access='direct',recl=imax*jmax)
      open(20,form='unformated',access='direct',recl=ltime)
      open(30,form='unformated',access='direct',recl=imax*jmax)
      iwrite=1
      do 2000 m=1,mode
      call setzero(stdv,imax,jmax)
      call setzero(corr,imax,jmax)
      sd=0
      write(6,*) 'read coef'
      read(20,rec=m) coef

      do 1000 it=1,ltime
      read(10,rec=it) sst 
        do i=1,imax
        do j=1,jmax
         stdv(i,j)=stdv(i,j)+sst(i,j)*sst(i,j)/float(ltime)
         corr(i,j)=corr(i,j)+coef(it)*sst(i,j)/float(ltime)
        enddo
        enddo
        sd=sd+coef(it)*coef(it)/float(ltime)
 1000 continue

        do i=1,imax
        do j=1,jmax
         stdv(i,j)=stdv(i,j)**0.5
        enddo
        enddo
        sd=sd**0.5

        do i=1,imax
        do j=1,jmax
         if (abs(sst(i,j)).gt.800) then
         corr(i,j)=-999.0
         else
         corr(i,j)=corr(i,j)/(sd*stdv(i,j))
         regr(i,j)=corr(i,j)*stdv(i,j)
         end if
        enddo
        enddo

      write(30,rec=iwrite) corr
      iwrite=iwrite+1
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
