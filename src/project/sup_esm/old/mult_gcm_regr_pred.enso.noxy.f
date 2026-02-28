      program regression
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. regression between obs and gcms (b9x,echam,ccm3,gfdl)
C. nyin < nyr: cross validation; nyin = nyr: no cross validation.
C. weights are spatial independent & only ENSO years are evaluated.
C===========================================================
      PARAMETER (imax=72,jmax=37,nyr=45,nyin=44)
      PARAMETER (nyenso=15,icdcase=8,iwmcase=7)
      real fld1(imax,jmax),fld2(imax,jmax)
      real b0(imax,jmax),b1(imax,jmax)
      real b2(imax,jmax),b3(imax,jmax)
      real b4(imax,jmax)
      real b9x3d(imax,jmax,nyin),echam3d(imax,jmax,nyin)
      real ccm33d(imax,jmax,nyin),gfdl3d(imax,jmax,nyin)
      real obs3d(imax,jmax,nyin)
      real b9x2d(imax,jmax),echam2d(imax,jmax)
      real ccm32d(imax,jmax),gfdl2d(imax,jmax)
      real obs2d(imax,jmax)
      real warmcp(imax,jmax),coldcp(imax,jmax)
      real obs(nyin,imax,jmax),gcm(4,nyin,imax,jmax),beta(4)
      real wk1(imax,jmax),wk11(imax,jmax),wk2(imax,jmax)
      real wk3(imax,jmax),wk4(imax,jmax)
      real wk5(imax,jmax),zmwk(jmax)
      real coslat(jmax),xlat(jmax)
      real actp(nyenso,7)
      real acpna(nyenso,7),acglb(nyenso,7)
      real rmstp(nyenso,7)
      real rmspna(nyenso,7),rmsglb(nyenso,7)
      real acpnamw(7),acpnamc(7)
      real acglbmw(7),acglbmc(7)
      real actpmw(7),actpmc(7)
      real rmpnamw(7),rmpnamc(7)
      real rmglbmw(7),rmglbmc(7)
      real rmtpmw(7),rmtpmc(7)
      real clim1(imax,jmax),clim2(imax,jmax)
      real clim3(imax,jmax),clim4(imax,jmax)
      real clim5(imax,jmax)
      real*8 gmgm(4,4),obgm(4)
      real*8 gmgminv(4,4)
      real   gm(4)
      real iwmcd(nyenso),iwarm(iwmcase),icold(icdcase)
      real betaout(nyenso,4)
c
      data iwmcd/1,6,7,9,17,20,22,24,25,27,34,36,38,40,43/
      data iwarm/9,17,20,24,34,38,43/
      data icold/1,6,7,22,25,27,36,40/
 
      open(unit=10,form='unformated',access='direct',recl=imax*jmax)
      open(unit=11,form='unformated',access='direct',recl=imax*jmax)
      open(unit=20,form='unformated',access='direct',recl=imax*jmax)
      open(unit=30,form='unformated',access='direct',recl=imax*jmax)
      open(unit=40,form='unformated',access='direct',recl=imax*jmax)
      open(unit=50,form='unformated',access='direct',recl=imax*jmax)
      open(unit=60,form='unformated',access='direct',recl=imax*jmax)

      mean=0  ! mean=1: acc take off area mean; 
              ! =0: not take off area mean
      ieddy=0 ! ieddy=1: eddy only; ieddy=0: not eddy only
      ianom=1 ! =1: remove time mean; =0: not remove time mean
      itpfcd=0 ! =1: use sst forced obs to regress; =0: use raw obs
 
      ib9x=1  ! =0 means not include it
      iecham=1  ! =0 means not include it
      iccm3=1  ! =0 means not include it
      igfdl=1  ! =0 means not include it
ccc have coslat
      do j=1,jmax
        xlat(j)=(j-1)*5-90
        coslat(j)=cos(xlat(j)*3.14159/180)
      enddo

