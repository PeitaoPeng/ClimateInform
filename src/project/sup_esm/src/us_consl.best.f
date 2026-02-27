      program regression
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. chose the best model in the history for current prd
C. ispd=1: space-dependent; ispd=0: space-independent
C. irms=1: based on rms skill; irms=0:based on acc skill
C===========================================================
      PARAMETER (ncv=3,ispd=1,irsm=0)
      PARAMETER (mdvs=102,nyr=25,nyin=nyr-ncv,nmodel=3,nfcst=nmodel+2)
      real fld1(mdvs),fld2(mdvs)
      real totdata(mdvs,nyr,nmodel+1)
      real bidx(mdvs,nmodel)
      real wk3d(mdvs,nyr)
      real obs3d(mdvs,nyin)
      real cca3d(mdvs,nyin),cfs3d(mdvs,nyin)
      real smlr3d(mdvs,nyin),eca3d(mdvs,nyin)
      real cps3d(mdvs,nyin)
      real obs2d(mdvs)
      real cca2d(mdvs),cfs2d(mdvs)
      real smlr2d(mdvs),eca2d(mdvs)
      real cps2d(mdvs)
      real obs(nyin,mdvs),gcm(nmodel,nyin,mdvs),beta(nmodel)
      real wk1(mdvs),wk2(mdvs)
      real wk3(mdvs),wk4(mdvs)
      real wk5(mdvs),wk6(mdvs)
      real accus(nyr,nfcst)
      real rmsus(nyr,nfcst)
      real accm(nfcst)
      real rmsm(nfcst)
      real clim1(mdvs),clim2(mdvs)
      real clim3(mdvs),clim4(mdvs)
      real clim5(mdvs)
      real betaout(nyr,nmodel)
      real mlrprd(mdvs,nyr),ewmprd(mdvs,nyr)
      real ccaprd(mdvs,nyr),cfsprd(mdvs,nyr)
      real smlprd(mdvs,nyr)
      real verify(mdvs,nyr)
c
      open(unit=10,form='formatted')
      open(unit=20,form='formatted')
      open(unit=30,form='formatted')
      open(unit=40,form='formatted')
      open(unit=50,form='unformatted',access='direct',recl=4*mdvs)
      open(unit=60,form='formatted')
      open(unit=70,form='formatted')
c     open(unit=60,form='unformatted',access='direct',recl=4*mdvs)

      mean=0  ! mean=1: acc take off area mean; 
              ! =0: not take off area mean
      ianom=1 ! =1: remove time; =0: not remove time mean
 
      icca=1  ! =0 means not include it
      icfs=1  ! =0 means not include it
      ismlr=1 ! =0 means not include it

      write(6,*) 'ispd=',ispd
      write(6,*) 'irms=',irms
      write(6,*) 'ncv=',ncv
C=== read in obs and model data
      DO iy=1,nyr
        read(10,444) wk1  !obs
        read(20,444) wk2  !cca
        read(30,444) wk3  !CFS
        read(40,444) wk4  !smlr
        do i=1,mdvs
          totdata(i,iy,1)=wk1(i)
          totdata(i,iy,2)=wk2(i)
          totdata(i,iy,3)=wk3(i)
          totdata(i,iy,4)=wk4(i)
        end do
      ENDDO
 444  format(10f6.1)
C
C== normalize data
      do im=1,nmodel+1
        do id=1,mdvs
        do iy=1,nyr
          wk3d(id,iy)=totdata(id,iy,im)
        enddo
        enddo
c
        call norm_data(wk3d,mdvs,nyr)
c
        do id=1,mdvs
        do iy=1,nyr
          totdata(id,iy,im)=wk3d(id,iy)
        enddo
        enddo
      enddo

