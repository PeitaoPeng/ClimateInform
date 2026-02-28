      program caprd
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C CA prediction for tropical heating
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      parameter(ngrd=imp*jmp)
c range for z500 pat cor (ac_1d)
      parameter(ims=1,ime=144)   ! 0->360
      parameter(jms=1,jme=jmp)   ! 20S->90N
c range for sat pat cor (ac_1d)
      parameter(imts=77,imte=125)  ! 190E-310E
      parameter(jmts=41,jmte=69)   ! 10N-80N
c
      parameter(npp=nps-4)       ! max weeks to be predicted
      parameter(ntt=nseason*npp,nhs=(nseason-3)*npp)
      parameter(icttm=modemax*mwic)
c
      dimension ts1(npp*nseason),ts2(npp*nseason),ts3(npp*nseason)
      dimension ts4(ntt),ts5(ntt)
      dimension tsout(npp),tsout2(npp)
      dimension ac1d(6,nseason,npp),ac1d2(6,nseason,npp)
      dimension rms1d(6,nseason,npp),rms1d2(6,nseason,npp)
      dimension rms_pc(6,modemax),corr_pc(6,modemax)
      dimension fldin(imin,jmin),fldin2(imin,jmin)
      dimension xlat(jmp),fldp(imp,jmp)
      dimension alpha(nhs),corr(imp,jmp)
      dimension alpha3d(nhs,npp,nseason)
      dimension obs(imp,jmp)
      dimension prd(imp,jmp),prdw34(imp,jmp,npp,nseason)
      dimension wk2d(imp,jmp),wk2d2(imp,jmp)
      dimension fld2d(imp,jmp),fld4d(imp,jmp,nps+mwic-1,nseason)
      dimension tgt4d(imp,jmp,npp,nseason)
      dimension clim(imp,jmp,nps),aaa(ngrd,ntt)
      dimension efld3d(modemax,nps+mwic-1,nseason)
      dimension efld4d(modemax,nps,mwic,nseason)
      dimension etgt3d(modemax,npp,nseason)
      dimension    WK(ntt,ngrd)
      dimension    ana(modemax*mwic,nhs+1),anac(modemax)
      dimension    eval(ntt),evec(ngrd,ntt),pc(ntt,ntt)
      dimension    eof(modemax,imp,jmp),cosl(jmp)
C
      dimension    xlatsat(jmt),coslsat(jmt)
      dimension    t2d(imt,jmt),t4d(imt,jmt,nps,nseason)
      dimension    satana(imt,jmt,nhs+1),tgtsat4d(imt,jmt,npp,nseason)
      dimension    twk2d(imt,jmt),twk2d2(imt,jmt)
      dimension    prdsat(imt,jmt),prdsatw34(imt,jmt,npp,nseason)
      dimension    obssat(imt,jmt)
      dimension ac1dsat(7,nseason,npp),ac1dsat2(7,nseason,npp)
      dimension rms1dsat(7,nseason,npp),rms1dsat2(7,nseason,npp)
C
C
      open(unit=11,form='unformatted',access='direct',recl=4*imin*jmin) !input psi
      open(unit=12,form='unformatted',access='direct',recl=4*imt*jmt)   !input sat      

c for predictor (psi or hgt)
      open(unit=60,form='unformatted',access='direct',recl=4*imp*jmp) !CA_data
      open(unit=61,form='unformatted',access='direct',recl=4*imp*jmp) !wk1_prd
      open(unit=62,form='unformatted',access='direct',recl=4*imp*jmp) !wk2_prd
      open(unit=63,form='unformatted',access='direct',recl=4*imp*jmp) !wk3_prd
      open(unit=64,form='unformatted',access='direct',recl=4*imp*jmp) !wk4_prd
      open(unit=65,form='unformatted',access='direct',recl=4*imp*jmp) !wk34_prd
