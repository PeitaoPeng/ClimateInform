      program eof
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C proj reof patt to drd and rsd data
C===========================================================
      parameter(nbin=20)
      real regr(imx,jmx),corr(imx,jmx)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      dimension crr(nmon-1),ipc(nmon-1)
      dimension ms(nmon-1)
      dimension cr(nmon-1,nmon-1),cry(nmon-1,nmon-1,nyr)
      dimension maxp(nyr)
      real w2d(imx,jmx),w2d2(imx,jmx),w2d3(imx,jmx)
      real w3d(imx,jmx,5)
      dimension hstg(nbin,4)
      dimension hstg2(nbin),ncase(4)
      dimension cr1d(1000)
      real nino34(nyr)
C
      open(11,form='unformatted',access='direct',recl=4*imx*jmx) 
      open(50,form='unformatted',access='direct',recl=4*nbin) 
      open(60,form='unformatted',access='direct',recl=4) 
      open(20,form='unformatted',access='direct',recl=4) 
      open(70,form='unformatted',access='direct',recl=4*nyr) 
C
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-90+(j-1)*2.5
        coslat(j)=cos(xlat(j)*3.14159/180)
      enddo
c
      iyear=1949
      ip0=0
      ip1=0
      ip2=0
      ip3=0
      ip4=0
c initiate winter# with varous persistence in El Nino winters
      ipw0=0
      ipw1=0
      ipw2=0
      ipw3=0
      ipw4=0

c initiate winter# with varous persistence in La Nina winters
      ipc0=0
      ipc1=0
      ipc2=0
      ipc3=0
      ipc4=0

      iw=0
      do iy=1,nyr

      nmo=nmon

c read in nmo-month data for year iy
c     do im=1,nmo
c       ir=(iy-1)*5+im
        irs=(iy-1)*12+11
        ire=iy*12+3
        im=0
        do ir=irs,ire
        read(11,rec=ir) w2d 
        im=im+1
        do i=1,imx
        do j=1,jmx
          w3d(i,j,im)=w2d(i,j)
        enddo
        enddo
      enddo !im loop

cccc patt corr of each pare of data among the nmo
      do im=1,nmo-1

c take first field
        do i=1,imx
        do j=1,jmx
          w2d(i,j)=w3d(i,j,im)
        enddo
        enddo

c take second field
        km=0
        do l=1,nmo-1
        cr(l,im)=-9.99
        cry(l,im,iy)=-9.99
        enddo

        do jm=im+1,nmo

        km=km+1

        do i=1,imx
        do j=1,jmx
          w2d2(i,j)=w3d(i,j,jm)
        enddo
        enddo

c pattern corr
      call ptcor(w2d,w2d2,imx,jmx,lons,lone,lats,late,coslat,cr(km,im))
c
      cry(km,im,iy)=cr(km,im)

      enddo !jm loop

      enddo !im loop
      
c count # of various persistent for each season
      call ptcount(cr,ct,nmon-1,ipc,ms)

      call xmaxm(ipc,ms,nmo-1,maxp(iy),kout)
      do k=1,nmo-1
        crr(k)=cr(k,kout)
      enddo

      if(ipc(1).gt.0.or.ipc(2).gt.0.or.ipc(3).gt.0.or.ipc(4).gt.0) then
      irr=ir
      write(6,999)'yr=',iyear,'maxp=',maxp(iy),'start mon=',kout,'cr=',
     &crr
  999 format(A3,2x,I5,2x,A5,I3,2x,A11,I3,2x,A4,4f9.3)
      do i=1,nmo-1
        do j=1,nmo-1
        crr(j)=cr(j,i)
        enddo
c     write(6,*) crr
      enddo
      endif

      if(maxp(iy).eq.0) ip0=ip0+1
      if(maxp(iy).eq.1) ip1=ip1+1
      if(maxp(iy).eq.2) ip2=ip2+1
      if(maxp(iy).eq.3) ip3=ip3+1
      if(maxp(iy).eq.4) ip4=ip4+1
c
      read(20,rec=iy) sst
      nino34(iy)=sst
c
      if(iy.eq.27.or.iy.eq.28) then
