      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C PCR for forecst TPZ
C===========================================================
c     PARAMETER (ngrd=(late-lats+1)*(lone-lons+1))
      real fld(imx,jmx),fld2(imx,jmx)
      real fld3(imx,jmx),fld4(imx,jmx),fld5(imx,jmx)
      real corr(imx,jmx,nmod),regr(imx,jmx,nmod)
      real corr2(imx,jmx,nmod),regr2(imx,jmx,nmod)
      real cor2d(imx,jmx),rms2d(imx,jmx)
      real ts1(nyr),ts2(nyr)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real w2d(imx,jmx),w2d2(imx,jmx)
      real tcof(nmod,nyr)
      real pj(nmod),proj(nmod,nyr)
      real tpz(imx,jmx,nyr),wtpz(imx,jmx,nyr)
      real sst(imx,jmx,nyr),wsst(imx,jmx,nyr)
      real sstc(imx,jmx),tpzc(imx,jmx)
      real fcst(imx,jmx,nyr-nfys+1)
      real vfld(imx,jmx,nyr-nfys+1)
      real xn34(nyr)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !sst
      open(11,form='unformatted',access='direct',recl=4*imx*jmx) !tpz

      open(20,form='unformatted',access='direct',recl=4)
      open(21,form='unformatted',access='direct',recl=4*imx*jmx)

      open(30,form='unformatted',access='direct',recl=4*imx*jmx) !tp reg
      open(31,form='unformatted',access='direct',recl=4*imx*jmx) !fcst
      open(32,form='unformatted',access='direct',recl=4*imx*jmx) !skill
      open(33,form='unformatted',access='direct',recl=4) !sptial skill
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
      if(iic.lt.1) iic=36+itgt-ilead-del
      if(iic.lt.1) iic=48+itgt-ilead-del
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
        if(fld(i,j).gt.-900.) then
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
      call havenino34(wsst,xn34,imx,jmx,nyr)
c
C have tpz anomalies over time 1 to iym
      iym=iyr-1
      do i=1,imx
      do j=1,jmx
        if(fld2(i,j).gt.-900.) then
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

c SST EOF analysis for nclm years
c
      do m=1,nmod
      do it=1,nyr
        tcof(m,it)=undef
      enddo
      enddo
C
      call pc_eof(wsst,imx,jmx,lons,lone,lats,late,nyr,nclm,cosr,
     &ngrd,nmod,tcof,corr,regr,undef,id)
c
C write out PC and EOF for last forecast
      if(iyr.eq.nyr) then
      iw=0
      iw2=0
      do m=1,nmod

c write out PC
      do it=1,nyr
      iw=iw+1
      write(20,rec=iw) tcof(m,it)
      enddo

c write out sst corr&regr patterns
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
      endif
C 
C regression of tpz to sst PC

      ics=itgt-ilead-del
      icsp=12+itgt-ilead-del
      icsp2=24+itgt-ilead-del
      icsp3=36+itgt-ilead-del
      iym2=iyr-2
      iym3=iyr-3
      iym4=iyr-4
      iym5=iyr-5
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
      else if(icsp2.gt.0) then
        its_tpz=3
        ite_tpz=iym
        its_sst=1
        ite_sst=iym3
      else if(icsp3.gt.0) then
        its_tpz=4
        ite_tpz=iym
        its_sst=1
        ite_sst=iym4
      else
        its_tpz=5
        ite_tpz=iym
        its_sst=1
        ite_sst=iym5
      endif
      write(6,*) 'its_sst=',its_sst,'ite_sst=',ite_sst
      write(6,*) 'its_tpz=',its_tpz,'ite_tpz=',ite_tpz

      nfld=ite_sst - its_sst + 1
      do m=1,nmod
            ir=0
            do it=its_sst,ite_sst
            ir=ir+1
            ts1(ir)=tcof(m,it)
            enddo
        do i=1,imx
        do j=1,jmx
          if(fld2(i,j).gt.-900.) then
            ir=0
            do it=its_tpz,ite_tpz
            ir=ir+1
            ts2(ir)=wtpz(i,j,it)
            enddo

            call regr_t(ts1,ts2,nyr,nfld,corr2(i,j,m),regr2(i,j,m))

          else
            corr2(i,j,m)=undef
            regr2(i,j,m)=undef
          endif
        enddo
        enddo
      enddo ! m loop
  777 format(10f7.2)
