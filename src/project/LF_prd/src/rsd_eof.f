      program eof
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C===========================================================
      PARAMETER (imax=72,jmax=37)
      PARAMETER (ifld=ltime,nw=2*ifld+15,nmod=mode)
      PARAMETER (lats=23,late=35,lons=1,lone=72)
      PARAMETER (ngrd=(late-lats+1)*(lone-lons+1))
      real fldin(imax,jmax),fld1(imax,jmax),fld2(imax,jmax)
      real stdv(imax,jmax),corr(imax,jmax),rcorr(imax,jmax)
      real sst1d(ifld,its)
      real aaa(ngrd,ifld),wk(ifld,ngrd),tt(nmod,nmod)
      real eval(ifld),evec(ngrd,ifld),coef(ifld,ifld)
      real rin(ifld),rot2(ifld),rot(ifld)
      real weval(ifld),wevec(ngrd,ifld),wcoef(ifld,ifld)
      real reval(nmod),revec(ngrd,ifld),rcoef(nmod,ifld)
      real xlat(jmax),coslat(jmax)
      real rwk(ngrd),rwk2(ngrd,nmod)
 
      open(unit=11,form='unformated',access='direct',recl=imax*jmax)
      open(unit=50,form='unformated',access='direct',recl=ifld)
      open(unit=51,form='unformated',access='direct',recl=ifld)
      open(unit=90,form='unformated',access='direct',recl=ifld)
      open(unit=80,form='unformated',access='direct',recl=imax*jmax)

ccc have coslat
      xlat(1)=-90
      do j=2,jmax
       xlat(j)=xlat(j-1)+5
      end do
        
      do j=1,jmax
        coslat(j)=sqrt(cos(xlat(j)*3.14159/180))
      enddo
ccc regressing the fld with its time series

      do is=1,its1
      read(50) rot
      do it=1,ltime
       sst1d(it,is)=rot(it)
      end do
      end do

      do is=1,its2
      read(51) rot
      do it=1,ltime
       sst1d(it,is+its1)=rot(it)
      end do
      end do

      do 1000 is=1,its  !loop over its

        iunit=1
        iu1=iunit+10
        call setzero(corr,imax,jmax)
        call setzero(stdv,imax,jmax)
        sd=0

      do it=1,ltime
       read(iu1) fldin
        do i=1,imax
        do j=1,jmax
          corr(i,j)=corr(i,j)+sst1d(it,is)*fldin(i,j)/float(ltime)
          stdv(i,j)=stdv(i,j)+fldin(i,j)*fldin(i,j)/float(ltime)
        enddo
        enddo
        sd=sd+sst1d(it,is)*sst1d(it,is)/float(ltime)
      enddo

        sd=sqrt(sd)
        do j=1,jmax
        do i=1,imax
          stdv(i,j)=sqrt(stdv(i,j))
        end do
        end do

        do i=1,imax
        do j=1,jmax
          fld1(i,j)=corr(i,j)/sd
          fld2(i,j)=corr(i,j)/(stdv(i,j)*sd)
        enddo
        enddo
      write(80) fld1   !regression
      write(80) fld2   !correlation
      do n=1,ifld
         rot2(n)=sst1d(n,is)
      end do
      write(90) rot2

      rewind (iu1)

        iu2=iunit+10+(is-1)*5
        iu3=iunit+10+is*5
      do it=1,ltime
       read(iu2) fldin
        do i=1,imax
        do j=1,jmax
         fld2(i,j)=fldin(i,j)-sst1d(it,is)*fld1(i,j)
        enddo
        enddo
        write(iu3) fld2
c      write(6,*)'it=',it,' coef=',rot(it),' fld1=',fld1(8,8)
      enddo
        rewind (iu2)
        rewind (iu3)
       write(6,*)'iu1= ',iu1,' iu2=',iu2,' iu3=',iu3

 1000 continue         !loop over # of time series

ccc feed matrix aaa

      iread=0
       iu=iu3
      do it  =1,ltime
       iread=iread+1
       write(6,*)'iread= ',iread

