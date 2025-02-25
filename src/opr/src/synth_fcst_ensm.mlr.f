      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C PCR for forecst TPZ
C===========================================================
      parameter(kpdf=1000)

      real prd(imx,jmx,mlead,nprd),stdo(imx,jmx,mlead)
      real cor(imx,jmx,mlead,nprd)
      real clmo(imx,jmx,mlead)
      real rms(imx,jmx,mlead,nprd),hss(imx,jmx,mlead,nprd)
      
      real hcst(imx,jmx,nprd,ny_hcst)

      real eprd(imx,jmx),ecor(imx,jmx)
      real erms(imx,jmx),ehss(imx,jmx)
      real oclm(imx,jmx),ostd(imx,jmx)

      real wts(imx,jmx,mlead,nprd),ws1d(nprd)
      real wts2(imx,jmx,nprd)
      real obs(imx,jmx,ny_hcst),ehcst(imx,jmx,ny_hcst)
      real prbhcst(imx,jmx,ny_hcst)
      real xn34(ny_hcst+1,mlead)

      real w1d(nprd),w1d2(nprd),w1d3(nprd),w1d4(nprd)
      real ts1(ny_hcst),ts2(ny_hcst),ts3(ny_hcst),ts4(ny_hcst)

      real ts2d(nprd,ny_hcst)
      real wt2d(nprd,ny_hcst)

      real w2d(imx,jmx),w2d2(imx,jmx),w2d3(imx,jmx)
      real w2d4(imx,jmx),w2d5(imx,jmx),w2d6(imx,jmx)

      real xlat(jmx),coslat(jmx),cosr(jmx)

      real xbin(kpdf),ypdf(kpdf),prbprd(imx,jmx)
      real pa(imx,jmx,ny_hcst),pb(imx,jmx,ny_hcst),pn(imx,jmx,ny_hcst)
      real xpa(imx,jmx),xpb(imx,jmx),xpn(imx,jmx)

      real frac(imx,jmx)

C
C fcst from sst, olr, slp & ocn
      open(11,form='unformatted',access='direct',recl=4*imx*jmx) !ersst
      open(12,form='unformatted',access='direct',recl=4*imx*jmx) !olr
      open(13,form='unformatted',access='direct',recl=4*imx*jmx) !slp
      open(14,form='unformatted',access='direct',recl=4*imx*jmx) !ocn
C hcst from sst, olr, slp & ocn
      open(15,form='unformatted',access='direct',recl=4*imx*jmx) !ersst
      open(16,form='unformatted',access='direct',recl=4*imx*jmx) !olr
      open(17,form='unformatted',access='direct',recl=4*imx*jmx) !slp
      open(18,form='unformatted',access='direct',recl=4*imx*jmx) !ocn
      open(19,form='unformatted',access='direct',recl=4) !nino34
      open(20,form='unformatted',access='direct',recl=4*imx*jmx) !frac
C synth output
      open(31,form='unformatted',access='direct',recl=4*imx*jmx) !fcst
      open(32,form='unformatted',access='direct',recl=4*imx*jmx) !hcst
      open(33,form='unformatted',access='direct',recl=4) !1d_skill
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-89.5+(j-1)*1.
        coslat(j)=cos(xlat(j)*3.14159/180) 
        cosr(j)=sqrt(coslat(j))
      enddo

      undef=-999.0

      xdel=10./float(kpdf)
      call pdf_tab(xbin,ypdf,xdel,kpdf)
C
C read in nino3.4 index
      ir=0
      do ld=1,mlead
      do it=1,ny_hcst+1
      ir=ir+1
      read(19,rec=ir) xn34(it,ld)
      enddo
      enddo ! loop ld

