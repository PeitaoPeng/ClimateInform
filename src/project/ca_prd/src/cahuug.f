      parameter(natura=0)! natura=1 means natural analogue
      parameter(nss=540,ntt=90,n=ntt,modemax=50)!choice #of modes and ntt
      dimension anom(im,jm),cosl(jm),ana(modemax,n+1),anac(modemax)
      dimension climtor(im,jm),climtand(im,jm)
      dimension t3(nss),t3eof(nss),t3c(nss),e(modemax,nss),t2(nss)
      dimension alpha(n),ax(n*n),ipvt(n)
      dimension isi(nss),isj(nss)
      dimension isir(nss),isjr(nss)! reduced grid indexing
      dimension helpr(36,15)
C
      open(82,file='/nfsuser/g01/wx23ss/gale/z500',form='unformatted')
      open(84,file='/nfsuser/g01/wx23ss/gale/prmsl',form='unformatted')!choice
      open(81,file='/ptmp/wx51hd/test/psijfm.6190',
     *form='unformatted')!choice history for predictor
      open(83,file='/ptmp/wx51hd/test/chijfm.6190',
     *form='unformatted')!choice history for predictand
      open(44,file='/ptmp/wx51hd/test/psijfm.eof.6190',
     *form='unformatted')!choi
      open(35,file='/ptmp/wx51hd/test/psiclim',form='unformatted')!tor climo
      open(36,file='/ptmp/wx51hd/test/chiclim',form='unformatted')! tand climo
      open(45,file='pra24.out',form='unformatted')
      open(46,file='chi.out',form='unformatted')
c*************************************************
      read(35)climtor
      read(36)climtand
c*************************************************
      if (natura.eq.1)write(6,307)
      if (natura.eq.0)write(6,308)
c*************************************************
      jb=31! 61-90 climo
      je=jb+29
c*************************************************
c set up a NH grid >= 20 N, every 5/10 degrees lat/lon
      is=0
      do i=1,im,4
      do j=29,1,-2
      is=is+1
      isi(is)=i
      isj(is)=j
      isir(is)=1+(i-1)/4
      isjr(is)=1+(j-1)/2
      enddo
      enddo
      write(6,207)is,isi(is),isj(is),isir(is),isjr(is)
      is=1
      write(6,207)is,isi(is),isj(is),isir(is),isjr(is)
207   format(1h ,'set-up (reduced) grids',5i6)
c*
      pi=4.*atan(1.)
      CONV=PI/180.
      DO j=1,jm
         ALAT=90.-FLOAT(j-1)*2.5
         COSL(j)=COS(ALAT*CONV)
      END DO
      fak=1.
      ridge=0.10
c* read in the alphas (from reverse t-s) and store as othogonal e's
      do nmode=1,modemax
      read(44)t3
      do is=1,nss
      e(nmode,is)=t3(is)
      enddo
      enddo
C****standardize spatial patterns to unity****
      do m1=1,modemax
      call inprod1(e,nss,cosl,isj,jm,nss,modemax,m1,m1,anorm)
c     write(6,100)m1,anorm
      e(m1,:)=e(m1,:)/sqrt(anorm)
      call inprod1(e,nss,cosl,isj,jm,nss,modemax,m1,m1,anorm)
c     write(6,100)m1,anorm
      enddo
C*********************************************
C*****project jan fields onto Jan eof's*******
      do nj=1,ntt
       read(81) anom
       is=0
        do i=1,im,4
        do j=29,1,-2
        is=is+1
        t3(is)=anom(i,j)/10.
        enddo
        enddo
       do nmode=1,modemax
       call inprod4(e,t3,nss,cosl,isj,jm,nmode,modemax,anorm)
       ana(nmode,nj)=anorm
       enddo
c      write(6,100)nj,(ana(nmode,nj),nmode=1,10)
      enddo
      call vardetail(ana,modemax,ntt)
C*********************************************
       do njbase=25,34! Jan25-Feb3 1953
       do ihr=0,21,3! every 3 hours
       read(82) anom! the 'base'
       is=0
        do i=1,im,4
        do j=29,1,-2
        is=is+1
        t3(is)=anom(i,j)/10.-climtor(i,j)/10.
        enddo
        enddo
                 do is=1,nss
                 helpr(isir(is),isjr(is))=t3(is)
                 enddo
                 write(45)helpr! write IC for grads1
       do nmode=1,modemax
       call inprod4(e,t3,nss,cosl,isj,jm,nmode,modemax,anorm)
       ana(nmode,n+1)=anorm
       enddo
