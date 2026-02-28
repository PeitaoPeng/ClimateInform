      program eof
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C===========================================================
      PARAMETER (nmod=11)
      PARAMETER (ifld=ltime,nw=2*ifld+15)
      PARAMETER (ngrd=(late-lats+1)*(lone-lons+1))
      real fld(imx,jmx),fld1(imx,jmx),fld2(imx,jmx)
      real corr(imx,jmx),rcorr(imx,jmx)
      real sst(ltime),tps(ltime)
      real ts1(ltime),ts2(ltime)
      real aaa(ngrd,ifld),wk(ifld,ngrd),tt(nmod,nmod)
      real eval(ifld),evec(ngrd,ifld),coef(ifld,ifld)
      real rin(ifld),rot2(ifld),rot(ifld)
      real weval(ifld),wevec(ngrd,ifld),wcoef(ifld,ifld)
      real reval(nmod),revec(ngrd,ifld),rcoef(nmod,ifld)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real rwk(ngrd),rwk2(ngrd,nmod)
      real amipa(imx,jmx,ltime+2,nm)
      real obsa(imx,jmx,ltime+2)
      real afld(imx,jmx,ltime+2,nm+1)
      real regr(imx,jmx)
      real corr2(imx,jmx),regr2(imx,jmx)
      real cor3d(imx,jmx,nm+1),reg3d(imx,jmx,nm+1)
      real tcof(nmod+5,ltime)
      real spc(nm),spr(nm)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !obs
