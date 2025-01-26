      program eof
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C===========================================================
      PARAMETER (ng1=2520)
      PARAMETER (ng2=2034)
c
      integer i,j,k,l,m,n,ii,i1,kk,k1,ll,l1,mn,nm,its,ierr
      real a(ng1,ng2),w(ng2),u(ng1,ng2),v(ng1,ng2),rv1(ng2)
      real c,f,g,h,s,x,y,z,tst1,tst2,scale,pythag
      logical matu,matv
c
      real ff1(imx1,jmx1)
      real corr1(imx1,jmx1),regr1(imx1,jmx1)
      real corr12(imx1,jmx1),regr12(imx1,jmx1)
      real w3d1(imx1,jmx1,ltime)
      real std1(imx1,jmx1)
c
      real fs1(imx2,jmx2)
      real corr2(imx2,jmx2),regr2(imx2,jmx2)
      real corr22(imx2,jmx2),regr22(imx2,jmx2)
      real w3d2(imx2,jmx2,ltime)
      real std2(imx2,jmx2)
c
      real aleft(ng1,ltime),aright(ng2,ltime)
c
      real xn34(ltime)
      real ts1(ltime),ts2(ltime)
      real ts3(ltime),ts4(ltime)
c
      real xlat1(jmx1),coslat1(jmx1),cosr1(jmx1)
      real xlat2(jmx2),coslat2(jmx2),cosr2(jmx2)
c

      real cof1(nmod,ltime)
      real cof2(nmod,ltime)
C
      open(11,form='unformatted',access='direct',recl=4*imx1*jmx1) !3_d z200
      open(12,form='unformatted',access='direct',recl=4*imx2*jmx2) !3_d sst
C
      open(21,form='unformatted',access='direct',recl=4) ! nino34
c
      open(31,form='unformatted',access='direct',recl=4*imx2*jmx2)
      open(32,form='unformatted',access='direct',recl=4*imx2*jmx2)
c
      open(41,form='unformatted',access='direct',recl=4*imx1*jmx1)
      open(42,form='unformatted',access='direct',recl=4*imx1*jmx1)
c
      open(51,form='unformatted',access='direct',recl=4)
      open(52,form='unformatted',access='direct',recl=4)
C
C== have coslat
C
      undef=-9999.0
c
      do j=1,jmx1
        xlat1(j)=-90+(j-1)*2.5
        coslat1(j)=cos(xlat1(j)*3.14159/180)  !for EOF use 
        cosr1(j)=sqrt(coslat1(j))  !for EOF use 
      enddo
c
      do j=1,jmx2
        xlat2(j)=-89.5+(j-1)*2.
        coslat2(j)=cos(xlat2(j)*3.14159/180)  !for EOF use 
        cosr2(j)=sqrt(coslat2(j))  !for EOF use 
      enddo
c
c     write(6,*) 'coslat=',coslat
C==read in obs
      do it=1,ltime
        read(11,rec=it) ff1
        do i=1,imx1
        do j=1,jmx1
          w3d1(i,j,it)=ff1(i,j) !for z200
        enddo
        enddo
c
        read(12,rec=it) fs1
        do i=1,imx2
        do j=1,jmx2
          w3d2(i,j,it)=fs1(i,j) !for sst
        enddo
        enddo
      enddo
c
c== read in nino34 index
c
      do it=1,ltime
      read(21,rec=it) ts1(it)
      enddo
      call normal(ts1,xn34,ltime)  !for residual use
      write(6,*) 'nino34=', xn34
c
c== regr to nino34
c
      do i=1,imx1
      do j=1,jmx1
      if(ff1(i,j).gt.-1000) then
        do it=1,ltime
        ts1(it)=w3d1(i,j,it)
        enddo
        call regr_t(xn34,ts1,ltime,corr1(i,j),regr1(i,j))
      else
        corr1(i,j)=undef
        regr1(i,j)=undef
      endif
      enddo
      enddo