c for T2m
      open(unit=50,form='unformatted',access='direct',recl=4*imt*jmt) !CA_data
      open(unit=51,form='unformatted',access='direct',recl=4*imt*jmt) !wk1_prd
      open(unit=52,form='unformatted',access='direct',recl=4*imt*jmt) !wk2_prd
      open(unit=53,form='unformatted',access='direct',recl=4*imt*jmt) !wk3_prd
      open(unit=54,form='unformatted',access='direct',recl=4*imt*jmt) !wk4_prd
      open(unit=55,form='unformatted',access='direct',recl=4*imt*jmt) !wk34_prd
      open(unit=56,form='unformatted',access='direct',recl=4*imt*jmt) !wk34_obs
c
      open(unit=70,form='unformatted',access='direct',recl=4*imp*jmp) !EOFs for proj use

      open(unit=71,form='unformatted',access='direct',recl=4*npp)  !1D_skill
      open(unit=72,form='unformatted',access='direct',recl=4*imp*jmp) !2D_skill
c
      open(unit=81,form='unformatted',access='direct',recl=4*npp)  !1D_skill
      open(unit=82,form='unformatted',access='direct',recl=4*imt*jmt) !2D_skill
c*************************************************
c
      PI=4.*atan(1.)
      CONV=PI/180.

      do j=1,jmp
      xlat(j)=eoflats+(j-1)*2.5
      enddo
c
      DO j=1,jmp
        cosl(j)=COS(xlat(j)*CONV)
      END DO
c
      do j=1,jmt
      xlatsat(j)=-90+(j-1)*2.5
      enddo
      DO j=1,jmt
        coslsat(j)=COS(xlatsat(j)*CONV)
      END DO
c
      fak=1.
      ridge=0.05
c 
C*********************************************
c* read in data
      iu=11
      iu2=12
c
      if (iseason.eq.1) then  ! for spring, ICs in MAM
      kps=9
      endif
      if(iseason.eq.2) then  ! for summe, ICs in JJA
      kps=22
      end if
      if(iseason.eq.3) then  ! for fall, ICs in SON
      kps=35
      end if
      if(iseason.eq.4) then  !for winter, ICs in DJF
      kps=48
      end if
c
      irec=0
      DO is=1,nseason          ! number of seasons used to for CA
        np=0
        do it=kps-mwic+1,kps+nps-1  
        irec=irec+1
        np=np+1
      write(6,*) 'for unit=12,it=',it
          read(iu,rec=it) fldin
            do j=1,jmp
            do i=1,imp
              fld4d(i,j,np,is)=fldin(i+lons-1,j+lats-1)  
              if(abs(fldin(i+lons-1,j+lats-1)).gt.999999999) then
                write(6,*) 'undef in is=',is,'np=',np,'i,j=',i,j
                fld4d(i,j,np,is)=0.
              endif
            enddo
            enddo
        enddo
      kps=kps+52
      write(6,*) 'time length of psi200 data =',irec
      ENDDO

      irec=0
      kps=48
      DO is=1,nseason          ! number of seasons used to for CA
        np=0
        do it=kps,kps+nps-1  
        irec=irec+1
        np=np+1
          read(iu2,rec=it) t2d
            do j=1,jmt
            do i=1,imt
              t4d(i,j,np,is)=t2d(i,j)
              if(abs(t2d(i,j)).gt.999) then
c               write(6,*) 'sat undef in is=',is,'np=',np,'i,j=',i,j
                t4d(i,j,np,is)=0.
              endif
            enddo
            enddo
        enddo
      kps=kps+52
      write(6,*) 'time length of t2m data =',irec
      ENDDO
c
      IF (nruneof.eq.1) THEN
c* input data for EOF analysis
      it=0
      do is=1,nseason
      do ip=mwic,npp+mwic-1 ! limit DJF for EOF
      it=it+1
        id=0
        do j=1,jmp
        do i=1,imp
          id=id+1
          aaa(id,it)=fld4d(i,j,ip,is)*sqrt(cosl(j))
        end do
        end do
      enddo
      enddo
      write(6,*) 'length of input data to EOF calculation=',it
