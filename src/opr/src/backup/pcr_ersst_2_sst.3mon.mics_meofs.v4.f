      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C PCR for forecst TPZ
C===========================================================
      parameter(kpdf=1000)

      real fld0(imx,jmx),fld(imx,jmx)
      real sst(imx,jmx,nyr,mics)
      real v1dtd(imx,jmx,nyr,mics),v1trd(imx,jmx,nyr)
      real av1(imx,jmx),bv1(imx,jmx)
      real sstc(imx,jmx),tpzc(imx,jmx)
      real fld2(imx,jmx)
      real corr(imx,jmx,nyr),regr(imx,jmx,nyr)
      real corr2(imx,jmx,nyr),regr2(imx,jmx,nyr,nyr)
      real corr3(imx,jmx,nyr),regr3(imx,jmx,nyr)
      real cor3d(imx,jmx,nlead),rms3d(imx,jmx,nlead)
      real hss3d(imx,jmx,nlead)
      real ts1(nyr),ts2(nyr)
      real ts3(nyr),ts4(nyr)
      real w2d(imx,jmx),w2d2(imx,jmx),w2d3(imx,jmx)
      real w2d4(imx,jmx),w2d5(imx,jmx),w2d6(imx,jmx)
      real tcof(nyr,nyr,mics)
      real tpz(imx,jmx,montot),wtpz(imx,jmx,nyr)
      real av2(imx,jmx),bv2(imx,jmx)
      real hcst(imx,jmx,nyr,nlead,mics,ncut)
      real wthcst(imx,jmx,nyr,nlead)
      real obs(imx,jmx,nyr)
      real w3d(imx,jmx,nyr)
      real fcst(imx,jmx,nlead,mics,ncut)
      real stdo(imx,jmx,nwmo,nlead),stdf(imx,jmx)
      real clmo(imx,jmx,nwmo,nlead),clmf(imx,jmx)
      real wtfcst(imx,jmx,nlead)
      real vfld(imx,jmx,nyr,nlead)
      real v3c(imx,jmx,nyr) ! obs in 3C
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real on34(nyr),fn34(nyr)
      real w1d(nwmo),w1d2(nwmo)
      dimension neof(mcut)
      data neof/icut1,icut2,icut3,icut4/
c      
      real xbin(kpdf),ypdf(kpdf),prbprd(imx,jmx)
      real pa(imx,jmx,nyr),pb(imx,jmx,nyr),pn(imx,jmx,nyr)
      real xpa(imx,jmx),xpb(imx,jmx),xpn(imx,jmx)

      real avg_o(imx,jmx),std_o(imx,jmx)
      real avg_f(imx,jmx),std_f(imx,jmx)
      real rpss(imx,jmx),frac(imx,jmx)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !sst
      open(11,form='unformatted',access='direct',recl=4*imx*jmx) !frac

      open(20,form='unformatted',access='direct',recl=4) !pc
      open(21,form='unformatted',access='direct',recl=4*imx*jmx) !eof
      open(22,form='unformatted',access='direct',recl=4) !hcst/fcst nino34
      open(23,form='unformatted',access='direct',recl=4) !obs nino34

      open(30,form='unformatted',access='direct',recl=4*imx*jmx) !fcst
      open(31,form='unformatted',access='direct',recl=4) !1d_skill
      open(32,form='unformatted',access='direct',recl=4*imx*jmx) !hcst

      open(40,form='unformatted',access='direct',recl=4*imx*jmx) !sst ICs
C
C== have coslat
C
      do j=1,jmx
        if(jmx.eq.180) then
          xlat(j)=-89.5+(j-1)*1.
        else
          xlat(j)=-88+(j-1)*2.
        endif
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use
        cosr(j)=sqrt(coslat(j))
      enddo
C
      xdel=10./float(kpdf)
      call pdf_tab_general(1.,0.,xbin,ypdf,xdel,kpdf)

C=== read in all 3-mon avg sst
      do it=1,nsstot ! nsstot=montot-2
        read(10,rec=it) fld2
        do i=1,imx
        do j=1,jmx
          tpz(i,j,it)=fld2(i,j) ! use tpz array for sst
        enddo
        enddo
      enddo
C
C============ have sst of mics
c
      DO ic=1,mics ! # of non-overlapping 3-mon or months 

      its_sst=icmon+lagmax-2-(ic-1)*3 !for 3-mon data,+lagmax to avoid < 0

      ir=0
c     do it=its_sst,montot,12
      do it=its_sst,nsstot,12
      write(6,*) 'it=',it
        read(10,rec=it) fld
        ir=ir+1
        do i=1,imx
        do j=1,jmx
          sst(i,j,ir,ic)=fld(i,j)
        enddo
        enddo
      enddo
      ny_sst=ir
      write(6,*) 'its_sst==',its_sst,'ny_sst==',ny_sst

      ic_fcst=ny_sst
C
C have sst anomalies over period 1 -> ny_sst
      do i=1,imx
      do j=1,jmx
        if(fld(i,j).gt.-900.) then
          do it=1,ny_sst
            ts1(it)=sst(i,j,it,ic)
          enddo
          call clim_anom(ts1,sstc(i,j),nyr,ny_sst)
        else
          do it=1,ny_sst
            ts1(it)=undef
          enddo
            sstc(i,j)=undef
        endif
          do it=1,ny_sst
            sst(i,j,it,ic)=ts1(it)
          enddo
      enddo
      enddo
