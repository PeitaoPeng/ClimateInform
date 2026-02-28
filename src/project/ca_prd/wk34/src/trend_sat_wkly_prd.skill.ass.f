      program caprd
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C CA prediction for tropical heating
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c range for sat pat cor (ac_1d)
      parameter(imts=77,imte=125)  ! 190E-310E
      parameter(jmts=41,jmte=69)   ! 10N-80N
c
      parameter(npp=nps-4)       ! max weeks to be predicted
      parameter(ntt=nseason*nps,nhs=(nseason-3)*npp)
      dimension ts1(npp*nseason),ts2(npp*nseason),ts3(npp*nseason)
      dimension ts4(ntt),ts5(ntt)
      dimension tsout(npp),tsout2(npp)
      dimension ac1d(6,nseason,npp),ac1d2(6,nseason,npp)
      dimension rms1d(6,nseason,npp),rms1d2(6,nseason,npp)
C
      dimension    xlatsat(jmt),coslsat(jmt)
      dimension    t2d(imt,jmt),t2d2(imt,jmt)
      dimension    t4d(imt,jmt,nps,nseason),t4d2(imt,jmt,nps,nseason)
      dimension    twk2d(imt,jmt),twk2d2(imt,jmt)
      dimension    prdsat(imt,jmt)
      dimension    obssat(imt,jmt)
      dimension ac1dsat(7,nseason,npp),ac1dsat2(7,nseason,npp)
      dimension rms1dsat(7,nseason,npp),rms1dsat2(7,nseason,npp)
C
C
      open(unit=11,form='unformatted',access='direct',recl=4*imt*jmt) !input trend
      open(unit=12,form='unformatted',access='direct',recl=4*imt*jmt)   !input sat      
c
      open(unit=50,form='unformatted',access='direct',recl=4*imt*jmt)
      open(unit=51,form='unformatted',access='direct',recl=4*imt*jmt)
      open(unit=52,form='unformatted',access='direct',recl=4*imt*jmt)
      open(unit=53,form='unformatted',access='direct',recl=4*imt*jmt)
      open(unit=54,form='unformatted',access='direct',recl=4*imt*jmt)
      open(unit=55,form='unformatted',access='direct',recl=4*imt*jmt)

      open(unit=81,form='unformatted',access='direct',recl=4*npp)  !1D_skill
      open(unit=82,form='unformatted',access='direct',recl=4*imt*jmt) !2D_skill
c*************************************************
c
      PI=4.*atan(1.)
      CONV=PI/180.

      do j=1,jmt
      xlatsat(j)=-90+(j-1)*2.5
      enddo

      DO j=1,jmt
        coslsat(j)=COS(xlatsat(j)*CONV)
      END DO
c
C*********************************************
c* read in data
      iu=11
      iu2=12
c
      if (iseason.eq.1) then  ! for spring, ICs in mid-Feb to end-May
      kps=8
      endif
      if(iseason.eq.2) then  ! for summe, ICs in mid-May to end-Aug
      kps=20
      end if
      if(iseason.eq.3) then  ! for fall, ICs in mid-Aug to end-Nov
      kps=33
      end if
      if(iseason.eq.4) then  !for winter, ICs in mid-Nov to end-Feb
      kps=46
      end if
c
      irec=0
      DO is=1,nseason          ! number of seasons used to for CA
        np=0
        do it=kps,kps+nps-1  
        irec=irec+1
        np=np+1
          read(iu,rec=it) t2d2 !trend
          read(iu2,rec=it) t2d !obs
            do j=1,jmt
            do i=1,imt
              t4d(i,j,np,is)=t2d(i,j)
              t4d2(i,j,np,is)=t2d2(i,j)
              if(abs(t2d(i,j)).gt.999) then
                t4d(i,j,np,is)=0.
                t4d2(i,j,np,is)=0.
              endif
            enddo
            enddo
        enddo
      write(6,*) 'it=',kps
      kps=kps+52
c
      write(6,*) 'time length of data =',irec
      ENDDO
c
c* cross validated CA prd begins
c
      iout=0
      DO ldpen=1,6  !1:IC; 2:0 wk1; 3: wk2; 4: wk3; 5: wk4; 6: wk34

      np=0
      DO is=1,nseason      !loop over target season
      DO ip=1,npp          !loop over target week
      np=np+1

         do i=1,imt
         do j=1,jmt
           obssat(i,j)=t4d(i,j,ip+ldpen-1,is)
           prdsat(i,j)=t4d2(i,j,ip+ldpen-1,is)
           if(ldpen.eq.6) then
           obssat(i,j)=0.5*(t4d(i,j,ip+ldpen-2,is)+
     &t4d(i,j,ip+ldpen-1,is))
           prdsat(i,j)=0.5*(t4d2(i,j,ip+ldpen-2,is)+
     &t4d2(i,j,ip+ldpen-1,is))
           endif
         enddo
         enddo
         write(49+ldpen,rec=np) prdsat