c      write(6,100)nj,(ana(nmode,n+1),nmode=1,10)
                 t3eof=0.
                 do nmode=1,modemax
                 t3eof(:)=t3eof(:)+ana(nmode,n+1)*e(nmode,:)
                 enddo
                 do is=1,nss
                 helpr(isir(is),isjr(is))=t3eof(is)
                 enddo
                 write(45)helpr! write IC-30EOF for grads1
C*********************************************
      mm=moper-1
      if (natura.eq.1)call getalphana(ana,alpha,modemax,n,fak)
      if (natura.eq.0)
     *call getalpha(ana,alpha,ax,modemax,n,fak,ridge)
      call prout(alpha,njbase,mm,mm,ntt,6)
                 anac=0.
                 do nmode=1,modemax
                 do ntime=1,ntt
                 anac(nmode)=anac(nmode)+ana(nmode,ntime)*alpha(ntime)
                 enddo
                 enddo
                 t3c=0.
                 do nmode=1,modemax
                 t3c(:)=t3c(:)+anac(nmode)*e(nmode,:)
                 enddo
                 do is=1,nss
                 helpr(isir(is),isjr(is))=t3c(is)
                 enddo
                 write(45)helpr! write CA for grads1
      call rmsd1(t3*10.,t3c*10.,nss,cosl,isj,jm)
c     call rmsd1(t3eof*100.,t3c*100.,nss,cosl,isj,jm)
c     call rmsd1(t3*100.,t3eof*100.,nss,cosl,isj,jm)
                 t3c=t3c-t3
                 t3c=-t3c!observed-ca
                 do is=1,nss
                 helpr(isir(is),isjr(is))=t3c(is)
                 enddo
                 write(45)helpr! write IC-error for grads1
C**************** partially redo for chi *****************************
       read(84) anom! inital chi state or gridded predictand
       is=0
        do i=1,im,4
        do j=29,1,-2
        is=is+1
        t3(is)=anom(i,j)/100.-1000.-climtand(i,j)
        enddo
        enddo
                 do is=1,nss
                 helpr(isir(is),isjr(is))=t3(is)
                 enddo
                 write(46)helpr! write IC for grads1
                 helpr=0.
                 write(46)helpr! write panel 2 with zeros
c*
      t3c=0.
      rewind 83
      do nj=1,ntt
       read(83) anom
       is=0
        do i=1,im,4
        do j=29,1,-2
        is=is+1
        t2(is)=anom(i,j)-climtand(i,j)
        enddo
        enddo
       t3c=t3c+t2*alpha(nj)
      enddo
                 do is=1,nss
                 helpr(isir(is),isjr(is))=t3c(is)
                 enddo
                 write(46)helpr! write CA for grads1
      call rmsd1(t3,t3c,nss,cosl,isj,jm)
                 t3c=t3c-t3
                 t3c=-t3c
                 do is=1,nss
                 helpr(isir(is),isjr(is))=t3c(is)
                 enddo
                 write(46)helpr! write IC-error for grads1
      enddo
      enddo
C*********************************************
100   format(1h ,i6,10f6.2)
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
      subroutine inprod1(e,n,cosl,isj,jm,nss,modemax,m1,m2,anorm)
c* inner product in space among eofs of length n
      dimension e(modemax,n)
      dimension cosl(jm),isj(nss)
      x=0.
      do is=1,n
      cosw=cosl(isj(is))
      x=x+e(m1,is)*e(m2,is)*cosw
      enddo
c     write(6,100)x
      anorm=x
100   format(1h ,'ip1= ',f10.6)
      return
      end
c
      subroutine inprod4(e,academic,n,cosl,isj,jm,m1,modemax,anorm)
c* inner product in space among one eof and an academic anomaly both of length n
      dimension e(modemax,n),academic(n)
      dimension cosl(jm),isj(n)
      x=0.
      y=0.
      do is=1,n
      cosw=cosl(isj(is))
      x=x+e(m1,is)*academic(is)*cosw
      y=y+e(m1,is)*e(m1,is)*cosw
      enddo
c     write(6,100)m1,x/y
      anorm=x/y
100   format(1h ,'ip4= ',i5,3f10.6)
      return
      end
