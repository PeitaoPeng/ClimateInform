      program skill
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. correlation between tropical area averaged sst and global field
C===========================================================
      real fld1(imax),fld2(imax)

      open(10,form='unformated',access='direct',recl=imax)
 

CCC read in data for ac
      read(10) fld1
      write(6,*) fld1
      ac=0.
      do i=1,imax
        if(fld1(i).ge.0.) then
          acc=fld1(i)
        else
          acc=0.
        end if
        ac=ac+acc/102.
      enddo

      write(6,*) 'ac=',ac

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

      SUBROUTINE acc(fld1,fld2,coslat,jmax,imax,
     'lat1,lat2,lon1,lon2,cor)

      real fld1(imax,jmax),fld2(imax,jmax),coslat(jmax)

      area=0
      do j=lat1,lat2
      do i=lon1,lon2
        area=area+coslat(j)
      enddo
      enddo


      cor=0.
      sd1=0.
      sd2=0.

      do j=lat1,lat2
      do i=lon1,lon2
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


      SUBROUTINE accavg(acc,sd1,sd2,coslat,jmax,imax,
     '                  lat1,lat2,lon1,lon2,cor)

      real acc(imax,jmax),coslat(jmax)
      real sd1(imax,jmax),sd2(imax,jmax)

      area=0
      do j=lat1,lat2
      do i=lon1,lon2
        area=area+coslat(j)
      enddo
      enddo

      cor=0.
      do j=lat1,lat2
      do i=lon1,lon2

        if(acc(i,j).lt.0..and.(sd1(i,j)/sd2(i,j)).lt.1) then
c       acc(i,j)=acc(i,j)*(sd1(i,j)/sd2(i,j))
        endif

        cor=cor+acc(i,j)*coslat(j)/area

      enddo
      enddo

      return
      end

      SUBROUTINE norsou(fldin,fldot,lon,lat)
      dimension fldin(lon,lat),fldot(lon,lat)
      do 100 j=1,lat
      do 100 i=1,lon
         fldot(i,j)=fldin(i,lat+1-j)
  100 continue
      return
      end

      SUBROUTINE wtout(fld,lon,lat,lat1,lat2,lon1,lon2)
      dimension fld(lon,lat)
      do 100 j=lat1,lat2
      do 100 i=lon1,lon2
         write(6,*) 'i,j= ',i,j,fld(i,j)
  100 continue
      return
      end

      SUBROUTINE accmaskavg(acc,mask,sd1,sd2,coslat,jmax,imax,
     '                  lat1,lat2,lon1,lon2,cor)

      real acc(imax,jmax),coslat(jmax),mask(imax,jmax)
      real sd1(imax,jmax),sd2(imax,jmax)

      area=0
      do j=lat1,lat2
      do i=lon1,lon2
        if(mask(i,j).lt.0) then
        area=area+coslat(j)
        endif
      enddo
      enddo

      cor=0.
      do j=lat1,lat2
      do i=lon1,lon2

        if(mask(i,j).lt.0) then

        if(acc(i,j).lt.0..and.(sd1(i,j)/sd2(i,j)).lt.1) then
c       acc(i,j)=acc(i,j)*(sd1(i,j)/sd2(i,j))
        endif

        cor=cor+acc(i,j)*coslat(j)/area

        end if

      enddo
      enddo

      return
      end


      SUBROUTINE maskout(fld,mask,lon,lat)
      dimension fld(lon,lat),mask(lon,lat)
      do  j=1,lat
      do  i=1,lon
        if(mask(i,j).gt.0) then
          fld(i,j)=-99999.0
        endif
      end do
      end do
      return
      end


