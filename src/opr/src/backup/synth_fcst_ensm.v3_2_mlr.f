      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C Synthesize fcsts from different models
C Pattern correction with EOF_obs is applied
C input NOT standardized 
C===========================================================
      parameter(kpdf=1000)

      real prd(imx,jmx,mlead,nprd)

      real stdo(imx,jmx,nwmo)
      real clmo(imx,jmx,nwmo)

      real stdf(imx,jmx,nwmo)
      real clmf(imx,jmx,nwmo)

      real cvcor(imx,jmx,nprd)
      real cvrms(imx,jmx,nprd)
      
      real hcst(imx,jmx,ny_hcst,nprd)

      real eprd(imx,jmx),ecor(imx,jmx)
      real erms(imx,jmx),ehss(imx,jmx)

      real avg_o(imx,jmx),std_o(imx,jmx)
      real avg_f(imx,jmx),std_f(imx,jmx)
      real rpss(imx,jmx)

      real obs(imx,jmx,ny_hcst),ehcst(imx,jmx,ny_hcst)

      real v3c(imx,jmx,ny_hcst) ! obs in 3C
      real prbhcst(imx,jmx,ny_hcst)
      real xn34(ny_hcst+1,mlead)

      real w1d(nprd),w1d2(nprd),w1d3(nprd),w1d4(nprd)
      real ts1(ny_hcst),ts2(ny_hcst),ts3(ny_hcst),ts4(ny_hcst)

      real pp(nprd,ny_hcst),wt1d(nprd)

      real w2d(imx,jmx),w2d2(imx,jmx),w2d3(imx,jmx)
      real w2d4(imx,jmx),w2d5(imx,jmx),w2d6(imx,jmx)
      real w2d7(imx,jmx)

      real xlat(jmx),coslat(jmx),cosr(jmx)

      real xbin(kpdf),ypdf(kpdf),prbprd(imx,jmx)
      real pa(imx,jmx,ny_hcst),pb(imx,jmx,ny_hcst),pn(imx,jmx,ny_hcst)
      real xpa(imx,jmx),xpb(imx,jmx),xpn(imx,jmx)

      real frac(imx,jmx)

      real fld3d(imx,jmx,ny_hcst+1)
      real fld3d2(imx,jmx,ny_hcst)
      real wstd(nwmo),wclm(nwmo)
