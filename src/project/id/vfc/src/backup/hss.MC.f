CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  Heidk skill
C==========================================================
      include "parm.h"
      parameter (nbin=121)
      dimension mask(imx,jmx)
      dimension kprd(imx,jmx,nss),kvfc(imx,jmx,nss)  !nss: # of seasons
      dimension hdk1(nss),hdk2(nss)
      dimension corlag(nss)
      dimension hdk1_t(imx,jmx),hdk2_t(imx,jmx)
      dimension hdk1cyc(12),hdk2cyc(12)
      dimension mwk1(imx,jmx),mwk2(imx,jmx)
c
      dimension wk1(imx,jmx),wk2(imx,jmx)
      dimension wk3(imx,jmx),wk4(imx,jmx)
      dimension wk5(imx,jmx),wk6(imx,jmx)
      dimension wk1d1(nss),wk1d2(nss)
      dimension wk1d3(nss),wk1d4(nss)
      dimension wk1d5(nss),wk1d6(nss)
c
      dimension mw1d1(nss),mw1d2(nss)
      dimension xnonec(nss),xnonec2d(imx,jmx)
      dimension xnoneccyc(12)
      dimension xlat(jmx),coslat(jmx)
      dimension fld1d1(232),fld1d2(232)
      dimension ran(nss),rdx(nss)
c
      dimension hsmc1(nsp),hsmc2(nsp)
      dimension hsbin(nbin)
c
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx) !mask
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx) !fcst
      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx) 
      open(unit=51,form='unformatted',access='direct',recl=4)
      open(unit=52,form='unformatted',access='direct',recl=4*imx*jmx) !spa patt of H skill
      open(unit=53,form='unformatted',access='direct',recl=4)  !seasonal cycle of hdk
      open(unit=54,form='unformatted',access='direct',recl=4*232)  !seasonal cycle of hdk
      open(unit=55,form='unformatted',access='direct',recl=nbin*4)  !hss bin
c
cc have coslat
      dl=2.
      do j=1,jmx
        xlat(j)=dl*(j-1)+20.
c       coslat(j)=COS(3.14159*xlat(j)/180)
        coslat(j)=1.
      enddo
      write(6,*) 'xlat=',xlat
      write(6,*) 'coslat=',coslat

C= read in mask
      read(11,rec=1) wk1
      call real_2_itg(wk1,mask,imx,jmx)
c
c= read in prd data
      do it=1,nss
        read(12,rec=it) wk1
        do i=1,imx
        do j=1,jmx
          mwk1(i,j)=wk1(i,j)
        enddo
        enddo
        call change_numb(mwk1,imx,jmx)  !convert prd to -1,0,+1,9
        do i=1,imx
        do j=1,jmx
          kprd(i,j,it)=mwk1(i,j)
        enddo
        enddo
      enddo
c
c= read in verification data
      do it=1,nss 
        read(13,rec=it) wk1
        do i=1,imx
        do j=1,jmx
          kvfc(i,j,it)=wk1(i,j)
        enddo
        enddo
      enddo
c
cc and calculate HEIDKE skill time series
      avghs1=0.
      avghs2=0.
      do it=1,nss
        do i=1,imx
        do j=1,jmx
          mwk1(i,j)=kprd(i,j,it)
          mwk2(i,j)=kvfc(i,j,it)
        enddo
        enddo
        call heidke1(mask,mwk1,mwk2,coslat,hs1,ntot1,imx,jmx)
        call heidke2(mask,mwk1,mwk2,coslat,hs2,ntot2,imx,jmx)
        call hss_s_MC(mask,mwk1,mwk2,coslat,imx,jmx,nsp,hsmc1,hsmc2)
          hdk1(it)=hs1
          hdk2(it)=hs2
          avghs1=avghs1+hs1/float(nss)  !(nss): no data for it=1 
          avghs2=avghs2+hs2/float(nss)
          avg_tot1=avg_tot1+ntot1/float(nss)
          avg_tot2=avg_tot2+ntot2/float(nss)
          xnonec(it)=100*float(ntot2)/float(ntot1)
c         write(6,999) it,hs2,hs1,ntot1,ntot2,xnonec(it)
          write(6,777) it,hs1
c
        call hss_stat(hs1,hs2,hsmc1,hsmc2,nsp,
     &hsm1,hsm2,sdv1,sdv2,ct1,ct2)
        wk1d1(it)=hsm1
        wk1d2(it)=hsm2
        wk1d3(it)=sdv1
        wk1d4(it)=sdv2
        wk1d5(it)=ct1
        wk1d6(it)=ct2
      enddo
