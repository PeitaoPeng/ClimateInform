      program ssa
      include "parm.h"
      parameter(nt=nd-lag+1)
c
      dimension work(nd),data(nt,lag),w1d(lag)
      dimension work2(nd)
c
      real aaa(lag,nt),w(lag),wk(nt),wkk(lag,lag)
      real eval(lag),evec(lag,lag),coef(lag,nt)
c
c-----read in 1-D data
c
      open(unit=10,form='unformatted',access='direct',recl=4)
      pi=3.14159
      do k=1,nd
      read(10,rec=k)work(k)
c     work(k)=sin(2*pi*k/10)
      enddo
c
c-----generate lagged matrix
c
      call norm(work,nd,nd)
      do j=1,lag
      do i=1,nt
      aaa(j,i)=work(i+j-1)
      enddo
      enddo
c
c-----calculate eof modes
c
      id=1  !=0 for covariance, .0 for correlation
      call eofs(aaa,lag,nt,lag,w,evec,coef,wkk,id)
c
c-----write out PC modes
c
      open(20,form='unformatted',access='direct',recl=4*nt)
      iw=0
      do n=1,lag
        do k=1,nt
          wk(k)=coef(n,k)
        enddo
      iw=iw+1
      call norm(wk,nt,nt)
        do j=1,nt
        coef(n,j)=wk(j)
        enddo
      write(20,rec=iw) wk
      enddo
c
c-----write out the EOF modes
c
      open(30,form='unformatted',access='direct',recl=4*lag)
      iw=0
      do k=1,lag
        do i=1,lag
          w1d(i)=evec(i,k)
        enddo
      iw=iw+1
      call norm(w1d,lag,lag)
      do j=1,lag
        w1d(j)=sqrt(w(k))*w1d(j)
        evec(j,k)=w1d(j)
      enddo
      write(30,rec=iw)w1d
      enddo
c
c-----calculate percentage of variances by each mode
c
      open(40,form='formatted')
      var=0.0
      do k=1,lag
      var=var+w(k)
      enddo
      write(40,*)'total var=', totalvar, var
      write(40,*)'mode','         pct variance','      pct acc. var'
      vr=0.0
      do k=1,lag
      vp=w(k)/var
      vr=vr+vp
      write(40,*)'k=', k, '      ',vp, '    ',vr
      enddo
c
c----reconstruct time series and write them and original out
c
      open(50,form='unformatted',access='direct',recl=4*nd)
      write(50,rec=1)work
c
      iw=1
      do nm=1,nmode

      do i=1,nt
      do j=1,lag
        data(i,j)=0.
        do m=1,nm
        data(i,j)=data(i,j)+coef(m,i)*evec(j,m)
        enddo
      enddo
      enddo
c
      do i=1,nt
      do j=1,lag
      work2(i+j-1)=data(i,j)
      enddo
      enddo
c
      iw=iw+1
      write(50,rec=iw)work2

      enddo  !loop nm
        
      stop
      end
c
      subroutine norm(u,nt,m)
      dimension u(nt)
      su=0.
      do i=1,m
      su=su+u(i)*u(i)/float(m)
      enddo
      su=sqrt(su)
      if(su.le.1.0e-10)then
      write(6,*)'Input may be zero'
      stop 1501
      endif
      do i=1,m
      u(i)=u(i)/su
      enddo
      return
      end
c
      SUBROUTINE setzero(fld,n,m)
      DIMENSION fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end
