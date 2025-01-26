      program ssa
      include "parm.h"
      parameter(nt=nd-lag+1)
      dimension work(nd),data(nt,lag),w1d(lag)
      dimension work2(nd),data2(nt,lag)
      dimension w(lag),u(nt,lag),v(nt,lag),rv1(lag)
      dimension varn(lag)
      dimension su(lag),sv(lag),wk(nt)
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
      call norm1d(work,nd,nd,std)
      do i=1,nt
      do j=1,lag
        data(i,j)=work(i+j-1)
      enddo
      enddo
c
c-----calculate SVD modes
c
      call svdeof(data,nt,lag,w,u,v,rv1)
c
c
c-----has been used to check the correction of modes
c
      call vart(data,nt,lag,u,lag,totalvar,varn,w,v)
      write(6,*)'check variance'
      do k=1,lag
      write(6,*) varn(k)
      enddo
c
c-----normalize PCs and write them out
c
      open(20,form='unformatted',access='direct',recl=4*nt)
      iw=0
      do n=1,lag
        do k=1,nt
          wk(k)=u(k,n)
        enddo
        call norm1d(wk,nt,nt,su(n))
        do k=1,nt
          u(k,n)=wk(k)
        enddo
      iw=iw+1
      write(20,rec=iw) wk
      enddo
c
c-----write out the EOF modes
c
      open(30,form='unformatted',access='direct',recl=4*lag)
      iw=0
      do k=1,lag
        do i=1,lag
          w1d(i)=v(i,k)*w(k)*su(k)  !absorb std of PCs and eiganvalues to eofs
        enddo
        do i=1,lag
          v(i,k)=w1d(i)
        enddo
        
      iw=iw+1
      write(30,rec=iw)w1d
      enddo
c
c-----calculate percentage of variances by each mode
c
      open(40,form='formatted')
      var=0.0
      do k=1,lag
      var=var+w(k)*w(k)
      enddo
      write(40,*)'total var=', totalvar, var
      write(40,*)'mode','         pct variance','      pct acc. var'
      vr=0.0
      do k=1,lag
      vp=w(k)*w(k)/var
      vr=vr+vp
      write(40,*)'k=', k, '      ',vp, '    ',vr
      enddo
c
c----reconstruct time series and write them and original out
c
      open(50,form='unformatted',access='direct',recl=4*nd)
      write(50,rec=1)work  !write out original
c
      iw=1
      do nm=1,nmode
 
      do i=1,nt
      do j=1,lag
        data2(i,j)=0.
        do m=1,nm
c       data2(i,j)=data2(i,j)+u(i,m)*w(m)*v(j,m)
        data2(i,j)=data2(i,j)+u(i,m)*v(j,m)
        enddo
      enddo
      enddo
c
      do i=1,nt
      do j=1,lag
      work2(i+j-1)=data2(i,j)
      enddo
      enddo
c
      iw=iw+1
      write(50,rec=iw)work2

      enddo  !loop nmode
c
      stop
      end
c

      subroutine svdeof(col,ist,ntt,w,u,v,rv1)
      dimension col(ist,ntt),w(ntt),u(ist,ntt),v(ist,ntt),rv1(ntt)
      logical matu,matv
      matu=.true.
      matv=.true.
      call svd(ist,ist,ntt,col,w,matu,u,matv,v,ierr,rv1)
      write(6,*)'ierr=',ierr
      if(ierr.ne.0)then
      write(6,*)'The SVD is failed'
      stop 1300
      endif
c     write(6,*)'singular values'
c     write(6,*)w
c     write(6,*)'right vectors'
c     write(6,*)v
c
c-----order the SVD modes
c
      call ordersvd(w,ntt,u,v,ist)
c
c-----normalize u and v (probably redundent,just to make sure)
c
      call norm(u,ist,ntt,ist,ntt)
      call norm(v,ist,ntt,ntt,ntt)
c
c-----write out noise singular values
c
c     write(6,*)'Singular values'
      write(6,*)w
       return
       end
c
      subroutine ordersvd(w,nt,u,v,ist)
      dimension w(nt),u(ist,nt),v(ist,nt)
      dimension temp(10000,400),wp(400),kw(400)
      if(ist.gt.10000.or.nt.gt.400)then
      write(6,*)'Increase memory in Subroutine ordersvd'
      stop 1200
      endif
c
c-----order the SVD modes (because the SVD subroutine
c-----does not do the ordering)
c
      do i=1,400
      wp(i)=0.0
      enddo
c
      do j=1,nt
       pp=-1.0
       kk=0
        do k=1,nt
         if(w(k).gt.pp)then
         pp=w(k)
         kk=k
         endif
        enddo
       if(kk.ne.0)then
       wp(j)=pp
       kw(j)=kk
       w(kk)=-1.0
       else
       write(6,*)'The SVD is not correct'
       stop 1100
       endif
      enddo
       do k=1,nt
       w(k)=wp(k)
       enddo
       do k=1,nt
       do i=1,ist
       temp(i,k)=u(i,kw(k))
       enddo
       enddo
       do k=1,nt
       do i=1,ist
       u(i,k)=temp(i,k)
       enddo
       enddo
       do k=1,nt
       do i=1,ist
       temp(i,k)=v(i,kw(k))
       enddo
       enddo
       do k=1,nt
       do i=1,ist
       v(i,k)=temp(i,k)
       enddo
       enddo
       return
       end
      subroutine vart(col,ist,nt,e,mode,tvar,evar,w,v)
      dimension col(ist,nt),e(ist,mode),evar(mode),w(mode)
      dimension v(ist,mode),aa(100)
      dimension pc(120)
      if(nt.gt.500)then
      write(6,*)'Increase the working memory in vart'
      stop 1700
      endif
      write(6,*)'check first 10 values'
c
      do i=1,100
      aa(i)=0.0
      enddo
c
      do i=1,100
      do n=1,mode
      aa(i)=aa(i)+e(i,n)*w(n)*v(1,n)
      enddo
      write(6,*)aa(i),col(i,1)
      enddo
c
c------calculate the variance of the original data
c
      tvar=0.0
      do i=1,ist
       do k=1,nt
        tvar=tvar+col(i,k)*col(i,k)
       enddo
      enddo
c
c------calculate the variance for each mode
c
      do n=1,mode
      evar(n)=0.0
        do k=1,nt
         pc(k)=0.0
        do i=1,ist
         pc(k)=pc(k)+col(i,k)*e(i,n)
        enddo
        evar(n)=evar(n)+pc(k)*pc(k)
        enddo
      enddo
      do k=1,mode
      write(6,*)'var=',evar(k),' w2=',w(k)*w(k)
      enddo
      return
      end
c
      subroutine norm1d(u,nt,m,su)
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
      subroutine norm(u,ist,nt,m,n)
      dimension u(ist,nt)
      do k=1,n
      su=0.
      do i=1,m
      su=su+u(i,k)*u(i,k)
      enddo
      su=sqrt(su)
      if(su.le.1.0e-10)then
      write(6,*)'Input may be zero'
      stop 1501
      endif
      do i=1,m
      u(i,k)=u(i,k)/su
      enddo
c     write(6,*)'test su=',su
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