c     write(6,*) 'iy=',iyear,'sst=',sst
      endif

      if(maxp(iy).eq.0.and.sst.gt.0.5) ipw0=ipw0+1
      if(maxp(iy).eq.1.and.sst.gt.0.5) ipw1=ipw1+1
      if(maxp(iy).eq.2.and.sst.gt.0.5) ipw2=ipw2+1
      if(maxp(iy).eq.3.and.sst.gt.0.5) ipw3=ipw3+1
      if(maxp(iy).eq.4.and.sst.gt.0.5) ipw4=ipw4+1

      if(maxp(iy).eq.0.and.sst.lt.-0.5) ipc0=ipc0+1
      if(maxp(iy).eq.1.and.sst.lt.-0.5) ipc1=ipc1+1
      if(maxp(iy).eq.2.and.sst.lt.-0.5) ipc2=ipc2+1
      if(maxp(iy).eq.3.and.sst.lt.-0.5) ipc3=ipc3+1
      if(maxp(iy).eq.4.and.sst.lt.-0.5) ipc4=ipc4+1
c
      xp0=-999.0
      xp1=-999.0
      xp2=-999.0
      xp3=-999.0
      xp4=-999.0
      if(maxp(iy).eq.0) xp0=1.
c     if(maxp(iy).eq.1) xp1=2.
c     if(maxp(iy).eq.2) xp2=3.
c     if(maxp(iy).eq.3) xp3=4.
c     if(maxp(iy).eq.4) xp4=5.
      if(maxp(iy).eq.1) xp1=1.
      if(maxp(iy).eq.2) xp2=1.
      if(maxp(iy).eq.3) xp3=1.
      if(maxp(iy).eq.4) xp4=1.
      iw=iw+1
      write(60,rec=iw) xp0
      iw=iw+1
      write(60,rec=iw) xp1
      iw=iw+1
      write(60,rec=iw) xp2
      iw=iw+1
      write(60,rec=iw) xp3
      iw=iw+1
      write(60,rec=iw) xp4

      iyear=iyear+1

      enddo !year

c write out statstics of persitency
      ip0=nyr-ip1-ip2-ip3-ip4
      write(6,*) 'p1=',ip0,'p2=',ip1,'p3=',ip2,'p4=',ip3,'p5=',ip4
      write(6,*) 'pw1=',ipw0,'pw2=',ipw1,'pw3=',ipw2,'pw4=',ipw3,
     &'pw5=',ipw4
      write(6,*) 'pc1=',ipc0,'pc2=',ipc1,'pc3=',ipc2,'pc4=',ipc3,
     &'pc5=',ipc4
      p0=100*float(ip0)/65.
      p1=100*float(ip1)/65.
      p2=100*float(ip2)/65.
      p3=100*float(ip3)/65.
      p4=100*float(ip4)/65.
      pw0=100*float(ipw0)/65.
      pw1=100*float(ipw1)/65.
      pw2=100*float(ipw2)/65.
      pw3=100*float(ipw3)/65.
      pw4=100*float(ipw4)/65.
      pc0=100*float(ipc0)/65.
      pc1=100*float(ipc1)/65.
      pc2=100*float(ipc2)/65.
      pc3=100*float(ipc3)/65.
      pc4=100*float(ipc4)/65.
      pn0=p0-pw0-pc0
      pn1=p1-pw1-pc1
      pn2=p2-pw2-pc2
      pn3=p3-pw3-pc3
      pn4=p4-pw4-pc4
      write(6,*) 'for percentage'
      write(6,*) 'p1=',p0,'p2=',p1,'p3=',p2,'p4=',p3,'p5=',p4
      write(6,*) 'pw1=',pw0,'pw2=',pw1,'pw3=',pw2,'pw4=',pw3,
     &'pw5=',pw4
      write(6,*) 'pc1=',pc0,'pc2=',pc1,'pc3=',pc2,'pc4=',pc3,
     &'pc5=',pc4
      write(6,*) 'pn1=',pn0,'pn2=',pn1,'pn3=',pn2,'pn4=',pn3,
     &'pn5=',pn4
c ratio of El Nino and La Nia winters
      warmyr=0
      coldyr=0
      do iy=1,nyr
      if(nino34(iy).gt.0.5) warmyr=warmyr+1
      if(nino34(iy).lt.-0.5) coldyr=coldyr+1
      enddo
      write(6,*) 'warmyr=',warmyr, 'coldyr=',coldyr
