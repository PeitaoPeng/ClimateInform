      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C eeof with regression only for IC season
C===========================================================
      real fld0(imx,jmx),fld(imx,jmx)
      real sst(imx,jmx,nssuse)
      real sstc(imx,jmx,4),clm_sst_1d(4),clm_tpz_1d(12)
      real sstlag(imx,jmx,mlag,nfld)
      real aaa(mlag*ngrd,nfld),wk(nfld,mlag*ngrd),tt(nmod,nmod)
      real eval(nfld),evec(mlag*ngrd,nfld),coef(nfld,nfld)
      real rin(nfld),rot(nfld)
      real weval(nfld),wevec(mlag*ngrd,nfld),wcoef(nfld,nfld)
      real reval(nmod),revec(mlag*ngrd,nfld),rcoef(nmod,nfld)
      real rcoef2(nmod,nfld)
      real rwk(mlag*ngrd),rwk2(mlag*ngrd,nmod)
      real fld2(imx,jmx)
      real corr(imx,jmx),regr(imx,jmx)
      real xlat(jmx),coslat(jmx),cosr(jmx)

      real corr2(imx2,jmx2,nmod),regr2(imx2,jmx2,nmod,nfld)
      real corr3(imx2,jmx2,nmod),regr3(imx2,jmx2,nmod)
      real corr4d(imx2,jmx2,mlag,nmod),regr4d(imx2,jmx2,mlag,nmod)

      real cvcor(imx2,jmx2,nfld,nlead)
      real cvrms(imx2,jmx2,nfld,nlead)

      real cor3d(imx2,jmx2,nlead),rms3d(imx2,jmx2,nlead)
      real hss3d(imx2,jmx2,nlead)
      real ts1(nssuse)
      real ts2(nfld),ts3(nfld),ts4(nfld)
      real w1d(nwmo),w1d2(nwmo)
      real w2d(imx2,jmx2),w2d2(imx2,jmx2),w2d3(imx2,jmx2)
      real w2d4(imx2,jmx2),w2d5(imx2,jmx2),w2d6(imx2,jmx2)
      real wtpz(imx2,jmx2,nfld)
      real wtpz2(imx2,jmx2,nfld)
      real hcst(imx2,jmx2,nfld,nlead)
      real fcst(imx2,jmx2,nlead)
      real avgo(imx2,jmx2),avgf(imx2,imx2)
      real stdo(imx2,jmx2,nlead),stdf(imx2,jmx2,nlead)
      real clmo(imx2,jmx2,nlead),clmf(imx2,jmx2,nlead)
      real vfld(imx2,jmx2,nfld,nlead)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !sst

      open(11,form='unformatted',access='direct',recl=4*imx2*jmx2) !tpz

      open(20,form='unformatted',access='direct',recl=4) !pc
      open(21,form='unformatted',access='direct',recl=4*imx*jmx) !eof

      open(30,form='unformatted',access='direct',recl=4*imx2*jmx2) !fcst
      open(32,form='unformatted',access='direct',recl=4*imx2*jmx2) !hcst
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
C=== read in independent and properly skiped avg sst
      ir=0
      do it=its_sst,nsstot,3
      ir=ir+1
        read(10,rec=it) fld2
        do i=1,imx
        do j=1,jmx
          sst(i,j,ir)=fld2(i,j) 
        enddo
        enddo
        write(6,*) 'its_sst=',its_sst,'it=',it
      enddo

      nread=ir
      write(6,*) 'nread(=nssuse?)=',nread ! should = nssuse
C
C have sst anomalies 
      do i=1,imx
      do j=1,jmx

        if(fld2(i,j).gt.-900.) then
          do it=1,nssuse
            ts1(it)=sst(i,j,it)
          enddo
          call clim_anom_4(ts1,nssuse,nssuse,clm_sst_1d)
        else
          do it=1,nssuse
            ts1(it)=undef
          enddo
          do m=1,4
            clm_sst_1d(m)=undef
          enddo
        endif

        do it=1,nssuse
          sst(i,j,it)=ts1(it)
        enddo

        do m=1,4
          sstc(i,j,m)=clm_sst_1d(m)
        enddo

      enddo
      enddo
c
c have lagged SST matrix
c
      do ilag=1,mlag
      do is=1,nfld

      iss=is+ilag-1

      do i=1,imx
      do j=1,jmx

      sstlag(i,j,ilag,is)=sst(i,j,iss)

      enddo
      enddo

      enddo ! is loop
      enddo ! ilag loop

C input to aaa
      do is=1,nfld
      do ilag=1,mlag

      ig=0
      do i=lons,lone
      do j=lats,late
        if(fld2(i,j).gt.-900.) then
          ig=ig+1
          aaa(ig+(ilag-1)*ngrd,is)=cosr(j)*sstlag(i,j,ilag,is)
        endif
      enddo
      enddo

      enddo
      enddo
      write(6,*) 'ngrd=',ig
