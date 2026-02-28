      subroutine comput(nl,nr,nplots,iulf,iurf)
#include "parm.h"
c
c.....This version assumes that:
c.....  the LEFT field dimension  >= the RIGHT field dimension
c
      parameter (nwk=nmaxr**2+5*(nmaxr-1))
      real sv(ndimsv),u(nmaxl,nmaxr),v(nmaxr,nmaxr),
     1    c(nmaxl,nmaxr),a(nmon,nyr,nrot),b(nmon,nyr,nrot),
     1    va(nf),vb(nf),heteol(nmax,nf),heteor(nmax,nf),
     1    homol(nmax,nf),homor(nmax,nf),
     1    array(idl,jdl),barray(idr,jdr),covab(nf),valx(nf),vbrx(nf),
     1    varx(nf),vblx(nf)
      common/source/xldata(nmax,nmon,nyr),rdata(nmax,nmon,nyr)
      dimension ss(10),ss1(10),wk(nwk),aa(nmaxl,nmaxr),dum1(1),dum2(1),
     *    pt(nmaxr,nmaxr)
      character*30 labex
      logical wantq,wantp
c
      integer one
      one=1
c
      read(79,'(a30)') labex
      print *,'title=',labex
      print *,'in comput, nl=',nl,' nr=',nr,' nplots=',nplots
      total=nyr*nmon
c
      irank=nmaxr
      ncolb=0
      wantq=.true.
      wantp=.true.
      ifail=0
c
      do j=1,nr
        do i=1,nl
          c(i,j)=0.
        enddo
      enddo
      do iyr=1,nyr
        do imon=1,nmon
          do j=1,nr
            do i=1,nl
              c(i,j)=c(i,j)+rdata(j,imon,iyr)*xldata(i,imon,iyr)/total
            enddo
          enddo
        enddo
      enddo
      do j=1,nr
        do i=1,nl
          aa(i,j)=c(i,j)
        enddo
      enddo
c
c.....NAG ROUTINE F02WEF
c.....(f02wee on the T90; f02wef on the SGI)
c
      call f02wee(nl,nr,aa,nmaxl,ncolb,dum1,one,wantq,dum2,one,sv,wantp,
     *  pt,nmaxr,wk,ifail)
      write(6,'(/,10x,''ifail= '',i5)') ifail
      write(6,'(/,10x,''irank= '',i5)') irank
      do j=1,nr
        do i=1,nl
          u(i,j)=aa(i,j)
        enddo
      enddo
      do j=1,nl
        do i=1,nl
          v(i,j)=pt(j,i)
        enddo
      enddo
c
      do k=1,nrot
        do iyr=1,nyr
          do imon=1,nmon
            a(imon,iyr,k)=0.
            b(imon,iyr,k)=0.
          enddo
        enddo
      enddo
      do k=1,nrot
        do iyr=1,nyr
          do imon=1,nmon
            do i=1,nl
              a(imon,iyr,k)=a(imon,iyr,k)+u(i,k)*xldata(i,imon,iyr)
            enddo
          enddo
        enddo
        do iyr=1,nyr
          do imon=1,nmon
            do i=1,nr
              b(imon,iyr,k)=b(imon,iyr,k)+v(i,k)*rdata(i,imon,iyr)
            enddo
          enddo
        enddo
      enddo
      if(lrsvd.eq.0) then
        sum1=0.
        sum2=0.
        do i=1,irank
          sum1=sum1+sv(i)*sv(i)
        enddo
        write(6,4) irank,sum1
    4   format(10x,'sum of squares of first ',i5,' singular values ', 
     *    e11.4)
        do j=1,nr
          do i=1,nl
            sum2=sum2+c(i,j)*c(i,j)
          enddo
        enddo
        write(6,5) sum2
    5   format(10x,'square of frobenius norm of covariance matrix ',
     1    e11.4)
        write(6,6)
    6   format(/,2x,'squared covariance fraction')
        do i=1,10
          ss(i)=sv(i)*sv(i)/sum1
        enddo
        write(6,7) (ss(i),i=1,10)
    7   format(2x,5e11.4)
        write(6,8)
    8   format(/,2x,'cumulative squared covariance fraction')
        ss1(1)=ss(1)
        do i=2,10
          ss1(i)=ss1(i-1)+ss(i)
        enddo
        write(6,9) (ss1(i),i=1,10)
    9   format(2x,5e11.4)
        write(6,2)
    2   format(/,2x,'singular values')
        write(6,3) (sv(i),i=1,10)
    3   format(2x,5e11.4)
      else
        write(*,'(''Computing Rotated SVD'')')
        call rotsvd(u,v,sv,a,b,nl,nr,ss,ss1)
      endif
      call crosst(a,b,va,vb,covab)
      call crosss(b,xldata,1,nl,heteol)
      call crosss(a,rdata,1,nr,heteor)
      call crosss(a,xldata,1,nl,homol)
      call crosss(b,rdata,1,nr,homor)
      call exvar(homol, va,0,nl,valx)
      call exvar(homor, vb,0,nr,vbrx)
      write(6,21)
   21 format(/,2x,'fraction of variance of l-field explained by a')
      write(6,22) (valx(k),k=1,nf)
   22 format(2x,5e11.4)
      write(6,23)
   23 format(/,2x,'fraction of variance of r-field explained by b')
      write(6,22) (vbrx(k),k=1,nf)
      call exvar(heteol, vb,0,nl,vblx)
      call exvar(heteor, va,0,nr,varx)
      write(6,24)
   24 format(/,2x,'fraction of variance of l-field explained by b')
      write(6,22) (vblx(k),k=1,nf)
      write(6,25)
   25 format(/,2x,'fraction of variance of r-field explained by a')
      write(6,22) (varx(k),k=1,nf)
      write(61) a
      write(61) b
      write(61) (sv(k),k=1,10)
      write(61) ss
      write(61) ss1
      write(61) covab
      write(61) valx
      write(61) vbrx
      write(61) vblx
      write(61) varx
c
      do 300 k=1,nplots
c...... project svd a on left field 
        call crossl(a,k,iulf,array)
        write(81,301) labex,k,ss(k),covab(k),valx(k)
  301   format(a30,' a.l hm#',i1,' scf=',f4.2,' r(a,b)=',f4.2,
     1    ' var by a=',f6.3)
        write(61) array
        write(71) array

c...... project svd b on right field 
        call crossr(b,k,iurf,barray)
        write(82,302) labex,k,ss(k),covab(k),vbrx(k)
  302   format(a30,' b.r hm#',i1,' scf=',f4.2,' r(a,b)=',f4.2,
     1    ' var by b=',f6.3)
        write(61) barray
        write(72) barray

c...... project svd b on left field 
        call crossl(b,k,iulf,array)
        write(83,303) labex,k,ss(k),covab(k),vblx(k)
  303   format(a30,' b.l ht#',i1,' scf=',f4.2,' r(a,b)=',f4.2,
     1    ' var by b=',f5.2)
        write(61) array
        write(73) array

c...... project svd a on right field 
        call crossr(a,k,iurf,barray)
        write(84,304) labex,k,ss(k),covab(k),varx(k)
  304   format(a30,' a.r ht#',i1,' scf=',f4.2,' r(a,b)=',f4.2,
     1    ' var by a=',f5.2)
        write(61) barray
        write(74) barray

  300 continue
      return
      end
