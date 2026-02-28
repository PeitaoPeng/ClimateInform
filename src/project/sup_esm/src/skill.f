      program skill
C===========================================================
      PARAMETER (mdvs=102,nyr=25,nmodel=4)
      real wk1(mdvs),wk2(mdvs)
      real wk3(mdvs),wk4(mdvs)
      real wk5(mdvs)
      real totdata(mdvs,nyr,nmodel+1)
      real wk3d(mdvs,nyr)
      real obs3d(mdvs,nyr)
      real cca3d(mdvs,nyr),cfs3d(mdvs,nyr)
      real smlr3d(mdvs,nyr),ocn3d(mdvs,nyr)
      real accm(nmodel)
 
      open(unit=10,form='formatted')
      open(unit=20,form='formatted')
      open(unit=30,form='formatted')
      open(unit=40,form='formatted')
      open(unit=50,form='formatted')

C=== read in obs and model data
      DO iy=1,nyr
        read(10,444) wk1  !obs
        read(20,444) wk2  !cca
        read(30,444) wk3  !CFS
        read(40,444) wk4  !smlr
        read(50,444) wk5  !eocn
        do i=1,mdvs
          obs3d(i,iy)=wk1(i)
          cca3d(i,iy)=wk2(i)
          cfs3d(i,iy)=wk3(i)
          smlr3d(i,iy)=wk4(i)
          ocn3d(i,iy)=wk5(i)
        end do
      ENDDO
 444  format(10f6.1)
c
      call timeanom(obs3d,mdvs,nyr)
      call timeanom(cca3d,mdvs,nyr)
      call timeanom(cfs3d,mdvs,nyr)
      call timeanom(smlr3d,mdvs,nyr)
      call timeanom(ocn3d,mdvs,nyr)
C=== have spatial ACC
      itime=0
  222 continue
      itime=itime+1
c
      cca=0.
      cfs=0.
      smlr=0.
      ocn=0.
      DO it=1,nyr
        do id=1,mdvs
          wk1(id)=obs3d(id,it)
          wk2(id)=cca3d(id,it)
          wk3(id)=cfs3d(id,it)
          wk4(id)=smlr3d(id,it)
          wk5(id)=ocn3d(id,it)
        enddo
      call acc(wk1,wk2,mdvs,ccaacc)
      call acc(wk1,wk3,mdvs,cfsacc)
      call acc(wk1,wk4,mdvs,smlracc)
      call acc(wk1,wk5,mdvs,ocnacc)
      cca=cca+ccaacc/25.
      cfs=cfs+cfsacc/25.
      smlr=smlr+smlracc/25.
      ocn=ocn+ocnacc/25.
      iiy=1982+it-1
      write(6,777)iiy,ccaacc,cfsacc,smlracc,ocnacc
      ENDDO
      write(6,*) 'avg acc',cca,cfs,smlr,ocn
C=== have s&t avg AC and RMS
      call acc_in_st(obs3d,cca3d,accm(1),mdvs,nyr)
      call acc_in_st(obs3d,cfs3d,accm(2),mdvs,nyr)
      call acc_in_st(obs3d,smlr3d,accm(3),mdvs,nyr)
      call acc_in_st(obs3d,ocn3d,accm(4),mdvs,nyr)
c
      write(6,888)'ST MEAN ACC=',accm(1),accm(2),accm(3),accm(4)

555   format(A10,3(2x,A5,f7.2))
888   format(A10,20x,4f7.2)
777   format(I5,2x,4f7.2)
788   format(A5,7x,3A7,6x,5A6)
766   format(A13,5f7.2)
666   format(1x,A50)
999   format(2x,I2,2x,6(f7.2,2x))
988   format(10f6.2)

C
CC== acc in time domain
c
      write(6,*)
      write(6,*) 'Temporal AC SKILL'
      call acc_in_t(cca3d,obs3d,wk1,mdvs,nyr)
      write(6,*) 'CCA'
      write(6,988) wk1
      call acc_in_t(cfs3d,obs3d,wk1,mdvs,nyr)
      write(6,*) 'CFS'
      write(6,988) wk1
      call acc_in_t(smlr3d,obs3d,wk1,mdvs,nyr)
      write(6,*) 'SMLR'
      write(6,988) wk1
      call acc_in_t(ocn3d,obs3d,wk1,mdvs,nyr)
      write(6,*) 'OCN'
      write(6,988) wk1
