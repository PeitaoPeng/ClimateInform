CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  Lagged Heidk skill
C==========================================================
      include "parm.h"
      parameter(maxlag=6)
      dimension mask(imx,jmx)
      dimension kprd(imx,jmx,nss),kvfc(imx,jmx,nss)  !nss: # of seasons
      dimension hdk1(nss),hdk2(nss)
      dimension corlag(nss)
      dimension hdk1_t(imx,jmx),hdk2_t(imx,jmx)
      dimension hdk1cyc(12),hdk2cyc(12)
      dimension mwk1(imx,jmx),mwk2(imx,jmx)
      dimension mwk3(imx,jmx),mwk4(imx,jmx)
      dimension wk1(imx,jmx),wk2(imx,jmx)
      dimension w1d1(nss),w1d2(nss)
      dimension mw1d1(nss),mw1d2(nss)
      dimension xnonec(nss),xnonec2d(imx,jmx)
      dimension xnoneccyc(12)
      dimension xlat(jmx),coslat(jmx)
      dimension fld1d1(232),fld1d2(232)
      dimension avghs1(maxlag+1),avghs2(maxlag+1)
      dimension avghs3(maxlag+1),avghs4(maxlag+1)
      dimension avghs5(maxlag+1),avghs6(maxlag+1)
      dimension avghs7(maxlag+1),avghs8(maxlag+1)
c
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx) !mask
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx) !fcst
      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx) 
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
cc and calculate lagged HEIDKE skill time series
      do jt=0,maxlag
        lt=nss-jt
        avghs1(jt+1)=0.
        avghs2(jt+1)=0.
        avghs3(jt+1)=0.
        avghs4(jt+1)=0.
        avghs5(jt+1)=0.
        avghs6(jt+1)=0.
        avghs7(jt+1)=0.
        avghs8(jt+1)=0.
       do it=1,lt 
        do i=1,imx
        do j=1,jmx
          mwk1(i,j)=kprd(i,j,it)
          mwk2(i,j)=kvfc(i,j,it)
          mwk3(i,j)=kvfc(i,j,it+jt)
          mwk4(i,j)=kprd(i,j,it+jt)
        enddo
        enddo
        call heidke1(mask,mwk1,mwk2,coslat,hs1,ntot1,imx,jmx)
        call heidke2(mask,mwk1,mwk2,coslat,hs2,ntot2,imx,jmx)
        call heidke1(mask,mwk1,mwk3,coslat,hs3,ntot1,imx,jmx)
        call heidke2(mask,mwk1,mwk3,coslat,hs4,ntot2,imx,jmx)
        call heidke1(mask,mwk2,mwk3,coslat,hs5,ntot1,imx,jmx)
        call heidke2(mask,mwk2,mwk3,coslat,hs6,ntot2,imx,jmx)
        call heidke1(mask,mwk1,mwk4,coslat,hs7,ntot1,imx,jmx)
        call heidke2(mask,mwk1,mwk4,coslat,hs8,ntot2,imx,jmx)
c       write(6,*) 'hs5=',hs5,'  hs6=',hs6
          avghs1(jt+1)=avghs1(jt+1)+hs1/float(lt)  
          avghs2(jt+1)=avghs2(jt+1)+hs2/float(lt)
          avghs3(jt+1)=avghs3(jt+1)+hs3/float(lt)  
          avghs4(jt+1)=avghs4(jt+1)+hs4/float(lt)
          avghs5(jt+1)=avghs5(jt+1)+hs5/float(lt) 
          avghs6(jt+1)=avghs6(jt+1)+hs6/float(lt)
          avghs7(jt+1)=avghs7(jt+1)+hs7/float(lt) 
          avghs8(jt+1)=avghs8(jt+1)+hs8/float(lt)
       enddo
      enddo
c
 888  format(10f7.2)
 999  format(I3,3x,2f9.2,2I5,f7.2)
 777  format(A7,1x,21f7.2)
     
      iw=0
      do it=1,maxlag+1
      iw=iw+1
      write(51,rec=iw) avghs1(it)
      iw=iw+1
      write(51,rec=iw) avghs2(it)
      iw=iw+1
      write(51,rec=iw) avghs3(it)
      iw=iw+1
      write(51,rec=iw) avghs4(it)
      iw=iw+1
      write(51,rec=iw) avghs5(it)
      iw=iw+1
      write(51,rec=iw) avghs6(it)
      iw=iw+1
      write(51,rec=iw) avghs7(it)
      iw=iw+1
      write(51,rec=iw) avghs8(it)
      enddo
      write(6,777) 'avghs5=',avghs5
      write(6,777) 'avghs6=',avghs6
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

