      program eof
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C===========================================================
      PARAMETER (ngrd=102)
      PARAMETER (ifld=ltime,nw=2*ifld+15,nmod=mode)
      real fldin(ngrd),fldot(ngrd)
      real fld1(ngrd),fld2(ngrd)
      real stdv(ngrd),corr(ngrd),rcorr(ngrd)
      real aaa(ngrd,ifld),wk(ifld,ngrd),tt(nmod,nmod)
      real eval(ifld),evec(ngrd,ifld),coef(ifld,ifld)
      real rin(ifld),rot2(ifld),rot(ifld)
      real weval(ifld),wevec(ngrd,ifld),wcoef(ifld,ifld)
      real reval(nmod),revec(ngrd,ifld),rcoef(nmod,ifld)
      real rwk(ngrd),rwk2(ngrd,nmod)
 
      open(unit=11,form='formated')
      open(unit=90,form='unformated',access='direct',recl=ifld)
      open(unit=80,form='unformated',access='direct',recl=ngrd)

ccc feed matrix aaa

      iread=0
       iu=11
      do it=1,ltime
       iread=iread+1
       write(6,*)'iread= ',iread
       read(iu,888) fldin
 888  format(10f7.1)
        do i=1,ngrd
          aaa(i,iread)=fldin(i)
        end do
      end do
      write(6,*) 'irec= ',iread
       rewind (iu)

cc... EOF analysis begin

c     call eofs(aaa,ngrd,ifld,ifld,eval,evec,coef,wk,ID)
      call eofs(aaa,ngrd,ifld,ngrd,eval,evec,coef,wk,ID)
c     call REOFS(aaa,ngrd,ifld,ifld,wk,ID,weval,wevec,wcoef,
      call REOFS(aaa,ngrd,ifld,ngrd,wk,ID,weval,wevec,wcoef,
     &           nmod,reval,revec,rcoef,tt,rwk,rwk2)
cc... arange reval,revec and rcoef in decreasing order
      call order(ngrd,ifld,nmod,reval,revec,rcoef)
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
c.....calculate proj to EVEC to have coef
c
      do i=1,ngrd
c       fld1(i)=evec(i,m)
      end do
c
c     do it = 1,ifld      !loop over time
c      read(iu,888) fldin
c      call proj(fld1,fldin,coef(m,it),ngrd)
c     end do
c     rewind (iu)
c     
      call setzero(stdv,ngrd)
      call setzero(corr,ngrd)
      call setzero(rcorr,ngrd)
      sdcf=0
      rsdcf=0

       ir=0
      do it  =1,ltime      !loop over time
       ir=ir+1
       read(iu,888) fldin
        sdcf =sdcf+coef(m,ir)*coef(m,ir)/float(ifld)
        rsdcf=rsdcf+rcoef(m,ir)*rcoef(m,ir)/float(ifld)
        do i=1,ngrd
          stdv(i)=stdv(i)+fldin(i)*fldin(i)/float(ifld)
          corr(i)=corr(i)+coef(m,ir)*fldin(i)/float(ifld)
          rcorr(i)=rcorr(i)+rcoef(m,ir)*fldin(i)/float(ifld)
        end do
      end do
        rewind(iu)

      sdcf=sdcf**0.5
      rsdcf=rsdcf**0.5
      do i=1,ngrd
        stdv(i)=stdv(i)**0.5
      end do
      do i=1,ngrd
        fld2(i)=corr(i)/sdcf
c       fld1(i)=corr(i)/(sdcf*stdv(i))
        fld1(i)=rcorr(i)/(rsdcf*stdv(i))
      end do
c
      do i=1,ngrd
c       fld1(i)=evec(i,m)
      enddo
c
      write(80) fld2     !regression
c     write(80) fld1     !correlation

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
      end do
      call normal(rot,ltime)
      write(90) rot

      END DO    !loop over mode 

      stop
      end

      SUBROUTINE setzero(fld,n)
      DIMENSION fld(n)
      do i=1,n
         fld(i)=0.0
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

      SUBROUTINE proj(eof,fld,pj,n)
      DIMENSION eof(n),fld(n)
      sd1=0
      sd2=0
      do i=1,n
        sd1=sd1+eof(i)*eof(i)/float(n)
        sd2=sd2+fld(i)*fld(i)/float(n)
        pj = pj+eof(i)*fld(i)/float(n)
      end do
      sd1=sqrt(sd1)
      sd2=sqrt(sd2)
      pj=pj/(sd1*sd2)
c
      return
      end