c     write(6,*) regr1
c
      do i=1,imx2
      do j=1,jmx2
      if(fs1(i,j).gt.-1000) then
        do it=1,ltime
        ts1(it)=w3d2(i,j,it)
        enddo
        call regr_t(xn34,ts1,ltime,corr2(i,j),regr2(i,j))
      else
        corr2(i,j)=undef
        regr2(i,j)=undef
      endif
      enddo
      enddo
c     write(6,*) regr2
c
c
c== have residual
c
      do i=1,imx1
      do j=1,jmx1
        if(regr1(i,j).gt.-1000) then
        do it=1,ltime
          w3d1(i,j,it)=w3d1(i,j,it)-rsd*xn34(it)*regr1(i,j)
        enddo
        endif
      enddo
      enddo
c
      do i=1,imx2
      do j=1,jmx2
        if(regr2(i,j).gt.-1000) then
        do it=1,ltime
          w3d2(i,j,it)=w3d2(i,j,it)-rsd*xn34(it)*regr2(i,j)
        enddo
        endif
      enddo
      enddo
c
c cor matrix or var matrix
c
      if(id.eq.1) then
c
      do i=1,imx1
      do j=1,jmx1
        if(regr1(i,j).gt.-1000) then
        std1(i,j)=0.
        do it=1,ltime
        std1(i,j)=std1(i,j)+w3d1(i,j,it)*w3d1(i,j,it)/float(ltime)
        enddo
        std1(i,j)=sqrt(std1(i,j))
        endif
      enddo
      enddo
c
      do i=1,imx2
      do j=1,jmx2
        if(regr2(i,j).gt.-1000) then
        std2(i,j)=0.
        do it=1,ltime
        std2(i,j)=std2(i,j)+w3d2(i,j,it)*w3d2(i,j,it)/float(ltime)
        enddo
        std2(i,j)=sqrt(std2(i,j))
        endif
      enddo
      enddo
      endif
c
ccc feed matrix a
c
      do it=1,ltime
      ngd1=0
        do i=lons1,lone1,2
        do j=lats1,late1,1
          if(ff1(i,j).gt.-1000) then
          ngd1=ngd1+1
          if(id.eq.1) then
          aleft(ngd1,it)=w3d1(i,j,it)*cosr1(j)/std1(i,j)
          else
          aleft(ngd1,it)=w3d1(i,j,it)*cosr1(j)
          endif
          endif
        enddo
        enddo
      ngd2=0
        do i=lons2,lone2,2
        do j=lats2,late2
          if(fs1(i,j).gt.-1000) then
          ngd2=ngd2+1
          if(id.eq.1) then
          aright(ngd2,it)=w3d2(i,j,it)*cosr2(j)/std2(i,j)
          else
          aright(ngd2,it)=w3d2(i,j,it)*cosr2(j)
          endif
          endif
        enddo
        enddo
      enddo
      write(6,*) 'ng1= ',ngd1
      write(6,*) 'ng2= ',ngd2
c
      do i=1,ng1
      do j=1,ng2

      a(i,j)=0.
      do k=1,ltime
      a(i,j)=a(i,j)+aleft(i,k)*aright(j,k)/float(ltime)
      enddo

      enddo
      enddo
c
cc... SVD analysis
c
      call svdcmp(a,ng1,ng2,ng1,ng2,w,v)
cc... write out singular value in w
      do i=1,ng1
      do j=1,ng2
        u(i,j)=a(i,j)
      enddo
      enddo
c
      do i=1,20
      write(6,*)'singular value= ',i,w(i)
      end do
c
c== have coef
c
      do m=1,nmod
c
      do it=1,ltime
        cof1(m,it)=0.
        cof2(m,it)=0.
      do n=1,ng1
        cof1(m,it)=cof1(m,it)+aleft(n,it)*u(n,m)
      enddo
      do n=1,ng2
        cof2(m,it)=cof2(m,it)+aright(n,it)*v(m,n)
      enddo
      enddo
