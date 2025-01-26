      program caprd
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C CA prediction for tropical heating
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      parameter(ngrd=imp*jmp)
c range for z500 pat cor (ac_1d)
      parameter(imss=1,imse=144)   ! 0->360
      parameter(jmss=1,jmse=jmp)   ! 20S->90N
c range for sat pat cor (ac_1d)
      parameter(imts=77,imte=125)  ! 190E-310E
      parameter(jmts=41,jmte=69)   ! 10N-80N
      parameter(kpdf=100)   ! # of pdf bin
c
      parameter(npp=nps-4)       ! max weeks to be predicted
      parameter(ntt=nseason*npp,nhs=(nseason-3)*npp)
c
      dimension ts1(npp*nseason),ts2(npp*nseason),ts3(npp*nseason)
      dimension tsout(npp),tsout2(npp)
      dimension ac1d(6,nseason,npp),ac1d2(6,nseason,npp)
      dimension rms1d(6,nseason,npp),rms1d2(6,nseason,npp)
      dimension rms_pc(6,modemax),corr_pc(6,modemax)
      dimension fldin(ims,jms),fldin2(ims,jms)
      dimension xlat(jmp),fldp(imp,jmp)
      dimension alpha(nhs),alpha2(ntt),corr(imp,jmp)
      dimension alpha3d(nhs,npp,nseason)
      dimension obs(imp,jmp)
      dimension prd(imp,jmp),prdw34(imp,jmp,npp,nseason)
      dimension prd2dw34(imp,jmp)
      dimension fld2d(imp,jmp),wk2d(imp,jmp),wk2d2(imp,jmp)
      dimension allpsi(ims,jms,52+nps,nyear)
      dimension allsat(imt,jmt,52+nps,nyear)
      dimension allpre(imt,jmt,52+nps,nyear)
      dimension fld4d(imp,jmp,nps,nseason)
      dimension tgt2d(imp,jmp),tgt3d(imp,jmp,npp) 
      dimension tgt4d(imp,jmp,npp,nseason)
      dimension psiclm(ims,jms,52),psiic(imp,jmp)
      dimension aaa(ngrd,ntt+1)
      dimension efld1d(modemax)
      dimension efld3d(modemax,nps,nseason)
      dimension etgt1d(modemax),etgt3d(modemax,npp,nseason)
      dimension    WK(ntt+1,ngrd)
      dimension    ana(modemax,nhs+1),ana2(modemax,ntt+1)
      dimension    eval(ntt+1),evec(ngrd,ntt+1),pc(ntt+1,ntt+1)
      dimension    eof(modemax,imp,jmp),cosl(jmp)
C
      dimension    xlatsat(jmt),coslsat(jmt)
c
      dimension    t2d(imt,jmt),t4d(imt,jmt,nps,nseason)
      dimension    satana(imt,jmt,nhs+1),tgtsat3d(imt,jmt,npp)
      dimension    satana2(imt,jmt,ntt+1)
      dimension    tgtsat4d(imt,jmt,npp,nseason)
      dimension    tgtsat2d(imt,jmt)
      dimension    twk2d(imt,jmt),twk2d2(imt,jmt)
      dimension    prdsat(imt,jmt),prdsatw34(imt,jmt,npp,nseason)
      dimension    prd2dsatw34(imt,jmt)
      dimension    obssat(imt,jmt),obssatw34(imt,jmt,npp,nseason)
c
      dimension    p2d(imt,jmt),p4d(imt,jmt,nps,nseason)
      dimension    preana(imt,jmt,nhs+1),tgtpre3d(imt,jmt,npp)
      dimension    preana2(imt,jmt,ntt+1)
      dimension    tgtpre4d(imt,jmt,npp,nseason)
      dimension    tgtpre2d(imt,jmt)
      dimension    pwk2d(imt,jmt),pwk2d2(imt,jmt)
      dimension    prdpre(imt,jmt),prdprew34(imt,jmt,npp,nseason)
      dimension    prd2dprew34(imt,jmt)
      dimension    obspre(imt,jmt),obsprew34(imt,jmt,npp,nseason)
c
      dimension ac1dsat(7,nseason,npp),ac1dsat2(7,nseason,npp)
      dimension rms1dsat(7,nseason,npp),rms1dsat2(7,nseason,npp)
      dimension sprmspsi(6),sprmssat(6)
      dimension spacpsi(6),spacsat(6)
      dimension ran(nseason-1),rdx(nseason-1)
      dimension w34avg(imt,jmt),w34std(imt,jmt)
      dimension obsavg(imt,jmt),obsstd(imt,jmt)
      dimension satclm(imt,jmt),satocn(imt,jmt)
c
      dimension xbin(kpdf),ypdf(kpdf),prbprd(imt,jmt)