C=== read in fcst and stdo
      ich=10
      do ip=1,nprd 
      ich=ich+1

      ir=0
      do ld=1,mlead

        ir=ir+1
        read(ich,rec=ir) w2d
        ir=ir+1
        read(ich,rec=ir) w2d2
        ir=ir+1
        read(ich,rec=ir) w2d3
        ir=ir+1
        read(ich,rec=ir) w2d4
        ir=ir+1
        read(ich,rec=ir) w2d5
        ir=ir+1
        read(ich,rec=ir) w2d6

        do i=1,imx
        do j=1,jmx
          prd(i,j,ld,ip)=w2d(i,j)
          stdo(i,j,ld)=w2d2(i,j)
          cor(i,j,ld,ip)=w2d3(i,j)
          rms(i,j,ld,ip)=w2d4(i,j)
          hss(i,j,ld,ip)=w2d5(i,j)
          clmo(i,j,ld)=w2d6(i,j)
        enddo
        enddo

        enddo ! ld loop
        enddo ! ip loop
c
C=== have wts prd
      ir=0
      iw=0
      iw2=0
      iw3=0
      do ld=1,mlead

      ir2=ld*2-1
      read(20,rec=ir2) frac

C=== synthesize hcst with mlr
      do it=1,ny_hcst

      ich=14
      do ip=1,nprd 

      ich=ich+1

        ir1=ir+1
        read(ich,rec=ir1) w2d
        ir2=ir+2
        read(ich,rec=ir2) w2d2
        ir3=ir+3
        read(ich,rec=ir3) w2d3
        ir4=ir+4
        read(ich,rec=ir4) w2d4

        do i=1,imx
        do j=1,jmx
          obs(i,j,it)=w2d(i,j)
          hcst(i,j,ip,it)=w2d2(i,j)
        enddo
        enddo
      enddo ! ip loop
      ir=ir+4
      enddo ! it loop

C=== have wts from mlr
      do itgt=1,ny_hcst

      do i=1,imx
      do j=1,jmx

      if (w2d(i,j).gt.-900.) then

        k=0
        do iy=1,ny_hcst

          if(iy /= itgt)  then

          k=k+1
          ts1(k)=obs(i,j,iy)
          do ip=1,nprd
            ts2d(ip,k)=hcst(i,j,ip,iy)
          enddo
          endif

        enddo ! loop iy

        rdg=ridge
        go to 212
 211    continue
        rdg=rdg+del
 212    continue

        call get_mlr_wt(ts1,ts2d,ws1d,nprd,ny_hcst,ny_hcst-1,rdg)

        ws=0
        do k=1,nprd
        ws=ws+ws1d(k)*ws1d(k)
        enddo
        if(ws.gt.0.5) go to 211

          nmodel=nprd
          if(abs(xn34(it,ld)).gt.xncrt) nmodel=1

          if(nmodel.eq.1) then
            ws1d(1)=1.
            do ip=2,nprd
            ws1d(ip)=0.
            enddo
          endif

          do ip=1,nprd
            w1d(ip)=hcst(i,j,ip,itgt)
          enddo

          call wtavg(w1d,ws1d,nprd,avg)

          ehcst(i,j,itgt)=avg
          w2d(i,j)=avg
      ELSE
          ehcst(i,j,itgt)=undef
          w2d(i,j)=undef
      ENDIF

          w2d2(i,j)=obs(i,j,itgt)

      enddo
      enddo

      enddo ! itgt loop

C=== synthesize prd with mlr

      do i=1,imx
      do j=1,jmx

      IF (w2d(i,j).gt.-900.) then

        do iy=1,ny_hcst
          ts1(iy)=obs(i,j,iy)
          do ip=1,nprd
            ts2d(ip,iy)=hcst(i,j,ip,iy)
          enddo
        enddo ! loop iy

        rdg=ridge
        go to 312
 311    continue
        rdg=rdg+del
 312    continue

        call get_mlr_wt(ts1,ts2d,ws1d,nprd,ny_hcst,ny_hcst,rdg)

        ws=0
        do k=1,nprd
        ws=ws+ws1d(k)*ws1d(k)
        enddo
        if(ws.gt.0.5) go to 311

          nmodel=nprd
          if(abs(xn34(it,ld)).gt.xncrt) nmodel=1

          if(nmodel.eq.1) then
            ws1d(1)=1.
            do ip=2,nprd
            ws1d(ip)=0.
            enddo
          endif

          do ip=1,nprd
            w1d(ip)=prd(i,j,ld,ip)
          enddo

          call wtavg(w1d,ws1d,nprd,eprd(i,j))

      ELSE
          eprd(i,j)=undef
      ENDIF
          ostd(i,j)=stdo(i,j,ld)
      enddo
      enddo

