      program correlation
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. correlation between tropical area averaged sst and global field
C===========================================================
      real fld1(imx,jmx),fld2(imx,jmx),regr(imx,jmx)
      real fld3d(imx,jmx,ltime)
      real fld3d2(imx,jmx,ltime)
      real corr(imx,jmx),xidx(ltime)
      real rpc(ltime,nmod)
      real wk1(ltime),wk2(ltime)
      real wk3(ltime),wk4(ltime)
      real wk5(ltime),wk6(ltime)
      real wk7(ltime),wk8(ltime)
      real mask(imx,jmx)
c
      open(unit=10,form='unformatted',access='direct',recl=4)
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=50,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=51,form='unformatted',access='direct',recl=4)
c
c read in index data
c== read in PCs
c
      ir=0
      do it=1,ltime
      do  m=1,nmod
      ir=ir+1
      read(10,rec=ir) rpc(it,m)
      enddo
      enddo
c
c read in fld data
      do it=1,ltime
        itr=iskip_fld+it
        read(11,rec=itr) fld1
        do i=1,imx
        do j=1,jmx
         fld3d(i,j,it)=fld1(i,j)
        enddo
        enddo
      end do
c
      iwrite=0
c
      do im=1,nmod
c
      do it=1,ltime
        xidx(it)=rpc(it,im)
      enddo
c
      do i=1,imx
      do j=1,jmx
 
      if(fld1(i,j).lt.-1000) then

        corr(i,j)=-999.0
        regr(i,j)=-999.0

      else

        do it=1,ltime
        wk1(it)=fld3d(i,j,it)
        enddo

        call anom(wk1,ltime)
        call regr_t(xidx,wk1,ltime,corr(i,j),regr(i,j))
        
      endif

      enddo
      enddo

      iwrite=iwrite+1
      write(50,rec=iwrite) corr
      iwrite=iwrite+1
      write(50,rec=iwrite) regr

      enddo  !im loop
c
c have residual by taking off ENSO related pattern
       read(50,rec=2) regr
      do it=1,ltime
        do i=1,imx
        do j=1,jmx
          fld3d2(i,j,it)=fld3d(i,j,it)-rpc(it,1)*regr(i,j)
        enddo
        enddo
      enddo
c
c have projection of trend pattern to SSTs
c
      read(50,rec=4) regr
c
      do it=1,ltime
        do i=1,imx
        do j=1,jmx
          fld1(i,j)=fld3d(i,j,it)
          fld2(i,j)=fld3d2(i,j,it)
        enddo
        enddo
c to raw sst
        call spcor(regr,fld1,imx,jmx,is,ie,js,je,proj1)
c to rsd sst
        call spcor(regr,fld2,imx,jmx,is,ie,js,je,proj2)
        wk1(it)=proj1
        wk2(it)=proj2
      enddo
      call normal(wk1,wk3,sd,ltime)
      call normal(wk2,wk4,sd,ltime)
c
      call ltrend(wk3,wk5,wk1,ltime,1,ltime,a,b)
      call ltrend(wk4,wk6,wk1,ltime,1,ltime,a,b)
      do it=1,ltime
        xidx(it)=rpc(it,2)
      enddo
      call ltrend(xidx,wk7,wk2,ltime,1,ltime,a,b)
      call normal(wk5,wk1,sd,ltime)
      call normal(wk6,wk2,sd,ltime)
      call normal(wk7,wk8,sd,ltime)

      iw=0
      do it=1,ltime
        iw=iw+1
        write(51,rec=iw) rpc(it,2)
        iw=iw+1
        write(51,rec=iw) wk3(it)
        iw=iw+1
        write(51,rec=iw) wk4(it)
        iw=iw+1
        write(51,rec=iw) wk8(it)
        iw=iw+1
        write(51,rec=iw) wk1(it)
        iw=iw+1
        write(51,rec=iw) wk2(it)
      enddo

c last undef
        undef=-9999.0
        iw=iw+1
        write(51,rec=iw) undef
        iw=iw+1
        write(51,rec=iw) undef
        iw=iw+1
        write(51,rec=iw) undef
        iw=iw+1
        write(51,rec=iw) undef
        iw=iw+1
        write(51,rec=iw) undef
        iw=iw+1
        write(51,rec=iw) undef
      
      stop
      END

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  using least square to have y=a+bx
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine ltrend(grid,out,out2,nt,its,ite,a,b)
      dimension grid(nt),out(nt)
      dimension out2(nt)
      real lxx, lxy
c
      xb=0
      yb=0
      do it=its,ite
        xb=xb+float(it)/float(ite-its+1)
        yb=yb+grid(it)/float(ite-its+1)
      enddo
c
      lxx=0.
      lxy=0.
      do it=its,ite
      lxx=lxx+(it-xb)*(it-xb)
      lxy=lxy+(it-xb)*(grid(it)-yb)
      enddo
      b=lxy/lxx
      a=yb-b*xb
c
      do it=1,nt
        out(it)=grid(it)-b*float(it)-a !detrended
        out2(it)=b*float(it)+a !trend
      enddo
c
      return
      end

      SUBROUTINE normal(rot,rot2,sd,ltime)
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
c
      SUBROUTINE spcor(f1,f2,imx,jmx,is,ie,js,je,proj)

      real f1(imx,jmx),f2(imx,jmx)

      cor=0.
      sd1=0.
      sd2=0.
      ng=0
      do i=is,ie
      do j=js,je
        if(abs(f1(i,j)).lt.100) then
         cor=cor+f1(i,j)*f2(i,j)
         sd1=sd1+f1(i,j)*f1(i,j)
         sd2=sd2+f2(i,j)*f2(i,j)
         ng=ng+1
        endif
      enddo
      enddo

      sd1=(sd1/float(ng))**0.5
      sd2=(sd2/float(ng))**0.5
      cor=cor/(sd1*sd2*float(ng))
      proj=cor*sd2
      write(6,*) 'ng=',ng

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


      SUBROUTINE setzero(fld,n,m)
      DIMENSION fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end
