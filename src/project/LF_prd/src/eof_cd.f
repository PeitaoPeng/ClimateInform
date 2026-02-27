      program eof
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C===========================================================
      PARAMETER (ngrd=102)
      PARAMETER (ifld=ltime,nw=2*ifld+15,nmod=mode)
      real fldin(ngrd),fldot(ngrd)
      real fld1(ngrd),fld2(ngrd)
      real fld3(ngrd),fld4(ngrd)
      real stdv(ngrd),corr(ngrd),rcorr(ngrd)
      real aaa(ngrd,ifld),wk(ifld,ngrd),tt(nmod,nmod)
      real eval(ifld),evec(ngrd,ifld),coef(ifld,ifld)
      real rin(ifld),rot2(ifld),rot(ifld)
      real weval(ifld),wevec(ngrd,ifld),wcoef(ifld,ifld)
      real reval(nmod),revec(ngrd,ifld),rcoef(nmod,ifld)
      real rwk(ngrd),rwk2(ngrd,nmod)
 
      open(unit=90,form='unformated',access='direct',recl=ifld)
      open(unit=95,form='unformated',access='direct',recl=ifld)
      open(unit=80,form='unformated',access='direct',recl=ngrd)
      open(unit=81,form='unformated',access='direct',recl=ngrd)
      open(unit=85,form='unformated',access='direct',recl=ngrd)
      open(unit=86,form='unformated',access='direct',recl=ngrd)

ccc feed matrix aaa

      iread=0
       iu=11
      do it  =1,ltime
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

      call eofs(aaa,ngrd,ifld,ifld,eval,evec,coef,wk,ID)
c
cc proj of data on evec
c
      do m=1,6
      do i=1,ngrd
        fld1(i)=evec(i,m)
      enddo
      do ir=1,ltime
        do i=1,ngrd
          fld2(i)=aaa(i,ir)
        enddo
        call proj(fld1,fld2,ngrd,pj)
        rot(ir)=pj
      enddo
      call normal(rot,ltime)
      write(95) rot
      enddo
c
      do m=1,10
      do i=1,ngrd
        fld1(i)=evec(i,m)/sqrt(eval(m))
      enddo
c     write(85) fld1
      enddo
      call REOFS(aaa,ngrd,ifld,ifld,wk,ID,weval,wevec,wcoef,
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

ccc...CORR between Rcoef and data

      DO m=1,mode   !loop over mode (1-4)

      call setzero(stdv,ngrd)
      call setzero(rcorr,ngrd)
      rsdcf=0

       ir=0
      do it  =1,ltime      !loop over time
       ir=ir+1
       read(iu,888) fldin
        sdcf =sdcf+coef(m,ir)*coef(m,ir)/float(ifld)
        rsdcf=rsdcf+rcoef(m,ir)*rcoef(m,ir)/float(ifld)
        do i=1,ngrd
          stdv(i)=stdv(i)+fldin(i)*fldin(i)/float(ifld)
          rcorr(i)=rcorr(i)+rcoef(m,ir)*fldin(i)/float(ifld)
        end do
      end do
        rewind(iu)

      rsdcf=rsdcf**0.5
      do i=1,ngrd
        stdv(i)=stdv(i)**0.5
      end do
      do i=1,ngrd
        fld1(i)=rcorr(i)/(rsdcf*stdv(i))
        fld2(i)=rcorr(i)/rsdcf
      end do

      write(80) fld1     !correlation
      write(81) fld2     !correlation

      rsd=0
      do n=1,ifld
        rsd=rsd+rcoef(m,n)*rcoef(m,n)/float(ifld)
      end do
      rsd=sqrt(rsd)

      do n=1,ifld
      rot(n)=rcoef(m,n)/rsd
      end do
      call normal(rot,ltime)
      write(90) rot

      END DO    !loop over mode (1-4)
ccc...CORR between coef and data

      DO m=1,71   !loop over mode (1-4)

      call setzero(stdv,ngrd)
      call setzero(corr,ngrd)
      sdcf=0
       ir=0
      do it  =1,ltime      !loop over time
       ir=ir+1
       read(iu,888) fldin
        sdcf =sdcf+coef(m,ir)*coef(m,ir)/float(ifld)
        do i=1,ngrd
          stdv(i)=stdv(i)+fldin(i)*fldin(i)/float(ifld)
          corr(i)=corr(i)+coef(m,ir)*fldin(i)/float(ifld)
        end do
      end do
        rewind(iu)

      sdcf=sdcf**0.5
      do i=1,ngrd
        stdv(i)=stdv(i)**0.5
      end do
      do i=1,ngrd
        fld3(i)=corr(i)/(sdcf*stdv(i))
        fld4(i)=corr(i)/sdcf
      end do

      write(85) fld3     !correlation
      write(86) fld4     !regression

      sd=0
      do n=1,ifld
        sd=sd+coef(m,n)*coef(m,n)/float(ifld)
      end do
      sd=sqrt(sd)

      do n=1,ifld
      rot2(n)=coef(m,n)/sd
      end do
      call normal(rot2,ltime)
c     write(95) rot2

      END DO    !loop over eof mode=30
c acc among reofs
      do i=1,ngrd
        fld1(i)=revec(i,1)
        fld2(i)=revec(i,2)
        fld3(i)=revec(i,3)
      enddo
      call acc(fld1,fld2,ngrd,c12)
      call acc(fld1,fld3,ngrd,c13)
      call acc(fld2,fld3,ngrd,c23)
      write(6,*) 'apc(reof1 vs reof2)=',c12
      write(6,*) 'apc(reof1 vs reof3)=',c13
      write(6,*) 'apc(reof2 vs reof3)=',c23

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
      c=ac/(sd_a*sd_b)
c
      return
      end
