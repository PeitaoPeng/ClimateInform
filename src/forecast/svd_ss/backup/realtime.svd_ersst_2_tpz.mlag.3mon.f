      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C PCR for forecst TPZ
C===========================================================
      real fld0(imx,jmx),fld(imx,jmx),fld1(imx,jmx),fldv1(imx,jmx)
      real sst(imx,jmx,nyr)
      real sstc(imx,jmx),tpzc(imx2,jmx2),tpzc_tot(imx2,jmx2,nlead)

      real fld2(imx2,jmx2)
      real cor3d(imx2,jmx2,nlead),rms3d(imx2,jmx2,nlead)
      real ac(imx2,jmx2,nyr,nlead,lagmax)
      real hss3d(imx2,jmx2,nlead)
      real ts1(nyr),ts2(nyr)
      real ts3(nyr),ts4(nyr)
      real ts5(nyr),ts6(nyr)
      real w2d(imx2,jmx2),w2d2(imx2,jmx2),w2d3(imx2,jmx2)
      real w2d4(imx2,jmx2),w2d5(imx2,jmx2),w2d6(imx2,jmx2)

      real tcof(mv1,nyr),pcv1(mv1,nyr),pcv2(mv2,nyr)

      real cof1(msvd,nyr),cof2(msvd,nyr)
      real cic(msvd),sdc1(msvd),sdc2(msvd)

      real corv1(imx,jmx,mv1),regv1(imx,jmx,mv1)
      real corv2(imx2,jmx2,mv2),regv2(imx2,jmx2,mv2)

      real prdpcv2(mv2,nyr),w1d(mv2)

      real corr12(mv2,msvd),regr12(mv2,msvd)
      real corr11(mv1,msvd),regr11(mv1,msvd)

      real corr21(mv1,msvd),regr21(mv1,msvd)
      real corr22(mv2,msvd),regr22(mv2,msvd)

      real tpz(imx2,jmx2,montot),wtpz(imx2,jmx2,nyr)
      real ftpz(imx2,jmx2,nyr)

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

      real cor1d1(msvd),cor1d2(msvd)
      real cor1d3(msvd),cor1d4(msvd)
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

      open(40,form='unformatted',access='direct',recl=4*imx*jmx) !IC
      open(41,form='unformatted',access='direct',recl=4*imx*jmx) !svd
      open(42,form='unformatted',access='direct',recl=4*imx2*jmx2) !svd

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
      lagmaxm=lagmax - 1
      DO ilag=1,lagmaxm ! =1 for lag=0
c     its_sst=icmon+lagmax-ilag+1 ! for mon sst
      its_sst=icmon-2+lagmax-ilag+1 ! for 3-mon sst 11-2+12-1+1=21(son)

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
c SST EOF analysis
c
      call eof_pc(sst,cosr,nyr,ny_sst,ng1,mv1,undef,
     &imx,jmx,idx1,idy1,isv1,iev1,jsv1,jev1,tcof,corv1,regv1,id)

c
C write out PC and EOF patterns for ilag=1
      if(ilag.eq.1) then
      iw=0
      iw2=0
      do m=1,mv1

      do it=1,ny_sst
      iw=iw+1
      write(20,rec=iw) tcof(m,it)
      enddo

      do i=1,imx
      do j=1,jmx
        fld(i,j)=corv1(i,j,m)
        fld0(i,j)=regv1(i,j,m)
      enddo
      enddo
      iw2=iw2+1
      write(21,rec=iw2) fld
      iw2=iw2+1
      write(21,rec=iw2) fld0

      enddo ! m loop
      endif
c
c tpz hindcast for ld=1->nlead
      iw5=0
      DO ld=1,nlead

c select tpz for each lead
      its_tpz=icmon+lagmax+ld+1 !11+12+1+1=25(jfm)
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
C CV hcst for this lead
C
      DO itgt=1,ny_tpz

        iym=itgt-1
        iyp=itgt+1
        if(itgt.eq.1) iym=3
        if(itgt.eq.ny_tpz) iyp=ny_tpz-2

      DO m=1,mv1

        ir=0
        do iy=1,ny_tpz

          if(iy.eq.itgt) go to 555

          if(ncv.eq.3) then
            if(iy.eq.iym)  go to 555
            if(iy.eq.iyp)  go to 555
          endif

            ir=ir+1
            pcv1(m,ir)=tcof(m,iy)

  555   continue

        enddo ! iy loop

      ENDDO ! m loop

      nfld=ir

      nfldp=nfld+1

      do m=1,mv1
        pcv1(m,nfldp)=tcof(m,itgt)
      enddo

