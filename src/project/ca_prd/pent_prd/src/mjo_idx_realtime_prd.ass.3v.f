      program caprd
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C CA prediction for tropical heating
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      parameter(nrunalpha=1)! 0: read in ; 1: run alpha
      parameter(ngrd=3*imp)  !factor 3 is for combind eof
      parameter(ims=1,ime=imp)   ! grid to have skill
      parameter(npp=nps)       ! max pentads to be predicted
      parameter(ntt=nseason*nps,nhs=(nseason-3)*30)  !nseason is # of years of hst data 
      parameter(ntout=nps*(nseason-1))
      dimension ts1(ntout),ts2(ntout)
      dimension ts4(ntt),ts5(ntt)
      dimension tsout(npp),tsout2(5)
      dimension ac1d(6,nseason,npp),ac1d2(6,nseason,npp)
      dimension rms1d(6,nseason,npp),rms1d2(6,nseason,npp)
      dimension rms_pc(6,modemax),corr_pc(6,modemax)
      dimension fldin(imin,jmin),fldin2(imin,jmin)
      dimension fldin3(imin,jmin),fldin33(imin,jmin)
      dimension fldin4(imin),fldin5(imin)
      dimension fldin6(imin),fldin66(imin)
      dimension fldful(imax,jmax)
      dimension xlat(jmp),fldp(imp,jmp)
      dimension alpha(nhs),corr(imp,jmp)
      dimension obs(imp),obs2(imp),prd(imp)
      dimension wk1d(imp),wk1d2(imp)
      dimension fld1d(imp),fld1d2(imp),fld1d3(imp)
      dimension fld1de(3*imp)
      dimension fld3d(imp,nps,nseason),fld3d2(imp,nps,nseason)
      dimension fld3d3(imp,nps,nseason),fld3de(3*imp,nps,nseason)
      dimension fld2d(imax,jmax)
      dimension fld4d(imin,jmin,nps,nseason)
      dimension fld4d2(imin,jmin,nps,nseason)
      dimension fld4d3(imin,jmin,nps,nseason)
      dimension tgt3d(imp,nps,nseason)
      dimension clim(imp,jmp,nps),aaa(ngrd,ntt)
      dimension efld3d(modemax,nps,nseason)
      dimension e3dwk(modemax,nps+25,nseason)
      dimension etgt2d(6,modemax)
      dimension pc_wk(5,modemax,nps*nseason)
      dimension pc_out(7,modemax,ntout)
      dimension WK(ntt,ngrd)
      dimension ana(modemax,nhs+1),anac(modemax)
      dimension eval(ntt),evec(ngrd,ntt),pc(ntt,ntt)
      dimension eof(modemax,imp),eof2(modemax,imp)
      dimension eof3(modemax,imp),ceof(modemax,3*imp),cosl(jmp)
      dimension rgpt(imin,jmin,modemax)
      dimension pcs(nps*nseason,modemax)
C
      open(unit=11,form='unformatted',access='direct',recl=4*imin*jmin) !hst u200
      open(unit=12,form='unformatted',access='direct',recl=4*imin*jmin) !hst u850
      open(unit=13,form='unformatted',access='direct',recl=4*imin*jmin) !hst olr
c
      open(unit=14,form='unformatted',access='direct',recl=4*imin*jmin) !cur u200
      open(unit=15,form='unformatted',access='direct',recl=4*imin*jmin) !cur u850
      open(unit=16,form='unformatted',access='direct',recl=4*imin*jmin) !cur olr
c
      open(unit=60,form='unformatted',access='direct',recl=4) !PC1 out
      open(unit=61,form='unformatted',access='direct',recl=4) !PC2 out
c
      open(unit=70,form='unformatted',access='direct',recl=4*imp*jmp)!EOFs for proj use
c
c*************************************************
c*************************************************
c*
      fak=1.
      ridge=0.05
c*
C*********************************************
c* read in data and save the tropics
      iu=11  ! u200
      iu2=12 ! u850
      iu3=13 ! olr
      irec=0
      DO is=1,nseason          ! number of seasons used for CA
        do ip=1,nps 
        irec=irec+1
          read(iu,rec=irec) fldin
          read(iu2,rec=irec) fldin2
          read(iu3,rec=irec) fldin3