c
      dimension obssat3d(imt,jmt,nseason),sattrd(imt,jmt,nseason)
      dimension aa(imt,jmt),bb(imt,jmt)
      dimension obspre3d(imt,jmt,nseason),pretrd(imt,jmt,nseason)
      dimension aap(imt,jmt),bbp(imt,jmt)
      dimension ts4(nseason),ts5(nseason)
      dimension ts6(nseason),ts7(nseason)
      dimension nts4(nseason*npp),nts5(nseason*npp)
      dimension hs(imt,jmt)
C
C
      open(unit=11,form='unformatted',access='direct',recl=4*ims*jms) !input historical psi
      open(unit=12,form='unformatted',access='direct',recl=4*imt*jmt) !input historical sat      
      open(unit=14,form='unformatted',access='direct',recl=4*imt*jmt) !input normalized prcp      

      open(unit=13,form='unformatted',access='direct',recl=4*ims*jms) !input clim psi
      open(unit=10,form='unformatted',access='direct',recl=4*imt*jmt) !input IC psi      
c
c     open(unit=70,form='unformatted',access='direct',recl=4*imp*jmp) !EOFs for proj use

c     open(unit=71,form='unformatted',access='direct',recl=4*npp)  !1D_skill
c     open(unit=72,form='unformatted',access='direct',recl=4*imp*jmp) !2D_skill
c
c     open(unit=81,form='unformatted',access='direct',recl=4*npp)  !1D_skill
c     open(unit=82,form='unformatted',access='direct',recl=4*imt*jmt) !2D_skill
c
      open(unit=85,form='unformatted',access='direct',recl=4*imp*jmp) !real forecast
      open(unit=86,form='unformatted',access='direct',recl=4*imt*jmt) !real forecast
      open(unit=87,form='unformatted',access='direct',recl=4*imt*jmt) !real forecast
c*************************************************
c
      PI=4.*atan(1.)
      CONV=PI/180.
      undef1=-9.99E+8
      undef2=-9.99E+33

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
      ridge=0.01
c
cc have IC data
c
      read(10,rec=1) fldin2
c
      do it=1,52
      read(13,rec=it) fldin
      do i=1,ims
      do j=1,jms
        psiclm(i,j,it)=fldin(i,j)
      enddo
      enddo
      enddo
c
      do i=1,imp
      do j=1,jmp
        psiic(i,j)=fldin2(i+lons-1,j+lats-1)-
     &psiclm(i+lons-1,j+lats-1,itgtw)
      enddo
      enddo
      do i=1,ims
      do j=1,jms
        fldin2(i,j)=fldin2(i,j)-psiclm(i,j,itgtw)
      enddo
      enddo
c 
cc read in all historical psi and sat data
c
      iu1=11
      iu2=12
      iu3=14
c
      it=0
      DO iy=1,nyear
      Do iw=1,52
      it=it+1
        read(iu1,rec=it) fldin
        read(iu2,rec=it) t2d
        read(iu3,rec=it) p2d
c
        do j=1,jms
        do i=1,ims
        allpsi(i,j,iw+nwextb,iy)=fldin(i,j)
        enddo
        enddo
c
        do j=1,jmt
        do i=1,imt
        allsat(i,j,iw+nwextb,iy)=t2d(i,j)
        allpre(i,j,iw+nwextb,iy)=p2d(i,j)
        if(allsat(i,j,iw+nwextb,iy).lt.-99999)
     &allsat(i,j,iw+nwextb,iy)=0.
        if(allsat(i,j,iw+nwextb,iy).lt.-99999)
     &allpre(i,j,iw+nwextb,iy)=0.
        enddo
        enddo
      Enddo
      Enddo
c
cc fill in the extended parts of data arrays
c
      DO iy=2,nyear-1

c  for ext in the beginning
       Do iw=1,nwextb
c
        do j=1,jms
        do i=1,ims
        allpsi(i,j,iw,iy)=allpsi(i,j,52+iw,iy-1)
        enddo
        enddo
c
        do j=1,jmt
        do i=1,imt
        allsat(i,j,iw,iy)=allsat(i,j,52+iw,iy-1)
        allpre(i,j,iw,iy)=allpre(i,j,52+iw,iy-1)
        enddo
        enddo
       Enddo

c  for ext in the end
       Do iw=1,nwexte
c
        do j=1,jms
        do i=1,ims
        allpsi(i,j,52+nwextb+iw,iy)=allpsi(i,j,nwextb+iw,iy+1)
        enddo
        enddo
c
        do j=1,jmt
        do i=1,imt
        allsat(i,j,52+nwextb+iw,iy)=allsat(i,j,nwextb+iw,iy+1)
        allpre(i,j,52+nwextb+iw,iy)=allpre(i,j,nwextb+iw,iy+1)
        enddo
        enddo
       Enddo
      Enddo
