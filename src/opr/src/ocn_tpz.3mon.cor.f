      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C PCR for forecst TPZ
C===========================================================
      real tpzc(imx,jmx,ndec)
      real fld(imx,jmx)
      real corr2(imx,jmx,nyr),regr2(imx,jmx,nyr,nyr)
      real corr3(imx,jmx,nyr),regr3(imx,jmx,nyr)
      real cor3d(imx,jmx,nlead),rms3d(imx,jmx,nlead)
      real cvcor(imx,jmx,nyr,nlead)
      real hss3d(imx,jmx,nlead)
      real ts1(nyr),ts2(nyr)
      real w2d(imx,jmx),w2d2(imx,jmx),w2d3(imx,jmx)
      real w2d4(imx,jmx),w2d5(imx,jmx),w2d6(imx,jmx)
      real tpz(imx,jmx,montot),wtpz(imx,jmx,nyr)
      real av2(imx,jmx),bv2(imx,jmx)
      real hcst(imx,jmx,nyr,nlead)
      real fcst(imx,jmx,nlead)
      real avgo(imx,jmx),avgf(imx,jmx)
      real stdo(imx,jmx,nlead),stdf(imx,jmx,nlead)
      real wtfcst(imx,jmx,nlead)
      real vfld(imx,jmx,nyr,nlead)
      real xn34(nyr)
      real xlat(jmx),coslat(jmx),cosr(jmx)
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
          wtpz(i,j,ir)=tpz(i,j,it)
        enddo
        enddo
        enddo ! it loop
      ny_tpz=ir
      write(6,*) 'its_tpz=',its_tpz,'ny_tpz=',ny_tpz
C 
C have WMO clim 51-80, 61-90, 71-00, 81-10, 91-20 ...
      mdec = ny_tpz/10 - 2 ! # of WMO clim from 1950
      write(6,*) 'mdec=',mdec

      do idec=1,mdec

      its=(idec-1)*10+1
      ite=its+29

      do i=1,imx
      do j=1,jmx
        if(fld(i,j).gt.-900.) then
          do it=1,ny_tpz
            ts1(it)=wtpz(i,j,it)
          enddo
          call clim_wmo(ts1,tpzc(i,j,idec),nyr,its,ite)
        else
          tpzc(i,j,idec)=undef
        endif
      enddo
      enddo

      enddo ! idec loop
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
           avg=avg+wtpz(i,j,k)/float(kocn)
         enddo

         hcst(i,j,iy-30,ld)=avg-tpzc(i,j,idec)

         vfld(i,j,iy-30,ld)=wtpz(i,j,iy)-tpzc(i,j,idec)

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
           avg=avg+wtpz(i,j,k)/float(kocn)
         end do

         fcst(i,j,ld)=avg-tpzc(i,j,idec)

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
c std of obs
      its_hcst=1
      ite_hcst=ny_tpz-30
      ny_hcst=ite_hcst-its_hcst+1

      do ld=1,nlead

        do i=1,imx
        do j=1,jmx
          if (fld(i,j).gt.-900.) then
            avgo(i,j)=0.
            do it=its_hcst,ite_hcst
            avgo(i,j)=avgo(i,j)+vfld(i,j,it,ld)/float(ny_hcst)
            enddo
          else
            avgo(i,j)=undef
          endif
        enddo
        enddo

        do i=1,imx
        do j=1,jmx
          if (fld(i,j).gt.-900.) then
            stdo(i,j,ld)=0.
            do it=its_hcst,ite_hcst
            stdo(i,j,ld)=stdo(i,j,ld)+
     &      (vfld(i,j,it,ld)-avgo(i,j))**2
            enddo
            stdo(i,j,ld)=sqrt(stdo(i,j,ld)/float(ny_hcst))
          else
            stdo(i,j,ld)=undef
            endif
        enddo
        enddo
