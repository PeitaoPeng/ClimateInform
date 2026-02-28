      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C PCR for forecst TPZ
C===========================================================
      real tpzc(imx,jmx,nwmo,nlead)
      real fld(imx,jmx)
      real corr2(imx,jmx,nyr),regr2(imx,jmx,nyr,nyr)
      real corr3(imx,jmx,nyr),regr3(imx,jmx,nyr)
      real cor3d(imx,jmx,nlead),rms3d(imx,jmx,nlead)
      real hss3d(imx,jmx,nlead)
      real ts1(nyr),ts2(nyr),ts3(nyr),ts4(nyr)
      real w1d(nwmo),w1d2(nwmo)
      real w2d(imx,jmx),w2d2(imx,jmx),w2d3(imx,jmx)
      real w2d4(imx,jmx),w2d5(imx,jmx),w2d6(imx,jmx)
      real tpz(imx,jmx,montot),wtpz(imx,jmx,nyr,nlead)
      real av2(imx,jmx),bv2(imx,jmx)
      real hcst(imx,jmx,nyr,nlead)
      real fcst(imx,jmx,nlead)
      real stdo(imx,jmx,nwmo,nlead),stdf(imx,jmx)
      real clmo(imx,jmx,nwmo,nlead),clmf(imx,jmx)
      real wtfcst(imx,jmx,nlead)
      real vfld(imx,jmx,nyr,nlead)
      real xn34(nyr)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real avgo(imx,jmx),avgf(imx,jmx)
C
      open(11,form='unformatted',access='direct',recl=4*imx*jmx) !tpz

      open(30,form='unformatted',access='direct',recl=4*imx*jmx) !fcst
      open(31,form='unformatted',access='direct',recl=4) !1d_skill
      open(32,form='unformatted',access='direct',recl=4*imx*jmx) !hcst
C
C== have coslat
C
      do j=1,jmx
        if(jmx.eq.180) then
          xlat(j)=-89.5+(j-1)*1.
        else if(jmx.eq.360) then
          xlat(j)=-89.75+(j-1)*0.5
        endif
        coslat(j)=cos(xlat(j)*3.14159/180)  
        cosr(j)=sqrt(coslat(j)) 
      enddo

C
C=== read in all 3-mon avg tpz
      do it=1,nsstot ! nsstot=montot-2
        read(11,rec=it) fld
        do i=1,imx
        do j=1,jmx
          tpz(i,j,it)=fld(i,j)
        enddo
        enddo
      enddo
C
      DO ld=1,nlead

c select tpz for each lead
      its_tpz=icmon+lagmax+ld+1 !11+1+1=13(jfm)
      ir=0
      do it=its_tpz,nsstot,12
        ir=ir+1
        do i=1,imx
        do j=1,jmx
          wtpz(i,j,ir,ld)=tpz(i,j,it)
        enddo
        enddo
        enddo ! it loop
      ny_tpz=ir
      write(6,*) 'its_tpz=',its_tpz,'ny_tpz=',ny_tpz
C 
C have WMO clim 51-80, 61-90, 71-00, 81-10, 91-20 ...
      do i=1,imx
      do j=1,jmx

      if(fld(i,j).gt.-900.) then

        do it=1,ny_tpz
          ts1(it)=wtpz(i,j,it,ld)
        enddo

        call wmo_clim_tot(ts1,w1d,nyr,nwmo)

        do ii=1,nwmo
          tpzc(i,j,ii,ld)=w1d(ii)
        enddo
      else

        do ii=1,nwmo
          tpzc(i,j,ii,ld)=undef
        enddo

      endif

      enddo
      enddo
C 
C hcst from 1981-ny_tpz
c
      DO iy=31,ny_tpz

         idec = (iy-1)/10 - 2 ! clim index
         write(6,*) 'iy=',iy,'idec=',idec

        do i=1,imx
        do j=1,jmx

        IF(fld(i,j).gt.-900.) then

         avg=0.
         do k=iy-kocn,iy-1
           avg=avg+wtpz(i,j,k,ld)/float(kocn)
         enddo

         hcst(i,j,iy-30,ld)=avg-tpzc(i,j,idec,ld)

         vfld(i,j,iy-30,ld)=wtpz(i,j,iy,ld)-tpzc(i,j,idec,ld)

        ELSE

          hcst(i,j,iy-30,ld)=undef
          vfld(i,j,iy-30,ld)=undef

        ENDIF

        enddo
        enddo

        ENDDO ! iy loop