c
          call lat_avg(fldin,fldin4,imin,jmin)
          call lat_avg(fldin2,fldin5,imin,jmin)
          call lat_avg(fldin3,fldin6,imin,jmin)
c
            do i=1,imp
              fld3d(i,ip,is)=fldin4(i)
              fld3d2(i,ip,is)=fldin5(i)
              fld3d3(i,ip,is)=fldin6(i)
            enddo
        enddo
      write(6,*) 'time length of data =',irec
      ENDDO !is loop
c* stdv, standardization and EOF analysis
      u20sd=0.
      u85sd=0.
      olrsd=0.
      xn=float(nseason*nps*imp)
      do is=1,nseason
      do ip=1,nps
      do i=1,imp
      u20sd=u20sd+fld3d(i,ip,is)*fld3d(i,ip,is)/xn
      u85sd=u85sd+fld3d2(i,ip,is)*fld3d2(i,ip,is)/xn
      olrsd=olrsd+fld3d3(i,ip,is)*fld3d3(i,ip,is)/xn
      enddo
      enddo
      enddo
      olrsd=sqrt(olrsd)
      u85sd=sqrt(u85sd)
      u20sd=sqrt(u20sd)
      it=0
      do is=1,nseason
      do ip=1,nps
      it=it+1
        do i=1,imp
          aaa(i,it)=fld3d(i,ip,is)/u20sd
          aaa(imp+i,it)=fld3d2(i,ip,is)/u85sd
          aaa(2*imp+i,it)=fld3d3(i,ip,is)/olrsd
c
          fld3de(i,ip,is)=fld3d(i,ip,is)/u20sd
          fld3de(imp+i,ip,is)=fld3d2(i,ip,is)/u85sd
          fld3de(2*imp+i,ip,is)=fld3d3(i,ip,is)/olrsd
        end do
      enddo
      enddo
      write(6,*) 'length of input data to EOF calculation=',it
c       
      call eofs_4_ca(aaa,ngrd,ntt,ngrd,eval,evec,pc,wk,0)
c
      write(6,*)'eval='
      write(6,400) eval
 400  format(9f8.3)
c
c* have 1D EOF patterns
c
        do nm=1,modemax
        do i=1,imp
          eof(nm,i)=-evec(i,nm)  !taking u200 part
          eof2(nm,i)=-evec(imp+i,nm)  !taking u850 part
          eof3(nm,i)=-evec(2*imp+i,nm)!taking olr part
        end do
        do i=1,3*imp
          ceof(nm,i)=-evec(i,nm)  !taking combined
        end do
        end do
c
c* standardize spatial patterns to unity****
c
        irec=0
        do m1=1,modemax

        call inprod(imp,modemax,eof,m1,m1,anorm)
        call inprod(imp,modemax,eof2,m1,m1,anorm2)
        call inprod(imp,modemax,eof3,m1,m1,anorm3)
        do i=1,imp
          eof(m1,i)=eof(m1,i)/sqrt(anorm)
          eof2(m1,i)=eof2(m1,i)/sqrt(anorm2)
          eof3(m1,i)=eof3(m1,i)/sqrt(anorm3)
        end do

        do i=1,imp
          fld1d(i)=eof(m1,i)
          fld1d2(i)=eof2(m1,i)
          fld1d3(i)=eof3(m1,i)
        enddo
        irec=irec+1
        write(70,rec=irec) fld1d ! write out EOFs
        irec=irec+1
        write(70,rec=irec) fld1d2 ! write out EOFs
        irec=irec+1
        write(70,rec=irec) fld1d3 ! write out EOFs

        enddo  !loop for m1
c
C* project grid data onto EOFs*******
c                
        it=0
        do is=1,nseason
        do ip=1,nps
        it=it+1
        call f3d_2_f1d(3*imp,nps,nseason,ip,is,fld1de,fld3de)
        do nmode=1,modemax
        call inprod4(ceof,fld1de,3*imp,nmode,modemax,anorm)
          efld3d(nmode,ip,is)=anorm  
        enddo
        enddo
        enddo 
c
cc feed in extended arrays e3dwk for prd use
c
      do is=1,nseason
      do ip=1,nps
      do im=1,modemax
         e3dwk(im,ip+10,is)=efld3d(im,ip,is)
      enddo
      enddo
      enddo
