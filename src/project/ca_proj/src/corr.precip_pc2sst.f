      program correlation
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. correlation between tropical area averaged sst and global field
C===========================================================
      real fld1(imx,jmx),fld2(imx,jmx),regr(imx,jmx)
      real fld3d(imx,jmx,ltime)
      real w3d(imx,jmx,ltime)
      real corr(imx,jmx),xidx(ltime)
      real rpc(ltime,nmod)
      real wk1(ltime),wk2(ltime),rcf(ltime)
      dimension mask(imx,jmx)
c
      open(unit=10,form='unformatted',access='direct',recl=4)
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=50,form='unformatted',access='direct',recl=4*imx*jmx)
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
c read mask
      read(12,rec=1) mask
c
c== regr of sst to nino34
c
      do it=1,ltime ! read normalized nino34
        wk1(it)=rpc(it,1)
      enddo

      do i=1,imx
      do j=1,jmx
      if(mask(i,j).lt.-90) then
        corr(i,j)=-999.0
        regr(i,j)=-999.0
      else
        do it=1,ltime
        wk2(it)=fld3d(i,j,it)
        enddo
        call regr_t(wk1,wk2,ltime,corr(i,j),regr(i,j))
      endif
      enddo
      enddo
c write out enso patterns
      iwrite=1
      write(50,rec=iwrite) corr
      iwrite=iwrite+1
      write(50,rec=iwrite) regr
c
c== have residual
c
      do it=1,ltime
        do i=1,imx
        do j=1,jmx
        if(mask(i,j).lt.-90) then
          w3d(i,j,it)=-999.0
        else
          w3d(i,j,it)=fld3d(i,j,it)-wk1(it)*regr(i,j)
        endif
        enddo
        enddo
      enddo
c
c corr/regr for other modes with residual data
c
      do im=2,nmod
c
      do it=1,ltime
        xidx(it)=rpc(it,im)
      enddo
c
      do i=1,imx
      do j=1,jmx
 
      if(mask(i,j).lt.-90) then

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
      
      stop
      END


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