c     write(6,*) 'nfld=',nfld, 'pcv1=',pcv1(1,nfldp),pcv1(mv1,nfldp)
c     write(6,*) 'nfldp=',nfldp, 'tcof=',tcof(1,itgt),tcof(mv1,itgt)
          
c have ftpz
      ir=0
      do iy=1,ny_tpz

          if(iy.eq.itgt) go to 666

          if(ncv.eq.3) then
            if(iy.eq.iym)  go to 666
            if(iy.eq.iyp)  go to 666
          endif

          ir=ir+1
          do i=1,imx2
          do j=1,jmx2
            ftpz(i,j,ir)=wtpz(i,j,iy)
          enddo
          enddo


  666     continue
      enddo ! iy loop

      nfld=ir

      call eof_pc(ftpz,cosr2,nyr,nfld,ng2,mv2,undef,
     &imx2,jmx2,idx2,idy2,isv2,iev2,jsv2,jev2,pcv2,corv2,regv2,id)
c
c have lead-ld hcst for itgt yr with SVD
c svd bwtween pcv1 & pcv2

      do m=1,msvd ! < min(mv1,mv2)
      do it=1,nyr
        cof1(m,it)=undef
        cof2(m,it)=undef
      enddo
      enddo
C
      call pc_svd(pcv1,pcv2,nyr,nfld,mv1,mv2,msvd,cof1,cof2,cic)
c
c normalize cof & cic
      do m=1,msvd !loop over mode
c
      do it=1,nfld
        ts1(it)=cof1(m,it)
        ts2(it)=cof2(m,it)
      enddo

      call normal_sd(ts1,nyr,nfld,sdc1(m))
      call normal_sd(ts2,nyr,nfld,sdc2(m))

      do jt=1,nfld
        cof1(m,jt)=ts1(jt)
        cof2(m,jt)=ts2(jt)
      enddo

      cic(m)=cic(m)/sdc1(m) ! normalize cic

      enddo ! loop m

c     write(6,*) 'cic=',cic

c regression of cof1 to pcv2

      do m=1,msvd

      do it=1,nfld
        ts1(it)=cof1(m,it)
      enddo

      do i=1,mv2

      do it=1,nfld
        ts2(it)=pcv2(i,it)
      enddo

      call regr_t(ts1,ts2,nyr,nfld,corr12(i,m),regr12(i,m))

      enddo ! loop i

      enddo ! loop m

c hindcast var2 on spectral
      do i=1,mv2

        w1d(i)=0.
        do m=1,msvd
          w1d(i)=w1d(i)+cic(m)*regr12(i,m)
        enddo
          prdpcv2(i,itgt)=w1d(i)

      enddo ! loop i

c hindcast var2 on grid
      call setzero(w2d,imx2,jmx2)
      do i=1,imx2
      do j=1,jmx2

      if(fld2(i,j).gt.undef) then
        do m=1,mv2
          w2d(i,j)=w2d(i,j)+prdpcv2(m,itgt)*regv2(i,j,m)
        enddo
          w2d2(i,j)=wtpz(i,j,itgt)
      else
          w2d(i,j)=undef
          w2d2(i,j)=undef
      endif

      hcst(i,j,itgt,ld,ilag)=w2d(i,j)
      vfld(i,j,itgt,ld)=w2d2(i,j)

      enddo
      enddo

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
      do m=1,mv1
      do it=1,ny_tpz+1 ! +1 to include ic_sst
         pcv1(m,it)=tcof(m,it)
      enddo
      enddo

      call eof_pc(wtpz,cosr2,nyr,ny_tpz,ng2,mv2,undef,
     &imx2,jmx2,idx2,idy2,isv2,iev2,jsv2,jev2,pcv2,corv2,regv2,id)
c
c svd bwtween pcv1 & pcv2
      do m=1,msvd ! < min(mv1,mv2)
      do it=1,nyr
        cof1(m,it)=undef
        cof2(m,it)=undef
      enddo
      enddo
C
      call pc_svd(pcv1,pcv2,nyr,ny_tpz,mv1,mv2,msvd,cof1,cof2,cic)
c
c normalize cof & cic
      do m=1,msvd !loop over mode
 
      do it=1,ny_tpz
        ts1(it)=cof1(m,it)
        ts2(it)=cof2(m,it)
      enddo

      call normal_sd(ts1,nyr,ny_tpz,sdc1(m))
      call normal_sd(ts2,nyr,ny_tpz,sdc2(m))

      do jt=1,ny_tpz
        cof1(m,jt)=ts1(jt)
        cof2(m,jt)=ts2(jt)
      enddo

      cic(m)=cic(m)/sdc1(m) ! normalize cic

      enddo ! loop m