c
      do is=2,nseason
      do ip=1,10
      do im=1,modemax
         e3dwk(im,ip,is)=efld3d(im,nps-10+ip,is-1)
      enddo
      enddo
      enddo
c
      do is=1,nseason-1
      do ip=1,15
      do im=1,modemax
         e3dwk(im,nps+10+ip,is)=efld3d(im,ip,is+1)
      enddo
      enddo
      enddo
c
c*   CA prd begins
c
      ntp1=10
      ntp2=20
      ntp3=30
      ntp4=40
      ntp5=50
      ntp6=60
      ntp7=73
c
      iout=0
      DO ldpen=1,6  !1:IC; 2:0 pent lead; 3: 1pent lead; ...

      giving ntgtp here
c
        it=0
        if(ntgtp.ge.1.and.ntgtp.le.ntp1) then
        do is=2,nseason-1   
          do ip=1,30
            it=it+1
            do nmode=1,modemax
              ana(nmode,it)=e3dwk(nmode,ip+ldpen-1,is)
            enddo
          enddo
        if(it.ge.nhs) go to 441
        enddo        
 441    continue
        endif
c
        it=0
        if(ntgtp.gt.ntp1.and.ntgtp.le.ntp2) then
        do is=2,nseason-1   
          do ip=11,40
            it=it+1
            do nmode=1,modemax
              ana(nmode,it)=e3dwk(nmode,ip+ldpen-1,is)
            enddo
          enddo
        if(it.ge.nhs) go to 442
        enddo          
 442    continue
        endif
c
        it=0
        if(ntgtp.gt.ntp2.and.ntgtp.le.ntp3) then
        do is=2,nseason-1 
          do ip=21,50
            it=it+1
            do nmode=1,modemax
              ana(nmode,it)=e3dwk(nmode,ip+ldpen-1,is)
            enddo
          enddo
        if(it.ge.nhs) go to 443
        enddo       
 443    continue
        endif
c
        it=0
        if(ntgtp.gt.ntp3.and.ntgtp.le.ntp4) then
        do is=2,nseason-1 
          do ip=31,60
            it=it+1
            do nmode=1,modemax
              ana(nmode,it)=e3dwk(nmode,ip+ldpen-1,is)
            enddo
          enddo
        if(it.ge.nhs) go to 444
        enddo         
 444    continue
        endif
c
        it=0
        if(ntgtp.gt.ntp4.and.ntgtp.le.ntp5) then
        do is=2,nseason-1   
          do ip=41,70
            it=it+1
            do nmode=1,modemax
              ana(nmode,it)=e3dwk(nmode,ip+ldpen-1,is)
            enddo
          enddo
        if(it.ge.nhs) go to 445
        enddo            
 445    continue
        endif
c
        it=0
        if(ntgtp.gt.ntp5.and.ntgtp.le.ntp6) then
        do is=2,nseason-1  
          do ip=51,80
            it=it+1
            do nmode=1,modemax
              ana(nmode,it)=e3dwk(nmode,ip+ldpen-1,is)
            enddo
          enddo
        if(it.ge.nhs) go to 446
        enddo       
 446    continue
        endif
c
        it=0
        if(ntgtp.gt.ntp6.and.ntgtp.le.ntp7) then
        do is=2,nseason-1  
          do ip=61,90
            it=it+1
            do nmode=1,modemax
              ana(nmode,it)=e3dwk(nmode,ip+ldpen-1,is)
            enddo
          enddo
        if(it.ge.nhs) go to 447
        enddo         
 447    continue
        write(6,*)'length of history',it
        endif
c
        IF(ldpen.gt.1) go to 222

        do nmode=1,modemax
        ana(nmode,nhs+1)=giving PC proj of IC data here
        enddo

        call getalpha(ana,alpha,modemax,nhs,fak,ridge)

 222    continue

        do nmode=1,modemax
        etgt2d(ldpen,nmode)=0.
        enddo

        do nmode=1,modemax
        do ntime=1,nhs
        etgt2d(ldpen,nmode)=etgt2d(ldpen,nmode)+
     &           ana(nmode,ntime)*alpha(ntime)
        enddo
        enddo
c
      ENDDO  !loop for ldpen
c
c* post process and write out
c
       do nmode=1,modemax
         it=0
         do is=2,nseason
         do ip=1,nps
         it=it+1
           pc_out(1,nmode,it)=efld3d(nmode,ip) !obs data
           pc_out(2,nmode,it)=etgt2d(1,nmode) !CA data
         enddo
         enddo
       enddo
