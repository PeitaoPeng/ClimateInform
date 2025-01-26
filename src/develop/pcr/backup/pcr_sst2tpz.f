      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C===========================================================
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C===========================================================
      PARAMETER (nfld=ltime-1,nw=2*nfld+15)
c     PARAMETER (ngrd=(late-lats+1)*(lone-lons+1))
      real fld(imx,jmx),fld2(imx,jmx)
      real fld3(imx,jmx),fld4(imx,jmx),fld5(imx,jmx)
      real corr(imx,jmx,nmod),regr(imx,jmx,nmod)
      real corr2(imx,jmx,nmod),regr2(imx,jmx,nmod)
      real cor2d(imx,jmx),rms2d(imx,jmx)
      real ts1(ltime),ts2(ltime)
      real rin(nfld),rot2(nfld),rot(nfld)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real w2d(imx,jmx),w2d2(imx,jmx)
      real tcof(nmod,ltime),tcofm(nmod,nfld)
      real pj(nmod),proj(nmod,ltime)
      real tpz(imx,jmx,ltime),tpzm(imx,jmx,nfld)
      real fcst(imx,jmx,ltime)
      real sst(imx,jmx,ltime),sstm(imx,jmx,nfld)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !3_d data
      open(11,form='unformatted',access='direct',recl=4*imx*jmx) !3_d data

      open(20,form='unformatted',access='direct',recl=4)
      open(21,form='unformatted',access='direct',recl=4*imx*jmx)

      open(30,form='unformatted',access='direct',recl=4) !proj
      open(31,form='unformatted',access='direct',recl=4*imx*jmx) !fcst
      open(32,form='unformatted',access='direct',recl=4*imx*jmx) !skill
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-89.5+(j-1)*1.
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use
        cosr(j)=sqrt(coslat(j))
      enddo

      undef=-999.0

c     write(6,*) 'coslat=',coslat
C==read in obs sst
      do it=1,ltime
        read(10,rec=it+nskip) fld
        read(11,rec=it+nskip) fld2
        do i=1,imx
        do j=1,jmx
          sst(i,j,it)=fld(i,j)
          tpz(i,j,it)=fld2(i,j)
        enddo
        enddo
      enddo
C have anomalies over time 1 to ltime
c
      do i=1,imx
      do j=1,jmx
        if(fld(i,j).gt.-900.) then
        do it=1,ltime
        ts1(it)=sst(i,j,it)
        ts2(it)=tpz(i,j,it)
        enddo
        call anom(ts1,ltime)
        call anom(ts2,ltime)
        do it=1,ltime
        sst(i,j,it)=ts1(it)
        tpz(i,j,it)=ts2(it)
        enddo
        endif
      enddo
      enddo
c
c EOF analysis for all ltime data
c
      call pc_eof(sst,imx,jmx,lons,lone,lats,late,ltime,cosr,
     &ngrd,nmod,tcof,corr,regr,undef,id)
c
      iw=0
      iw2=0
      do m=1,nmod

c write out PC
      do it=1,ltime
      iw=iw+1
      write(20,rec=iw) tcof(m,it)
      enddo

c write out corr&regr patterns
      do i=1,imx
      do j=1,jmx
        w2d(i,j)=corr(i,j,m)
        w2d2(i,j)=regr(i,j,m)
      enddo
      enddo
      iw2=iw2+1
      write(21,rec=iw2) w2d
      iw2=iw2+1
      write(21,rec=iw2) w2d2

      enddo ! m loop
c
c CV-1 for EOF and regression analysis
c
      iw3=0
      do itgt=1,ltime
        iy=0
        do iyr=1,ltime
          if (iyr.ne.itgt) then
            iy=iy+1
            do i=1,imx
            do j=1,jmx
              sstm(i,j,iy)=sst(i,j,iyr)
              tpzm(i,j,iy)=tpz(i,j,iyr)
            enddo
            enddo
          else
            do i=1,imx
            do j=1,jmx
              w2d(i,j)=sst(i,j,itgt) !sst of itgt yr
            enddo
            enddo
          endif
        enddo ! iyr loop
c
c have eof for sstm
      call pc_eof(sstm,imx,jmx,lons,lone,lats,late,nfld,cosr,
     &ngrd,nmod,tcofm,corr,regr,undef,id)
c
c project itgt year sst to regr patterns
      call sp_proj(w2d,regr,imx,jmx,nmod,lons,lone,lats,late,coslat,
     &undef,pj)
c
      do m=1,nmod
        proj(m,itgt)=pj(m)
      enddo
c
c have tpz 'fcst' for itgt year with proj and tpz regr
      call tpz_regr(tpzm,tcofm,imx,jmx,nfld,nmod,corr2,regr2,undef)
c
      call setzero(w2d,imx,jmx)
      do m=1,nmod
        do i=1,imx
        do j=1,jmx
          w2d(i,j)=w2d(i,j)+pj(m)*regr2(i,j,m)
        enddo
        enddo
      enddo !m loop