c
cc calculate HEIDKE for all data of the period
      call hss1_all(mask,kprd,kvfc,coslat,hss1,imx,jmx,nss)
      call hss2_all(mask,kprd,kvfc,coslat,hss2,imx,jmx,nss)
      write(6,*)'all data hss1=',hss1, '  all_data hss2=',hss2
      call hss_all_MC(mask,kprd,kvfc,coslat,imx,jmx,nss,nsp,hsmc1,hsmc2)
      call hss_stat(hss1,hss2,hsmc1,hsmc2,nsp,
     &hsm1,hsm2,sdv1,sdv2,ct1,ct2)
      write(6,*)'hsm1_all=',hsm1, '  hsm2_all=',hsm2
      write(6,*)'sdv1_all=',sdv1, '  sdv2_all=',sdv2
      write(6,*)'pct1_all=',ct1, '  pct2_all=',ct2
      call hssbin(hsmc1,hsbin,nsp,nbin)
      write(55,rec=1) hsbin
      call hssbin(hsmc2,hsbin,nsp,nbin)
      write(55,rec=2) hsbin
c
cc seasonal cycle of hdk skill
c
c from jfm to djf
      do is=1,12 
        hdk1cyc(is)=0.
        hdk2cyc(is)=0.
        xnoneccyc(is)=0.
        nyrhs2=0.
      do it=is,nss,12
        hdk1cyc(is)=hdk1cyc(is)+hdk1(it)/nyr
        xnoneccyc(is)=xnoneccyc(is)+xnonec(it)/nyr
        if(abs(hdk2(it)).le.100) then
        nyrhs2=nyrhs2+1
        hdk2cyc(is)=hdk2cyc(is)+hdk2(it)
        endif
      enddo
        hdk2cyc(is)=hdk2cyc(is)/float(nyrhs2)
      enddo
c
cc spatial patterns of HEIDKE skill
c for all seasons
      do i=1,imx
      do j=1,jmx
        hdk1_t(i,j)=-9999.0
        hdk2_t(i,j)=-9999.0
        wk1(i,j)=-9999.0
        wk2(i,j)=-9999.0
        wk3(i,j)=-9999.0
        wk4(i,j)=-9999.0
        wk5(i,j)=-9999.0
        wk6(i,j)=-9999.0
      enddo
      enddo
      iland=0
      do i=1,imx
      do j=1,jmx
      IF(mask(i,j).eq.1) then
        do it=1,nss
          mw1d1(it)=kprd(i,j,it)
          mw1d2(it)=kvfc(i,j,it)
        enddo
        call heidke1_t(mw1d1,mw1d2,hs1,tot1,nss,nss)
        call heidke2_t(mw1d1,mw1d2,hs2,tot2,nss,nss)
        call hss_t_MC(mw1d1,mw1d2,nss,nss,nsp,hsmc1,hsmc2)
        if (i.eq.10.and.j.eq.9) then
          call hssbin(hsmc1,hsbin,nsp,nbin)
          write(6,*) 'bin=',hsbin
          write(55,rec=3) hsbin
          call hssbin(hsmc2,hsbin,nsp,nbin)
          write(55,rec=4) hsbin
          write(6,*) 'SW USA:',' hss1=',hs1,'  hss2=',hs2
        end if
        if (i.eq.18.and.j.eq.10) then
          call hssbin(hsmc1,hsbin,nsp,nbin)
          write(6,*) 'bin=',hsbin
          write(55,rec=5) hsbin
          call hssbin(hsmc2,hsbin,nsp,nbin)
          write(55,rec=6) hsbin
          write(6,*) 'MD USA:',' hss1=',hs1,'  hss2=',hs2
        end if
c
        call hss_stat(hs1,hs2,hsmc1,hsmc2,nsp,
     &hsm1,hsm2,sdv1,sdv2,ct1,ct2)