c normalize PCs
       do ld=1,7
       do nmode=1,modemax
         do it=1,ntout
           ts1(it)=pc_out(ld,nmode,it)
         enddo
           call normal_1d(ntout,ts1)
         do it=1,ntout
           pc_out(ld,nmode,it)=ts1(it)
         enddo
       enddo
       enddo
c* write out PC1 of obs, CA and prd
       iwrt=0
       DO it=1,ntout
       iwrt=iwrt+1
         write(60,rec=iwrt) pc_out(1,1,it)
       iwrt=iwrt+1
         write(60,rec=iwrt) pc_out(2,1,it)
       iwrt=iwrt+1
         write(60,rec=iwrt) pc_out(3,1,it)
       iwrt=iwrt+1
         write(60,rec=iwrt) pc_out(4,1,it)
       iwrt=iwrt+1
         write(60,rec=iwrt) pc_out(5,1,it)
       iwrt=iwrt+1
         write(60,rec=iwrt) pc_out(6,1,it)
       iwrt=iwrt+1
         write(60,rec=iwrt) pc_out(7,1,it)
       ENDDO
c* write out PC2 of obs, CA and prd
       iwrt=0
       DO it=1,ntout
       iwrt=iwrt+1
         write(61,rec=iwrt) pc_out(1,2,it)
       iwrt=iwrt+1
         write(61,rec=iwrt) pc_out(2,2,it)
       iwrt=iwrt+1
         write(61,rec=iwrt) pc_out(3,2,it)
       iwrt=iwrt+1
         write(61,rec=iwrt) pc_out(4,2,it)
       iwrt=iwrt+1
         write(61,rec=iwrt) pc_out(5,2,it)
       iwrt=iwrt+1
         write(61,rec=iwrt) pc_out(6,2,it)
       iwrt=iwrt+1
         write(61,rec=iwrt) pc_out(7,2,it)
       ENDDO
c
C*********************************************
100    format(9f7.2/9f7.2)
110    format(A2,I2,A6,5f8.2)
      write(6,*) 'end of excution'
 888  continue
      STOP
      END
c*
      subroutine ca_prd_grd(iu,ntt,ntgt,nhs,im,jm,alpha,obs,prd)
      dimension wk(im,jm),fld3d(im,jm,nhs)
      dimension obs(im,jm),prd(im,jm),alpha(nhs)
      id=0
      do nt=1,ntt !have historical given month data for constructing prd
          read(iu,rec=nt) wk
          if(nt.eq.ntgt) go to 666
          if(nt.eq.ntgt-1) go to 666
          if(nt.eq.ntgt+1) go to 666
          id=id+1
          do i=1,im
          do j=1,jm
            fld3d(i,j,id)=wk(i,j)
          enddo
          enddo
 666      continue
      enddo
        call anom_clim(im,jm,nhs,nhs,fld3d,wk)
        read(iu,rec=ntgt) obs
        do i=1,im
        do j=1,jm
          obs(i,j)=obs(i,j)-wk(i,j)
        enddo
        enddo
c
        do i=1,im
        do j=1,jm
          prd(i,j)=0.0 
        enddo
        enddo
      do nt=1,nhs
        do i=1,im
        do j=1,jm
          prd(i,j)=prd(i,j)+fld3d(i,j,nt)*alpha(nt)
        enddo
        enddo
      enddo
      return
      end
c*
c
      subroutine lat_avg(fld1,fld2,imax,jmax)
      dimension fld1(imax,jmax),fld2(imax)
C avg from 15S to 15N
        do i=1,imax
        x=0
        do j=1,13 !from 15S to 15N
          x=x+fld1(i,j+6)
        end do
        x=x/13.
        fld2(i)=x
        end do

      return
      end
c
      subroutine normal_1d(nt,ts)
      dimension ts(nt)
        x=0
        do i=1,nt
          x=x+ts(i)*ts(i)
        end do
        x=sqrt(x/float(nt))
        do i=1,nt
          ts(i)=ts(i)/x
        end do

      return
      end
c
      subroutine fill_mis(im,jm,fld1,fld2,undf)
      dimension fld1(im,jm),fld2(im,jm)
        do i=1,im
        do j=1,jm
          if(abs(fld1(i,j)).gt.undf) then
          fld2(i,j)=0.
          else
          fld2(i,j)=fld1(i,j)
          endif
        enddo
        enddo
      return
      end
