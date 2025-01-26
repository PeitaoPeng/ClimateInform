CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      program caprd
#include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C CA prediction for tropical heating
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      parameter(natura=0)! natura=1 means natural analogue
      parameter(nruneof=1)! 0: read in eof; 1: run eof
      parameter(nrunalpha=1)! 0: read in ; 1: run alpha
      parameter(imin=72,jmin=72) ! grid size of Z500
c     parameter(imp=72,jmp=24)   ! grid size of prcp
      parameter(imp=72,jmp=32)   ! grid size of prcp
      parameter(ngrd=imp*jmp)
      parameter(nws=23,nps=4)   ! 23 winters, each winter 24 pentads
c     parameter(ims=9,ime=60)   ! grid to have 1d skill
      parameter(ims=1,ime=imp)   ! grid to have skill
      parameter(npp=nps-2)       ! max 6 pentads to be predicted
      parameter(ntt=nws*npp,nhs=(nws-1)*(npp))
      dimension ts1(npp*nws),ts2(npp*nws),ts3(npp*nws)
      dimension ac1d(npp),ac1d2(npp)
      dimension fldin(imin,jmin)
      dimension xlat(jmp),fldp(imp,jmp)
      dimension alpha(nhs),corr(imp,jmp)
      dimension alpha3d(nhs,npp,nws)
      dimension obs(imp,jmp),obs2(imp,jmp),prd(imp,jmp)
      dimension fld2d(imp,jmp),fld4d(imp,jmp,nps,nws)
      dimension fld4d2(imp,jmp,nps,nws)
      dimension fld3d(imp,jmp,nhs)
      dimension tgt4d(imp,jmp,npp,nws)
      dimension clim(imp,jmp),aaa(ngrd,ntt)
      dimension aaa2(ngrd,nhs)
      dimension efld3d(modemax,nps,nws)
      dimension etgt3d(modemax,npp,nws)
      dimension    WK(ntt,ngrd),WK2(nhs,ngrd)
      dimension    ana(modemax,nhs+1),anac(modemax)
      dimension    EVAL(ntt),EVEC(ngrd,ntt),PC(ntt,ntt)
      dimension    EVAL2(nhs),EVEC2(ngrd,nhs),PC2(nhs,nhs)
      dimension    e(modemax,imp,jmp),cosl(jmp)
C
      open(unit=10,form='unformatted',access='direct',recl=72*72) !pent data
      open(unit=20,form='unformatted',access='direct',recl=72*jmp) !pent data
      open(unit=21,form='unformatted',access='direct',recl=72*jmp) !pent data
      open(unit=22,form='unformatted',access='direct',recl=72*jmp) !pent data
      open(unit=23,form='unformatted',access='direct',recl=72*jmp) !pent data
      open(unit=24,form='unformatted',access='direct',recl=72*jmp) !pent data
      open(unit=25,form='unformatted',access='direct',recl=72*jmp) !filteed dat
      open(unit=30,form='unformatted',access='direct',recl=imp*jmp) !prcp_eof
      open(unit=35,form='unformatted',access='direct',recl=nhs)    !alpha
      open(unit=40,form='unformatted',access='direct',recl=npp)     !corr skill
c     open(unit=40,form='formatted')     !corr skill
      open(unit=50,form='unformatted',access='direct',recl=imp*jmp) !corr skill
c*************************************************
      if (natura.eq.1)write(6,307)
      if (natura.eq.0)write(6,308)
c*************************************************
c*
      do j=1,jmp
      xlat(j)=-28.75+(j-1)*2.5
      enddo
c
      PI=4.*atan(1.)
      CONV=PI/180.
      DO j=1,jmp
        COSL(j)=COS(xlat(j)*CONV)
      END DO
      fak=1.
      ridge=0.01
c 
C*********************************************
c* read in data and save the tropics
      DO iw=1,nws              !ws -> # of xxx seasons

