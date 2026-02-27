      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C PC_SVD for forecst TPZ
C===========================================================
c     PARAMETER (ngrd=(late-lats+1)*(lone-lons+1))
      real fld(imx,jmx),fld2(imx,jmx)
      real fld3(imx,jmx),fld4(imx,jmx),fld5(imx,jmx)
      real corr11(imx,jmx,nmod),regr11(imx,jmx,nmod)
      real corr21(imx,jmx,nmod),regr21(imx,jmx,nmod)
      real corr12(imx,jmx,nmod),regr12(imx,jmx,nmod)
      real corr22(imx,jmx,nmod),regr22(imx,jmx,nmod)
      real cor2d(imx,jmx),rms2d(imx,jmx)
      real ts1(nyr),ts2(nyr),ts3(nyr)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real w2d(imx,jmx),w2d2(imx,jmx)
      real w2d3(imx,jmx),w2d4(imx,jmx)
      real w2d5(imx,jmx),w2d6(imx,jmx)
      real w2d7(imx,jmx),w2d8(imx,jmx)
      real tpz(imx,jmx,nyr),wtpz(imx,jmx,nyr)
      real sst(imx,jmx,nyr),wsst(imx,jmx,nyr)
      real sstc(imx,jmx),tpzc(imx,jmx)
      real cof1(nmod,nyr),cof2(nmod,nyr)
      real fcst(imx,jmx,nyr-nfys+1)
      real vfld(imx,jmx,nyr-nfys+1)
      real fsst(imx,jmx,nyr),ftpz(imx,jmx,nyr)
      real cic(nmod),sdc1(nmod),sdc2(nmod)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !sst
      open(11,form='unformatted',access='direct',recl=4*imx*jmx) !tpz

      open(20,form='unformatted',access='direct',recl=4)
      open(21,form='unformatted',access='direct',recl=4*imx*jmx)

      open(30,form='unformatted',access='direct',recl=4*imx*jmx) !tp reg
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
C
C==read in sst of ilead IC and other same seasons

C== determine IC season (iic=1->12)
      iic=itgt-ilead-del
      if(iic.lt.1) iic=12+itgt-ilead-del
      if(iic.lt.1) iic=24+itgt-ilead-del
      write(6,*) 'ilead=',ilead,'iic=',iic

      ir=0
      do it=iic,nmon,12
        read(10,rec=it) fld
        ir=ir+1
        do i=1,imx
        do j=1,jmx
          sst(i,j,ir)=fld(i,j)
        enddo
        enddo
      enddo
C
C==read in tpz of itgt season
      ir=0
      do it=itgt,nmon,12
        read(11,rec=it) fld2
        ir=ir+1
        do i=1,imx
        do j=1,jmx
          tpz(i,j,ir)=fld2(i,j)
        enddo
        enddo
      enddo
C 
C loop for tgt yr
      iw3=0
      do iyr=nfys,nyr  !1995-curr

        ndf=itgt-iic ! see if there is a IC season in the tgt year
        if(ndf.ge.0) then 
          nclm=iyr !period for clim and anom
        else
          nclm=iyr-1
        endif
      write(6,*) 'ndf=',ndf
      write(6,*) 'nclm=',nclm
C
C have sst anomalies over period 1 -> nclm
      do i=1,imx
      do j=1,jmx
        if(fld(i,j).gt.undef) then
          do it=1,nclm
            ts1(it)=sst(i,j,it)
          enddo
          call clim_anom(ts1,sstc(i,j),nyr,nclm)
        else
          do it=1,nclm
            ts1(it)=undef
          enddo
          sstc(i,j)=undef
        endif
          do it=1,nclm
            wsst(i,j,it)=ts1(it)
          enddo
      enddo
      enddo
c
C have tpz anomalies over time 1 to iym
      iym=iyr-1
      do i=1,imx
      do j=1,jmx
        if(fld2(i,j).gt.undef) then
          do it=1,iym
            ts2(it)=tpz(i,j,it)
          enddo
          call clim_anom(ts2,tpzc(i,j),nyr,iym)
        else
          do it=1,iym
            ts2(it)=undef
          enddo
            tpzc(i,j)=undef
        endif
          do it=1,iym
            wtpz(i,j,it)=ts2(it)
          enddo
      enddo
      enddo
c
c prepare data for svd
      ics=itgt-ilead-del
      icsp=12+itgt-ilead-del
      iym2=iyr-2
      iym3=iyr-3
      if(ics.gt.0) then
        its_tpz=1
        ite_tpz=iym
        its_sst=1
        ite_sst=iym
      else if(icsp.gt.0) then
        its_tpz=2
        ite_tpz=iym
        its_sst=1
        ite_sst=iym2
      else
        its_tpz=3
        ite_tpz=iym
        its_sst=1
        ite_sst=iym3
      endif
      write(6,*) 'its_sst=',its_sst,'ite_sst=',ite_sst
      write(6,*) 'its_tpz=',its_tpz,'ite_tpz=',ite_tpz

      nfld=ite_sst - its_sst + 1  ! length of data for svd

