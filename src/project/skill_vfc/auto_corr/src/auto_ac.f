CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  Lagged Heidk skill
C==========================================================
      include "parm.h"
      dimension prd(imx,jmx,nss),obs(imx,jmx,nss) 
      dimension w2d(imx,jmx),w2d2(imx,jmx) 
      dimension w2d3(imx,jmx),w2d4(imx,jmx) 
      dimension ts1(nss),ts2(nss)
      dimension ts3(nss-1),ts4(nss-1)
      dimension ts5(nss-1),ts6(nss-1)
      dimension plag1(nss-1),olag1(nss-1)
      dimension glc(nss),tpc(nss),etc(nss)
      dimension corr(imx,jmx),corr2(imx,jmx) 
      dimension xlat(jmx),coslat(jmx),cosr(jmx)
      dimension xran(nran),xran2(nran-2),xw(nran),xw2(nran-2)
c
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx) !model
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx) !obs
      open(unit=21,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=22,form='unformatted',access='direct',recl=4) 
      open(unit=23,form='unformatted',access='direct',recl=4)
      open(unit=24,form='unformatted',access='direct',recl=4)
      open(unit=25,form='unformatted',access='direct',recl=4)
c
cc have coslat
      dl=2.
      do j=1,jmx
        xlat(j)=-90+(j-1)*2.5
        coslat(j)=cos(xlat(j)*3.14159/180)
        cosr(j)=sqrt(coslat(j))
      enddo
c
c= read in prd & obs data
      iw=0
      do it=1,nss
        read(11,rec=it) w2d
        read(12,rec=it) w2d2
        if(it.eq.444) read(12,rec=443) w2d
        do i=1,imx
        do j=1,jmx
          prd(i,j,it)=w2d(i,j)
          obs(i,j,it)=w2d2(i,j)
        enddo
        enddo
c= spatial corr 
        call corr_sp(w2d,w2d2,imx,jmx,coslat,glc(it),tpc(it),etc(it))
        iw=iw+1
        write(22,rec=iw) glc(it)
        iw=iw+1
        write(22,rec=iw) tpc(it)
        iw=iw+1
        write(22,rec=iw) etc(it)
      enddo !it loop
c
c= write out sck(it+1)
      iw=0
      do it=1,nss-1
        iw=iw+1
        write(25,rec=iw) glc(it+1)
        iw=iw+1
        write(25,rec=iw) tpc(it+1)
        iw=iw+1
        write(25,rec=iw) etc(it+1)
      enddo
c
c= lagged corr of corr_sp skill
      call lag_corr(nss,glc,ts1)
      write(6,*) 'glc_lag_cor=', (ts1(i), i=1,10)
      call lag_corr(nss,tpc,ts1)
      write(6,*) 'tpc_lag_cor=', (ts1(i), i=1,10)
      call lag_corr(nss,etc,ts1)
      write(6,*) 'etc_lag_cor=', (ts1(i), i=1,10)

c
c= skill in t-domain
      do i=1,imx
      do j=1,jmx
        do it=1,nss
         ts1(it)=prd(i,j,it)
         ts2(it)=obs(i,j,it)
        enddo
        call regr_t(ts1,ts2,nss,corr(i,j),xx)
      enddo
      enddo
      write(21,rec=1) corr
c
c= 1-mon lagged cor of prd&obs 
      do i=1,imx
      do j=1,jmx
        do it=1,nss-1
         ts3(it)=prd(i,j,it)
         ts4(it)=prd(i,j,it+1)
         ts5(it)=obs(i,j,it)
         ts6(it)=obs(i,j,it+1)
        enddo
        call regr_t(ts3,ts4,nss-1,corr(i,j),xx)
        call regr_t(ts5,ts6,nss-1,corr2(i,j),xx)
        w2d(i,j)=corr(i,j)*corr2(i,j)
      enddo
      enddo
      write(21,rec=2) corr
      write(21,rec=3) corr2
      write(21,rec=4) w2d
      call area_avg(w2d,imx,jmx,1,imx,1,jmx,coslat,av)
      write(6,*) 'sp_avg of f(t)f(t-1)*o(t)*o(t-1)==',av

c= one-month lagged spatial corr of prd and obs, respectively
      iw=0
      do it=1,nss-1
        do i=1,imx
        do j=1,jmx
           w2d(i,j)=prd(i,j,it)
           w2d2(i,j)=prd(i,j,it+1)
           w2d3(i,j)=obs(i,j,it)
           w2d4(i,j)=obs(i,j,it+1)
        enddo
        enddo
           call corr_sp(w2d, w2d2,imx,jmx,coslat,c1,c2,c3)
           call corr_sp(w2d3,w2d4,imx,jmx,coslat,c4,c5,c6)
           iw=iw+1
           write(23,rec=iw) c1
           iw=iw+1
           write(23,rec=iw) c2
           iw=iw+1
           write(23,rec=iw) c3
           iw=iw+1
           write(23,rec=iw) c4
           iw=iw+1
           write(23,rec=iw) c5
           iw=iw+1
           write(23,rec=iw) c6
      enddo