C===  verify against each case
      
      write(6,788)'year','CCA','CFS','SML','CON','ENS',
     &'CCA','CFS','SML'
      do 1000 icase=1,nyr

         iy=0
      do 2000 iyear=1,nyr
        if (iyear.eq.icase) then
         do i=1,mdvs
            obs2d(i)=totdata(i,iyear,1)
            cca2d(i)=totdata(i,iyear,2)
            cfs2d(i)=totdata(i,iyear,3)
            smlr2d(i)=totdata(i,iyear,4)
            verify(i,icase)=totdata(i,iyear,1)
         end do
        end if
c
        IF (ncv.eq.0) then  ! that is, not cross validation
         iy=iy+1
         do i=1,mdvs
            obs3d(i,iy)=totdata(i,iyear,1)
            cca3d(i,iy)=totdata(i,iyear,2)
            cfs3d(i,iy)=totdata(i,iyear,3)
            smlr3d(i,iy)=totdata(i,iyear,4)
         end do
        END IF
c
        IF (ncv.eq.1) then  !
          if(iyear.ne.icase) then
          iy=iy+1
          do i=1,mdvs
            obs3d(i,iy)=totdata(i,iyear,1)
            cca3d(i,iy)=totdata(i,iyear,2)
            cfs3d(i,iy)=totdata(i,iyear,3)
            smlr3d(i,iy)=totdata(i,iyear,4)
          end do
          end if
        END IF
c
        IF (ncv.eq.3) then
          icasep=icase+1
          icasem=icase-1
          if(iyear.lt.icasem.or.iyear.gt.icasep) then
          iy=iy+1
          if (iy.gt.nyin) go to 2500
          do i=1,mdvs
            obs3d(i,iy)=totdata(i,iyear,1)
            cca3d(i,iy)=totdata(i,iyear,2)
            cfs3d(i,iy)=totdata(i,iyear,3)
            smlr3d(i,iy)=totdata(i,iyear,4)
          end do
          end if
        END IF

 2000 continue
 2500 continue

C===  remove time mean
      call setzero(clim1,mdvs)
      call setzero(clim2,mdvs)
      call setzero(clim3,mdvs)
      call setzero(clim4,mdvs)
      if(ianom.eq.1) then
      call timeanom(obs3d,mdvs,nyin,clim1)
      call timeanom(cca3d,mdvs,nyin,clim2)
      call timeanom(cfs3d,mdvs,nyin,clim3)
      call timeanom(smlr3d,mdvs,nyin,clim4)
      end if

C===  correct anom for target year data
      do i=1,mdvs
        obs2d(i)=obs2d(i)-clim1(i)
        cca2d(i)=cca2d(i)-clim2(i)
        cfs2d(i)=cfs2d(i)-clim3(i)
        smlr2d(i)=smlr2d(i)-clim4(i)
      end do
c=== historic skills (rms and acc) 
      call acc_in_t(cca3d,obs3d,wk1,mdvs,nyin)
      call acc_in_t(cfs3d,obs3d,wk2,mdvs,nyin)
      call acc_in_t(smlr3d,obs3d,wk3,mdvs,nyin)
      call rms_in_t(cca3d,obs3d,wk4,mdvs,nyin)
      call rms_in_t(cfs3d,obs3d,wk5,mdvs,nyin)
      call rms_in_t(smlr3d,obs3d,wk6,mdvs,nyin)
c=== compare acc skill
      call setzero_2d(bidx,mdvs,nmodel)
      do i=1,mdvs
      if(irms.eq.0) then
        bgst=AMAX1(wk1(i),wk2(i),wk3(i))
        call whichone(bgst,wk1(i),wk2(i),wk3(i),idx)
      else
        smst=AMIN1(wk4(i),wk5(i),wk6(i))
        call whichone(smst,wk4(i),wk5(i),wk6(i),idx)
      end if
        bidx(i,idx)=1.
      end do
c
c     write(6,*) 'year',icase
c     write(6,444) wk1
      do id=1,mdvs
        wk1(id)=bidx(id,1)
      end do
c     write(6,444) wk1
c     write(6,444) wk2
      do id=1,mdvs
        wk1(id)=bidx(id,2)
      end do