C std of ehcst
      do i=1,imx
      do j=1,jmx

        if (w2d(i,j).gt.-900.) then

          do it=1,ny_hcst
            ts1(it)=ehcst(i,j,it)
          enddo

          call normal(ts1,ny_hcst,ny_clm,esd)

          do it=1,ny_hcst
            ehcst(i,j,it)=ts1(it)
          enddo
c normalize eprd with hcst std
          eprd(i,j)=eprd(i,j)/esd

        endif
      enddo
      enddo

C have & write out ehcst, prob-hcst and 1-D skill
      DO it=1,ny_hcst

      do i=1,imx
      do j=1,jmx

        w2d(i,j)=obs(i,j,it)
        w2d2(i,j)=ehcst(i,j,it)

c prob-hcst
      if (w2d2(i,j).gt.-900.and.w2d(i,j).gt.-900) then

        call prob_3c_prd(w2d2(i,j),prbprd(i,j),pa(i,j,it),pb(i,j,it),
     &pn(i,j,it),kpdf,xbin,xdel,ypdf,frac(i,j))   

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

      iw2=iw2+1
      write(32,rec=iw2) w2d ! obs
      iw2=iw2+1
      write(32,rec=iw2) w2d2  ! esm_hcst
      iw2=iw2+1
      write(32,rec=iw2) prbprd  ! prob-prd
      iw2=iw2+1
      write(32,rec=iw2) w2d3  ! prob_a
      iw2=iw2+1
      write(32,rec=iw2) w2d4  ! prob_b
      iw2=iw2+1
      write(32,rec=iw2) ostd

C 1-D skill

      call sp_cor_rms(w2d2,w2d,coslat,imx,jmx,
     &1,360,115,160,xcor,xrms)

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

      call hss3c_prob_s(w2d,w2d3,w2d2,imx,jmx,1,360,115,160,coslat,h1)
      call hss3c_prob_s(w2d,w2d3,w2d2,imx,jmx,230,300,115,140,
     &coslat,h2)

      iw3=iw3+1
      write(33,rec=iw3) h1
      iw3=iw3+1
      write(33,rec=iw3) h2

      call rpss_s(w2d,w2d2,w2d3,rpss1,imx,jmx,1,360,115,160,coslat)
      call rpss_s(w2d,w2d2,w2d3,rpss2,imx,jmx,230,300,115,140,coslat)

      iw3=iw3+1
      write(33,rec=iw3) rpss1
      iw3=iw3+1
      write(33,rec=iw3) rpss2

      enddo ! it loop

c temporal 2D skill calculation

      do i=1,imx
      do j=1,jmx

      if (w2d(i,j).gt.-900.) then

        do it=1,ny_hcst
          ts1(it)=obs(i,j,it)
          ts2(it)=ehcst(i,j,it)
          ts3(it)=pa(i,j,it)
          ts4(it)=pb(i,j,it)
        enddo

        call cor_rms(ts1,ts2,ny_hcst,ny_hcst,ecor(i,j),erms(i,j))

        call hss3c_prob_t(ts1,ts3,ts4,ny_hcst,ny_hcst,ehss(i,j))

      else

        ecor(i,j)=undef
        erms(i,j)=undef
        ehss(i,j)=undef

      endif

      ostd(i,j)=stdo(i,j,ld)
      oclm(i,j)=clmo(i,j,ld)

      enddo
      enddo

      iw=iw+1
      write(31,rec=iw) eprd
      iw=iw+1
      write(31,rec=iw) ostd
      iw=iw+1
      write(31,rec=iw) ecor
      iw=iw+1
      write(31,rec=iw) erms
      iw=iw+1
      write(31,rec=iw) ehss
      iw=iw+1
      write(31,rec=iw) oclm