c
c fcst
        idec = ny_tpz/10 - 2 ! clim index
        write(6,*) 'idec=',idec

        do i=1,imx
        do j=1,jmx

        IF(fld(i,j).gt.-900.) then

         avg=0.
         do k=ny_tpz-kocn+1,ny_tpz
           avg=avg+wtpz(i,j,k,ld)/float(kocn)
         end do

         fcst(i,j,ld)=avg-tpzc(i,j,idec,ld)

        ELSE

          fcst(i,j,ld)=undef

        ENDIF

        enddo
        enddo

c
        ENDDO ! ld loop
c
c normalize both obs and hcst
c
c std clm of obs
      its_hcst=1
      ite_hcst=ny_tpz-30
      ny_hcst=ite_hcst-its_hcst+1

      do ld=1,nlead

        do i=1,imx
        do j=1,jmx
          if (fld(i,j).gt.-900.) then
            do it=1,ny_tpz
              ts1(it)=wtpz(i,j,it,ld)
            enddo

            call wmo_clm_std_anom(ts1,w1d,w1d2,ts4,nyr,ny_tpz,nwmo)

            do ii=1,nwmo
              stdo(i,j,ii,ld)=w1d(ii)
              clmo(i,j,ii,ld)=w1d2(ii)
            enddo

            do it=31,ny_tpz
              vfld(i,j,it-30,ld)=ts4(it)
            enddo

          else

            do ii=1,nwmo
              stdo(i,j,ii,ld)=undef
              clmo(i,j,ii,ld)=undef
            enddo

            do it=31,ny_tpz
              vfld(i,j,it-30,ld)=undef
            enddo

          endif
        enddo
        enddo
c
c std clm of hcst
        do i=1,imx
        do j=1,jmx
          if (fld(i,j).gt.-900.) then

            do it=1,ny_tpz-30
              ts1(it)=hcst(i,j,it,ld)
            enddo

            call wmo_clm_std_anom(ts1,w1d,w1d2,ts4,nyr,ny_tpz-30,nwmo-3)

              stdf(i,j)=w1d(nwmo-3)
              clmf(i,j)=w1d2(nwmo-3)

            do it=1,ny_tpz-30
              hcst(i,j,it,ld)=ts4(it)
            enddo

          else

            do it=1,ny_tpz-30
              hcst(i,j,it,ld)=undef
            enddo
              stdf(i,j)=undef
              clmf(i,j)=undef
          endif
c           avgf(i,j)=0.
c           do it=its_hcst,ite_hcst
c           avgf(i,j)=avgf(i,j)+hcst(i,j,it,ld)/
c    &float(ny_hcst)
c           enddo
c         else
c           avgf(i,j)=undef
c         endif
c       enddo
c       enddo

c       do i=1,imx
c       do j=1,jmx
c         if (fld(i,j).gt.-900.) then
c           stdf(i,j)=0.
c           do it=its_hcst,ite_hcst
c           stdf(i,j)=stdf(i,j)+
c    &      (hcst(i,j,it,ld)-avgf(i,j))**2
c           enddo
c           stdf(i,j)=sqrt(stdf(i,j)/float(ny_hcst))

c           if(stdf(i,j).lt.0.01) stdf(i,j)=0.01

c         else
c           stdf(i,j)=undef
c         endif

        enddo
        enddo
c
c standardized fcsts
      do i=1,imx
      do j=1,jmx
      if (fld(i,j).gt.-900.) then
c       fcst(i,j,ld)=(fcst(i,j,ld)-avgf(i,j))/stdf(i,j)
        fcst(i,j,ld)=(fcst(i,j,ld)-clmf(i,j))/stdf(i,j)
      else
        fcst(i,j,ld)=undef
      endif
      enddo
      enddo

      enddo ! ld loop
c
c== temporal skill
      DO ld=1,nlead

      DO i=1,imx
      DO j=1,jmx
