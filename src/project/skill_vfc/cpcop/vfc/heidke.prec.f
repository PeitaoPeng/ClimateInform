CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  Heidk skill
C==========================================================
      include "parm.h"
      dimension mask(imx,jmx)
      dimension kprd(imx,jmx,nss),kvfc(imx,jmx,nss)  !nss: # of seasons
      dimension hdk1(nss-1),hdk2(nss-1)
      dimension corlag(nss-1)
      dimension hdk1_t(imx,jmx),hdk2_t(imx,jmx)
      dimension hdk1cyc(12),hdk2cyc(12)
      dimension mwk1(imx,jmx),mwk2(imx,jmx)
      dimension wk1(imx,jmx),wk2(imx,jmx)
      dimension w1d1(nss-1),w1d2(nss-1)
      dimension mw1d1(nss-1),mw1d2(nss-1)
      dimension xnonec(nss-1),xnonec2d(imx,jmx)
      dimension xnoneccyc(12)
      dimension xlat(jmx),coslat(jmx)
      dimension fld1d1(232),fld1d2(232)
c
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx) !mask
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx) !fcst
      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx) !obs w.r.t. 61-90 clim
      open(unit=14,form='unformatted',access='direct',recl=4*imx*jmx) !obs w.r.t. 71-00 clim
      open(unit=51,form='unformatted',access='direct',recl=4)
      open(unit=52,form='unformatted',access='direct',recl=4*imx*jmx) !spa patt of H skill
      open(unit=53,form='unformatted',access='direct',recl=4)  !seasonal cycle of hdk
      open(unit=54,form='unformatted',access='direct',recl=4*232)  !seasonal cycle of hdk
      open(unit=55,form='unformatted',access='direct',recl=4)  !lagged corr ldk
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
      do it=1,77 ! JFM 1995 to MMJ of 2001
        read(13,rec=it) wk1
        do i=1,imx
        do j=1,jmx
          kvfc(i,j,it)=wk1(i,j)
        enddo
        enddo
      enddo
      do it=78,nss !JJA 2001 to MAM 2007(=147)
        read(14,rec=it) wk1
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
      do it=2,nss
        do i=1,imx
        do j=1,jmx
          mwk1(i,j)=kprd(i,j,it)
          mwk2(i,j)=kvfc(i,j,it)
        enddo
        enddo
        call heidke1(mask,mwk1,mwk2,coslat,hs1,ntot1,imx,jmx)
        call heidke2(mask,mwk1,mwk2,coslat,hs2,ntot2,imx,jmx)
          hdk1(it-1)=hs1
          hdk2(it-1)=hs2
          avghs1=avghs1+hs1/float(nss-1)  !(nss-1): no data for it=1 
          if(abs(hs2).gt.100) hs2=0.
          avghs2=avghs2+hs2/float(nss-1)
          avg_tot1=avg_tot1+ntot1/float(nss-1)
          avg_tot2=avg_tot2+ntot2/float(nss-1)
          xnonec(it-1)=100*float(ntot2)/float(ntot1)
          write(6,999) it,hs2,hs1,ntot1,ntot2,xnonec(it-1)
          itt=it-1
c         write(6,999) itt,hs2,hs1
c     write(6,*) 'ntot1=',ntot1
c     write(6,*) 'ntot2=',ntot2
      enddo
cc calculate HEIDKE for all data of the period
        call hss1_all(mask,kprd,kvfc,coslat,hss1,imx,jmx,nss)
        call hss2_all(mask,kprd,kvfc,coslat,hss2,imx,jmx,nss)
c
cc lagged corr of ldk skill
      call lag_corr(nss-1,hdk1,corlag)
      write(6,*)'lagcor=',corlag
c
cc seasonal cycle of hdk skill
c
c for fma to djf
      do is=2,12  !is=2,12, there is no jfm for 1995
        hdk1cyc(is)=0.
        hdk2cyc(is)=0.
        xnoneccyc(is)=0.
        rny=0.
      do it=is-1,nss,12
        hdk1cyc(is)=hdk1cyc(is)+hdk1(it)/nyr
        if (abs(hdk2(it)).lt.100) then
        hdk2cyc(is)=hdk2cyc(is)+hdk2(it)
        rny=rny+1
        endif
        xnoneccyc(is)=xnoneccyc(is)+xnonec(it)/nyr
      enddo
        hdk2cyc(is)=hdk2cyc(is)/rny
      enddo
