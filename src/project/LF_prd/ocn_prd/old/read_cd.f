      program read_data
      include "parm.h"
      dimension it(nyear,14),tt(344,nyear,14),rit(nyear,14)
      dimension tt102(102,nyear,14),tt102ub(102,nyear,14)
      dimension out(102)
      dimension t(344),t3(102)
      dimension ireg(344),frak(344)
c* follows the operational CD data set, up to date with dirty CD
C* units degree C for T and mm for P. and for w
      open(unit=11,file='/export/lnx225/wd53du/cddata/cdldict.dat')
      open(unit=61,
     *file='/export/lnx225/wd53du/cddata/t.long',status='old')
      open(unit=62,
     *file='/export/lnx225/wd53du/cddata/p.long',status='old')
      open(unit=63,
     *file='/export/lnx225/wd53du/cddata/w30.long',status='old')
      open(unit=80,
     *file='/export-12/cacsrv1/wd52pp/LF_prd/temp_102.txt')
c*************************************************
      read(11,204) x
204   format(a4)
      do icd=1,344
      read(11,205)ireg(icd),frak(icd)
      enddo
205   format(36x,i6,f7.3)
c*************************************************
      jb=41!climo period jb,je =31,60 means base=1961-90 
      je=jb+29
      nyr=je-jb+1
      write(6,876)jb,je,nyr,jb+1930,je+1930
876   format(1h ,5i5)
c* set initial month just ending (2 =jan)
c     call loaddata(tt102,tt102ub,it,tt,rit,frak,ireg,jb,je,63,0,nyear)!phys units - soil moisture
      call loaddata(tt102,tt102ub,it,tt,rit,frak,ireg,jb,je,61,0,nyear)!phys units - temperature
c     call loaddata(tt102,tt102ub,it,tt,rit,frak,ireg,jb,je,62,0,nyear)!phys units - precip
c     call loaddata(tt102,tt102ub,it,tt,rit,frak,ireg,jb,je,64,0,nyear)!phys units - evap
c     call loaddata(tt102,tt102ub,it,tt,rit,frak,ireg,jb,je,65,0,nyear)!phys units
c     call loaddata(tt102,tt102ub,it,tt,rit,frak,ireg,jb,je,66,0,nyear)!phys units
c     do j=1,72
      do j=1,nyear
      do k=2,13 !jan to dec
      do i=1,102
        out(i)=tt102(i,j,k)
      enddo
      write(80,888) out
      enddo
      enddo
888   format(10f7.1)
       stop
       end

      subroutine norm(tt,nicd,nyear,nmo,icd,m,jb,je,anorm,sd)
      dimension tt(nicd,nyear,nmo)
      x=0.
      y=0.
      n=0
      do 10 j=jb,je
      n=n+1
      x=x+tt(icd,j,m)
      y=y+tt(icd,j,m)*tt(icd,j,m)
10    continue
      zn=float(n)
      anorm=x/zn
      sd=sqrt(y/zn-anorm**2)
c     write(6,100)zn,anorm,sd,nicd,icd,m,nyr
100   format(1h ,3f7.2,4i5)
      return
      end
c*
      subroutine bias(tt,ttub,m,jb,je,nyear)
C*differs from biassd only in that it returns physical units for anomalies.
      dimension tt(102,nyear,14)
      dimension ttub(102,nyear,14)
      do 5 icd=1,102
      call norm(tt,102,nyear,14,icd,m,jb,je,an,sd)
c     write(6,100)an,sd,icd,m,nyr
      do 4 i=1,nyear
      ttub(icd,i,m)=(tt(icd,i,m)-an)
4     continue
5     continue
100   format(1h ,2f7.2,3i5)
      return
      end
c*
      subroutine biassd(tt,ttub,m,jb,je,nyear)
      dimension tt(102,nyear,14)
      dimension ttub(102,nyear,14)
      do 5 icd=1,102
      call norm(tt,102,nyear,14,icd,m,jb,je,an,sd)
c     write(6,100)an,sd,icd,m,nyr
      do 4 i=1,nyear
      ttub(icd,i,m)=(tt(icd,i,m)-an)/sd
4     continue
5     continue
100   format(1h ,2f7.2,3i5)
      return
      end
c*
      subroutine mosea(it,rit,nyear)
      dimension it(nyear,14),rit(nyear,14)
      do 10 j=2,nyear-1
      do 9 m=2,13
      mp=m+1
      mm=m-1
      jp=j
      jm=j
      if (m.eq.2)mm=13
      if (m.eq.2)jm=j-1
      if (m.eq.13)mp=2
      if (m.eq.13)jp=j+1
      rit(j,m)=(float(it(jm,mm))+float(it(j,m))+float(it(jp,mp)))/3.
9     continue
10    continue
      return
      end
c*
      subroutine readit(it,ich,itt,icd,nyear)
      dimension it(nyear,14),rit(nyear,12)
      do j=1,nyear
      do m=1,14
      it(j,m)=-9999
      enddo
      enddo
      read(ich,100)rit
      do j=1,nyear
      do m=1,12
      x=rit(j,m)
      if (itt.eq.1)x=rit(j,m)*9./5.+32.
      it(j,m+1)=ifix(x*10.)
