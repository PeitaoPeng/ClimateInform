      program caprd
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C CA prediction for tropical heating
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      parameter(natura=0)! natura=1 means natural analogue
      parameter(imz=72,jmz=37)   ! grid size of Z500
      parameter(imp=64,jmp=10)   ! grid size of prcp
      parameter(ims=18,ime=56)   ! grid to have skill
      parameter(ntt=24,nhs=ntt-1,modemax=12)!choice # of modes and ntt
      dimension xlat(jmp),cosl(jmp),fldp(imp,jmp)
      dimension anom(imp,jmp),ana(modemax,ntt),anac(modemax)
      dimension ana2(modemax,nhs+1)
      dimension t3(imp,jmp),t3eof(imp,jmp),t3c(imp,jmp)
      dimension e(modemax,imp,jmp)
      dimension alpha(nhs),corr(imp,jmp)
      dimension obs(imp,jmp),prd(imp,jmp),fld3d(imp,jmp,nhs)
      dimension obs3d(imp,jmp,ntt),prd3d(imp,jmp,ntt)
      dimension obs3d2(imp,jmp,ntt)
C
      data xlat/-19.998,-15.554,-11.110, -6.666,-2.222,
     &2.222,6.666,11.110,15.554,19.998/
C
      open(unit=10,form='unformatted',access='direct',recl=imp*jmp) !mon prcp
      open(unit=15,form='unformatted',access='direct',recl=imp*jmp) !mp prcp
C     open(unit=20,form='unformatted',access='direct',recl=imz*jmz) !z500
      open(unit=30,form='unformatted',access='direct',recl=imp*jmp) !prcp_eof
      open(unit=40,form='unformatted',access='direct',recl=imp*jmp) !ca
      open(unit=45,form='unformatted',access='direct',recl=imp*jmp) !prd-prcp
      open(unit=50,form='unformatted',access='direct',recl=imp*jmp) !corr skill
c*************************************************
      if (natura.eq.1)write(6,307)
      if (natura.eq.0)write(6,308)
c*************************************************
c*
      PI=4.*atan(1.)
      CONV=PI/180.
      DO j=1,jmp
        COSL(j)=COS(xlat(j)*CONV)
      END DO
      fak=1.
      ridge=0.05
c* read in the EOFs and store as othogonal e's
      do nmode=1,modemax
      read(30,rec=nmode) t3 !read regr
        do i=1,imp
        do j=1,jmp
          e(nmode,i,j)=t3(i,j)
        enddo
        enddo
      enddo
C* standardize spatial patterns to unity****
      do m1=1,modemax
      call inprod1(imp,jmp,modemax,e,cosl,m1,m1,anorm)
      write(6,*)m1,anorm
        do i=1,imp
        do j=1,jmp
          e(m1,i,j)=e(m1,i,j)/sqrt(anorm)
        end do
        end do
      call inprod1(imp,jmp,modemax,e,cosl,m1,m1,anorm)
      write(6,*)m1,anorm
      enddo
C*project "Jan" fields onto "Jan" eof's*******
      do nj=1,ntt
       read(10) anom
       do nmode=1,modemax
       call inprod4(e,anom,imp,jmp,cosl,nmode,modemax,anorm)
       ana(nmode,nj)=anorm
       enddo
c      write(6,100)nj,(ana(nmode,nj),nmode=1,10)
      enddo
      rewind 10
c 
C*********************************************
c
      do ntgt=1,ntt  !loop over target years
        read(10) t3 !read obs field
        do i=1,imp
        do j=1,jmp
          obs3d(i,j,ntgt)=t3(i,j)
        enddo
        enddo
        id=0
        do nt=1,ntt ! get "historical spectral data"
          if(nt.eq.ntgt) go to 555
          id=id+1
          do nmode=1,modemax
            ana2(nmode,id)=ana(nmode,nt)
          enddo
 555      continue
        enddo
          do nmode=1,modemax ! get target year data
            ana2(nmode,nhs+1)=ana(nmode,ntgt)
          enddo
      call getalpha(ana2,alpha,modemax,nhs,fak,ridge)
c
      call prout(alpha,njbase,mm,mm,ntt,6)
c
      af=0.
      do i=1,nhs
        af=af+alpha(i)*alpha(i)
      enddo
      write(6,*) 'alpha**2=',af
c     write(6,100) alpha
                 do nmode=1,modemax
                 anac(nmode)=0.
                 enddo
c
                 do nmode=1,modemax
                 do ntime=1,nhs
                 anac(nmode)=anac(nmode)+ana2(nmode,ntime)*alpha(ntime)
                 enddo
                 enddo