c*
      subroutine f3d_2_f2d(im,jm,ntt,ntgt,fld2d,fld3d)
      dimension fld3d(im,jm,ntt),fld2d(im,jm)
        do i=1,im
        do j=1,jm
          fld2d(i,j)=fld3d(i,j,ntgt)
        enddo
        enddo
      return
      end
c*
      subroutine f3d_2_f1d(im,nps,nseason,ip,iw,fld1d,fld3d)
      dimension fld3d(im,nps,nseason),fld1d(im)
        do i=1,im
          fld1d(i)=fld3d(i,ip,iw)
        enddo
      return
      end
c*
      subroutine f2d_2_f3d(im,jm,ntt,ntgt,fld2d,fld3d)
      dimension fld3d(im,jm,ntt),fld2d(im,jm)
        do i=1,im
        do j=1,jm
          fld3d(i,j,ntgt)=fld2d(i,j)
        enddo
        enddo
      return
      end
c*
      subroutine anom_clim(im,jm,ntt,nys,fld3d,fld2d)
      dimension fld3d(im,jm,ntt),fld2d(im,jm)
        do i=1,im
        do j=1,jm
          fld2d(i,j)=0.
        enddo
        enddo
        do it=1,nys
        do i=1,im
        do j=1,jm
        fld2d(i,j)=fld2d(i,j)+fld3d(i,j,it)/float(nys)
        enddo
        enddo
        enddo
        do it=1,nys
        do i=1,im
        do j=1,jm
        fld3d(i,j,it)=fld3d(i,j,it)-fld2d(i,j)
        enddo
        enddo
        enddo
      return
      end
c*
      function cov(ana,nisb,n,ib1,ib2,fak)
      dimension ana(nisb,n+1)
      z=0.
      do is=1,nisb
      ax=ana(is,ib1)/fak
      ay=ana(is,ib2)/fak
      z=z+(ay*ax)
      enddo
c     cov=z/float(nisb)
      cov=z
101   format(1h ,3f7.2,3i4)
      return
      end
c*
      subroutine rms_1d(n,ts1,ts2,rms)
      dimension ts1(n),ts2(n)
      x=0.
      do it=1,n
      x=x+(ts1(it)-ts2(it))*(ts1(it)-ts2(it))
      enddo
      rms=sqrt(x/float(n))
      return
      end
c*
      subroutine corr_1d(n,ts1,ts2,corr)
      dimension ts1(n),ts2(n)
      x=0.
      y=0.
      xy=0.
      do it=1,n
      x=x+ts1(it)*ts1(it)/float(n)
      y=y+ts2(it)*ts2(it)/float(n)
      xy=xy+ts1(it)*ts2(it)/float(n)
      enddo
      corr=xy/(sqrt(x)*sqrt(y))
      return
      end
c*
      subroutine regr_1d(n,ts1,ts2,corr)
      dimension ts1(n),ts2(n)
      x=0.
      y=0.
      xy=0.
      do it=1,n
      x=x+ts1(it)*ts1(it)/float(n)
      y=y+ts2(it)*ts2(it)/float(n)
      xy=xy+ts1(it)*ts2(it)/float(n)
      enddo
      corr=xy/sqrt(x)
      return
      end
c
      subroutine corr_2d(im,jm,n,obs,prd,corr)
      dimension obs(im,jm,n),prd(im,jm,n)
      dimension corr(im,jm)
      do i=1,im
      do j=1,jm
      x=0.
      y=0.
      xy=0.
      do it=1,n
      x=x+obs(i,j,it)*obs(i,j,it)/float(n)
      y=y+prd(i,j,it)*prd(i,j,it)/float(n)
      xy=xy+obs(i,j,it)*prd(i,j,it)/float(n)
      enddo
      corr(i,j)=xy/(sqrt(x)*sqrt(y))
      enddo
      enddo
c     write(6,101) corr
101   format(1h ,10f7.2)
      return
      end
*
      subroutine inprod1(im,jm,modemax,e,cosl,m1,m2,anorm)