c
          hdk1_t(i,j)=hs1
          hdk2_t(i,j)=hs2
          wk1(i,j)=hsm1
          wk2(i,j)=hsm2
          wk3(i,j)=sdv1
          wk4(i,j)=sdv2
          wk5(i,j)=ct1
          wk6(i,j)=ct2
          xnonec2d(i,j)=100*tot2/tot1 !ratio of nonec grids
          iland=iland+1
          fld1d1(iland)=hs2 !for scattering plot
          fld1d2(iland)=xnonec2d(i,j) !for scattering plot
      END IF
      enddo
      enddo
      iw=1
      write(52,rec=iw) hdk1_t
      iw=iw+1
      write(52,rec=iw) hdk2_t
      iw=iw+1
      write(52,rec=iw) xnonec2d
      iw=iw+1
      write(52,rec=iw) wk1  !avg MC HSS1
      iw=iw+1
      write(52,rec=iw) wk2  !avg MC HSS2
      iw=iw+1
      write(52,rec=iw) wk3  !stdv of MC HSS1
      iw=iw+1
      write(52,rec=iw) wk4  !stdv of MC HSS2
      iw=iw+1
      write(52,rec=iw) wk5  !hs1 higher% than MC HSS1
      iw=iw+1
      write(52,rec=iw) wk6  !hs2 higher% than MC HSS2

c for summer(AMJ,MJJ,JJA,JAS)
      do i=1,imx
      do j=1,jmx
        hdk1_t(i,j)=-9999.0
        hdk2_t(i,j)=-9999.0
        wk1(i,j)=-9999.0
        wk2(i,j)=-9999.0
        wk3(i,j)=-9999.0
        wk4(i,j)=-9999.0
        wk5(i,j)=-9999.0
        wk6(i,j)=-9999.0
      enddo
      enddo
      do i=1,imx
      do j=1,jmx
      IF(mask(i,j).eq.1) then
        ir=0
        do it=4,nss,12  !AMJ
          ir=ir+1
          mw1d1(ir)=kprd(i,j,it)
          mw1d2(ir)=kvfc(i,j,it)
        enddo
        do it=5,nss,12  !MJJ
          ir=ir+1
          mw1d1(ir)=kprd(i,j,it)
          mw1d2(ir)=kvfc(i,j,it)
        enddo
        do it=6,nss,12  !JJA
          ir=ir+1
          mw1d1(ir)=kprd(i,j,it)
          mw1d2(ir)=kvfc(i,j,it)
        enddo
        do it=7,nss,12  !JAS
          ir=ir+1
          mw1d1(ir)=kprd(i,j,it)
          mw1d2(ir)=kvfc(i,j,it)
        enddo
        write(6,*)'summer ir=',ir
        call heidke1_t(mw1d1,mw1d2,hs1,tot1,nss,ir)
        call heidke2_t(mw1d1,mw1d2,hs2,tot2,nss,ir)
        call hss_t_MC(mw1d1,mw1d2,nss,ir,nsp,hsmc1,hsmc2)
        call hss_stat(hs1,hs2,hsmc1,hsmc2,nsp,
     &hsm1,hsm2,sdv1,sdv2,ct1,ct2)
          hdk1_t(i,j)=hs1
          hdk2_t(i,j)=hs2
          wk1(i,j)=hsm1
          wk2(i,j)=hsm2
          wk3(i,j)=sdv1
          wk4(i,j)=sdv2
          wk5(i,j)=ct1
          wk6(i,j)=ct2
      END IF
      enddo
      enddo
      iw=iw+1
      write(52,rec=iw) hdk1_t
      iw=iw+1
      write(52,rec=iw) hdk2_t
      write(6,*) hdk2_t
      iw=iw+1
      write(52,rec=iw) wk1  !avg MC HSS1
      iw=iw+1
      write(52,rec=iw) wk2  !avg MC HSS2
      iw=iw+1
      write(52,rec=iw) wk3  !stdv of MC HSS1
      iw=iw+1
      write(52,rec=iw) wk4  !stdv of MC HSS2
      iw=iw+1
      write(52,rec=iw) wk5  !hs1 higher% than MC HSS1
      iw=iw+1
      write(52,rec=iw) wk6  !hs2 higher% than MC HSS2
