      program ssa test
      include "parm.h"
      parameter(nt=nd-lag+1)
      dimension work(nd),data(nt,lag),w1d(lag)
      dimension work2(nd),data2(nt,lag)
      dimension w(lag),u(nt,lag),v(nt,lag),rv1(lag)
      dimension wk(nt),fld2d(nend,nd)
c
c-----read in 1-D data
c
      open(unit=10,form='unformatted',access='direct',recl=4)
      pi=3.14159
      undef=-9999.0
      do k=1,nd
      read(10,rec=k) work(k)
c     work(k)=sin(2*pi*k/10)
      enddo
c
c-----generate lagged matrix
c
      call norm1d(work,nd,nd,std)
      write(6,*) 'std of ori=',std
      do i=1,nt
      do j=1,lag
        data(i,j)=work(i+j-1)
      enddo
      enddo
c
c-----calculate SVD modes
c
      write(6,*) 'start 1st part'
      call svd_sub(data,u,v,w,nt,nt,lag)
      write(6,*) 'finished svd'
c
c-- PC
      open(unit=20,form='unformatted',access='direct',recl=4*nt)
c-- EOF
      open(unit=30,form='unformatted',access='direct',recl=4*lag)
c
      iw=0
      do n=1,lag
        do k=1,nt
          wk(k)=u(k,n)
        enddo
        do k=1,lag
          w1d(k)=v(k,n)
        enddo
      iw=iw+1
      write(20,rec=iw) wk  !PC
      write(30,rec=iw) w1d !EOF
      enddo  !n
c
c-----write variance and the accumulated variances by each mode
c
      open(40,form='formatted')
      vr=0.
      do k=1,lag
      vr=vr+w(k)
      write(40,*)'k=', k, '      ',w(k), '    ',vr
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

      write(6,*) 'nmode=',nmode,'nm=',nm

      enddo  !loop nmode
c
c----examine end point effect
c
      open(60,form='unformatted',access='direct',recl=4)
c
      call setundef(fld2d,nend,nd,undef)
c
      write(6,*) 'start 2nd part'
      do n=1,nend
c
      mondel=1*12
      nend1=nd-nend*mondel
      nt2=nend1-lag+n*mondel
c
      do i=1,nt2
      do j=1,lag
        data(i,j)=work(i+j-1)
      enddo
      enddo
c
      call svd_sub(data,u,v,w,nt,nt2,lag)
c
      do i=1,nt2
      do j=1,lag
        data2(i,j)=0.
        do m=1,mode_recon
        data2(i,j)=data2(i,j)+u(i,m)*v(j,m)
        enddo
      enddo
      enddo
c
      do i=1,nt2
      do j=1,lag
      fld2d(n,i+j-1)=data2(i,j)
      enddo
      enddo
c
      enddo !n loop

c----write out 
      iw=0
      do it=1,nd
        do n=1,nend
        iw=iw+1
        write(60,rec=iw) fld2d(n,it)
        enddo
      enddo
c
      stop
      end