c
      call rmsd1(obssat,prdsat,imt,jmt,imts,imte,jmts,jmte,coslsat,
     &rms1dsat(ldpen,is,ip),ac1dsat(ldpen,is,ip))

       ENDDO
       ENDDO
       write(6,*) 'ldwk=',ldpen,'  number of prd write out=',np
c
c* temporal corr for sat grids
c
      do i=1,imt
      do j=1,jmt
        it=1
        do is=1,nseason
        do ip=1,npp
          ts1(it)=t4d(i,j,ip+ldpen-1,is) ! obs
          ts2(it)=t4d2(i,j,ip+ldpen-1,is) !trend
          if(ldpen.eq.6) then
          ts1(it)=0.5*(t4d(i,j,ip+ldpen-2,is)+t4d(i,j,ip+ldpen-1,is))
          ts2(it)=0.5*(t4d2(i,j,ip+ldpen-2,is)+t4d2(i,j,ip+ldpen-1,is))
          endif
        it=it+1
        enddo
        enddo
        call corr_1d(nseason*npp,ts1,ts2,t2d(i,j)) ! against raw
        call rms_1d(nseason*npp,ts1,ts2,twk2d(i,j))
      enddo
      enddo
      iout=iout+1
      write(82,rec=iout) t2d
      iout=iout+1
      write(82,rec=iout) twk2d
c
      ENDDO  !loop for ldpen
c
c write out ac1d and rms1d
c
       iwo=0
       do is=1,nseason
         do ldpen=1,6
           do ip=1,npp
           tsout(ip)=ac1dsat(ldpen,is,ip)
           end do
           iwo=iwo+1
           write(81,rec=iwo) tsout
         end do
         do ldpen=1,6
           do ip=1,npp
           tsout(ip)=rms1dsat(ldpen,is,ip)
           end do
           iwo=iwo+1
           write(81,rec=iwo) tsout
         end do
       end do
C*********************************************
100    format(9f7.2/9f7.2)
110    format(A2,I2,A6,6f8.2)
      write(6,*) 'end of excution'
 888  continue
      STOP
      END
c*
c
      subroutine normal_1d(nt,ts)
      dimension ts(nt)
        x=0
        do i=1,nt
          x=x+ts(i)*ts(i)
        end do
        x=sqrt(x/float(nt))
        do i=1,nt
          ts(i)=ts(i)/x
        end do

      return
      end
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
      subroutine f4d_2_f2d(im,jm,nps,nseason,ip,iw,fld2d,fld4d)
      dimension fld4d(im,jm,nps,nseason),fld2d(im,jm)
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
      subroutine rms_1d(n,ts1,ts2,rms)
      dimension ts1(n),ts2(n)
      x=0.
      do it=1,n
      x=x+(ts1(it)-ts2(it))*(ts1(it)-ts2(it))
      enddo
      rms=sqrt(x/float(n))
      return
      end
c*
      subroutine corr_1d(n,ts1,ts2,corr)
      dimension ts1(n),ts2(n)
      x=0.
      y=0.
      xy=0.
      do it=1,n
      x=x+ts1(it)*ts1(it)
      y=y+ts2(it)*ts2(it)
      xy=xy+ts1(it)*ts2(it)
      enddo
      corr=xy/(sqrt(x)*sqrt(y))
      return
      end
c*
      subroutine regr_1d(n,ts1,ts2,corr)
      dimension ts1(n),ts2(n)
      x=0.
      y=0.
      xy=0.
      do it=1,n
      x=x+ts1(it)*ts1(it)/float(n)
      y=y+ts2(it)*ts2(it)/float(n)
      xy=xy+ts1(it)*ts2(it)/float(n)
      enddo
      corr=xy/sqrt(x)
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

      subroutine pass_4d(wk1,wk2,n1,n2,n3,n4)
      dimension wk1(n1,n2,n3,n4),wk2(n1,n2,n3,n4)
      do l=1,n4
      do k=1,n3
      do j=1,n2
      do i=1,n1
      wk2(i,j,k,l)=wk1(i,j,k,l)
      enddo
      enddo
      enddo
      enddo
      return
      end

      subroutine rmsd1(anom,anomp,im,jm,ims,ime,jms,jme,cosl,z1,zc)
      dimension anomp(im,jm),anom(im,jm)
      dimension cosl(jm)
      x=0.
      y=0.
      z=0.
      zc=0.
      w=0.
      do i=ims,ime
      do j=jms,jme
      cosw=cosl(j)
      if(abs(anom(i,j)).gt.9.e9.or.abs(anomp(i,j)).gt.9.e9) go to 123
      w=w+cosw
      x=x+anom(i,j)*anom(i,j)*cosw
      y=y+anomp(i,j)*anomp(i,j)*cosw
      z=z+(anomp(i,j)-anom(i,j))*(anomp(i,j)-anom(i,j))*cosw
      zc=zc+anomp(i,j)*anom(i,j)*cosw
  123 continue
      enddo
      enddo
      x1=sqrt(x/w)
      y1=sqrt(y/w)
      z1=sqrt(z/w)
      zc=zc/w/(x1*y1)
      return
      end
