      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C PCR for forecst TPZ
C===========================================================
      real fld(imx,jmx),fld2(imx,jmx)
      real ac(imx,jmx,leadmax),rm(imx,jmx,leadmax)
      real wtd(imx,jmx,3),wts(imx,jmx,leadmax,3)
      real ts0(nyr),ts1(nyr),ts2(nyr)
      real ts3(nyr),ts4(nyr),ts5(nyr)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real w2d(imx,jmx),w2d2(imx,jmx),w2d3(imx,jmx)
      real w2d4(imx,jmx),w2d5(imx,jmx),w2d6(imx,jmx)
      real fcst(imx,jmx,nyr,leadmax)
      real vfld(imx,jmx,nyr)
      real wtfcst(imx,jmx,nyr,4,nlead)
      real avgo(imx,jmx),avgf(imx,jmx,4,nlead)
      real stdo(imx,jmx),stdf(imx,jmx,4,nlead)
      real aavef(4,nlead)
      real cor(imx,jmx),rms(imx,jmx)
      real cor2(imx,jmx),rms2(imx,jmx)
      real cor3(imx,jmx),rms3(imx,jmx)
      real cor4(imx,jmx),rms4(imx,jmx)
C
      do i=1,leadmax
        ich1=10+i
        ich2=50+i
        open(ich1,form='unformatted',access='direct',recl=4*imx*jmx)
        open(ich2,form='unformatted',access='direct',recl=4*imx*jmx) 
      enddo

      open(91,form='unformatted',access='direct',recl=4*imx*jmx) !fcst
      open(92,form='unformatted',access='direct',recl=4*imx*jmx) !skill
      open(93,form='unformatted',access='direct',recl=4) !sp !skill
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-89.5+(j-1)*1.
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use
        cosr(j)=sqrt(coslat(j))
      enddo

      undef=-999.0
C
C== read cor skill of all leads

      do ilead=1,leadmax
        ich=10+ilead
        read(ich,rec=1) fld
        read(ich,rec=2) fld2
        do i=1,imx
        do j=1,jmx
          ac(i,j,ilead)=fld(i,j)
          rm(i,j,ilead)=fld2(i,j)
        enddo
        enddo
      enddo
C
C== read forecast of all leads

      do ilead=1,leadmax
        ich=50+ilead
        ir=0
        do it=1,nyr
          ir=ir+2
          read(ich,rec=ir) fld !fcst
          do i=1,imx
          do j=1,jmx
            fcst(i,j,it,ilead)=fld(i,j)
          enddo
          enddo
        enddo
      enddo
C
C== read obs

      ir=1
      do it=1,nyr
        read(51,rec=ir) fld !obs
        do i=1,imx
        do j=1,jmx
          vfld(i,j,it)=fld(i,j)
        enddo
        enddo
        ir=ir+2
      enddo
C
C for leads of weighted fcst
      do kld=1,nlead ! lead of weighted fcst
C== have denominator of the weights

      do i=1,imx
      do j=1,jmx
        if(fld(i,j).gt.-900) then
          wtd(i,j,1)=0
          wtd(i,j,2)=0
          wtd(i,j,3)=0
          do ilead=kld,leadmax
            if(ac(i,j,ilead).gt.0.) then
              wtd(i,j,1)=wtd(i,j,1)+ac(i,j,ilead)
              wtd(i,j,3)=wtd(i,j,3)+ac(i,j,ilead)**2
            else
              wtd(i,j,1)=wtd(i,j,1)+0.
              wtd(i,j,3)=wtd(i,j,3)+0.
            endif
              wtd(i,j,2)=wtd(i,j,2)+ac(i,j,ilead)**2
          enddo
        else
        wtd(i,j,1)=undef
        wtd(i,j,2)=undef
        wtd(i,j,3)=undef
        endif
      enddo
      enddo
C
C== have weights for each lead
      do ilead=kld,leadmax
        do i=1,imx
        do j=1,jmx
          if(fld(i,j).gt.-900) then
            if(ac(i,j,ilead).gt.0.) then
              wts(i,j,ilead,1)=ac(i,j,ilead)/wtd(i,j,1)
              wts(i,j,ilead,2)=ac(i,j,ilead)**2/wtd(i,j,2)
              wts(i,j,ilead,3)=ac(i,j,ilead)**2/wtd(i,j,3)
            else
              wts(i,j,ilead,1)=0.
              wts(i,j,ilead,2)=-ac(i,j,ilead)**2/wtd(i,j,2)
              wts(i,j,ilead,3)=0.
            endif
          else
            wts(i,j,ilead,1)=undef
            wts(i,j,ilead,2)=undef
            wts(i,j,ilead,3)=undef
          endif
        enddo
        enddo
      enddo