c have fsst & ftpz used as input of svd      
      do i=1,imx
      do j=1,jmx
        ir=0
        do it=its_sst,ite_sst+1  ! +1 is for the use as IC in forecast
        ir=ir+1
        fsst(i,j,ir)=wsst(i,j,it)
        enddo
      enddo
      enddo

      do i=1,imx
      do j=1,jmx
        ir=0
        do it=its_tpz,ite_tpz
        ir=ir+1
        ftpz(i,j,ir)=wtpz(i,j,it)
        enddo
      enddo
      enddo
c
c SVD bwtween sst and tpz
      do m=1,nmod
      do it=1,nyr
        cof1(m,it)=undef
        cof2(m,it)=undef
      enddo
      enddo
C
      call have_svd(fsst,ftpz,nyr,nfld,imx,jmx,isv1,iev1,
     &jsv1,jev1,isv2,iev2,jsv2,jev2,ng1,ng2,cosr,nmod,cof1,cof2,
     &cic,undef,id,idel)
c
c==CORR between coef and data
      DO m=1,nmod !loop over mode
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

c for var1
      do i=1,imx
      do j=1,jmx

      if(fsst(i,j,1).gt.undef) then

      do it=1,nfld
        ts3(it)=fsst(i,j,it)
      enddo

      call regr_t(ts1,ts3,nyr,nfld,corr11(i,j,m),regr11(i,j,m))
      call regr_t(ts2,ts3,nyr,nfld,corr21(i,j,m),regr21(i,j,m))

       else
       corr11(i,j,m)=undef
       regr11(i,j,m)=undef
       corr21(i,j,m)=undef
       regr21(i,j,m)=undef
       endif

      enddo
      enddo

c for var2
      do i=1,imx
      do j=1,jmx

      if(ftpz(i,j,1).gt.undef) then

      do it=1,nfld
        ts3(it)=ftpz(i,j,it)
      enddo

      call regr_t(ts1,ts3,nyr,nfld,corr12(i,j,m),regr12(i,j,m))
      call regr_t(ts2,ts3,nyr,nfld,corr22(i,j,m),regr22(i,j,m))

      else
      corr12(i,j,m)=undef
      regr12(i,j,m)=undef
      corr22(i,j,m)=undef
      regr22(i,j,m)=undef
      endif

      enddo
      enddo

      enddo  ! m loop

C write out coef and patterns for the end of the iyr loop
      if(iyr.eq.nyr) then
      iw=0
      iw2=0
      do m=1,nmod

c write out PC
      do it=1,nyr
      iw=iw+1
      write(20,rec=iw) cof1(m,it)
      iw=iw+1
      write(20,rec=iw) cof2(m,it)
      enddo

c write out sst corr&regr patterns
      do i=1,imx
      do j=1,jmx
        w2d(i,j)= corr11(i,j,m)
        w2d2(i,j)=regr11(i,j,m)
        w2d3(i,j)=corr21(i,j,m)
        w2d4(i,j)=regr21(i,j,m)
        w2d5(i,j)=corr12(i,j,m)
        w2d6(i,j)=regr12(i,j,m)
        w2d7(i,j)=corr22(i,j,m)
        w2d8(i,j)=regr22(i,j,m)
      enddo
      enddo
c
      iw2=iw2+1
      write(21,rec=iw2) w2d
      iw2=iw2+1
      write(21,rec=iw2) w2d2
      iw2=iw2+1
      write(21,rec=iw2) w2d3
      iw2=iw2+1
      write(21,rec=iw2) w2d4
      iw2=iw2+1
      write(21,rec=iw2) w2d5
      iw2=iw2+1
      write(21,rec=iw2) w2d6
      iw2=iw2+1
      write(21,rec=iw2) w2d7
      iw2=iw2+1
      write(21,rec=iw2) w2d8

      enddo ! m loop
      endif
C 
c have tpz 'fcst' for itgt year

      do m=1,nmod
        cic(m)=cic(m)/sdc1(m) ! normalize cic
      enddo

      call setzero(w2d,imx,jmx)
      do i=1,imx
      do j=1,jmx

      if(fld2(i,j).gt.undef) then
        do m=1,nmod
          w2d(i,j)=w2d(i,j)+cic(m)*regr12(i,j,m)
        enddo
          w2d2(i,j)=tpz(i,j,iyr)-tpzc(i,j)
      else
          w2d(i,j)=undef
          w2d2(i,j)=undef
      endif

      fcst(i,j,iyr-nfys+1)=w2d(i,j)
      vfld(i,j,iyr-nfys+1)=w2d2(i,j)

      enddo
      enddo

c write out obs & 'forecasted' tpz
      iw3=iw3+1
      write(31,rec=iw3) w2d2
      iw3=iw3+1
      write(31,rec=iw3) w2d

      enddo ! iyr loop
c
c==cor and rms of reconstructed field
c
      DO i=1,imx
      DO j=1,jmx