c      if (it.eq.26) then
c      read(iu)fld1
c      else
       read(iu) fldin
c      end if

        ng=0
        do j=lats,late
        do i=lons,lone
          ng=ng+1
          aaa(ng,iread)=fldin(i,j)*coslat(j)
        end do
        end do
      end do
      write(6,*) 'ngrd= ',ng
      write(6,*) 'irec= ',iread
       rewind (iu)

cc... EOF analysis begin

      call eofs(aaa,ngrd,ifld,ifld,eval,evec,coef,wk,ID)
      call REOFS(aaa,ngrd,ifld,ifld,wk,ID,weval,wevec,wcoef,
     &           nmod,reval,revec,rcoef,tt,rwk,rwk2)
cc... arange reval,revec and rcoef in decreasing order
c     call order(ngrd,ifld,nmod,reval,revec,rcoef)
cc... write out eval and reval
      totv1=0
      do i=1,20
      write(6,*)'eval= ',i,eval(i)
      totv1=totv1+eval(i)
      end do
      write(6,*)'total= ',totv1

      totv2=0
      do i=1,nmod
      write(6,*)'reval= ',i,reval(i)
      totv2=totv2+reval(i)
      end do
      write(6,*)'total= ',totv2

CCC...writeout evec

ccc...CORR between coef and data


      DO m=1,mode   !loop over mode (1-4)

      call setzero(stdv,imax,jmax)
      call setzero(corr,imax,jmax)
      call setzero(rcorr,imax,jmax)
      sdcf=0
      rsdcf=0

       ir=0
       iu=iu1
      do it  =1,ltime      !loop over time
       ir=ir+1
       read(iu) fldin
        sdcf =sdcf+coef(m,ir)*coef(m,ir)/float(ifld)
        rsdcf=rsdcf+rcoef(m,ir)*rcoef(m,ir)/float(ifld)
        do j=1,jmax
        do i=1,imax
          stdv(i,j)=stdv(i,j)+fldin(i,j)*fldin(i,j)/float(ifld)
          corr(i,j)=corr(i,j)+coef(m,ir)*fldin(i,j)/float(ifld)
          rcorr(i,j)=rcorr(i,j)+rcoef(m,ir)*fldin(i,j)/float(ifld)
        end do
        end do
      end do
        rewind(iu)

      sdcf=sdcf**0.5
      rsdcf=rsdcf**0.5
      do j=1,jmax
      do i=1,imax
        stdv(i,j)=stdv(i,j)**0.5
      end do
      end do
      do j=1,jmax
      do i=1,imax
        fld2(i,j)=rcorr(i,j)/rsdcf
        fld1(i,j)=rcorr(i,j)/(rsdcf*stdv(i,j))
      end do
      end do

      write(80) fld2     !regression
      write(80) fld1     !correlation
c     write(80) fldin     !correlation

      rsd=0
      sd=0
      do n=1,ifld
        rsd=rsd+rcoef(m,n)*rcoef(m,n)/float(ifld)
        sd=sd+coef(m,n)*coef(m,n)/float(ifld)
      end do
      rsd=sqrt(rsd)
      sd=sqrt(sd)

      do n=1,ifld
      rot(n)=rcoef(m,n)/rsd
c     rot(n)=coef(m,n)/sd
c     write(6,*) 'mode= ',m, 'it= ',n,'rcoef= ',rot(n)
      end do
      call normal(rot2,ltime)
      do n=1,ifld
         rot2(n)=rot(n)
      end do
      write(90) rot2

      END DO    !loop over mode (1-4)

cc... check the othorgnal property
c
      sum=0
      do 120 ng=1,ngrd
         sum=sum+revec(ng,1)*revec(ng,3)
120   continue
      write(6,*) 'sum of revec= ',sum
      sum=0
      do 130 nt=1,ifld
         sum=sum+sst1d(nt,1)*rcoef(1,nt)
130   continue
      write(6,*) 'sum of coef= ',sum

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

