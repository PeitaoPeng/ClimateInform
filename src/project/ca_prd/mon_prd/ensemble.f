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
      parameter(nws=24,nps=6)   ! 23 winters
c     parameter(ims=9,ime=60)   ! grid to have 1d skill
      parameter(ims=1,ime=imp)   ! grid to have skill
      parameter(npp=nps-4)       ! max 6 pentads to be predicted
      parameter(ntt=nws*npp,nhs=(nws-1)*(npp))
      dimension ts1(npp*nws),ts2(npp*nws),ts3(npp*nws)
      dimension ac1d(npp),ac1d2(npp)
      dimension fldin(imin,jmin)
      dimension xlat(jmp),fldp(imp,jmp)
      dimension alpha(nhs),corr(imp,jmp)
      dimension alpha3d(nhs,npp,nws)
      dimension obs(imp,jmp),obs2(imp,jmp),prd(imp,jmp)
      dimension acca(imp,jmp),acpt(imp,jmp)
      dimension wca(imp,jmp),wpt(imp,jmp)
      dimension fld2d(imp,jmp),fld4d(imp,jmp,nps,nws)
      dimension fld4d2(imp,jmp,nps,nws)
      dimension fld3d(imp,jmp,nhs)
      dimension tgt4d(imp,jmp,npp,nws)
      dimension clim(imp,jmp),aaa(ngrd,ntt)
      dimension aaa2(ngrd,nhs)
C
      open(unit=20,form='unformatted',access='direct',recl=72*jmp) !pent data
      open(unit=35,form='unformatted',access='direct',recl=nhs)    !alpha
      open(unit=40,form='unformatted',access='direct',recl=npp)     !corr skill
c     open(unit=40,form='formatted')     !corr skill
      open(unit=45,form='unformatted',access='direct',recl=imp*jmp) !corr skill
      open(unit=50,form='unformatted',access='direct',recl=imp*jmp) !corr skill
      open(unit=55,form='unformatted',access='direct',recl=imp*jmp) !real prd
      open(unit=60,form='unformatted',access='direct',recl=imp*jmp) !ens prd
c 
C*********************************************
c* read in data and save the tropics
      ir=1
      DO iw=1,nws            !ws -> # of xxx seasons
        do ip=1,nps          !read data
          read(20,rec=ir) fld2d
            do i=1,imp
            do j=1,jmp
            fld4d(i,j,ip,iw)=fld2d(i,j)
            enddo
            enddo
        ir=ir+1
        enddo
      ENDDO
c
c* cross validated CA prd begins
c
      DO ldpen=1,4  !1:IC; 2:0 mon lead; 3: 1 mon lead; ...

      DO ntgtw=1,nws      !loop over target winters
      DO ntgtp=1,npp      !loop over target month
        it=1
        do iw=1,nws       !loop for the non-target winter
        if(iw.eq.ntgtw) go to 555
          do ip=1,npp
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

        read(35) alpha
        do k=1,nhs
        alpha3d(k,ntgtp,ntgtw)=alpha(k)
        enddo

 222    continue

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

c* read in 2d ac
      read(45) acca
      read(45) acpt
      do i=1,imp
      do j=1,jmp
        xca=acca(i,j)
        xpt=acpt(i,j)
        if(xca.lt.0) xca=-xca
        if(xpt.lt.0) xpt=-xpt
        wca(i,j)=acca(i,j)/(xca+xpt)
        wpt(i,j)=acpt(i,j)/(xca+xpt)
      enddo
      enddo
      
c* pattern ac
       DO iw=1,nws
       DO ip=1,npp
         do i=1,imp
         do j=1,jmp
           obs(i,j)=fld4d(i,j,ip+ldpen-1,iw)
           obs2(i,j)=fld4d(i,j,ip,iw) !as persistency prd
           prd(i,j)=fld4d2(i,j,ip,iw)
         enddo
         enddo
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
          ts2(it)=wca(i,j)*fld4d2(i,j,ip,iw)+
     &            wpt(i,j)*fld4d(i,j,ip,iw)
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

c* real prd based on current IC
      if(ldpen.gt.1) then
      read(55) fld2d
      write(60) fld2d
      read(55) obs
      write(60) obs
      do i=1,imp
      do j=1,jmp
        obs2(i,j)=wca(i,j)*fld2d(i,j)+wpt(i,j)*obs(i,j)
      enddo
      enddo
      write(60) obs2
      endif

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
c*