c     it(j,m+1)=nint(rit(j,m)*10.)
      enddo
      it(j,1)=100.*icd+j+30
      enddo
c     write(6,101)(rit(67,m),m=1,12)
c     write(6,102)(it(67,m),m=2,13)
100   format(10f8.3)
101   format(1h ,12f8.1)
102   format(1h ,12i8)
      return
      end
c*
      SUBROUTINE prep102(T,t3,frak,ireg)
c* transforms 344 temperatures into 102 values, given frak and ireg
      DIMENSION T(344),t3(102),frak(344),ireg(344)
c     t3=0.
      do i=1,102
      t3(i)=0.
      enddo
c
      do icd=1,344
      kreg=ireg(icd)
      t3(kreg)=t3(kreg)+t(icd)*frak(icd)
      enddo
      RETURN
      END
c*
      subroutine loaddata(tt102,tt102ub,it,tt,rit,frak,ireg,jb,je,
     *ich,isd,nyear)
      dimension tt102(102,nyear,14),tt102ub(102,nyear,14)
      dimension ireg(344),frak(344)
      dimension it(nyear,14),tt(344,nyear,14),rit(nyear,14)
      dimension t(344),t3(102)
c*    read w30 (61) tt (62) pp (63) and ee(64) clim.div data
c*    below i=1 denotes 1931, i=25 1955, i=60 1990  62 1992
c*    below ii=1 denotes 1955, ii=38 denotes 1992
c     tt=0.
      do ic=1,344
      do iy=1,nyear
      do im=1,14
        tt(ic,iy,im)=0.
      enddo
      enddo
      enddo
c     tt102=0.
c     tt102ub=0.
      do ic=1,102
      do iy=1,nyear
      do im=1,14
        tt102(ic,iy,im)=0.
        tt102ub(ic,iy,im)=0.
      enddo
      enddo
      enddo
c
      itt=0
      if (ich.eq.61)itt=1
      do 10 icd=1,344
      call readit(it,ich,itt,icd,nyear)
C* 'mosea': for seasonal averages call twice:
c     call mosea(it,rit)
C* 'mosea': for monthly averages: don't call the 2 moseas before
      do 9 i=1,nyear
      ii=i-24
      if (ii.eq.42.and.icd.eq.100) write(6,172)
172   format(1h ,'check availablity of clim.div data')
      if (icd.eq.100) write(6,102)(it(i,j),j=1,14)
      do 8 j=2,14
c* 'mosea'
c* next three lines only for monthly data! Commentout for seasonal
      rit(i,j)=float(it(i,j))
c* 'mosea'
      if (ich.eq.61)tt(icd,i,j)=(rit(i,j)/10.-32.)*5./9.
      if (ich.ne.61)tt(icd,i,j)=rit(i,j)/10.
8     continue
      tt(icd,i,1)=float(it(i,1))
9     continue
10    continue
      do 12 icd=90,100
c     write(6,100)(tt(icd,1,j),j=1,14)
c     write(6,100)(tt(icd,40,j),j=1,14)
c     write(6,100)(tt(icd,63,j),j=1,14)
c     write(6,100)(tt(icd,68,j),j=1,14)
c     write(6,100)(tt(icd,69,j),j=1,14)
12    continue
c*****************************
      do m=2,13
      do j=1,nyear
      do icd=1,344
      t(icd)=tt(icd,j,m)
      enddo
      call prep102(T,t3,frak,ireg)
      do icd=1,102
      tt102(icd,j,m)=t3(icd)
      enddo
      enddo
      enddo
c*****************************
c     jb=31!1961-1990 base
c     jb=21!1951-1980 base
c     je=jb+29
      nyr=je-jb+1
      write(6,876)jb,je,nyr,jb+1930,je+1930
876   format(1h ,5i5)
      do 11 m=2,13
      if (isd.eq.1)call biassd(tt102,tt102ub,m,jb,je,nyear)! sd units
      if (isd.eq.0)call bias(tt102,tt102ub,m,jb,je,nyear)! units in mm
11    continue
      do icd=1,102
      do i=1,nyear-1
      ii=i+1
      tt102ub(icd,i,14)=tt102ub(icd,ii,2)
      enddo
      enddo
      do icd=1,102
      do i=2,nyear
      ii=i-1
      tt102ub(icd,i,1)=tt102ub(icd,ii,13)
      enddo
      enddo
      do 13 icd=90,100
c     write(6,100)(tt102ub(icd,1,j),j=1,14)
c     write(6,100)(tt102ub(icd,40,j),j=1,14)
c     write(6,100)(tt102ub(icd,63,j),j=1,14)
c     write(6,100)(tt102ub(icd,68,j),j=1,14)
c     write(6,100)(tt102ub(icd,69,j),j=1,14)
13    continue
100   format(1h ,f7.0,13f5.1)
102   format(1h ,14i8)
      return
      end
