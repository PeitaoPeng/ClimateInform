CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  % of a&b ctg
C==========================================================
      include "parm.h"
      dimension mask(imx,jmx)
      dimension kprd(imx,jmx,nss,3),kvfc(imx,jmx,nss)  !nss: # of seasons
      dimension wk1(imx,jmx),wk2(imx,jmx)
      dimension mwk1(imx,jmx),mwk2(imx,jmx)
      dimension prdabv(nss,3),prdblw(nss,3)
      dimension obsabv(nss),obsblw(nss)
c
      dimension wk1d1(nss),wk1d2(nss)
      dimension wk1d3(nss),wk1d4(nss)
      dimension wk1d5(nss),wk1d6(nss)
c
      dimension xlat(jmx),coslat(jmx)
c
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx) !mask
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=14,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=15,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=51,form='unformatted',access='direct',recl=4)
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
c= read in data for CFSv1, CFSv2, CPCopr
      do iunit=12,14
      do it=1,nss
        read(iunit,rec=it) wk1
        do i=1,imx
        do j=1,jmx
          mwk1(i,j)=wk1(i,j)
        enddo
        enddo
        call change_numb(mwk1,imx,jmx)  !convert prd to -1,0,+1,9
        do i=1,imx
        do j=1,jmx
          kprd(i,j,it,iunit-11)=mwk1(i,j)
        enddo
        enddo

        call ab_count(mask,mwk1,coslat,ta,tb,imx,jmx)
c       if(iunit.eq.14) call ab_count(mask,mwk1,coslat,ta,tb,imx,jmx)
        prdabv(it,iunit-11)=ta
        prdblw(it,iunit-11)=tb

      enddo !it-loop
      enddo !iunit-loop
c
c= read in verification data
      do it=1,nss 
        read(15,rec=it) wk1
        do i=1,imx
        do j=1,jmx
          kvfc(i,j,it)=wk1(i,j)
          mwk1(i,j)=wk1(i,j)
        enddo
        enddo

        call ab_count(mask,mwk1,coslat,ta,tb,imx,jmx)
        obsabv(it)=ta
        obsblw(it)=tb

      enddo
c
c write out
c
      iw=0.
      do it=1,nss
      iw=iw+1
        write(51,rec=iw) prdabv(it,1)
      iw=iw+1
        write(51,rec=iw) prdblw(it,1)
      iw=iw+1
        write(51,rec=iw) prdabv(it,2)
      iw=iw+1
        write(51,rec=iw) prdblw(it,2)
      iw=iw+1
        write(51,rec=iw) prdabv(it,3)
      iw=iw+1
        write(51,rec=iw) prdblw(it,3)
      iw=iw+1
        write(51,rec=iw) obsabv(it)
      iw=iw+1
        write(51,rec=iw) obsblw(it)
      enddo
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

      subroutine ab_count(mask,mw1,coslat,ta,tb,m,n)
      dimension mask(m,n),mw1(m,n),coslat(n)

      ta=0.
      tb=0.
      tot=0.
      do i=1,m
      do j=1,n
      IF(mask(i,j).eq.1) then
      tot=tot+coslat(j)
      if (mw1(i,j).ne.9) then
        if (mw1(i,j).eq.1) ta=ta+coslat(j)
        if (mw1(i,j).eq.-1) tb=tb+coslat(j)
      else
        ta=ta+coslat(j)/3.
        tb=tb+coslat(j)/3.
      end if
      END IF
      enddo
      enddo
c     ta=100.*ta/tot
c     tb=100.*ta/tot
      tab=ta+tb
c     if(tab.gt.232) write(6,*) 'tab=',tab,' tot=',tot
      write(6,*) 'tab=',tab,' tot=',tot
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

