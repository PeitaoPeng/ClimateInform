      program correlation
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. correlation between rpc and global field
C===========================================================
c     PARAMETER (imx=128,jmx=64,ltime=21,mode=10)
      real fld1(imx,jmx),fld2(imx,jmx),regr(imx,jmx)
      real fld3d(imx,jmx,ltime2)
      real corr(imx,jmx),rpc(ltime,mode)
      real wk1(ltime2),wk2(ltime2),rcoef(ltime2)
      dimension mask(imx,jmx)
c
      open(unit=11,form='unformatted',access='direct',recl=4)
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=50,form='unformatted',access='direct',recl=4*imx*jmx)
c
c read in fld data
      do it=1,ltime2
        read(12,rec=it) fld1
        do i=1,imx
        do j=1,jmx
         fld3d(i,j,it)=fld1(i,j)
        enddo
        enddo
      end do
      write(6,*) 'rpc='
c     write(6,*) 'sst=',fld1
c
c read in rpc
      iw=0
      do it=1,ltime
        do m=1,mode
        iw=iw+1
        read(11,rec=iw) rpc(it,m)
        enddo
      enddo
c
      iwrite=1
      do 2000 m=1,mode

      do it=1,ltime2
        rcoef(it)=rpc(it+18,m)
      enddo
      write(6,*) rcoef
c
      do i=1,imx
      do j=1,jmx
c
        do it=1,ltime2
        wk1(it)=fld3d(i,j,it)
        enddo

        call anom(rcoef,ltime2)
        call anom(wk1,ltime2)
        call regr_t(rcoef,wk1,ltime2,corr(i,j),regr(i,j))
        
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