c* inner product in space among eofs of length n
      dimension e(modemax,im,jm)
      dimension cosl(jm)
      x=0.
      do i=1,im
      do j=1,jm
      x=x+e(m1,i,j)*e(m2,i,j)*cosl(j)
      enddo
      enddo
      anorm=x
      return
      end
c
      subroutine inprod(im,modemax,e,m1,m2,anorm)
c* inner product in space among eofs of length n
      dimension e(modemax,im)
      x=0.
      do i=1,im
      x=x+e(m1,i)*e(m2,i)
      enddo
      anorm=x
      return
      end
c
      subroutine inprod4(e,academic,im,m1,modemax,anorm)
c* inner product in space among one eof and an academic anomaly
      dimension e(modemax,im),academic(im)
      x=0.
      y=0.
      do i=1,im
      x=x+e(m1,i)*academic(i)
      y=y+e(m1,i)*e(m1,i)
      enddo
c     write(6,100)m1,x/y
      anorm=x/y
100   format(1h ,'ip4= ',i5,3f10.6)
      return
      end
c
      subroutine rmsd1(anom,anomp,im,ims,ime,cosl,z1,zc)
      dimension anomp(im),anom(im)
      x=0.
      y=0.
      z=0.
      zc=0.
      w=0.
      do i=ims,ime
c     do i=1,im
      w=w+1
      x=x+anom(i)*anom(i)
      y=y+anomp(i)*anomp(i)
      z=z+(anomp(i)-anom(i))*(anomp(i)-anom(i))
      zc=zc+anomp(i)*anom(i)
      enddo
      x1=sqrt(x/w)
      y1=sqrt(y/w)
      z1=sqrt(z/w)
      zc=zc/w/(x1*y1)
c     write(6,100)x,y,z,w,ns
c* add average diffs
      x=0.
      y=0.
      z=0.
      w=0.
      do i=ims,ime
      w=w+1
      x=x+anom(i)
      y=y+anomp(i)
      z=z+(anom(i)-anomp(i))
      enddo
      x=x/w
      y=y/w
      z=z/w
      write(6,100)x1,y1,z1,zc,x,y,z,w
100   format('stats grid rms/ave:',8f7.2,i5)
200   format(1h ,'stats grid ave:',4f7.2,i5)
      return
      end
c
      subroutine getalpha(ana,alpha,modemax,n,fak,ridge)
      dimension ana(modemax,n+1),alpha(n)
      real*8 a(n,n),b(n),aiv(n,n)
      do i=1,n
      do j=1,n
       a(i,j)=0.
       b(j)=0.
      enddo
      enddo
      ax=0.
      do ib1=1,n
      b(ib1)=cov(ana,modemax,n,ib1,n+1,fak)
      do ib2=ib1,n
      a(ib1,ib2)=cov(ana,modemax,n,ib1,ib2,fak)
      a(ib2,ib1)=a(ib1,ib2)
      enddo
      enddo
      d=0.
      do ib1=1,n
      d=d+a(ib1,ib1)/float(n)
      enddo
      do ib1=1,n
       a(ib1,ib1)=a(ib1,ib1)+d*ridge
      enddo
       call mtrx_inv(a,aiv,n,n)
       call solutn(aiv,b,alpha,n)
      return
      end
c
      SUBROUTINE solutn(ff,vf,beta,m)
      real*8 ff(m,m),vf(m)
      real beta(m)

      do i=1,m
         beta(i)=0.
      do j=1,m
         beta(i)=beta(i)+ff(i,j)*vf(j)
      end do
      end do

      return
      end
c*
c*
      subroutine weinalys(alpha,nt,sa,sasq,sabs,qeven,qodd,decadal)
      dimension alpha(nt),decadal(10)
c* analysis of nt (66) weights;
C* sa=sum of weights, sasq=sum of squares of weights, sabs=sum of abs values of weights.
C* qeven is sum of weights for even years (32,34 etc)
C* qodd is sum of weights for odd years (33,35 etc)
c* decadal(1) contains sums over 1st 10 years (32-41)
c* decadal(2) contains sums over 2nd 10 years (42-51), etc
      x=0.
      u=0.
      y=0.
      z=0.
C* sum of weights, forward and backwards
      do ntime=1,nt
      ntimer=nt-ntime+1
      x=x+alpha(ntime)
      u=u+alpha(ntimer)
      y=y+alpha(ntime)*alpha(ntime)
      z=z+abs(alpha(ntime))