c
      ltime=nyr-nfys+1
      if(fld2(i,j).gt.undef) then
        do it=1,ltime
          ts1(it)=vfld(i,j,it)
          ts2(it)=fcst(i,j,it)
        enddo
        call cor_rms(ts1,ts2,nyr,ltime,cor2d(i,j),rms2d(i,j))
      else
        cor2d(i,j)=undef
        rms2d(i,j)=undef
      endif
      enddo
      enddo

      iw4=1
      write(32,rec=iw4) cor2d
      iw4=iw4+1
      write(32,rec=iw4) rms2d
c
      stop
      end

      SUBROUTINE cor_rms(f1,f2,nt,ltime,cor,rms)

      real f1(nt),f2(nt)

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

      SUBROUTINE have_svd(w3dv1,w3dv2,nt,mt,imx,jmx,isv1,iev1,
     &jsv1,jev1,isv2,iev2,jsv2,jev2,ng1,ng2,cosr,nmod,cof1,cof2,
     &cic,undef,id,idel)

      real w3dv1(imx,jmx,nyr),w3dv2(imx,jmx,nyr)
      real aleft(ng1,nt),aright(ng2,nt)
      real a(ng1,ng2),w(ng2),u(ng1,ng2),v(ng2,ng2),rv1(ng2)
      real wic(imx,jmx),aic(ng1),cic(nmod),cosr(jmx)
c
      real cof1(nmod,nt),cof2(nmod,nt)
      real ts1(nt),ts2(nt),ts3(nt)

      real std1(imx,jmx),std2(imx,jmx)

c stdv of the data 
      do i=1,imx
      do j=1,jmx
      if(w3dv1(i,j,1).gt.undef) then
        std1(i,j)=0.
        do it=1,mt
        std1(i,j)=std1(i,j)+w3dv1(i,j,it)*w3dv1(i,j,it)
        enddo
        std1(i,j)=sqrt(std1(i,j)/float(mt))
      endif
      enddo
      enddo

      do i=1,imx
      do j=1,jmx
      if(w3dv2(i,j,1).gt.undef) then
        std2(i,j)=0.
        do it=1,mt
        std2(i,j)=std2(i,j)+w3dv2(i,j,it)*w3dv2(i,j,it)
        enddo
        std2(i,j)=sqrt(std2(i,j)/float(mt))
      endif
      enddo
      enddo

c feed matrix a
      do it=1,mt
      ngd1=0
        do i=isv1,iev1,idel
        do j=jsv1,jev1,idel
          if(w3dv1(i,j,1).gt.undef) then
          ngd1=ngd1+1
          if(id.eq.1) then
          aleft(ngd1,it)=w3dv1(i,j,it)*cosr(j)/std1(i,j)
          else
          aleft(ngd1,it)=w3dv1(i,j,it)*cosr(j)
          endif
          endif
       enddo
       enddo

      ngd2=0
        do i=isv2,iev2
        do j=jsv2,jev2
          if(w3dv2(i,j,1).gt.undef) then
          ngd2=ngd2+1
          if(id.eq.1) then
          aright(ngd2,it)=w3dv2(i,j,it)*cosr(j)/std2(i,j)
          else
          aright(ngd2,it)=w3dv2(i,j,it)*cosr(j)
          endif
          endif
        enddo
        enddo
      enddo  ! it loop

      write(6,*) 'ng1= ',ngd1
      write(6,*) 'ng2= ',ngd2
c
      do i=1,ng1
      do j=1,ng2

        a(i,j)=0.
        do k=1,mt
        a(i,j)=a(i,j)+aleft(i,k)*aright(j,k)/float(mt)
        enddo
         
      enddo
      enddo
c
c SVD analysis
      print *, 'before svdcmp'
      call svdcmp(a,ng1,ng2,ng1,ng2,w,v)

c write out singular value in w
      do i=1,ng1
      do j=1,ng2
        u(i,j)=a(i,j)
      enddo
      enddo
c 
      do i=1,10
c     write(6,*)'singular value= ',i,w(i)
      end do

c== have coef
      do m=1,nmod
      do it=1,mt
        cof1(m,it)=0.
        cof2(m,it)=0.
      do n=1,ng1
        cof1(m,it)=cof1(m,it)+aleft(n,it)*u(n,m)
      enddo
      do n=1,ng2
        cof2(m,it)=cof2(m,it)+aright(n,it)*v(m,n)
      enddo
      enddo
      enddo ! loop m
c
c have cic, the projection of var1_ic to u
      do i=1,imx
      do j=1,jmx
        wic(i,j)=w3dv1(i,j,mt+1)
      enddo
      enddo

      ngd3=0
      do i=isv1,iev1,idel
      do j=jsv1,jev1,idel
        if(w3dv1(i,j,1).gt.undef) then
        ngd3=ngd3+1
        if(id.eq.1) then
        aic(ngd3)=wic(i,j)*cosr(j)/std1(i,j)
        else
        aic(ngd3)=wic(i,j)*cosr(j)
        endif
        endif
      enddo
      enddo

      do m=1,nmod
        cic(m)=0.
        do n=1,ng1
        cic(m)=cic(m)+aic(n)*u(n,m)
        enddo
      enddo
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

