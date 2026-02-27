      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C PCR for forecst TPZ
C===========================================================
      real fld0(imx,jmx),fld(imx,jmx)
      real sst(imx,jmx,nyr),v1dtd(imx,jmx,nyr),v1trd(imx,jmx,nyr)
      real av1(imx,jmx),bv1(imx,jmx)
      real sstc(imx,jmx),tpzc(imx2,jmx2),tpzc_tot(imx2,jmx2,nlead)
      real fld2(imx2,jmx2)
      real corr(imx,jmx,nyr),regr(imx,jmx,nyr)
      real corr2(imx2,jmx2,nyr),regr2(imx2,jmx2,nmod,nyr)
      real corr3(imx2,jmx2,nyr),regr3(imx2,jmx2,nyr)
      real cor3d(imx2,jmx2,nlead),rms3d(imx2,jmx2,nlead)
      real ac(imx2,jmx2,nyr,nlead,lagmax)
      real hss3d(imx2,jmx2,nlead)
      real ts1(nyr),ts2(nyr)
      real w2d(imx2,jmx2),w2d2(imx2,jmx2),w2d3(imx2,jmx2)
      real w2d4(imx2,jmx2),w2d5(imx2,jmx2),w2d6(imx2,jmx2)
      real tcof(nyr,nyr)
      real tpz(imx2,jmx2,montot),wtpz(imx2,jmx2,nyr)
      real v2dtd(imx2,jmx2,nyr),v2trd(imx2,jmx2,nyr)
      real av2(imx2,jmx2),bv2(imx2,jmx2)
      real hcst(imx2,jmx2,nyr,nlead,lagmax)
      real wthcst(imx2,jmx2,nyr,nlead)
      real fcst(imx2,jmx2,nlead,lagmax)
      real wtd(imx2,jmx2,nyr,nlead),wts(imx2,jmx2,nyr,nlead,lagmax)
      real avgo(imx2,jmx2),avgf(imx2,jmx2)
      real stdo(imx2,jmx2,nlead),stdf(imx2,jmx2,nlead)
      real wtfcst(imx2,jmx2,nlead)
      real vfld(imx2,jmx2,nyr,nlead),vfld2(imx2,jmx2,nyr)
      real xn34(nyr)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real xlat2(jmx2),coslat2(jmx2),cosr2(jmx2)
      real w4d(imx2,jmx2,nmod,nyr),wcor(imx2,jmx2,nmod,nyr)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !sst
      open(11,form='unformatted',access='direct',recl=4*imx2*jmx2) !tpz

      open(20,form='unformatted',access='direct',recl=4) !pc
      open(21,form='unformatted',access='direct',recl=4*imx*jmx) !eof

      open(30,form='unformatted',access='direct',recl=4*imx2*jmx2) !fcst
      open(31,form='unformatted',access='direct',recl=4) !1d_skill
      open(32,form='unformatted',access='direct',recl=4*imx2*jmx2) !hcst

      open(33,form='unformatted',access='direct',recl=4*imx2*jmx2) !wts
      open(34,form='unformatted',access='direct',recl=4*imx2*jmx2) !regr

      open(40,form='unformatted',access='direct',recl=4*imx*jmx)
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

      do j=1,jmx2
        if(jmx2.eq.180) then
          xlat2(j)=-89.5+(j-1)*1.
        else if(jmx2.eq.360) then
          xlat2(j)=-89.75+(j-1)*0.5
        endif
        coslat2(j)=cos(xlat2(j)*3.14159/180)  
        cosr2(j)=sqrt(coslat2(j)) 
      enddo

C     undef=-999.0
C
C=== read in all 3-mon avg tpz
      do it=1,nsstot ! nsstot=montot-2
        read(11,rec=it) fld2
        do i=1,imx2
        do j=1,jmx2
          tpz(i,j,it)=fld2(i,j)
        enddo
        enddo
      enddo
C
C============ loop over ilag
c
      lagmaxm=lagmax - 1
      lagmaxm=1
      DO ilag=1,lagmaxm ! =1 for lag=0