c regression of cof1 to pcv2

      do m=1,msvd

      do it=1,ny_tpz
        ts1(it)=cof1(m,it)
      enddo

      do i=1,mv2

      do it=1,ny_tpz
        ts2(it)=pcv2(i,it)
      enddo

      call regr_t(ts1,ts2,nyr,ny_tpz,corr12(i,m),regr12(i,m))

      enddo ! loop i

      enddo ! loop m

c forcast var2 on spectral
      do i=1,mv2

        w1d(i)=0.
        do m=1,msvd
          w1d(i)=w1d(i)+cic(m)*regr12(i,m)
        enddo
          prdpcv2(i,ic_fcst)=w1d(i)

      enddo ! loop i

c forcast var2 on grid
      call setzero(w2d,imx2,jmx2)
      do i=1,imx2
      do j=1,jmx2

      if(fld2(i,j).gt.undef) then
        do m=1,mv2
          w2d(i,j)=w2d(i,j)+prdpcv2(m,ic_fcst)*regv2(i,j,m)
        enddo
      else
          w2d(i,j)=undef
      endif

      fcst(i,j,ld,ilag)=w2d(i,j)

      enddo
      enddo

      write(6,*) 'ilag=',ilag,'lead=',ld

c
c write out svd patterns of sst and tpz 
c

      IF (ilag.eq.1.and.ld.eq.1) then

      do m=1,msvd

c regression of cof2 to pcv1 & pcv2
        do it=1,ny_tpz
          ts1(it)=cof2(m,it)
        enddo

        do i=1,mv1
          do it=1,ny_tpz
            ts2(it)=pcv1(i,it)
          enddo
          call regr_t(ts1,ts2,nyr,ny_tpz,corr21(i,m),regr21(i,m))
        enddo ! loop i

        do i=1,mv2
        do it=1,ny_tpz
          ts2(it)=pcv2(i,it)
        enddo
          call regr_t(ts1,ts2,nyr,ny_tpz,corr22(i,m),regr22(i,m))
        enddo ! loop i

c regression of cof1 to pcv1 & pcv2
        do it=1,ny_tpz
          ts1(it)=cof1(m,it)
        enddo

        do i=1,mv1
          do it=1,ny_tpz
            ts2(it)=pcv1(i,it)
          enddo
          call regr_t(ts1,ts2,nyr,ny_tpz,corr11(i,m),regr11(i,m))
        enddo ! loop i

        do i=1,mv2
        do it=1,ny_tpz
          ts2(it)=pcv2(i,it)
        enddo
          call regr_t(ts1,ts2,nyr,ny_tpz,corr12(i,m),regr12(i,m))
        enddo ! loop i

      enddo ! loop m
c
c have var1 & var2 on grid for each svd mode
      iw1=0
      iw2=0
      do m=1,msvd

c var1
      call setzero(fld0,imx,jmx)
      call setzero(fld1,imx,jmx)
      do i=1,imx
      do j=1,jmx

      if(fld(i,j).gt.undef) then
        do n=1,mv1
          fld0(i,j)=fld0(i,j)+regr11(n,m)*regv1(i,j,m)
          fld1(i,j)=fld1(i,j)+regr21(n,m)*regv1(i,j,m)
        enddo
          fldv1(i,j)=regv1(i,j,m)
      else
          fld0(i,j)=undef
          fld1(i,j)=undef
          fldv1(i,j)=undef
      endif

      enddo
      enddo

      iw1=iw1+1
      write(41,rec=iw1) fld0
      iw1=iw1+1
      write(41,rec=iw1) fld1
      iw1=iw1+1
      write(41,rec=iw1) fldv1

c var2
      call setzero(w2d,imx2,jmx2)
      call setzero(w2d2,imx2,jmx2)
      do i=1,imx2
      do j=1,jmx2

      if(fld2(i,j).gt.undef) then
        do n=1,mv2
          w2d(i,j)=w2d(i,j)+regr22(n,m)*regv2(i,j,m)
          w2d2(i,j)=w2d2(i,j)+regr12(n,m)*regv2(i,j,m)
        enddo
          w2d3(i,j)=regv2(i,j,m)
      else
          w2d(i,j)=undef
          w2d2(i,j)=undef
          w2d3(i,j)=undef
      endif

      enddo
      enddo

      iw2=iw2+1
      write(42,rec=iw2) w2d
      iw2=iw2+1
      write(42,rec=iw2) w2d2
      iw2=iw2+1
      write(42,rec=iw2) w2d3

      enddo ! m loop