c
      enddo
c
c==CORR between coef and data
c
      iw=0
      iw2=0
      DO m=1,nmod !loop over mode
c
      do it=1,ltime
      ts1(it)=cof1(m,it)
      ts3(it)=cof2(m,it)
      enddo
      call normal(ts1,ts2,ltime)
      call normal(ts3,ts4,ltime)
      do jt=1,ltime
        ts1(jt)=ts2(jt)
        ts3(jt)=ts4(jt)
      enddo
      do jt=1,ltime
        cof1(m,jt)=ts2(jt)
        cof2(m,jt)=ts4(jt)
      enddo
c
c for var1
      do j=1,jmx1
      do i=1,imx1

      if(ff1(i,j).gt.-1000) then

      do it=1,ltime
        ts2(it)=w3d1(i,j,it)
      enddo

      call regr_t(ts1,ts2,ltime,corr1(i,j),regr1(i,j))
      call regr_t(ts3,ts2,ltime,corr12(i,j),regr12(i,j))

      else
      corr1(i,j)=undef
      regr1(i,j)=undef
      corr12(i,j)=undef
      regr12(i,j)=undef
      endif

      enddo
      enddo

      iw=iw+1
      write(41,rec=iw) corr1
      write(42,rec=iw) corr12
      iw=iw+1
      write(41,rec=iw) regr1
      write(42,rec=iw) regr12
c
c for var2
      do j=1,jmx2
      do i=1,imx2

      if(fs1(i,j).gt.-1000) then

      do it=1,ltime
        ts2(it)=w3d2(i,j,it)
      enddo

      call regr_t(ts3,ts2,ltime,corr2(i,j),regr2(i,j))
      call regr_t(ts1,ts2,ltime,corr22(i,j),regr22(i,j))

      else
      corr2(i,j)=undef
      regr2(i,j)=undef
      corr22(i,j)=undef
      regr22(i,j)=undef
      endif

      enddo
      enddo

      iw2=iw2+1
      write(31,rec=iw2) corr2
      write(32,rec=iw2) corr22
      iw2=iw2+1
      write(31,rec=iw2) regr2
      write(32,rec=iw2) regr22

      enddo !m loop

c== write out coef
      iw=0
      do it=1,ltime
      xx=cof1(1,it)
      iw=iw+1
      write(51,rec=iw) xx
      xx=cof1(2,it)
      iw=iw+1
      write(51,rec=iw) xx
      xx=cof1(3,it)
      iw=iw+1
      write(51,rec=iw) xx
      xx=cof1(4,it)
      iw=iw+1
      write(51,rec=iw) xx
      xx=cof1(5,it)
      iw=iw+1
      write(51,rec=iw) xx
      enddo
      do m=1,nmod
      iw=iw+1
      write(51,rec=iw) undef
      enddo
c
      iw=0
      do it=1,ltime
      xx=cof2(1,it)
      iw=iw+1
      write(52,rec=iw) xx
      xx=cof2(2,it)
      iw=iw+1
      write(52,rec=iw) xx
      xx=cof2(3,it)
      iw=iw+1
      write(52,rec=iw) xx
      xx=cof2(4,it)
      iw=iw+1
      write(52,rec=iw) xx
      xx=cof2(5,it)
      iw=iw+1
      write(52,rec=iw) xx
      enddo
      do m=1,nmod
      iw=iw+1
      write(52,rec=iw) undef
      enddo

      stop
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
      enddo !over j
      enddo !over i
c
      do i=1,imx
      do j=1,jmx
      do it=1,nt
        out(i,j,it)=grid(i,j,it)-b(i,j)*float(it)-a(i,j) !detrended
        out2(i,j,it)=b(i,j)*float(it)+a(i,j) !trend
      enddo
      enddo
      enddo
c
      return
      end
