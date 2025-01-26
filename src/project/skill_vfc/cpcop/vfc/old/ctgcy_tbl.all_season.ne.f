CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  3x3(a,n,b) Contengency Table
C==========================================================
      include "parm.h"
      dimension mask(imx,jmx)
      dimension kprd(imx,jmx,nss),kvfc(imx,jmx,nss)  !nss: # of seasons
      dimension hdk1(nss),hdk2(nss)
      dimension hdk1_t(imx,jmx),hdk2_t(imx,jmx)
      dimension hdk1cyc(12),hdk2cyc(12)
      dimension mwk1(imx,jmx),mwk2(imx,jmx)
      dimension wk1(imx,jmx),wk2(imx,jmx)
      dimension w1d1(nss),w1d2(nss)
      dimension mw1d1(nss),mw1d2(nss)
      dimension xnonec(nss),xnonec2d(imx,jmx)
      dimension xnoneccyc(12)
      dimension xlat(jmx),coslat(jmx)
      dimension fld1d1(232),fld1d2(232)
      real na,nn,nb
      real na_t,nn_t,nb_t
c
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx) !mask
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx) !fcst
      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx) 
      open(unit=51,form='formatted')
c
cc have coslat
      dl=2.
      do j=1,jmx
        xlat(j)=dl*(j-1)+20.
        coslat(j)=COS(3.14159*xlat(j)/180)
c       coslat(j)=1.
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
cc and have contengency table for A. N, and B
c
      aa_t=0
      an_t=0
      ab_t=0
      na_t=0
      nn_t=0
      nb_t=0
      ba_t=0
      bn_t=0
      bb_t=0

      anmb_t=0.

      DO it=1,nss

        do i=1,imx
        do j=1,jmx
          mwk1(i,j)=kprd(i,j,it)
          mwk2(i,j)=kvfc(i,j,it)
        enddo
        enddo
      call count_2D(mask,mwk1,mwk2,coslat,
     &aa,an,ab,na,nn,nb,ba,bn,bb,imx,jmx,anmb)
      aa_t=aa_t+aa
      an_t=an_t+an
      ab_t=ab_t+ab
      na_t=na_t+na
      nn_t=nn_t+nn
      nb_t=nb_t+nb
      ba_t=ba_t+ba
      bn_t=bn_t+bn
      bb_t=bb_t+bb

      anmb_t=anmb_t+anmb

      ENDDO

      tot=aa_t+an_t+ab_t+na_t+nn_t+nb_t+ba_t+bn_t+bb_t

      aa_t=100*aa_t/tot
      an_t=100*an_t/tot
      ab_t=100*ab_t/tot
      na_t=100*na_t/tot
      nn_t=100*nn_t/tot
      nb_t=100*nb_t/tot
      ba_t=100*ba_t/tot
      bn_t=100*bn_t/tot
      bb_t=100*bb_t/tot
c
      write(61,888)aa_t,an_t,ab_t
      write(61,888)na_t,nn_t,nb_t
      write(61,888)ba_t,bn_t,bb_t

      write(61,*) 'anmb_tot=',anmb_t
      write(61,*) 'tot=',tot

 888  format(3f10.1)
     
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

      subroutine count_2D(mask,mw1,mw2,coslat,
     &aa,an,ab,na,nn,nb,ba,bn,bb,m,n,anmb) 
      dimension mask(m,n),mw1(m,n),mw2(m,n),coslat(n)
      real na,nn,nb
c    
      aa=0. 
      an=0. 
      ab=0. 
      na=0. 
      nn=0. 
      nb=0. 
      ba=0. 
      bn=0. 
      bb=0. 
      ic1=1
      ic2=0
      ic3=-1
c
      anmb=0.
      do i=1,m
      do j=1,n
c     do i=1,14
c     do j=1,12

      IF(mask(i,j).eq.1) then

      if(mw1(i,j).eq.ic2) anmb=anmb+coslat(j)

      if(mw1(i,j).ne.9) then

      if(mw1(i,j).eq.ic1.and.mw2(i,j).eq.ic1) aa=aa+coslat(j)
      if(mw1(i,j).eq.ic1.and.mw2(i,j).eq.ic2) an=an+coslat(j)
      if(mw1(i,j).eq.ic1.and.mw2(i,j).eq.ic3) ab=ab+coslat(j)

      if(mw1(i,j).eq.ic2.and.mw2(i,j).eq.ic1) na=na+coslat(j)
      if(mw1(i,j).eq.ic2.and.mw2(i,j).eq.ic2) nn=nn+coslat(j)
      if(mw1(i,j).eq.ic2.and.mw2(i,j).eq.ic3) nb=nb+coslat(j)

      if(mw1(i,j).eq.ic3.and.mw2(i,j).eq.ic1) ba=ba+coslat(j)
      if(mw1(i,j).eq.ic3.and.mw2(i,j).eq.ic2) bn=bn+coslat(j)
      if(mw1(i,j).eq.ic3.and.mw2(i,j).eq.ic3) bb=bb+coslat(j)

      else
c     if(mw2(i,j).eq.ic1) aa=aa+coslat(j)/3.
c     if(mw2(i,j).eq.ic2) an=an+coslat(j)/3.
c     if(mw2(i,j).eq.ic3) ab=ab+coslat(j)/3.
c     if(mw2(i,j).eq.ic1) na=na+coslat(j)/3.
c     if(mw2(i,j).eq.ic2) nn=nn+coslat(j)/3.
c     if(mw2(i,j).eq.ic3) nb=nb+coslat(j)/3.
c     if(mw2(i,j).eq.ic1) ba=ba+coslat(j)/3.
c     if(mw2(i,j).eq.ic2) bn=bn+coslat(j)/3.
c     if(mw2(i,j).eq.ic3) bb=bb+coslat(j)/3.

      end if

      END IF
      enddo 
      enddo 
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