c
c std of hcst
        do i=1,imx
        do j=1,jmx
          if (fld(i,j).gt.-900.) then
            avgf(i,j)=0.
            do it=its_hcst,ite_hcst
            avgf(i,j)=avgf(i,j)+hcst(i,j,it,ld)/
     &float(ny_hcst)
            enddo
          else
            avgf(i,j)=undef
          endif
        enddo
        enddo

        do i=1,imx
        do j=1,jmx
          if (fld(i,j).gt.-900.) then
            stdf(i,j,ld)=0.
            do it=its_hcst,ite_hcst
            stdf(i,j,ld)=stdf(i,j,ld)+
     &      (hcst(i,j,it,ld)-avgf(i,j))**2
            enddo
            stdf(i,j,ld)=sqrt(stdf(i,j,ld)/float(ny_hcst))
          else
            stdf(i,j,ld)=undef
          endif
        enddo
        enddo
c
c deal with "too small" std
        do i=1,imx
        do j=1,jmx
          if(fld(i,j).gt.-900) then
            if(stdo(i,j,ld).lt.0.01) then
              stdo(i,j,ld)=0.01
            endif
            if(stdf(i,j,ld).lt.0.01) then
              stdf(i,j,ld)=0.01
            endif
          endif
        enddo
        enddo
c        
c standardized hcst
      do i=1,imx
      do j=1,jmx
      do it=its_hcst,ite_hcst
      if (fld(i,j).gt.-900.) then
        vfld(i,j,it,ld)=(vfld(i,j,it,ld)-avgo(i,j))/stdo(i,j,ld)
        hcst(i,j,it,ld)=(hcst(i,j,it,ld)-avgf(i,j))/stdf(i,j,ld)
      else
        vfld(i,j,it,ld)=undef
        hcst(i,j,it,ld)=undef
      endif
      enddo
      enddo
      enddo
c
c standardized fcsts
      do i=1,imx
      do j=1,jmx
      if (fld(i,j).gt.-900.) then
        fcst(i,j,ld)=(fcst(i,j,ld)-avgf(i,j))/stdf(i,j,ld)
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
c CV corr skill of hcst
c
        do ld=1,nlead
        do itgt=1,ny_tpz

        iym=itgt-1
        iyp=itgt+1
        if(itgt.eq.1) iym=3
        if(itgt.eq.ny_tpz) iyp=ny_tpz-2

        do i=1,imx2
        do j=1,jmx2

        IF(fld(i,j).gt.-900.) then

          ir=0
          do iy=1,ny_tpz

          if(iy.eq.itgt) go to 777

          if(ncv.eq.3) then
            if(iy.eq.iym)  go to 777
            if(iy.eq.iyp)  go to 777
          endif

            ir=ir+1
            ts1(ir)=hcst(i,j,iy,ld)
            ts2(ir)=vfld(i,j,iy,ld)
  777     continue
          enddo

          nfld=ir
          call regr_t(ts1,ts2,nyr,nfld,cvcor(i,j,itgt,ld),w2d(i,j))

        ELSE

          cvcor(i,j,itgt,ld)=undef

        ENDIF

        enddo !i loop
        enddo !j loop

        enddo !itgt loop
        enddo !ld loop
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

          do i=1,imx
          do j=1,jmx
            w2d(i,j)=stdo(i,j,ld)
          enddo
          enddo
          iw=iw+1
          write(32,rec=iw) w2d

          do i=1,imx2
          do j=1,jmx2
            w2d(i,j)=cvcor(i,j,it,ld)
          enddo
          enddo
          iw=iw+1
          write(32,rec=iw) w2d

       enddo
       enddo ! ld loop
c write out fcst and skill_t
        iw=0
       do ld=1,nlead
         do i=1,imx
         do j=1,jmx
           w2d(i,j)=fcst(i,j,ld)
           w2d2(i,j)=stdo(i,j,ld)
           w2d3(i,j)=cor3d(i,j,ld)
           w2d4(i,j)=rms3d(i,j,ld)
           w2d5(i,j)=hss3d(i,j,ld)
c          w2d6(i,j)=tpzc(i,j,ld)
           w2d6(i,j)=tpzc(i,j,mdec)
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