c* keep the data for prd test

        nkeeps=(iw-1)*12+12    !mon of current year
        nkeepe=iw*12+3         !mon of next year
c       nkeeps=(iw-1)*12+9         !starting mon of the year
c       nkeepe=(iw-1)*12+12        !ending mon of the year
        np=1
        do it=nkeeps,nkeepe    !read data
          read(10,rec=it) fldin
            do i=1,imp
            do j=1,jmp
            fld4d(i,j,np,iw)=fldin(i,j+24)
            fld2d(i,j)=fldin(i,j+24)
            enddo
            enddo
          write(20) fld2d
        np=np+1
        enddo

      ENDDO

      IF (nruneof.eq.1) THEN
c* input data for EOF analysis
      it=1
      do iw=1,nws
      do ip=1,npp
        id=1
        do j=1,jmp
        do i=1,imp
          aaa(id,it)=fld4d(i,j,ip,iw)*sqrt(COSL(j))
          id=id+1
        end do
        end do
      it=it+1
      enddo
      enddo
c       
      call eofs_4_ca(aaa,ngrd,ntt,ntt,eval,evec,pc,wk,0)
      write(6,*) 'eval=',eval
c* have 2D EOF 

        do nm=1,modemax
        ng=0
        do j=1,jmp
        do i=1,imp
          ng=ng+1
          e(nm,i,j)=evec(ng,nm)
        end do
        end do
        end do

c* standardize spatial patterns to unity****

        do m1=1,modemax

        call inprod1(imp,jmp,modemax,e,cosl,m1,m1,anorm)
c       write(6,*)m1,anorm
        do i=1,imp
        do j=1,jmp
          e(m1,i,j)=e(m1,i,j)/sqrt(anorm)
        end do
        end do

        do i=1,imp
        do j=1,jmp
          fld2d(i,j)=e(m1,i,j)
        end do
        end do
        write(30) fld2d ! write out eof
        enddo  !loop for m1

      ELSE

        do m1=1,modemax
        read(30) fld2d
          do i=1,imp
          do j=1,jmp
            e(m1,i,j)=fld2d(i,j)
          end do
          end do
        enddo

      ENDIF
c
C* project grid data onto eof's*******
c
        do iw=1,nws
        do ip=1,nps
        call f4d_2_f2d(imp,jmp,nps,nws,ip,iw,fld2d,fld4d)
        do nmode=1,modemax
          call inprod4(e,fld2d,imp,jmp,cosl,nmode,modemax,anorm)
          efld3d(nmode,ip,iw)=anorm
        enddo
        enddo
        enddo 

c
c* cross validated CA prd begins
c
      DO ldpen=1,3  !1:IC; 2:0 pent lead; 3: 1pent lead; ...

      DO ntgtw=1,nws      !loop over target winters
      DO ntgtp=1,npp      !loop over target month
        it=1
        do iw=1,nws       !loop for the non-target winter
        if(iw.eq.ntgtw) go to 555
          do ip=1,npp
            do nmode=1,modemax
              ana(nmode,it)=efld3d(nmode,ip+ldpen-1,iw)
            enddo
c 
            do i=1,imp
            do j=1,jmp
              fld3d(i,j,it)=fld4d(i,j,ip+ldpen-1,iw)
            enddo
            enddo