c write out sst_IC
      do i=1,imx
      do j=1,jmx
        fld(i,j)=sst(i,j,ny_sst,ic)
      enddo
      enddo
      write(40,rec=ic) fld

      ENDDO ! ic loop
c
c SST EOF analysis
c
      DO ic=1,mics

      do m=1,modmax
      do it=1,nyr
        tcof(m,it,ic)=undef
      enddo
      enddo

      enddo ! ic loop
C
      call pc_eof_mics(sst,imx,jmx,lons,lone,lats,late,nyr,
     &ny_sst,cosr,ngrd,modmax,tcof,corr,regr,undef,id,mics,id_ceof)

C write out EOF patters
      do m=1,5
        do i=1,imx
        do j=1,jmx
        fld(i,j)=regr(i,j,m)
        enddo
        enddo
        write(21,rec=m) fld
      enddo
C write out tcof
      iw=0
      do it=1,ny_sst
      do m=1,5
         iw=iw+1
         write(20,rec=iw) tcof(m,it,1)
      enddo
      enddo
c
c tpz hindcast for ld=1->nlead
      iw5=0
      DO ld=1,nlead

c select tpz for each lead
c     its_tpz=icmon+lagmax+ld+1 !11+1+1=13(jfm)
      its_tpz=icmon+lagmax+ld   !11+1=12(djf)
      ir=0
      do it=its_tpz,nsstot,12
        ir=ir+1
        do i=1,imx
        do j=1,jmx
          wtpz(i,j,ir)=tpz(i,j,it)
        enddo
        enddo
      enddo
      ny_tpz=ir
      write(6,*) 'its_tpz=',its_tpz,'ny_tpz=',ny_tpz
C 
C CV hcst for this lead
c     nfld=ny_tpz - 1
c     if(ncv.eq.3) nfld=ny_tpz - 3
c
      DO ic=1,mics

      DO itgt=1,ny_tpz

        iym=itgt-1
        iyp=itgt+1
        if(itgt.eq.1) iym=3
        if(itgt.eq.ny_tpz) iyp=ny_tpz-2

      DO m=1,modmax

        ir=0
        do iy=1,ny_tpz

          if(iy.eq.itgt) go to 555

          if(ncv.eq.3) then
            if(iy.eq.iym)  go to 555
            if(iy.eq.iyp)  go to 555
          endif

            ir=ir+1
            ts1(ir)=tcof(m,iy,ic)
  555   continue
        enddo
          
        do i=1,imx
        do j=1,jmx

        IF(fld2(i,j).gt.-900.) then

          ir=0
          do iy=1,ny_tpz

          if(iy.eq.itgt) go to 666

          if(ncv.eq.3) then
            if(iy.eq.iym)  go to 666
            if(iy.eq.iyp)  go to 666
          endif

            ir=ir+1
            ts2(ir)=wtpz(i,j,iy)
  666     continue
          enddo

          nfld=ir
          call regr_t(ts1,ts2,nyr,nfld,corr2(i,j,m),
     &    regr2(i,j,m,itgt))

        ELSE

          corr2(i,j,m)=undef
          regr2(i,j,m,itgt)=undef

        ENDIF

        enddo
        enddo
      enddo ! m loop
c
c have lead-ld hcst for itgt yr with sst tcof and tpz regr
      do mc=1,ncut
      call setzero(w2d,imx,jmx)
      do i=1,imx
      do j=1,jmx
        if(fld2(i,j).gt.-900.) then
          do m=1,neof(mc)
            w2d(i,j)=w2d(i,j)+tcof(m,itgt,ic)*regr2(i,j,m,itgt)
          enddo
            w2d2(i,j)=wtpz(i,j,itgt)
        else
            w2d(i,j)=undef
            w2d2(i,j)=undef
        endif

        hcst(i,j,itgt,ld,ic,mc)=w2d(i,j)

        vfld(i,j,itgt,ld)=w2d2(i,j)

      enddo
      enddo

      enddo ! mc loop

      ENDDO ! itgt loop
c
C========== realtime fcst
c
c have regr patterns
      DO m=1,modmax

        do iy=1,ny_tpz
            ts1(iy)=tcof(m,iy,ic)
        enddo
          
        do i=1,imx
        do j=1,jmx

        IF(fld2(i,j).gt.-900.) then

          do iy=1,ny_tpz
            ts2(iy)=wtpz(i,j,iy)
          enddo

          call regr_t(ts1,ts2,nyr,ny_tpz,corr3(i,j,m),regr3(i,j,m))

        ELSE

          corr3(i,j,m)=undef
          regr3(i,j,m)=undef

        ENDIF

        enddo
        enddo
      enddo ! m loop
c
c fcst
      do mc=1,ncut

      call setzero(w2d,imx,jmx)
      do i=1,imx
      do j=1,jmx
        if(fld2(i,j).gt.-900.) then

          do m=1,neof(mc)
            w2d(i,j)=w2d(i,j)+tcof(m,ic_fcst,ic)*regr3(i,j,m)
          enddo

        else
            w2d(i,j)=undef
        endif

        fcst(i,j,ld,ic,mc)=w2d(i,j)

      enddo
      enddo

      enddo ! mc loop

      ENDDO ! ic loop

      ENDDO ! ld loop
c
c  hcst and fcst
      DO ld=1,nlead ! lead of weighted hcst/fcst