c for jfm
        hdk1cyc(1)=0.
        hdk2cyc(1)=0.
        rny=0.
      do it=12,nss,12  !for jfm
        hdk1cyc(1)=hdk1cyc(1)+hdk1(it)/nyr
        if (abs(hdk2(it)).lt.100) then
        hdk2cyc(1)=hdk2cyc(1)+hdk2(it)
        rny=rny+1
        endif
        xnoneccyc(1)=xnoneccyc(1)+xnonec(it)/nyr
      enddo
        hdk2cyc(1)=hdk2cyc(1)/rny
c
cc spatial patterns of HEIDKE skill
c for all seasons
      do i=1,imx
      do j=1,jmx
        hdk1_t(i,j)=-9999.0
        hdk2_t(i,j)=-9999.0
      enddo
      enddo
      iland=0
      do i=1,imx
      do j=1,jmx
      IF(mask(i,j).eq.1) then
        do it=2,nss
          mw1d1(it-1)=kprd(i,j,it)
          mw1d2(it-1)=kvfc(i,j,it)
        enddo
        call heidke1_t(mw1d1,mw1d2,hs1,tot1,nss-1,nss-1)
        call heidke2_t(mw1d1,mw1d2,hs2,tot2,nss-1,nss-1)
          hdk1_t(i,j)=hs1
          hdk2_t(i,j)=hs2
          xnonec2d(i,j)=100*tot2/tot1 !ratio of nonec grids
          iland=iland+1
          fld1d1(iland)=hs2 !for scattering plot
          fld1d2(iland)=xnonec2d(i,j) !for scattering plot
      END IF
      enddo
      enddo
      iw=1
      write(52,rec=iw) hdk1_t
c     write(6,*) hdk1_t
      iw=iw+1
      write(52,rec=iw) hdk2_t
      iw=iw+1
      write(52,rec=iw) xnonec2d
c     write(6,*) hdk2_t
c for summer(AMJ,MJJ,JJA,JAS)
      do i=1,imx
      do j=1,jmx
        hdk1_t(i,j)=-9999.0
        hdk2_t(i,j)=-9999.0
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
        call heidke1_t(mw1d1,mw1d2,hs1,tot1,nss-1,48)
        call heidke2_t(mw1d1,mw1d2,hs2,tot1,nss-1,48)
          hdk1_t(i,j)=hs1
          hdk2_t(i,j)=hs2
      END IF
      enddo
      enddo
      iw=iw+1
      write(52,rec=iw) hdk1_t
      write(6,*) hdk1_t
      iw=iw+1
      write(52,rec=iw) hdk2_t
      write(6,*) hdk2_t
c for winter (OND,NDJ,DJF,JFM)
      do i=1,imx
      do j=1,jmx
        hdk1_t(i,j)=-9999.0
        hdk2_t(i,j)=-9999.0
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
        do it=13,nss,12  !JFM
          ir=ir+1
          mw1d1(ir)=kprd(i,j,it)
          mw1d2(ir)=kvfc(i,j,it)
        enddo
        write(6,*)'winter ir=',ir
        call heidke1_t(mw1d1,mw1d2,hs1,tot1,nss-1,48)
        call heidke2_t(mw1d1,mw1d2,hs2,tot1,nss-1,48)
          hdk1_t(i,j)=hs1
          hdk2_t(i,j)=hs2
      END IF
      enddo
      enddo
      iw=iw+1
      write(52,rec=iw) hdk1_t
      write(6,*) hdk1_t
      iw=iw+1
      write(52,rec=iw) hdk2_t
      write(6,*) hdk2_t
c
 888  format(10f7.2)
 999  format(I3,3x,2f9.2,2I5,f7.2)
     
      iw=0
      do it=1,nss-1
      iw=iw+1
      write(51,rec=iw) hdk1(it)
      iw=iw+1
      write(51,rec=iw) hdk2(it)
      iw=iw+1
      write(51,rec=iw) xnonec(it)
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
C  chang num of verification to -1,0,+1,9
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