c
          it=it+1
          enddo
 555    continue
        enddo             !loop for the non-target winter

        IF(ldpen.gt.1) go to 222

        do nmode=1,modemax
        ana(nmode,nhs+1)=efld3d(nmode,ntgtp,ntgtw)
        enddo

        IF(nrunalpha.eq.1) then
        
        call getalpha(ana,alpha,modemax,nhs,fak,ridge)

        do k=1,nhs
        alpha3d(k,ntgtp,ntgtw)=alpha(k)
        enddo
        write(35) alpha

        ELSE

        read(35) alpha
        do k=1,nhs
        alpha3d(k,ntgtp,ntgtw)=alpha(k)
        enddo
 
        ENDIF

        alpha2=0
        do k=1,nhs
        alpha2=alpha2+alpha(k)*alpha(k)
        enddo
        write(6,*) 'alpha2=',alpha2

 222    continue

        do nmode=1,modemax
          etgt3d(nmode,ntgtp,ntgtw)=0.
        enddo

        do nmode=1,modemax
        do ntime=1,nhs
        etgt3d(nmode,ntgtp,ntgtw)=etgt3d(nmode,ntgtp,ntgtw)+
     &           ana(nmode,ntime)*alpha3d(ntime,ntgtp,ntgtw)
        enddo
        enddo

c* EOF filtering for data used to construct prd 
      do it=1,nhs
        id=1
        do j=1,jmp
        do i=1,imp
          aaa2(id,it)=fld3d(i,j,it)*sqrt(COSL(j))
          id=id+1
        end do
        end do
      enddo
c
c     call eofs_4_ca(aaa2,ngrd,nhs,nhs,eval2,evec2,pc2,wk2,0)
c       
      do it=1,nhs

        do i=1,imp
        do j=1,jmp
c         fld3d(i,j,it)=0.
          fld2d(i,j)=0.
        enddo
        enddo

        id=1
        do j=1,jmp
        do i=1,imp
          do n=1,modemax
c         fld3d(i,j,it)=fld3d(i,j,it)+evec2(id,n)*pc2(n,it)
c         fld2d(i,j)=fld2d(i,j)+evec2(id,n)*pc2(n,it)
c    &/sqrt(COSL(j))
          end do
        id=id+1
        end do
        end do
      write(25) fld2d
      end do

        do i=1,imp
        do j=1,jmp
          fld4d2(i,j,ntgtp,ntgtw)=0.
        enddo
        enddo
        do i=1,imp
        do j=1,jmp
        do ntime=1,nhs
        fld4d2(i,j,ntgtp,ntgtw)=fld4d2(i,j,ntgtp,ntgtw)+
     &           fld3d(i,j,ntime)*alpha3d(ntime,ntgtp,ntgtw)
        enddo
        enddo
        enddo

      ENDDO            
      ENDDO

c
c* PC to grid for constructed data
c
      DO iw=1,nws      
      DO ip=1,npp  

        do i=1,imp
        do j=1,jmp
          tgt4d(i,j,ip,iw)=0.
        enddo
        enddo

        do i=1,imp
        do j=1,jmp
c       do nmode=1,modemax
c         tgt4d(i,j,ip,iw)=tgt4d(i,j,ip,iw)+
c    &          etgt3d(nmode,ip,iw)*e(nmode,i,j)
c       enddo
          tgt4d(i,j,ip,iw)=fld4d2(i,j,ip,iw)

        enddo
        enddo

       ENDDO
       ENDDO

c* pattern ac
       DO iw=1,nws
       DO ip=1,npp
         do i=1,imp
         do j=1,jmp
           obs(i,j)=fld4d(i,j,ip+ldpen-1,iw)
           obs2(i,j)=fld4d(i,j,ip,iw) !as persistency prd
           prd(i,j)=tgt4d(i,j,ip,iw)
         enddo
         enddo
c* write out tropical obs
         if(ldpen.eq.1) then
c        write(20) obs
         endif
c* write out prd
         write(20+ldpen) prd
c
         call rmsd1(obs,prd,imp,jmp,ims,ime,cosl,ac1d(ip))
         call rmsd1(obs,obs2,imp,jmp,ims,ime,cosl,ac1d2(ip))
       ENDDO
c        write(40,*) 'ldpen=',ldpen,' winter #=',iw
c        write(40,100) ac1d
c        write(40,*) 'persistency'
c        write(40,100) ac1d2
         write(40) ac1d
c        write(40) ac1d2
       ENDDO