C== have wthcst
      do it=1,ny_tpz
        do i=1,imx
        do j=1,jmx
          if(fld2(i,j).gt.-900.) then
            w2d2(i,j)=vfld(i,j,it,ld)

            w2d(i,j)=0.
            do ic=1,mics
            do mc=1,ncut
            w2d(i,j)=w2d(i,j)+hcst(i,j,it,ld,ic,mc)/float(mics*ncut)
            enddo
            enddo

          else
            w2d(i,j)=undef
          endif
          wthcst(i,j,it,ld)=w2d(i,j)
        enddo
        enddo

      enddo !it loop
c
C== have wtfcst
        do i=1,imx
        do j=1,jmx

          if(fld2(i,j).gt.-900.) then

          w2d(i,j)=0.
          do ic=1,mics
          do mc=1,ncut
          w2d(i,j)=w2d(i,j)+fcst(i,j,ld,ic,mc)/float(mics*ncut)
          enddo
          enddo

          else
            w2d(i,j)=undef
          endif
            wtfcst(i,j,ld)=w2d(i,j)
        enddo
        enddo

      enddo ! ld loop
C
c normalize both obs and wthcst
c
c std clm of obs
      iw=0
      iw2=0
      iw4=0
      DO ld=1,nlead

        do i=1,imx
        do j=1,jmx
          if (fld2(i,j).gt.-900.) then

            do it=1,ny_tpz
              ts1(it)=vfld(i,j,it,ld)
            enddo

            call wmo_clm_std_anom(ts1,w1d,w1d2,ts4,nyr,ny_tpz,nwmo)

            do ii=1,nwmo
              stdo(i,j,ii,ld)=w1d(ii)
              clmo(i,j,ii,ld)=w1d2(ii)
            enddo

            do it=1,ny_tpz
              vfld(i,j,it,ld)=ts4(it)
            enddo

          else

            do ii=1,nwmo
              stdo(i,j,ii,ld)=undef
              clmo(i,j,ii,ld)=undef
            enddo

            do it=1,ny_tpz
              vfld(i,j,it,ld)=undef
            enddo

          endif
        enddo
        enddo

c std clm of wthcst
        do i=1,imx
        do j=1,jmx
          if (fld2(i,j).gt.-900.) then

            do it=1,ny_tpz
              ts1(it)=wthcst(i,j,it,ld)
            enddo

            call wmo_clm_std_anom(ts1,w1d,w1d2,ts4,nyr,ny_tpz,nwmo)

            stdf(i,j)=w1d(nwmo)
            clmf(i,j)=w1d2(nwmo)

            do it=1,ny_tpz
              wthcst(i,j,it,ld)=ts4(it)
            enddo

          else

            do it=1,ny_tpz
              wthcst(i,j,it,ld)=undef
            enddo

            stdf(i,j)=undef
            clmf(i,j)=undef

          endif
       enddo
       enddo

C nino3.4 of hcst
      do it=its_hcst,ny_tpz
        do i=1,imx
        do j=1,jmx
          fld0(i,j)=vfld(i,j,it,ld)
          fld(i,j)=wthcst(i,j,it,ld)
        enddo
        enddo
        call nino34(fld0,on34(it),imx,jmx)
        call nino34(fld, fn34(it),imx,jmx)
      enddo
        
      do it=its_hcst,ny_tpz
        iw=iw+1
        write(22,rec=iw) fn34(it)
        iw2=iw2+1
        write(23,rec=iw2) on34(it)
      enddo
c
c
c standardized fcsts
      do i=1,imx
      do j=1,jmx
      if (fld2(i,j).gt.-900.) then
        wtfcst(i,j,ld)=(wtfcst(i,j,ld)-clmf(i,j))/stdf(i,j)
      else
        wtfcst(i,j,ld)=undef
      endif
      enddo
      enddo

C nino3.4 of fcst
        do i=1,imx
        do j=1,jmx
          fld(i,j)=wtfcst(i,j,ld)
        enddo
        enddo
        call nino34(fld,xn34,imx,jmx)
        iw=iw+1
        write(22,rec=iw) xn34

      enddo ! ld loop
c
c== temporal skill
      ny_skill=ny_tpz-its_skill+1
      DO ld=1,nlead

      DO i=1,imx
      DO j=1,jmx
c
      if(fld2(i,j).gt.-900.) then
        ir=0
        do it=its_skill,ny_tpz

        ir=ir+1
          ts1(ir)=vfld(i,j,it,ld)
          ts2(ir)=wthcst(i,j,it,ld)
        enddo
        call cor_rms(ts1,ts2,nyr,ny_skill,cor3d(i,j,ld),rms3d(i,j,ld))

        call hss3c_t(ts1,ts2,nyr,ny_skill,hss3d(i,j,ld))
      else
        cor3d(i,j,ld)=undef
        rms3d(i,j,ld)=undef
        hss3d(i,j,ld)=undef
      endif
      enddo
      enddo

      enddo ! ld loop
c
c== spatial skill
      iw=0
      do ld=1,nlead
      do iy=its_skill,ny_tpz

        do i=1,imx
        do j=1,jmx
          w2d(i,j)=vfld(i,j,iy,ld)
          w2d2(i,j)=wthcst(i,j,iy,ld)
        enddo
        enddo

      call sp_cor_rms(w2d,w2d2,coslat,imx,jmx,
     &1,360,35,55,xcor,xrms)

      iw=iw+1
      write(31,rec=iw) xcor
      iw=iw+1
      write(31,rec=iw) xrms

      call sp_cor_rms(w2d,w2d2,coslat,imx,jmx,
     &1,360,56,75,xcor,xrms)
      iw=iw+1
      write(31,rec=iw) xcor
      iw=iw+1
      write(31,rec=iw) xrms

      call hss3c_s(w2d,w2d2,imx,jmx,1,360,35,55,coslat,h1)
      call hss3c_s(w2d,w2d2,imx,jmx,1,360,56,75,coslat,h2)

      iw=iw+1
      write(31,rec=iw) h1
      iw=iw+1
      write(31,rec=iw) h2

      enddo ! iy loop
      enddo ! ld loop