c corr of svd cof1 vs cof2
      do m=1,msvd
        do it=1,ny_tpz
          ts1(it) = cof1(m,it)
          ts2(it) = cof2(m,it)
          ts3(it) = pcv1(m,it)
          ts4(it) = pcv2(m,it)
        enddo
          call cor_rms(ts1,ts2,nyr,ny_tpz,cor1d1(m),rms)
          call cor_rms(ts1,ts3,nyr,ny_tpz,cor1d2(m),rms)
          call cor_rms(ts2,ts4,nyr,ny_tpz,cor1d3(m),rms)
          call cor_rms(ts3,ts4,nyr,ny_tpz,cor1d4(m),rms)
      enddo

      write(6,*) 'cor_svdsst_vs_svdtpz'
      write(6,101) cor1d1
      write(6,*) 'cor_svdsst_vs_eofsst'
      write(6,101) cor1d2
      write(6,*) 'cor_svdtpz_vs_eoftpz'
      write(6,101) cor1d3
      write(6,*) 'cor_eofsst_vs_eoftpz'
      write(6,101) cor1d4

      ENDIF

      ENDDO ! ld loop
      ENDDO ! ilag
 101  format(10f7.3)
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

      subroutine eof_pc(fin,cosr,ntot,nt,ng,nmod,undef,
     &im,jm,idx,idy,is,ie,js,je,pc,cor,reg,id)
c
      dimension fin(im,jm,ntot),cosr(jm)
      dimension aaa(ng,nt),wk(nt,ng)
      dimension eval(nt),evec(ng,nt),coef(nt,nt)
      dimension pc(nmod,ntot)

      dimension ts1(nt),ts2(nt)
      dimension cor(im,jm,nmod),reg(im,jm,nmod)
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
      print *, 'ngrd=',ig
C EOF analysis
      call eofs(aaa,ng,nt,nt,eval,evec,coef,wk,id)
      write(6,*) 'eval=',eval(1),eval(2),eval(3),eval(4)
C
C normalize rpc and have cor&reg patterns
      do m=1,nmod
        do it=1,nt
          ts1(it)=coef(m,it)
        enddo

        if(id.eq.0) then
          call normal(ts1,nt,nt)
        endif

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

      SUBROUTINE pc_svd(pcv1,pcv2,nt,mt,mv1,mv2,msvd,
     &cof1,cof2,cic)

      real pcv1(mv1,nyr),pcv2(mv2,nyr)
      real aleft(mv1,nt),aright(mv2,nt)
      real a(mv1,mv2),w(mv2),u(mv1,mv2),v(mv2,mv2),rv1(mv2)
      real wic(mv1),aic(mv1),cic(msvd)
c
      real cof1(msvd,nt),cof2(msvd,nt)

c feed matrix
      do it=1,mt
        do m=1,mv1
          aleft(m,it)=pcv1(m,it)
        enddo
        do m=1,mv2
          aright(m,it)=pcv2(m,it)
        enddo
      enddo  ! it loop

      do i=1,mv1
      do j=1,mv2

      a(i,j)=0.
      do k=1,mt
      a(i,j)=a(i,j)+aleft(i,k)*aright(j,k)/float(mt)
      enddo

      enddo
      enddo
c
c var1 IC data (pcv1 in mtp)
      do m=1,mv1
        aic(m)=pcv1(m,mt+1)
      enddo
c
cc... SVD analysis
      print *, 'before svdcmp'
      call svdcmp(a,mv1,mv2,mv1,mv2,w,v)
      do i=1,mv1
      do j=1,mv2
        u(i,j)=a(i,j)
      enddo
      enddo
c
      write(6,*)'singular value=',w(1),w(2),w(3),w(4),w(5)
c== have svd coef
      do m=1,msvd
c
      do it=1,mt
        cof1(m,it)=0.
        cof2(m,it)=0.
        do n=1,mv1
          cof1(m,it)=cof1(m,it)+aleft(n,it)*u(n,m)
        enddo
        do n=1,mv2
          cof2(m,it)=cof2(m,it)+aright(n,it)*v(n,m)
        enddo
      enddo
c
      enddo
c
c have cic, the projection of var1_ic to u
      do m=1,mv1
        wic(m)=pcv1(m,mt+1)
      enddo

      do m=1,msvd
        cic(m)=0.
        do n=1,mv1
        cic(m)=cic(m)+wic(n)*u(n,m)
        enddo
      enddo
c
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


      subroutine normal(x,n,m)
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