c
c data for EOF analysis
c
      iws=itgtw 
      iwe=itgtw+nps-1 

      irec=0
      is=0
      DO iy=2,nyear-1        ! number of years used for EOF
      is=is+1
        np=0
        do iw=iws,iwe  
        irec=irec+1
        np=np+1
            do j=1,jmp
            do i=1,imp
              fld4d(i,j,np,is)=allpsi(i+lons-1,j+lats-1,iw,iy)  
              if(abs(fldin(i+lons-1,j+lats-1)).gt.999999999) then
                write(6,*) 'undef in iy=',iy,'np=',np,'i,j=',i,j
                fld4d(i,j,np,is)=0.
              endif
            enddo
            enddo

            do j=1,jmt
            do i=1,imt
              t4d(i,j,np,is)=allsat(i,j,iw,iy)
              p4d(i,j,np,is)=allpre(i,j,iw,iy)
              if(abs(t2d(i,j)).gt.999) then
c               write(6,*) 'sat undef in iy=',iy,'np=',np,'i,j=',i,j
                t4d(i,j,np,is)=0.
                p4d(i,j,np,is)=0.
              endif
            enddo
            enddo
        enddo
c
      write(6,*) 'time length of data =',irec
      ENDDO
c
c* input data for EOF analysis
      it=0
      do is=1,nseason
      do ip=1,npp
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
c add psiic to aaa
      it=it+1
        id=0
        do j=1,jmp
        do i=1,imp
          id=id+1
          aaa(id,it)=psiic(i,j)*sqrt(cosl(j))
        end do
        end do

      write(6,*) 'length of input data to EOF calculation=',it
c       
      call eofs_4_ca(aaa,ngrd,ntt+1,ntt+1,eval,evec,pc,wk,0)
c
      write(6,*)'eval='
      write(6,400) eval
 400  format(6f8.4)
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
c       write(70,rec=m1) fld2d ! write out EOFs
        enddo  !loop for m1
c       go to 888
c
C* project grid data onto EOFs*******
c
c for historical data
        do is=1,nseason
        do ip=1,nps
        call f4d_2_f2d(imp,jmp,nps,nseason,ip,is,fld2d,fld4d)
        do nmode=1,modemax
          call inprod4(eof,fld2d,imp,jmp,cosl,nmode,modemax,anorm)
          efld3d(nmode,ip,is)=anorm
        enddo
        enddo
        enddo 
c for IC data
        do nmode=1,modemax
          call inprod4(eof,psiic,imp,jmp,cosl,nmode,modemax,anorm)
          efld1d(nmode)=anorm
        enddo
c     write(6,*) 'efld1d=',efld1d
c
c* realtime forecast
c
      write(85,rec=1) psiic

      iwr=0
      DO ldpen=1,6  !1:IC; 2:0 wk1; 3: wk2; 4: wk3; 5: wk4; 6: wk34

      if(ldpen.eq.6) go to 990


        it=0
        do is=1,nseason       !loop for the non-target winter
c
          do ip=1,npp
            it=it+1

            do nmode=1,modemax
              ana2(nmode,it)=efld3d(nmode,ip+ldpen-1,is)
            enddo
            do i=1,imt
            do j=1,jmt
              satana2(i,j,it)=t4d(i,j,ip+ldpen-1,is)
              preana2(i,j,it)=p4d(i,j,ip+ldpen-1,is)
            enddo
            enddo

          enddo   
        enddo  

        IF(ldpen.gt.1) go to 122

        do nmode=1,modemax
        ana2(nmode,ntt+1)=efld1d(nmode)
        enddo

        go to 112
 111    continue
        ridge=ridge+0.01
 112    continue

        call getalpha(ana2,alpha2,modemax,ntt,fak,ridge)

c     write(6,*) 'alpha2=',alpha2
 
        alpha22=0
        do k=1,ntt
        alpha22=alpha22+alpha2(k)*alpha2(k)
        enddo
        write(6,*) 'summation of alpha2=',alpha22

        if(alpha22.gt.0.5) go to 111

 122    continue

        do nmode=1,modemax
        etgt1d(nmode)=0.
        do ntime=1,ntt
        etgt1d(nmode)=etgt1d(nmode)+
     &           ana2(nmode,ntime)*alpha2(ntime)
        enddo
        enddo
c construct sat prd
        do i=1,imt
        do j=1,jmt
        tgtsat2d(i,j)=0.
        tgtpre2d(i,j)=0.
        enddo
        enddo
     
        do i=1,imt
        do j=1,jmt
        do ntime=1,ntt
        tgtsat2d(i,j)=tgtsat2d(i,j)+
     &           satana2(i,j,ntime)*alpha2(ntime)
        tgtpre2d(i,j)=tgtpre2d(i,j)+
     &           preana2(i,j,ntime)*alpha2(ntime)
        enddo
        enddo
        enddo