c for winter (OND,NDJ,DJF,JFM)
      do i=1,imx
      do j=1,jmx
        hdk1_t(i,j)=-9999.0
        hdk2_t(i,j)=-9999.0
        wk1(i,j)=-9999.0
        wk2(i,j)=-9999.0
        wk3(i,j)=-9999.0
        wk4(i,j)=-9999.0
        wk5(i,j)=-9999.0
        wk6(i,j)=-9999.0
      enddo
      enddo
      do i=1,imx
      do j=1,jmx
      IF(mask(i,j).eq.1) then
        ir=0
        do it=10,nss,12  !OND
          ir=ir+1
          mw1d1(ir)=kprd(i,j,it)
          mw1d2(ir)=kvfc(i,j,it)
        enddo
        do it=11,nss,12  !NDJ
          ir=ir+1
          mw1d1(ir)=kprd(i,j,it)
          mw1d2(ir)=kvfc(i,j,it)
        enddo
        do it=12,nss,12  !DJF
          ir=ir+1
          mw1d1(ir)=kprd(i,j,it)
          mw1d2(ir)=kvfc(i,j,it)
        enddo
        do it=1,nss,12  !JFM
          ir=ir+1
          mw1d1(ir)=kprd(i,j,it)
          mw1d2(ir)=kvfc(i,j,it)
        enddo
        write(6,*)'winter ir=',ir
        call heidke1_t(mw1d1,mw1d2,hs1,tot1,nss,ir)
        call heidke2_t(mw1d1,mw1d2,hs2,tot2,nss,ir)
        call hss_t_MC(mw1d1,mw1d2,nss,ir,nsp,hsmc1,hsmc2)
        call hss_stat(hs1,hs2,hsmc1,hsmc2,nsp,
     &hsm1,hsm2,sdv1,sdv2,ct1,ct2)
          hdk1_t(i,j)=hs1
          hdk2_t(i,j)=hs2
          hdk1_t(i,j)=hs1
          hdk2_t(i,j)=hs2
          wk1(i,j)=hsm1
          wk2(i,j)=hsm2
          wk3(i,j)=sdv1
          wk4(i,j)=sdv2
          wk5(i,j)=ct1
          wk6(i,j)=ct2
      END IF
      enddo
      enddo
      iw=iw+1
      write(52,rec=iw) hdk1_t
      iw=iw+1
      write(52,rec=iw) hdk2_t
      iw=iw+1
      write(52,rec=iw) wk1  !avg MC HSS1
      iw=iw+1
      write(52,rec=iw) wk2  !avg MC HSS2
      iw=iw+1
      write(52,rec=iw) wk3  !stdv of MC HSS1
      iw=iw+1
      write(52,rec=iw) wk4  !stdv of MC HSS2
      iw=iw+1
      write(52,rec=iw) wk5  !hs1 higher% than MC HSS1
      iw=iw+1
      write(52,rec=iw) wk6  !hs2 higher% than MC HSS2
c     write(6,*) hdk2_t
c
 777  format(I3,3x,f7.2)
 888  format(10f7.2)
 999  format(I3,3x,2f9.2,2I5,f7.2)
     
      iw=0
      do it=1,nss
      iw=iw+1
      write(51,rec=iw) hdk1(it)
      iw=iw+1
      write(51,rec=iw) hdk2(it)
      iw=iw+1
      write(51,rec=iw) xnonec(it)
      iw=iw+1
      write(51,rec=iw) wk1d1(it)
      iw=iw+1
      write(51,rec=iw) wk1d2(it)
      iw=iw+1
      write(51,rec=iw) wk1d3(it)
      iw=iw+1
      write(51,rec=iw) wk1d4(it)
      iw=iw+1
      write(51,rec=iw) wk1d5(it)
      iw=iw+1
      write(51,rec=iw) wk1d6(it)
      enddo
c
      iw=0
      do it=1,12
      iw=iw+1
      write(53,rec=iw) hdk1cyc(it)
      iw=iw+1
      write(53,rec=iw) hdk2cyc(it)
      iw=iw+1
      write(53,rec=iw) xnoneccyc(it)
      enddo
c
      write(54,rec=1) fld1d1
      write(54,rec=2) fld1d2
c
      write(6,*) 'avg_hs1=',avghs1
      write(6,*) 'avg_hs2=',avghs2
      write(6,*) 'avg_tot1=',avg_tot1
      write(6,*) 'avg_tot2=',avg_tot2
      
c
cc lagged corr of ldk skill
      call lag_corr(nss,hdk1,corlag)
      write(6,*)'lagcor of hs1=',corlag
      call lag_corr(nss,xnonec,corlag)
      write(6,*)'lagcorof nonec grid=',corlag
c
      stop
      end
        
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  real 2 integer
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine real_2_itg(wk,mw,m,n)
      dimension wk(m,n),mw(m,n)
c
      do i=1,m
      do j=1,n
      mw(i,j)=wk(i,j)
      end do
      end do