c
c SST EOF analysis
c
      write(6,*) 'eof begins'
c     call EOFS(aaa,mlag*ngrd,nfld,nfld,eval,evec,coef,wk,ID)
      write(6,*) 'reof begins'
      call REOFS(aaa,mlag*ngrd,nfld,nfld,wk,ID,weval,wevec,wcoef,
     &           nmod,reval,revec,rcoef,tt,rwk,rwk2)
cc... arrange reval,revec and rcoef in decreasing order
      call order(mlag*ngrd,nfld,nmod,reval,revec,rcoef)
c
CCC...CORR between rcoef and tpz data
C
      iw1=0
      iw2=0

      DO m=1,nmod      !loop over mode
c
      do it=1,nfld
        ts2(it)=rcoef(m,it)
      enddo

      call normal(ts2,ts3,nfld,nfld)

      do it=1,nfld
        rcoef(m,it)=ts3(it)
      enddo

      do ilag=1,mlag

      do i=1,imx
      do j=1,jmx
        if(fld2(i,j).gt.-900.) then
        do it=1,nfld
          ts3(it)=sstlag(i,j,ilag,it)
        enddo
        call regr_t(ts2,ts3,nfld,nfld,corr(i,j),regr(i,j))
        else
          corr(i,j)=undef
          regr(i,j)=undef
        endif
        corr4d(i,j,ilag,m)=corr(i,j)
        regr4d(i,j,ilag,m)=regr(i,j)
      enddo
      enddo

C write out EOF patterns
        iw1=iw1+1
        write(21,rec=iw1) regr

      enddo ! ilag loop

C write out rcoef
      do it=1,nfld
         iw2=iw2+1
         write(20,rec=iw2) rcoef(m,it)
      enddo

      enddo !m loop
C      
C take rcoef data for the season same as that of IC
C 
      nyrpc=int(nfld/4)
      nsrpc=nyrpc*4
      nsdel=nfld-nsrpc
      if(nsdel.eq.0) then
        its_rpc=4
      else
        its_rpc=nsdel
      endif
      write(6,*)'nyrpc=',nyrpc
      write(6,*)'nsrpc=',nsrpc
      write(6,*)'nfld=',nfld
      write(6,*)'its_rpc=',its_rpc

c rcoef2

      DO m=1,nmod      !loop over mode
c
      ir=0
      do it=its_rpc,nfld,4
      ir=ir+1
        ts2(ir)=rcoef(m,it)
      enddo

      ns_rpc=ir

      call normal(ts2,ts3,nfld,ns_rpc)

      do it=1,ns_rpc
        rcoef2(m,it)=ts3(it)
      enddo

      ENDDO ! m loop
      write(6,*) 'ns_rpc=',ns_rpc
c
c hindcast for ld=1->nlead
c
      DO ld=1,nlead

c read in predictant (tpz) for each lead
c     its_tpz=its_sst+ld+mlag*3 
      its_tpz=its_sst+ld+mlag*3-1 
      write(6,*) 'its_sst=',its_sst,'its_tpz=',its_tpz
      ir=0
      do it=its_tpz,nsstot,3
        ir=ir+1
        read(11,rec=it) w2d3

        do i=1,imx2
        do j=1,jmx2
          wtpz(i,j,ir)=w2d3(i,j)
        enddo
        enddo
        write(6,*) 'ld=',ld,'it=',it,'ir=',ir
      enddo
      ns_tpz=ir
      write(6,*) 'ns_tpz=',ns_tpz
C      
C take wtpz data for the season same as that of IC
C 
      do i=1,imx2
      do j=1,jmx2
        if(w2d3(i,j).gt.-900.) then

          ir=0
          do it=its_rpc,ns_tpz,4
          ir=ir+1
            ts2(ir)=wtpz(i,j,it)
          enddo
          ns_tpz2=ir
          call clim_anom(ts2,xclm,nfld,ns_tpz2)
        else
          do it=1,ns_tpz2
            ts2(it)=undef
          enddo
        endif
          do it=1,ns_tpz2
            wtpz2(i,j,it)=ts2(it)
          enddo
      enddo
      enddo
      write(6,*) 'ns_tpz2=',ns_tpz2