c     its_sst=icmon+lagmax-ilag+1 ! for mon sst
c     its_sst=icmon-2+lagmax-ilag+1 ! for 3-mon sst 11-2+12-1+1=21(son)
      its_sst=icmon+12-2-ilag+1 ! for 3-mon sst 11-2+12-1+1=21(son)
      ir=0
c     do it=its_sst,montot,12
      do it=its_sst,nsstot,12
      write(6,*) 'it=',it
        read(10,rec=it) fld
        ir=ir+1
        do i=1,imx
        do j=1,jmx
          sst(i,j,ir)=fld(i,j)
        enddo
        enddo
      enddo
      ny_sst=ir
      write(6,*) 'its_sst==',its_sst,'ny_sst==',ny_sst,
     &'sst=',sst(90,45,ny_sst)

      ic_fcst=ny_sst
C
C have sst anomalies over period 1 -> ny_sst
      do i=1,imx
      do j=1,jmx
        if(fld(i,j).gt.-900.) then
          do it=1,ny_sst
            ts1(it)=sst(i,j,it)
          enddo
          call clim_anom(ts1,sstc(i,j),nyr,ny_sst)
        else
          do it=1,ny_sst
            ts1(it)=undef
          enddo
            sstc(i,j)=undef
        endif
          do it=1,ny_sst
            sst(i,j,it)=ts1(it)
          enddo
      enddo
      enddo

c      call havenino34(sst,xn34,imx,jmx,nyr,ny_sst)
c
c SST EOF analysis
c
      do m=1,ny_sst
      do it=1,nyr
        tcof(m,it)=undef
      enddo
      enddo
C
      call ltrend_3d(sst,v1dtd,v1trd,imx,jmx,nyr,ny_sst,av1,bv1,undef)

      call pc_eof(v1dtd,imx,jmx,lons,lone,lats,late,nyr,ny_sst,cosr,
     &ngrd,ny_sst,tcof,corr,regr,undef,id)
c
C write out PC and EOF patterns for ilag=1
      iw=0
      iw2=0
      do m=1,ny_sst

      do it=1,ny_sst
      iw=iw+1
      write(20,rec=iw) tcof(m,it)
      enddo

      do i=1,imx
      do j=1,jmx
        fld(i,j)=corr(i,j,m)
        fld0(i,j)=regr(i,j,m)
      enddo
      enddo
      iw2=iw2+1
      write(21,rec=iw2) fld
      iw2=iw2+1
      write(21,rec=iw2) fld0

      enddo ! m loop

c reconstruct sst
      iw=0
      do it=1,ny_sst

      do i=1,imx
      do j=1,jmx
        fld0(i,j)=sst(i,j,it)

      if(abs(regr(i,j,1)).lt.900) then
        fld(i,j)=0.
        do m=1,ny_sst
        fld(i,j)=fld(i,j)+tcof(m,it)*regr(i,j,m)
        enddo
      else
        fld(i,j)=undef
      endif
        
      enddo
      enddo

      iw=iw+1
      write(40,rec=iw) fld0
      iw=iw+1
      write(40,rec=iw) fld

      enddo ! it loop
c
c tpz hindcast for ld=1->nlead
      iw5=0
      DO ld=1,nlead

c select tpz for each lead
c     its_tpz=icmon+lagmax+ld+1 !11+12+1+1=25(jfm)
      its_tpz=icmon+12+ld+1 !11+1+1=13(jfm)
      ir=0
      do it=its_tpz,nsstot,12
        ir=ir+1
        do i=1,imx2
        do j=1,jmx2
          wtpz(i,j,ir)=tpz(i,j,it)
        enddo
        enddo
      enddo
      ny_tpz=ir
      write(6,*) 'its_tpz=',its_tpz,'ny_tpz=',ny_tpz
C 
C have tpz anomalies over period 1 -> ny_tpz
      do i=1,imx2
      do j=1,jmx2
        if(fld2(i,j).gt.-900.) then
          do it=1,ny_tpz
            ts2(it)=wtpz(i,j,it)
          enddo
          call clim_tot(ts2,tpzc_tot(i,j,ld),nyr,its_clm,ite_clm)
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
      call ltrend_3d(wtpz,v2dtd,v2trd,imx2,jmx2,nyr,ny_tpz,
     &av2,bv2,undef)