c
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  put MC hss into a bin
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine hssbin(wk,bin,m,n)
      dimension wk(m),bin(n)
c
      do j=1,n
        bin(j)=0.
      enddo
c
      bs=-21
      be=-20
      inc=1.  !increment of hs

      do j=1,n

      bs=bs+inc
      be=be+inc

      do i=1,m
        if(wk(i).gt.bs.and.wk(i).le.be) bin(j)=bin(j)+1
      enddo
c     write(6,*) 'bs&be=',bs,be
c
      end do
c
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  change num of verification to -1,0,+1,9
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine change_numb(mw,m,n)
      dimension mw(m,n)
c
      do i=1,m
      do j=1,n
      if(mw(i,j).eq.0) mw(i,j)=9
      if(mw(i,j).eq.1) mw(i,j)=-1
      if(mw(i,j).eq.2) mw(i,j)=0
      if(mw(i,j).eq.3) mw(i,j)=1
      end do
      end do
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  set array zero
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine setzero2(a,m,n)
      real a(m,n)
c
      do i=1,m
      do j=1,n
        a(i,j)=0.
      end do
      end do
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  set array zero
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine setzero(a,n)
      real a(n)
      do 5 i=1,n
      a(i)=0.
  5   continue
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  get rid of mean
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine anom(a,n)
      real a(n)
      avg=0
      do 5 i=1,n-4
      avg=avg+a(i+2)/float(n-4)
  5   continue
      do 6 i=1,n-4
      a(i+2)=a(i+2)-avg
  6   continue
      return
      end


CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  runing mean
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine runmean(a,n,b,m)
      real a(n),b(n)
c
      do i=1,m
        b(i)=a(i)
        b(n-i+1)=a(n-i+1)
      enddo
c
      do 5 i=m+1,n-m
        avg=0
        do 6 j=i-m,i+m
        avg=avg+a(j)/float(2*m+1)
  6   continue
        b(i)=avg
  5   continue
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  acc in time domain
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine acc(a,b,n,c)
      real a(n),b(n)
c
      avg_a=0.
      avg_b=0.
      do i=1,n
c       avg_a=avg_a+a(i)/float(n)
c       avg_b=avg_b+b(i)/float(n)
      enddo
c
      do i=1,n
      a(i)=a(i)-avg_a
      b(i)=b(i)-avg_b
      enddo
c
      sd_a=0
      sd_b=0
      ac=0
      do i=1,n
      sd_a=sd_a+a(i)*a(i)/float(n)
      sd_b=sd_b+b(i)*b(i)/float(n)
      ac=ac+a(i)*b(i)/float(n)
      enddo
      sd_a=sqrt(sd_a)
      sd_b=sqrt(sd_b)
      c=ac/(sd_a*sd_b)
c     
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  rms in time domain
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine rms(a,b,n,c)
      real a(n),b(n)
c
      c=0.
      do i=1,n
      c=c+(a(i)-b(i))*(a(i)-b(i))/float(n)
      enddo
      c=sqrt(c)
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  stdv of the time series
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine stdv(a,n,c)
      real a(n)
c
      avg_a=0.
      do i=1,n
        avg_a=avg_a+a(i)/float(n)
      enddo
c
      c=0.
      do i=1,n
      c=c+(a(i)-avg_a)*(a(i)-avg_a)/float(n)
      enddo
      c=sqrt(c)
c
      return
      end

      SUBROUTINE terc102(t,a,b,it3) 
c* transforms 102 temperatures into 102 terciled values 
      DIMENSION t(102),it3(102) 
      DO 11 i=1,102 
      icd=i 
      IF (t(icd).le.b)it3(i)=-1 
      IF (t(icd).ge.a)it3(i)=1 
      IF (t(icd).lt.a.and.t(icd).gt.b)it3(i)=0 
11    CONTINUE 
      RETURN 
      END 

      subroutine heidke1(mask,mw1,mw2,coslat,hs,ntot,m,n) 
      dimension mask(m,n),mw1(m,n),mw2(m,n),coslat(n)
     
      h=0. 
      tot=0. 
      ntot=0
      do i=1,m
      do j=1,n
      IF(mask(i,j).eq.1) then
c     IF(abs(mw2(i,j)).ne.9999) then
      tot=tot+coslat(j)
      ntot=ntot+1
      if (mw1(i,j).ne.9) then
      if (mw1(i,j).eq.mw2(i,j)) h=h+coslat(j)
      else
        h=h+coslat(j)/3.
      end if
      END IF
      enddo 
      enddo 
      hs=(h-tot/3.)/(tot-tot/3.)*100. 