C
C CV hcst for this lead
c     mfld=ns_tpz2 - 1
c     if(ncv.eq.3) mfld=ns_tpz2 - 3
c
      DO itgt=1,ns_tpz2

        ism=itgt-1
        isp=itgt+1
        if(itgt.eq.1) ism=3
        if(itgt.eq.ns_tpz2) isp=ns_tpz2-2

      DO m=1,nmod

        ir=0
        do is=1,ns_tpz2

          if(is.eq.itgt) go to 555

          if(ncv.eq.3) then
            if(is.eq.ism)  go to 555
            if(is.eq.isp)  go to 555
          endif

          ir=ir+1
          ts2(ir)=rcoef2(m,is)
  555   continue
        enddo
          
        do i=1,imx2
        do j=1,jmx2

        IF(w2d3(i,j).gt.-900.) then

          ir=0
          do is=1,ns_tpz2

          if(is.eq.itgt) go to 666

          if(ncv.eq.3) then
            if(is.eq.ism)  go to 666
            if(is.eq.isp)  go to 666
          endif

            ir=ir+1
            ts3(ir)=wtpz2(i,j,is)
  666     continue
          enddo

          mfld=ir
          call regr_t(ts2,ts3,nfld,mfld,corr2(i,j,m),
     &    regr2(i,j,m,itgt))

        ELSE

          corr2(i,j,m)=undef
          regr2(i,j,m,itgt)=undef

        ENDIF

        enddo
        enddo
      enddo ! m loop
c
c have lead-ld hcst for itgt season with sst rcoef and tpz regr
      call setzero(w2d,imx2,jmx2)
      do i=1,imx2
      do j=1,jmx2
        if(w2d3(i,j).gt.-900.) then
          do m=1,nmod
            w2d(i,j)=w2d(i,j)+rcoef2(m,itgt)*regr2(i,j,m,itgt)
          enddo
            w2d2(i,j)=wtpz2(i,j,itgt)
        else
            w2d(i,j)=undef
            w2d2(i,j)=undef
        endif

        hcst(i,j,itgt,ld)=w2d(i,j)

        vfld(i,j,itgt,ld)=w2d2(i,j)

      enddo
      enddo

      ENDDO ! itgt loop

c
C======== realtime fcst
c
c have regr patterns
      DO m=1,nmod

        do is=1,ns_tpz2
            ts2(is)=rcoef2(m,is)
        enddo
          
        do i=1,imx2
        do j=1,jmx2

        IF(w2d3(i,j).gt.-900.) then

          do is=1,ns_tpz2
            ts3(is)=wtpz2(i,j,is)
          enddo

          call regr_t(ts2,ts3,nfld,ns_tpz2,corr3(i,j,m),regr3(i,j,m))

        ELSE

          corr3(i,j,m)=undef
          regr3(i,j,m)=undef

        ENDIF

        enddo
        enddo

        ENDDO ! m loop
c
c fcst
c
      call setzero(w2d,imx2,jmx2)
      do i=1,imx2
      do j=1,jmx2
        if(w2d3(i,j).gt.-900.) then

          do m=1,nmod
            w2d(i,j)=w2d(i,j)+rcoef2(m,ns_rpc)*regr3(i,j,m)
          enddo

        else
            w2d(i,j)=undef
        endif

        fcst(i,j,ld)=w2d(i,j)

      enddo
      enddo

      ENDDO ! ld loop
c
c write out obs and hcst
      iw=0
      do ld=1,nlead

c normalize obs and hcst
      do i=1,imx2
      do j=1,jmx2

        if(w2d3(i,j).gt.-900.) then

        ir=0
        do it=its_hcst,ns_tpz2
        ir=ir+1
          ts1(ir)=vfld(i,j,it,ld)
          ts2(ir)=hcst(i,j,it,ld)
        enddo

        call clim_anom_std(ts1,clmo(i,j,ld),stdo(i,j,ld),nyr,ir)
        call clim_anom_std(ts2,clmf(i,j,ld),stdf(i,j,ld),nyr,ir)

        do it=its_hcst,ns_tpz2
          vfld(i,j,it,ld)=vfld(i,j,it,ld)/stdo(i,j,ld)
          hcst(i,j,it,ld)=hcst(i,j,it,ld)/stdf(i,j,ld)
        enddo

        else

        stdo(i,j,ld)=undef
        stdf(i,j,ld)=undef
        clmo(i,j,ld)=undef
        clmf(i,j,ld)=undef

        endif

      enddo
      enddo

        do it=its_hcst,ns_tpz2 ! from 1951

          do i=1,imx2
          do j=1,jmx2
            w2d(i,j)=vfld(i,j,it,ld)
          enddo
          enddo
          iw=iw+1
          write(32,rec=iw) w2d

          do i=1,imx2
          do j=1,jmx2
            w2d(i,j)=hcst(i,j,it,ld)
          enddo
          enddo
          iw=iw+1
          write(32,rec=iw) w2d

      enddo

      enddo ! ld loop

c write out fcst
       iw=0
       do ld=1,nlead

         do i=1,imx2
         do j=1,jmx2
           if(w2d3(i,j).gt.-900.) then
             w2d(i,j)=(fcst(i,j,ld)-clmf(i,j,ld))/stdf(i,j,ld)
           else
             w2d(i,j)=undef
           endif
         enddo
         enddo

         iw=iw+1
         write(30,rec=iw) w2d

      enddo ! ld loop
