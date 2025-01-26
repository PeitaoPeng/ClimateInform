      program eof
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C===========================================================
      PARAMETER (ngrd=102)
      PARAMETER (ifld=ltime,nw=2*ifld+15,nmod=mode)
      real fldin(ngrd),fldot(ngrd)
      real fld1(ngrd),fld2(ngrd)
      real fld3d(ngrd,ifld),bbb(ngrd,ifld-1)
      real stdv(ngrd),corr(ngrd),rcorr(ngrd)
      real aaa(ngrd,ifld-1),wk(ifld-1,ngrd),tt(nmod,nmod)
      real eval(ifld-1),evec(ngrd,ifld-1),coef(ifld,ifld)
      real ceval(10,41),evout(10),ac(41)
      real evec1(ngrd,41),evec2(ngrd,41),evec3(ngrd,41)
      real coef1(ifld,41),coef2(ifld,41),coef3(ifld,41)
      real rin(ifld),rot2(ifld),rot(ifld)
      real vec1(ngrd),vec2(ngrd),vfull(ngrd,6)
      real coefm(ifld-1,ifld-1)
 
      open(unit=11,form='formated')
      open(unit=90,form='unformated',access='direct',recl=ifld)
      open(unit=80,form='unformated',access='direct',recl=ngrd)
      open(unit=20,form='unformated',access='direct',recl=ngrd)
      open(unit=85,form='unformated',access='direct',recl=ngrd)

ccc read in eof of 1931-2002 data set
      do ir=1,6
        read(20,rec=ir) vec1
        do i=1,ngrd
          vfull(i,ir)=vec1(i)
        enddo
      enddo
ccc read in temp data
 888  format(10f7.1)
      iu=11
      do it=1,ltime
       read(iu,888) fldin
        do i=1,ngrd
          fld3d(i,it)=fldin(i)
        end do
      end do
c                                  
      DO it=31,71      !cross validatio from 1961 to 2001
c
      do ir=1,30       !feed in first 30 year data to matrix aaa
        do i=1,ngrd
          aaa(i,ir)=fld3d(i,ir)
          bbb(i,ir)=fld3d(i,ir)
        end do
      enddo
c
        iread=30
        do ir=31,71
        iread=iread+1
          if(ir.ne.it) then
          do i=1,ngrd
            aaa(i,iread)=fld3d(i,ir)
            bbb(i,iread)=fld3d(i,ir)
          end do
          end if
        end do
c
cc... EOF analysis begin
c
      CALL eofs(aaa,ngrd,ifld-1,ifld-1,eval,evec,coefm,wk,ID)
c     write(6,*) (coef(i,1),i=1,5)
c
cc... collect eval,reval and coef
c
      do i=1,10
        ceval(i,it-30)=eval(i)
      enddo
c
      do i=1,ngrd
        evec1(i,it-30)=evec(i,1)
        evec2(i,it-30)=evec(i,2)
        evec3(i,it-30)=evec(i,3)
      enddo
c
cc proj of data on evec
c
      do i=1,ngrd
        vec1(i)=evec(i,1)
      enddo
      do ir=1,ltime
        do i=1,ngrd
          vec2(i)=fld3d(i,ir)
        enddo
        call proj(vec1,vec2,ngrd,pj)
        coef(ir,1)=pj
      enddo
       
      ir=0.
      do i=1,ltime
c       if(i.ne.it) then
          ir=ir+1
          coef1(i,it-30)=coef(ir,1)
          coef2(i,it-30)=coef(ir,2)
          coef3(i,it-30)=coef(ir,3)
c       else
c         coef1(i,it-30)=-999.
c         coef2(i,it-30)=-999.
c         coef3(i,it-30)=-999.
c       endif
      end do
c
      write(6,*) (coef1(i,it-30),i=1,71)
      END DO   !loop for Cross Validation
c== write out eval,reval and coef
      do ir=1,41
        do i=1,10
        evout(i)=ceval(i,ir)
        end do
        write(6,777) evout
      end do
 777  format(10f7.3)
      do ir=1,41
        do i=1,ltime
          rot(i)=coef1(i,ir)
        enddo
          write(90) rot
        do i=1,ltime
          rot(i)=coef2(i,ir)
        enddo
          write(90) rot
        do i=1,ltime
          rot(i)=coef3(i,ir)
        enddo
          write(90) rot
ccc corr between eof form full field and that from full-1 field
        do i=1,ngrd
         vec1(i)=evec3(i,ir)
         vec2(i)=vfull(i,3)
c        vec2(i)=evec3(i,1)
        enddo
        call acc(vec1,vec2,ngrd,ac(ir))
      end do
      write(6,777) ac

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
C  acc in time domain
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
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  acc in time domain
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