c
      subroutine rmsd1(anom,anomp,ns,cosl,isj,jm)
      dimension anomp(ns),anom(ns)
      dimension cosl(jm),isj(ns)
      x=0.
      y=0.
      z=0.
      zc=0.
      w=0.
      do is=1,ns
      cosw=cosl(isj(is))
      w=w+cosw
      x=x+anom(is)*anom(is)*cosw
      y=y+anomp(is)*anomp(is)*cosw
      z=z+(anomp(is)-anom(is))*(anomp(is)-anom(is))*cosw
      zc=zc+anomp(is)*anom(is)*cosw
      enddo
      x1=sqrt(x/w)
      y1=sqrt(y/w)
      z1=sqrt(z/w)
      zc=zc/w/(x1*y1)*100.
c     write(6,100)x,y,z,w,ns
c* add average diffs
      x=0.
      y=0.
      z=0.
      w=0.
      do is=1,ns
      cosw=cosl(isj(is))
      w=w+cosw
      x=x+anom(is)*cosw
      y=y+anomp(is)*cosw
      z=z+(anom(is)-anomp(is))*cosw
      enddo
      x=x/w
      y=y/w
      z=z/w
      write(6,100)x1,y1,z1,zc,x,y,z,w,ns
100   format('stats grid rms/ave:',8f7.2,i5)
200   format(1h ,'stats grid ave:',4f7.2,i5)
      return
      end
c
      subroutine getalpha(ana,alpha,ax,modemax,n,fak,ridge)
      dimension ana(modemax,n+1),alpha(n)
      dimension a(n,n),b(n),ax(n*n),bvv(n),ipvt(n)
      a=0.
      b=0.
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
c     write(6,100)modemax,d,1.-d
C* ridge = 1. -d ??
      do ib1=1,n
      a(ib1,ib1)=a(ib1,ib1)+d*ridge
      enddo
       in=0
       do 772 j=1,n
       do 772 i=1,n
       in=in+1
       ax(in)=a(i,j)
772    continue
        bvv=b
        call sgef(ax,n,n,ipvt)
        call sges(ax,n,n,ipvt,bvv,0)
        alpha=bvv
c      call lsasf(n,ax,n,b,alpha)
c       call lfisf(n,ax,n,fac,n,ipvt,b,alpha,res)
c     write(6,103)
c     do i=1,n
c     write(6,110)i,b(i),a(i,i),alpha(i),b(i)/a(i,i)
c     enddo
c     write(6,103)
c     do ib1=1,10
c     write(6,101)ib1,(a(ib1,ib2),ib2=1,10),alpha(ib1),b(ib1)
c     enddo
c     write(6,103)
100   format(1h ,i6,2f6.3)
101   format(1h ,i6,12f6.2)
110   format(1h ,i6,4f6.2)
103   format(/)
      return
      end
c
      subroutine getalphana(ana,alpha,modemax,n,fak)
      dimension ana(modemax,n+1),alpha(n)
      dimension cor(n)
      cor=0.
      do ib1=1,n
      cor(ib1)=cov(ana,modemax,n,ib1,n+1,fak)
     *      /sqrt(cov(ana,modemax,n,ib1,ib1,fak))
     *      /sqrt(cov(ana,modemax,n,n+1,n+1,fak))
      enddo
      alpha=cor
      call natural(alpha,n)
100   format(f6.3)
103   format(/)
      return
      end
c*
c*
      subroutine getalphafast(ana,alpha,
     *ax,ipvt,iyesterday,modemax,n,fak,ridge)
      dimension ana(iyesterday*modemax,n+1),alpha(n)
      dimension b(n),ax(n*n)
      dimension ipvt(n),bvv(n)
      b=0.
      do ib1=1,n
      b(ib1)=cov(ana,iyesterday*modemax,n,ib1,n+1,fak)
      enddo
        bvv=b
c       call sgef(ax,n,n,ipvt)
        call sges(ax,n,n,ipvt,bvv,0)
        alpha=bvv
c      call lsasf(n,ax,n,b,alpha)
c       call lfisf(n,ax,n,fac,n,ipvt,b,alpha,res)
c       call lfssf(n,fac,n,ipvt,b,alpha)
      return
      end
c*
      subroutine fillax(ana,alpha,ax,iyesterday,modemax,n,fak,ridge)
      dimension ana(iyesterday*modemax,n+1),alpha(n)
      dimension a(n,n),b(n),ax(n*n)
      a=0.
      ax=0.
      do ib1=1,n
      do ib2=ib1,n
      a(ib1,ib2)=cov(ana,iyesterday*modemax,n,ib1,ib2,fak)
      a(ib2,ib1)=a(ib1,ib2)
      enddo
      enddo
      d=0.
      do ib1=1,n
      d=d+a(ib1,ib1)/float(n)
      enddo
      write(6,100)modemax,d,1.-d
