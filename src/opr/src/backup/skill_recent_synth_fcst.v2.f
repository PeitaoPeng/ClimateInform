      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C PCR for forecst TPZ
C===========================================================
      parameter(kpdf=1000)

      real w2d(imx,jmx),w2d2(imx,jmx),w2d3(imx,jmx),w2d4(imx,jmx)
      real w2d5(imx,jmx),w2d6(imx,jmx)
      real tpz(imx,jmx,nss),stdo(imx,jmx,nlead,nss)
      real fcst(imx,jmx,nlead,nss)
      real xlat(jmx),coslat(jmx),cosr(jmx)

      real xbin(kpdf),ypdf(kpdf),prbprd(imx,jmx)
      real pa(imx,jmx,nlead,nss),pb(imx,jmx,nlead,nss)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !tpz
      open(11,form='unformatted',access='direct',recl=4*imx*jmx)

      open(91,form='unformatted',access='direct',recl=4) !1d_skill
      open(92,form='unformatted',access='direct',recl=4*imx*jmx) !2d

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
C=== read in fcst,stdo,pa,pb
      ir=0
      do it=1,nss 
      do ld=1,nlead

        ir=ir+1
        read(11,rec=ir) w2d
        ir=ir+1
        read(11,rec=ir) w2d2
        ir=ir+1
        read(11,rec=ir) w2d3
        ir=ir+1
        read(11,rec=ir) w2d4

        do i=1,imx
        do j=1,jmx
          fcst(i,j,ld,it)=w2d(i,j)
          stdo(i,j,ld,it)=w2d2(i,j)
          pa(i,j,ld,it)=w2d3(i,j)
          pb(i,j,ld,it)=w2d4(i,j)
        enddo
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
        tpz(i,j,it)=tpz(i,j,it)/stdo(i,j,2,it) ! lead-1 stdo
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
          w2d2(i,j)=fcst(i,j,2,it) ! lead-1 fcst
      enddo
      enddo

      call sp_cor_rms(w2d,w2d2,coslat,imx,jmx,
     &1,360,40,160,xcor,xrms)

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

      do i=1,imx
      do j=1,jmx
      w2d3(i,j)=pa(i,j,1,it)
      w2d4(i,j)=pb(i,j,1,it)
      enddo
      enddo

      call hss3c_prob_s(w2d,w2d3,w2d4,imx,jmx,1,360,40,160,coslat,h1)
      call hss3c_prob_s(w2d,w2d3,w2d4,imx,jmx,230,300,115,140,
     &coslat,h2)

      iw=iw+1
      write(91,rec=iw) h1
      iw=iw+1
      write(91,rec=iw) h2
c rpss 
      call rpss_s(w2d,w2d4,w2d3,rpss1,imx,jmx,1,360,40,160,coslat)
      call rpss_s(w2d,w2d4,w2d3,rpss2,imx,jmx,230,300,115,140,coslat)

      iw=iw+1
      write(91,rec=iw) rpss1
      iw=iw+1
      write(91,rec=iw) rpss2

      enddo ! it loop
c
c write out obs, fcst, and hit
        iw=0
        do it=1,nss

          do i=1,imx
          do j=1,jmx
            w2d(i,j)=tpz(i,j,it)
c           w2d2(i,j)=fcst(i,j,1,it)
            w2d2(i,j)=fcst(i,j,2,it) ! get lead-1 fcst
            w2d3(i,j)=stdo(i,j,1,it)
            w2d4(i,j)=pa(i,j,1,it)
            w2d5(i,j)=pb(i,j,1,it)
          enddo
          enddo

          iw=iw+1
          write(92,rec=iw) w2d
          iw=iw+1
          write(92,rec=iw) w2d2
          iw=iw+1
          write(92,rec=iw) w2d3
          iw=iw+1
          write(92,rec=iw) w2d4
          iw=iw+1
          write(92,rec=iw) w2d5

          call hit_skill(w2d,w2d4,w2d5,w2d6,imx,jmx)

          iw=iw+1
          write(92,rec=iw) w2d6

       enddo

      stop
      end

      SUBROUTINE hit_skill(obs,pa,pb,hit,imx,jmx)
      dimension obs(imx,jmx),hit(imx,jmx)
      dimension pa(imx,jmx),pb(imx,jmx)
      dimension nobs(imx,jmx),nprd(imx,jmx)
      dimension w1d(3)

      do i=1,imx
      do j=1,jmx

        if(obs(i,j).gt.-900) then

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

      SUBROUTINE hss3c_prob_s(obs,pa,pb,imx,jmx,is,ie,js,je,coslat,h)
      dimension obs(imx,jmx),pa(imx,jmx),pb(imx,jmx),pn(imx,jmx)
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

      SUBROUTINE prob_3c_prd(detp,prbp,pa,pb,pn,kpdf,xbin,xdel,ypdf,
     &frac)
c detp: deterministic prd
c prbp: problistic prd
      real xbin(kpdf),ypdf(kpdf)

      esm=frac*detp

      b1=-esm-0.43
      b2=-esm+0.43
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

      SUBROUTINE rpss_s(vfc,pb,pa,rpss,imx,jmx,is,ie,js,je,coslat)

      real pa(imx,jmx),pb(imx,jmx)
      real vfc(imx,jmx),coslat(jmx)
      real rps(imx,jmx),rpsc(imx,jmx)

      do i=is,ie
      do j=js,je
c       IF(vfc(i,j).gt.-900.and.pb(i,j).gt.-900) then
        IF(vfc(i,j).gt.-900.) then

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
          rps(i,j)=(y1-o1)**2 !rps
     &+(y2-o2)**2
          rpsc(i,j)=(1./3.-o1)**2 !rpsc
     &+(2./3.-o2)**2
        END IF

      enddo
      enddo
c area avg
        exp=0.
        expc=0.
        grd=0
        do i=is,ie
        do j=js,je
c         IF(vfc(i,j).gt.-900.and.pb(i,j).gt.-900) then
          IF(vfc(i,j).gt.-900) then
            exp=exp+coslat(j)*rps(i,j)
            expc=expc+coslat(j)*rpsc(i,j)
            grd=grd+coslat(j)
          END IF
        enddo
        enddo
        exp_rps =exp/grd
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

        IF(vfc(i,j,it).gt.-900) then

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
