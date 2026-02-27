c------------------------------------------------------------
c Must rlogin hp23 to use IMSL
c :to compile IMSL routines: >source /opt/vni/CTT3.0/ctt/bin/cttsetup.csh
c :to compile Fortran programs with IMSL : $F90 $F90FLAGS $LINK_F90 filename
c Covariance matrix
c mode=min(npt,nmon)
c Varimax method
c NMO =  # of loading factors
c------------------------------------------------------------
        PARAMETER(NLON=144,NLAT=36,NMON=612,nlat2=37)
        PARAMETER(NMO=10,NPT=NLON*NLAT)
        parameter(mode=nmon)
        parameter(norm=1,w=1.0)
        real ef1(npt,nmon),eva(nmon),pva(nmon)
        real ets(nmon,nmo),evec(nlon,nlat)
        real alat(nlat),hyun(nmon),cofac(nlat)
        real slpm(npt),an(nmon)
        real rf1(npt,nmo),revec(nlon,nlat),reva(nmo),
     &       rpc(nmon,nmo),t(nmo,nmo)

        real cov(nmon,nmon),pct(nmon),std(nmon),
     &       a(nmon,nmon),ets2(nmon,mode),ef2(npt,nmo)


        DIMENSION SLP(NLON,NLAT),SLP2(NPT,NMON)

C Input data
        OPEN(10,file=
     $  '/export-6/sgi85/wd52wh/hkkim/data/monthly.500za.'//
     &  'clim79-00.NH.b50.e00',
     $  access='direct',form='unformatted',
     $  recl=nlon*nlat2*4)
C Eigen vectors: Unrotated and rotated
        OPEN(11,file=
     $ 'reof.test',
     $  access='direct',form='unformatted',
     $  recl=nlon*nlat*4)
C Principal components (time series): Unrotated and rotated
        OPEN(12,file=
     $ 'rcoef.test',
     $  access='direct',form='unformatted',
     $  recl=nmo*4)
C Eigen values
        OPEN(21,file=
     $ 'ev.test',
     $  access='direct',form='unformatted',
     $  recl=nmon*4)
C Eigen values(%): Unrotated and rotated
        OPEN(14,file=
     $ 'ev.test.dat')
C Need for projection 
        open(15,file=
     & 'index.test',
     & form='unformatted')

c--------------------------------------------------------
c Area weighting with sqrt(cos(lat))
c-------
        pi=atan(1.)*4.
        write(*,*)'pi=',pi
        do j=1,nlat
        alat(j)=0.+float(j-1)*2.5
        enddo

        do j=1,nlat
        cofac(j)=sqrt(cos(alat(j)*pi/180.))
        enddo

        write(*,*)'cos=',(cos(alat(j)*pi/180.),j=1,nlat)
c-------
        do ij=1,npt 
        slpm(ij)=0.
        enddo
c-------
        icount=0
        do iy=1950,2000
        do im=1,12
        read(10) slp
c       if(im.eq.1.or.im.eq.2.or.im.eq.3) then  ! JFM only
        icount=icount+1

        k=0
         do j=1,nlat
         do i=1,nlon
         k=k+1
          slp2(k,icount)=slp(i,j)*cofac(j)
         end do
         end do

         do ij=1,npt
         slpm(ij)=slpm(ij)+slp2(ij,icount)/float(nmon)
         enddo

c       endif
        end do
        end do
         print*,'icount=',icount

c--------
c subtract time avg.
c--------
        do it=1,nmon
        do ij=1,npt
        slp2(ij,it)=slp2(ij,it)-slpm(ij)  ! with cos factor
        enddo
        enddo
c--------
c Calculate covariance matrix
c-----
      do i=1,nmon
      do j=1,nmon
      cov(i,j)=0.
      enddo
      enddo

      do k=1,npt
       do i=1,nmon
       do j=1,nmon
        cov(i,j)=cov(i,j)+slp2(k,i)*slp2(k,j)/float(npt)
       enddo
       enddo
      enddo
c------
      print*,'before princ'
      ndf=npt-nmon
      call princ(ndf,mode,cov,mode,0,eva,pct,std,ets2,mode,a,mode)
      print*,'after princ'
      print*,'pct=',(pct(i),i=1,mode)
c---
c Variance of each mode by % : pva(mode)
c---
      trace=0.
      do k=1,mode
      trace=trace+eva(k)
      enddo
      do k=1,mode
      pva(k)=eva(k)/trace*100.
      enddo
      print*,'pva=',(pva(i),i=1,mode)
cc    write(21) pva   ! explained variance by %
      write(21) eva   ! eigen values