C===  verify against each case
      do 1000 icase=1,nyenso

         iy=0
      do 2000 iyear=1,nyr

         read(10) wk1
         read(11) wk11
         read(20) wk2
         read(30) wk3
         read(40) wk4
         read(50) wk5

        if (iyear.eq.iwmcd(icase)) then
         do i=1,imax
         do j=1,jmax
            obs2d(i,j)=wk1(i,j)
            b9x2d(i,j)=wk2(i,j)
            echam2d(i,j)=wk3(i,j)
            ccm32d(i,j)=wk4(i,j)
            gfdl2d(i,j)=wk5(i,j)
         end do
         end do
        end if

        IF (nyr.eq.nyin) then  ! that is, not cross validation
         iy=iy+1
         do i=1,imax
         do j=1,jmax

            if (itpfcd.eq.1) then
            obs3d(i,j,iy)=wk11(i,j)
            else
            obs3d(i,j,iy)=wk1(i,j)
            end if

            b9x3d(i,j,iy)=wk2(i,j)
            echam3d(i,j,iy)=wk3(i,j)
            ccm33d(i,j,iy)=wk4(i,j)
            gfdl3d(i,j,iy)=wk5(i,j)
         end do
         end do
        ELSE                      ! there is cross cross validation
          if(iyear.ne.iwmcd(icase)) then
          iy=iy+1
          do i=1,imax
          do j=1,jmax

            if (itpfcd.eq.1) then
            obs3d(i,j,iy)=wk11(i,j)
            else
            obs3d(i,j,iy)=wk1(i,j)
            end if

            b9x3d(i,j,iy)=wk2(i,j)
            echam3d(i,j,iy)=wk3(i,j)
            ccm33d(i,j,iy)=wk4(i,j)
            gfdl3d(i,j,iy)=wk5(i,j)
          end do
          end do
          end if
        END IF

 2000 continue

C===  remove time mean
      if(ianom.eq.1) then
      call timeanom(obs3d,imax,jmax,nyin,clim1)
      call timeanom(b9x3d,imax,jmax,nyin,clim2)
      call timeanom(echam3d,imax,jmax,nyin,clim3)
      call timeanom(ccm33d,imax,jmax,nyin,clim4)
      call timeanom(gfdl3d,imax,jmax,nyin,clim5)
      end if

C===  correct anom for target year data
      do i=1,imax
      do j=1,jmax
            obs2d(i,j)=obs2d(i,j)-clim1(i,j)
            b9x2d(i,j)=b9x2d(i,j)-clim2(i,j)
            echam2d(i,j)=echam2d(i,j)-clim3(i,j)
            ccm32d(i,j)=ccm32d(i,j)-clim4(i,j)
            gfdl2d(i,j)=gfdl2d(i,j)-clim5(i,j)
       end do
       end do

C=== remove zonal mean
      if(ieddy.eq.1) then
      call eddy3d(obs3d,imax,jmax,nyin,zmwk)
      call eddy3d(b9x3d,imax,jmax,nyin,zmwk)
      call eddy3d(echam3d,imax,jmax,nyin,zmwk)
      call eddy3d(ccm33d,imax,jmax,nyin,zmwk)
      call eddy3d(gfdl3d,imax,jmax,nyin,zmwk)

      call eddy(obs2d,imax,jmax,zmwk)
      call eddy(b9x2d,imax,jmax,zmwk)
      call eddy(echam2d,imax,jmax,zmwk)
      call eddy(ccm32d,imax,jmax,zmwk)
      call eddy(gfdl2d,imax,jmax,zmwk)
      end if

        rewind 10
        rewind 11
        rewind 20
        rewind 30
        rewind 40
        rewind 50
C=== have obs enso composites
      call setzero(warmcp,imax,jmax)
      call setzero(coldcp,imax,jmax)

      do 4000 iyear=1,nyr
         read(10) wk1
         read(20) wk2
         read(30) wk3
         read(40) wk4
         read(50) wk5

      IF (nyr.eq.nyin) THEN  ! that is, not cross validation

      do iy=1,iwmcase
       if (iwarm(iy).eq.iyear) then
         do i=1,imax
         do j=1,jmax
            warmcp(i,j)=warmcp(i,j)+wk1(i,j)/float(iwmcase)
         end do
         end do
       end if
      end do

      do iy=1,icdcase
       if (icold(iy).eq.iyear) then
         do i=1,imax
         do j=1,jmax
            coldcp(i,j)=coldcp(i,j)+wk1(i,j)/float(icdcase)
         end do
         end do
       end if
      end do

      ELSE                 ! there is cross cross validation
      if(iyear.ne.iwmcd(icase)) then
      do iy=1,iwmcase
       if (iwarm(iy).eq.iyear) then
         do i=1,imax
         do j=1,jmax
            warmcp(i,j)=warmcp(i,j)+wk1(i,j)/float(iwmcase-1)
         end do
         end do
        end if
      end do

      do iy=1,icdcase
       if (icold(iy).eq.iyear) then
         do i=1,imax
         do j=1,jmax
            coldcp(i,j)=coldcp(i,j)+wk1(i,j)/float(icdcase-1)
         end do
         end do
       end if
      end do
      end if
      END IF

 4000 continue