c
c* PC to grid for constructed prd
c
        do i=1,imp
        do j=1,jmp
          tgt2d(i,j)=0.
        do nmode=1,modemax
          tgt2d(i,j)=tgt2d(i,j)+
     &          etgt1d(nmode)*eof(nmode,i,j)
        enddo
        enddo
        enddo
c
c* have wk3-4 avg
c
      if(ldpen.eq.4) then
        call pass_2d(tgt2d,prd2dw34,imp,jmp)
        call pass_2d(tgtsat2d,prd2dsatw34,imt,jmt)
        call pass_2d(tgtpre2d,prd2dprew34,imt,jmt)
      endif
      if(ldpen.eq.5) then
        call avg_2d(tgt2d,prd2dw34,imp,jmp)
        call avg_2d(tgtsat2d,prd2dsatw34,imt,jmt)
        call avg_2d(tgtpre2d,prd2dprew34,imt,jmt)
      endif
 990  if(ldpen.eq.6) then
        call pass_2d(prd2dw34,tgt2d,imp,jmp)
        call pass_2d(prd2dsatw34,tgtsat2d,imt,jmt)
        call pass_2d(prd2dprew34,tgtpre2d,imt,jmt)
      endif
c* spatial cor for test run
         do i=1,imp
         do j=1,jmp
           prd(i,j)=tgt2d(i,j)
         enddo
         enddo
c for sat
         do i=1,imt
         do j=1,jmt
           prdsat(i,j)=tgtsat2d(i,j) !Sat prd
         enddo
         enddo
      iwr=iwr+1
      write(85,rec=iwr+1) prd
      write(86,rec=iwr) prdsat
c
      ENDDO  !loop for ldpen
c
c* 3-yr cross validated CA prd for having statistics
c* which will be used for construct prob forecast
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

cc randomly select 2 seasons for CV
c        ira=0
c     do 101 it=1,nseason   !seeds# = ira
c        if(it.eq.ntgts) go to 101
c        print*, it
c        ira=ira+1
c        ran(ira)=ran1(i)
c        rdx(ira)=it
c        print*, 'rdx=',rdx(ira),'ran=',ran(ira)
c 101    continue
c       call hpsort(nseason-1,nseason-1,ran,rdx)
c       ntgtsm=rdx(1)
c       ntgtsp=rdx(2)
        print*, 'ntgtsm=',ntgtsm,'ntgtsp=',ntgtsp

      DO ntgtp=1,npp          !loop over target week

        it=0
        do is=1,nseason       !loop for the non-target winter
c
        if(is.eq.ntgtsm) go to 555
        if(is.eq.ntgts)  go to 555
        if(is.eq.ntgtsp) go to 555
          do ip=1,npp
            it=it+1

            do nmode=1,modemax
              ana(nmode,it)=efld3d(nmode,ip+ldpen-1,is)
            enddo
            do i=1,imt
            do j=1,jmt
              satana(i,j,it)=t4d(i,j,ip+ldpen-1,is)
              preana(i,j,it)=p4d(i,j,ip+ldpen-1,is)
            enddo
            enddo

          enddo           !loop for the non-target pentad
 555    continue
        enddo             !loop for the non-target winter

        IF(ldpen.gt.1) go to 222

        do nmode=1,modemax
        ana(nmode,nhs+1)=efld3d(nmode,ntgtp,ntgts)
        enddo

        ridge=0.01
        go to 212
 211    continue
        ridge=ridge+0.01
 212    continue

        call getalpha(ana,alpha,modemax,nhs,fak,ridge)
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

        do nmode=1,modemax
        etgt3d(nmode,ntgtp,ntgts)=0.
        enddo
     
        do nmode=1,modemax
        do ntime=1,nhs
        etgt3d(nmode,ntgtp,ntgts)=etgt3d(nmode,ntgtp,ntgts)+
     &           ana(nmode,ntime)*alpha3d(ntime,ntgtp,ntgts)
        enddo
        enddo
