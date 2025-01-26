      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C PCR for forecst TPZ
C===========================================================
      real w2d(imx,jmx),w2d2(imx,jmx),w2d3(imx,jmx)
      real tpz(imx,jmx,nt),stdo(imx,jmx,nt),fcst(imx,jmx,nt)
      real xlat(jmx),coslat(jmx),cosr(jmx)
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
C
C=== read in fcst and stdo
      ich=10
      do it=1,nss 
      ich=ich+1

        read(ich,rec=1) w2d
        read(ich,rec=2) w2d2

        do i=1,imx
        do j=1,jmx
          fcst(i,j,it)=w2d(i,j)
          stdo(i,j,it)=w2d2(i,j)
        enddo
        enddo

      enddo
c
C=== read in tpz anom
      ir=0
      do it=its_vf, ite_vf
        ir=ir+1
        read(10,rec=it) w2d
        do i=1,imx
        do j=1,jmx
          tpz(i,j,ir)=w2d(i,j)
        enddo
        enddo
      enddo
c
c standardized tpz
      do i=1,imx
      do j=1,jmx

      do it=1,nss
      if (w2d(i,j).gt.-900.) then
        tpz(i,j,it)=tpz(i,j,it)/stdo(i,j,it)
      else
        tpz(i,j,it)=undef
      endif
      enddo

      enddo
      enddo
c
c== spatial skill
      iw=0
      do it=1,nss

        do i=1,imx
        do j=1,jmx
          w2d(i,j)=tpz(i,j,it)
          w2d2(i,j)=fcst(i,j,it)
        enddo
        enddo

      call sp_cor_rms(w2d,w2d2,coslat,imx,jmx,
     &1,360,115,160,xcor,xrms)

      iw=iw+1
      write(91,rec=iw) xcor
      iw=iw+1
      write(91,rec=iw) xrms

      call sp_cor_rms(w2d,w2d2,coslat,imx,jmx,
     &230,300,115,140,xcor,xrms)
      iw=iw+1
      write(91,rec=iw) xcor
      iw=iw+1
      write(91,rec=iw) xrms

      call hss3c_s(w2d,w2d2,imx,jmx,1,360,115,160,coslat,h1)
      call hss3c_s(w2d,w2d2,imx,jmx,230,300,115,140,coslat,h2)

      iw=iw+1
      write(91,rec=iw) h1
      iw=iw+1
      write(91,rec=iw) h2

      enddo ! it loop
c
c write out obs, fcst, and hit
        iw=0
        do it=1,nss

          do i=1,imx
          do j=1,jmx
            w2d(i,j)=tpz(i,j,it)
            w2d2(i,j)=fcst(i,j,it)
            w2d3(i,j)=stdo(i,j,it)
          enddo
          enddo

          iw=iw+1
          write(92,rec=iw) w2d
          iw=iw+1
          write(92,rec=iw) w2d3
          iw=iw+1
          write(92,rec=iw) w2d2

          call hit_skill(w2d,w2d2,w2d3,imx,jmx)

          iw=iw+1
          write(92,rec=iw) w2d3

       enddo

      stop
      end

      SUBROUTINE hit_skill(obs,prd,hit,imx,jmx)
      dimension obs(imx,jmx),prd(imx,jmx),hit(imx,jmx)
      dimension nobs(imx,jmx),nprd(imx,jmx)

      do i=1,imx
      do j=1,jmx

        if(obs(i,j).gt.-900) then

        if(obs(i,j).gt.0.43) nobs(i,j)=1
        if(obs(i,j).lt.-0.43) nobs(i,j)=-1
        if(obs(i,j).ge.-0.43.and.obs(i,j).le.0.43) nobs(i,j)=0

        if(prd(i,j).gt.0.43) nprd(i,j)=1
        if(prd(i,j).lt.-0.43) nprd(i,j)=-1
        if(prd(i,j).ge.-0.43.and.prd(i,j).le.0.43) nprd(i,j)=0

       if (nobs(i,j).eq.nprd(i,j)) then
       hit(i,j)=1
       else
       hit(i,j)=0
       endif

       endif

      enddo
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

