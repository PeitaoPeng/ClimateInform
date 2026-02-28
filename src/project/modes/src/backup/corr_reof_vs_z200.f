      program correlation
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. correlation between tropical area averaged sst and global field
C===========================================================
c     PARAMETER (imx=128,jmx=64,ltime=21,mode=10)
      real fld1(imx,jmx),fld2(imx,jmx),regr(imx,jmx)
      real fld3d(imx,jmx,ltime)
      real corr(imx,jmx),rcoef(ltime)
      real wk1(ltime),wk2(ltime),rcf(ltime)
      dimension mask(imx,jmx)
c
      open(unit=11,form='unformatted',access='direct',recl=4*ltime)
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=50,form='unformatted',access='direct',recl=4*imx*jmx)
c have land mask
      read(12,rec=1) mask
c
c read in fld data
      do it=1,ltime
        read(13,rec=it) fld1
        do i=1,imx
        do j=1,jmx
         fld3d(i,j,it)=fld1(i,j)
        enddo
        enddo
      end do
c
      iwrite=1
      do 2000 m=1,mode

      read(11,rec=m) rcoef
c
      do i=1,imx
      do j=1,jmx
c
c     if(mask(i,j).gt.-100) then

c       corr(i,j)=-999.0
c       regr(i,j)=-999.0

c     else

        do it=1,ltime
        wk1(it)=fld3d(i,j,it)
        enddo

        call anom(wk1,ltime)
        call regr_t(rcoef,wk1,ltime,corr(i,j),regr(i,j))
        
c     endif

      enddo
      enddo

      write(50,rec=iwrite) corr
      iwrite=iwrite+1
      write(50,rec=iwrite) regr
      iwrite=iwrite+1

 2000 continue
      
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
