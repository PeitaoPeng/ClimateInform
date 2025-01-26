      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C PCR for forecst TPZ
C===========================================================
      real fld0(imx,jmx),fld(imx,jmx),fld1(imx,jmx),fldv1(imx,jmx)
      real sst(imx,jmx,nyr),w3dv1(imx,jmx,nyr)
      real sstc(imx,jmx),tpzc(imx2,jmx2),tpzc_tot(imx2,jmx2,nlead)
      real fic(imx,jmx)

      real fld2(imx2,jmx2)
      real cor3d(imx2,jmx2,nlead),rms3d(imx2,jmx2,nlead)
      real ac(imx2,jmx2,nyr,nlead,lagmax)
      real hss3d(imx2,jmx2,nlead)
      real ts1(nyr),ts2(nyr)
      real ts3(nyr),ts4(nyr)
      real ts5(nyr),ts6(nyr)
      real w2d(imx2,jmx2),w2d2(imx2,jmx2),w2d3(imx2,jmx2)
      real w2d4(imx2,jmx2),w2d5(imx2,jmx2),w2d6(imx2,jmx2)

      real rpc(mrpc,nyr),rpc2(mrpc,nyr)
      real pc(nyr,mpls),pco(mpls)
      real pt1(imx,jmx,mpls),pt2(imx,jmx,mpls)
      real xac(mrpc,mpls),xvar(mpls)
      real krpc(mrpc),kpls(mpls),wac(mpls)
      real mcho(mrpc)

      real rpcf(mrpc,nyr),rpcf2(mrpc,mpls,nyr)

      real corv2(imx2,jmx2,mrpc),regv2(imx2,jmx2,mrpc)
      real corv22(imx2,jmx2,mrpc),regv22(imx2,jmx2,mrpc)

      real tpz(imx2,jmx2,montot),wtpz(imx2,jmx2,nyr)
      real w3dv2(imx2,jmx2,nyr)

      real hcst(imx2,jmx2,nyr,nlead,lagmax)
      real wthcst(imx2,jmx2,nyr,nlead)
      real fcst(imx2,jmx2,nlead,lagmax)
      real wtd(imx2,jmx2,nyr,nlead),wts(imx2,jmx2,nyr,nlead,lagmax)
      real avgo(imx2,jmx2),avgf(imx2,jmx2)
      real stdo(imx2,jmx2,nlead),stdf(imx2,jmx2,nlead)
      real wtfcst(imx2,jmx2,nlead)
      real vfld(imx2,jmx2,nyr,nlead)
      real xn34(nyr)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real xlat2(jmx2),coslat2(jmx2),cosr2(jmx2)

C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !sst
      open(11,form='unformatted',access='direct',recl=4*imx2*jmx2) !tpz

      open(30,form='unformatted',access='direct',recl=4*imx2*jmx2) !fcst
      open(31,form='unformatted',access='direct',recl=4) !1d_skill
      open(32,form='unformatted',access='direct',recl=4*imx2*jmx2) !hcst

      open(33,form='unformatted',access='direct',recl=4*imx2*jmx2) !wts
      open(34,form='unformatted',access='direct',recl=4*imx2*jmx2) !regr

      open(40,form='unformatted',access='direct',recl=4*imx*jmx) !IC
      open(41,form='unformatted',access='direct',recl=4*imx*jmx) !pls
      open(42,form='unformatted',access='direct',recl=4*imx2*jmx2) !reof
      open(43,form='unformatted',access='direct',recl=4*nyr) !pls_ts

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

      undef=-999.0
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
c     lagmaxm=lagmax - 1
      lagmaxm=1
      DO ilag=1,lagmaxm ! =1 for lag=0
c     its_sst=icmon+lagmax-ilag+1 ! for mon sst
c     its_sst=icmon-2+lagmax-ilag+1 ! for 3-mon sst 11-2+12-1+1=21(son)
      its_sst=icmon+12-2-ilag+1 ! for 3-mon sst 11-2+12-1+1=21(son)

      ir=0
