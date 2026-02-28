      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C PCR for forecst TPZ
C===========================================================
      real fld0(imx,jmx),fld(imx,jmx),fld1(imx,jmx),fldv1(imx,jmx)
      real sst(imx,jmx,nyr),w3dv1(imx,jmx,nyr)
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

      real cof1(msvd,nyr),cof2(msvd,nyr)
      real cic(msvd),sdc1(msvd),sdc2(msvd)

      real corr11(imx,jmx,msvd),regr11(imx,jmx,msvd)
      real corr21(imx,jmx,msvd),regr21(imx,jmx,msvd)

      real corr12(imx2,jmx2,msvd),regr12(imx2,jmx2,msvd)
      real corr22(imx2,jmx2,msvd),regr22(imx2,jmx2,msvd)

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

      real cor1d1(msvd),cor1d2(msvd)
      real cor1d3(msvd),cor1d4(msvd)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !sst
      open(11,form='unformatted',access='direct',recl=4*imx2*jmx2) !tpz

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
      its_sst=icmon+2 ! for 3-mon sst 11-2+12-1+1=21(son)

      ir=0
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
c tpz hindcast for ld=1->nlead
      its_tpz=icmon+2 !test same as sst
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
      do i=1,imx
      do j=1,jmx
        do it=1,ny_tpz ! +1 to include ic_sst
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
C
      call grd_svd(w3dv1,w3dv2,nyr,ny_tpz,imx,jmx,imx2,jmx2,isv1,
     &iev1,jsv1,jev1,isv2,iev2,jsv2,jev2,id1,jd1,id2,jd2,ng1,ng2,
     &cosr,cosr2,msvd,cof1,cof2,undef,id)
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

      enddo ! loop m

c regression of cof1 to tpz
      do m=1,msvd

      do it=1,ny_tpz
        ts1(it)=cof1(m,it)
      enddo

      do i=1,imx2
      do j=1,jmx2

      if(fld2(i,j).gt.undef) then

      do it=1,ny_tpz
        ts2(it)=w3dv2(i,j,it)
      enddo

      call regr_t(ts1,ts2,nyr,ny_tpz,corr12(i,j,m),regr12(i,j,m))

      else
          corr12(i,j,m)=undef
          regr12(i,j,m)=undef
      endif

      enddo ! loop i
      enddo ! loop j

      enddo ! loop m
c
c have var1 & var2 on grid for each svd mode

      iw1=0
      iw2=0
      do m=1,msvd

c var2
      do it=1,ny_tpz
        ts1(it)=cof2(m,it)
      enddo

      do i=1,imx2
      do j=1,jmx2

      if(fld2(i,j).gt.undef) then

      do it=1,ny_tpz
        ts2(it)=w3dv2(i,j,it)
      enddo

      call regr_t(ts1,ts2,nyr,ny_tpz,corr22(i,j,m),regr22(i,j,m))

      else
          corr22(i,j,m)=undef
          regr22(i,j,m)=undef
      endif

      enddo ! loop i
      enddo ! loop j

c var1
      do it=1,ny_tpz
        ts1(it)=cof1(m,it)
        ts2(it)=cof2(m,it)
      enddo

      do i=1,imx
      do j=1,jmx

      if(fld(i,j).gt.undef) then

      do it=1,ny_tpz
        ts3(it)=w3dv1(i,j,it)
      enddo

      call regr_t(ts1,ts3,nyr,ny_tpz,corr11(i,j,m),regr11(i,j,m))
      call regr_t(ts2,ts3,nyr,ny_tpz,corr21(i,j,m),regr21(i,j,m))

      else
          corr11(i,j,m)=undef
          regr11(i,j,m)=undef
          corr21(i,j,m)=undef
          regr21(i,j,m)=undef
      endif

      enddo ! loop i
      enddo ! loop j

      do i=1,imx
      do j=1,jmx
          fld0(i,j)=regr11(i,j,m)
          fld1(i,j)=regr21(i,j,m)
      enddo
      enddo

      iw1=iw1+1
      write(41,rec=iw1) fld0
      iw1=iw1+1
      write(41,rec=iw1) fld1

      do i=1,imx2
      do j=1,jmx2
          w2d(i,j)=regr22(i,j,m)
          w2d2(i,j)=regr12(i,j,m)
      enddo
      enddo

      iw2=iw2+1
      write(42,rec=iw2) w2d
      iw2=iw2+1
      write(42,rec=iw2) w2d2

      enddo ! m loop