c
      call norm_data(obs3d,mdvs,nyr)
      call norm_data(cca3d,mdvs,nyr)
      call norm_data(cfs3d,mdvs,nyr)
      call norm_data(smlr3d,mdvs,nyr)
      call norm_data(ocn3d,mdvs,nyr)
      write(6,*) 'below is for normalized data'
      if (itime.eq.1) go to 222

      stop
      END


      SUBROUTINE timespaceanom(fld,lon,ltime,clim)
      dimension fld(lon,ltime)
      clim=0.
      do  k=1,ltime
      do  i=1,lon
        clim=clim+fld(i,k)
      end do
      end do
 
      clim=clim/(lon*ltime)

      do  k=1,ltime
      do  i=1,lon
        fld(i,k)=fld(i,k)-clim
      end do
      end do
      return
      end

      SUBROUTINE norm_data(wk3d,mdvs,ltime)
      dimension wk3d(mdvs,ltime)

      do id=1,mdvs
        clim=0.
        do it=1,ltime
        clim=clim+wk3d(id,it)/float(ltime)
        end do

        do it=1,ltime
        wk3d(id,it)=wk3d(id,it)-clim
        end do

        std=0.
        do it=1,ltime
        std=std+wk3d(id,it)*wk3d(id,it)/float(ltime)
        end do
        std=sqrt(std)

        do it=1,ltime
        wk3d(id,it)=wk3d(id,it)/std
        end do
      enddo
c
      return
      end


      SUBROUTINE acc_in_t(fld1,fld2,corr,mdvs,ltime)
      real fld1(mdvs,ltime),fld2(mdvs,ltime)
      real corr(mdvs)
c
      call setzero(corr,mdvs)
c
      do i=1,mdvs
         sd1=0.
         sd2=0.
      do it=1,ltime
         sd1=sd1+fld1(i,it)*fld1(i,it)/float(ltime)
         sd2=sd2+fld2(i,it)*fld2(i,it)/float(ltime)
         corr(i)=corr(i)+fld1(i,it)*fld2(i,it)/float(ltime)
      enddo
         corr(i)=corr(i)/(sqrt(sd1*sd2))
      enddo

      return
      end

      SUBROUTINE rms_in_t(fld1,fld2,rms,mdvs,ltime)
      real fld1(mdvs,ltime),fld2(mdvs,ltime)
      real rms(mdvs)
c
      call setzero(rms,mdvs)
c
      do 100 it=1,ltime
        do i=1,mdvs
          rr=fld1(i,it)-fld2(i,it)
          rms(i)=rms(i)+rr*rr/float(ltime)
        enddo
 100  continue

        do i=1,mdvs
         rms(i)=rms(i)**0.5
        enddo

      return
      end


      SUBROUTINE acc_in_st(fld1,fld2,corr,mdvs,ltime)
      real fld1(mdvs,ltime),fld2(mdvs,ltime)
c
      acc=0.
      std1=0.
      std2=0.
      do it=1,ltime
      do i=1,mdvs
          std1=std1+fld1(i,it)*fld1(i,it)/float(ltime*mdvs)
          std2=std2+fld2(i,it)*fld2(i,it)/float(ltime*mdvs)
          corr=corr+fld1(i,it)*fld2(i,it)/float(ltime*mdvs)
      enddo
      enddo

         std1=std1**0.5
         std2=std2**0.5
         corr=corr/(std1*std2)
      return
      end

      SUBROUTINE rms_in_st(fld1,fld2,rms,mdvs,ltime)
      real fld1(mdvs,ltime),fld2(mdvs,ltime)
c
      rms=0.
      do it=1,ltime
      do i=1,mdvs
      rm=(fld1(i,it)-fld2(i,it))
      rms=rms+rm*rm/float(ltime*mdvs)
      enddo
      enddo
      rms=sqrt(rms)
      return
      end


      SUBROUTINE setzero(fld,n)
      DIMENSION fld(n)
      do i=1,n
         fld(i)=0.0
      enddo
      return
      end

      SUBROUTINE setzero_2d_dd(fld,n,m)
      real*8 fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end


      SUBROUTINE setzero_1d(fld,n)
      DIMENSION fld(n)
      do i=1,n
         fld(i)=0.0
      enddo
      return
      end

      SUBROUTINE setzero_1d_dd(fld,n)
      real*8 fld(n)
      do i=1,n
         fld(i)=0.0
      enddo
      return
      end

      SUBROUTINE rmss(fld1,fld2,mdvs,rms)

      real fld1(mdvs),fld2(mdvs)

      rm=0.

      do i=1,mdvs
         df=fld1(i)-fld2(i)
         rm=rm+df*df/float(mdvs)
      enddo

      rms=sqrt(rm)

      return
      end

      SUBROUTINE acc(fld1,fld2,mdvs,cor)

      real fld1(mdvs),fld2(mdvs)

      cor=0.
      sd1=0.
      sd2=0.

      do i=1,mdvs
      cor=cor+fld1(i)*fld2(i)/float(mdvs)
      sd1=sd1+fld1(i)*fld1(i)/float(mdvs)
      sd2=sd2+fld2(i)*fld2(i)/float(mdvs)
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      cor=cor/(sd1*sd2)

      return
      end


      SUBROUTINE timeanom(fld,mdvs,ltime)
      dimension fld(mdvs,ltime)

      do  i=1,mdvs

      clim=0.
      do  k=1,ltime
        clim=clim+fld(i,k)/float(ltime)
      end do

      do  k=1,ltime
        fld(i,k)=fld(i,k)-clim
      end do

      end do
      return
      end