C=== define lon/lat for different areas
      lattp1=15
      lattp2=23
      latnh1=24
      latnh2=37
      latsh1=1
      latsh2=14
 
      latpna1=23
      latpna2=33
      lonpna1=31
      lonpna2=61

C=== define area of spatial integration
c     is=lonpna1
c     ie=lonpna2
c     js=latpna1
c     je=latpna2
      is=1
      ie=imax
      js=1
      je=jmax
c
         do k=1,nyin
         do i=1,imax
         do j=1,jmax
           obs(  k,i,j)=obs3d(i,j,k)
           gcm(1,k,i,j)=ib9x*b9x3d(i,j,k)
           gcm(2,k,i,j)=iecham*echam3d(i,j,k)
           gcm(3,k,i,j)=iccm3*ccm33d(i,j,k)
           gcm(4,k,i,j)=igfdl*gfdl3d(i,j,k)
         end do
         end do
         end do
c
C=== construct matrix
      call setzero_2d_dd(gmgm,4,4)
      call setzero_1d_dd(obgm,4)
c
      do im=1,4
      do jm=1,4
         do k=1,nyin
            axy=0.
         do i=is,ie
         do j=js,je
           axy=axy+coslat(j)
           gmgm(im,jm)=gmgm(im,jm)+coslat(j)*gcm(im,k,i,j)*gcm(jm,k,i,j)
         end do
         end do
         end do
      end do
      end do

      do im=1,4
      do jm=1,4
         gmgm(im,jm)=gmgm(im,jm)/(axy*nyin)
      end do
      end do

      do im=1,4
         do k=1,nyin
            axy=0.
         do i=is,ie
         do j=js,je
            axy=axy+coslat(j)
            obgm(im)=obgm(im)+coslat(j)*obs(k,i,j)*gcm(im,k,i,j)
         end do
         end do
         end do
      end do

      do im=1,4
         obgm(im)=obgm(im)/(axy*nyin)
      end do

c        write(6,*)'matrix=',obgm
         call mtrx_inv(gmgm,gmgminv,4)
         call solutn(gmgminv,obgm,beta,4)
C== have xmean
      do im=1,4
        gm(i)=0
        do k=1,nyin
        axy=0
        do i=is,ie
         do j=js,je
            axy=axy+coslat(j)
            gm(im)=gm(im)+coslat(j)*gcm(im,k,i,j)
         end do
        end do
        end do
      end do
      do im=1,4
        gm(im)=gm(im)/(axy*nyin)
      end do
c
        om=0
        do k=1,nyin
        axy=0
        do i=is,ie
         do j=js,je
            axy=axy+coslat(j)
            om=om+coslat(j)*obs(k,i,j)
         end do
        end do
        end do
        om=om/(axy*nyin)
        
        af=0.
        do im=1,4
          af=sf+beta(i)*gm(i)
        end do
    
        xmean=om-af

C=== write beta into a array
        do i=1,4
          betaout(icase,i)=beta(i)
        end do

C=== make prediction and verify against obs for case i
C... prediction with multi_regression
      do i=1,imax
      do j=1,jmax
         wk1(i,j)=xmean+beta(1)*b9x2d(i,j)+
     &            beta(2)*echam2d(i,j)+
     &            beta(3)*ccm32d(i,j)+
     &            beta(4)*gfdl2d(i,j)
      end do
      end do
C... prediction with simple ensemble
      do i=1,imax
      do j=1,jmax
         wk2(i,j)=(b9x2d(i,j)+
     &            echam2d(i,j)+
     &            ccm32d(i,j)+
     &            gfdl2d(i,j))/4.
      end do
      end do