c corr of svd cof1 vs cof2
      do m=1,msvd
        do it=1,ny_tpz
          ts1(it) = cof1(m,it)
          ts2(it) = cof2(m,it)
        enddo
          call cor_rms(ts1,ts2,nyr,ny_tpz,cor1d1(m),rms)
      enddo

      write(6,*) 'cor_svdsst_vs_svdtpz'
      write(6,101) cor1d1

 101  format(10f7.3)
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
        call normal(ts1,nt,nt)

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

      SUBROUTINE grd_svd(w3dv1,w3dv2,nt,mt,imx,jmx,imx2,jmx2,isv1,
     &iev1,jsv1,jev1,isv2,iev2,jsv2,jev2,id1,jd1,id2,jd2,ng1,ng2,
     &cosr1,cosr2,nmod,cof1,cof2,undef,id)

      real w3dv1(imx,jmx,nyr),w3dv2(imx2,jmx2,nyr)
      real aleft(ng1,nt),aright(ng2,nt)
c     real a(ng1,ng2),w(ng2),u(ng1,ng2),v(ng2,ng2),rv1(ng2)
      real a(ng2,ng2),w(ng2),u(ng2,ng2),v(ng2,ng2),rv1(ng2)
      real wic(imx,jmx),aic(ng1),cic(nmod),cosr1(jmx),cosr2(jmx2)
c
      real cof1(nmod,nt),cof2(nmod,nt)
      real ts1(nt),ts2(nt),ts3(nt)

      real std1(imx,jmx),std2(imx2,jmx2)

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

      do i=1,imx2
      do j=1,jmx2
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
        do i=isv1,iev1,id1
        do j=jsv1,jev1,jd1
          if(w3dv1(i,j,1).gt.undef) then
          ngd1=ngd1+1
          if(id.eq.1) then
          aleft(ngd1,it)=w3dv1(i,j,it)*cosr1(j)/std1(i,j)
          else
          aleft(ngd1,it)=w3dv1(i,j,it)*cosr1(j)
          endif
          endif
       enddo
       enddo

      ngd2=0
        do i=isv2,iev2,id2
        do j=jsv2,jev2,jd2
          if(w3dv2(i,j,1).gt.undef) then
          ngd2=ngd2+1
          if(id.eq.1) then
          aright(ngd2,it)=w3dv2(i,j,it)*cosr2(j)/std2(i,j)
          else
          aright(ngd2,it)=w3dv2(i,j,it)*cosr2(j)
          endif
          endif
        enddo
        enddo
      enddo  ! it loop

      write(6,*) 'ng1= ',ngd1
      write(6,*) 'ng2= ',ngd2
c
c     do i=1,ng1
      do i=1,ng2
      do j=1,ng2

        a(i,j)=0.
        do k=1,mt
c       a(i,j)=a(i,j)+aleft(i,k)*aright(j,k)/float(mt)
        a(i,j)=a(i,j)+aright(i,k)*aright(j,k)/float(mt)
        enddo

      enddo
      enddo
c
c SVD analysis
      print *, 'before svdcmp'
c     call svdcmp(a,ng1,ng2,ng1,ng2,w,v)
      call svdcmp(a,ng2,ng2,ng2,ng2,w,v)

c write out singular value in w
c     do i=1,ng1
      do i=1,ng2
      do j=1,ng2
        u(i,j)=a(i,j)
      enddo
      enddo
c
      do i=1,10
      write(6,*)'singular value= ',i,w(i)
      end do

c== have coef
      do m=1,nmod
      do it=1,mt
        cof1(m,it)=0.
        cof2(m,it)=0.
c     do n=1,ng1
      do n=1,ng2
c       cof1(m,it)=cof1(m,it)+aleft(n,it)*u(n,m)
        cof1(m,it)=cof1(m,it)+aright(n,it)*u(n,m)
      enddo
      do n=1,ng2
c       cof2(m,it)=cof2(m,it)+aright(n,it)*v(m,n)
        cof2(m,it)=cof2(m,it)+aright(n,it)*v(n,m)
      enddo

      enddo
      enddo ! loop m
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