c
C CV hcst for this lead
c     nfld=ny_tpz - 1
c     if(ncv.eq.3) nfld=ny_tpz - 3

      DO itgt=1,ny_tpz

        iym=itgt-1
        iyp=itgt+1
        if(itgt.eq.1) iym=3
        if(itgt.eq.ny_tpz) iyp=ny_tpz-2

      DO m=1,nmod

        ir=0
        do iy=1,ny_tpz

          if(iy.eq.itgt) go to 555

          if(ncv.eq.3) then
            if(iy.eq.iym)  go to 555
            if(iy.eq.iyp)  go to 555
          endif

            ir=ir+1
            ts1(ir)=tcof(m,iy)
  555   continue
        enddo
          
        do i=1,imx2
        do j=1,jmx2

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
          call regr_t(ts1,ts2,nyr,nfld,corr2(i,j,m),regr2(i,j,m,itgt))

        ELSE

          corr2(i,j,m)=undef
          regr2(i,j,m,itgt)=undef

        ENDIF

        enddo
        enddo
      enddo ! m loop
c
c have w4d
      do i=1,imx2
      do j=1,jmx2
        if(fld2(i,j).gt.-900.) then
          w2d2(i,j)=wtpz(i,j,itgt)
          w2d3(i,j)=v2dtd(i,j,itgt)
          do m=1,nmod
          w4d(i,j,m,itgt)=tcof(m,itgt)*regr2(i,j,m,itgt)
          enddo
        else
          w2d2(i,j)=undef
          w2d3(i,j)=undef
          do m=1,nmod
          w4d(i,j,m,itgt)=undef
          enddo
        endif
          vfld(i,j,itgt,ld)=w2d2(i,j)
          vfld2(i,j,itgt)=w2d3(i,j)
      enddo
      enddo

      ENDDO ! itgt loop

c have corr for each mode and each tgt year
      do m=1,nmod

      do i=1,imx2
      do j=1,jmx2

      do itgt=1,ny_tpz

        iym=itgt-1
        iyp=itgt+1
        if(itgt.eq.1) iym=3
        if(itgt.eq.ny_tpz) iyp=ny_tpz-2

        IF(fld2(i,j).gt.undef) then

          ir=0
          do iy=1,ny_tpz

          if(iy.eq.itgt) go to 766

          if(ncv.eq.3) then
            if(iy.eq.iym)  go to 766
            if(iy.eq.iyp)  go to 766
          endif

            ir=ir+1
            ts1(ir)=w4d(i,j,m,iy)
            ts2(ir)=vfld2(i,j,iy)
  766     continue
          enddo

        call regr_t(ts1,ts2,nyr,nfld,wcor(i,j,m,itgt),xreg)

        ELSE

        wcor(i,j,m,itgt)=undef

        ENDIF

      enddo ! itgt loop

      enddo
      enddo

      enddo ! loop m

c have corr for all hcst
      do m=1,nmod

      do i=1,imx2
      do j=1,jmx2

        IF(fld2(i,j).gt.undef) then
          do iy=1,ny_tpz
            ts1(iy)=w4d(i,j,m,iy)
            ts2(iy)=vfld2(i,j,iy)
          enddo
        call regr_t(ts1,ts2,nyr,ny_tpz,wcor(i,j,m,ic_fcst),xreg)
        ELSE
          wcor(i,j,m,ic_fcst)=undef
        ENDIF

      enddo
      enddo

      enddo !m loop

c hcst
      do it=1,ny_tpz
      call setzero(w2d,imx2,jmx2)
      do i=1,imx2
      do j=1,jmx2
        if(fld2(i,j).gt.undef) then
          do m=1,nmod

          if(wcor(i,j,m,it).lt.0.) then
            regr2(i,j,m,it)=-regr2(i,j,m,it)
          endif

            w2d(i,j)=w2d(i,j)+tcof(m,it)*regr2(i,j,m,it)
          enddo
        else
            w2d(i,j)=undef
        endif
        hcst(i,j,it,ld,ilag)=w2d(i,j)+v2trd(i,j,it)
      enddo
      enddo
      enddo ! it loop