c     write(6,444) wk1
c     write(6,444) wk3
      do id=1,mdvs
        wk1(id)=bidx(id,3)
      end do
c     write(6,444) wk1
c
      do ix=1,nmodel
        betaout(icase,ix)=0
        beta(ix)=0
        do id=1,mdvs
          betaout(icase,ix)=betaout(icase,ix)+
     &bidx(id,ix)/float(mdvs)
          beta(ix)=beta(ix)+bidx(id,ix)/float(mdvs)
        enddo
      end do
c
C=== make prediction and verify against obs for case i
C... prediction with best model
      do i=1,mdvs
      if(ispd.eq.0) then
         wk4(i)=beta(1)*cca2d(i)+
     &          beta(2)*cfs2d(i)+
     &          beta(3)*smlr2d(i)
      else
         wk4(i)=bidx(i,1)*cca2d(i)+
     &          bidx(i,2)*cfs2d(i)+
     &          bidx(i,3)*smlr2d(i)
      end if
        mlrprd(i,icase)=wk4(i)
      end do
C... prediction with simple ensemble
      do i=1,mdvs
         wk5(i)=(cca2d(i)+
     &            cfs2d(i)+
     &            smlr2d(i))/float(nmodel)
         ewmprd(i,icase)=wk5(i)
      end do
C... verify against obs2d
c... have 1-D acc 

        call acc(obs2d,wk4,mdvs,accus(icase,1))
        call acc(obs2d,wk5,mdvs,accus(icase,2))
        call acc(obs2d,cca2d,mdvs,accus(icase,3))
        call acc(obs2d,cfs2d,mdvs,accus(icase,4))
        call acc(obs2d,smlr2d,mdvs,accus(icase,5))

        call rmss(obs2d,wk4,mdvs,rmsus(icase,1))
        call rmss(obs2d,wk5,mdvs,rmsus(icase,2))
        call rmss(obs2d,cca2d,mdvs,rmsus(icase,3))
        call rmss(obs2d,cfs2d,mdvs,rmsus(icase,4))
        call rmss(obs2d,smrl2d,mdvs,rmsus(icase,5))

      write(60,*) 'OBS'
      write(60,444) obs2d
      write(60,*) 'CONSL'
      write(60,444) wk1
      write(60,*) 'SIMPLE ENSEMBLE'
      write(60,444) wk2
      write(60,*) 'CCA'
      write(60,444) cca2d
      write(60,*) 'CFS'
      write(60,444) cfs2d
      write(60,*) 'SMLR'
      write(60,444) smlr2d
 1000 continue

      do iy=1,nyr
      iiy=1982+iy-1
      write(6,777)iiy,'wgts=',betaout(iy,1),betaout(iy,2),betaout(iy,3),
     &'acc=',accus(iy,1),accus(iy,2),
     &accus(iy,3),accus(iy,4),accus(iy,5)
      enddo
      write(6,*)
      do iy=1,nyr
      iiy=1982+iy-1
      write(6,777)iiy,'wgts=',betaout(iy,1),betaout(iy,2),betaout(iy,3),
     &'rms=',rmsus(iy,1),rmsus(iy,2),
     &rmsus(iy,3),rmsus(iy,4),rmsus(iy,5)
      enddo
      write(6,*)
c
C=== have s&t avg AC and RMS
      do iy=1,nyr
      do i=1,mdvs
        ccaprd(i,iy)=totdata(i,iy,2)
        cfsprd(i,iy)=totdata(i,iy,3)
        smlprd(i,iy)=totdata(i,iy,4)
      end do
      end do
      call acc_in_st(verify,mlrprd,accm(1),mdvs,nyr)
      call acc_in_st(verify,ewmprd,accm(2),mdvs,nyr)
      call acc_in_st(verify,ccaprd,accm(3),mdvs,nyr)
      call acc_in_st(verify,cfsprd,accm(4),mdvs,nyr)
      call acc_in_st(verify,smlprd,accm(5),mdvs,nyr)