c have prob forecast
c
      do i=1,imx
      do j=1,jmx

      if (eprd(i,j).gt.-900.and.ostd(i,j).gt.-900.) then
        call prob_3c_prd(eprd(i,j),prbprd(i,j),xpa(i,j),xpb(i,j),
     &xpn(i,j),kpdf,xbin,xdel,ypdf,frac(i,j))
      else
        prbprd(i,j)=undef
        xpa(i,j)=undef
        xpb(i,j)=undef
        xpn(i,j)=undef
      endif

      if (abs(prbprd(i,j)).gt.1.) then
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

      call rpss_t(obs,pb,pa,w2d,imx,jmx,ny_hcst,undef)

      iw=iw+1
      write(31,rec=iw) w2d

      enddo ! ld loopo

      stop
      end


      SUBROUTINE rpss_s(vfc,pb,pa,rpss,imx,jmx,is,ie,js,je,coslat)

      real pa(imx,jmx),pb(imx,jmx)
      real vfc(imx,jmx),coslat(jmx)
      real rps(imx,jmx),rpsc(imx,jmx)

      do i=is,ie
      do j=js,je
        IF(vfc(i,j).gt.-900) then

          va=0.
          vb=0.
          vn=0.
          if(vfc(i,j).gt.0.43) va=1
          if(vfc(i,j).lt.-0.43) vb=1
          if(vfc(i,j).ge.-0.43.and.vfc(i,j).le.0.43) vn=1
c have rps        
          pn=1.- pa(i,j) - pb(i,j)
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

      SUBROUTINE rpss_t(vfc,pb,pa,rpss,imx,jmx,nt,undef)

      real pa(imx,jmx,nt),pb(imx,jmx,nt)
      real vfc(imx,jmx,nt),rpss(imx,jmx)
      real rps(imx,jmx,nt),rpsc(imx,jmx,nt)

c convert vfc to probilistic form
      do it=1,nt
        do i=1,imx
        do j=1,jmx
        IF(vfc(i,j,it).gt.-900) then

          va=0.
          vb=0.
          vn=0.
          if(vfc(i,j,it).gt.0.43) va=1
          if(vfc(i,j,it).lt.-0.43) vb=1
          if(vfc(i,j,it).ge.-0.43.and.vfc(i,j,it).le.0.43) vn=1
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
        do it=1,nt
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

      SUBROUTINE weights(cor,n,wts)
      dimension cor(n),wts(n) 

C== have denominator of the weights
      wd=0
      do i=1,n
        if(cor(i).gt.0.) then
          wd=wd+cor(i)**2
        else
          wd=wd+0.
        endif
      enddo
C
C== have weights
      if(wd.gt.0.01) then

        do i=1,n
         if(cor(i).gt.0.) then
          wts(i)=cor(i)**2/wd
        else
          wts(i)=0.
        endif
        enddo

      else

        do i=1,n
          wts(i)=0.
        enddo
        k = maxloc(cor,1)
        wts(k)=1.

      endif

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

      SUBROUTINE hss3c_prob_s(obs,pa,pb,imx,jmx,is,ie,js,je,coslat,h)
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
      h=(h-tot/3.)/(tot-tot/3.)*100.

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

      SUBROUTINE hss3c_prob_t(obs,pa,pb,ny,nt,h)
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
C  Have 3-category prob by integratinge PDF
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine prob_3c(n,n1,n2,xx,xdel,yy,pb,pa,pn)
      real xx(n),yy(n)
      pb=0
      do i=1,n1
      pb=pb+xdel*yy(i)
      enddo
      pa=0
      do i=n2,n
      pa=pa+xdel*yy(i)
      enddo
      pn=0
      do i=n1+1,n2-1
      pn=pn+xdel*yy(i)
      enddo
      return
      end