C
      open(11,form='unformatted',access='direct',recl=4*imx*jmx) !11->21: model
      open(12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(13,form='unformatted',access='direct',recl=4*imx*jmx)
      open(14,form='unformatted',access='direct',recl=4*imx*jmx)
      open(15,form='unformatted',access='direct',recl=4*imx*jmx)
      open(16,form='unformatted',access='direct',recl=4*imx*jmx)
      open(17,form='unformatted',access='direct',recl=4*imx*jmx)
      open(18,form='unformatted',access='direct',recl=4*imx*jmx)
      open(19,form='unformatted',access='direct',recl=4*imx*jmx)
      open(20,form='unformatted',access='direct',recl=4*imx*jmx)
      open(21,form='unformatted',access='direct',recl=4*imx*jmx)
c
      open(22,form='unformatted',access='direct',recl=4)
      open(23,form='unformatted',access='direct',recl=4)
C
      open(51,form='unformatted',access='direct',recl=4*imx*jmx)
      open(52,form='unformatted',access='direct',recl=4*ltime)
      open(53,form='unformatted',access='direct',recl=4*nm)
C
      data xlat/-87.864,-85.097,-82.313,-79.526,-76.737,-73.948,
     '-71.158,-68.368,-65.578,-62.787,-59.997,-57.207,-54.416,
     '-51.626,-48.835,-46.045,-43.254,-40.464,-37.673,-34.883,
     '-32.092,-29.301,-26.511,-23.720,-20.930,-18.139,-15.348,
     '-12.558,-9.767,-6.977,-4.186,-1.395, 1.395,  4.186,  6.977,
     '9.767, 12.558, 15.348, 18.139, 20.930,23.720, 26.511, 29.301,
     '32.092, 34.883, 37.673, 40.464, 43.254,46.045, 48.835, 51.626,
     '54.416, 57.207, 59.997, 62.787, 65.578,68.368, 71.158,
     '73.948, 76.737, 79.526, 82.313, 85.097, 87.86/
C
C== have coslat
C
      do j=1,jmx
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use 
        cosr(j)=sqrt(coslat(j))  !for EOF use 
      enddo
c     write(6,*) 'coslat=',coslat
C==read in obs
      do it=1,ltime+2
        read(10,rec=it) fld
        do i=1,imx
        do j=1,jmx
          obsa(i,j,it)=fld(i,j)
          afld(i,j,it,1)=fld(i,j)
        enddo
        enddo
      enddo
C
C==read in the data of 11 amip models
C
      DO iu=11,21
      do it=1,ltime+2
        read(iu,rec=it) fld
        do i=1,imx
        do j=1,jmx
          amipa(i,j,it,iu-10)= fld(i,j)
          afld(i,j,it,iu-10+1)= fld(i,j)
        enddo
        enddo
      enddo
      ENDDO
c
c== read in nino34 index
c
      do it=1,ltime
      read(22,rec=it) sst(it)
      read(23,rec=it) tps(it)
      enddo
      call anom(sst,ltime)
      call anom(tps,ltime)
      write(6,*) 'nino34=', sst
      write(6,*) 'tpsst=', tps
c
c== take residual of nino34 by subtract tpsst signal from it
C
      call regr_t(tps,sst,ltime,xcor,xreg) !to see their corr
      write(6,*) 'xreg=',xreg
      write(6,*) 'xcor=',xcor
      call normal(tps,ts1,ltime)
      do it=1,ltime
        sst(it)=sst(it)-ts1(it)*xreg
      enddo
      call regr_t(tps,sst,ltime,xcor,xreg) !to see their corr
      write(6,*) 'xreg=',xreg
      write(6,*) 'xcor=',xcor
c
c== put non-normalized nino34 and tpsst aside for later us
c
      do it=1,ltime
        tcof(1,it)=sst(it)
        tcof(2,it)=tps(it)
      enddo
c
c== regr of obs z200 to nino34 and tp_sst
c
      do i=1,imx
      do j=1,jmx
        do it=1,ltime
        ts1(it)=obsa(i,j,it)
        enddo
        call regr_t(sst,ts1,ltime,corr(i,j),regr(i,j))
        call regr_t(tps,ts1,ltime,corr2(i,j),regr2(i,j))
      enddo
      enddo
c
c== have residual
c
      call normal(sst,ts1,ltime)  !for residual use
      call normal(tps,ts2,ltime)  !for residual use
c
      do it=1,ltime
        do i=1,imx
        do j=1,jmx
          obsa(i,j,it)=obsa(i,j,it)-ts1(it)*regr(i,j)
     &-ts2(it)*regr2(i,j)
        enddo
        enddo
      enddo
c
ccc feed matrix aaa
c
      do it=1,ltime
        ng=0
        do j=lats,late
        do i=lons,lone
          ng=ng+1
          aaa(ng,it)=obsa(i,j,it)*cosr(j)
        end do
        end do
      end do
      write(6,*) 'ngrd= ',ng
c
cc... EOF analysis begin
c
      call eofs(aaa,ngrd,ifld,ifld,eval,evec,coef,wk)
      call REOFS(aaa,ngrd,ifld,ifld,wk,weval,wevec,wcoef,
     &           nmod,reval,revec,rcoef,tt,rwk,rwk2)
cc... arange reval,revec and rcoef in decreasing order
      call order(ngrd,ifld,nmod,reval,revec,rcoef)
cc... write out eval and reval
      totv1=0
      do i=1,20
      write(6,*)'eval= ',i,eval(i)
      totv1=totv1+eval(i)
      end do
      write(6,*)'total= ',totv1

      totv2=0
      do i=1,nmod
      write(6,*)'reval= ',i,reval(i)
      totv2=totv2+reval(i)
      end do
      write(6,*)'total= ',totv2
c
c== put rcoef to tcof for easy later use
c
      do m=1,nmod
      do it=1,ltime
        tcof(m+2,it)=rcoef(m,it)
      enddo
      enddo
c
c==CORR between coef and data
c
      iw=0
      iw2=0
      iw3=0
      DO m=1,nmod+2 !loop over mode

      do it=1,ltime
        ts1(it)=tcof(m,it)
      enddo
c
      do im=1,nm+1  !loop over models
c
      do j=1,jmx
      do i=1,imx

      do it=1,ltime
        ts2(it)=afld(i,j,it,im)
      enddo

      call regr_t(ts1,ts2,ltime,corr(i,j),regr(i,j))

      enddo
      enddo

      iw=iw+1
      write(51,rec=iw) corr
      iw=iw+1
      write(51,rec=iw) regr
c== put corr and regr for later use
      do i=1,imx
      do j=1,jmx
        cor3d(i,j,im)=corr(i,j)
        reg3d(i,j,im)=regr(i,j)
      enddo
      enddo

      enddo !loop over models
c
c== cor and rms between obs regr and model regr
c
      do im=1,nm
      do i=1,imx
      do j=1,jmx
        fld1(i,j)=reg3d(i,j,1)
        fld2(i,j)=reg3d(i,j,im+1)
      enddo
      enddo
      call sp_cor_rms(fld1,fld2,coslat,imx,jmx,
     &lons,lone,lats,late,spc(im),spr(im))
      enddo
      iw3=iw3+1
      write(53,rec=iw3) spc
      iw3=iw3+1
      write(53,rec=iw3) spr
c
      if(m.gt.2) then
      call normal(ts1,ts2,ltime)
      do it=1,ltime
        ts1(it)=ts2(it)
      enddo
      end if
c
      iw2=iw2+1
      write(52,rec=iw2) ts1
c
      enddo !loop over modes

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