C* ridge = 1. -d ??
      do ib1=1,n
      a(ib1,ib1)=a(ib1,ib1)+d*ridge
      enddo
       in=0
       do 772 j=1,n
       do 772 i=1,n
       in=in+1
       ax(in)=a(i,j)
772    continue
100   format(1h ,i6,2f6.3)
      return
      end
c*
      subroutine vardetail(ana,modemax,ntt)
      dimension ana(modemax,ntt+1),var(modemax)
c* first 20 years (previous month):
          totvar=0.
          do nmode=1,modemax
          x=0.
          do nj=1,ntt/3
          anorm=ana(nmode,nj)
          x=x+anorm*anorm
          enddo
          var(nmode)=x
          totvar=totvar+x
          enddo
          write(6,100)nj,(var(nmode),nmode=1,10)
          write(6,100)nj,(var(nmode)*100./totvar,nmode=1,10)
          do nmode=2,modemax
          var(nmode)=var(nmode)+var(nmode-1)
          enddo
          write(6,100)nj,(var(nmode)*100./totvar,nmode=1,10)
          write(6,100)nj,(var(nmode)*100./totvar,nmode=11,20)
          write(6,100)nj,(var(nmode)*100./totvar,nmode=21,30)
          write(6,103)
c* second 20 years (center month):
          totvar=0.
          do nmode=1,modemax
          x=0.
          do nj=ntt/3+1,2*ntt/3
          anorm=ana(nmode,nj)
          x=x+anorm*anorm
          enddo
          var(nmode)=x
          totvar=totvar+x
          enddo
          write(6,100)nj,(var(nmode),nmode=1,10)
          write(6,100)nj,(var(nmode)*100./totvar,nmode=1,10)
          do nmode=2,modemax
          var(nmode)=var(nmode)+var(nmode-1)
          enddo
          write(6,100)nj,(var(nmode)*100./totvar,nmode=1,10)
          write(6,100)nj,(var(nmode)*100./totvar,nmode=11,20)
          write(6,100)nj,(var(nmode)*100./totvar,nmode=21,30)
          write(6,103)
c* last 20 years (next month):
          totvar=0.
          do nmode=1,modemax
          x=0.
          do nj=2*ntt/3+1,ntt
          anorm=ana(nmode,nj)
          x=x+anorm*anorm
          enddo
          var(nmode)=x
          totvar=totvar+x
          enddo
          write(6,100)nj,(var(nmode),nmode=1,10)
          write(6,100)nj,(var(nmode)*100./totvar,nmode=1,10)
          do nmode=2,modemax
          var(nmode)=var(nmode)+var(nmode-1)
          enddo
          write(6,100)nj,(var(nmode)*100./totvar,nmode=1,10)
          write(6,100)nj,(var(nmode)*100./totvar,nmode=11,20)
          write(6,100)nj,(var(nmode)*100./totvar,nmode=21,30)
          write(6,103)
c* the whole thing
          totvar=0.
          do nmode=1,modemax
          x=0.
          do nj=1,ntt
          anorm=ana(nmode,nj)
          x=x+anorm*anorm
          enddo
          var(nmode)=x
          totvar=totvar+x
          enddo
          write(6,100)nj,(var(nmode),nmode=1,10)
          write(6,100)nj,(var(nmode)*100./totvar,nmode=1,10)
          do nmode=2,modemax
          var(nmode)=var(nmode)+var(nmode-1)
          enddo
          write(6,100)nj,(var(nmode)*100./totvar,nmode=1,10)
          write(6,100)nj,(var(nmode)*100./totvar,nmode=11,20)
          write(6,100)nj,(var(nmode)*100./totvar,nmode=21,30)
100   format(1h ,i6,10f6.1)
103   format()
      return
      end
C*
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
      alphaprint=-999999999999.
      do i=1,ntt
      alphaprint(i)=alpha(i)
      enddo
      call weinalys(alpha,ntt,x,y,z,qeven,qodd,decadal)
      hulp=-999999999999.
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
      subroutine natural(alpha,ntt)
      dimension alpha(ntt),help(ntt)
      help=alpha
      alpha=0.
        do idum=1,10
        amax=-1000.
          do j=1,ntt
          if (help(j).gt.amax)jmax=j
          if (help(j).gt.amax)amax=help(j)
          enddo 
        alpha(jmax)=help(jmax)
        help(jmax)=0.
        enddo 
      x=0.
      do i=1,ntt
      x=x+abs(alpha(i))
      enddo
      alpha=alpha/x
      return   
      end