c       
      call eofs_4_ca(aaa,ngrd,ntt,ntt,eval,evec,pc,wk,0)
c     call eofs_4_ca(aaa,ngrd,ntt,ngrd,eval,evec,pc,wk,0)
c
      write(6,*)'eval='
      write(6,400) eval
 400  format(6f8.4)
c     go to 888
c
c* have 2D EOF 
c
        do nm=1,modemax
        ng=0
        do j=1,jmp
        do i=1,imp
          ng=ng+1
          eof(nm,i,j)=evec(ng,nm)
        end do
        end do
        end do
c
c* standardize spatial patterns to unity****
c
        do m1=1,modemax

        call inprod1(imp,jmp,modemax,eof,cosl,m1,m1,anorm)
c       write(6,*)m1,anorm
        do i=1,imp
        do j=1,jmp
          eof(m1,i,j)=eof(m1,i,j)/sqrt(anorm)
        end do
        end do

        do i=1,imp
        do j=1,jmp
          fld2d(i,j)=eof(m1,i,j)
        end do
        end do
        write(70,rec=m1) fld2d ! write out EOFs
        enddo  !loop for m1

        ELSE
        do m1=1,modemax
        read(70,rec=m1) fld2d
          do i=1,imp
          do j=1,jmp
            eof(m1,i,j)=fld2d(i,j)
          end do
          end do
        enddo
      ENDIF
c       go to 888
c
C* project grid data onto EOFs*******
c
        do is=1,nseason
        do ip=1,nps+mwic-1
        call f4d_2_f2d(imp,jmp,nps+mwic-1,nseason,ip,is,fld2d,fld4d)
        do nmode=1,modemax
          call inprod4(eof,fld2d,imp,jmp,cosl,nmode,modemax,anorm)
          efld3d(nmode,ip,is)=anorm
        enddo
        enddo
        enddo 
c
c extend to multi week data
        do ic=1,mwic

        do is=1,nseason
        do ip=1,nps
        do nmode=1,modemax
          efld4d(nmode,ip,ic,is)=efld3d(nmode,ip+mwic-ic,is)
        enddo
        enddo
        enddo

        enddo ! ic loop
c
c* cross validated CA prd begins
c
      iout=0
      iout2=0
      DO ldpen=1,6  !1:IC; 2:0 wk1; 3: wk2; 4: wk3; 5: wk4; 6: wk34

      if(ldpen.eq.6) go to 999

      DO ntgts=1,nseason      !loop over target season

        ntgtsm=ntgts-1
        ntgtsp=ntgts+1
        if(ntgts.eq.1) ntgtsm=3
        if(ntgts.eq.nseason) ntgtsp=nseason-2

      DO ntgtp=1,npp          !loop over target week

        it=0
        do is=1,nseason       !loop for the non-target winter
c
        if(is.eq.ntgtsm) go to 555
        if(is.eq.ntgts)  go to 555
        if(is.eq.ntgtsp) go to 555
          do ip=1,npp
            it=it+1

            mm=0
            do nmode=1,modemax
            do ic=1,mwic
            mm=mm+1
              ana(mm,it)=efld4d(nmode,ip+ldpen-1,ic,is)
            enddo
            enddo

            do i=1,imt
            do j=1,jmt
              satana(i,j,it)=t4d(i,j,ip+ldpen-1,is)
            enddo
            enddo

          enddo           !loop for the non-target pentad
 555    continue
        enddo             !loop for the non-target winter

        IF(ldpen.gt.1) go to 222

c for ICs
        mm=0
        do nmode=1,modemax
        do ic=1,mwic
        mm=mm+1
        ana(mm,nhs+1)=efld4d(nmode,ntgtp,ic,ntgts)
        enddo
        enddo

        ridge=0.01
        go to 212
 211    continue
        ridge=ridge+0.01
 212    continue

        call getalpha(ana,alpha,icttm,nhs,fak,ridge)
        if(ntgts.eq.1.and.ntgtp.eq.1) then