c     do it=its_sst,montot,12 ! for mon sst
      do it=its_sst,nsstot,12 ! for 3-mon sst
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
c
c write out sst_IC
      do i=1,imx
      do j=1,jmx
        fld(i,j)=sst(i,j,ny_sst)
      enddo
      enddo
      write(40,rec=ilag) fld
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

C REOF analysis of var2
      call reof_rpc(wtpz,cosr2,nyr,ny_tpz,ng2,mrpc,undef,
     &imx2,jmx2,id2,jd2,isv2,iev2,jsv2,jev2,rpc,corv2,regv2,ideof)
C 
C CV hcst for this lead
C
      DO itgt=1,ny_tpz

        iym=itgt-1
        iyp=itgt+1
        if(itgt.eq.1) iym=3
        if(itgt.eq.ny_tpz) iyp=ny_tpz-2

c have w3dv1
        ir=0
        do iy=1,ny_tpz

          if(iy.eq.itgt) go to 555

          if(ncv.eq.3) then
            if(iy.eq.iym)  go to 555
            if(iy.eq.iyp)  go to 555
          endif

          ir=ir+1
          do i=1,imx
          do j=1,jmx
            w3dv1(i,j,ir)=sst(i,j,iy)
          enddo
          enddo

  555   continue

        enddo ! iy loop

      nfld=ir

      do i=1,imx
      do j=1,jmx
        fic(i,j)=sst(i,j,itgt)
      enddo
      enddo

c have rpc of w3dv2
      ir=0
      do iy=1,ny_tpz

          if(iy.eq.itgt) go to 666

          if(ncv.eq.3) then
            if(iy.eq.iym)  go to 666
            if(iy.eq.iyp)  go to 666
          endif

          ir=ir+1
          do m=1,mrpc
            rpc2(m,ir)=rpc(m,iy)
          enddo
  666     continue

      enddo ! iy loop

      nfld=ir
c
c have lead-ld hcst for itgt yr with PLS

c hindcast var2 
      do m=1,mrpc

      do iy=1,nfld
        ts1(iy)=rpc2(m,iy)
      enddo

      call pls_ana(nyr,nfld,imx,jmx,isv1,iev1,jsv1,jev1,mpls,
     &ts1,w3dv1,fic,pc,pco,pt1,pt2,xvar,coslat,cor_crit,undef,idpls)

c
c compose rpcf for itgt
c
        rpcf(m,itgt)=0
        do n=1,mpls
          rpcf(m,itgt)=rpcf(m,itgt)+pco(n)
        enddo

        do n=1,mpls
        rpcf2(m,n,itgt)=0
          do k=1,n
          rpcf2(m,n,itgt)=rpcf2(m,n,itgt)+pco(k)
          enddo
        enddo

        enddo ! mrpc loop

      ENDDO ! itgt loop

c
c check the ac skill of rpc and choose predictable rpc and optimal mpls
      DO m=1,mrpc

      do n=1,mpls

      do it=1,ny_tpz
        ts1(it)=rpc(m,it)
        ts2(it)=rpcf2(m,n,it)
      enddo

      call ac_rms(ts1,ts2,nyr,ny_tpz,wac(n),xrms)

      write(6,*) 'm=',m,'n=',n,'ac=',wac(n)

      enddo ! loop n
c      
c sort xac from highest to lowest
      do i=1,mpls
        kpls(i)=i
      enddo

      do 300 i=1,mpls
      k=i
      p=wac(i)
      ip1=i+1
      if(ip1.gt.mpls) go to 260
      do 250 j=ip1,mpls
      if(wac(j).le.p) go to 250
      k=j
      p=wac(j)
 250  continue
 260  if(k.eq.i) go to 300
c re-order wac
      wac(i)=wac(k)
      wac(k)=p
