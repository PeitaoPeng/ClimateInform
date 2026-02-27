      program eof
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. correlation between tropical area averaged sst and global field
C===========================================================
      PARAMETER (imax=64,jmax=40)
      PARAMETER (nw=2*ifld+15,nmod=20)
      PARAMETER (lats=16,late=25,lons=1,lone=64)  ! 20S-20N tp prcp
      PARAMETER (ngrd=(late-lats+1)*(lone-lons+1))
      real fldin(imax,jmax),fld1(imax,jmax),fldtp(imax,10)
      real stdv(imax,jmax),corr(imax,jmax),rcorr(imax,jmax)
      real regr(imax,jmax),rregr(imax,jmax)
      real aaa(ngrd,ifld),wk(ifld,ngrd),tt(nmod,nmod)
      real eval(ifld),evec(ngrd,ifld),coef(ifld,ifld)
      real rot(ifld),rot2(ifld)
      real weval(ifld),wevec(ngrd,ifld),wcoef(ifld,ifld)
      real reval(nmod),revec(ngrd,ifld),rcoef(nmod,ifld)
      real xlat(jmax),coslat(jmax)
      real rwk(ngrd),rwk2(ngrd,nmod)
      real varc(imax,jmax)
      data xlat/ -86.598,-82.191,-77.758,-73.319,-68.878,-64.435,
     &-59.992,-55.549,-51.106,-46.662,-42.218,-37.774,-33.330,-28.886,
     &-24.442,-19.998,-15.554,-11.110, -6.666,-2.222,
     & 2.222,6.666,11.110,15.554,19.998,24.442,28.886,33.330,37.774,
     & 42.218,46.662,51.106,55.549,59.992,64.435,68.878,73.319,
     & 77.758,82.191,86.598/

      open(unit=11,form='unformated',access='direct',recl=imax*jmax)
      open(unit=90,form='unformated',access='direct',recl=ifld)
      open(unit=95,form='unformated',access='direct',recl=ifld)
      open(unit=80,form='unformated',access='direct',recl=imax*10)
      open(unit=85,form='unformated',access='direct',recl=imax*10)
      open(unit=70,form='unformated',access='direct',recl=imax*10)
 
ccc have coslat
      do j=1,jmax
        coslat(j)=sqrt(cos(xlat(j)*3.14159/180))
      enddo
c
ccc loop over indv runs and time
c
      iu=11
c
      if(iskip.ge.1) then
      do is=1,iskip
        read(iu) fldin
      end do
      end if
c
      call setzero(varc,jmax,jmax)
      iread=0
      do it = istart,ltime,12
        iread=iread+1
      write(6,*) 'to read ',iread
        read(iu,rec=it) fldin
        call glb_2_tp(imax,jmax,fldin,imax,10,fldtp)
        write(85,rec=iread) fldtp
c
        do j=1,jmax
        do i=1,imax
          varc(i,j)=varc(i,j)+fldin(i,j)*fldin(i,j)/float(ifld)
        end do
        end do
c
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
c
cc... EOF analysis begin
      write(6,*) 'eof begins'
      call eofs(aaa,ngrd,ifld,ifld,eval,evec,coef,wk,ID)
c* write out EOF
      do nm=1,nmod
        ng=0
        do j=1,10
        do i=1,imax
          ng=ng+1
          fldtp(i,j)=evec(ng,nm)
        end do
        end do
        write(70) fldtp
      enddo
c     call eofs(aaa,ngrd,ifld,ngrd,eval,evec,coef,wk,ID)
      call REOFS(aaa,ngrd,ifld,ifld,wk,ID,weval,wevec,wcoef,
c     call REOFS(aaa,ngrd,ifld,ngrd,wk,ID,weval,wevec,wcoef,
     &           nmod,reval,revec,rcoef,tt,rwk,rwk2)
cc... arange reval,revec and rcoef in decreasing order
      call order(ngrd,ifld,nmod,reval,revec,rcoef)
cc... write out eval and reval
      totv1=0
      do i=1,nmod
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

CCC...CORR between coef(or rcoef) and data

      DO m=1,nmod     !loop over mode (1-4)

      call setzero(stdv,imax,jmax)
      call setzero(corr,imax,jmax)
      call setzero(rcorr,imax,jmax)
      sdcf=0
      rsdcf=0

c
       if(iskip.ge.1) then
       do is=1,iskip
         read(iu) fldin
       end do
       end if
c
      do it  =istart,ltime,12   !loop over time
       ir=ir+1
       read(iu,rec=it) fldin
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
        corr(i,j)=corr(i,j)/(sdcf*stdv(i,j))
        rcorr(i,j)=rcorr(i,j)/(rsdcf*stdv(i,j))
        regr(i,j)=corr(i,j)*stdv(i,j)
        rregr(i,j)=rcorr(i,j)*stdv(i,j)
      end do
      end do

      
      call glb_2_tp(imax,jmax,corr,imax,10,fldtp)
      write(80) fldtp
      call glb_2_tp(imax,jmax,rcorr,imax,10,fldtp)
      write(80) fldtp
      call glb_2_tp(imax,jmax,regr,imax,10,fldtp)
      write(80) fldtp
      call glb_2_tp(imax,jmax,rregr,imax,10,fldtp)
      write(80) fldtp 

      var=0
      do j=lats,late
      do i=lons,lone
        var=var+varc(i,j)
      end do
      end do
c     write(6,*) 'var=',var
c
      do n=1,ifld
        rot(n)=rcoef(m,n)
        rot2(n)=coef(m,n)
      end do
      call normal(rot,ifld)
      call normal(rot2,ifld)
      do n=1,ifld
c       rot(n)=rot(n)*reval(m)
        rot2(n)=rot2(n)*sqrt(eval(m)*var/100.)
      end do
      write(90) rot
      write(95) rot2
c
      END DO    !loop over mode 

cc... check the othorgnal property
c
      sum=0
      do 120 ng=1,ngrd
         sum=sum+revec(ng,1)*revec(ng,3)
120   continue
      write(6,*) 'sum of evec= ',sum
      sum=0
      do 130 nt=1,ifld
         sum=sum+coef(2,nt)*coef(1,nt)
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

      SUBROUTINE glb_2_tp(ig,jg,fg,it,jt,ft)
      DIMENSION fg(ig,jg),ft(it,jt)
      do i=1,it
      do j=16,25
         ft(i,j-15)=fg(i,j)
      enddo
      enddo
      return
      end


