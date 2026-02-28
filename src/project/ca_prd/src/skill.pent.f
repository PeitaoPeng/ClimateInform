      program caprd
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C CA prediction for tropical heating
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      parameter(imp=72,jmp=24)   ! grid size of prcp
      parameter(ngrd=imp*jmp)
      parameter(nws=23,nps=24)   ! 23 winters, each winter 24 pentads
      parameter(ims=9,ime=60)   ! grid to have 1d skill
c     parameter(ims=1,ime=imp)   ! grid to have skill
      parameter(npp=nps-6)       ! max 6 pentads to be predicted
      parameter(ntt=nws*nps,nhs=(nws-1)*(npp))
      dimension ts1(npp*nws),ts2(npp*nws),ts3(npp*nws)
      dimension ac1d(npp),ac1d2(npp)
      dimension xlat(jmp),fldp(imp,jmp)
      dimension corr(imp,jmp)
      dimension obs(imp,jmp),obs2(imp,jmp),prd(imp,jmp)
      dimension fld2d(imp,jmp),fld4d(imp,jmp,nps,nws)
      dimension prd5d(imp,jmp,npp,nws,7)
      dimension clim(imp,jmp),aaa(ngrd,ntt)
      dimension nwyr(6),ncyr(6),nnyr(11)
      dimension cosl(jmp)
C
      open(unit=20,form='unformatted',access='direct',recl=72*24) !pent data
      open(unit=21,form='unformatted',access='direct',recl=72*24) !pent data
      open(unit=22,form='unformatted',access='direct',recl=72*24) !pent data
      open(unit=23,form='unformatted',access='direct',recl=72*24) !pent data
      open(unit=24,form='unformatted',access='direct',recl=72*24) !pent data
      open(unit=25,form='unformatted',access='direct',recl=72*24) !pent data
      open(unit=26,form='unformatted',access='direct',recl=72*24) !pent data
      open(unit=27,form='unformatted',access='direct',recl=72*24) !pent data
c     open(unit=40,form='unformatted',access='direct',recl=npp)     !corr skill
      open(unit=40,form='formatted')     !corr skill
      open(unit=50,form='unformatted',access='direct',recl=imp*jmp) !corr skill

      data nwyr/4,8,9,13,16,19/
      data ncyr/5,6,10,17,20,21/
      data nnyr/1,2,3,7,11,12,14,15,18,22,23/
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
c 
C*********************************************
c
c* read in obs data
c
      DO iw=1,nws      
      DO ip=1,nps  
        read(20) fld2d
        do i=1,imp
        do j=1,jmp
          fld4d(i,j,ip,iw)=fld2d(i,j)
        enddo
        enddo
      ENDDO
      ENDDO
c
c* read in prd data
c
      DO LDPEN=1,7
      DO iw=1,nws      
      DO ip=1,npp  
        read(20+LDPEN) fld2d
        do i=1,imp
        do j=1,jmp
          prd5d(i,j,ip,iw,ldpen)=fld2d(i,j)
        enddo
        enddo
      ENDDO
      ENDDO
      ENDDO
c
c* skill for El Nino winters
c
      DO LDPEN=1,7
c* pattern ac
       DO nw=1,6
       DO ip=1,npp
         do i=1,imp
         do j=1,jmp
           obs(i,j)=fld4d(i,j,ip+ldpen-1,nwyr(nw))
           obs2(i,j)=fld4d(i,j,ip,nwyr(nw))
           prd(i,j)=prd5d(i,j,ip,nwyr(nw),ldpen)
         enddo
         enddo
         call rmsd1(obs,prd,imp,jmp,ims,ime,cosl,ac1d(ip))
         call rmsd1(obs,obs2,imp,jmp,ims,ime,cosl,ac1d2(ip))
       ENDDO
         write(40,*) 'ldpen=',ldpen,' winter #=',nwyr(nw)
         write(40,100) ac1d
         write(40,100) ac1d2
c        write(40) ac1d
       ENDDO
c* temporal ac
      do i=1,imp
      do j=1,jmp
        it=1
        do nw=1,6
        do ip=1,npp
          ts1(it)=fld4d(i,j,ip+ldpen-1,nwyr(nw))
          ts2(it)=prd5d(i,j,ip,nwyr(nw),ldpen)
          ts3(it)=fld4d(i,j,ip,nwyr(nw))
        it=it+1
        enddo
        enddo
        call corr_1d(6*npp,ts1,ts2,fld2d(i,j))
        call corr_1d(6*npp,ts1,ts3,obs2(i,j))
      enddo
      enddo
      write(50) fld2d
      write(50) obs2

      ENDDO  !loop for ldpen
c
c* skill for La Nino winters
c
      DO LDPEN=1,7
c* pattern ac
       DO nw=1,6
       DO ip=1,npp
         do i=1,imp
         do j=1,jmp
           obs(i,j)=fld4d(i,j,ip+ldpen-1,ncyr(nw))
           obs2(i,j)=fld4d(i,j,ip,ncyr(nw))
           prd(i,j)=prd5d(i,j,ip,ncyr(nw),ldpen)
         enddo
         enddo
         call rmsd1(obs,prd,imp,jmp,ims,ime,cosl,ac1d(ip))
         call rmsd1(obs,obs2,imp,jmp,ims,ime,cosl,ac1d2(ip))
       ENDDO
         write(40,*) 'ldpen=',ldpen,' winter #=',iw
         write(40,100) ac1d
         write(40,100) ac1d2
c        write(40) ac1d
       ENDDO
c* temporal ac
      do i=1,imp
      do j=1,jmp
        it=1
        do nw=1,6
        do ip=1,npp
          ts1(it)=fld4d(i,j,ip+ldpen-1,ncyr(nw))
          ts2(it)=prd5d(i,j,ip,ncyr(nw),ldpen)
          ts3(it)=fld4d(i,j,ip,ncyr(nw))
        it=it+1
        enddo
        enddo
        call corr_1d(6*npp,ts1,ts2,fld2d(i,j))
        call corr_1d(6*npp,ts1,ts3,obs2(i,j))
      enddo
      enddo
      write(50) fld2d
      write(50) obs2

      ENDDO  !loop for ldpen

c
c* skill for Normal winters
c
c* pattern ac
      DO LDPEN=1,7
       DO nw=1,11
       DO ip=1,npp
         do i=1,imp
         do j=1,jmp
           obs(i,j)=fld4d(i,j,ip+ldpen-1,nnyr(nw))
           obs2(i,j)=fld4d(i,j,ip,nnyr(nw))
           prd(i,j)=prd5d(i,j,ip,nnyr(nw),ldpen)
         enddo
         enddo
         call rmsd1(obs,prd,imp,jmp,ims,ime,cosl,ac1d(ip))
         call rmsd1(obs,obs2,imp,jmp,ims,ime,cosl,ac1d2(ip))
       ENDDO
         write(40,*) 'ldpen=',ldpen,' winter #=',nnyr(nw)
         write(40,100) ac1d
         write(40,100) ac1d2
c        write(40) ac1d
       ENDDO
c* temporal ac
      do i=1,imp
      do j=1,jmp
        it=1
        do nw=1,11
        do ip=1,npp
          ts1(it)=fld4d(i,j,ip+ldpen-1,nnyr(nw))
          ts2(it)=prd5d(i,j,ip,nnyr(nw),ldpen)
          ts3(it)=fld4d(i,j,ip,nnyr(nw))
        it=it+1
        enddo
        enddo
        call corr_1d(11*npp,ts1,ts2,fld2d(i,j))
        call corr_1d(11*npp,ts1,ts3,obs2(i,j))
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