c re-order rpcf2
      do 275 j=1,ny_tpz
      c1=rpcf2(m,i,j)
      rpcf2(m,i,j)=rpcf2(m,k,j)
      rpcf2(m,k,j)=c1
 275  continue
      kc1=kpls(i)
      kpls(i)=kpls(k)
      kpls(k)=kc1
 300  continue

      krpc(m)=kpls(1)

      if(wac(1).lt.cor_crit) then
        do it=1,ny_tpz
          rpcf(m,it)=0
        enddo
         mcho(m)=0
      else
        do it=1,ny_tpz
          rpcf(m,it)=rpcf2(m,1,it)
        enddo
         mcho(m)=1
      endif

      write(6,*) 'm=',m,'wac(1)=',wac(1)

      ENDDO ! loop m


      write(6,*) 'krpc='
      write(6,102) krpc
c
c hindcast var2 on grids
      do itgt=1,ny_tpz

      ir=0
      do iy=1,ny_tpz

          if(iy.eq.itgt) go to 677

          if(ncv.eq.3) then
            if(iy.eq.iym)  go to 677
            if(iy.eq.iyp)  go to 677
          endif

          ir=ir+1
          do i=1,imx2
          do j=1,jmx2
            w3dv2(i,j,ir)=wtpz(i,j,iy)
          enddo
          enddo

          do m=1,mrpc
            rpc2(m,ir)=rpc(m,iy)
          enddo

  677     continue
      enddo ! iy loop
c
c have regr pattern for this itgt
c
      do m=1,mrpc

        do it=1,nfld
          ts1(it)=rpc2(m,it)
        enddo

        call normal_a(ts1,nyr,nfld)
c
        do j=1,jmx2
        do i=1,imx2

        if(w3dv2(i,j,1).gt.undef) then

        do it=1,nfld
          ts2(it)=w3dv2(i,j,it)
        enddo

        call regr_t(ts1,ts2,nyr,nfld,corv22(i,j,m),regv22(i,j,m))

        else

        corv22(i,j,m)=undef
        regv22(i,j,m)=undef

        endif

        enddo
        enddo

      enddo ! m loop
c
      call setzero(w2d,imx2,jmx2)
      do i=1,imx2
      do j=1,jmx2

      if(fld2(i,j).gt.undef) then
        do m=1,mrpc
          w2d(i,j)=w2d(i,j)+rpcf(m,itgt)*regv22(i,j,m)
c         w2d(i,j)=w2d(i,j)+rpcf(m,itgt)*regv2(i,j,m)
        enddo
          w2d2(i,j)=wtpz(i,j,itgt)
      else
          w2d(i,j)=undef
          w2d2(i,j)=undef
      endif

      hcst(i,j,itgt,ld,ilag)=w2d(i,j)
      vfld(i,j,itgt,ld)=w2d2(i,j)

      enddo ! loop i
      enddo ! loop j

c
      write(6,*) 'itgt=',itgt

      ENDDO ! itgt loop

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
C===realtime fcst
c
      do i=1,imx
      do j=1,jmx
        do it=1,ny_tpz
          w3dv1(i,j,it)=sst(i,j,it)
        enddo
      enddo
      enddo

      do i=1,imx2
      do j=1,jmx2
        do it=1,ny_tpz
          w3dv2(i,j,it)=wtpz(i,j,it)
        enddo
      enddo
      enddo

      do i=1,imx
      do j=1,jmx
        fic(i,j)=sst(i,j,ny_sst)
      enddo
      enddo
C
      call reof_rpc(w3dv2,cosr2,nyr,ny_tpz,ng2,mrpc,undef,
     &imx2,jmx2,id2,jd2,isv2,iev2,jsv2,jev2,rpc,corv2,regv2,ideof)
c
c fcst var2 
      iw1=0 ! pls patterns
      iw2=0 ! reof patterns
      iw3=0 ! pls_ts
      do m=1,mrpc

      do iy=1,ny_tpz
        ts1(iy)=rpc(m,iy)
      enddo

      call pls_ana(nyr,ny_tpz,imx,jmx,isv1,iev1,jsv1,jev1,mpls,
     &ts1,w3dv1,fic,pc,pco,pt1,pt2,xvar,coslat,cor_crt,undef,idpls)

c
c compose rpcf for ny_sst
c
        rpcf(m,ny_sst)=0
        do n=1,mpls
          rpcf(m,ny_sst)=rpcf(m,ny_sst)+pco(n)
        enddo

        do n=1,mpls
        rpcf2(m,n,ny_sst)=0
          do k=1,n
          rpcf2(m,n,ny_sst)=rpcf2(m,n,ny_sst)+pco(k)
          enddo
        enddo