c==temporal ac skill for hcst of ld and ilag

      DO i=1,imx2
      DO j=1,jmx2
c
      do itgt=1,ny_tpz

        iym=itgt-1
        iyp=itgt+1
        if(itgt.eq.1) iym=3
        if(itgt.eq.ny_tpz) iyp=ny_tpz-2

      if(fld2(i,j).gt.-900.) then

        ir=0
        do iy=1,ny_tpz

          if(iy.eq.itgt) go to 777

          if(ncv.eq.3) then
            if(iy.eq.iym)  go to 777
            if(iy.eq.iyp)  go to 777
          endif

          ir=ir+1
            ts1(ir)=vfld(i,j,iy,ld)
            ts2(ir)=hcst(i,j,iy,ld,ilag)
  777   continue
        enddo

        call ac_rms(ts1,ts2,nyr,nfld,ac(i,j,itgt,ld,ilag),xrms)

      else
        ac(i,j,itgt,ld,ilag)=undef
      endif

      enddo  ! itgt loop

c ac for ic_fcst

      if(fld2(i,j).gt.-900.) then
        do it=1,ny_tpz
            ts1(it)=vfld(i,j,it,ld)
            ts2(it)=hcst(i,j,it,ld,ilag)
        enddo
        call ac_rms(ts1,ts2,nyr,ny_tpz,ac(i,j,ic_fcst,ld,ilag),xrms)
      else
        ac(i,j,ic_fcst,ld,ilag)=undef
      endif

      ENDDO
      ENDDO
c
C========== realtime fcst
c
c have regr patterns
      DO m=1,nmod

        do iy=1,ny_tpz
            ts1(iy)=tcof(m,iy)
        enddo
          
        do i=1,imx2
        do j=1,jmx2

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
c
c fcst
      call setzero(w2d,imx2,jmx2)
      do i=1,imx2
      do j=1,jmx2
        if(fld2(i,j).gt.-900.) then
          do m=1,nmod
            if(wcor(i,j,m,ic_fcst).lt.0.) then
              regr3(i,j,m)=-regr3(i,j,m)
            endif
            w2d(i,j)=w2d(i,j)+tcof(m,ic_fcst)*regr3(i,j,m)
          enddo
        else
            w2d(i,j)=undef
        endif

c       fcst(i,j,ld,ilag)=w2d(i,j)
        fcst(i,j,ld,ilag)=w2d(i,j)+v2trd(i,j,ny_tpz)

      enddo
      enddo

      ENDDO ! ld loop
      ENDDO ! ilag
c
c weighted ensemble over all lagged hcst and fcst
      iw=0
      DO ld=1,nlead ! lead of weighted hcst/fcst

C== have denominator of the weights
      do it=1,ic_fcst

      do i=1,imx2
      do j=1,jmx2
        if(fld2(i,j).gt.-900.) then
          wtd(i,j,it,ld)=0
          do ilag=1,lagmaxm
            if(ac(i,j,it,ld,ilag).gt.0.) then
              wtd(i,j,it,ld)=wtd(i,j,it,ld)+ac(i,j,it,ld,ilag)**2
            else
              wtd(i,j,it,ld)=wtd(i,j,it,ld)+0.
            endif
          enddo
        else
        wtd(i,j,it,ld)=undef
        endif
      enddo
      enddo
C== have weights for each ld and lag
      do ilag=1,lagmaxm
        do i=1,imx2
        do j=1,jmx2
          if(fld2(i,j).gt.-900.) then
            if(ac(i,j,it,ld,ilag).gt.0.) then
              wts(i,j,it,ld,ilag)=ac(i,j,it,ld,ilag)**2/wtd(i,j,it,ld)
            else
              wts(i,j,it,ld,ilag)=0.
            endif
          else
            wts(i,j,it,ld,ilag)=undef
          endif
        enddo
        enddo
      enddo
       
      enddo ! it loop

