      subroutine rotsvd(u,v,sv,a,b,nl,nr,ss,ss1)
#include "parm.h"
      parameter (iwk=2*(nmaxl+nmaxr)+nrot*nrot+5*(nrot-1))
      parameter (ndiml=nmaxl+nmaxr)
      dimension u(nmaxl,nmaxr),v(nmaxr,nmaxr),sv(ndimsv),wk(iwk),
     * a(nmon,nyr,nrot),b(nmon,nyr,nrot),
     * ar(nmon,nyr,nrot),br(nmon,nyr,nrot),cfr(nrot),cumcfr(nrot),
     * xl(ndiml,nrot),cf(nrot),cumcf(nrot),flr(ndiml,nrot),r(nrot,nrot),
     * ss(10),ss1(10),kk(nrot),sigma(nrot),wl(nrot), wr(nrot)
c    *,xnorml(nrot),xnormr(nrot)
#ifdef check
      dimension test(nrot,nrot)
#endif
c     common/source/ xldata(nmax,nmon,nyr),rdata(nmax,nmon,nyr)
      character*1 stand
c.....Nag routine constants 
      stand='U'
      g=1.0
      maxit=100
      acc=0.0001
      ifail=0
c
      nlpnr=nl+nr
      xl=0.
      
      do k=1,nrot
        sigma(k)=sqrt(sv(k))
      enddo
      do k=1,nrot
        do i=1,nl
          xl(i,k)=u(i,k)*sigma(k)
        enddo
        do i=1,nr
          xl(i+nl,k)=v(i,k)*sigma(k)
        enddo
      enddo
c
      print *,'call g03bae'
      call g03bae(stand,g,nlpnr,nrot,xl,ndiml,flr,r,nrot,acc,maxit,
     *            iter,wk,ifail)
      print *,'done g03bae'
c
c     xnorml=0.
c     xnormr=0.
c     do k=1,nrot
c       do iyr=1,nyr
c         do imon=1,nmon
c           xnorml(k)=xnorml(k)+a(imon,iyr,k)*a(imon,iyr,k)
c           xnormr(k)=xnormr(k)+b(imon,iyr,k)*b(imon,iyr,k)
c         enddo
c       enddo
c       xnorml(k)=sqrt(xnorml(k))
c       xnormr(k)=sqrt(xnormr(k))
c     enddo
c     
      do k=1,nrot
        suml=0. 
        sumr=0.
        do i=1,nl
          suml=suml+flr(i,k)**2
        enddo
        do i=1,nr
          sumr=sumr+flr(i+nl,k)**2
        enddo
        wl(k)=sqrt(suml)
        wr(k)=sqrt(sumr)
      enddo
      ar=0.
      br=0.
      print *,'start to define ar & br'
      do k=1,nrot
        do iyr=1,nyr
          do imon=1,nmon
            do l=1,nrot
c             ar(imon,iyr,k)=ar(imon,iyr,k)+a(imon,iyr,l)*
c    *                       r(l,k)/xnorml(l)
c             br(imon,iyr,k)=br(imon,iyr,k)+b(imon,iyr,l)*
c    *                       r(l,k)/xnormr(l)
              ar(imon,iyr,k)=ar(imon,iyr,k)+a(imon,iyr,l)*
     *          r(l,k)*wl(k)/sigma(l)
              br(imon,iyr,k)=br(imon,iyr,k)+b(imon,iyr,l)*
     *          r(l,k)*wr(k)/sigma(l)
            enddo
          enddo
        enddo
      enddo
      print *,'done...defining ar & br'
      sumsv=0.
      sumsv1=0.
      do k=1,nr
        sumsv=sumsv+sv(k)
      enddo
      do k=1,nrot
        sumsv1=sumsv1+sv(k)
      enddo
      rtotal=1./float(nyr*nmon)
      print *,'rtotal=',rtotal
      write(6,'(5x,''sum of first '',i5,'' singular values '',e11.4)')
     *  nr,sumsv
      write(6,'(5x,''sum of first '',i5,'' singular values '',e11.4)')
     *  nrot,sumsv1
      write(6,'(5x,''singular values 1-10:''/10e11.4)')(sv(k),k=1,10)
      write(6,'(5x,''singular values 11-20:''/10e11.4)')(sv(k),k=11,20)
      print *,'compute sum, sum1'
      do k=1,nrot
        sum=0.
        sum1=0.
        do iyr=1,nyr
          do imon=1,nmon
            sum=sum+ar(imon,iyr,k)*br(imon,iyr,k)*rtotal
            sum1=sum1+a(imon,iyr,k)*b(imon,iyr,k)*rtotal
          enddo
        enddo
        cf(k)=sum1/sumsv
        cfr(k)=sum/sumsv
      enddo
      print *,'done compute sum, sum1'
      print *,'compute cumcf, cumcfr'
      cumcf(1)=cf(1)
      cumcfr(1)=cfr(1)
      do k=2,nrot
        cumcf(k)=cumcf(k-1)+cf(k)
        cumcfr(k)=cumcfr(k-1)+cfr(k)
      enddo
      print *,'done compute cumcf, cumcfr'
      write(6,'(5x,''covariance fraction for 1st 20 unrotated SVDs:''
     * /20f6.3)') (cf(k),k=1,20)
      write(6,'(5x,''cumulative covariance fraction for 1st 20'',
     * '' unrotated SVDs:''/20f6.3)') (cumcf(k),k=1,20)
      write(6,'(5x,''covariance fraction for 20 rotated SVDs '',
     *''(unordered):''/20f6.3)') (cfr(k),k=1,20)
      write(6,'(5x,''cumulative covariance fraction for  20'',
     * '' rotated SVDs (unordered):''/20f6.3)') (cumcfr(k),k=1,20)
