      program correlation
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. correlation between tropical area averaged sst and global field
C===========================================================
c     PARAMETER (imax=128,jmax=64)
      real fld1(imax,jmax),fld2(imax,jmax),stdv(imax,jmax)
      real fld3d(imax,jmax,ltime)
      real fld2d(mode+2,ltime)
      real corr(imax,jmax),regr(imax,jmax),rcoef(ltime)
      real datain(nin)
c
      open(unit=10,form='unformated',access='direct',recl=nin)
      open(unit=11,form='unformated',access='direct',recl=ltime)
      open(unit=20,form='unformated',access='direct',recl=imax*jmax)
      open(unit=30,form='unformated',access='direct',recl=imax*jmax)
c
c read in fld data
c
      undef=undef
      istart=13
      iend=ltime+12
      nr=0
      do it=istart,iend
        nr=nr+1
        read(20,rec=it) fld1
        do i=1,imax
        do j=1,jmax
         fld3d(i,j,nr)=fld1(i,j)
        enddo
        enddo
      end do
c
c read in ori, imf and residual
      read(10,rec=1) datain  !original
      do i=1,ltime
        fld2d(1,i)=datain(i+12)
      enddo
c
      do m=1,mode
      read(10,rec=(m-1)*6+2) datain  !imf
      do i=1,ltime
        fld2d(m+1,i)=datain(i+12)
      enddo
      enddo
c
      read(10,rec=(mode-1)*6+5) datain  !trend
      do i=1,ltime
        fld2d(mode+2,i)=datain(i+12)
      enddo
c
      iwrite=1
      do 2000 m=1,mode+2
      call setzero(stdv,imax,jmax)
      call setzero(corr,imax,jmax)
      do i=1,ltime
        rcoef(i)=fld2d(m,i)
      enddo
      write(11) rcoef
c
      do i=1,imax
      do j=1,jmax
        sdfld=0.
        cor=0.
        do it=1,ltime
          sdfld=sdfld+fld3d(i,j,it)*fld3d(i,j,it)/float(ltime)
          cor=cor+rcoef(it)*fld3d(i,j,it)/float(ltime)
          if(abs(fld3d(i,j,it)).gt.900) then
          corr(i,j)=undef
          stdv(i,j)=undef
          goto 1000
          endif
        enddo
        corr(i,j)=cor
        stdv(i,j)=sdfld**0.5
 1000 continue
      enddo
      enddo

        sdcft=0.
        do it=1,ltime
          sdcft=sdcft+rcoef(it)*rcoef(it)/float(ltime)
        sdcft=sdcft**0.5
        enddo
      write(6,*) 'sdcft=',sdcft

        do i=1,imax
        do j=1,jmax
          if(abs(corr(i,j)).gt.900) then
            fld2(i,j)=undef
            regr(i,j)=undef
          else
            fld2(i,j)=corr(i,j)/(sdcft*stdv(i,j))
            regr(i,j)=corr(i,j)/sdcft
         end if
        enddo
        enddo

      write(30,rec=iwrite) fld2
      iwrite=iwrite+1
      write(30,rec=iwrite) regr
      iwrite=iwrite+1
      write(6,*)'loop has come to m=',m

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