c----
c Calculate loading patterns : ef1=slp2*ets2
c---
      do k=1,mode  

       do ij=1,npt
       ef1(ij,k)=0.
       enddo

       do i=1,nmon
       do ij=1,npt
        ef1(ij,k)=ef1(ij,k)+slp2(ij,i)*ets2(i,k)
       enddo
       enddo

      enddo
      print*,'after ef1'
      print*,'ef1',(ef1(ij,1),ij=1,20)
c- normalize ef1
      do m=1,mode
      sum=0.
       do i=1,npt
      sum=sum+ef1(i,m)*ef1(i,m)
       enddo
      cnorm=sqrt(sum)
       do i=1,npt
      ef1(i,m)=ef1(i,m)/cnorm
       enddo
      enddo
      print*,'after normalize ef1'
      print*,'ef1',(ef1(ij,1),ij=1,20)
c---
c recalculate principal component
c---
      do m=1,nmo   ! only nmo 
       do it=1,nmon
      ets(it,m)=0.
       do i=1,npt
      ets(it,m)=ets(it,m)+ef1(i,m)*slp2(i,it)
       enddo
       enddo
      enddo
      print*,'after ets'
c---
c-test
c     test=0.
c     test2=0.
c     do kim=1,npt
c     test=test+ef1(kim,1)*ef1(kim,1)
c     test2=test2+ef1(kim,1)*ef1(kim,3)
c     enddo
c     test=sqrt(test)
c     print*, 'test of orthogonality, test=', test
c     print*, 'test of orthogonality, test2=', test2

c     test3=0.
c     test4=0.
c     do kim=1,nmon
c     test3=test3+ets(kim,1)*ets(kim,1)
c     test4=test4+ets(kim,1)*ets(kim,3)
c     enddo
c     test3=sqrt(test3)
c     print*, 'test of orthogonality, test3=', test3
c     print*, 'test of orthogonality, test4=', test4
c-----

c---------------------------------------------------------------
c  Start rotation    
c--------------------------------
      print*, 'start rotation'
      do k=1,nmo
      do ij=1,npt      
      ef2(ij,k)=ef1(ij,k)*sqrt(eva(k))
      enddo
      enddo
 
      call frota(npt,nmo,ef2,npt,norm,30,w,0.0001,rf1,npt,t,nmo)
      print*,'after frota'
c
c Calculate variance (%) : diagonal values of REVEC*REVEC
      do k=1,nmo
      reva(k)=0.
      do ij=1,npt 
      reva(k)=reva(k)+rf1(ij,k)**2.
      enddo
      reva(k)=reva(k)/trace*100.
      enddo
c------------------
c
c Rotate PC
      do i=1,nmo
      do j=1,nmon
      total=0.
       do k=1,nmo
       total=total+t(k,i)*ets(j,k)
       enddo
      rpc(j,i)=total
      enddo
      enddo
c------------------
      write(15) reva,ef1,t

      call order(npt,nmon,nmo,reva,rf1,rpc)
c-----
c WRITE
c-----
c loading pattern

      DO kim=1,nmo

        k=0
        do j=1,nlat
        do i=1,nlon
        k=k+1
        evec(i,j)=ef2(k,kim)
        revec(i,j)=rf1(k,kim)
        end do
        end do

        write(11,rec=2*(kim-1)+1) evec
        write(11,rec=2*(kim-1)+2) revec

      ENDDO
c
c principal component

      DO it=1,nmon
      write(12,rec=2*(it-1)+1) (ets(it,k),k=1,nmo)
      write(12,rec=2*(it-1)+2) (rpc(it,k),k=1,nmo)
      ENDDO
 
c
c eigenvalues

c     write(13,rec=1) (pva(i)*100.,i=1,nmo)
c     write(13,rec=2) (reva(i),i=1,nmo)

      write(14,*) '  k  EVA    REVA'
      do k=1,nmo
      write(14,1000)k,pva(k),reva(k)
      print*,'k=',k,'eva=',pva(k),'reva=',reva(k)
      enddo
1000  format(i5,2f7.2)
c-
      stop
      end


c---------------------------------------------------------------------
c  arange rotated eval,evec and coef in decreasing order
c---------------------------------------------------------------------
      subroutine order(m,n,mod,reval,revec,rcoef)
      dimension reval(mod),revec(m,mod),rcoef(n,mod)
      do 20 i=1,mod-1
      do 20 j=i+1,mod
      if(reval(i).lt.reval(j)) then
      xx=reval(i)
      reval(i)=reval(j)
      reval(j)=xx
      do 30 k=1,m
         xx=revec(k,i)
         revec(k,i)=revec(k,j)
         revec(k,j)=xx
30    continue
      do 40 k=1,n
         xx=rcoef(k,i)
         rcoef(k,i)=rcoef(k,j)
         rcoef(k,j)=xx
40    continue
      endif
20    continue
      return
      end
