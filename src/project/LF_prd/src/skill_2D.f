      program skill
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. correlation between tropical area averaged sst and global field
C===========================================================
      real fld1(imax,jmax),fld2(imax,jmax)
      real stdv1(imax,jmax),stdv2(imax,jmax)
      real obs(imax,jmax,ltime),prd(imax,jmax,ltime)
      real cobs(imax,jmax),cprd(imax,jmax)
      real corr(imax,jmax),xlat(jmax),mask(imax,jmax)
      real actp(ltime),acnh(ltime),acsh(ltime),acpna(ltime)
      real acglb(ltime),coslat(jmax)

      open(10,form='unformated',access='direct',recl=imax*jmax)
      open(20,form='unformated',access='direct',recl=imax*jmax)
      open(50,form='unformated',access='direct',recl=imax*jmax)
 
c     ifld=1  ! < 3 for hgt500 and 2mt; =3 for temp

CCC read in data for 81-02
      do it=1,ltime
      read(10,rec=it) fld1
      read(20,rec=it+31) fld2            !skip 50-80
        do i=1,imax
        do j=1,jmax
          prd(i,j,it)=fld1(i,j)
          obs(i,j,it)=fld2(i,j)
        enddo
        enddo
      enddo

ccc have 2-D acc between obs abd esmavg
      call setzero(stdv1,imax,jmax)
      call setzero(stdv2,imax,jmax)
      call setzero(corr,imax,jmax)
      call setzero(cobs,imax,jmax)
      call setzero(cprd,imax,jmax)

      do i=1,imax
      do j=1,jmax

        do it=1,ltime
          cprd(i,j)=cprd(i,j)+prd(i,j,it)/float(ltime)
          cobs(i,j)=cobs(i,j)+prd(i,j,it)/float(ltime)
         if(abs(obs(i,j,it)).gt.900.or.abs(prd(i,j,it)).gt.900) then
          cobs(i,j)=-999.0
          cprd(i,j)=-999.0
          goto 2000
          endif
        enddo
 2000 continue
      enddo
      enddo
c
      do i=1,imax
      do j=1,jmax

        do it=1,ltime
          stdv1(i,j)=stdv1(i,j)+(prd(i,j,it)-cprd(i,j))*
     &                          (prd(i,j,it)-cprd(i,j))/float(ltime)
          stdv2(i,j)=stdv2(i,j)+(obs(i,j,it)-cobs(i,j))*
     &                          (obs(i,j,it)-cobs(i,j))/float(ltime)
          corr(i,j)=corr(i,j)+(obs(i,j,it)-cobs(i,j))*
     &                          (prd(i,j,it)-cprd(i,j))/float(ltime)
          if(abs(obs(i,j,it)).gt.900.or.abs(prd(i,j,it)).gt.900) then
          corr(i,j)=-999.0
          stdv1(i,j)=-999.0
          stdv2(i,j)=-999.0
          goto 1000
          endif
        enddo
        stdv1(i,j)=stdv1(i,j)**0.5
        stdv2(i,j)=stdv2(i,j)**0.5
 1000 continue
      enddo
      enddo

        do i=1,imax
        do j=1,jmax
        if(abs(corr(i,j)).gt.900) then
          corr(i,j)=-999.0
        else
          corr(i,j)=corr(i,j)/(stdv1(i,j)*stdv2(i,j))
        end if
        enddo
        enddo

      write(50) stdv1
      write(50) stdv2
c     if(ifld.eq.3) then
c     call maskout(corr,mask,imax,jmax)
c     endif
      write(50) corr

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