c     write(6,100)ntime+1931,x,ntimer+1931,u
      enddo
c     write(6,111)x,y,z
      sa=x
      sasq=y
      sabs=z
      x=0.
      u=0.
      y=0.
      z=0.
C* sum of weights, forward and backwards, for odd/even years
      do ntime=1,nt,2
      ntimer=nt-ntime+1
      x=x+alpha(ntime)
      u=u+alpha(ntimer)
      y=y+alpha(ntime)*alpha(ntime)
      z=z+abs(alpha(ntime))
c     write(6,100)ntime+1931,x,ntimer+1931,u
      enddo
      qodd=u
      qeven=sa-u
c     write(6,111)x,y,z
      x=0.
      u=0.
      y=0.
      z=0.
C* sum of weights, forward and backwards, for odd/even years
      do ntime=2,nt,2
      ntimer=nt-ntime+1
      x=x+alpha(ntime)
      u=u+alpha(ntimer)
      y=y+alpha(ntime)*alpha(ntime)
      z=z+abs(alpha(ntime))
c     write(6,100)ntime+1931,x,ntimer+1931,u
      enddo
c     write(6,111)x,y,z
      do j=1,9
      ntime=(j-1)*10+1
      x=0.
      do i=0,9
      nti=ntime+i
      if (nti.le.nt) x=x+alpha(nti)
      enddo
c     write(6,101)ntime+1931,ntime+1940,x
      decadal(j)=x
      enddo
111   format(1h ,' sum, sumsqr sumabs: ',14f7.2)
100   format(1h ,'qb',i5,f7.2,i5,f7.2)
101   format(1h ,'decadal',2i5,f7.2)
      return
      end
c
      subroutine prout(alpha,jeartarget,m,mf,ntt,iout)
      dimension alpha(ntt),decadal(10),hulp(10)
      dimension alphaprint(100)
      do i=1,100
      alphaprint(i)=-999999999999.
      enddo
      do i=1,ntt
      alphaprint(i)=alpha(i)
      enddo
      call weinalys(alpha,ntt,x,y,z,qeven,qodd,decadal)
      do i=1,10
      hulp(i)=-999999999999.
      enddo
      hulp(1)=x
      hulp(2)=y
      hulp(3)=z
      hulp(4)=qeven
      hulp(5)=qodd
      hulp(6)=qodd-qeven
       write(iout,102)m,mf,jeartarget+1930,ntt
       do ntime=1,10
       if (ntt.eq.90) then
       write(iout,112)ntime+1960, alphaprint(ntime)
     *           ,ntime+1970, alphaprint(ntime+10)
     *           ,ntime+1980, alphaprint(ntime+20)
     *           ,ntime+1960, alphaprint(ntime+30)
     *           ,ntime+1970, alphaprint(ntime+40)
     *           ,ntime+1980, alphaprint(ntime+50)
     *           ,ntime+1960, alphaprint(ntime+60)
     *           ,ntime+1970, alphaprint(ntime+70)
     *           ,ntime+1980, alphaprint(ntime+80),hulp(ntime)
       endif
c      write(iout,212)ntime+1979, alphaprint(ntime)
c    *           ,ntime+1989, alphaprint(ntime+10)
c    *           ,ntime+1979, alphaprint(ntime+20)!1980-99 choice
c    *           ,ntime+1989, alphaprint(ntime+30)
c    *           ,ntime+1979, alphaprint(ntime+40)
c    *           ,ntime+1989, alphaprint(ntime+50),hulp(ntime)
c      write(iout,212)ntime+1970, alphaprint(ntime)
c    *           ,ntime+1980, alphaprint(ntime+10)
c    *           ,ntime+1970, alphaprint(ntime+20)!1971-90 choice
c    *           ,ntime+1980, alphaprint(ntime+30)
c    *           ,ntime+1970, alphaprint(ntime+40)
c    *           ,ntime+1980, alphaprint(ntime+50),hulp(ntime)
c      write(iout,212)ntime+1950, alphaprint(ntime)
c    *           ,ntime+1960, alphaprint(ntime+10)
c    *           ,ntime+1950, alphaprint(ntime+20)!1951-70 choice
c    *           ,ntime+1960, alphaprint(ntime+30)
c    *           ,ntime+1950, alphaprint(ntime+40)
c    *           ,ntime+1960, alphaprint(ntime+50),hulp(ntime)
       enddo