c
c write out obs and wthcst
        iw=0
        do ld=1,nlead
        do it=its_hcst,ny_tpz

          do i=1,imx
          do j=1,jmx
            w2d(i,j)=vfld(i,j,it,ld)
          enddo
          enddo
          iw=iw+1
          write(32,rec=iw) w2d

          do i=1,imx
          do j=1,jmx
            w2d2(i,j)=wthcst(i,j,it,ld)
          enddo
          enddo
          iw=iw+1
          write(32,rec=iw) w2d2

c prob-hcst
        do i=1,imx
        do j=1,jmx
         
          if (w2d(i,j).gt.-900.and.w2d2(i,j).gt.-900) then

          call prob_3c_prd(w2d2(i,j),prbprd(i,j),
c    &pa(i,j,it),pb(i,j,it),pn(i,j,it),kpdf,xbin,xdel,ypdf,frac(i,j))
     &pa(i,j,it),pb(i,j,it),pn(i,j,it),kpdf,xbin,xdel,ypdf,1.)

        else

          prbprd(i,j)=undef

          pa(i,j,it)=undef
          pb(i,j,it)=undef
          pn(i,j,it)=undef

        endif

        if(abs(prbprd(i,j)).gt.1.) prbprd(i,j)=undef

        w2d3(i,j)=pa(i,j,it)
        w2d4(i,j)=pb(i,j,it)

       enddo
       enddo

       iw=iw+1
       write(32,rec=iw) prbprd
       iw=iw+1
       write(32,rec=iw) w2d3
       iw=iw+1
       write(32,rec=iw) w2d4

       call have_iwmo(it,nwmo,iwmo)
       write(6,*) 'iwmo=',iwmo

       do i=1,imx
       do j=1,jmx
         w2d(i,j)=stdo(i,j,iwmo,ld)
       enddo
       enddo
       iw=iw+1
       write(32,rec=iw) w2d

       enddo ! it loop
       enddo ! ld loopo
c
c write out fcst and skill_t
        iw=0
       do ld=1,nlead

         do i=1,imx
         do j=1,jmx
           w2d(i,j)=wtfcst(i,j,ld)
           w2d2(i,j)=stdo(i,j,nwmo,ld)
           w2d3(i,j)=cor3d(i,j,ld)
           w2d4(i,j)=rms3d(i,j,ld)
           w2d5(i,j)=hss3d(i,j,ld)
           w2d6(i,j)=clmo(i,j,nwmo,ld)
         enddo
         enddo

         iw=iw+1
         write(30,rec=iw) w2d
         iw=iw+1
         write(30,rec=iw) w2d2
         iw=iw+1
         write(30,rec=iw) w2d3
         iw=iw+1
         write(30,rec=iw) w2d4
         iw=iw+1
         write(30,rec=iw) w2d5
         iw=iw+1
         write(30,rec=iw) w2d6

c prob forecast
c
      do i=1,imx
      do j=1,jmx

      if (w2d(i,j).gt.-900.) then

        call prob_3c_prd(w2d(i,j),prbprd(i,j),
c    &xpa(i,j),xpb(i,j),xpn(i,j),kpdf,xbin,xdel,ypdf,frac(i,j))
     &xpa(i,j),xpb(i,j),xpn(i,j),kpdf,xbin,xdel,ypdf,1.)

      else

        prbprd(i,j)=undef
        xpa(i,j)=undef
        xpb(i,j)=undef
        xpn(i,j)=undef

      endif

      if (abs(xpa(i,j)).gt.1.or.abs(xpb(i,j)).gt.1) then
        prbprd(i,j)=undef
        xpa(i,j)=undef
        xpb(i,j)=undef
        xpn(i,j)=undef
      endif

      enddo
      enddo
c
      iw=iw+1
      write(30,rec=iw) prbprd
      iw=iw+1
      write(30,rec=iw) xpa
      iw=iw+1
      write(30,rec=iw) xpb
      iw=iw+1
      write(30,rec=iw) xpn

      do it=its_hcst,ny_tpz
        do i=1,imx
        do j=1,jmx
          obs(i,j,it)=vfld(i,j,it,ld)
        enddo
        enddo
      enddo

      call rpss_t(obs,pb,pa,w2d,v3c,imx,jmx,its_skill,ny_tpz,nyr,undef)

      iw=iw+1
      write(30,rec=iw) w2d

      enddo ! ld loop
c
      stop
      end

      SUBROUTINE have_iwmo(it,nwmo,iwmo)

      iwmo=1 ! for it < 33

      do id=1,nwmo-1
        its=30+(id-1)*10+2 ! +2 is for skip 1949-1950
        ite=30+id*10+1
        if(it.ge.its.and.it.le.ite) iwmo=id
      enddo

      its=30+(nwmo-1)*10+2
      if(it.ge.its) iwmo=nwmo

      return
      end

      SUBROUTINE wmo_clm_std_anom(ts,std,clm,anom,maxt,nt,nwmo)