C
C== have ensemble forecast
      do it=1,nyr
        do i=1,imx
        do j=1,jmx
          if(fld(i,j).gt.-900) then
            w2d(i,j)=0.
            w2d2(i,j)=0.
            w2d3(i,j)=0.
            w2d4(i,j)=0.
            w2d5(i,j)=vfld(i,j,it)
            do ilead=kld,leadmax
            w2d(i,j)=w2d(i,j)+fcst(i,j,it,ilead)/float(leadmax-kld+1)
            w2d2(i,j)=w2d2(i,j)+wts(i,j,ilead,1)*fcst(i,j,it,ilead)
            w2d3(i,j)=w2d3(i,j)+wts(i,j,ilead,2)*fcst(i,j,it,ilead)
            w2d4(i,j)=w2d4(i,j)+wts(i,j,ilead,3)*fcst(i,j,it,ilead)
            enddo
          else
            w2d(i,j)=undef
            w2d2(i,j)=undef
            w2d3(i,j)=undef
            w2d4(i,j)=undef
            w2d5(i,j)=undef
          endif
          wtfcst(i,j,it,1,kld)=w2d(i,j)
          wtfcst(i,j,it,2,kld)=w2d2(i,j)
          wtfcst(i,j,it,3,kld)=w2d3(i,j)
          wtfcst(i,j,it,4,kld)=w2d4(i,j)
        enddo
        enddo
        enddo ! it loop

        enddo ! kld loop
c
c amplitude adjustment for obs
c
c std of obs
        do i=1,imx
        do j=1,jmx
          if (vfld(i,j,1).gt.undef) then
            avgo(i,j)=0.
            do it=1,nyr
            avgo(i,j)=avgo(i,j)+vfld(i,j,it)/float(nyr)
            enddo
          else
            avgo(i,j)=undef
          endif
        enddo
        enddo

        do i=1,imx
        do j=1,jmx
          if (vfld(i,j,1).gt.undef) then
            stdo(i,j)=0.
            do it=1,nyr
            stdo(i,j)=stdo(i,j)+
     &      (vfld(i,j,it)-avgo(i,j))**2
            enddo
            stdo(i,j)=sqrt(stdo(i,j)/float(nyr))
          else
            stdo(i,j)=undef
          endif
        enddo
        enddo


c std of wtfcst
        do i=1,imx
        do j=1,jmx
        do iv=1,4
        do ld=1,nlead
          if (wtfcst(i,j,1,1,1).gt.undef) then
            avgf(i,j,iv,ld)=0.
            do it=1,nyr
            avgf(i,j,iv,ld)=avgf(i,j,iv,ld)+wtfcst(i,j,it,iv,ld)/
     &float(nyr)
            enddo
          else
            avgf(i,j,iv,ld)=undef
          endif
        enddo
        enddo
        enddo
        enddo

        do i=1,imx
        do j=1,jmx
        do iv=1,4
        do ld=1,nlead
          if (wtfcst(i,j,1,1,1).gt.undef) then
            stdf(i,j,iv,ld)=0.
            do it=1,nyr
            stdf(i,j,iv,ld)=stdf(i,j,iv,ld)+
     &      (wtfcst(i,j,it,iv,ld)-avgf(i,j,iv,ld))**2
            enddo
            stdf(i,j,iv,ld)=sqrt(stdf(i,j,iv,ld)/float(nyr))
          else
            stdf(i,j,iv,ld)=undef
          endif
        enddo
        enddo
        enddo
        enddo
c
c area averaged std 
        area=0.
        aaveo=0.
        do i=1,imx
        do j=1,jmx
          if(vfld(i,j,1).gt.undef) then
          area=area+coslat(j)
          aaveo=aaveo+coslat(j)*stdo(i,j)
          endif
        enddo
        enddo
        aaveo=aaveo/area
c
      do iv=1,4
      do ld=1,nlead
        aavef(iv,ld)=0.
        do i=1,imx
        do j=1,jmx
          if(vfld(i,j,1).gt.undef) then
          aavef(iv,ld)=aavef(iv,ld)+coslat(j)*stdf(i,j,iv,ld)
          endif
        enddo
        enddo
          aavef(iv,ld)=aavef(iv,ld)/area
      enddo
      enddo
      write(6,*) 'aaveo std=',aaveo
      write(6,*) 'aavef std=',aavef

