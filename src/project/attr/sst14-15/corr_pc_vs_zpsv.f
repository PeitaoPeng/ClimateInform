      program correlation
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. correlation between tropical area averaged sst and global field
C===========================================================
c     PARAMETER (imx=128,jmx=64,ltime=21,mode=10)
      real fld1(imx,jmx),fld2(imx,jmx),regr(imx,jmx)
      real fld4d(imx,jmx,ltime,4)
      real corr(imx,jmx),rcoef(ltime)
      real wk1(ltime),wk2(ltime),rcf(ltime)
      real pc(ltime,2,nmod)
      dimension mask(imx,jmx)
c
      open(unit=10,form='unformatted',access='direct',recl=4)
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=50,form='unformatted',access='direct',recl=4*imx*jmx)
c
c read in z200,psi and vlp
      ir=0
      do it=1,ltime
        do iv=1,3
        ir=ir+1
        read(11,rec=ir) fld1
        do i=1,imx
        do j=1,jmx
         fld4d(i,j,it,iv)=fld1(i,j)
        enddo
        enddo
      end do
        read(12,rec=it) fld1
        do i=1,imx
        do j=1,jmx
         fld4d(i,j,it,4)=fld1(i,j)
        enddo
        enddo
      end do
c
c== read in PCs
c
      ir=0
      do it=1,ltime
      do m=1,nmod
      ir=ir+1
      read(10,rec=ir) pc(it,1,m)
      ir=ir+1
      read(10,rec=ir) pc(it,2,m)
      enddo
      enddo
c
      iw=0
      do 2000 m=1,nmod
      do iv=1,4
      do  n=1,2 !pc and rpc
c
      do it=1,ltime
      rcoef(it)=pc(it,n,m)
      enddo

      do i=1,imx
      do j=1,jmx

        do it=1,ltime
        wk1(it)=fld4d(i,j,it,iv)
        enddo

        call anom(wk1,ltime,ltw)
        call regr_t(rcoef,wk1,ltime,ltw,corr(i,j),regr(i,j))

      enddo
      enddo

      iw=iw+1
      write(50,rec=iw) corr
      iw=iw+1
      write(50,rec=iw) regr

      enddo
      enddo

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


      SUBROUTINE anom(rot,ltime,ltw)
      DIMENSION rot(ltime)
      avg=0.
      do i=1,ltw
         avg=avg+rot(i)/float(ltw)
      enddo
      do i=1,ltw
        rot(i)=rot(i)-avg
      enddo
c
      return
      end

      SUBROUTINE regr_t(f1,f2,ltime,ltw,cor,reg)

      real f1(ltime),f2(ltime)

      cor=0.
      sd1=0.
      sd2=0.

      do it=1,ltw
         cor=cor+f1(it)*f2(it)/float(ltw)
         sd1=sd1+f1(it)*f1(it)/float(ltw)
         sd2=sd2+f2(it)*f2(it)/float(ltw)
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