c
      if(fld(i,j).gt.-900.) then
        ir=0
        do it=its_hcst,ite_hcst

        ir=ir+1
          ts1(ir)=vfld(i,j,it,ld)
          ts2(ir)=hcst(i,j,it,ld)
        enddo
        call cor_rms(ts1,ts2,nyr,ny_hcst,cor3d(i,j,ld),rms3d(i,j,ld))
        call hss3c_t(ts1,ts2,nyr,ny_hcst,hss3d(i,j,ld))
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
      do iy=its_hcst,ite_hcst

        do i=1,imx
        do j=1,jmx
        w2d(i,j)=vfld(i,j,iy,ld)
        w2d2(i,j)=hcst(i,j,iy,ld)
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
c write out obs and hcst
        iw=0
        do ld=1,nlead

        do it=its_hcst,ite_hcst

          do i=1,imx
          do j=1,jmx
            w2d(i,j)=vfld(i,j,it,ld)
          enddo
          enddo
          iw=iw+1
          write(32,rec=iw) w2d

          do i=1,imx
          do j=1,jmx
            w2d(i,j)=hcst(i,j,it,ld)
          enddo
          enddo
          iw=iw+1
          write(32,rec=iw) w2d

          if(it.gt.0.and.it.le.10) md=1
          if(it.gt.10.and.it.le.20) md=2
          if(it.gt.20.and.it.le.30) md=3
          if(it.gt.30.and.it.le.40) md=4
          if(it.gt.40.and.it.le.50) md=5
          if(it.gt.50.and.it.le.60) md=6
          if(it.gt.60.and.it.le.70) md=7

          do i=1,imx
          do j=1,jmx
            w2d(i,j)=stdo(i,j,md,ld)
          enddo
          enddo
          iw=iw+1
          write(32,rec=iw) w2d

      enddo 
      enddo ! ld loop
c write out fcst and skill_t
        iw=0
        ny_prd=ny_hcst+1

      do ld=1,nlead
         do i=1,imx
         do j=1,jmx
           w2d(i,j)=fcst(i,j,ld)
           w2d2(i,j)=stdo(i,j,nwmo-2,ld)
           w2d3(i,j)=cor3d(i,j,ld)
           w2d4(i,j)=rms3d(i,j,ld)
           w2d5(i,j)=hss3d(i,j,ld)

          if(ny_prd.ge.31.and.it.lt.41) md=1 ! 32-42 for skiping 1950
          if(ny_prd.gt.41.and.it.lt.51) md=2
          if(ny_prd.gt.51.and.it.lt.61) md=3
          if(ny_prd.gt.61.and.it.lt.71) md=4
          if(ny_prd.gt.71.and.it.lt.81) md=5
          if(ny_prd.gt.81.and.it.lt.91) md=6
          if(ny_prd.gt.91.and.it.lt.101) md=7

           w2d6(i,j)=tpzc(i,j,md,ld)
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


      SUBROUTINE clim_wmo(ts,cc,maxt,its,ite)
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

      SUBROUTINE wmo_clim_tot(ts,clm,maxt,nwmo)
      DIMENSION ts(maxt),clm(nwmo)

      do id=1,nwmo ! 51-80,61-90,71-00,81-10,91-20

      its=(id-1)*10+1 
      ite=(id-1)*10+30 

      cc=0.
      do i=its,ite
        cc=cc+ts(i)
      enddo

      clm(id)=cc/30.

      enddo

      return
      end

      SUBROUTINE wmo_clm_std_anom(ts,std,clm,anom,maxt,nt,nwmo)
C WMO std, clm, and anom
      DIMENSION ts(maxt),anom(maxt),std(nwmo),clm(nwmo)
C have WMO std and clm
      do id=1,nwmo ! 51-80,61-90,71-00,81-10,91-20

      its=(id-1)*10+1 
      ite=(id-1)*10+30

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
c
      do i=1,30 
        anom(i)=(ts(i)-clm(1))/std(1)
      enddo

      do id=1,nwmo-1 ! 81-90,91-00,01-10,11-20,21-cur
        its=30+(id-1)*10+1 
        ite=30+id*10
        do i=its,ite
          anom(i)=(ts(i)-clm(id))/std(id)
        enddo
      enddo

      its=30+(nwmo-1)*10+1
      ite=nt

      do i=its,ite
        anom(i)=(ts(i)-clm(nwmo))/std(nwmo)
      enddo

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