c* temporal ac
      do i=1,imp
      do j=1,jmp
        it=1
        do iw=1,nws
        do ip=1,npp
          ts1(it)=fld4d(i,j,ip+ldpen-1,iw)
          ts2(it)=tgt4d(i,j,ip,iw)
          ts3(it)=fld4d(i,j,ip,iw)
        it=it+1
        enddo
        enddo
        call corr_1d(nws*npp,ts1,ts2,fld2d(i,j))
        call corr_1d(nws*npp,ts1,ts3,obs2(i,j))
      enddo
      enddo
      write(50) fld2d
      write(50) obs2

      ENDDO  !loop for ldpen
c
C*********************************************
100    format(9f7.2/9f7.2)
307    format(1h ,'natural analogues')
308    format(1h ,'constructed analogue')

 200  continue
      STOP
      END
c*
      subroutine ca_prd_grd(iu,ntt,ntgt,nhs,im,jm,alpha,obs,prd)
      dimension wk(im,jm),fld3d(im,jm,nhs)
      dimension obs(im,jm),prd(im,jm),alpha(nhs)
      id=0
      do nt=1,ntt !have historical given month data for constructing prd
          read(iu,rec=nt) wk
          if(nt.eq.ntgt) go to 666
          if(nt.eq.ntgt-1) go to 666
          if(nt.eq.ntgt+1) go to 666
          id=id+1
          do i=1,im
          do j=1,jm
            fld3d(i,j,id)=wk(i,j)
          enddo
          enddo
 666      continue
      enddo
        call anom_clim(im,jm,nhs,nhs,fld3d,wk)
        read(iu,rec=ntgt) obs
        do i=1,im
        do j=1,jm
          obs(i,j)=obs(i,j)-wk(i,j)
        enddo
        enddo
c
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
c
      subroutine f3d_2_f2d(im,jm,ntt,ntgt,fld2d,fld3d)
      dimension fld3d(im,jm,ntt),fld2d(im,jm)
        do i=1,im
        do j=1,jm
          fld2d(i,j)=fld3d(i,j,ntgt)
        enddo
        enddo
      return
      end
c*
      subroutine f4d_2_f2d(im,jm,nps,nws,ip,iw,fld2d,fld4d)
      dimension fld4d(im,jm,nps,nws),fld2d(im,jm)
        do i=1,im
        do j=1,jm
          fld2d(i,j)=fld4d(i,j,ip,iw)
        enddo
        enddo
      return
      end
c*
      subroutine f2d_2_f3d(im,jm,ntt,ntgt,fld2d,fld3d)
      dimension fld3d(im,jm,ntt),fld2d(im,jm)
        do i=1,im
        do j=1,jm
          fld3d(i,j,ntgt)=fld2d(i,j)
        enddo
        enddo
      return
      end
c*
      subroutine anom_clim(im,jm,ntt,nys,fld3d,fld2d)
      dimension fld3d(im,jm,ntt),fld2d(im,jm)
        do i=1,im
        do j=1,jm
          fld2d(i,j)=0.
        enddo
        enddo
        do it=1,nys
        do i=1,im
        do j=1,jm
        fld2d(i,j)=fld2d(i,j)+fld3d(i,j,it)/float(nys)
        enddo
        enddo
        enddo
        do it=1,nys
        do i=1,im
        do j=1,jm
        fld3d(i,j,it)=fld3d(i,j,it)-fld2d(i,j)
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
      subroutine corr_1d(n,ts1,ts2,corr)
      dimension ts1(n),ts2(n)
      x=0.
      y=0.
      xy=0.
      do it=1,n
      x=x+ts1(it)*ts1(it)/float(n)
      y=y+ts2(it)*ts2(it)/float(n)
      xy=xy+ts1(it)*ts2(it)/float(n)
      enddo
      corr=xy/(sqrt(x)*sqrt(y))
      return
      end
c
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
      subroutine rmsd1(anom,anomp,im,jm,ims,ime,cosl,zc)
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
       call mtrx_inv(a,aiv,n,n)
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

