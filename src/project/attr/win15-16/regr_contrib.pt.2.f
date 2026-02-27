      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      real pt(imx,jmx),p0(imx,jmx),p1(imx,jmx),p2(imx,jmx),p3(imx,jmx)
      real p4(imx,jmx),p5(imx,jmx),p6(imx,jmx),p7(imx,jmx),p8(imx,jmx)
      real p9(imx,jmx),p10(imx,jmx),p11(imx,jmx),p12(imx,jmx)
      real fld(imx,jmx)
      real aa(imx,jmx),bb(imx,jmx)
      real fld0(imx,jmx),fld1(imx,jmx),fld2(imx,jmx),fld3(imx,jmx)
      real fld4(imx,jmx),fld5(imx,jmx),fld6(imx,jmx)
      real fld7(imx,jmx),fld8(imx,jmx),fld9(imx,jmx)
      real fld10(imx,jmx),fld11(imx,jmx),fld12(imx,jmx)
      real regr(imx,jmx),corr(imx,jmx)
      real ts1(ltime),ts2(ltime)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real afld(imx,jmx,ltime)
      real w3d(imx,jmx,ltime)
      real obs(imx,jmx)
      real tcof(nmod,ltime)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !3_d data
      open(11,form='unformatted',access='direct',recl=4)
c regr&cor
      open(50,form='unformatted',access='direct',recl=4*imx*jmx)
c
c contributions for each winter
      open(51,form='unformatted',access='direct',recl=4*imx*jmx)
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-89.75+(j-1)*0.5
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use 
        cosr(j)=sqrt(coslat(j))  !for EOF use 
      enddo
c     write(6,*) 'coslat=',coslat
      undef=-9.99e+8
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
c== read in PCs
c
      ir=0
      do it=1,ltime
      do  m=1,nmod
      ir=ir+1
      read(11,rec=ir) tcof(m,it)
      enddo
      enddo
c 
c== regressing PCs to 3d data
c
      iw=0
      do m=1,nmod

      do it=1,ltime
        ts1(it)=tcof(m,it)
      enddo
c
      read(10,rec=1) fld
      do i=1,imx
      do j=1,jmx

      if(abs(fld(i,j)).gt.1000) then

        corr(i,j)=undef
        regr(i,j)=undef

      else

        do it=1,ltime
        ts2(it)=w3d(i,j,it)
        enddo
c
        call anom(ts1,ltime)
        call regr_t(ts1,ts2,ltime,corr(i,j),regr(i,j))

      endif

      enddo
      enddo

      iw=iw+1
      write(50,rec=iw) corr
      iw=iw+1
      write(50,rec=iw) regr

      enddo  !m loop

c== read in patterns
c
      read(50,rec=2) p1
      read(50,rec=4) p2
      read(50,rec=6) p3
      read(50,rec=8) p4
      read(50,rec=10) p5
c
c== trd and PCs for 2016
      t1=tcof(1,67)
      t2=tcof(2,67)
      t3=tcof(3,67)
      t4=tcof(4,67)
      t5=tcof(5,67)
        
       do i=1,imx
       do j=1,jmx
       if(abs(p1(i,j)).lt.1000) then
          fld1(i,j)=t1*p1(i,j)
          fld2(i,j)=t2*p2(i,j)
          fld3(i,j)=t3*p3(i,j)
          fld4(i,j)=t4*p4(i,j)
          fld5(i,j)=t5*p5(i,j)
        else
          fld1(i,j)=undef
          fld2(i,j)=undef
          fld3(i,j)=undef
          fld4(i,j)=undef
          fld5(i,j)=undef
        endif
        enddo
        enddo

      read(10,rec=67) obs
      iw=1
      write(51,rec=iw) obs
      iw=iw+1
      write(51,rec=iw) fld1
      iw=iw+1
      write(51,rec=iw) fld2
      iw=iw+1
      write(51,rec=iw) fld3
      iw=iw+1
      write(51,rec=iw) fld4
      iw=iw+1
      write(51,rec=iw) fld5
c
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