c
c calculate skill of each pls component
      do n=1,mpls
        do it=1,ny_tpz
        ts3(it)=pc(it,n)

        ts4(it)=0.
        do k=1,n
        ts4(it)=ts4(it)+pc(it,k)
        enddo ! k loop

        enddo ! it loop

        call acrms_t(ts1,ts3,cor1,rms1,nyr,ny_tpz)
        call acrms_t(ts1,ts4,cor2,rms2,nyr,ny_tpz)
c
      write(6,101) 'eofm plsm cor&rms=',m,n,cor1,rms1,cor2,rms2

      enddo ! n loop

 101  format(A20,I3,x,I3,x,4f7.2)
 102  format(10f7.2)
 103  format(10I5)

c write out pls patterns and var2 reof patterns 
      IF (ilag.eq.1.and.ld.eq.1) then

      do n=1,mpls

      do i=1,imx
      do j=1,jmx
        fld0(i,j)=pt1(i,j,n)
        fld1(i,j)=pt2(i,j,n)
      enddo ! loop i
      enddo ! loop j

      iw1=iw1+1
      write(41,rec=iw1) fld0
      iw1=iw1+1
      write(41,rec=iw1) fld1

      do it=1,nyr
        ts1(it)=undef
        ts2(it)=undef
      enddo
      do it=1,ny_tpz
        ts1(it)=rpc(m,it)
        ts2(it)=pc(it,n)
      enddo
      iw3=iw3+1
      write(43,rec=iw3) ts1
      iw3=iw3+1
      write(43,rec=iw3) ts2

      enddo ! n loop

      do i=1,imx2
      do j=1,jmx2
        w2d(i,j)=corv2(i,j,m)
        w2d2(i,j)=regv2(i,j,m)
      enddo ! loop i
      enddo ! loop j

      iw2=iw2+1
      write(42,rec=iw2) w2d
      iw2=iw2+1
      write(42,rec=iw2) w2d2

      ENDIF

      ENDDO !m loop

c forecast var2 on grids
      call setzero(w2d,imx2,jmx2)
      do i=1,imx2
      do j=1,jmx2

      if(fld2(i,j).gt.undef) then
        do m=1,mrpc
          w2d(i,j)=w2d(i,j)+rpcf(m,ny_sst)*regv2(i,j,m)
        enddo
      else
          w2d(i,j)=undef
      endif

      fcst(i,j,ld,ilag)=w2d(i,j)

      enddo ! loop i
      enddo ! loop j

      ENDDO ! ld loop
      ENDDO ! ilag

c
c weighted ensemble over all lagged hcst and fcst
c
      iw=0
      DO ld=1,nlead ! lead of weighted hcst/fcst

C== have denominator of the weights
      do it=1,ic_fcst

      do i=1,imx2
      do j=1,jmx2
        if(fld2(i,j).gt.-900.) then
          wtd(i,j,it,ld)=0
          do ilag=1,lagmaxm
              wtd(i,j,it,ld)=wtd(i,j,it,ld)+ac(i,j,it,ld,ilag)**2
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
             wts(i,j,it,ld,ilag)=-ac(i,j,it,ld,ilag)**2/wtd(i,j,it,ld)
            endif
          else
            wts(i,j,it,ld,ilag)=undef
          endif
        enddo
        enddo

        enddo ! ilag loopo
       
      enddo ! it loop

C== have ensemble hcst
      do it=1,ny_tpz
        do i=1,imx2
        do j=1,jmx2
          if(fld2(i,j).gt.-900.) then

            w2d(i,j)=0.
            do ilag=1,lagmaxm
            w2d(i,j)=w2d(i,j)+wts(i,j,it,ld,ilag)*hcst(i,j,it,ld,ilag)
            enddo

          else
            w2d(i,j)=undef
          endif
          wthcst(i,j,it,ld)=w2d(i,j)
          w2d2(i,j)=vfld(i,j,it,ld)
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
          enddo

          else
            w2d(i,j)=undef
          endif
            wtfcst(i,j,ld)=w2d(i,j)

        enddo
        enddo

        write(6,*) 'fcst(260,125)=',fcst(260,125,ld,1)
        write(6,*) 'hcst(260,125)=',hcst(260,125,73,ld,1)