C
                 do i=1,imp
                 do j=1,jmp
                   t3c(i,j)=0.
                 enddo
                 enddo
                 do nmode=1,modemax
                 do i=1,imp
                 do j=1,jmp
                   t3c(i,j)=t3c(i,j)+anac(nmode)*e(nmode,i,j)
                 enddo
                 enddo
                 enddo
        call rmsd1(t3,t3c,imp,jmp,ims,ime,cosl)
                 do i=1,imp
                 do j=1,jmp
c                  t3c(i,j)=t3c(i,j)-t3(i,j)
c                  t3c(i,j)=-t3c(i,j)    !observed-ca
                 enddo
                 enddo
c
                 write(40) t3c   ! write IC-error for grads1
c       call ca_prd(10,ntt,ntgt,nhs,imp,jmp,alpha,obs,prd)
        call ca_prd(15,ntt,ntgt,nhs,imp,jmp,alpha,obs,prd)
        do i=1,imp
        do j=1,jmp
          prd3d(i,j,ntgt)=prd(i,j)
          obs3d2(i,j,ntgt)=obs(i,j)
        enddo
        enddo
        call rmsd1(obs,prd,imp,jmp,ims,ime,cosl)
        write(45) prd
      enddo   !loop over target years
      call corr_2d(imp,jmp,ntt,obs3d2,prd3d,corr)
      write(50) corr
C*********************************************
100   format(12f6.2)
c100   format(1h ,i6,10f6.2)
102   format(1h ,i6,3f6.2,i6)
103   format()
120   format(2i8)
121   format(2i8,' month+1,month')
1100   format(i4,12i5)
1102   format(2i4,12i6)
1104   format(1h ,12f6.1)
1105   format(1h ,i4,12f6.1)
1106   format(1h ,12f6.1,' obs us ave')
1112   format(1h ,2i5,f7.3)
307    format(1h ,'natural analogues')
308    format(1h ,'constructed analogue')
      stop
      end
c*
      subroutine ca_prd(iu,ntt,ntgt,nhs,im,jm,alpha,obs,prd)
      dimension wk(im,jm),fld3d(im,jm,nhs)
      dimension obs(im,jm),prd(im,jm),alpha(nhs)
      id=0
      do nt=1,ntt !have historical given month data for constructing prd
          read(iu,rec=nt) wk
          if(nt.eq.ntgt) go to 666
          id=id+1
          do i=1,im
          do j=1,jm
            fld3d(i,j,id)=wk(i,j)
          enddo
          enddo
 666      continue
      enddo
        read(iu,rec=ntgt) obs
        do i=1,im
        do j=1,jm
          prd(i,j)=0.0 
        enddo
        enddo
      do nt=1,nhs
        do i=1,im
        do j=1,jm
          prd(i,j)=prd(i,j)+fld3d(i,j,nt)*alpha(nt)
        enddo
        enddo
      enddo
      return
      end
c*
      function cov(ana,nisb,n,ib1,ib2,fak)
      dimension ana(nisb,n+1)
      z=0.
      do is=1,nisb
      ax=ana(is,ib1)/fak
      ay=ana(is,ib2)/fak
      z=z+(ay*ax)
      enddo
c     cov=z/float(nisb)
      cov=z
101   format(1h ,3f7.2,3i4)
      return
      end
c*
      subroutine corr_2d(im,jm,n,obs,prd,corr)
      dimension obs(im,jm,n),prd(im,jm,n)
      dimension corr(im,jm)
      do i=1,im
      do j=1,jm
      x=0.
      y=0.
      xy=0.
      do it=1,n
      x=x+obs(i,j,it)*obs(i,j,it)/float(n)
      y=y+prd(i,j,it)*prd(i,j,it)/float(n)
      xy=xy+obs(i,j,it)*prd(i,j,it)/float(n)
      enddo
      corr(i,j)=xy/(sqrt(x)*sqrt(y))
      enddo
      enddo
c     write(6,101) corr
101   format(1h ,10f7.2)
      return
      end
*
      subroutine inprod1(im,jm,modemax,e,cosl,m1,m2,anorm)
c* inner product in space among eofs of length n
      dimension e(modemax,im,jm)
      dimension cosl(jm)
      x=0.
      do i=1,im
      do j=1,jm
      x=x+e(m1,i,j)*e(m2,i,j)*cosl(j)
      enddo
      enddo
      anorm=x
      return
      end
c
      subroutine inprod4(e,academic,im,jm,cosl,m1,modemax,anorm)