C== have ensemble hcst
      do it=1,ny_tpz
        do i=1,imx2
        do j=1,jmx2
          if(fld2(i,j).gt.-900.) then
            w2d2(i,j)=vfld(i,j,it,ld)

            w2d(i,j)=0.
            do ilag=1,lagmaxm
            w2d(i,j)=w2d(i,j)+wts(i,j,it,ld,ilag)*hcst(i,j,it,ld,ilag)
c           w2d(i,j)=w2d(i,j)+hcst(i,j,it,ld,ilag)/float(lagmaxm)
            enddo

          else
            w2d(i,j)=undef
          endif
          wthcst(i,j,it,ld)=w2d(i,j)
        enddo
        enddo
      enddo !it loop
c
C== have ensemble fcst
        do i=1,imx2
        do j=1,jmx2
          if(fld2(i,j).gt.-900.) then

          w2d(i,j)=0.
          do ilag=1,lagmaxm
          w2d(i,j)=w2d(i,j)+wts(i,j,ic_fcst,ld,ilag)*fcst(i,j,ld,ilag)
c         w2d(i,j)=w2d(i,j)+fcst(i,j,ld,ilag)/float(lagmaxm)
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
      ny_clm=ite_clm-its_clm + 1

      do ld=1,nlead

        do i=1,imx2
        do j=1,jmx2
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

        do i=1,imx2
        do j=1,jmx2
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
        do i=1,imx2
        do j=1,jmx2
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

        do i=1,imx2
        do j=1,jmx2
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
        do i=1,imx2
        do j=1,jmx2
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
      do i=1,imx2
      do j=1,jmx2
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
      do i=1,imx2
      do j=1,jmx2
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
      do i=1,imx2
      do j=1,jmx2
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

      DO i=1,imx2
      DO j=1,jmx2
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

        do i=1,imx2
        do j=1,jmx2
        w2d(i,j)=vfld(i,j,iy,ld)
        w2d2(i,j)=wthcst(i,j,iy,ld)
        enddo
        enddo

      call sp_cor_rms(w2d,w2d2,coslat2,imx2,jmx2,
     &1,360,115,160,xcor,xrms)

      iw=iw+1
      write(31,rec=iw) xcor
      iw=iw+1
      write(31,rec=iw) xrms

      call sp_cor_rms(w2d,w2d2,coslat2,imx2,jmx2,
     &230,300,115,140,xcor,xrms)
      iw=iw+1
      write(31,rec=iw) xcor
      iw=iw+1
      write(31,rec=iw) xrms

      call hss3c_s(w2d,w2d2,imx2,jmx2,1,360,115,160,coslat2,h1)
      call hss3c_s(w2d,w2d2,imx2,jmx2,230,300,115,140,coslat2,h2)

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

          do i=1,imx2
          do j=1,jmx2
            w2d(i,j)=vfld(i,j,it,ld)
          enddo
          enddo
          iw=iw+1
          write(32,rec=iw) w2d

          do i=1,imx2
          do j=1,jmx2
            w2d(i,j)=wthcst(i,j,it,ld)
          enddo
          enddo
          iw=iw+1
          write(32,rec=iw) w2d

          do i=1,imx2
          do j=1,jmx2
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
         do i=1,imx2
         do j=1,jmx2
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
       enddo
c
      iw=0
      do it=1,ic_fcst
      do ilag=1,lagmaxm

      do i=1,imx2
      do j=1,jmx2
        w2d(i,j)=ac(i,j,it,1,ilag)
        w2d2(i,j)=wts(i,j,it,1,ilag)
      enddo
      enddo

      iw=iw+1
      write(33,rec=iw) w2d
      iw=iw+1
      write(33,rec=iw) w2d2

      enddo
      enddo