c
c have statistics for all years using cry
c
c have histogram for each lag(1-4)
      do lag=1,4
      do ib=1,nbin
        hstg(ib,lag)=0
      enddo
      enddo

      do lag=1,4

      ncase(lag)=0
      ct1=-1.  !lower limit of cor
      dct=0.1  !increament of cor

      do i=1,1000
        cr1d(i)=0.
      enddo

      do ib=1,nbin
      ct2=ct1+dct
      do iy=1,nyr
      do im=1,nmo-1
        cor=cry(lag,im,iy)
        if(cor.gt.ct1.and.cor.le.ct2) then
        hstg(ib,lag)=hstg(ib,lag)+1
        ncase(lag)=ncase(lag)+1
      endif
      enddo
      enddo
      ct1=ct1+dct
      enddo  !bin loop
      
      do ib=1,nbin
        hstg2(ib)=hstg(ib,lag)/float(ncase(lag))
      enddo

      ic=0
      do iy=1,nyr
      do im=1,nmo-1
        cor=cry(lag,im,iy)
        if(cor.ge.-1.and.cor.le.1) then
        ic=ic+1
        cr1d(ic)=cor
        endif
      enddo
      enddo

      write(6,*) 'lag=',lag-1,' ncase=',ncase(lag)
      write(50,rec=lag) hstg2
      call mean_std(cr1d,1000,ncase(lag),avg,std)
      write(6,*) 'mean=',avg,' std=',std

      enddo  !lag loop

      stop
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  count the # of persistency for each array of corr
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine ptcount(cr,ct,n,ip,ms)
      dimension cr(n,n),ip(n),ms(n)
c
      do i=1,n
        ip(i)=0
        ms(i)=0
      enddo

      do i=1,n
      if(cr(1,i).ge.ct.and.cr(2,i).ge.ct.and.cr(3,i).ge.ct.and.
     &cr(4,i).ge.ct) then
      ip(4)=4
      ms(4)=i
      else if(cr(1,i).ge.ct.and.cr(2,i).ge.ct.and.cr(3,i).ge.ct) then
      ip(3)=3
      ms(3)=i

      else if(cr(1,i).ge.ct.and.cr(2,i).ge.ct) then
      ip(2)=2
      ms(2)=i
      
      else if(cr(1,i).ge.ct) then
      ip(1)=1
      ms(1)=i
      endif
      enddo
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  find the maxmum in a array
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine xmaxm(na,ms,n,mx,kout)
      dimension na(n),ms(n)
c
      nx=na(1)
      kk=1
      do i=2,n
      if (nx.lt.na(i)) then
        nx=na(i)
        kk=ms(i)
      endif
      enddo
      mx=nx !nx+1 months are similar
      kout=kk
c
      return
      end

C pattern corr of two fields
      SUBROUTINE ptcor(reg,fld,imx,jmx,lons,lone,lats,late,coslat,pj)
      DIMENSION reg(imx,jmx),fld(imx,jmx),coslat(jmx)
      pj=0.
      v1=0.
      v2=0.
      do i=lons,lone
      do j=lats,late
      pj=pj+reg(i,j)*fld(i,j)*coslat(j)
      v1=v1+reg(i,j)*reg(i,j)*coslat(j)
      v2=v2+fld(i,j)*fld(i,j)*coslat(j)
      enddo
      enddo
      pj=pj/sqrt(v1*v2)
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

      SUBROUTINE mean_std(f,m,n,avg,std)
      real f(m)
      avg=0.
      do i=1,n
        avg=avg+f(i)/float(n)
      enddo
      std=0.
      do i=1,n
      std=std+(f(i)-avg)*(f(i)-avg)/float(n)
      enddo
      std=sqrt(std)
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
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  using least square to have y=a+bx
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine ltrend(grid,out,out2,imx,jmx,nt,its,ite,a,b)
      dimension grid(imx,jmx,nt),out(imx,jmx,nt)
      dimension out2(imx,jmx,nt)
      dimension a(imx,jmx),b(imx,jmx)
      real lxx, lxy
c
      do i=1,imx
      do j=1,jmx
c
      xb=0
      yb=0
      do it=its,ite
        xb=xb+float(it)/float(ite-its+1)
        yb=yb+grid(i,j,it)/float(ite-its+1)
      enddo
c
      lxx=0.
      lxy=0.
      do it=its,ite
      lxx=lxx+(it-xb)*(it-xb)
      lxy=lxy+(it-xb)*(grid(i,j,it)-yb)
      enddo
      b(i,j)=lxy/lxx
      a(i,j)=yb-b(i,j)*xb
      enddo !over j
      enddo !over i
c
      do i=1,imx
      do j=1,jmx
      do it=1,nt
        out(i,j,it)=grid(i,j,it)-b(i,j)*float(it)-a(i,j) !detrended
        out2(i,j,it)=b(i,j)*float(it)+a(i,j) !trend
      enddo
      enddo
      enddo
c
      return
      end