c write out 'forecasted' tpz
      iw3=iw3+1
      write(31,rec=iw3) w2d

      do i=1,imx
      do j=1,jmx
        fcst(i,j,itgt)=w2d(i,j)
      enddo
      enddo

      enddo ! itgt loop
c
c==cor and rms of reconstructed field
c
      DO i=1,imx
      DO j=1,jmx
c
      do it=1,ltime
      ts1(it)=tpz(i,j,it)
      ts2(it)=fcst(i,j,it)
      enddo

      call cor_rms(ts1,ts2,ltime,cor2d(i,j),rms2d(i,j))

      enddo
      enddo

      iw4=1
      write(32,rec=iw4) cor2d
      iw4=iw4+1
      write(32,rec=iw4) rms2d
c
c write out proj
      iw=0
      do m=1,nmod
      do it=1,ltime
      iw=iw+1
      write(30,rec=iw) proj(m,it)
      enddo
      enddo !m loop

      stop
      end

      SUBROUTINE cor_rms(f1,f2,ltime,cor,rms)

      real f1(ltime),f2(ltime)

      cor=0.
      sd1=0.
      sd2=0.
      rms=0.

      do it=1,ltime
         cor=cor+f1(it)*f2(it)/float(ltime)
         sd1=sd1+f1(it)*f1(it)/float(ltime)
         sd2=sd2+f2(it)*f2(it)/float(ltime)
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

      call regr_t(ts1,ts2,nfld,corr(i,j,m),regr(i,j,m))
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

      SUBROUTINE pc_eof(f3d,imx,jmx,is,ie,ls,le,nfld,cosr,
     &ngrd,nmod,pc,corr,regr,undef,id)

      real f3d(imx,jmx,nfld),cosr(jmx)
      real regr(imx,jmx,nmod),corr(imx,jmx,nmod),pc(nmod,nfld)
      real aaa(ngrd,nfld),wk(nfld,ngrd)
      real eval(nfld),evec(ngrd,nfld),coef(nfld,nfld)
      real ts1(nfld),ts2(nfld)

      do it=1,nfld
        ng=0
        do j=ls,le
        do i=is,ie
        if(f3d(i,j,1).gt.undef) then
          ng=ng+1
          aaa(ng,it)=f3d(i,j,it)*cosr(j)
        endif
        end do
        end do
      enddo ! it loop
      write(6,*) 'ngrd= ',ng
c
      call eofs(aaa,ngrd,nfld,nfld,eval,evec,coef,wk,id)
c
c normalize coef
      do m=1, nmod
      do it=1,nfld
        ts1(it)=coef(m,it)
      enddo
c
      call normal(ts1,ts2,nfld)
c
      do it=1,nfld
        pc(m,it)=ts2(it)
      enddo
      enddo ! m loop
c
cc... write out eval
      totv=0
      do m=1,nmod
      write(6,*)'eval= ',i,eval(m)
      totv=totv+eval(m)
      end do
      write(6,*)'totv= ',totv
c
      do i=1,nfld
      write(6,*)'eval= ',i,eval(i)
      end do
c
cc have regr patterns
      do m=1,nmod
c
      do it=1,nfld
        ts1(it)=pc(m,it)
      enddo
c
      do j=1,jmx
      do i=1,imx

      if(f3d(i,j,1).gt.undef) then

      do it=1,nfld
        ts2(it)=f3d(i,j,it)
      enddo

      call regr_t(ts1,ts2,nfld,corr(i,j,m),regr(i,j,m))
      else
      corr(i,j,m)=undef
      regr(i,j,m)=undef
      regr(i,j,m)=undef
      endif

      enddo
      enddo

      enddo !m loop

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

      SUBROUTINE anom(rot,ltime)
      DIMENSION rot(ltime)
      avg=0.
      do i=1,ltime
         avg=avg+rot(i)/float(ltime)
      enddo
      do i=1,ltime
        rot(i)=rot(i)-avg
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

      SUBROUTINE regr_t(f1,f2,ltime,cor,reg)

      real f1(ltime),f2(ltime)

      cor=0.
      sd1=0.
      sd2=0.

      do it=1,ltime
         cor=cor+f1(it)*f2(it)/float(ltime)
         sd1=sd1+f1(it)*f1(it)/float(ltime)
         sd2=sd2+f2(it)*f2(it)/float(ltime)
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
        area=area+coslat(j)
      enddo
      enddo
c     write(6,*) 'area=',area

      cor=0.
      rms=0.
      sd1=0.
      sd2=0.

      do j=lat1,lat2
      do i=lon1,lon2
         cor=cor+fld1(i,j)*fld2(i,j)*coslat(j)/area
         rms=rms+(fld1(i,j)-fld2(i,j))*(fld1(i,j)-fld2(i,j))
     &*coslat(j)/area
         sd1=sd1+fld1(i,j)*fld1(i,j)*coslat(j)/area
         sd2=sd2+fld2(i,j)*fld2(i,j)*coslat(j)/area
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