c       write(6,*) 'alpha=',alpha
        endif

        do k=1,nhs
        alpha3d(k,ntgtp,ntgts)=alpha(k)
        enddo

        alphas=0
        do k=1,nhs
        alphas=alphas+alpha(k)*alpha(k)
        enddo
        write(6,*) 'target season=',ntgts,'alphas=',alphas
        if(alphas.gt.0.5) go to 211

 222    continue
c
c psi forecast associated with the latest IC in hindcast
        im=0
        do nmode=1,icttm,mwic
        im=im+1
        etgt3d(im,ntgtp,ntgts)=0.
        do ntime=1,nhs
        etgt3d(im,ntgtp,ntgts)=etgt3d(im,ntgtp,ntgts)+
     &           ana(nmode,ntime)*alpha3d(ntime,ntgtp,ntgts)
        enddo
        enddo
c construct sat prd
        do i=1,imt
        do j=1,jmt
        tgtsat4d(i,j,ntgtp,ntgts)=0.
        enddo
        enddo
     
        do i=1,imt
        do j=1,jmt
        do ntime=1,nhs
        tgtsat4d(i,j,ntgtp,ntgts)=tgtsat4d(i,j,ntgtp,ntgts)+
     &           satana(i,j,ntime)*alpha3d(ntime,ntgtp,ntgts)
        enddo
        enddo
        enddo

      ENDDO  !loop over target pentad
      ENDDO  !loop over target season

c
c* PC to grid for constructed data
c
      DO is=1,nseason      
      DO ip=1,npp  

        do i=1,imp
        do j=1,jmp
          tgt4d(i,j,ip,is)=0.
        do nmode=1,modemax
          tgt4d(i,j,ip,is)=tgt4d(i,j,ip,is)+
     &          etgt3d(nmode,ip,is)*eof(nmode,i,j)
        enddo
        enddo
        enddo

       ENDDO
       ENDDO
c
c* have wk3-4 avg
c
      if(ldpen.eq.4) then
        call pass_4d(tgt4d,prdw34,imp,jmp,npp,nseason)
        call pass_4d(tgtsat4d,prdsatw34,imt,jmt,npp,nseason)
      endif
      if(ldpen.eq.5) then
        call avg_4d(tgt4d,prdw34,imp,jmp,npp,nseason)
        call avg_4d(tgtsat4d,prdsatw34,imt,jmt,npp,nseason)
      endif
 999  if(ldpen.eq.6) then
        call pass_4d(prdw34,tgt4d,imp,jmp,npp,nseason)
        call pass_4d(prdsatw34,tgtsat4d,imt,jmt,npp,nseason)
      endif
c
c* spatial corr
       np=0
       DO is=1,nseason
       DO ip=1,npp
       np=np+1
         do i=1,imp
         do j=1,jmp
           if(ldpen.lt.6) then
           obs(i,j)=fld4d(i,j,ip+ldpen-1,is)
           endif
           if(ldpen.eq.6) then
           obs(i,j)=0.5*(fld4d(i,j,ip+ldpen-3,is)+
     &fld4d(i,j,ip+ldpen-2,is))
           endif
           prd(i,j)=tgt4d(i,j,ip,is)
         enddo
         enddo
c for sat
         do i=1,imt
         do j=1,jmt
           if(ldpen.lt.6) then
           obssat(i,j)=t4d(i,j,ip+ldpen-1,is)
           endif
           if(ldpen.eq.6) then
           obssat(i,j)=0.5*(t4d(i,j,ip+ldpen-3,is)+
     &t4d(i,j,ip+ldpen-2,is))
           endif
           prdsat(i,j)=tgtsat4d(i,j,ip,is) !Sat prd
         enddo
         enddo
c* write out prd
         write(59+ldpen,rec=np) prd
         write(49+ldpen,rec=np) prdsat