C... verify against obs2d
c... have 1-D acc for TROP NH SH PNA area(input data is from South to North)

        call acc(obs2d,wk1,coslat,jmax,imax,lattp1,
     &lattp2,1,imax,tp,mean)
        call acc(obs2d,wk1,coslat,jmax,imax,latnh1,
     &latnh2,1,imax,anh,mean)
        call acc(obs2d,wk1,coslat,jmax,imax,latsh1,
     &latsh2,1,imax,sh,mean)
        call acc(obs2d,wk1,coslat,jmax,imax,latpna1,
     &latpna2,lonpna1,lonpna2,pna,mean)
        call acc(obs2d,wk1,coslat,jmax,imax,1,
     &jmax,1,imax,glb,mean)
        call rms(obs2d,wk1,coslat,jmax,imax,lattp1,
     &lattp2,1,imax,rmtp)
        call rms(obs2d,wk1,coslat,jmax,imax,latpna1,
     &latpna2,lonpna1,lonpna2,rmpna)
        call rms(obs2d,wk1,coslat,jmax,imax,1,
     &jmax,1,imax,rmglb)

      iicase=50+iwmcd(icase)-1
      write(15,777) 'year = ',iicase
      write(15,888) 'regression:','tp=',tp,rmtp,' nh=',anh,
     &           ' sh=',sh,'pna=',pna,rmpna,' glb=',glb
      acpna(icase,1)=pna
      acglb(icase,1)=glb
      actp(icase,1)=tp
      rmspna(icase,1)=rmpna
      rmsglb(icase,1)=rmglb
      rmstp(icase,1)=rmtp

        call acc(obs2d,wk2,coslat,jmax,imax,lattp1,
     &lattp2,1,imax,tp,mean)
        call acc(obs2d,wk2,coslat,jmax,imax,latnh1,
     &latnh2,1,imax,anh,mean)
        call acc(obs2d,wk2,coslat,jmax,imax,latsh1,
     &latsh2,1,imax,sh,mean)
        call acc(obs2d,wk2,coslat,jmax,imax,latpna1,
     &latpna2,lonpna1,lonpna2,pna,mean)
        call acc(obs2d,wk2,coslat,jmax,imax,1,
     &jmax,1,imax,glb,mean)
        call rms(obs2d,wk2,coslat,jmax,imax,lattp1,
     &lattp2,1,imax,rmtp)
        call rms(obs2d,wk2,coslat,jmax,imax,latpna1,
     &latpna2,lonpna1,lonpna2,rmpna)
        call rms(obs2d,wk2,coslat,jmax,imax,1,
     &jmax,1,imax,rmglb)

      write(15,888) '4_model_esm:','tp=',tp,rmtp,' nh=',anh,
     &           ' sh=',sh,'pna=',pna,rmpna,' glb=',glb
      acpna(icase,2)=pna
      acglb(icase,2)=glb
      actp(icase,2)=tp
      rmspna(icase,2)=rmpna
      rmsglb(icase,2)=rmglb
      rmstp(icase,2)=rmtp

      do iy=1,iwmcase
        if(iwarm(iy).eq.iwmcd(icase)) then
       write(6,*) 'iwarm icase=',icase
         do i=1,imax
         do j=1,jmax
            wk5(i,j)=warmcp(i,j)
         end do
         end do
        end if
      end do

      do iy=1,icdcase
        if(icold(iy).eq.iwmcd(icase)) then
       write(6,*) 'icold icase=',icase
         do i=1,imax
         do j=1,jmax
            wk5(i,j)=coldcp(i,j)
         end do
         end do
        end if
      end do

      write(6,*) 'wk5=',wk5(1,30),wk5(36,20)
        call acc(obs2d,wk5,coslat,jmax,imax,lattp1,
     &lattp2,1,imax,tp,mean)
        call acc(obs2d,wk5,coslat,jmax,imax,latnh1,
     &latnh2,1,imax,anh,mean)
        call acc(obs2d,wk5,coslat,jmax,imax,latsh1,
     &latsh2,1,imax,sh,mean)
        call acc(obs2d,wk5,coslat,jmax,imax,latpna1,
     &latpna2,lonpna1,lonpna2,pna,mean)
        call acc(obs2d,wk5,coslat,jmax,imax,1,
     &jmax,1,imax,glb,mean)
        call rms(obs2d,wk5,coslat,jmax,imax,lattp1,
     &lattp2,1,imax,rmtp)
        call rms(obs2d,wk5,coslat,jmax,imax,latpna1,
     &latpna2,lonpna1,lonpna2,rmpna)
        call rms(obs2d,wk5,coslat,jmax,imax,1,
     &jmax,1,imax,rmglb)

      write(15,888) 'obs_comp:','tp=',tp,rmtp,' nh=',anh,
     &           ' sh=',sh,'pna=',pna,rmpna,' glb=',glb
      acpna(icase,3)=pna
      acglb(icase,3)=glb
      actp(icase,3)=tp
      rmspna(icase,3)=rmpna
      rmsglb(icase,3)=rmglb
      rmstp(icase,3)=rmtp

        call acc(obs2d,b9x2d,coslat,jmax,imax,lattp1,
     &lattp2,1,imax,tp,mean)
        call acc(obs2d,b9x2d,coslat,jmax,imax,latnh1,
     &latnh2,1,imax,anh,mean)
        call acc(obs2d,b9x2d,coslat,jmax,imax,latsh1,
     &latsh2,1,imax,sh,mean)
        call acc(obs2d,b9x2d,coslat,jmax,imax,latpna1,
     &latpna2,lonpna1,lonpna2,pna,mean)
        call acc(obs2d,b9x2d,coslat,jmax,imax,1,
     &jmax,1,imax,glb,mean)
        call rms(obs2d,b9x2d,coslat,jmax,imax,lattp1,
     &lattp2,1,imax,rmtp)
        call rms(obs2d,b9x2d,coslat,jmax,imax,latpna1,
     &latpna2,lonpna1,lonpna2,rmpna)
        call rms(obs2d,b9x2d,coslat,jmax,imax,1,
     &jmax,1,imax,rmglb)

      write(15,888) 'b9x_esm:','tp=',tp,rmtp,' nh=',anh,
     &           ' sh=',sh,'pna=',pna,rmpna,' glb=',glb
      acpna(icase,4)=pna
      acglb(icase,4)=glb
      actp(icase,4)=tp
      rmspna(icase,4)=rmpna
      rmsglb(icase,4)=rmglb
      rmstp(icase,4)=rmtp

        call acc(obs2d,echam2d,coslat,jmax,imax,lattp1,
     &lattp2,1,imax,tp,mean)
        call acc(obs2d,echam2d,coslat,jmax,imax,latnh1,
     &latnh2,1,imax,anh,mean)
        call acc(obs2d,echam2d,coslat,jmax,imax,latsh1,
     &latsh2,1,imax,sh,mean)
        call acc(obs2d,echam2d,coslat,jmax,imax,latpna1,
     &latpna2,lonpna1,lonpna2,pna,mean)
        call acc(obs2d,echam2d,coslat,jmax,imax,1,
     &jmax,1,imax,glb,mean)
        call rms(obs2d,echam2d,coslat,jmax,imax,lattp1,
     &lattp2,1,imax,rmtp)
        call rms(obs2d,echam2d,coslat,jmax,imax,latpna1,
     &latpna2,lonpna1,lonpna2,rmpna)
        call rms(obs2d,echam2d,coslat,jmax,imax,1,
     &jmax,1,imax,rmglb)

      write(15,888) 'echam_esm:','tp=',tp,rmtp,' nh=',anh,
     &           ' sh=',sh,'pna=',pna,rmpna,' glb=',glb
      acpna(icase,5)=pna
      acglb(icase,5)=glb
      actp(icase,5)=tp
      rmspna(icase,5)=rmpna
      rmsglb(icase,5)=rmglb
      rmstp(icase,5)=rmtp

        call acc(obs2d,ccm32d,coslat,jmax,imax,lattp1,
     &lattp2,1,imax,tp,mean)
        call acc(obs2d,ccm32d,coslat,jmax,imax,latnh1,
     &latnh2,1,imax,anh,mean)
        call acc(obs2d,ccm32d,coslat,jmax,imax,latsh1,
     &latsh2,1,imax,sh,mean)
        call acc(obs2d,ccm32d,coslat,jmax,imax,latpna1,
     &latpna2,lonpna1,lonpna2,pna,mean)
        call acc(obs2d,ccm32d,coslat,jmax,imax,1,
     &jmax,1,imax,glb,mean)
        call rms(obs2d,ccm32d,coslat,jmax,imax,lattp1,
     &lattp2,1,imax,rmtp)
        call rms(obs2d,ccm32d,coslat,jmax,imax,latpna1,
     &latpna2,lonpna1,lonpna2,rmpna)
        call rms(obs2d,ccm32d,coslat,jmax,imax,1,
     &jmax,1,imax,rmglb)

      write(15,888) 'ccm3_esm:','tp=',tp,rmtp,' nh=',anh,
     &           ' sh=',sh,'pna=',pna,rmpna,' glb=',glb
      acpna(icase,6)=pna
      acglb(icase,6)=glb
      actp(icase,6)=tp
      rmspna(icase,6)=rmpna
      rmsglb(icase,6)=rmglb
      rmstp(icase,6)=rmtp

        call acc(obs2d,gfdl2d,coslat,jmax,imax,lattp1,
     &lattp2,1,imax,tp,mean)
        call acc(obs2d,gfdl2d,coslat,jmax,imax,latnh1,
     &latnh2,1,imax,anh,mean)
        call acc(obs2d,gfdl2d,coslat,jmax,imax,latsh1,
     &latsh2,1,imax,sh,mean)
        call acc(obs2d,gfdl2d,coslat,jmax,imax,latpna1,
     &latpna2,lonpna1,lonpna2,pna,mean)
        call acc(obs2d,gfdl2d,coslat,jmax,imax,1,
     &jmax,1,imax,glb,mean)
        call rms(obs2d,gfdl2d,coslat,jmax,imax,lattp1,
     &lattp2,1,imax,rmtp)
        call rms(obs2d,gfdl2d,coslat,jmax,imax,latpna1,
     &latpna2,lonpna1,lonpna2,rmpna)
        call rms(obs2d,gfdl2d,coslat,jmax,imax,1,
     &jmax,1,imax,rmglb)

      write(15,888) 'gfdl_esm:','tp=',tp,rmtp,' nh=',anh,
     &           ' sh=',sh,'pna=',pna,rmpna,' glb=',glb
      acpna(icase,7)=pna
      acglb(icase,7)=glb
      actp(icase,7)=tp
      rmspna(icase,7)=rmpna
      rmsglb(icase,7)=rmglb
      rmstp(icase,7)=rmtp

      write(15,666) '**************************************'
      write(60) obs2d
      write(60) wk1
      write(60) wk2
      write(60) b9x2d
      write(60) echam2d
      write(60) ccm32d
      write(60) gfdl2d
      rewind 10
      rewind 20
      rewind 30
      rewind 40
      rewind 50
 1000 continue

