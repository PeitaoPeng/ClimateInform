      program eof
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C===========================================================
      PARAMETER (imax=192,jmax=94)
      PARAMETER (ngrd=783) !NA region
c     PARAMETER (ngrd=2980) !NH
c     PARAMETER (ngrd=289)  !USA
      PARAMETER (ifld=ltime,nw=2*ifld+15,nmod=mode)
      real fldin(imax,jmax),fldot(imax,jmax)
      real fld1(imax,jmax),fld2(imax,jmax)
      real fld3(imax,jmax),fld4(imax,jmax)
      real mask(imax,jmax)
      real stdv(imax,jmax),corr(imax,jmax)
      real aaa(ngrd,ifld),wk(ifld,ngrd),tt(nmod,nmod)
      real eval(ifld),evec(ngrd,ifld),coef(ifld,ifld)
      real rin(ifld),rot2(ifld),rot(ifld)
      real rot2d(mode,ifld)
      real weval(ifld),wevec(ngrd,ifld),wcoef(ifld,ifld)
      real reval(nmod),revec(ngrd,ifld),rcoef(nmod,ifld)
      real f1d(ngrd),f1d2(ngrd)
      real coslat(jmax),xlat(jmax)
 
      open(unit=11,form='unformatted',access='direct',recl=4*imax*jmax)
      open(unit=12,form='unformatted',access='direct',recl=4*imax*jmax)
      open(unit=80,form='unformatted',access='direct',recl=4*imax*jmax)
      open(unit=81,form='unformatted',access='direct',recl=4*imax*jmax)
      open(unit=90,form='unformatted',access='direct',recl=4*ifld)

      dl=1.915
      do j=1,jmax
        xlat(j)=dl*(j-1)-88.542
        coslat(j)=COS(3.14159*xlat(j)/180)
      enddo
      write(6,*) 'xlat=',xlat
      write(6,*) 'coslat=',coslat
ccc feed matrix aaa

      read(12,rec=1) mask
c     write(6,*) 'mask=',mask
c
      iu=11
      iread=0
      do it = 1,ltime
        iread=iread+1
        read(iu,rec=iread) fldin
c limit the data of NA region Lat:15N-73N; Lon: 195-305
        ig=0
        do i=105,163  !NA region
        do j=56,86
c       do i=1,imax  !NH area
c       do j=58,94
c       do i=105,163   !USA
c       do j=62,73
          if(mask(i,j).gt.0) then
          ig=ig+1
          aaa(i,iread)=sqrt(coslat(j))*fldin(i,j)
          endif
        end do
        end do
      write(6,*) 'ngrd=',ig
      end do
c     go to 888
c
      write(6,*) 'irec= ',iread

cc... EOF analysis begin
c
      call eofs(aaa,ngrd,ifld,ifld,eval,evec,coef,wk,ID)
      write(6,*) 'eval=',eval
c
cc proj of data on evec
c
      do m=1,6
      do i=1,ngrd
        f1d(i)=evec(i,m)
      enddo
      do ir=1,ltime
        do i=1,ngrd
          f1d2(i)=aaa(i,ir)
        enddo
        call proj(f1d,f1d2,ngrd,pj)
        rot(ir)=pj
        rot2d(m,ir)=pj
      enddo
      call normal(rot,ltime)
c
      write(90,rec=m) rot
c
c     write(6,*) 'rot=',rot
      enddo
c
ccc...CORR between coef and data
c
      DO m=1,mode   !loop over mode (1-6)

      call setzero(stdv,imax,jmax)
      call setzero(corr,imax,jmax)
      sdcf=0
      ir=0
      do it =1,ltime      !loop over time
       ir=ir+1
        read(iu,rec=ir) fldin
        sdcf =sdcf+coef(m,ir)*coef(m,ir)/float(ifld)
        do i=1,imax
        do j=1,jmax
        if(mask(i,j).gt.0) then
          stdv(i,j)=stdv(i,j)+fldin(i,j)*fldin(i,j)/float(ifld)
          corr(i,j)=corr(i,j)+coef(m,ir)*fldin(i,j)/float(ifld)
        else
          stdv(i,j)=999.0
          corr(i,j)=999.0
        end if
        end do
        end do
      end do
      write(6,*) 'sdcf=',sdcf
      write(6,*) 'stdv=',stdv
      write(6,*) 'corr=',corr

      sdcf=sdcf**0.5
      do i=1,imax
      do j=1,jmax
        if(mask(i,j).gt.0) then
        stdv(i,j)=stdv(i,j)**0.5
        end if
      end do
      end do
      do i=1,imax
      do j=1,jmax
        if(mask(i,j).gt.0) then
        fld1(i,j)=corr(i,j)/(sdcf*stdv(i,j))
        fld2(i,j)=corr(i,j)/sdcf
        else
        fld1(i,j)=999.0
        fld2(i,j)=999.0
        endif
      end do
      end do

      write(80,rec=m) fld1     !correlation
      write(81,rec=m) fld2     !regression

      END DO    !loop over mode (1-4)
 888  continue
      do m=1,mode
        do it=1,ifld
          rot(it)=coef(m,it)
          rot2(it)=rot2d(m,it)
        enddo
        call acc(rot,rot2,ifld,cor)
        write(6,*) 'mode=',m,'cor=',cor
        write(6,*) 'rot=',rot2
      enddo
        

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

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  proj to evec
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine proj(a,b,n,c)
      real a(n),b(n)
c
      avg_a=0.
      avg_b=0.
      do i=1,n
c       avg_a=avg_a+a(i)/float(n)
c       avg_b=avg_b+b(i)/float(n)
      enddo
c
      do i=1,n
      a(i)=a(i)-avg_a
      b(i)=b(i)-avg_b
      enddo
c
      sd_a=0
      sd_b=0
      ac=0
      do i=1,n
      sd_a=sd_a+a(i)*a(i)/float(n)
      sd_b=sd_b+b(i)*b(i)/float(n)
      ac=ac+a(i)*b(i)/float(n)
      enddo
      sd_a=sqrt(sd_a)
      sd_b=sqrt(sd_b)
c     c=ac/(sd_a*sd_b)
      c=ac/(sd_a)
c
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  acc of patterns
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine acc(a,b,n,c)
      real a(n),b(n)
c
      avg_a=0.
      avg_b=0.
      do i=1,n
        avg_a=avg_a+a(i)/float(n)
        avg_b=avg_b+b(i)/float(n)
      enddo
c
      do i=1,n
      a(i)=a(i)-avg_a
      b(i)=b(i)-avg_b
      enddo
c
      sd_a=0
      sd_b=0
      ac=0
      do i=1,n
      sd_a=sd_a+a(i)*a(i)/float(n)
      sd_b=sd_b+b(i)*b(i)/float(n)
      ac=ac+a(i)*b(i)/float(n)
      enddo
      sd_a=sqrt(sd_a)
      sd_b=sqrt(sd_b)
      c=ac/(sd_a*sd_b)
c
      return
      end
