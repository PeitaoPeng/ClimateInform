      program correlation
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. correlation between tropical area averaged sst and global field
C===========================================================
      real fld1(imax,jmax),fld2(imax,jmax),fld3(imax,jmax)
      real coefm(ltime,mode),coef(ltime)
      real rcoefm(ltime,mode),rcoef(ltime)
      real regr(imax,jmax,mode),rregr(imax,jmax,mode)
      real xlat(jmax),coslat(jmax)
c
      open(unit=10,form='unformated',access='direct',recl=ltime)
      open(unit=15,form='unformated',access='direct',recl=ltime)
      open(unit=20,form='unformated',access='direct',recl=imax*jmax)
      open(unit=25,form='unformated',access='direct',recl=imax*jmax)
      open(unit=30,form='unformated',access='direct',recl=imax*jmax)
      open(unit=35,form='unformated',access='direct',recl=imax*jmax)
c
ccc have coslat
      dlat=180./float(jmax-1)
      do j=1,jmax
        xlat(j)=-90+(j-1)*dlat
        coslat(j)=cos(xlat(j)*3.14159/180)
      enddo
c
      do m=1,mode
      read(10,rec=m) coef
      read(15,rec=m) rcoef
        do i=1,ltime
         coefm(i,m)=coef(i)
         rcoefm(i,m)=rcoef(i)
        enddo
      end do
c
      do m=1,mode
      ir1=m*2
      ir2=m*2-1
      read(20,rec=ir1) fld1
      read(25,rec=ir2) fld2
        do i=1,imax
        do j=1,jmax
         regr(i,j,m)=fld1(i,j)
         rregr(i,j,m)=fld2(i,j)
        enddo
        enddo
      end do

      do 1000 iy=1,ltime

        call setzero(fld1,imax,jmax)
        call setzero(fld2,imax,jmax)
       do m=1,mode
        do i=1,imax
        do j=1,jmax
          fld1(i,j)=fld1(i,j)+regr(i,j,m)*coefm(iy,m)
          fld2(i,j)=fld2(i,j)+rregr(i,j,m)*rcoefm(iy,m)
        enddo
        enddo
       enddo
      write(35) fld1
      write(35) fld2
      read(30,rec=iy) fld3
      write(35) fld3
      call acc(fld2,fld3,coslat,jmax,imax,23,35,1,72,corr)
      call acc(fld1,fld3,coslat,jmax,imax,23,35,1,72,cor)
      write(6,*)"iyear=",iy,"ac= ",cor,"rac=",corr

 1000 continue
      
      stop
      END


      SUBROUTINE acc(fld1,fld2,coslat,jmax,imax,j1,j2,i1,i2,cor)

      real fld1(imax,jmax),fld2(imax,jmax),coslat(jmax)

      area=0
      do j=j1,j2
      do i=i1,i2
        area=area+coslat(j)
      enddo
      enddo

      cor=0.
      sd1=0.
      sd2=0.

      do j=j1,j2
      do i=i1,i2
         cor=cor+fld1(i,j)*fld2(i,j)*coslat(j)/area
         sd1=sd1+fld1(i,j)*fld1(i,j)*coslat(j)/area
         sd2=sd2+fld2(i,j)*fld2(i,j)*coslat(j)/area
      enddo
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      cor=cor/(sd1*sd2)

      return
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