c
c write out tpz regr & corr
        if(iyr.eq.nyr) then

        iw5=0
        do m=1,nmod

        do i=1,imx
        do j=1,jmx
          w2d(i,j)=corr2(i,j,m)
          w2d2(i,j)=regr2(i,j,m)
        enddo
        enddo
        iw5=iw5+1
        write(30,rec=iw5) w2d
        iw5=iw5+1
        write(30,rec=iw5) w2d2

        enddo ! m loop

        endif
c
c have tpz 'fcst' for itgt year with sst tcof and tpz regr
      call setzero(w2d,imx,jmx)
      do i=1,imx
      do j=1,jmx
        if(fld2(i,j).gt.-900.) then
          do m=1,nmod
            w2d(i,j)=w2d(i,j)+tcof(m,ite_sst+1)*regr2(i,j,m)
          enddo
            w2d2(i,j)=tpz(i,j,iyr)-tpzc(i,j)
        else
            w2d(i,j)=undef
            w2d2(i,j)=undef
        endif

      enddo
      enddo
      write(6,*) 'ite_sst=',ite_sst,'tcof=',tcof(1,ite_sst+1)

c write out obs & 'forecasted' tpz
      iw3=iw3+1
      write(31,rec=iw3) w2d2
      iw3=iw3+1
      write(31,rec=iw3) w2d

      do i=1,imx
      do j=1,jmx
        fcst(i,j,iyr-nfys+1)=w2d(i,j)
        vfld(i,j,iyr-nfys+1)=w2d2(i,j)
      enddo
      enddo

      enddo ! iyr loop
c
c==temporal cor and rms of forecasted field
c
      DO i=1,imx
      DO j=1,jmx
c
      ltime=nyr-nfys+1
      if(fld2(i,j).gt.-900.) then
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
c== spatial skill
      iw=0
      do iy=1,ltime

        do i=1,imx
        do j=1,jmx
        w2d(i,j)=vfld(i,j,iy)
        w2d2(i,j)=fcst(i,j,iy)
        enddo
        enddo

      call sp_cor_rms(w2d,w2d2,coslat,imx,jmx,
     &1,360,115,160,xcor,xrms)

      iw=iw+1
      write(33,rec=iw) xcor
      iw=iw+1
      write(33,rec=iw) xrms
      call sp_cor_rms(w2d,w2d2,coslat,imx,jmx,
     &230,300,115,140,xcor,xrms)
      iw=iw+1
      write(33,rec=iw) xcor
      iw=iw+1
      write(33,rec=iw) xrms

      enddo

      stop
      end

      SUBROUTINE cor_rms(f1,f2,nt,ltime,cor,rms)

      real f1(nt),f2(nt)

      av1=0
      av2=0
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
         sd1=sd1+(f1(it)-av1)*(f1(it)-av1)/float(ltime)
         sd2=sd2+(f2(it)-av2)*(f2(it)-av2)/float(ltime)
         rms=rms+(f1(it)-av1-f2(it)+av2)**2/float(ltime)
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

      SUBROUTINE pc_eof(wf3d,imx,jmx,is,ie,ls,le,ltime,nfld,cosr,
     &ngrd,nmod,tcof,corr,regr,undef,id)

      real wf3d(imx,jmx,ltime),tcof(nmod,ltime)
      real f3d(imx,jmx,nfld),cosr(jmx)
      real regr(imx,jmx,nmod),corr(imx,jmx,nmod),pc(nmod,nfld)
      real aaa(ngrd,nfld),wk(nfld,ngrd)
      real eval(nfld),evec(ngrd,nfld),coef(nfld,nfld)
      real ts1(nfld),ts2(nfld)

      do i=1,imx
      do j=1,jmx
      do it=1,nfld
        f3d(i,j,it)=wf3d(i,j,it)
      enddo
      enddo
      enddo
c
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
        tcof(m,it)=ts2(it)
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

      call regr_t(ts1,ts2,nfld,nfld,corr(i,j,m),regr(i,j,m))
      else
      corr(i,j,m)=undef
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