C
C fcst from vpz,sst, olr, slp
      open(11,form='unformatted',access='direct',recl=4*imx*jmx) 
      open(12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(13,form='unformatted',access='direct',recl=4*imx*jmx)
      open(14,form='unformatted',access='direct',recl=4*imx*jmx) 
      open(15,form='unformatted',access='direct',recl=4*imx*jmx) 
      open(16,form='unformatted',access='direct',recl=4*imx*jmx) 
      open(17,form='unformatted',access='direct',recl=4*imx*jmx)
      open(18,form='unformatted',access='direct',recl=4*imx*jmx) 
      open(19,form='unformatted',access='direct',recl=4*imx*jmx) 
      open(20,form='unformatted',access='direct',recl=4*imx*jmx)

      open(22,form='unformatted',access='direct',recl=4) !nino34
      open(23,form='unformatted',access='direct',recl=4*imx*jmx) !frac
C synth output
      open(31,form='unformatted',access='direct',recl=4*imx*jmx) !fcst
      open(32,form='unformatted',access='direct',recl=4*imx*jmx) !hcst
      open(33,form='unformatted',access='direct',recl=4) !1d_skill
      open(34,form='unformatted',access='direct',recl=4*imx*jmx) !obs&v3c
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-89.5+(j-1)*1.
        coslat(j)=cos(xlat(j)*3.14159/180) 
        cosr(j)=sqrt(coslat(j))
      enddo

      xdel=10./float(kpdf)

c     call pdf_tab(xbin,ypdf,xdel,kpdf)
      call pdf_tab_general(1.,0.,xbin,ypdf,xdel,kpdf)
C
C read in nino3.4 index
      ir=0
      do ld=1,mlead
      do it=1,ny_hcst+1
      ir=ir+1
      read(22,rec=ir) xn34(it,ld)
      enddo
      enddo

C=== read in fcst 
      ich=10
      do ip=1,nprd 
      ich=ich+1

      ir=0
      do ld=1,mlead

        ir=ir+1
        read(ich,rec=ir) w2d

        do i=1,imx
        do j=1,jmx
          prd(i,j,ld,ip)=w2d(i,j)
        enddo
        enddo

      enddo ! ld loop
      enddo ! ip loop
c

C=== read in hcst

      iw=0
      iw2=0
      iw3=0

      ir=0

      do ld=1,mlead

      do it=1,ny_hcst

      ich=15
      do ip=1,nprd 
      ich=ich+1

        ir1=ir+1
        read(ich,rec=ir1) w2d
        ir2=ir+2
        read(ich,rec=ir2) w2d2

        do i=1,imx
        do j=1,jmx
          if(ip.eq.1) obs(i,j,it)=w2d(i,j) 
          hcst(i,j,it,ip)=w2d2(i,j)
c         hcst(i,j,it,1)=w2d(i,j) ! for testing get_mlr_wt 
        enddo
        enddo
      enddo ! ip loop

      ir=ir+2
c     ir=ir+4
      enddo ! it loopo

C have weighted eprd 
      do i=1,imx
      do j=1,jmx

      if (obs(i,j,1).gt.-900.and.hcst(i,j,1,1).gt.-900) then
        do it=1,ny_hcst
          ts1(it)=obs(i,j,it)
          do ip=1,nprd
            pp(ip,it)=hcst(i,j,it,ip)
          enddo
        enddo

        call get_mlr_wt(ts1,pp,wt1d,nprd,ny_hcst,ny_hcst,ridge)

        do ip=1,nprd
          w1d(ip)=prd(i,j,ld,ip)
        enddo

        call wtavg(w1d,wt1d,nprd,eprd(i,j))

      else

        eprd(i,j)=undef

      endif

      enddo
      enddo


C have CV-weighted hcst

      do i=1,imx
      do j=1,jmx

      do itgt=1,ny_hcst

      if (obs(i,j,1).gt.-900.and.hcst(i,j,1,1).gt.-900) then

        jr=0
        do iy=1,ny_hcst

        if(iy.eq.itgt) go to 555

        jr=jr+1

          ts1(jr)=obs(i,j,iy)
          do ip=1,nprd
            pp(ip,jr)=hcst(i,j,iy,ip)
          enddo

  555   continue

        enddo ! iy loop

        nym=ny_hcst-1
        call get_mlr_wt(ts1,pp,wt1d,nprd,ny_hcst,nym,ridge)

        do ip=1,nprd
          w1d(ip)=hcst(i,j,itgt,ip)
        enddo

        call wtavg(w1d,wt1d,nprd,ehcst(i,j,itgt))

      else

        ehcst(i,j,itgt)=undef

      endif

      enddo ! itgt loop

      enddo
      enddo

C WMO anom of OBS & ehcst

c OBS
      do i=1,imx
      do j=1,jmx
        if (obs(i,j,1).gt.-900.) then

            do it=1,ny_hcst
              ts1(it)=obs(i,j,it)
            enddo

          call wmo_clm_std_anom(ts1,wstd,wclm,ts2,ny_hcst,ny_hcst,nwmo)

            do ii=1,nwmo
              stdo(i,j,ii)=wstd(ii)
              clmo(i,j,ii)=wclm(ii)
            enddo

            do it=1,ny_tpz
              obs(i,j,it)=ts2(it)
            enddo

          else

            do ii=1,nwmo
              stdo(i,j,ii)=undef
              clmo(i,j,ii)=undef
            enddo

            do it=1,ny_tpz
              obs(i,j,it)=undef
            enddo

          endif
        enddo
        enddo

c ehcst
        do i=1,imx
        do j=1,jmx

          if (ehcst(i,j,1).gt.-900.) then

          do it=1,ny_hcst
            ts1(it)=ehcst(i,j,it)
          enddo

          call wmo_clm_std_anom(ts1,wstd,wclm,ts2,ny_hcst,ny_hcst,nwmo)

          do ii=1,nwmo
            stdf(i,j,ii)=wstd(ii)
            clmf(i,j,ii)=wclm(ii)
          enddo

          do it=1,ny_hcst
            ehcst(i,j,it)=ts2(it)
          enddo

          else

          do it=1,ny_hcst
            ehcst(i,j,it)=undef
          enddo

          do ii=1,nwmo
            stdf(i,j,ii)=undef
            clmf(i,j,ii)=undef
          enddo

        endif

       enddo
       enddo

C write out ehcst, prob-hcst and 1-D skill

c     DO it=1,ny_hcst
      DO it=its_skill,ny_hcst ! its_skill=31 for from 1981

      do i=1,imx
      do j=1,jmx

        w2d(i,j)=obs(i,j,it)
        w2d2(i,j)=ehcst(i,j,it)
c prob-hcst
      if (w2d2(i,j).gt.-900.and.w2d(i,j).gt.-900) then

        w2d(i,j)=obs(i,j,it) 
        w2d2(i,j)=ehcst(i,j,it)

        call prob_3c_prd(w2d2(i,j),prbprd(i,j),
     &pa(i,j,it),pb(i,j,it),pn(i,j,it),kpdf,xbin,xdel,ypdf,frac(i,j))   

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

      call have_iwmo(it,nwmo,iwmo)
c     write(6,*) 'iwmo=',iwmo

        do i=1,imx
        do j=1,jmx
          w2d6(i,j)=stdo(i,j,iwmo)
          w2d7(i,j)=stdf(i,j,iwmo)
        enddo
        enddo


      iw2=iw2+1
      write(32,rec=iw2) w2d ! stdized obs
      iw2=iw2+1
      write(32,rec=iw2) w2d2  ! stdized ehcst
      iw2=iw2+1
      write(32,rec=iw2) prbprd  ! prob-prd
      iw2=iw2+1
      write(32,rec=iw2) w2d3  ! prob_a
      iw2=iw2+1
      write(32,rec=iw2) w2d4  ! prob_b
      iw2=iw2+1
      write(32,rec=iw2) w2d6 ! stdo
      iw2=iw2+1
      write(32,rec=iw2) w2d7 ! stdf

C 1-D skill

      call sp_cor_rms(w2d2,w2d,coslat,imx,jmx,
     &1,360,40,165,xcor,xrms)

      iw3=iw3+1
      write(33,rec=iw3) xcor
      iw3=iw3+1
      write(33,rec=iw3) xrms

      call sp_cor_rms(w2d,w2d2,coslat,imx,jmx,
     &230,300,115,140,xcor,xrms)
      iw3=iw3+1
      write(33,rec=iw3) xcor
      iw3=iw3+1
      write(33,rec=iw3) xrms

      do i=1,imx
      do j=1,jmx
      w2d2(i,j)=pb(i,j,it)
      w2d3(i,j)=pa(i,j,it)
      enddo
      enddo

      call hss3c_prob_s(w2d,w2d3,w2d2,imx,jmx,1,360,40,165,coslat,h1)
      call hss3c_prob_s(w2d,w2d3,w2d2,imx,jmx,230,300,115,140,
     &coslat,h2)

      iw3=iw3+1
      write(33,rec=iw3) h1
      iw3=iw3+1
      write(33,rec=iw3) h2

      call rpss_s(w2d,w2d2,w2d3,rpss1,imx,jmx,1,360,40,165,coslat)
      call rpss_s(w2d,w2d2,w2d3,rpss2,imx,jmx,230,300,115,140,coslat)

      iw3=iw3+1
      write(33,rec=iw3) rpss1
      iw3=iw3+1
      write(33,rec=iw3) rpss2

      enddo ! it loop

c temporal 2D skill calculation

      do i=1,imx
      do j=1,jmx

      IF (obs(i,j,1).gt.-900.) then

        nskip_y=its_skill-1
        do it=its_skill,ny_hcst
          ts1(it-nskip_y)=obs(i,j,it)
          ts2(it-nskip_y)=ehcst(i,j,it)
          ts3(it-nskip_y)=pa(i,j,it)
          ts4(it-nskip_y)=pb(i,j,it)
        enddo

        call cor_rms(ts1,ts2,ny_hcst,ny_skill,ecor(i,j),erms(i,j))

        if(std_f(i,j).gt.0.1) then
          call hss3c_prob_t(ts1,ts3,ts4,ny_hcst,ny_skill,ehss(i,j))
        else
          call hss3c_t(ts1,ts2,ny_hcst,ny_skill,ehss(i,j))
        endif

        ELSE

        ecor(i,j)=undef
        erms(i,j)=undef
        ehss(i,j)=undef

        ENDIF

      w2d(i,j)=stdo(i,j,nwmo)
      w2d2(i,j)=clmo(i,j,nwmo)

      enddo
      enddo

      do i=1,imx
      do j=1,jmx

      if (obs(i,j,1).gt.-900.) then
        eprd(i,j)=(eprd(i,j)-clmf(i,j,nwmo))/stdf(i,j,nwmo)
      else
        eprd(i,j)=undef
      endif

      enddo
      enddo

      iw=iw+1
      write(31,rec=iw) eprd
      iw=iw+1
      write(31,rec=iw) w2d
      iw=iw+1
      write(31,rec=iw) ecor
      iw=iw+1
      write(31,rec=iw) erms
      iw=iw+1
      write(31,rec=iw) ehss
      iw=iw+1
      write(31,rec=iw) w2d2

c have prob forecast
c
      do i=1,imx
      do j=1,jmx

      if (eprd(i,j).gt.-900.) then

        call prob_3c_prd(eprd(i,j),prbprd(i,j),
     &xpa(i,j),xpb(i,j),xpn(i,j),kpdf,xbin,xdel,ypdf,frac(i,j))

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
      write(31,rec=iw) prbprd
      iw=iw+1
      write(31,rec=iw) xpa
      iw=iw+1
      write(31,rec=iw) xpb
      iw=iw+1
      write(31,rec=iw) xpn

      call rpss_t(obs,pb,pa,w2d,v3c,imx,jmx,its_skill,ny_hcst,undef)

      iw=iw+1
      write(31,rec=iw) w2d

c write out obs & v3c
      do it=its_skill,ny_hcst

        do i=1,imx
        do j=1,jmx
          w2d(i,j)=obs(i,j,it)
          w2d2(i,j)=v3c(i,j,it)
        enddo
        enddo

        iw4=iw4+1
        write(34,rec=iw4) w2d
        iw4=iw4+1
        write(34,rec=iw4) w2d2

      enddo ! it loop

      enddo ! ld loop
C
      stop
      end

      SUBROUTINE have_iwmo(it,nwmo,iwmo)

      iwmo=1 ! for it <= 30

      do id=1,nwmo-1
        its=30+(id-1)*10+1 ! for 1951-curr data 
        ite=30+id*10
        if(it.ge.its.and.it.le.ite) iwmo=id
      enddo

      its=30+(nwmo-1)*10
      if(it.ge.its) iwmo=nwmo

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

      SUBROUTINE pat_crct(fld3d,prd,cosr,nmod,imx,jmx,nt,ngrd,
     &idx,jdy,is,ie,js,je,undef)
C
      real fld3d(imx,jmx,nt)
      real corr(imx,jmx,nmod),regr(imx,jmx,nmod)
      real pc(nmod,nt)
      real prd(imx,jmx),avg(imx,jmx)
      real w2d(imx,jmx)
      real ts(nt)
      real cosr(jmx)
C
C EOF filter eprd
      do i=1,imx
      do j=1,jmx

        if(prd(i,j).gt.-900) then

        do it=1,nt
          ts(it)=fld3d(i,j,it)
        enddo

        call mean_anom(ts,nt,nt,avg(i,j))

        do it=1,nt
          fld3d(i,j,it)=ts(it)
        enddo

        endif

      enddo
      enddo

       call eof_pc(fld3d,cosr,nt,nt,ngrd,nmod,undef,
     &imx,jmx,idx,jdy,is,ie,js,je,pc,corr,regr,0)

c reconstrct prd

      call setzero(w2d,imx,jmx)

      do i=1,imx
      do j=1,jmx

        if(prd(i,j).gt.-900.) then

          do m=1,nmod
            w2d(i,j)=w2d(i,j)+pc(m,nt)*regr(i,j,m)
          enddo

          w2d(i,j)=w2d(i,j)+avg(i,j)

        else
          w2d(i,j)=undef
        endif

        prd(i,j)=w2d(i,j)

      enddo
      enddo

      return
      end


      SUBROUTINE rpss_s(vfc,pb,pa,rpss,imx,jmx,is,ie,js,je,coslat)

      real pa(imx,jmx),pb(imx,jmx)
      real vfc(imx,jmx),coslat(jmx)
      real rps(imx,jmx),rpsc(imx,jmx)

      do i=is,ie
      do j=js,je
        IF(vfc(i,j).gt.-900) then
c       IF(pa(i,j).gt.-900.and.pb(i,j).gt.-900) then

          va=0.
          vb=0.
          vn=0.
          if(vfc(i,j).gt.0.43) va=1
          if(vfc(i,j).lt.-0.43) vb=1
          if(vfc(i,j).ge.-0.43.and.vfc(i,j).le.0.43) vn=1
c have rps        
          pn=1.- pa(i,j) - pb(i,j)

          if(abs(pn).gt.100) then
c           write(6,*) 'pn i,j=', pn,i,j
c           write(6,*) 'pa i,j=', pa(i,j),i,j
c           write(6,*) 'pb i,j=', pb(i,j),i,j
          endif

          y1=pb(i,j)
          y2=pb(i,j)+pn
          y3=1.
          o1=vb
          o2=vb+vn
          o3=1.
          rps(i,j)=(y1 - o1)**2 !rps
     &+(y2 - o2)**2
          rpsc(i,j)=(1./3.- o1)**2 !rpsc
     &+(2./3.- o2)**2
        END IF
      enddo
      enddo
c area avg
        exp=0.
        expc=0.
        grd=0
        do i=is,ie
        do j=js,je
          IF(vfc(i,j).gt.-900) then
            exp=exp+coslat(j)*rps(i,j)
            expc=expc+coslat(j)*rpsc(i,j)
            grd=grd+coslat(j)
          END IF
        enddo
        enddo
        exp_rps=exp/grd
        exp_rpsc=expc/grd
        rpss=1.- exp_rps/exp_rpsc
      return
      end

      SUBROUTINE rpss_t(vfc,pb,pa,rpss,v3c,imx,jmx,its,nt,undef)

      real pa(imx,jmx,nt),pb(imx,jmx,nt)
      real vfc(imx,jmx,nt),rpss(imx,jmx)
      real rps(imx,jmx,nt),rpsc(imx,jmx,nt)
      real v3c(imx,jmx,nt)

c convert vfc to probilistic form
      do it=its,nt
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
        do it=its,nt
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

      SUBROUTINE prob_3c_general(sd,detp,prbp,pa,pb,pn,kpdf,xbin,xdel,
     &ypdf,frac)
c detp: deterministic prd
c prbp: problistic prd

      real xbin(kpdf),ypdf(kpdf)

      esm=frac*detp

      call pdf_tab_general(sd,esm,xbin,ypdf,xdel,kpdf)

      b1=-0.43
      b2= 0.43
c
      n1=kpdf/2+int(b1/xdel)
      n2=kpdf/2+int(b2/xdel)+1

      call prob_3c(kpdf,n1,n2,xbin,xdel,ypdf,pb,pa,pn)

      if(detp.gt.0) then
        prbp=pa
      else
        prbp=-pb
      endif

      return
      end

      SUBROUTINE weights_2(rms,n,wts)
      dimension rms(n),wts(n) 

C== have denominator of the weights
      wd=0
      do i=1,n
          wd=wd+1/rms(i)**2
      enddo
C
C== have weights
        do i=1,n
          wts(i)=(1/rms(i)**2)/wd
        enddo

      return
      end

      SUBROUTINE weights(rms,n,wts)
      dimension rms(n),wts(n) 

C== have denominator of the weights
      wd=0
      do i=1,n
        wd=wd+1./rms(i)**2
      enddo
C
C== have weights
      do i=1,n
        wts(i)=1./rms(i)**2/wd
      enddo

      return
      end

      SUBROUTINE wtavg(x,wts,n,avg)
      dimension x(n),wts(n) 
      avg=0
      do i=1,n
      avg=avg+x(i)*wts(i)
      enddo

      return
      end


      SUBROUTINE hss3c_s(obs,prd,imx,jmx,is,ie,js,je,coslat,hs)
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
      hs=(h-tot/3.)/(tot-tot/3.)*100.

      return
      end

      SUBROUTINE hss3c_prob_s(obs,pa,pb,imx,jmx,is,ie,js,je,coslat,hs)
      dimension obs(imx,jmx),pa(imx,jmx),pb(imx,jmx)
      dimension nobs(imx,jmx),nprd(imx,jmx)
      dimension coslat(jmx)
      dimension w1d(3)

      do i=is,ie
      do j=js,je
        if(obs(i,j).gt.-900.and.pa(i,j).gt.-900) then

          if(obs(i,j).gt.0.43) nobs(i,j)=1
          if(obs(i,j).lt.-0.43) nobs(i,j)=-1
          if(obs(i,j).ge.-0.43.and.obs(i,j).le.0.43) nobs(i,j)=0


          w1d(3)=pa(i,j)
          w1d(1)=pb(i,j)
          w1d(2)=1.- pa(i,j)-pb(i,j)
          maxp = maxloc(w1d,1)

          if(maxp.eq.3) nprd(i,j)=1
          if(maxp.eq.1) nprd(i,j)=-1
          if(maxp.eq.2) nprd(i,j)=0

        endif
      enddo
      enddo

      h=0.
      tot=0.
      do i=is,ie
      do j=js,je
        if(obs(i,j).gt.-900..and.pa(i,j).gt.-900.) then
        tot=tot+coslat(j)
        if (nobs(i,j).eq.nprd(i,j)) h=h+coslat(j)
        endif
      enddo
      enddo
      hs=(h-tot/3.)/(tot-tot/3.)*100.

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
      SUBROUTINE normal_0avg(rot,nt,mt,sd)
      DIMENSION rot(nt)
      avg=0.
      do i=1,mt
c        avg=avg+rot(i)/float(mt)
      enddo
      do i=1,nt
        rot(i)=rot(i)-avg
      enddo
c
      sd=0.
      do i=1,mt
        sd=sd+rot(i)*rot(i)/float(mt)
      enddo
        sd=sqrt(sd)
      do i=1,nt
        rot(i)=rot(i)/sd
      enddo
      return
      end

      SUBROUTINE normal(rot,nt,mt,sd)
      DIMENSION rot(nt)
      avg=0.
      do i=1,mt
         avg=avg+rot(i)/float(mt)
      enddo
      do i=1,nt
        rot(i)=rot(i)-avg
      enddo
c
      sd=0.
      do i=1,mt
        sd=sd+rot(i)*rot(i)/float(mt)
      enddo
        sd=sqrt(sd)
      do i=1,nt
        rot(i)=rot(i)/sd
      enddo
      return
      end

      SUBROUTINE mean_std(s,nt,mt,avg,std)
      DIMENSION s(nt),w(mt)
      avg=0
      do i=1,mt
         avg=avg+s(i)/float(mt)
      enddo

      do i=1,mt
        w(i)=s(i)-avg
      enddo
c
      sd=0.
      do i=1,mt
        sd=sd+w(i)*w(i)
      enddo

      std=sqrt(sd/float(mt))

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
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine ltrend(grid,out,out2,imx,jmx,nt,its,ite,a,b)
      dimension grid(imx,jmx,nt),out(imx,jmx,nt)
      dimension out2(imx,jmx,nt)
      dimension a(imx,jmx),b(imx,jmx)
      real lxx, lxy
c
      do i=1,imx
      do j=1,jmx
c
      if(grid(i,j,1).gt.-900) then
c
      xb=0
      yb=0
      do it=its,ite
        xb=xb+float(it)/float(ite-its+1)
        yb=yb+grid(i,j,it)/float(ite-its+1)
      enddo
c
      lxx=0.
      lxy=0.
      do it=its,ite
      lxx=lxx+(it-xb)*(it-xb)
      lxy=lxy+(it-xb)*(grid(i,j,it)-yb)
      enddo
      b(i,j)=lxy/lxx
      a(i,j)=yb-b(i,j)*xb

      else
      a(i,j)=-999.0
      b(i,j)=-999.0
      endif

      enddo !over j
      enddo !over i
c
      do i=1,imx
      do j=1,jmx
      do it=1,nt

      if(grid(i,j,1).gt.-900) then
        out(i,j,it)=grid(i,j,it)-b(i,j)*float(it)-a(i,j) !detrended
        out2(i,j,it)=b(i,j)*float(it)+a(i,j) !trend
      else
        out(i,j,it)=-999.0
        out2(i,j,it)=-999.0
      endif

      enddo
      enddo
      enddo
c
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

      SUBROUTINE hss3c_prob_t(obs,pa,pb,ny,nt,hs)
      dimension obs(ny),pa(ny),pb(ny)
      dimension nobs(ny),nprd(ny)
      dimension w1d(3)
      do it=1,nt
        if(obs(it).gt.0.43) nobs(it)=1
        if(obs(it).lt.-0.43) nobs(it)=-1
        if(obs(it).ge.-0.43.and.obs(it).le.0.43) nobs(it)=0

        w1d(3)=pa(it)
        w1d(1)=pb(it)
        w1d(2)=1.- pa(it)-pb(it)
        maxp = maxloc(w1d,1)

          if(maxp.eq.3) nprd(it)=1
          if(maxp.eq.1) nprd(it)=-1
          if(maxp.eq.2) nprd(it)=0
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

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  calculate normal distribution PDF from -5 to 5 (unit=std)
C  have it as a table for later integration
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine pdf_tab(xx,yy,xde,n)
      real xx(n),yy(n)
      pi=3.14159
      coef=1./sqrt(2*pi)
c     xde=0.1
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

      subroutine eof_pc(fin,cosr,ntot,nt,ng,nmod,undef,
     &im,jm,idx,idy,is,ie,js,je,pc,cor,reg,id)
c
      dimension fin(im,jm,ntot),cosr(jm)
      dimension aaa(ng,nt),wk(nt,ng)
      dimension eval(nt),evec(ng,nt),coef(nt,nt)
      dimension pc(nmod,ntot)

      dimension ts1(nt),ts2(nt)
      dimension cor(im,jm,nmod),reg(im,jm,nmod)

      real weval(nt),wevec(ng,nt),wcoef(nt,nt)
      real reval(nmod),revec(ng,nmod),rcoef(nmod,nt)
      real tt(nmod,nmod),rwk(ng),rwk2(ng,nmod)
c
c select grid data
      do it=1,nt
        ig=0
        do i=is,ie,idx
        do j=js,je,idy
        if(fin(i,j,1).gt.undef) then
        ig=ig+1
        aaa(ig,it)=cosr(j)*fin(i,j,it)
        endif
        enddo
        enddo
      enddo
c     print *, 'ngrd=',ig
C EOF analysis
      call eofs(aaa,ng,nt,nt,eval,evec,coef,wk,id)
c     do km = 1, 10
c       write  (6,*)  'km=',km,' eval=',eval(km)
c     enddo
c     call REOFS(aaa,ng,nt,nt,wk,id,weval,wevec,wcoef,
c    &           nmod,reval,revec,rcoef,tt,rwk,rwk2)
C
C normalize rpc and have cor&reg patterns
      do m=1,nmod
        do it=1,nt
c         ts1(it)=rcoef(m,it)
          ts1(it)=coef(m,it)
        enddo

        call normal(ts1,nt,nt,sd)

        do it=1,nt
          pc(m,it)=ts1(it)
        enddo
c
        do j=1,jm
        do i=1,im

        if(fin(i,j,1).gt.undef) then

        do it=1,nt
          ts2(it)=fin(i,j,it)
        enddo

        call regr_t(ts1,ts2,nt,nt,cor(i,j,m),reg(i,j,m))

        else

        cor(i,j,m)=undef
        reg(i,j,m)=undef

        endif

        enddo
        enddo
      enddo  ! m loop

      return
      end

      SUBROUTINE mean_anom(s,nt,mt,avg)
      DIMENSION s(nt)
      avg=0
      do i=1,mt
         avg=avg+s(i)/float(mt)
      enddo

      do i=1,mt
        s(i)=s(i)-avg
      enddo
c
      return
      end