c
      stop
      end

      SUBROUTINE have_iwmo(it,nwmo,iwmo,ii)

      iwmo=1 ! for it < 33

      do id=1,nwmo-1
        its=30+(id-1)*10+1+1+ii ! ii=0 skip 1950; ii=1 skip 1949-50
        ite=30+id*10+1+ii
        if(it.ge.its.and.it.le.ite) iwmo=id
      enddo

      its=30+(nwmo-1)*10+1+1+ii
      if(it.ge.its) iwmo=nwmo

      return
      end

      SUBROUTINE wmo_clm_std_anom(ts,std,clm,anom,maxt,nt,nwmo,ii)
c================================
C WMO std, clm, and anom
c================================
      DIMENSION ts(maxt),anom(maxt),std(nwmo),clm(nwmo)

C have WMO std and clm
      do id=1,nwmo ! 51-80,61-90,71-00,81-10,91-20

      its=(id-1)*10+1+1+ii ! ii=0 skip 1950; ii=1 skip 1949-50
      ite=(id-1)*10+30+1+ii 

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
      do i=1,31 ! i=1 is 1950
c       anom(i)=(ts(i)-clm(1))/std(1)
        anom(i)=ts(i)-clm(1)
      enddo

      do id=1,nwmo-1 ! 81-90,91-00,01-10,11-20,21-cur
        its=30+(id-1)*10+1+1+ii ! +1 is for skip 1949-1950
        ite=30+id*10+1+ii
        do i=its,ite
c         anom(i)=(ts(i)-clm(id))/std(id)
          anom(i)=ts(i)-clm(id)
        enddo
      enddo

      its=30+(nwmo-1)*10+1+1+ii 
      ite=nt

      if(ite.ge.its) then
      do i=its,ite
c       anom(i)=(ts(i)-clm(nwmo))/std(nwmo)
        anom(i)=ts(i)-clm(nwmo)
      enddo
      endif

      return
      end

      SUBROUTINE clm_std_anom(ts,std,clm,anom,maxt,nt,its,ite)
C WMO std, clm, and anom

      DIMENSION ts(maxt),anom(maxt)

      nclm=its+nt-1
      cc=0.
      do i=its,nclm
        cc=cc+ts(i)
      enddo
      clm=cc/float(nt)
c
      do i=its,ite
        anom(i)=ts(i)-clm
      enddo

      sd=0
      do i=its,nclm
        sd=sd+anom(i)*anom(i)
      enddo
      std=sqrt(sd/float(nt))
      if(std.lt.0.01) std=0.01

C have normalized anom
c
      do i=its,ite
        anom(i)=(ts(i)-clm)/std
      enddo

      return
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
c        av1=av1+f1(it)/float(ltime)
c        av2=av2+f2(it)/float(ltime)
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

      SUBROUTINE clim_anom_std(ts,cc,sd,maxt,nt)
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
      sd=0
      do i=1,nt
        sd=sd+ts(i)*ts(i)
      enddo
      sd=sqrt(sd/float(nt))
c
      return
      end

      SUBROUTINE clim_anom_4(ts,ntot,nss,clm)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. calculate seasonal anom 
C===========================================================
      DIMENSION ts(ntot),clm(4)

      do m=1,4
        clm(m)=0.
        ir=0
        do i=m,nss,4
        ir=ir+1
         clm(m)=clm(m)+ts(i)
        enddo
        clm(m)=clm(m)/float(ir)
      enddo
c  
      do m=1,4
        do i=m,nss,4
          ts(i)=ts(i)-clm(m)
        enddo
      enddo
c
      return
      end

      SUBROUTINE clim_anom_12(ts,ntot,nyr,clm)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. calculate seasonal anom 
C===========================================================
      DIMENSION ts(ntot),clm(12)

      nss=nyr*12

      do m=1,12
        clm(m)=0.
        do i=m,nss,12
         clm(m)=clm(m)+ts(i)
        enddo
        clm(m)=clm(m)/float(nyr)
      enddo
c  
      do m=1,12
        do i=m,nss,12
          ts(i)=ts(i)-clm(m)
        enddo
      enddo

      nleft=ntot-nss

      do m=1,nleft
        ts(nss+m)=ts(nss+m)-clm(m)
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


      SUBROUTINE normal(rot,rot2,ltime,nss)
      DIMENSION rot(ltime),rot2(ltime)
      avg=0.
      do i=1,nss
         avg=avg+rot(i)
      enddo
      avg=avg/float(nss)

      do i=1,nss
        rot2(i)=rot(i)-avg
      enddo
c
      sd=0.
      do i=1,nss
        sd=sd+rot2(i)*rot2(i)
      enddo
      sd=sd/float(nss)
      sd=sqrt(sd)

      do i=1,nss
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