c* inner product in space among one eof and an academic anomaly
      dimension e(modemax,im,jm),academic(im,jm)
      dimension cosl(jm)
      x=0.
      y=0.
      do i=1,im
      do j=1,jm
      cosw=cosl(j)
      x=x+e(m1,i,j)*academic(i,j)*cosw
      y=y+e(m1,i,j)*e(m1,i,j)*cosw
      enddo
      enddo
c     write(6,100)m1,x/y
      anorm=x/y
100   format(1h ,'ip4= ',i5,3f10.6)
      return
      end
c
      subroutine rmsd1(anom,anomp,im,jm,ims,ime,cosl)
      dimension anomp(im,jm),anom(im,jm)
      dimension cosl(jm)
      x=0.
      y=0.
      z=0.
      zc=0.
      w=0.
      do i=ims,ime
c     do i=1,im
      do j=1,jm
      cosw=cosl(j)
      w=w+cosw
      x=x+anom(i,j)*anom(i,j)*cosw
      y=y+anomp(i,j)*anomp(i,j)*cosw
      z=z+(anomp(i,j)-anom(i,j))*(anomp(i,j)-anom(i,j))*cosw
      zc=zc+anomp(i,j)*anom(i,j)*cosw
      enddo
      enddo
      x1=sqrt(x/w)
      y1=sqrt(y/w)
      z1=sqrt(z/w)
      zc=zc/w/(x1*y1)
c     write(6,100)x,y,z,w,ns
c* add average diffs
      x=0.
      y=0.
      z=0.
      w=0.
      do i=ims,ime
c     do i=1,im
      do j=1,jm
      cosw=cosl(j)
      w=w+cosw
      x=x+anom(i,j)*cosw
      y=y+anomp(i,j)*cosw
      z=z+(anom(i,j)-anomp(i,j))*cosw
      enddo
      enddo
      x=x/w
      y=y/w
      z=z/w
      write(6,100)x1,y1,z1,zc,x,y,z,w
100   format('stats grid rms/ave:',8f7.2,i5)
200   format(1h ,'stats grid ave:',4f7.2,i5)
      return
      end
c
      subroutine getalpha(ana,alpha,modemax,n,fak,ridge)
      dimension ana(modemax,n+1),alpha(n)
      real*8 a(n,n),b(n),aiv(n,n)
      do i=1,n
      do j=1,n
       a(i,j)=0.
       b(j)=0.
      enddo
      enddo
      ax=0.
      do ib1=1,n
      b(ib1)=cov(ana,modemax,n,ib1,n+1,fak)
      do ib2=ib1,n
      a(ib1,ib2)=cov(ana,modemax,n,ib1,ib2,fak)
      a(ib2,ib1)=a(ib1,ib2)
      enddo
      enddo
      d=0.
      do ib1=1,n
      d=d+a(ib1,ib1)/float(n)
      enddo
      do ib1=1,n
       a(ib1,ib1)=a(ib1,ib1)+d*ridge
      enddo
       call mtrx_inv(a,aiv,n)
       call solutn(aiv,b,alpha,n)
      return
      end
c
      SUBROUTINE solutn(ff,vf,beta,m)
      real*8 ff(m,m),vf(m)
      real beta(m)

      do i=1,m
         beta(i)=0.
      do j=1,m
         beta(i)=beta(i)+ff(i,j)*vf(j)
      end do
      end do

      return
      end
c*
c*
      subroutine weinalys(alpha,nt,sa,sasq,sabs,qeven,qodd,decadal)
      dimension alpha(nt),decadal(10)
c* analysis of nt (66) weights;
C* sa=sum of weights, sasq=sum of squares of weights, sabs=sum of abs values of weights.
C* qeven is sum of weights for even years (32,34 etc)
C* qodd is sum of weights for odd years (33,35 etc)
c* decadal(1) contains sums over 1st 10 years (32-41)
c* decadal(2) contains sums over 2nd 10 years (42-51), etc
      x=0.
      u=0.
      y=0.
      z=0.
C* sum of weights, forward and backwards
      do ntime=1,nt
      ntimer=nt-ntime+1
      x=x+alpha(ntime)
      u=u+alpha(ntimer)
      y=y+alpha(ntime)*alpha(ntime)
      z=z+abs(alpha(ntime))
c     write(6,100)ntime+1931,x,ntimer+1931,u
      enddo
c     write(6,111)x,y,z
      sa=x
      sasq=y
      sabs=z
      x=0.
      u=0.
      y=0.
      z=0.