c       write(6,*) 'wts(260,125)=',wts(260,125,ic_fcst,ld,1)
        write(6,*) 'wts(260,125)=',wts(260,125,74,ld,1)
        write(6,*) 'wtfcst(260,125,ld)=',wtfcst(260,125,ld)

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

      subroutine reof_rpc(fin,cosr,nt,mt,ng,mrpc,undef,
     &im,jm,idx,idy,is,ie,js,je,rcoef,cor,reg,id)
c
      dimension fin(im,jm,nt),cosr(jm)

      dimension aaa(ng,mt)
      dimension eval(mt),evec(ng,mt),coef(mt,mt)
      dimension reval(mrpc),revec(ng,mrpc),rcoef(mrpc,nt)
      dimension tt(mrpc,mrpc),wk(mt,ng),rwk3(ng),rwk4(ng,mrpc)

      dimension ts1(mt),ts2(mt)
      dimension cor(im,jm,mrpc),reg(im,jm,mrpc)
c      
ci normaliz or not
        do i=is,ie,idx
        do j=js,je,idy

        if(fin(i,j,1).gt.undef) then
          if(id.eq.1) then
            do it=1,mt
              ts1(it)=fin(i,j,it)
            enddo
            call normal_a(ts1,mt,mt)
            do it=1,mt
              fin(i,j,it)=ts1(it)
            enddo
          endif
        endif

        enddo
        enddo

c feed aaa
      do it=1,mt
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
      print *, 'ngrd=',ig

C REOF analysis
      call reofs(aaa,ng,mt,mt,wk,0,eval,evec,coef,
     &           mrpc,reval,revec,rcoef,tt,rwk3,rwk4)
C
C normalize rpc and have cor&reg patterns
      do m=1,mrpc
        do it=1,mt
          ts1(it)=rcoef(m,it)
        enddo
        call normal_a(ts1,mt,mt)

        do it=1,mt
          rcoef(m,it)=ts1(it)
        enddo
c
        do j=1,jm
        do i=1,im

        if(fin(i,j,1).gt.undef) then

        do it=1,mt
          ts2(it)=fin(i,j,it)
        enddo

        call regr_t(ts1,ts2,mt,mt,cor(i,j,m),reg(i,j,m))

        else

        cor(i,j,m)=undef
        reg(i,j,m)=undef

        endif

        enddo
        enddo
      enddo  ! m loop

      return
      end

      subroutine normal_sd(x,n,m,std)
      dimension x(n)
      avg=0
      do i=1,m
      avg=avg+x(i)/float(m)
      enddo
      var=0
      do i=1,m
      var=var+(x(i)-avg)*(x(i)-avg)/float(m)
      enddo
      std=sqrt(var)
      do i=1,m
        x(i)=(x(i)-avg)/std
      enddo
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


      subroutine normal_a(x,n,m)
      dimension x(n)
      avg=0
      do i=1,m
      avg=avg+x(i)/float(m)
      enddo
      var=0
      do i=1,m
      var=var+(x(i)-avg)*(x(i)-avg)/float(m)
      enddo
      std=sqrt(var)
      do i=1,m
        x(i)=(x(i)-avg)/std
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

      subroutine acrms_t(f,o,ac,rms,m,n)
      dimension f(m),o(m)

      oo=0.
      ff=0.
      of=0.
      rms=0
      do i=1,n
        oo=oo+o(i)*o(i)
        ff=ff+f(i)*f(i)
        of=of+f(i)*o(i)
        rms=rms+(f(i)-o(i))*(f(i)-o(i))
      enddo
      tt=float(n)
      stdo=sqrt(oo/tt)
      stdf=sqrt(ff/tt)
      of=of/tt
      ac=of/(stdo*stdf)
      rms=sqrt(rms/tt)
c
      return
      end