C=== have mean AC and RMS for warmcases and cold cases respectively

      call setzero_1d(acpnamw,7)
      call setzero_1d(acpnamc,7)
      call setzero_1d(acglbmw,7)
      call setzero_1d(acglbmc,7)
      call setzero_1d(actpmw,7)
      call setzero_1d(actpmc,7)
      call setzero_1d(rmpnamw,7)
      call setzero_1d(rmpnamc,7)
      call setzero_1d(rmglbmw,7)
      call setzero_1d(rmglbmc,7)
      call setzero_1d(rmtpmw,7)
      call setzero_1d(rmtpmc,7)

      Do iyear=1,nyenso

      do iy=1,iwmcase
       if (iwarm(iy).eq.iwmcd(iyear)) then
         do i=1,7
            acpnamw(i)=acpnamw(i)+acpna(iyear,i)/float(iwmcase)
            acglbmw(i)=acglbmw(i)+acglb(iyear,i)/float(iwmcase)
            actpmw(i)=actpmw(i)+actp(iyear,i)/float(iwmcase)
            rmpnamw(i)=rmpnamw(i)+rmspna(iyear,i)/float(iwmcase)
            rmglbmw(i)=rmglbmw(i)+rmsglb(iyear,i)/float(iwmcase)
            rmtpmw(i)=rmtpmw(i)+rmstp(iyear,i)/float(iwmcase)
         end do
       end if
      end do
      do iy=1,icdcase
       if (icold(iy).eq.iwmcd(iyear)) then
         do i=1,7
            acpnamc(i)=acpnamc(i)+acpna(iyear,i)/float(icdcase)
            acglbmc(i)=acglbmc(i)+acglb(iyear,i)/float(icdcase)
            actpmc(i)=actpmc(i)+actp(iyear,i)/float(icdcase)
            rmpnamc(i)=rmpnamc(i)+rmspna(iyear,i)/float(icdcase)
            rmglbmc(i)=rmglbmc(i)+rmsglb(iyear,i)/float(icdcase)
            rmtpmc(i)=rmtpmc(i)+rmstp(iyear,i)/float(icdcase)
         end do
       end if
      end do

      End do
      write(15,*)'MEAN AC'
      write(15,555)'regr:',
     &             ' tp=',actpmw(1),actpmc(1),
     &             'pna=',acpnamw(1),acpnamc(1),
     &             'glb=',acglbmw(1),acglbmc(1)
      write(15,555)'4_model:',
     &             ' tp=',actpmw(2),actpmc(2),
     &             'pna=',acpnamw(2),acpnamc(2),
     &             'glb=',acglbmw(2),acglbmc(2)
      write(15,555)'obscmp:',
     &             ' tp=',actpmw(3),actpmc(3),
     &             'pna=',acpnamw(3),acpnamc(3),
     &             'glb=',acglbmw(3),acglbmc(3)
      write(15,555)'b9x:',
     &             ' tp=',actpmw(4),actpmc(4),
     &             'pna=',acpnamw(4),acpnamc(4),
     &             'glb=',acglbmw(4),acglbmc(4)
      write(15,555)'echam:',
     &             ' tp=',actpmw(5),actpmc(5),
     &             'pna=',acpnamw(5),acpnamc(5),
     &             'glb=',acglbmw(5),acglbmc(5)
      write(15,555)'ccm3:',
     &             ' tp=',actpmw(6),actpmc(6),
     &             'pna=',acpnamw(6),acpnamc(6),
     &             'glb=',acglbmw(6),acglbmc(6)
      write(15,555)'gfdl:',
     &             ' tp=',actpmw(7),actpmc(7),
     &             'pna=',acpnamw(7),acpnamc(7),
     &             'glb=',acglbmw(7),acglbmc(7)

      write(15,*)'MEAN RMS'
      write(15,555)'regr:',
     &             ' tp=',rmtpmw(1),rmtpmc(1),
     &             'pna=',rmpnamw(1),rmpnamc(1),
     &             'glb=',rmglbmw(1),rmglbmc(1)
      write(15,555)'4_model:',
     &             ' tp=',rmtpmw(2),rmtpmc(2),
     &             'pna=',rmpnamw(2),rmpnamc(2),
     &             'glb=',rmglbmw(2),rmglbmc(2)
      write(15,555)'obscmp:',
     &             ' tp=',rmtpmw(3),rmtpmc(3),
     &             'pna=',rmpnamw(3),rmpnamc(3),
     &             'glb=',rmglbmw(3),rmglbmc(3)
      write(15,555)'b9x:',
     &             ' tp=',rmtpmw(4),rmtpmc(4),
     &             'pna=',rmpnamw(4),rmpnamc(4),
     &             'glb=',rmglbmw(4),rmglbmc(4)
      write(15,555)'echam:',
     &             ' tp=',rmtpmw(5),rmtpmc(5),
     &             'pna=',rmpnamw(5),rmpnamc(5),
     &             'glb=',rmglbmw(5),rmglbmc(5)
      write(15,555)'ccm3:',
     &             ' tp=',rmtpmw(6),rmtpmc(6),
     &             'pna=',rmpnamw(6),rmpnamc(6),
     &             'glb=',rmglbmw(6),rmglbmc(6)
      write(15,555)'gfdl:',
     &             ' tp=',rmtpmw(7),rmtpmc(7),
     &             'pna=',rmpnamw(7),rmpnamc(7),
     &             'glb=',rmglbmw(7),rmglbmc(7)