C WMO std, clm, and anom

      DIMENSION ts(maxt),anom(maxt),std(nwmo),clm(nwmo)

C have WMO std and clm
      do id=1,nwmo ! 51-80,61-90,71-00,81-10,91-20

      its=(id-1)*10+1+1 ! +1 for skiping 1950
      ite=(id-1)*10+30+1 ! +1 for skip 1950

      cc=0.
      do i=its,ite
        cc=cc+ts(i)
      enddo
      clm(id)=cc/30.
c
      do i=its,ite
        anom(i)=ts(i)-clm(id)
      enddo

      sd=0
      do i=its,ite
        sd=sd+anom(i)*anom(i)
      enddo
      sd=sqrt(sd/30.)
      if(sd.lt.0.01) sd=0.01
      std(id)=sd

      enddo !loop id

C have WMO anom
      do i=1,31 ! i=1 is 1950
        anom(i)=(ts(i)-clm(1))/std(1)
      enddo

      do id=1,nwmo-1 ! 81-90,91-00,01-10,11-20,21-cur
        its=30+(id-1)*10+1+1 ! +1 is for 1950
        ite=30+id*10+1
        do i=its,ite
          anom(i)=(ts(i)-clm(id))/std(id)
        enddo
      enddo

      its=30+(nwmo-1)*10+1+1 ! +1 is for 1950
      ite=nt

      if(ite.ge.its) then
      do i=its,ite
        anom(i)=(ts(i)-clm(nwmo))/std(nwmo)
      enddo
      endif

      return
      end

      SUBROUTINE hss3c_t(obs,prd,ny,nt,hs)
      dimension obs(ny),prd(ny)
      dimension nobs(ny),nprd(ny)
      do it=1,nt
        if(obs(it).gt.0.43) nobs(it)=1
        if(obs(it).lt.-0.43) nobs(it)=-1
        if(obs(it).ge.-0.43.and.obs(it).le.0.43) nobs(it)=0

        if(prd(it).gt.0.43) nprd(it)=1
        if(prd(it).lt.-0.43) nprd(it)=-1
        if(prd(it).ge.-0.43.and.prd(it).le.0.43) nprd(it)=0
      enddo
      h=0.
      tot=0.
      do i=1,nt
      tot=tot+1
      if (nobs(i).eq.nprd(i)) h=h+1
      enddo
      hs=(h-tot/3.)/(tot-tot/3.)*100.
      return
      end

      SUBROUTINE hss3c_s(obs,prd,imx,jmx,is,ie,js,je,coslat,h)
      dimension obs(imx,jmx),prd(imx,jmx)
      dimension nobs(imx,jmx),nprd(imx,jmx)
      dimension coslat(jmx)

      do i=is,ie
      do j=js,je
        if(obs(i,j).gt.-900.and.prd(i,j).gt.-900) then

          if(obs(i,j).gt.0.43) nobs(i,j)=1
          if(obs(i,j).lt.-0.43) nobs(i,j)=-1
          if(obs(i,j).ge.-0.43.and.obs(i,j).le.0.43) nobs(i,j)=0

          if(prd(i,j).gt.0.43) nprd(i,j)=1
          if(prd(i,j).lt.-0.43) nprd(i,j)=-1
          if(prd(i,j).ge.-0.43.and.prd(i,j).le.0.43) nprd(i,j)=0

        endif
      enddo
      enddo

      h=0.
      tot=0.
      do i=is,ie
      do j=js,je
        if(obs(i,j).gt.-900..and.prd(i,j).gt.-900.) then
        tot=tot+coslat(j)
        if (nobs(i,j).eq.nprd(i,j)) h=h+coslat(j)
        endif
      enddo
      enddo
      h=(h-tot/3.)/(tot-tot/3.)*100.

      return
      end

      SUBROUTINE ac_rms(f1,f2,nt,ltime,cor,rms)

      real f1(nt),f2(nt)

      av1=0.
      av2=0.
      do it=1,ltime
        av1=av1+f1(it)/float(ltime)
        av2=av2+f2(it)/float(ltime)
      enddo

      cor=0.
      sd1=0.
      sd2=0.
      rms=0.

      do it=1,ltime
         cor=cor+(f1(it)-av1)*(f2(it)-av2)/float(ltime)
         sd1=sd1+(f1(it)-av1)**2/float(ltime)
         sd2=sd2+(f2(it)-av2)**2/float(ltime)
         rms=rms+(f1(it)-f2(it))**2/float(ltime)
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      reg=cor/(sd1)
      cor=cor/(sd1*sd2)
      rms=sqrt(rms)

      return
      end

      SUBROUTINE cor_rms(f1,f2,nt,ltime,cor,rms)

      real f1(nt),f2(nt)

      av1=0.
      av2=0.
      do it=1,ltime
c       av1=av1+f1(it)/float(ltime)
c       av2=av2+f2(it)/float(ltime)
      enddo

      cor=0.
      sd1=0.
      sd2=0.
      rms=0.

      do it=1,ltime
         cor=cor+(f1(it)-av1)*(f2(it)-av2)/float(ltime)
         sd1=sd1+(f1(it)-av1)**2/float(ltime)
         sd2=sd2+(f2(it)-av2)**2/float(ltime)
         rms=rms+(f1(it)-f2(it))**2/float(ltime)
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      reg=cor/(sd1)
      cor=cor/(sd1*sd2)
      rms=sqrt(rms)

      return
      end

      SUBROUTINE sp_proj(w2d,regr,imx,jmx,modmax,is,ie,js,je,cosl,
     &undef,pj)
      real w2d(imx,jmx),regr(imx,jmx,modmax),cosl(jmx),pj(modmax)
