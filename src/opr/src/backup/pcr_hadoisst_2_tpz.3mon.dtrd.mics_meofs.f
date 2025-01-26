      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C PCR for forecst TPZ
C===========================================================
      real fld0(imx,jmx),fld(imx,jmx)
      real sst(imx,jmx,nyr,mics)
      real v1dtd(imx,jmx,nyr,mics),v1trd(imx,jmx,nyr)
      real av1(imx,jmx),bv1(imx,jmx)
      real sstc(imx,jmx),tpzc(imx,jmx),tpzc_tot(imx,jmx,nlead)
      real fld2(imx,jmx),fld3(imx,jmx)
      real corr(imx,jmx,nyr),regr(imx,jmx,nyr)
      real corr2(imx,jmx,nyr),regr2(imx,jmx,nyr,nyr)
      real corr3(imx,jmx,nyr),regr3(imx,jmx,nyr)
      real cor3d(imx,jmx,nlead),rms3d(imx,jmx,nlead)
      real hss3d(imx,jmx,nlead)
      real ts1(nyr),ts2(nyr)
      real w2d(imx,jmx),w2d2(imx,jmx),w2d3(imx,jmx)
      real w2d4(imx,jmx),w2d5(imx,jmx),w2d6(imx,jmx)
      real tcof(nyr,nyr,mics)
      real tpz(imx,jmx,montot),wtpz(imx,jmx,nyr)
      real v2dtd(imx,jmx,nyr),v2trd(imx,jmx,nyr)
      real av2(imx,jmx),bv2(imx,jmx)
      real hcst(imx,jmx,nyr,nlead,mics,ncut)
      real wthcst(imx,jmx,nyr,nlead)
      real fcst(imx,jmx,nlead,mics,ncut)
      real avgo(imx,jmx),avgf(imx,jmx)
      real stdo(imx,jmx,nlead),stdf(imx,jmx,nlead)
      real wtfcst(imx,jmx,nlead)
      real vfld(imx,jmx,nyr,nlead)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      dimension neof(mcut)
      data neof/icut1,icut2,icut3,icut4/
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !sst
      open(11,form='unformatted',access='direct',recl=4*imx*jmx) !tpz

      open(20,form='unformatted',access='direct',recl=4) !pc
      open(21,form='unformatted',access='direct',recl=4*imx*jmx) !eof

      open(30,form='unformatted',access='direct',recl=4*imx*jmx) !fcst
      open(31,form='unformatted',access='direct',recl=4) !1d_skill
      open(32,form='unformatted',access='direct',recl=4*imx*jmx) !hcst

      open(40,form='unformatted',access='direct',recl=4*imx*jmx) !sst ICs
      open(41,form='unformatted',access='direct',recl=4*imx*jmx) !regr
C
C== have coslat
C
      do j=1,jmx
        if(jmx.eq.180) then
          xlat(j)=-89.5+(j-1)*1.
        else
          xlat(j)=-89+(j-1)*2.
        endif
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use
        cosr(j)=sqrt(coslat(j))
      enddo

C     undef=-999.0
C
C=== read in all 3-mon avg tpz
      do it=1,nsstot ! nsstot=montot-2
        read(11,rec=it) fld2
        do i=1,imx
        do j=1,jmx
          tpz(i,j,it)=fld2(i,j)
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


      call ltrend_4d_mics(sst,v1dtd,v1trd,imx,jmx,nyr,ny_sst,av1,bv1,
     &undef,mics)
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
      if(id_detrd.eq.1) then
      call pc_eof_mics(v1dtd,imx,jmx,lons,lone,lats,late,nyr,
     &ny_sst,cosr,ngrd,modmax,tcof,corr,regr,undef,id,mics,id_ceof)
      else
      call pc_eof_mics(sst,imx,jmx,lons,lone,lats,late,nyr,
     &ny_sst,cosr,ngrd,modmax,tcof,corr,regr,undef,id,mics,id_ceof)
      endif

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
      its_tpz=icmon+lagmax+ld+1 !11+1+1=13(jfm)
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
C have tpz anomalies over period 1 -> ny_tpz
      do i=1,imx
      do j=1,jmx
        if(fld2(i,j).gt.-900.) then
          do it=1,ny_tpz
            ts2(it)=wtpz(i,j,it)
          enddo
          call clim_tot(ts2,tpzc_tot(i,j,ld),nyr,1,ny_tpz)
          call clim_anom(ts2,tpzc(i,j),nyr,ny_tpz)
        else
          do it=1,ny_tpz
            ts2(it)=undef
          enddo
            tpzc(i,j)=undef
            tpzc_tot(i,j,ld)=undef
        endif
          do it=1,ny_tpz
            wtpz(i,j,it)=ts2(it)
          enddo
      enddo
      enddo