555   format(A10,3(2x,A5,2f7.2))
888   format(A13,1x,A3,f5.2,1x,f6.2,2(1x,A4,f5.2),
     &1x,A4,f5.2,1x,f6.2,1x,A5,f5.2)
777   format(1x,A10,I3)
666   format(1x,A50)

      write(15,*) "weights for model b9x, echam, ccm3 & gfdl"
      do n=1,nyenso
      write(15,444) n,betaout(n,1),betaout(n,2),betaout(n,3),
     &              betaout(n,4)
      end do
444   format(2x,I2,2x,4(f8.2,2x))

      stop
      END


      SUBROUTINE setzero(fld,n,m)
      DIMENSION fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end

      SUBROUTINE setzero_2d_dd(fld,n,m)
      real*8 fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end


      SUBROUTINE setzero_1d(fld,n)
      DIMENSION fld(n)
      do i=1,n
         fld(i)=0.0
      enddo
      return
      end

      SUBROUTINE setzero_1d_dd(fld,n)
      real*8 fld(n)
      do i=1,n
         fld(i)=0.0
      enddo
      return
      end

      SUBROUTINE rms(fld1,fld2,coslat,jmax,imax,
     'lat1,lat2,lon1,lon2,rm)

      real fld1(imax,jmax),fld2(imax,jmax),coslat(jmax)

      area=0
      do j=lat1,lat2
      do i=lon1,lon2
        area=area+coslat(j)
      enddo
      enddo


      rm=0.

      do j=lat1,lat2
      do i=lon1,lon2
         df=fld1(i,j)-fld2(i,j)
         rm=rm+df*df*coslat(j)/area
      enddo
      enddo

      rm=sqrt(rm)

      return
      end

      SUBROUTINE acc(fld1,fld2,coslat,jmax,imax,
     'lat1,lat2,lon1,lon2,cor,mean)

      real fld1(imax,jmax),fld2(imax,jmax),coslat(jmax)

      area=0
      do j=lat1,lat2
      do i=lon1,lon2
        area=area+coslat(j)
      enddo
      enddo

        af1=0
        af2=0
      if(mean.eq.1) then
      do j=lat1,lat2
      do i=lon1,lon2
        af1=af1+sqrt(coslat(j))*fld1(i,j)/area
        af2=af2+sqrt(coslat(j))*fld2(i,j)/area
      enddo
      enddo
      end if

      cor=0.
      sd1=0.
      sd2=0.

      do j=lat1,lat2
      do i=lon1,lon2
      cor=cor+(fld1(i,j)-af1)*(fld2(i,j)-af2)*coslat(j)/area
      sd1=sd1+(fld1(i,j)-af1)*(fld1(i,j)-af1)*coslat(j)/area
      sd2=sd2+(fld2(i,j)-af2)*(fld2(i,j)-af2)*coslat(j)/area
      enddo
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      cor=cor/(sd1*sd2)

      return
      end


      SUBROUTINE accavg(acc,sd1,sd2,coslat,jmax,imax,
     '                  lat1,lat2,lon1,lon2,cor)

      real acc(imax,jmax),coslat(jmax)
      real sd1(imax,jmax),sd2(imax,jmax)

      area=0
      do j=lat1,lat2
      do i=lon1,lon2
        area=area+coslat(j)
      enddo
      enddo

      cor=0.
      do j=lat1,lat2
      do i=lon1,lon2

        if(acc(i,j).lt.0..and.(sd1(i,j)/sd2(i,j)).lt.1) then
c       acc(i,j)=acc(i,j)*(sd1(i,j)/sd2(i,j))
        endif

        cor=cor+acc(i,j)*coslat(j)/area

      enddo
      enddo

      return
      end

      SUBROUTINE norsou(fldin,fldot,lon,lat)
      dimension fldin(lon,lat),fldot(lon,lat)
      do 100 j=1,lat
      do 100 i=1,lon
         fldot(i,j)=fldin(i,lat+1-j)
  100 continue
      return
      end

      SUBROUTINE wtout(fld,lon,lat,lat1,lat2,lon1,lon2)
      dimension fld(lon,lat)
      do 100 j=lat1,lat2
      do 100 i=lon1,lon2
         write(6,*) 'i,j= ',i,j,fld(i,j)
  100 continue
      return
      end

      SUBROUTINE accmaskavg(acc,mask,sd1,sd2,coslat,jmax,imax,
     '                  lat1,lat2,lon1,lon2,cor)

      real acc(imax,jmax),coslat(jmax),mask(imax,jmax)
      real sd1(imax,jmax),sd2(imax,jmax)

      area=0
      do j=lat1,lat2
      do i=lon1,lon2
        if(mask(i,j).lt.0) then
        area=area+coslat(j)
        endif
      enddo
      enddo

      cor=0.
      do j=lat1,lat2
      do i=lon1,lon2

        if(mask(i,j).lt.0) then

        if(acc(i,j).lt.0..and.(sd1(i,j)/sd2(i,j)).lt.1) then
c       acc(i,j)=acc(i,j)*(sd1(i,j)/sd2(i,j))
        endif

        cor=cor+acc(i,j)*coslat(j)/area

        end if

      enddo
      enddo

      return
      end


      SUBROUTINE maskout(fld,mask,lon,lat)
      dimension fld(lon,lat),mask(lon,lat)
      do  j=1,lat
      do  i=1,lon
        if(mask(i,j).gt.0) then
          fld(i,j)=-999.0
        endif
      end do
      end do
      return
      end


      SUBROUTINE timeanom(fld,lon,lat,ltime,clim)
      dimension fld(lon,lat,ltime),clim(lon,lat)
      call setzero(clim,lon,lat)
      do  k=1,ltime
      do  j=1,lat
      do  i=1,lon
        clim(i,j)=clim(i,j)+fld(i,j,k)/float(ltime)
      end do
      end do
      end do

      do  k=1,ltime
      do  j=1,lat
      do  i=1,lon
        fld(i,j,k)=fld(i,j,k)-clim(i,j)
      end do
      end do
      end do
      return
      end

      SUBROUTINE eddy3d(fld,lon,lat,ltime,zmean)
      dimension fld(lon,lat,ltime),zmean(lat)
      do  k=1,ltime

      do  j=1,lat
        zmean(j)=0.
      do  i=1,lon
        zmean(j)=zmean(j)+fld(i,j,k)/float(lon)
      end do
      end do

      do  j=1,lat
      do  i=1,lon
        fld(i,j,k)=fld(i,j,k)-zmean(j)
      end do
      end do

      end do
      return
      end

      SUBROUTINE eddy(fld,lon,lat,zmean)
      dimension fld(lon,lat),zmean(lat)

      do  j=1,lat
        zmean(j)=0.
      do  i=1,lon
        zmean(j)=zmean(j)+fld(i,j)/float(lon)
      end do
      end do

      do  j=1,lat
      do  i=1,lon
        fld(i,j)=fld(i,j)-zmean(j)
      end do
      end do

      return
      end

      SUBROUTINE solutn(ff,vf,beta,m)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
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