C       ================================================================
        subroutine  mtrx_inv( x, xinv, n,max_npc)
C       ================================================================

        implicit none

C-----------------------------------------------------------------------
C                             INCLUDE FILES
C-----------------------------------------------------------------------
c
c #include  "reg_parm"
        integer max_nchan
        parameter(max_nchan = 2378) !MAXIMUM # OF ALLOWED REGRESSION CHANNELS

        integer max_nsamp
        parameter(max_nsamp = 600) ! MAXIMUM TRAINING SAMPLE SIZE OR THE MAXIMUM #
                                    ! OF OBSERVATIONS TO WHICH COEFFICENTS ARE APPLIED

        integer max_npc
c       parameter(max_npc =21) ! maximum # of principal components
c       parameter(max_npc =46) ! maximum # of principal components
c
C-----------------------------------------------------------------------
C                              ARGUMENTS
C-----------------------------------------------------------------------

        real*8    x ( max_npc, max_npc )
        real*8    xinv ( max_npc, max_npc )
        integer   n

C-----------------------------------------------------------------------
C                            LOCAL VARIABLES
C-----------------------------------------------------------------------

        integer   i
        integer   ii
        integer   im
        integer   ip
        integer   j
        integer   jm
        integer   jp
        integer   k
        integer   l
        integer   nm
        real*8    s ( max_npc, max_npc )
        real*8    a ( max_npc, max_npc )
        real*8    sum

C***********************************************************************
C***********************************************************************
C                            EXECUTABLE CODE
C***********************************************************************
C***********************************************************************

C-----------------------------------------------------------------------
C     [ Major comment blocks set off by rows of dashes. ]
C-----------------------------------------------------------------------

C
C    CONVERT 'X' TO A DOUBLE PRECISION WORK ARRAY.
      do 10 i=1,n
      do 10 j=1,n
c      a(i,j)=dble(x(i,j))
      a(i,j)=x(i,j)
   10 continue
      s(1,1)=1.0/a(1,1)
c    just inverting a scalar if n=1.
      if(n-1)20,180,30
   20 return
   30 do 40 j=2,n
      s(1,j)=a(1,j)
   40 continue
      do 70 i=2,n
      im=i-1
      do 60 j=i,n
      sum=0.0
      do 50 l=1,im
      sum=sum+s(l,i)*s(l,j)*s(l,l)
   50 continue
      s(i,j)=a(i,j)-sum
   60 continue
      s(i,i)=1.0/s(i,i)
   70 continue
      do 80 i=2,n
      im=i-1
      do 80 j=1,im
   80 s(i,j)=0.0
      nm=n-1
      do 90 ii=1,nm
      im=n-ii
      i=im+1
      do 90 j=1,im
      sum=s(j,i)*s(j,j)
      do 90 k=i,n
      s(k,j)=s(k,j)-s(k,i)*sum
   90 continue
      do 120 j=2,n
      jm=j-1
      jp=j+1
      do 120 i=1,jm
      s(i,j)=s(j,i)
      if(jp-n)100,100,120
  100 do 110 k=jp,n
      s(i,j)=s(i,j)+s(k,i)*s(k,j)/s(k,k)
  110 continue
  120 continue
      do 160 i=1,n
      ip=i+1
      sum=s(i,i)
      if(ip-n)130,130,150
  130 do 140 k=ip,n
      sum=sum+s(k,i)*s(k,i)/s(k,k)
  140 continue
  150 s(i,i)=sum
  160 continue
      do 170 i=1,n
      do 170 j=i,n
      s(j,i)=s(i,j)
  170 continue
c    retrieve output array 'xinv' from the double precession work array.
  180 do 190 i=1,n
      do 190 j=1,n
c      xinv(i,j)=sngl(s(i,j))
      xinv(i,j)=s(i,j)
  190 continue
      return
      end
