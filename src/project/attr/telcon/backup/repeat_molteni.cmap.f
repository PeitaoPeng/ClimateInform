      program correlation
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. correlation between tropical area averaged sst and global field
C===========================================================
      real fld1(imx,jmx),fld2(im,jm),fld3(ims,jms)
      real fld3d(imx,jmx,ltime)
      real z200(im,jm,ltime)
      real sst(ims,jms,ltime)
      real corr(imx,jmx),regr(imx,jmx)
      real corr2(im,jm),regr2(im,jm)
      real corr3(ims,jms),regr3(ims,jms)
      real ts(ltime,3)
      real wk1(ltime),wk2(ltime)
c
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=12,form='unformatted',access='direct',recl=4*im*jm)
      open(unit=13,form='unformatted',access='direct',recl=4*ims*jms)
c
      open(unit=21,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=22,form='unformatted',access='direct',recl=4*im*jm)
      open(unit=23,form='unformatted',access='direct',recl=4*ims*jms)
      open(unit=31,form='unformatted',access='direct',recl=4)
c
c read in fld data
      do it=1,ltime
        read(11,rec=it) fld1
        read(12,rec=it) fld2
        read(13,rec=it) fld3
c
        call boxavg(fld1,imx,jmx,is1,ie1,js,je,avg1)
        call boxavg(fld1,imx,jmx,is2,ie2,js,je,avg2)
        call boxavg(fld1,imx,jmx,is3,ie3,js,je,avg3)

        ts(it,1)=avg1
        ts(it,2)=avg2
        ts(it,3)=avg3

        do i=1,imx
        do j=1,jmx
         fld3d(i,j,it)=fld1(i,j)
        enddo
        enddo
c
        do i=1,im
        do j=1,jm
         z200(i,j,it)=fld2(i,j)
        enddo
        enddo
c
        do i=1,ims
        do j=1,jms
         sst(i,j,it)=fld3(i,j)
        enddo
        enddo
      end do
c
c normalize box avg
      do ib=1,3
        do it=1,ltime
          wk1(it)=ts(it,ib)
        enddo
        call anom(wk1,ltime)
        call normal(wk1,wk2,sd,ltime)
        do it=1,ltime
          ts(it,ib)=wk2(it)
        enddo
      enddo

      iw=0
      iw2=0
      iw3=0
      do ib=1,3

c regr cmap
      do i=1,imx
      do j=1,jmx
 
      if(fld1(i,j).lt.-900) then

        corr(i,j)=-9999.0
        regr(i,j)=-9999.0

      else

        do it=1,ltime
        wk1(it)=fld3d(i,j,it)
        wk2(it)=ts(it,ib)
        enddo
        call anom(wk1,ltime)
        call regr_t(wk2,wk1,ltime,corr(i,j),regr(i,j))
        
      endif

      enddo
      enddo

      iw=iw+1
      write(21,rec=iw) corr
      iw=iw+1
      write(21,rec=iw) regr
c
c regr z200
      do i=1,im
      do j=1,jm
        do it=1,ltime
        wk1(it)=z200(i,j,it)
        wk2(it)=ts(it,ib)
        enddo
        call anom(wk1,ltime)
        call regr_t(wk2,wk1,ltime,corr2(i,j),regr2(i,j))
      enddo
      enddo
      iw2=iw2+1
      write(22,rec=iw2) corr2
      iw2=iw2+1
      write(22,rec=iw2) regr2
c
c regr sst
      do i=1,ims
      do j=1,jms

      if(fld3(i,j).lt.-900) then

        corr3(i,j)=-9999.0
        regr3(i,j)=-9999.0

      else
        do it=1,ltime
        wk1(it)=sst(i,j,it)
        wk2(it)=ts(it,ib)
        enddo
        call anom(wk1,ltime)
        call regr_t(wk2,wk1,ltime,corr3(i,j),regr3(i,j))
      endif

      enddo
      enddo
      iw3=iw3+1
      write(23,rec=iw3) corr3
      iw3=iw3+1
      write(23,rec=iw3) regr3


      enddo  !ib loop

c write out ts
      iw=0
      do it=1,ltime
      do ib=1,3

      iw=iw+1
        write(31,rec=iw) ts(it,ib)

      enddo  !ib loop
      enddo  !it loop
      
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

      SUBROUTINE boxavg(fld,imx,jmx,is,ie,js,je,avg)
      DIMENSION fld(imx,jmx)
      tot=0
      avg=0
      do i=is,ie
      do j=js,je
         tot=tot+1
         avg=avg+fld(i,j)
      enddo
      enddo
        avg=avg/tot
      return
      end