c
      do m=1,modmax

      x=0.
      y=0.
      do i=is,ie
      do j=js,je
      if(w2d(i,j).gt.undef) then
      x=x+regr(i,j,m)*w2d(i,j)*cosl(j)
      y=y+regr(i,j,m)*regr(i,j,m)*cosl(j)
      endif
      enddo
      enddo

      pj(m)=x/y
      enddo !m loop
c     write(6,*)'pj=', pj
c
      return
      end

      SUBROUTINE pc_eof_mics(wf3d,imx,jmx,is,ie,ls,le,ltime,nfld,cosr,
     &ngrd,modmax,tcof,corr,regr,undef,id,mics,id_ceof)

      real wf3d(imx,jmx,ltime,mics),tcof(ltime,ltime,mics)
      real f3d(imx,jmx,nfld,mics),cosr(jmx)
      real aaa(ngrd*mics,nfld),wk(nfld,ngrd)
      real eval(nfld*mics),evec(ngrd*mics,nfld),coef(nfld,nfld)
      real ts1(nfld),ts2(nfld)
      real corr(imx,jmx,modmax),regr(imx,jmx,modmax)
c
      do ic=1,mics

      do it=1,nfld

      if(id_ceof.eq.0) then
        ng=0
        do j=ls,le
        do i=is,ie
        if(wf3d(i,j,1,1).gt.undef) then
          ng=ng+1
          aaa(ng,it)=wf3d(i,j,it,ic)*cosr(j)
        endif
        enddo
        enddo
      else
        ng=0
      do ii=1,ic
        do j=ls,le
        do i=is,ie
        if(wf3d(i,j,1,1).gt.undef) then
          ng=ng+1
          aaa(ng,it)=wf3d(i,j,it,ii)*cosr(j)
        endif
        enddo
        enddo
        enddo ! ii loop
      endif

      enddo ! it loop

      write(6,*) 'ic=',ic,' ngrd= ',ng
c
      call eofs_mics(aaa,ngrd*mics,ng,nfld,coef,modmax,id)
c
c normalize coef
      do m=1, modmax
      do it=1,nfld
        ts1(it)=coef(m,it)
      enddo
c
      call normal(ts1,ts2,nfld)
c
      do it=1,nfld
        tcof(m,it,ic)=ts2(it)
      enddo
      enddo ! m loop

      enddo ! ic loop

c regr patterns

      do m=1,modmax
c
      do it=1,nfld
        ts1(it)=tcof(m,it,1)
      enddo
c
      do j=1,jmx
      do i=1,imx

      if(wf3d(i,j,1,1).gt.undef) then

      do it=1,nfld
        ts2(it)=wf3d(i,j,it,1)
      enddo

      call regr_t(ts1,ts2,nfld,nfld,corr(i,j,m),regr(i,j,m))
      else
      corr(i,j,m)=undef
      regr(i,j,m)=undef
      endif

      enddo
      enddo

      enddo !m loop
c
      return
      end

      SUBROUTINE eofs_mics(aaa,ngbig,ng,nfld,coef,modmax,id)
      real aaa(ngbig,nfld),wk(nfld,ng)
      real bbb(ng,nfld)
      real eval(nfld),evec(ng,nfld),coef(nfld,nfld)

      do k=1,nfld
      do i=1,ng
        bbb(i,k)=aaa(i,k)
      enddo
      enddo

      call eofs(bbb,ng,nfld,nfld,eval,evec,coef,wk,id)

cc... write out eval
      totv=0
      do m=1,modmax
      write(6,*)'eval= ',m,eval(m)
      totv=totv+eval(m)
      end do
      write(6,*)'modmax=',modmax,'totv= ',totv

      return
      end
c

      SUBROUTINE setzero(fld,n,m)
      DIMENSION fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end

      SUBROUTINE setzero_3d(fld,n,m,kk)
      DIMENSION fld(n,m,kk)
      do i=1,n
      do j=1,m
      do k=1,kk
         fld(i,j,k)=0.0
      enddo
      enddo
      enddo
      return
      end


      SUBROUTINE nino34(sst,xn34,imx,jmx)
      DIMENSION sst(imx,jmx)
        xn34=0
        ngrd=0
        do i=96,121
        do j=42,48
          xn34=xn34+sst(i,j)
          ngrd=ngrd+1
        enddo
        enddo
        xn34=xn34/float(ngrd)
      return
      end
c
      SUBROUTINE clim_anom(ts,cc,maxt,nt)
      DIMENSION ts(maxt)
      cc=0.
      do i=1,nt
         cc=cc+ts(i)
      enddo
      cc=cc/float(nt)
c  
      do i=1,nt
        ts(i)=ts(i)-cc
      enddo
c
      return
      end

      SUBROUTINE clim_tot(ts,cc,maxt,its,ite)
      DIMENSION ts(maxt)
      cc=0.
      do i=its,ite
         cc=cc+ts(i)
      enddo
      nt=ite-its+1
      cc=cc/float(nt)
c  
      return
      end


      SUBROUTINE normal(rot,rot2,ltime)
      DIMENSION rot(ltime),rot2(ltime)
      avg=0.
      do i=1,ltime
         avg=avg+rot(i)/float(ltime)
      enddo
      do i=1,ltime
        rot2(i)=rot(i)-avg
      enddo