c amplitude adjstment
      do i=1,imx
      do j=1,jmx
      do iv=1,4
      do ld=1,nlead
      if (wtfcst(i,j,1,1,1).gt.undef) then
        do it=1,nyr
        wtfcst(i,j,it,iv,ld)=wtfcst(i,j,it,iv,ld)
c    &*aaveo/aavef(iv,ld)
        enddo
        else
        wtfcst(i,j,it,iv,ld)=undef
        endif
      enddo
      enddo
      enddo
      enddo
c
c write out obs and wtfcst
        iw=0
        do ld=1,nlead
        do it=1,nyr

           do i=1,imx
           do j=1,jmx
             w2d(i,j)=vfld(i,j,it)
           enddo
           enddo
           iw=iw+1
           write(91,rec=iw) w2d
        do iv=1,4
           do i=1,imx
           do j=1,jmx
             w2d(i,j)=wtfcst(i,j,it,iv,ld)
           enddo
           enddo
           iw=iw+1
           write(91,rec=iw) w2d
         enddo

         enddo
         enddo


c
c== temporal skill
      iw4=0
      DO kld=1,nlead

      DO i=1,imx
      DO j=1,jmx
c
      if(fld(i,j).gt.-900.) then
        do it=1,nyr
          ts0(it)=vfld(i,j,it)
          ts1(it)=wtfcst(i,j,it,1,kld)
          ts2(it)=wtfcst(i,j,it,2,kld)
          ts3(it)=wtfcst(i,j,it,3,kld)
          ts4(it)=wtfcst(i,j,it,4,kld)
        enddo
        call cor_rms(ts0,ts1,nyr,nyr,cor(i,j),rms(i,j))
        call cor_rms(ts0,ts2,nyr,nyr,cor2(i,j),rms2(i,j))
        call cor_rms(ts0,ts3,nyr,nyr,cor3(i,j),rms3(i,j))
        call cor_rms(ts0,ts4,nyr,nyr,cor4(i,j),rms4(i,j))
      else
        cor(i,j)=undef
        rms(i,j)=undef
        cor2(i,j)=undef
        rms2(i,j)=undef
        cor3(i,j)=undef
        rms3(i,j)=undef
        cor4(i,j)=undef
        rms4(i,j)=undef
      endif
      enddo
      enddo

      iw4=iw4+1
      write(92,rec=iw4) cor
      iw4=iw4+1
      write(92,rec=iw4) rms      
      iw4=iw4+1
      write(92,rec=iw4) cor2
      iw4=iw4+1
      write(92,rec=iw4) rms2      
      iw4=iw4+1
      write(92,rec=iw4) cor3
      iw4=iw4+1
      write(92,rec=iw4) rms3      
      iw4=iw4+1
      write(92,rec=iw4) cor4
      iw4=iw4+1
      write(92,rec=iw4) rms4      
c lead-1 skill
      do i=1,imx
      do j=1,jmx
        fld(i,j)=ac(i,j,kld)
        fld2(i,j)=rm(i,j,kld)
      enddo
      enddo
c
      iw4=iw4+1
      write(92,rec=iw4) fld
      iw4=iw4+1
      write(92,rec=iw4) fld2      

      enddo ! loop kld
c
c== spatially avg skill
      iw=0
      do ld=1,nlead
      do iy=1,nyr

        do i=1,imx
        do j=1,jmx
        w2d(i,j)=vfld(i,j,iy)
        w2d2(i,j)=wtfcst(i,j,iy,4,ld)
        enddo
        enddo

      call sp_cor_rms(w2d,w2d2,coslat,imx,jmx,
     &1,360,115,160,xcor,xrms)
      iw=iw+1
      write(93,rec=iw) xcor
      iw=iw+1
      write(93,rec=iw) xrms
      call sp_cor_rms(w2d,w2d2,coslat,imx,jmx,
     &230,300,115,140,xcor,xrms)
      iw=iw+1
      write(93,rec=iw) xcor
      iw=iw+1
      write(93,rec=iw) xrms

      enddo
      enddo

      stop
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


      SUBROUTINE havenino34(sst,xn34,imx,jmx,nt)
      DIMENSION sst(imx,jmx,nt),xn34(nt)
      do it=1,nt
        xn34(it)=0
        ngrd=50*10
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

      cor=0.
      sd1=0.
      sd2=0.

      do it=1,nt
         cor=cor+f1(it)*f2(it)/float(nt)
         sd1=sd1+f1(it)*f1(it)/float(nt)
         sd2=sd2+f2(it)*f2(it)/float(nt)
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
        if(fld1(i,j).gt.-900.) then
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
        if(fld1(i,j).gt.-900.) then
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

