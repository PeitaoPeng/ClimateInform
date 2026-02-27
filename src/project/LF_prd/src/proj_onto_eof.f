      program eof
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C===========================================================
      PARAMETER (ngrd=102)
      PARAMETER (ifld=ltime,nmod=mode)
      real fldin(ngrd),fldot(ngrd)
      real fld1(ngrd),fld2(ngrd)
      real fld3(ngrd),fld4(ngrd)
      real aaa(ngrd,ifld)
      real rin(ifld),rot2(ifld),rot(ifld)
 
      open(unit=11,form='formated')
      open(unit=20,form='unformated',access='direct',recl=ngrd)
      open(unit=80,form='unformated',access='direct',recl=ifld)

ccc feed matrix aaa

      iread=0
       iu=11
      do it  =1,ltime
       iread=iread+1
c      write(6,*)'iread= ',iread
       read(iu,888) fldin
 888  format(10f7.1)
        do i=1,ngrd
          aaa(i,iread)=fldin(i)
        end do
      end do
      write(6,*) 'irec= ',iread

cc proj of data on evec
c
      do m=1,mode
        read(20) fld1
      do ir=1,ltime
        do i=1,ngrd
          fld2(i)=aaa(i,ir)
        enddo
        call proj(fld1,fld2,ngrd,pj)
        rot(ir)=pj
      enddo
      call normal(rot,ltime)
      write(80) rot
      enddo
c
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