c
      call rms_in_st(verify,mlrprd,rmsm(1),mdvs,nyr)
      call rms_in_st(verify,ewmprd,rmsm(2),mdvs,nyr)
      call rms_in_st(verify,ccaprd,rmsm(3),mdvs,nyr)
      call rms_in_st(verify,cfsprd,rmsm(4),mdvs,nyr)
      call rms_in_st(verify,smlprd,rmsm(5),mdvs,nyr)

      write(6,888)'MEAN ACC=',accm(1),accm(2),accm(3),accm(4),accm(5)
      write(6,888)'MEAN RMS=',rmsm(1),rmsm(2),rmsm(3),rmsm(4),rmsm(5)
      write(6,*)

555   format(A10,3(2x,A5,f7.2))
888   format(A10,30x,5f6.2)
777   format(I5,2x,A5,1x,3f7.2,1x,A5,5f6.2)
788   format(A5,7x,3A7,6x,5A6)
766   format(A13,5f7.2)
666   format(1x,A50)
999   format(2x,I2,2x,6(f7.2,2x))
988   format(10f6.2)

C
CC== acc & rms in time domain
      write(6,*)
      write(6,*) 'Temporal AC SKILL'
      call acc_in_t(mlrprd,verify,wk1,mdvs,nyr)
      write(6,*) 'consolidated'
      write(6,988) wk1
      write(50) wk1
      call acc_in_t(ewmprd,verify,wk1,mdvs,nyr)
      write(6,*) 'simple ensemble avg'
      write(6,988) wk1
      write(50) wk1
      call acc_in_t(ccaprd,verify,wk1,mdvs,nyr)
      write(6,*) 'CCA'
      write(6,988) wk1
      write(50) wk1
      call acc_in_t(cfsprd,verify,wk1,mdvs,nyr)
      write(6,*) 'CFS'
      write(6,988) wk1
      write(50) wk1
      call acc_in_t(smlprd,verify,wk1,mdvs,nyr)
      write(6,*) 'SMLR'
      write(6,988) wk1
      write(50) wk1
cccccccccccccccccccccccccccccccccccc
      write(6,*)
      write(6,*) 'RMS SKILL'
      call rms_in_t(mlrprd,verify,wk1,mdvs,nyr)
      write(6,*) 'consolidated'
      write(6,988) wk1
      call rms_in_t(ewmprd,verify,wk1,mdvs,nyr)
      write(6,*) 'simple ensemble avg'
      write(6,988) wk1
      call rms_in_t(ccaprd,verify,wk1,mdvs,nyr)
      write(6,*) 'CCA'
      write(6,988) wk1
      call rms_in_t(cfsprd,verify,wk1,mdvs,nyr)
      write(6,*) 'CFS'
      write(6,988) wk1
      call rms_in_t(smlprd,verify,wk1,mdvs,nyr)
      write(6,*) 'SMLR'
      write(6,988) wk1

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

      SUBROUTINE whichone(a,b1,b2,b3,id)
      if(a.eq.b1) id=1
      if(a.eq.b2) id=2
      if(a.eq.b3) id=3
      return
      end

      SUBROUTINE setzero(fld,n)
      DIMENSION fld(n)
      do i=1,n
         fld(i)=0.0
      enddo
      return
      end

      SUBROUTINE setzero_2d(fld,n,m)
      real fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end


      SUBROUTINE setzero_1d(fld,n)
      real fld(n)
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


      SUBROUTINE timeanom(fld,mdvs,ltime,clim)
      dimension fld(mdvs,ltime),clim(mdvs)
      call setzero_1d(clim,mdvs)
      do  i=1,mdvs
      do  k=1,ltime
        clim(i)=clim(i)+fld(i,k)/float(ltime)
      end do
      end do

      do  i=1,mdvs
      do  k=1,ltime
        fld(i,k)=fld(i,k)-clim(i)
      end do
      end do
      return
      end


