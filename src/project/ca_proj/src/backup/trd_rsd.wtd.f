      program eof
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C eof is applied to detrended data
C===========================================================
      real fld(imx,jmx),fld1(imx,jmx),fld2(imx,jmx)
      real afld(imx,jmx,ltime)
      real w3d(imx,jmx,ltime),w3d2(imx,jmx,ltime)
      real pat(imx,jmx,nmod)
      real w2d(imx,jmx),w2d2(imx,jmx)
      real cof(nmod,ltime)
      real rregr(imx,jmx),rcorr(imx,jmx)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !3_d data
      open(11,form='unformatted',access='direct',recl=4) 
      open(12,form='unformatted',access='direct',recl=4*imx*jmx) 
C
      open(20,form='unformatted',access='direct',recl=4*imx*jmx) !rsd_trd
C
C==read in obs
      do it=1,ltime
        read(10,rec=it) fld
        do i=1,imx
        do j=1,jmx
          w3d(i,j,it)=fld(i,j)
        enddo
        enddo
      enddo
c
c== read in coef
c
      ir=0
      do it=1,ltime
      do m=1,nmod
      ir=ir+1
      read(11,rec=ir) cof(m,it)
      enddo
      enddo
c
c== read in pattern
c
      ir=0
      do m=1,nmod
      ir=ir+2  !read regr, not cor
      read(12,rec=ir) w2d
        do i=1,imx
        do j=1,jmx
          pat(i,j,m)=w2d(i,j)
        enddo
        enddo
      enddo
c
c have residual
c
c     do m=1,nmod
      do m=1,ncut !focus on mode 1-5
      do it=1,ltime

        do i=1,imx
        do j=1,jmx
        if(pat(i,j,m).gt.-100) then
          w3d(i,j,it)=w3d(i,j,it)-cof(m,it)*pat(i,j,m)
        else
          w3d(i,j,it)=w3d(i,j,it)
        endif
        enddo
        enddo
      enddo
      enddo
c
c== detrend data
c
      call ltrend(w3d,afld,w3d2,imx,jmx,ltime,1,ltime,w2d,w2d2)
c write out of trend data of all years
      do it =1,ltime
        do i=1,imx
        do j=1,jmx
          w2d(i,j)=w3d2(i,j,it)
        enddo
        enddo
      write(20,rec=it) w2d
      enddo
c
      stop
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
      if(grid(i,j,1).gt.-1000) then
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
      a(i,j)=-9.99E+8
      b(i,j)=-9.99E+8
      endif

      enddo !over j
      enddo !over i
c
      do i=1,imx
      do j=1,jmx
      do it=1,nt

      if(grid(i,j,1).gt.-1000) then
        out(i,j,it)=grid(i,j,it)-b(i,j)*float(it)-a(i,j) !detrended
        out2(i,j,it)=b(i,j)*float(it)+a(i,j) !trend
      else
        out(i,j,it)=-9.99E+8
        out2(i,j,it)=-9.99E+8
      endif

      enddo
      enddo
      enddo
c
      return
      end
