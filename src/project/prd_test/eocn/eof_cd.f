      program eof
      include "parm.h"
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
      real pcs(ifld,nmod)
      real out(36,19)
 
      open(unit=11,form='formatted')
      open(unit=81,form='unformatted',access='direct',recl=4*36*19)
      open(unit=82,form='unformatted',access='direct',recl=4)
      open(unit=91,form='unformatted',access='direct',recl=4*36*19)
      open(unit=92,form='unformatted',access='direct',recl=4)

ccc feed matrix aaa

      iread=0
      iu=11
      do it=1,ltime
        iread=iread+1
        read(iu,888) fldin
 888  format(10f7.1)
        do i=1,ngrd
          aaa(i,iread)=fldin(i)
        end do
      end do

cc... EOF analysis begin

      call eofs(aaa,ngrd,ifld,ifld,eval,evec,coef,wk,ID)
c
      call REOFS(aaa,ngrd,ifld,ifld,wk,ID,weval,wevec,wcoef,
     &           nmod,reval,revec,rcoef,tt,rwk,rwk2)
cc... arange reval,revec and rcoef in decreasing order
      call order(ngrd,ifld,nmod,reval,revec,rcoef)
c
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

ccc...CORR and regr between RPC and data

      iw=0
      DO m=1,mode   !loop over mode

      do i=1,ngrd
        do it=1,ltime      !loop over time
        rin(it)=rcoef(m,it)
        rot(it)=aaa(i,it)
        end do
        call normal(rin,ltime)
        call regr_t(rin,rot,ltime,fld1(i),fld2(i))
      end do
c
      do it=1,ltime 
        pcs(it,m)=rin(it)
      enddo

      iw=iw+1
      call CD102_2_2x2(fld1,out)
      write(81,rec=iw) out     !regr
      iw=iw+1
      call CD102_2_2x2(fld2,out)
      write(81,rec=iw) out     !corr
c
      ENDDO  !over m
c
      iw=0
      do it=1,ifld
        do m=1,nmod
        iw=iw+1
        write(82,rec=iw) pcs(it,m)
        enddo
      enddo
c
ccc...CORR and regr between PC and data

      iw=0
      DO m=1,mode   !loop over mode 

      do i=1,ngrd
        do it=1,ltime      !loop over time
        rin(it)=coef(m,it)
        rot(it)=aaa(i,it)
        end do
        call normal(rin,ltime)
        call regr_t(rin,rot,ltime,fld1(i),fld2(i))
      end do
c
      do it=1,ltime 
        pcs(it,m)=rin(it)
      enddo

      iw=iw+1
      call CD102_2_2x2(fld1,out)
      write(91,rec=iw) out     !regr
      iw=iw+1
      call CD102_2_2x2(fld2,out)
      write(91,rec=iw) out     !corr
c
      ENDDO  !over m
c
      iw=0
      do it=1,ifld
        do m=1,nmod
        iw=iw+1
        write(92,rec=iw) pcs(it,m)
        enddo
      enddo


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
c
      SUBROUTINE regr_t(f1,f2,ltime,reg,cor)

      real f1(ltime),f2(ltime)

      cor=0.
      sd1=0.
      sd2=0.

      do it=1,ltime
         cor=cor+f1(it)*f2(it)/float(ltime)
         sd1=sd1+f1(it)*f1(it)/float(ltime)
         sd2=sd2+f2(it)*f2(it)/float(ltime)
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      reg=cor/(sd1)
      cor=cor/(sd1*sd2)

      return
      end