C 
C have linear trend of tpz

      if(id_detrd.eq.1) then
      call ltrend_3d(wtpz,v2dtd,v2trd,imx,jmx,nyr,ny_tpz,
     &av2,bv2,undef)
      else
      do it=1,nyr 
      do i=1,imx
      do j=1,jmx
        v2dtd(i,j,it)=wtpz(i,j,it)
      enddo
      enddo
      enddo
      endif
c
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
c           ts2(ir)=wtpz(i,j,iy)
            ts2(ir)=v2dtd(i,j,iy)
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

      if(id_detrd.eq.1) then
        hcst(i,j,itgt,ld,ic,mc)=w2d(i,j)+v2trd(i,j,itgt)
c       hcst(i,j,itgt,ld,ic,mc)=w2d(i,j) ! not add trend
      else
        hcst(i,j,itgt,ld,ic,mc)=w2d(i,j)
      endif

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
c           ts2(iy)=wtpz(i,j,iy)
            ts2(iy)=v2dtd(i,j,iy)
          enddo

          call regr_t(ts1,ts2,nyr,ny_tpz,corr3(i,j,m),regr3(i,j,m))

        ELSE

          corr3(i,j,m)=undef
          regr3(i,j,m)=undef

        ENDIF

        enddo
        enddo
      enddo ! m loop

C write out regr3 & corr3
      do m=1,icut1
        do i=1,imx
        do j=1,jmx
        w2d(i,j)=regr3(i,j,m)
        w2d2(i,j)=corr3(i,j,m)
        enddo
        enddo
        iw5=iw5+1
        write(41,rec=iw5) w2d
        iw5=iw5+1
        write(41,rec=iw5) w2d2
      enddo
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

      if(id_detrd.eq.1) then
        fcst(i,j,ld,ic,mc)=w2d(i,j)+v2trd(i,j,ny_tpz)
c       fcst(i,j,ld,ic,mc)=w2d(i,j) ! not aad trend
      else
        fcst(i,j,ld,ic,mc)=w2d(i,j)
      endif

      enddo
      enddo

      enddo ! mc loop

      ENDDO ! ic loop

      ENDDO ! ld loop
c
c  hcst and fcst
      iw=0
      DO ld=1,nlead ! lead of weighted hcst/fcst

C== have hcst
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
C== have fcst
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
c std of obs
      iw4=0
      do ld=1,nlead

        do i=1,imx
        do j=1,jmx
          if (fld2(i,j).gt.-900.) then
            avgo(i,j)=0.
c           do it=1,ny_tpz
            do it=its_clm,ite_clm
            avgo(i,j)=avgo(i,j)+vfld(i,j,it,ld)/float(ny_clm)
            enddo
          else
            avgo(i,j)=undef
          endif
        enddo
        enddo

        do i=1,imx
        do j=1,jmx
          if (fld2(i,j).gt.-900.) then
            stdo(i,j,ld)=0.
            do it=its_clm,ite_clm
            stdo(i,j,ld)=stdo(i,j,ld)+
     &      (vfld(i,j,it,ld)-avgo(i,j))**2
            enddo
            stdo(i,j,ld)=sqrt(stdo(i,j,ld)/float(ny_clm))
          else
            stdo(i,j,ld)=undef
            endif
        enddo
        enddo

c std of wthcst
        do i=1,imx
        do j=1,jmx
          if (fld2(i,j).gt.-900.) then
            avgf(i,j)=0.
            do it=its_clm,ite_clm
            avgf(i,j)=avgf(i,j)+wthcst(i,j,it,ld)/
     &float(ny_clm)
            enddo
          else
            avgf(i,j)=undef
          endif
        enddo
        enddo

        do i=1,imx
        do j=1,jmx
          if (fld2(i,j).gt.-900.) then
            stdf(i,j,ld)=0.
            do it=its_clm,ite_clm
            stdf(i,j,ld)=stdf(i,j,ld)+
     &      (wthcst(i,j,it,ld)-avgf(i,j))**2
            enddo
            stdf(i,j,ld)=sqrt(stdf(i,j,ld)/float(ny_clm))
          else
            stdf(i,j,ld)=undef
          endif
        enddo
        enddo
