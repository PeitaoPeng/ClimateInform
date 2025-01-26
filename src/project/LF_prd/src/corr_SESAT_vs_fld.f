      program correlation
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. correlation between tropical area averaged sst and global field
C===========================================================
c     PARAMETER (imax=128,jmax=64,ltime=21,mode=10)
      real fld1(imax,jmax),fld2(imax,jmax),stdv(imax,jmax)
      real fld3d(imax,jmax,ltime)
      real corr(imax,jmax),regr(imax,jmax),rcoef(lsesat)
c
      open(unit=10,form='unformated',access='direct',recl=lsesat)
      open(unit=20,form='unformated',access='direct',recl=imax*jmax)
      open(unit=30,form='unformated',access='direct',recl=imax*jmax)
c
c     iskip=19   !19 is 1950; 20 is 1951
c read in fld data
      do it=1,ltime
        read(20,rec=it) fld1
        do i=1,imax
        do j=1,jmax
         fld3d(i,j,it)=fld1(i,j)
        enddo
        enddo
      end do
c
      iwrite=1
      call setzero(stdv,imax,jmax)
      call setzero(corr,imax,jmax)
      read(10,rec=1) rcoef
      write(6,*) rcoef
c
      do i=1,imax
      do j=1,jmax
        sdfld=0.
        cor=0.
        do it=1,ltime-1
          sdfld=sdfld+fld3d(i,j,it)*fld3d(i,j,it)/float(ltime-1)
          cor=cor+rcoef(it+iskip)*fld3d(i,j,it)/float(ltime-1)
          if(abs(fld3d(i,j,it)).gt.900) then
          corr(i,j)=-999.0
          stdv(i,j)=-999.0
          goto 1000
          endif
        enddo
        corr(i,j)=cor
        stdv(i,j)=sdfld**0.5
 1000 continue
      enddo
      enddo

        sdcft=0.
        do it=1,ltime-1
          sdcft=sdcft+rcoef(it+iskip)*rcoef(it+iskip)/float(ltime-1)
        sdcft=sdcft**0.5
        enddo
      write(6,*) 'sdcft=',sdcft

        do i=1,imax
        do j=1,jmax
          if(abs(corr(i,j)).gt.990) then
            fld2(i,j)=-999.0
            regr(i,j)=-999.0
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