c      write(iout,103)
       write(iout,113)(decadal(j),j=1,9)!choice 61-90
c      write(iout,113)(decadal(j),j=1,6)!choice
c      write(iout,103)
c      write(iout,103)
c      write(iout,103)
102   format(4i6)
103   format()
112   format(9(i6,f7.2),1x,f8.2)
212   format(6(i6,f7.2),1x,f8.2)
113   format(9(6x,f7.2))
      return
      end
c*

C       ================================================================
        subroutine  mtrx_inv( x, xinv, n,max_npc)
C       ================================================================

        implicit none

C-----------------------------------------------------------------------
C                             INCLUDE FILES
C-----------------------------------------------------------------------
c
c #include  "reg_parm"
        integer max_nchan
        parameter(max_nchan = 2378) !MAXIMUM # OF ALLOWED REGRESSION CHANNELS

        integer max_nsamp
        parameter(max_nsamp = 600) ! MAXIMUM TRAINING SAMPLE SIZE OR THE MAXIMUM #
                                    ! OF OBSERVATIONS TO WHICH COEFFICENTS ARE APPLIED

        integer max_npc
c       parameter(max_npc =21) ! maximum # of principal components
c       parameter(max_npc =46) ! maximum # of principal components
c
C-----------------------------------------------------------------------
C                              ARGUMENTS
C-----------------------------------------------------------------------

        real*8    x ( max_npc, max_npc )
        real*8    xinv ( max_npc, max_npc )
        integer   n

C-----------------------------------------------------------------------
C                            LOCAL VARIABLES
C-----------------------------------------------------------------------

        integer   i
        integer   ii
        integer   im
        integer   ip
        integer   j
        integer   jm
        integer   jp
        integer   k
        integer   l
        integer   nm
        real*8    s ( max_npc, max_npc )
        real*8    a ( max_npc, max_npc )
        real*8    sum

C***********************************************************************
C***********************************************************************
C                            EXECUTABLE CODE
C***********************************************************************
C***********************************************************************

C-----------------------------------------------------------------------
C     [ Major comment blocks set off by rows of dashes. ]
C-----------------------------------------------------------------------

C
C    CONVERT 'X' TO A DOUBLE PRECISION WORK ARRAY.
      do 10 i=1,n
      do 10 j=1,n
c      a(i,j)=dble(x(i,j))
      a(i,j)=x(i,j)
   10 continue
      s(1,1)=1.0/a(1,1)
c    just inverting a scalar if n=1.
      if(n-1)20,180,30
   20 return
   30 do 40 j=2,n
      s(1,j)=a(1,j)
   40 continue
      do 70 i=2,n
      im=i-1
      do 60 j=i,n
      sum=0.0
      do 50 l=1,im
      sum=sum+s(l,i)*s(l,j)*s(l,l)
   50 continue
      s(i,j)=a(i,j)-sum
   60 continue
      s(i,i)=1.0/s(i,i)
   70 continue
      do 80 i=2,n
      im=i-1
      do 80 j=1,im
   80 s(i,j)=0.0
      nm=n-1
      do 90 ii=1,nm
      im=n-ii
      i=im+1
      do 90 j=1,im
      sum=s(j,i)*s(j,j)
      do 90 k=i,n
      s(k,j)=s(k,j)-s(k,i)*sum
   90 continue
      do 120 j=2,n
      jm=j-1
      jp=j+1
      do 120 i=1,jm
      s(i,j)=s(j,i)
      if(jp-n)100,100,120
  100 do 110 k=jp,n
      s(i,j)=s(i,j)+s(k,i)*s(k,j)/s(k,k)
  110 continue
  120 continue
      do 160 i=1,n
      ip=i+1
      sum=s(i,i)
      if(ip-n)130,130,150
  130 do 140 k=ip,n
      sum=sum+s(k,i)*s(k,i)/s(k,k)
  140 continue
  150 s(i,i)=sum
  160 continue
      do 170 i=1,n
      do 170 j=i,n
      s(j,i)=s(i,j)
  170 continue
c    retrieve output array 'xinv' from the double precession work array.
  180 do 190 i=1,n
      do 190 j=1,n
c      xinv(i,j)=sngl(s(i,j))
      xinv(i,j)=s(i,j)
  190 continue
      return
      end