c     write(6,*) 'h=',h,'tot=',tot,'hs=',hs
      return 
      end 
c
      subroutine hss1_all(mask,mw1,mw2,coslat,hs,m,n,nt) 
      dimension mask(m,n),mw1(m,n,nt),mw2(m,n,nt),coslat(n)
     
      h=0. 
      tot=0. 
      ntot=0
      do i=1,m
      do j=1,n
      do it=2,nt  !1 st month data is undefined
      IF(mask(i,j).eq.1) then
      tot=tot+coslat(j)
      ntot=ntot+1
      if (mw1(i,j,it).ne.9) then
      if (mw1(i,j,it).eq.mw2(i,j,it)) h=h+coslat(j)
      else
        h=h+coslat(j)/3.
      end if
      END IF
      enddo 
      enddo 
      enddo 
      hs=(h-tot/3.)/(tot-tot/3.)*100. 
      write(6,*) 'hit#=',h,'  tot#=',tot,'  hss1_all=',hs
      return 
      end 
c
c
      subroutine heidke1_t(mw1,mw2,hs,tot,m,n) 
      dimension mw1(m),mw2(m)
     
      h=0. 
      tot=0. 
      do i=1,n
      tot=tot+1
      if (mw1(i).ne.9) then
      if (mw1(i).eq.mw2(i)) h=h+1
      else
        h=h+1/3.
      end if
      enddo 
      hs=(h-tot/3.)/(tot-tot/3.)*100. 
      return 
      end 

      subroutine heidke2(mask,mw1,mw2,coslat,hs,ntot,m,n) 
      dimension mask(m,n),mw1(m,n),mw2(m,n),coslat(n)
     
      h=0. 
      tot=0. 
      ntot=0. 
      usgrd=0
      do i=1,m
      do j=1,n
      IF(mask(i,j).eq.1) then
c     IF(abs(mw2(i,j)).ne.9999) then
        usgrd=usgrd+coslat(j)
        if(mw1(i,j).ne.9) then
        tot=tot+coslat(j)
        ntot=ntot+1
        if (mw1(i,j).eq.mw2(i,j)) h=h+coslat(j)
        end if
      END IF
      enddo 
      enddo 
        hs=-9999.
        if (tot.gt.0) hs=(h-tot/3.)/(tot-tot/3.)*100. 
        hs2=hs*tot/usgrd
      return 
      end 
c
      subroutine hss2_all(mask,mw1,mw2,coslat,hs,m,n,nt) 
      dimension mask(m,n),mw1(m,n,nt),mw2(m,n,nt),coslat(n)
     
      h=0. 
      tot=0. 
      ntot=0. 
      usgrd=0
      do i=1,m
      do j=1,n
      do it=2,nt  !1st record is undefined
      IF(mask(i,j).eq.1) then
        usgrd=usgrd+coslat(j)
        if(mw1(i,j,it).ne.9) then
        tot=tot+coslat(j)
        ntot=ntot+1
        if (mw1(i,j,it).eq.mw2(i,j,it)) h=h+coslat(j)
        end if
      END IF
      enddo 
      enddo 
      enddo 
        hs=-9999.
        if (tot.gt.0) hs=(h-tot/3.)/(tot-tot/3.)*100. 
        hs2=hs*tot/usgrd
      write(6,*) 'hit#=',h,'  tot#=',tot,'  hss2_all=',hs
      return 
      end 
c
      subroutine heidke2_t(mw1,mw2,hs,tot,m,n) 
      dimension mw1(m),mw2(m)
     
      h=0. 
      tot=0. 
      do i=1,n
        if(mw1(i).ne.9) then
        tot=tot+1
        if (mw1(i).eq.mw2(i)) h=h+1
        end if
      enddo 
        hs=-9999.
        if (tot.gt.0) hs=(h-tot/3.)/(tot-tot/3.)*100. 
        hs2=hs*tot/usgrd
      return 
      end 


CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  48MRM
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine rm_48m(a,b,n,nr,m)
      real a(n),b(n)
c
      do i=1,m-1
        b(i)=a(i)
      enddo
c
      do 5 i=m,nr
        avg=0
        do 6 j=i-m+1,i
        avg=avg+a(j)/float(m)
  6   continue
        b(i)=avg
  5   continue
      return
      end