c
      do k=1,nrot
        kk(k)=k
      enddo
c
      call order(cfr,kk,nrot)
c
      write(6,'(5x,''covariance fraction for 20 rotated SVDS '',
     * ''(ordered):''/20f6.3)') (cfr(k),k=1,20)
c
      cumcfr(1)=cfr(1)
      do k=2,nrot
        cumcfr(k)=cumcfr(k-1)+cfr(k)
      enddo
c
      write(6,'(5x,''cumulative covariance fraction for 20'',
     * '' rotated SVDs (ordered):''/20f6.3)') (cumcfr(k),k=1,20)
c
      do k=1,10
        ss(k)=cfr(k)
        ss1(k)=cumcfr(k)
      enddo
      do j=1,nrot
        k=kk(j)
        do iyr=1,nyr
          do imon=1,nmon
             a(imon,iyr,j)=ar(imon,iyr,k)
             b(imon,iyr,j)=br(imon,iyr,k)
          enddo
        enddo
      enddo
#ifdef check
      test=0.
      do i=1,nrot
        do j=1,nrot
          do k=1,nl
            test(i,j)=test(i,j)+u(k,i)*u(k,j)
          enddo
        enddo
      enddo
      print*,'TESTING ORTHOGONALITY OF UNROTATED LEFT SINGULAR VECTORS'
      do i=1,nrot
        write(*,'(1x,20f6.3)') (test(i,j),j=1,nrot)
      enddo
      test=0.
      do i=1,nrot
        do j=1,nrot
          do k=1,nr
            test(i,j)=test(i,j)+v(k,i)*v(k,j)
          enddo
        enddo
      enddo
      print*,'TESTING ORTHOGONALITY OF UNROTATED RIGHT SINGULAR VECTORS'
      do i=1,nrot
        write(*,'(1x,20f6.3)') (test(i,j),j=1,nrot)
      enddo
      test=0.
      do i=1,nrot
        do j=1,nrot
          do k=1,nrot
            test(i,j)=test(i,j)+r(i,k)*r(j,k)
          enddo
        enddo
      enddo
      print*,'TESTING ORTHOGONALITY OF TRANSFORMATION MATRIX'
      do i=1,nrot
        write(*,'(1x,20f6.3)') (test(i,j),j=1,nrot)
      enddo
      do k=1,nrot
        cfr(k)=wl(k)*wr(k)
      enddo
      print*,'PRODUCT OF WL & WR'
      write(*,'(1x,10e11.4)') (cfr(k),k=1,20)
      test=0.
      do i=1,10
        do j=1,10
          do iyr=1,nyr
            do imon=1,nmon
              test(i,j)=test(i,j)+a(imon,iyr,i)*b(imon,iyr,j)*rtotal
            enddo
          enddo
        enddo
      enddo
      print*,'TESTING ORTHOGONALITY OF ROTATED EXPANSION COEFFICIENTS'
      do i=1,10
        write(*,'(1x,10e11.4)') (test(i,j),j=1,10)
      enddo
#endif
      return
      end