c
      sd=0.
      do i=1,ltime
        sd=sd+rot2(i)*rot2(i)/float(ltime)
      enddo
        sd=sqrt(sd)
      do i=1,ltime
        rot2(i)=rot2(i)/sd
      enddo
      return
      end

      SUBROUTINE regr_t(f1,f2,ltime,nt,cor,reg)

      real f1(ltime),f2(ltime)

      av1=0.
      av2=0.
      do it=1,nt
        av1=av1+f1(it)/float(nt)
        av2=av2+f2(it)/float(nt)
      enddo

      cor=0.
      sd1=0.
      sd2=0.

      do it=1,nt
         cor=cor+(f1(it)-av1)*(f2(it)-av2)/float(nt)
         sd1=sd1+(f1(it)-av1)*(f1(it)-av1)/float(nt)
         sd2=sd2+(f2(it)-av2)*(f2(it)-av2)/float(nt)
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      reg=cor/(sd1)
      cor=cor/(sd1*sd2)

      return
      end


      SUBROUTINE area_avg(fld,coslat,imx,jmx,is,ie,js,je,out)

      real fld(imx,jmx),coslat(jmx)

      area=0
      do j=js,je
      do i=is,ie
        area=area+coslat(j)
      enddo
      enddo
c     write(6,*) 'area2=',area

      out=0.
      do j=js,je
      do i=is,ie
        out=out+fld(i,j)*coslat(j)/area

      enddo
      enddo

      return
      end

      SUBROUTINE sp_cor_rms(fld1,fld2,coslat,imx,jmx,
     &lon1,lon2,lat1,lat2,cor,rms)

      real fld1(imx,jmx),fld2(imx,jmx),coslat(jmx)

      area=0.
      do j=lat1,lat2
      do i=lon1,lon2
        if(fld1(i,j).gt.-900..and.fld2(i,j).gt.-900.) then
          area=area+coslat(j)
        endif
      enddo
      enddo
c     write(6,*) 'area=',area

      cor=0.
      rms=0.
      sd1=0.
      sd2=0.

      do j=lat1,lat2
      do i=lon1,lon2
        if(fld1(i,j).gt.-900..and.fld2(i,j).gt.-900.) then
          cor=cor+fld1(i,j)*fld2(i,j)*coslat(j)/area
          rms=rms+(fld1(i,j)-fld2(i,j))*(fld1(i,j)-fld2(i,j))
     &*coslat(j)/area
          sd1=sd1+fld1(i,j)*fld1(i,j)*coslat(j)/area
          sd2=sd2+fld2(i,j)*fld2(i,j)*coslat(j)/area
        endif
      enddo
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      cor=cor/(sd1*sd2)
      rms=rms**0.5

      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  using least square to have y=a+bx
C  fin:input; fot:detrended output; for2:linear trend
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine ltrend_1d(fin,fot,fot2,nt,ny,a,b,undef)
      dimension fin(nt),fot(nt),fot2(nt)
      real lxx, lxy
c
      xb=0
      yb=0
      do it=1,ny
        xb=xb+float(it)/float(ny)
        yb=yb+fin(it)/float(ny)
      enddo
c
      lxx=0.
      lxy=0.
      do it=1,ny
        lxx=lxx+(it-xb)*(it-xb)
        lxy=lxy+(it-xb)*(fin(it)-yb)
      enddo
      b=lxy/lxx
      a=yb-b*xb

c
      do it=1,ny
        fot(it)=fin(it)-b*float(it)-a !detrended
        fot2(it)=b*float(it)+a !trend
      enddo
c
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  using least square to have y=a+bx
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine ltrend_3d(grid,out,out2,imx,jmx,nt,ny,a,b,undef)
      dimension grid(imx,jmx,nt),out(imx,jmx,nt)
      dimension out2(imx,jmx,nt)
      dimension a(imx,jmx),b(imx,jmx)
      real lxx, lxy
c
      do i=1,imx
      do j=1,jmx
c
      if(grid(i,j,1).gt.undef) then
c
      xb=0
      yb=0
      do it=1,ny
        xb=xb+float(it)/float(ny)
        yb=yb+grid(i,j,it)/float(ny)
      enddo
c
      lxx=0.
      lxy=0.
      do it=1,ny
      lxx=lxx+(it-xb)*(it-xb)
      lxy=lxy+(it-xb)*(grid(i,j,it)-yb)
      enddo
      b(i,j)=lxy/lxx
      a(i,j)=yb-b(i,j)*xb

      else
      a(i,j)=undef
      b(i,j)=undef
      endif

      enddo !over j
      enddo !over i
c
      do i=1,imx
      do j=1,jmx
      do it=1,ny

      if(grid(i,j,1).gt.undef) then
        out(i,j,it)=grid(i,j,it)-b(i,j)*float(it)-a(i,j) !detrended
        out2(i,j,it)=b(i,j)*float(it)+a(i,j) !trend
      else
        out(i,j,it)=undef
        out2(i,j,it)=undef
      endif

      enddo
      enddo
      enddo

      do i=1,imx
      do j=1,jmx

      if(grid(i,j,1).gt.undef) then
        out2(i,j,ny+1)=b(i,j)*float(ny+1)+a(i,j) !trend
      else
        out2(i,j,ny+1)=undef
      endif

      enddo
      enddo
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  using least square to have y=a+bx
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine ltrend_4d_mics(grid,out,out2,imx,jmx,nt,ny,a,b,undef,
     & mics)
      dimension grid(imx,jmx,nt,mics),out(imx,jmx,nt,mics)
      dimension out2(imx,jmx,nt)
      dimension a(imx,jmx),b(imx,jmx)
      real lxx, lxy