c
c= random time series
      ir=1
      do i=1,nran
         ir=ir+1
         xran(i)=ran1(ir)
      enddo
      call normal(xran,nran)
c
c     3-points runing mean
      do i=2,nran-1
        xran2(i-1)=(xran(i-1)+xran(i)+xran(i+1))/3.
      enddo
      call lag_corr(nran,xran,xw)
      write(6,*) 'xran_lag_cor=', (xw(i), i=1,15)
      call lag_corr(nran-2,xran2,xw2)
      write(6,*) 'xran2_lag_cor=', (xw2(i), i=1,15)
c write out random numbers
      iw=0
      do i=1,500
      iw=iw+1
      write(24,rec=iw) xran(i)
      iw=iw+1
      write(24,rec=iw) xran2(i)
      enddo
      
      
c
      stop
      end

      subroutine normal(x,n)
      dimension x(n)
      avg=0
      do i=1,n
        avg=avg+x(i)/float(n)
      enddo
      var=0
      do i=1,n
        var=var+(x(i)-avg)*(x(i)-avg)/float(n)
      enddo
      std=sqrt(var)
      do i=1,n
        x(i)=(x(i)-avg)/std
      enddo
      return
      end
c
      FUNCTION ran1(idum)
      INTEGER idum,IA,IM,IQ,IR,NTAB,NDIV
      REAL ran1,AM,EPS,RNMX
      PARAMETER (IA=16807,IM=2147483647,AM=1./IM,IQ=127773,IR=2836,
     *NTAB=32,NDIV=1+(IM-1)/NTAB,EPS=1.2e-7,RNMX=1.-EPS)
      INTEGER j,k,iv(NTAB),iy
      SAVE iv,iy
      DATA iv /NTAB*0/, iy /0/
      if (idum.le.0.or.iy.eq.0) then
        idum=max(-idum,1)
        do 11 j=NTAB+8,1,-1
          k=idum/IQ
          idum=IA*(idum-k*IQ)-IR*k
          if (idum.lt.0) idum=idum+IM
          if (j.le.NTAB) iv(j)=idum
11      continue
        iy=iv(1)
      endif
      k=idum/IQ
      idum=IA*(idum-k*IQ)-IR*k
      if (idum.lt.0) idum=idum+IM
      j=1+iy/NDIV
      iy=iv(j)
      iv(j)=idum
      ran1=min(AM*iy,RNMX)
      return
      END

      SUBROUTINE regr_t(f1,f2,ltime,cor,reg)

      real f1(ltime),f2(ltime)

      av1=0.
      av2=0.
      do it=1,ltime
      av1=av1+f1(it)/float(ltime)
      av2=av2+f2(it)/float(ltime)
      enddo

      do it=1,ltime
c     f1(it)=f1(it)-av1
c     f2(it)=f2(it)-av2
      enddo

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

      SUBROUTINE corr_sp(w1,w2,imx,jmx,cosl,glc,tpc,etc)

      real w1(imx,jmx),w2(imx,jmx)
      real cosl(jmx)

c global corr
      op=0.
      pp=0
      oo=0
      do i=1,imx
      do j=1,jmx
      op=op+w1(i,j)*w2(i,j)*cosl(j)
      pp=pp+w1(i,j)*w1(i,j)*cosl(j)
      oo=oo+w2(i,j)*w2(i,j)*cosl(j)
      enddo
      enddo
      glc=op/sqrt(oo*pp)

c tropical corr
      op=0.
      pp=0
      oo=0
      do j=27,47
      do i=1,imx
      op=op+w1(i,j)*w2(i,j)*cosl(j)
      pp=pp+w1(i,j)*w1(i,j)*cosl(j)
      oo=oo+w2(i,j)*w2(i,j)*cosl(j)
      enddo
      enddo
      tpc=op/sqrt(oo*pp)

c extratropical corr
      op=0.
      pp=0
      oo=0
      do j=1,26
      do i=1,imx
      op=op+w1(i,j)*w2(i,j)*cosl(j)
      pp=pp+w1(i,j)*w1(i,j)*cosl(j)
      oo=oo+w2(i,j)*w2(i,j)*cosl(j)
      enddo
      enddo
      do j=48,jmx
      do i=1,imx
      op=op+w1(i,j)*w2(i,j)*cosl(j)
      pp=pp+w1(i,j)*w1(i,j)*cosl(j)
      oo=oo+w2(i,j)*w2(i,j)*cosl(j)
      enddo
      enddo
      etc=op/sqrt(oo*pp)

      return
      end

      SUBROUTINE area_avg(w1,imx,jmx,is,ie,js,je,cosl,av)

      real w1(imx,jmx)
      real cosl(jmx)

      av=0
      ss=0
      do i=is,ie
      do j=js,je
      av=av+w1(i,j)*cosl(j)
      ss=ss+cosl(j)
      enddo
      enddo
      av=av/ss
      return
      end