c construct sat prd
        do i=1,imt
        do j=1,jmt
        tgtsat4d(i,j,ntgtp,ntgts)=0.
        tgtpre4d(i,j,ntgtp,ntgts)=0.
        enddo
        enddo
     
        do i=1,imt
        do j=1,jmt
        do ntime=1,nhs
        tgtsat4d(i,j,ntgtp,ntgts)=tgtsat4d(i,j,ntgtp,ntgts)+
     &           satana(i,j,ntime)*alpha3d(ntime,ntgtp,ntgts)
        tgtpre4d(i,j,ntgtp,ntgts)=tgtpre4d(i,j,ntgtp,ntgts)+
     &           preana(i,j,ntime)*alpha3d(ntime,ntgtp,ntgts)
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
        call pass_4d(tgtpre4d,prdprew34,imt,jmt,npp,nseason)
      endif
      if(ldpen.eq.5) then
        call avg_4d(tgt4d,prdw34,imp,jmp,npp,nseason)
        call avg_4d(tgtsat4d,prdsatw34,imt,jmt,npp,nseason)
        call avg_4d(tgtpre4d,prdprew34,imt,jmt,npp,nseason)
      endif
 999  if(ldpen.eq.6) then
      write(6,*) '999'
        call pass_4d(prdw34,tgt4d,imp,jmp,npp,nseason)
        call pass_4d(prdsatw34,tgtsat4d,imt,jmt,npp,nseason)
        call pass_4d(prdprew34,tgtpre4d,imt,jmt,npp,nseason)
      endif
c
c* spatial corr
      write(6,*) 'spatial corr'
       np=0
       DO is=1,nseason
       DO ip=1,npp
      write(6,*) 'ip=', ip,'is=',is, 'ldpen=',ldpen
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
      write(6,*) 'for sat data'
         do i=1,imt
         do j=1,jmt
           if(ldpen.lt.6) then
           obssat(i,j)=t4d(i,j,ip+ldpen-1,is)
           obspre(i,j)=p4d(i,j,ip+ldpen-1,is)
           endif
           if(ldpen.eq.6) then
           obssat(i,j)=0.5*(t4d(i,j,ip+ldpen-3,is)+
     &t4d(i,j,ip+ldpen-2,is))
           obssatw34(i,j,ip,is)=obssat(i,j)

           obspre(i,j)=0.5*(p4d(i,j,ip+ldpen-3,is)+
     &p4d(i,j,ip+ldpen-2,is))
           obsprew34(i,j,ip,is)=obspre(i,j)
           endif
           prdsat(i,j)=tgtsat4d(i,j,ip,is) !pre prd
           prdpre(i,j)=tgtpre4d(i,j,ip,is) !normalized pre prd
         enddo
         enddo

c* write out prd
c     write(6,*) 'write out prd'
c        write(59+ldpen,rec=np) prd
c        write(49+ldpen,rec=np) prdsat
c
      call rmsd1(obs,prd,imp,jmp,ims,ime,jms,jme,cosl,
     &rms1d(ldpen,is,ip),ac1d(ldpen,is,ip))
c
      call rmsd1(obssat,prdsat,imt,jmt,imts,imte,jmts,jmte,coslsat,
     &rms1dsat(ldpen,is,ip),ac1dsat(ldpen,is,ip))
c     write(6,*) 'after call rmsd1'
       ENDDO
       ENDDO
       write(6,*) 'ldwk=',ldpen,'  number of prd write out=',np
c
c temporal corr for predictor grids
c
      write(6,*) 'temporal corr for predictor'
      do i=1,imp
      do j=1,jmp
        it=1
        do is=1,nseason
        do ip=1,npp
          if(ldpen.lt.6) then
          ts1(it)=fld4d(i,j,ip+ldpen-1,is)
          endif
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
c     write(72,rec=iout) fld2d
      iout=iout+1
c     write(72,rec=iout) wk2d
c
c* temporal corr for sat grids
c
      write(6,*) 'temporal corr for sat'
      do i=1,imt
      do j=1,jmt
        it=1
        do is=1,nseason
        do ip=1,npp
          if(ldpen.lt.6) then
          ts1(it)=t4d(i,j,ip+ldpen-1,is) !raw obs
          endif
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
c     write(82,rec=iout2) t2d
      iout2=iout2+1
c     write(82,rec=iout2) twk2d
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
c          write(71,rec=iwo) tsout
c          write(81,rec=iwo) tsout2
         end do
         do ldpen=1,6
           do ip=1,npp
           tsout(ip)=rms1d(ldpen,is,ip)
           tsout2(ip)=rms1dsat(ldpen,is,ip)
           end do
           iwo=iwo+1
c          write(71,rec=iwo) tsout
c          write(81,rec=iwo) tsout2
         end do
       end do
c
cc statistics(mena and stdv) of wk34 prd & OBS 
c
      write(6,*) 'statistics(mena and stdv) of wk34 prd & OBS'
      do i=1,imt
      do j=1,jmt
        w34avg(i,j)=0.
        obsavg(i,j)=0.
        do is=1,30
        do iw=1,npp
        w34avg(i,j)=w34avg(i,j)+prdprew34(i,j,iw,is)
        obsavg(i,j)=obsavg(i,j)+obsprew34(i,j,iw,is)
        enddo
        enddo
        w34avg(i,j)=w34avg(i,j)/float(npp*30)
        obsavg(i,j)=obsavg(i,j)/float(npp*30)
      enddo
      enddo