c
      DO ic=1,mics

      do i=1,imx
      do j=1,jmx
c
      if(grid(i,j,1,1).gt.undef) then
c
      xb=0
      yb=0
      do it=1,ny
        xb=xb+float(it)/float(ny)
        yb=yb+grid(i,j,it,ic)/float(ny)
      enddo
c
      lxx=0.
      lxy=0.
      do it=1,ny
      lxx=lxx+(it-xb)*(it-xb)
      lxy=lxy+(it-xb)*(grid(i,j,it,ic)-yb)
      enddo
      b(i,j)=lxy/lxx
      a(i,j)=yb-b(i,j)*xb

      else
      a(i,j)=undef
      b(i,j)=undef
      endif

      enddo !over j
      enddo !over i
c
      do i=1,imx
      do j=1,jmx
      do it=1,ny

      if(grid(i,j,1,1).gt.undef) then
        out(i,j,it,ic)=grid(i,j,it,ic)-b(i,j)*float(it)-a(i,j) !detrended
      else
        out(i,j,it,ic)=undef
      endif

      enddo
      enddo
      enddo

      enddo ! ic loop
c
      return
      end

      SUBROUTINE prob_3c_prd(detp,prbp,pa,pb,pn,kpdf,xbin,xdel,ypdf,
     & frac)

c detp: deterministic prd
c prbp: problistic prd

      real xbin(kpdf),ypdf(kpdf)

      esm=frac*detp

      b1=-esm-0.43
      b2=-esm+0.43
c
      n1=kpdf/2+int(b1/xdel)
      n2=kpdf/2+int(b2/xdel)+1

c     write(6,*) 'esm',esm
c     write(6,*) 'b1,b2=',b1,b2
c     write(6,*) 'n1,n2=',n1,n2

      call prob_3c(kpdf,n1,n2,xbin,xdel,ypdf,pb,pa,pn)

      if(detp.gt.0) then
        prbp=pa
      else
        prbp=-pb
      endif

      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  Have 3-category prob by integratinge PDF
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine prob_3c(n,n1,n2,xx,xdel,yy,pb,pa,pn)
      real xx(n),yy(n)
      pb=0
      do i=1,n1
c     do i=1,n1-1
      pb=pb+xdel*yy(i)
      enddo
      pa=0
      do i=n2,n
c     do i=n2+1,n
      pa=pa+xdel*yy(i)
      enddo
      pn=0
      do i=n1+1,n2-1
c     do i=n1,n2
      pn=pn+xdel*yy(i)
      enddo
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  calculate normal distribution PDF from -5 to 5 (unit=std)
C  have it as a table for later integration
C  sd: std; xm: mean or center value
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine pdf_tab_general(sd,xm,xx,yy,xde,n)
      real xx(n),yy(n)
      pi=3.14159
      coef=1./(sd*sqrt(2.*pi))
      dvar=2.*sd*sd
      xx(1)=-5.+xde/2.
      do i=2,n
      xx(i)= xx(i-1)+xde
      enddo
      do i=1,n
      yy(i)=coef*exp(-(xx(i)-xm)*(xx(i)-xm)/dvar)
      enddo
      return
      end

      SUBROUTINE rpss_t(vfc,pb,pa,rpss,v3c,imx,jmx,its,nt1,nt,undef)

      real pa(imx,jmx,nt),pb(imx,jmx,nt)
      real vfc(imx,jmx,nt),rpss(imx,jmx)
      real rps(imx,jmx,nt),rpsc(imx,jmx,nt)
      real v3c(imx,jmx,nt)

c convert vfc to probilistic form
      do it=its,nt1
        do i=1,imx
        do j=1,jmx
        IF(vfc(i,j,it).gt.-900) then

          va=0.
          vb=0.
          vn=0.
          if(vfc(i,j,it).gt.0.43) then
            va=1
            v3c(i,j,it)=1
          endif

          if(vfc(i,j,it).lt.-0.43) then
            vb=1
            v3c(i,j,it)=-1
          endif

          if(vfc(i,j,it).ge.-0.43.and.vfc(i,j,it).le.0.43) then
            vn=1
            v3c(i,j,it)=0
          endif
c have rps
          pn=1.-pa(i,j,it)-pb(i,j,it)
          y1=pb(i,j,it)
          y2=pb(i,j,it)+pn
          y3=1.
          o1=vb
          o2=vb+vn
          o3=1.
          rps(i,j,it)=(y1-o1)**2 !rps
     &+(y2-o2)**2
          rpsc(i,j,it)=(1./3.-o1)**2 !rpsc
     &+(2./3.-o2)**2
        ELSE
            v3c(i,j,it)=undef
        END IF
        enddo
        enddo
      enddo
c have pattern of rpc_t
      do i=1,imx
      do j=1,jmx

        rpss(i,j)=undef

        IF(vfc(i,j,1).gt.-900) then

        exp=0.
        expc=0.
        grd=0
        do it=its,nt1
          exp=exp+rps(i,j,it)
          expc=expc+rpsc(i,j,it)
          grd=grd+1
        enddo
        exp_rps=exp/grd
        exp_rpsc=expc/grd
        rpss(i,j)=1.-exp_rps/exp_rpsc
      END IF
      enddo
      enddo

      return
      end
