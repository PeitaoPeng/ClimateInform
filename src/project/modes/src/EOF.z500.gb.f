      program svd_2_eof
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C calculate REOF of Z500 for consecutive 3 month data
C===========================================================
      PARAMETER (ifld=3*ny,nw=2*ifld+15)
      PARAMETER (ngrd=(je-js+1)*(ie-is+1))
      PARAMETER (nmode=ifld,neof=10)
      PARAMETER (jmp=jmx+1)
      PARAMETER (rotations=nmod)

      integer m,n,q,i,j,l,pass
      integer rot

      real fld(imx,jmx),fld1(imx,jmx),fld2(imx,jmx)
      real f3d(imx,jmx,ny),f4d(imx,jmx,ny,3),f4d2(imx,jmx,ny,3)
      real clim(imx,jmx),stdv(imx,jmx)
      real varp(imx,jmx),var3m(imx,jmx,3),vartot(imx,jmx)
      real corr(imx,jmx),rcorr(imx,jmx)
      real ts1(ifld),ts2(ifld)
      real ts3(ifld),ts4(ifld)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real afld(imx,jmx,ifld)
      real regr(imx,jmx)
      real corr2(imx,jmx),regr2(imx,jmx)
      real tcof(nmod,ifld)
      real eout(imx,jmp)

c     real aaa(ngrd,ifld),wk(ifld,ngrd),tt(nmod,nmod)
c     real eval(ifld),evec(ngrd,ifld),coef(ifld,ifld)

      dimension  data(ngrd,ifld), covar(ifld,ifld),
     #           eval0(nmode),evec0(ifld,ifld),pcout(ifld),
     #           eval(nmode), evaln(nmode),arrout(ngrd),
     #           pc(ifld,nmode),    space(ngrd,ifld),
     #           work(ifld*(ifld+1)/2+ifld)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !obs
C
      open(51,form='unformatted',access='direct',recl=4*imx*jmx)
      open(52,form='unformatted',access='direct',recl=4*ifld)
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-90+(j-1)*2.5
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use 
        cosr(j)=sqrt(coslat(j))  !for EOF use 
      enddo
      write(6,*) 'coslat=',coslat
c
C==read in data
c
      do ms=1,3
        if(ms.eq.1) ims=imm 
        if(ms.eq.2) ims=mons 
        if(ms.eq.3) ims=imp 
        iw=0
        do it=ims,ntotm,12
        read(10,rec=it) fld
        iw=iw+1
        write(6,*) 'iw=',iw
        do i=1,imx
        do j=1,jmx
          f4d(i,j,iw,ms)=fld(i,j)
        enddo
        enddo
        enddo
        write(6,*) 'ms=',ms,'iw=',iw
      enddo ! loop ms
ccc EOF calculation
      iw=0
      iw2=0
ccc feed matrixd data
      ir=0
      do ms=1,3
      do it=1,ny
      ir=ir+1
        ng=0
        do j=js,je
        do i=is,ie
          ng=ng+1
          data(ng,ir)=f4d(i,j,it,ms)
        end do
        end do
      end do
      end do
      write(6,*) 'ngrd= ',ng, ' nt=',ir
c
      do 2502 kt1 = 1, ifld
      do 2502 kt2 = 1, ifld
        covar(kt1,kt2) = 0.0
        do 2501 ks = 1, ngrd
 2501   covar(kt1,kt2) = covar(kt1,kt2) + data(ks,kt1)*data(ks,kt2)
        covar(kt1,kt2) = covar(kt1,kt2)/float(ngrd)
 2502 continue
      print *,'finished calculating co-variance matrix'
c
c     Calculate the eigenvalues
c
      call  eigrs (covar, ifld, 12, eval0, evec0, ifld, work, ier)
c
      evalt = 0.0
      do 3003 imode = 1, nmode
        eval(imode) = eval0(nmode-imode+1)
        evalt = evalt + eval(imode)
 3003 continue

      do 3004 imode = 1,nmode
        evaln(imode) = 100.*eval(imode)/evalt
 3004 continue
      print *,'eval==',eval
c     print *,'eignvalues=',evaln
c
c Calculate the spatial loading patterns and
c principal components for central month in question
c
      do 4001 km = 1, ifld
      do 4001 kt = 1, ifld
        pc(km,kt) = evec0(kt,ifld-km+1)
 4001 continue
c
      do 4003 km = 1, ifld
      do 4003 ks = 1, ngrd
        sum = 0.0
        do 4002 kt = 1, ifld
 4002   sum = sum + data(ks,kt)*pc(km,kt)
        space(ks,km) = sum
 4003 continue
      print *,'finished calculating loadings and pcs for month '
c
c     Output loading patterns and PC time series
c     for the 10 leading unrotated EOFs
c
      do 100 imode=1,neof
      do 105 igpt=1,ngrd
 105  arrout(igpt)=space(igpt,imode)
      call normal(arrout,ngrd)
      irec= imode
      write(51,rec=irec) arrout
 100  continue
c
      do 110 imode=1,neof
      do 115 iyr=1,ifld
 115  pcout(iyr)=pc(imode,iyr)
      call normal(pcout,ifld)
      irec=imode
      write(52,rec=irec) pcout
 110  continue
      print *,'finished writing loading patterns'

 10    continue
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

      SUBROUTINE clm_std(f,mx,my,nt,its,clm,std)
      DIMENSION f(mx,my,nt),clm(mx,my),std(mx,my)
      do i=1,mx
      do j=1,my

      clm(i,j)=0.
      std(i,j)=0.

      ite=nt
      do it=its,ite
         clm(i,j)=clm(i,j)+f(i,j,it)
      enddo
      clm(i,j)=clm(i,j)/float(nt)
c
      do it=1,nt
        f(i,j,it)=f(i,j,it)-clm(i,j)
      enddo
c
      do it=1,nt
        std(i,j)=std(i,j)+f(i,j,it)*f(i,j,it)
      enddo
      std(i,j)=sqrt(std(i,j)/float(nt))   

      enddo
      enddo
c
      return
      end
c
      SUBROUTINE anom(rot,ifld)
      DIMENSION rot(ifld)
      avg=0.
      do i=1,ifld
         avg=avg+rot(i)/float(ifld)
      enddo
      do i=1,ifld
        rot(i)=rot(i)-avg
      enddo
c
      return
      end

      SUBROUTINE normal(rot,ifld)
      DIMENSION rot(ifld)
      avg=0.
      do i=1,ifld
         avg=avg+rot(i)/float(ifld)
      enddo
      do i=1,ifld
c       rot(i)=rot(i)-avg
        rot(i)=rot(i)
      enddo
c
      sd=0.
      do i=1,ifld
        sd=sd+rot(i)*rot(i)/float(ifld)
      enddo
        sd=sqrt(sd)
      do i=1,ifld
        rot(i)=rot(i)/sd
      enddo
      return
      end

      SUBROUTINE regr_t(f1,f2,ifld,cor,reg,undef)

      real f1(ifld),f2(ifld)

      cor=0.
      sd1=0.
      sd2=0.

      do it=1,ifld
         cor=cor+f1(it)*f2(it)/float(ifld)
         sd1=sd1+f1(it)*f1(it)/float(ifld)
         sd2=sd2+f2(it)*f2(it)/float(ifld)
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      reg=cor/(sd1)
      cor=cor/(sd1*sd2)

      if(f2(1).gt.99999) then
        reg=undef
        cor=undef
      endif

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