c
      do i=1,imt
      do j=1,jmt
        if(abs(p2d(i,j)).lt.100) then
        w34std(i,j)=0.
        obsstd(i,j)=0.
        do is=1,30
        do iw=1,npp
        w34std(i,j)=w34std(i,j)+(prdprew34(i,j,iw,is)-w34avg(i,j))*
     &(prdprew34(i,j,iw,is)-w34avg(i,j))
        obsstd(i,j)=obsstd(i,j)+(obsprew34(i,j,iw,is)-obsavg(i,j))*
     &(obsprew34(i,j,iw,is)-obsavg(i,j))
        enddo
        enddo
        w34std(i,j)=sqrt(w34std(i,j)/float(npp*30))
        obsstd(i,j)=sqrt(obsstd(i,j)/float(npp*30))
        else
        w34std(i,j)=undef2
        obsstd(i,j)=undef2
        endif
      enddo
      enddo
c
      do i=1,imt
      do j=1,jmt
        if(obsstd(i,j).gt.100) then
        obsstd(i,j)=undef2
        w34std(i,j)=undef2
        endif
      enddo
      enddo
c
c trend of obssat and obspre
      do i=1,imt
      do j=1,jmt
      do is=1,nseason
      obssat3d(i,j,is)=0.
      obspre3d(i,j,is)=0.
      do iw=1,npp
      obssat3d(i,j,is)=obssat3d(i,j,is)+obssatw34(i,j,iw,is)/float(npp)
      obspre3d(i,j,is)=obspre3d(i,j,is)+obsprew34(i,j,iw,is)/float(npp)
      enddo
      enddo
      enddo
      enddo
c
      do i=1,imt
      do j=1,jmt
      if(abs(t2d(i,j)).lt.999) then
        do is=1,nseason
        ts4(is)=obssat3d(i,j,is)
        ts6(is)=obspre3d(i,j,is)
        enddo
      call ltrend_1d(ts4,ts5,nseason,1,nseason,aa(i,j),bb(i,j))
      call ltrend_1d(ts6,ts7,nseason,1,nseason,aap(i,j),bbp(i,j))
        do is=1,nseason
        sattrd(i,j,is)=ts5(is)
        pretrd(i,j,is)=ts7(is)
        enddo
      else
        aa(i,j)=t2d(i,j)
        bb(i,j)=t2d(i,j)
        aap(i,j)=t2d(i,j)
        bbp(i,j)=t2d(i,j)
        do is=1,nseason
        sattrd(i,j,is)=t2d(i,j)
        pretrd(i,j,is)=p2d(i,j)
        enddo
      endif
      enddo
      enddo
c
cc OCN of sat
c
c 30-yr clim
      write(6,*) 'OCN'
      do i=1,imt
      do j=1,jmt
        satclm(i,j)=0.
        do is=1,30
        do iw=1,npp
        satclm(i,j)=satclm(i,j)+t4d(i,j,iw,is)
        enddo
        enddo
        satclm(i,j)=satclm(i,j)/float(npp*30)
      enddo
      enddo
c past kocn year avg
      do i=1,imt
      do j=1,jmt
        satocn(i,j)=0.
        do is=1,kocn
        do iw=iws,iwe-4
        satocn(i,j)=satocn(i,j)+allsat(i,j,iw,nyear-is+1)
        enddo
        enddo
        satocn(i,j)=satocn(i,j)/float(npp*kocn)
      enddo
      enddo
c ocn prd(past 8-yr avg minus WMO 30-yr clim)
      do i=1,imt
      do j=1,jmt
        if(abs(t2d(i,j)).lt.999) then
        satocn(i,j)=satocn(i,j)-satclm(i,j)
        else
        satocn(i,j)=t2d(i,j)
        endif
      enddo
      enddo
c amplitude adjusted psi based prd
      write(6,*) 'amplitude adjusted prd'
      do i=1,imt
      do j=1,jmt
        if(abs(t2d(i,j)).lt.999) then
c       prdsat(i,j)=prd2dsatw34(i,j)*obsstd(i,j)/w34std(i,j)
        prdsat(i,j)=prd2dsatw34(i,j)
        prdpre(i,j)=prd2dprew34(i,j)
        else
        prdsat(i,j)=t2d(i,j)
        prdpre(i,j)=t2d(i,j)
        endif
      enddo
      enddo
c combine psi-based prd with ocn
      write(6,*) 'combine psi-based prd with ocn'
      do i=1,imt
      do j=1,jmt