c
      iw=0
      do it=ny_tpz-9,ny_tpz
      do n=1,70,10

      do i=1,imx2
      do j=1,jmx2
        w2d(i,j)=regr2(i,j,n,it)
      enddo
      enddo

      iw=iw+1
      write(34,rec=iw) w2d

      enddo
      enddo

      do n=1,70,10

      do i=1,imx2
      do j=1,jmx2
        w2d(i,j)=regr3(i,j,n)
      enddo
      enddo

      iw=iw+1
      write(34,rec=iw) w2d

      enddo

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

      SUBROUTINE sp_proj(w2d,regr,imx,jmx,nmod,is,ie,js,je,cosl,
     &undef,pj)
      real w2d(imx,jmx),regr(imx,jmx,nmod),cosl(jmx),pj(nmod)
c
      do m=1,nmod

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

      SUBROUTINE tpz_regr(tpz,tcof,imx,jmx,nfld,nmod,corr,regr,undef)
      real tpz(imx,jmx,nfld),tcof(nmod,nfld)
      real corr(imx,jmx,nfld),regr(imx,jmx,nfld)
      real ts1(nfld),ts2(nfld)
cc have regr patterns
      do m=1,nmod
c
      do it=1,nfld
        ts1(it)=tcof(m,it)
      enddo
c
      do j=1,jmx
      do i=1,imx

      if(tpz(i,j,1).gt.undef) then

      do it=1,nfld
        ts2(it)=tpz(i,j,it)
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

      SUBROUTINE pc_eof(wf3d,imx,jmx,is,ie,ls,le,ltime,nfld,cosr,
     &ngrd,nmod,tcof,corr,regr,undef,id)

      real wf3d(imx,jmx,ltime),tcof(ltime,ltime)
      real f3d(imx,jmx,nfld),cosr(jmx)
      real regr(imx,jmx,ltime),corr(imx,jmx,ltime),pc(nmod,nfld)
      real aaa(ngrd,nfld),wk(nfld,ngrd)
      real eval(nfld),evec(ngrd,nfld),coef(nfld,nfld)
      real ts1(nfld),ts2(nfld)

      do i=1,imx
      do j=1,jmx
      do it=1,nfld
        f3d(i,j,it)=wf3d(i,j,it)
      enddo
      enddo
      enddo
c
      do it=1,nfld
        ng=0
        do j=ls,le
        do i=is,ie
        if(f3d(i,j,1).gt.undef) then
          ng=ng+1
          aaa(ng,it)=f3d(i,j,it)*cosr(j)
        endif
        end do
        end do
      enddo ! it loop
      write(6,*) 'ngrd= ',ng
c
      call eofs(aaa,ngrd,nfld,nfld,eval,evec,coef,wk,id)
c
c normalize coef
      do m=1, nmod

      do it=1,nfld
        ts1(it)=coef(m,it)
      enddo
c
      call normal(ts1,ts2,nfld)
c
      do it=1,nfld
        pc(m,it)=ts2(it)
        tcof(m,it)=ts2(it)
      enddo
      enddo ! m loop
c
cc... write out eval
      totv=0
c     do m=1,5
      do m=1,nmod
      write(6,*)'eval= ',m,eval(m),'tcof(m,nfld)=',tcof(m,nfld)
      totv=totv+eval(m)
      end do
      write(6,*)'totv= ',totv,'sst(ny_sst)=',wf3d(90,45,nfld)
c
cc have regr patterns
      do m=1,nmod
c
      do it=1,nfld
        ts1(it)=pc(m,it)
      enddo
c
      do j=1,jmx
      do i=1,imx

      if(f3d(i,j,1).gt.-900.) then

      do it=1,nfld
        ts2(it)=f3d(i,j,it)
      enddo

      call regr_t(ts1,ts2,nfld,nfld,corr(i,j,m),regr(i,j,m))
      else
      corr(i,j,m)=undef
      regr(i,j,m)=undef
      endif

      enddo
      enddo

      enddo !m loop

      return
      end

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


      SUBROUTINE havenino34(sst,xn34,imx,jmx,nmax,nt)
      DIMENSION sst(imx,jmx,nmax),xn34(nmax)
      do it=1,nt
        xn34(it)=0
        ngrd=51*10
        do i=190,240
        do j=86,95
          xn34(it)=xn34(it)+sst(i,j,it)
        enddo
        enddo
        xn34(it)=xn34(it)/float(ngrd)
      enddo
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
c
      return
      end