c
c deal with "too small" std
        do i=1,imx
        do j=1,jmx
          if(fld2(i,j).gt.-900) then
            if(stdo(i,j,ld).lt.0.001) then
              stdo(i,j,ld)=0.001
            endif
            if(stdf(i,j,ld).lt.0.001) then
              stdf(i,j,ld)=0.001
            endif
          endif
        enddo
        enddo

c standardized wthcst 
      do i=1,imx
      do j=1,jmx
      do it=1,ny_tpz
      if (fld2(i,j).gt.-900.) then
        vfld(i,j,it,ld)=(vfld(i,j,it,ld)-avgo(i,j))/stdo(i,j,ld)
      else
        vfld(i,j,it,ld)=undef
      endif
      enddo
      enddo
      enddo
c
      do i=1,imx
      do j=1,jmx
      do it=1,ny_tpz
      if (fld2(i,j).gt.-900.) then
        wthcst(i,j,it,ld)=(wthcst(i,j,it,ld)-avgf(i,j))/
     &stdf(i,j,ld)
      else
        wthcst(i,j,it,ld)=undef
      endif
      enddo
      enddo
      enddo
c
c standardized fcsts
      do i=1,imx
      do j=1,jmx
      if (fld2(i,j).gt.-900.) then
        wtfcst(i,j,ld)=(wtfcst(i,j,ld)-avgf(i,j))/stdf(i,j,ld)
      else
        wtfcst(i,j,ld)=undef
      endif
      enddo
      enddo

      enddo ! ld loop
c
c== temporal skill
      ny_skill=ny_tpz-its_clm+1
      DO ld=1,nlead

      DO i=1,imx
      DO j=1,jmx
c
      if(fld2(i,j).gt.-900.) then
        ir=0
c       do it=its_clm,ite_clm
        do it=its_clm,ny_tpz

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
c     do iy=its_clm,ite_clm
      do iy=its_clm,ny_tpz

        do i=1,imx
        do j=1,jmx
        w2d(i,j)=vfld(i,j,iy,ld)
        w2d2(i,j)=wthcst(i,j,iy,ld)
        enddo
        enddo

      call sp_cor_rms(w2d,w2d2,coslat,imx,jmx,
     &1,360,115,160,xcor,xrms)

      iw=iw+1
      write(31,rec=iw) xcor
      iw=iw+1
      write(31,rec=iw) xrms

      call sp_cor_rms(w2d,w2d2,coslat,imx,jmx,
     &230,300,115,140,xcor,xrms)
      iw=iw+1
      write(31,rec=iw) xcor
      iw=iw+1
      write(31,rec=iw) xrms

      call hss3c_s(w2d,w2d2,imx,jmx,1,360,115,160,coslat,h1)
      call hss3c_s(w2d,w2d2,imx,jmx,230,300,115,140,coslat,h2)

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
        do it=its_clm,ny_tpz

          do i=1,imx
          do j=1,jmx
            w2d(i,j)=vfld(i,j,it,ld)
          enddo
          enddo
          iw=iw+1
          write(32,rec=iw) w2d

          do i=1,imx
          do j=1,jmx
            w2d(i,j)=wthcst(i,j,it,ld)
          enddo
          enddo
          iw=iw+1
          write(32,rec=iw) w2d

          do i=1,imx
          do j=1,jmx
            w2d(i,j)=stdo(i,j,ld)
          enddo
          enddo
          iw=iw+1
          write(32,rec=iw) w2d

       enddo
       enddo
c write out fcst and skill_t
        iw=0
       do ld=1,nlead

         do i=1,imx
         do j=1,jmx
           w2d(i,j)=wtfcst(i,j,ld)
           w2d2(i,j)=stdo(i,j,ld)
           w2d3(i,j)=cor3d(i,j,ld)
           w2d4(i,j)=rms3d(i,j,ld)
           w2d5(i,j)=hss3d(i,j,ld)
           w2d6(i,j)=tpzc_tot(i,j,ld)
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

      enddo ! ld loop
c
      stop
      end

      SUBROUTINE hss3c_t(obs,prd,ny,nt,h)
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
        do i=191,240
        do j=85,96
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