c       twk2d(i,j)=prdsat(i,j)+satocn(i,j)
        twk2d(i,j)=prdsat(i,j)+sattrd(i,j,nseason)
        pwk2d(i,j)=prdpre(i,j)+pretrd(i,j,nseason)
        pwk2d2(i,j)=pwk2d(i,j)/obsstd(i,j)
      enddo
      enddo
c have prob forecast
      xdel=10./float(kpdf)
      call pdf_tab(xbin,ypdf,xdel,kpdf)
c
      do i=1,imt
      do j=1,jmt

        if(abs(obsstd(i,j)).lt.100) then
        call prob(pwk2d2(i,j),kpdf,xbin,xdel,ypdf,pp,pn)
        if(pwk2d2(i,j).gt.0) then 
        prbprd(i,j)=pp
        else
        prbprd(i,j)=-pn
        endif
        else
        prbprd(i,j)=undef2
        endif
      enddo
      enddo
c
      write(87,rec=1) prdsat
      write(87,rec=2) satocn
      write(87,rec=3) twk2d
      write(87,rec=4) prbprd
      write(87,rec=5) bb
      
C
C HSS for hindcast
C
c have 2-class obs and prd
      do is=1,nseason
      do iw=1,npp
      do i=1,imt
      do j=1,jmt
      prdsatw34(i,j,iw,is)=prdsatw34(i,j,iw,is)+sattrd(i,j,is)
      enddo
      enddo
      enddo
      enddo
c
      do i=1,imt
      do j=1,jmt
      if(abs(t2d(i,j)).lt.999) then
        it=0
        do is=1,nseason
        do iw=1,npp
        it=it+1
        if(obssatw34(i,j,iw,is).gt.0) nts4(it)=1
        if(obssatw34(i,j,iw,is).lt.0) nts4(it)=-1
        if(prdsatw34(i,j,iw,is).gt.0) nts5(it)=1
        if(prdsatw34(i,j,iw,is).lt.0) nts5(it)=-1
        enddo
        enddo
        call hss2c_t(nts4,nts5,hs(i,j),npp*27,npp*nseason,npp*nseason)
      else
        hs(i,j)=t2d(i,j)
      endif
      enddo
      enddo
      write(87,rec=6) hs
      write(87,rec=7) fldin2
      write(87,rec=8) obsstd
      write(87,rec=9) w34std
C*********************************************
100    format(9f7.2/9f7.2)
110    format(A2,I2,A6,6f8.2)
      write(6,*) 'end of excution'
 888  continue
1000  continue
c
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
      subroutine changeundef(f1,f2,udf1,udf2,imx,jmx)
      dimension f1(imx,jmx),f2(imx,jmx)
        do i=1,imx
        do j=1,jmx
          f2(i,j)=f1(i,j)
        if(f1(i,j).eq.udf1) then
          f2(i,j)=udef2
        endif
        end do
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

      subroutine pass_2d(wk1,wk2,n1,n2)
      dimension wk1(n1,n2),wk2(n1,n2)
      do j=1,n2
      do i=1,n1
      wk2(i,j)=wk1(i,j)
      enddo
      enddo
      return
      end

      subroutine pass_2d_2_4d(w2d,w4d,n1,n2,n3,n4,ip,is)
      dimension w2d(n1,n2),w4d(n1,n2,n3,n4)
      do j=1,n2
      do i=1,n1
      w4d(i,j,ip,is)=w2d(i,j)
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

      subroutine avg_2d(wk1,wk2,n1,n2)
      dimension wk1(n1,n2),wk2(n1,n2)
      do j=1,n2
      do i=1,n1
      wk2(i,j)=0.5*(wk1(i,j)+wk2(i,j))
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
      if(abs(anom(i,j)).gt.9.e8.or.abs(anomp(i,j)).gt.9.e8) go to 123
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
      SUBROUTINE hpsort(n,n2,ra,rb)
      INTEGER n,n2
      REAL ra(n),rb(n)
      INTEGER i,ir,j,l
      REAL rra
      if (n2.lt.2) return
      l=n2/2+1
      ir=n2
10    continue
        if(l.gt.1)then
          l=l-1
          rra=ra(l)
          rrb=rb(l)
        else
          rra=ra(ir)
          rrb=rb(ir)
          ra(ir)=ra(1)
          rb(ir)=rb(1)
          ir=ir-1
          if(ir.eq.1)then
            ra(1)=rra
            rb(1)=rrb
            return
          endif
        endif
        i=l
        j=l+l