c
         if(ldpen.eq.6) then
           write(56,rec=np) obssat
         endif
c
      call rmsd1(obs,prd,imp,jmp,ims,ime,jms,jme,cosl,
     &rms1d(ldpen,is,ip),ac1d(ldpen,is,ip))
c
      call rmsd1(obssat,prdsat,imt,jmt,imts,imte,jmts,jmte,coslsat,
     &rms1dsat(ldpen,is,ip),ac1dsat(ldpen,is,ip))
       ENDDO
       ENDDO
       write(6,*) 'ldwk=',ldpen,'  number of prd write out=',np
c
c temporal corr for predictor grids
c
      do i=1,imp
      do j=1,jmp
        it=1
        do is=1,nseason
        do ip=1,npp
          ts1(it)=fld4d(i,j,ip+ldpen-1,is)
          if(ldpen.eq.6) then
          ts1(it)=0.5*(fld4d(i,j,ip+ldpen-3,is)+
     &fld4d(i,j,ip+ldpen-2,is))
          endif
          ts2(it)=tgt4d(i,j,ip,is)
        it=it+1
        enddo
        enddo
        call corr_1d(nseason*npp,ts1,ts2,fld2d(i,j))
        call rms_1d(nseason*npp,ts1,ts2,wk2d(i,j))
      enddo
      enddo
      iout=iout+1
      write(72,rec=iout) fld2d
      iout=iout+1
      write(72,rec=iout) wk2d
c
c* temporal corr for sat grids
c
      do i=1,imt
      do j=1,jmt
        it=1
        do is=1,nseason
        do ip=1,npp
          ts1(it)=t4d(i,j,ip+ldpen-1,is) !raw obs
          if(ldpen.eq.6) then
          ts1(it)=0.5*(t4d(i,j,ip+ldpen-3,is)+t4d(i,j,ip+ldpen-2,is))
          endif
          ts2(it)=tgtsat4d(i,j,ip,is) !ca prd
        it=it+1
        enddo
        enddo
        call corr_1d(nseason*npp,ts1,ts2,t2d(i,j)) ! against raw
        call rms_1d(nseason*npp,ts1,ts2,twk2d(i,j))
      enddo
      enddo
      iout2=iout2+1
      write(82,rec=iout2) t2d
      iout2=iout2+1
      write(82,rec=iout2) twk2d
c
      ENDDO  !loop for ldpen
c
c write out ac1d and rms1d
c
       iwo=0
       do is=1,nseason
         do ldpen=1,6
           do ip=1,npp
           tsout(ip)=ac1d(ldpen,is,ip)
           tsout2(ip)=ac1dsat(ldpen,is,ip)
           end do
           iwo=iwo+1
           write(71,rec=iwo) tsout
           write(81,rec=iwo) tsout2
         end do
         do ldpen=1,6
           do ip=1,npp
           tsout(ip)=rms1d(ldpen,is,ip)
           tsout2(ip)=rms1dsat(ldpen,is,ip)
           end do
           iwo=iwo+1
           write(71,rec=iwo) tsout
           write(81,rec=iwo) tsout2
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
      subroutine fill_mis(im,jm,fld1,fld2,undf)
      dimension fld1(im,jm),fld2(im,jm)
        do i=1,im
        do j=1,jm
          if(abs(fld1(i,j)).gt.undf) then
          fld2(i,j)=0.
          else
          fld2(i,j)=fld1(i,j)
          endif
        enddo
        enddo
      return
      end
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

      subroutine avg_4d(wk1,wk2,n1,n2,n3,n4)
      dimension wk1(n1,n2,n3,n4),wk2(n1,n2,n3,n4)
      do l=1,n4
      do k=1,n3
      do j=1,n2
      do i=1,n1
      wk2(i,j,k,l)=0.5*(wk1(i,j,k,l)+wk2(i,j,k,l))
      enddo
      enddo
      enddo
      enddo
      return
      end

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