C* sum of weights, forward and backwards, for odd/even years
      do ntime=1,nt,2
      ntimer=nt-ntime+1
      x=x+alpha(ntime)
      u=u+alpha(ntimer)
      y=y+alpha(ntime)*alpha(ntime)
      z=z+abs(alpha(ntime))
c     write(6,100)ntime+1931,x,ntimer+1931,u
      enddo
      qodd=u
      qeven=sa-u
c     write(6,111)x,y,z
      x=0.
      u=0.
      y=0.
      z=0.
C* sum of weights, forward and backwards, for odd/even years
      do ntime=2,nt,2
      ntimer=nt-ntime+1
      x=x+alpha(ntime)
      u=u+alpha(ntimer)
      y=y+alpha(ntime)*alpha(ntime)
      z=z+abs(alpha(ntime))
c     write(6,100)ntime+1931,x,ntimer+1931,u
      enddo
c     write(6,111)x,y,z
      do j=1,9
      ntime=(j-1)*10+1
      x=0.
      do i=0,9
      nti=ntime+i
      if (nti.le.nt) x=x+alpha(nti)
      enddo
c     write(6,101)ntime+1931,ntime+1940,x
      decadal(j)=x
      enddo
111   format(1h ,' sum, sumsqr sumabs: ',14f7.2)
100   format(1h ,'qb',i5,f7.2,i5,f7.2)
101   format(1h ,'decadal',2i5,f7.2)
      return
      end
c
      subroutine prout(alpha,jeartarget,m,mf,ntt,iout)
      dimension alpha(ntt),decadal(10),hulp(10)
      dimension alphaprint(100)
      do i=1,100
      alphaprint(i)=-999999999999.
      enddo
      do i=1,ntt
      alphaprint(i)=alpha(i)
      enddo
      call weinalys(alpha,ntt,x,y,z,qeven,qodd,decadal)
      do i=1,10
      hulp(i)=-999999999999.
      enddo
      hulp(1)=x
      hulp(2)=y
      hulp(3)=z
      hulp(4)=qeven
      hulp(5)=qodd
      hulp(6)=qodd-qeven
       write(iout,102)m,mf,jeartarget+1930,ntt
       do ntime=1,10
       if (ntt.eq.90) then
       write(iout,112)ntime+1960, alphaprint(ntime)
     *           ,ntime+1970, alphaprint(ntime+10)
     *           ,ntime+1980, alphaprint(ntime+20)
     *           ,ntime+1960, alphaprint(ntime+30)
     *           ,ntime+1970, alphaprint(ntime+40)
     *           ,ntime+1980, alphaprint(ntime+50)
     *           ,ntime+1960, alphaprint(ntime+60)
     *           ,ntime+1970, alphaprint(ntime+70)
     *           ,ntime+1980, alphaprint(ntime+80),hulp(ntime)
       endif
c      write(iout,212)ntime+1979, alphaprint(ntime)
c    *           ,ntime+1989, alphaprint(ntime+10)
c    *           ,ntime+1979, alphaprint(ntime+20)!1980-99 choice
c    *           ,ntime+1989, alphaprint(ntime+30)
c    *           ,ntime+1979, alphaprint(ntime+40)
c    *           ,ntime+1989, alphaprint(ntime+50),hulp(ntime)
c      write(iout,212)ntime+1970, alphaprint(ntime)
c    *           ,ntime+1980, alphaprint(ntime+10)
c    *           ,ntime+1970, alphaprint(ntime+20)!1971-90 choice
c    *           ,ntime+1980, alphaprint(ntime+30)
c    *           ,ntime+1970, alphaprint(ntime+40)
c    *           ,ntime+1980, alphaprint(ntime+50),hulp(ntime)
c      write(iout,212)ntime+1950, alphaprint(ntime)
c    *           ,ntime+1960, alphaprint(ntime+10)
c    *           ,ntime+1950, alphaprint(ntime+20)!1951-70 choice
c    *           ,ntime+1960, alphaprint(ntime+30)
c    *           ,ntime+1950, alphaprint(ntime+40)
c    *           ,ntime+1960, alphaprint(ntime+50),hulp(ntime)
       enddo
c      write(iout,103)
       write(iout,113)(decadal(j),j=1,9)!choice 61-90
c      write(iout,113)(decadal(j),j=1,6)!choice
c      write(iout,103)
c      write(iout,103)
c      write(iout,103)
102   format(4i6)
103   format()
112   format(9(i6,f7.2),1x,f8.2)
212   format(6(i6,f7.2),1x,f8.2)
113   format(9(6x,f7.2))
      return
      end
c*