20      if(j.le.ir)then
          if(j.lt.ir)then
            if(ra(j).lt.ra(j+1))j=j+1
          endif
          if(rra.lt.ra(j))then
            ra(i)=ra(j)
            rb(i)=rb(j)
            i=j
            j=j+j
          else
            j=ir+1
          endif
        goto 20
        endif
        ra(i)=rra
        rb(i)=rrb
      goto 10
      END

      FUNCTION ran1(idum)
      INTEGER idum,IA,IM,IQ,IR,NTAB,NDIV
      REAL ran1,AM,EPS,RNMX
      PARAMETER (IA=16807,IM=2147483647,AM=1./IM,IQ=127773,IR=2836,
     *NTAB=32,NDIV=1+(IM-1)/NTAB,EPS=1.2e-7,RNMX=1.-EPS)
      INTEGER j,k,iv(NTAB),iy
      SAVE iv,iy
      DATA iv /NTAB*0/, iy /0/
      if (idum.le.0.or.iy.eq.0) then
        idum=max(-idum,1)
        do 11 j=NTAB+8,1,-1
          k=idum/IQ
          idum=IA*(idum-k*IQ)-IR*k
          if (idum.lt.0) idum=idum+IM
          if (j.le.NTAB) iv(j)=idum
11      continue
        iy=iv(1)
      endif
      k=idum/IQ
      idum=IA*(idum-k*IQ)-IR*k
      if (idum.lt.0) idum=idum+IM
      j=1+iy/NDIV
      iy=iv(j)
      iv(j)=idum
      ran1=min(AM*iy,RNMX)
      return
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  calculate normal distribution PDF from -5 to 5 (unit=std)
C  have it as a table for later integration
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine pdf_tab(xx,yy,xde,n)
      real xx(n),yy(n)
      pi=3.14159
      coef=1./sqrt(2*pi)
      xde=0.1
      xx(1)=-5+xde/2
      do i=2,n
      xx(i)= xx(i-1)+xde
      enddo
      do i=1,n
      yy(i)=coef*exp(-xx(i)*xx(i)/2)
      enddo
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  Have prob by integratinge PDF
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine prob(x1,n,xx,xde,yy,pp,pn)
      real xx(n),yy(n)
      if(x1.gt.0) then
      x2=0-x1
      else
      x2=abs(x1)
      endif
      pn=0
      do i=1,n
      if(xx(i).gt.x2) go to 111
      pn=pn+xde*yy(i)
      enddo
  111 continue
      pp=1-pn
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  using least square to have y=a+bx
C  here xin=3-mon avg, xin2=weekly data
C  out=detrended xin2, out2=trend
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine ltrend_1d(xin,out,nt,its,ite,a,b)
      dimension xin(nt),out(nt)
      real lxx, lxy
c
      xb=0
      yb=0
      do it=its,ite
        xb=xb+float(it)/float(ite-its+1)
        yb=yb+xin(it)/float(ite-its+1)
      enddo
c
      lxx=0.
      lxy=0.
      do it=its,ite
      lxx=lxx+(it-xb)*(it-xb)
      lxy=lxy+(it-xb)*(xin(it)-yb)
      enddo
      b=lxy/lxx
      a=yb-b*xb
c
      do it=its,ite
        out(it)=b*float(it)+a !trend
      enddo
c
      return
      end
c 13-wk avg
      subroutine wkavg(wk,nyr,ime,im,jm,avg,ip,iy)
      dimension wk(im,jm,ime,nyr),avg(im,jm)
c
      do i=1,im
      do j=1,jm
      avg(i,j)=0.
      do ik=1,13
      avg(i,j)=avg(i,j)+wk(i,j,ip-1+ik,iy)/13.
      enddo
      enddo
      enddo

      return
      end
      subroutine hss2c(mask,mw1,mw2,coslat,hs,ntot,m,n)
      dimension mask(m,n),mw1(m,n),mw2(m,n),coslat(n)

      h=0.
      tot=0.
      ntot=0
      do i=1,m
      do j=1,n
      IF(mask(i,j).eq.1) then
c     IF(abs(mw2(i,j)).ne.9999) then
      tot=tot+coslat(j)
      ntot=ntot+1
      if (mw1(i,j).ne.9) then
      if (mw1(i,j).eq.mw2(i,j)) h=h+coslat(j)
      else
        h=h+coslat(j)/3.
      end if
      END IF
      enddo
      enddo
      hs=(h-tot/3.)/(tot-tot/3.)*100.
c     write(6,*) 'h=',h,'tot=',tot,'hs=',hs
      return
      end

      subroutine hss2c_t(mw1,mw2,hs,its,ite,n)
      dimension mw1(n),mw2(n)

      h=0.
      tot=0.
      do i=its,ite
      tot=tot+1
      if (mw1(i).eq.mw2(i)) h=h+1
      enddo
      hs=(h-tot/2.)/(tot-tot/2.)*100.
      return
      end

