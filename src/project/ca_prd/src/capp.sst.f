      program caprd
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C CA prediction for tropical heating
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      parameter(natura=0)! natura=1 means natural analogue
      parameter(imt=128,jmt=64)       ! grid size of 2mt
      parameter(imp=72,jmp=24)        ! grid size of prcp
      parameter(imsst=128,jmsst=16)   ! grid size of sst
      parameter(ims=18,ime=56)        ! grid to have skill
c     parameter(ims=1,ime=imp)        ! grid to have skill
      parameter(ntt=24,nhs=ntt-3,modemax=11)!choice # of modes and ntt
c     parameter(ngrd=imp*jmp)
      parameter(ngrd=1576)
      dimension xlat_sst(jmsst),coslsst(jmsst)
      dimension xlat_prcp(jmp),coslprcp(jmp)
      dimension ana(modemax,nhs+1),anac(modemax)
      dimension t3(imp,jmp),t3c(imsst,jmsst)
      dimension sst_t3(imsst,jmsst),sst_prd(imsst,jmsst)
      dimension e(modemax,imsst,jmsst)
      dimension alpha(nhs),corr(imp,jmp)
      dimension cr1d(ntt-2),cr1d2(ntt-2)
      dimension cr1d3(ntt-2)
      dimension obs(imsst,jmsst)
      dimension fld2d(imsst,jmsst),fld3d(imsst,jmsst,nhs)
      dimension obs3d(imsst,jmsst,ntt-2),obs3d2(imp,jmp,ntt-2)
      dimension sst_obs3d2(imsst,jmsst,ntt-2)
      dimension sst_prd3d(imsst,jmsst,ntt-2)
      dimension prd(imp,jmp)
      dimension prd3d(imp,jmp,ntt-2),ca3d(imp,jmp,ntt-2)
      dimension clim(imp,jmp),aaa(ngrd,nhs)
      dimension EVAL(nhs),EVEC(ngrd,nhs),PC(nhs,nhs)
      dimension WK(nhs,ngrd)
C
      data xlat_sst/-20.930,-18.139,-15.348,-12.558,-9.767, 
     &-6.977,-4.186,-1.395,
     & 1.395,4.186,6.977,9.767,12.558,15.348,18.139,20.93/
C
      open(unit=10,form='unformatted',access='direct',
     &     recl=imsst*jmsst)                                        !mon sst
      open(unit=11,form='unformatted',access='direct',
     &     recl=imsst*jmsst)                                        !mon sst
      open(unit=15,form='unformatted',access='direct',recl=imp*jmp) !mp prcp
C     open(unit=20,form='unformatted',access='direct',recl=imz*jmz) !z500
      open(unit=30,form='unformatted',access='direct',
     &     recl=imsst*jmsst) !prcp_eof
      open(unit=40,form='unformatted',access='direct',
     &     recl=imsst*jmsst) !ca
      open(unit=45,form='unformatted',access='direct',recl=imp*jmp) !prd-prcp
      open(unit=46,form='unformatted',access='direct',
     &     recl=imsst*jmsst) !prd-sst
      open(unit=50,form='unformatted',access='direct',recl=imp*jmp) !corr skill
      open(unit=51,form='unformatted',access='direct',
     &     recl=imsst*jmsst) !corr skill for SST
      open(unit=55,form='unformatted',access='direct',recl=ntt-2) !corr skill
c*************************************************
      if (natura.eq.1)write(6,307)
      if (natura.eq.0)write(6,308)
c*************************************************
c*
      PI=4.*atan(1.)
      CONV=PI/180.
      DO j=1,jmsst
        COSLSST(j)=COS(xlat_sst(j)*CONV)
      END DO
      do j=1,jmp
        xlat_prcp(j)=-28.75+(j-1)*2.5
        COSLPRCP(j)=COS(xlat_prcp(j)*CONV)
      end do
      fak=1.
      ridge=0.01
      undef=-999.0
c 
C*********************************************
c
c* cross validated CA prd begins
c
      no=0
      do ntgt=2,ntt-1  !loop over target years
        no=no+1
        read(10,rec=ntgt) obs  !save the target year (IC month) data
        call f2d_2_f3d(imsst,jmsst,ntt-2,no,obs,obs3d)
c* get data for the non-target years
        ny=0
        do nt=1,ntt
        ntm1=ntgt-1 
        ntp1=ntgt+1
        if(nt.eq.ntm1)   go to 555
        if(nt.eq.ntgt)   go to 555
        if(nt.eq.ntp1)   go to 555
        ny=ny+1
        read(10,rec=nt) fld2d
        call f2d_2_f3d(imsst,jmsst,nhs,ny,fld2d,fld3d)
 555    continue
        enddo
        write(6,*) 'non-target years#=',ny
        call anom_clim_sst(imsst,jmsst,nhs,ny,fld3d,fld2d,undef)
c* make target year data to be the anom wrt clim of the non-target years
        do j=1,jmsst
        do i=1,imsst
          obs3d(i,j,no)=obs3d(i,j,no)-fld2d(i,j)
        end do
        end do
c* input data for EOF analysis
        do it=1,ny
          id=0
          do j=1,jmsst
          do i=1,imsst
          if(abs(fld3d(i,j,it)).lt.50) then
            id=id+1
            aaa(id,it)=fld3d(i,j,it)*sqrt(COSLSST(j))
          end if
          end do
          end do
c         write(6,*) 'ngrd=',id
        enddo
c       
      call eofs_4_ca(aaa,ngrd,nhs,nhs,eval,evec,pc,wk,0)
c
c     write(6,*) 'eval=',eval
c* have 2D EOF 
c
        do nm=1,modemax
        ng=0
        do j=1,jmsst
        do i=1,imsst
          if(abs(obs(i,j)).lt.50) then
          ng=ng+1
           e(nm,i,j)=evec(ng,nm)
          else
           e(nm,i,j)=undef
          endif
        end do
        end do
        end do
C* standardize spatial patterns to unity****
        do m1=1,modemax
        call inprod1_sst(imsst,jmsst,modemax,e,coslsst,m1,m1,anorm,
     &                   undef,obs)
c       write(6,*)m1,anorm
        do i=1,imsst
        do j=1,jmsst
         if(abs(obs(i,j)).lt.50) then
          e(m1,i,j)=e(m1,i,j)/sqrt(anorm)
         end if
        end do
        end do
        call inprod1_sst(imsst,jmsst,modemax,e,coslsst,m1,m1,anorm,
     &                   undef,obs)
c       write(6,*)m1,anorm
        do i=1,imsst
        do j=1,jmsst
          fld2d(i,j)=e(m1,i,j)
        end do
        end do
        write(30) fld2d ! write out eof
        enddo
C* project "historical data" onto current eof's*******
        do nt=1,ny
        call f3d_2_f2d(imsst,jmsst,ny,nt,fld2d,fld3d)
        do nmode=1,modemax
        call inprod4_sst(e,fld2d,imsst,jmsst,coslsst,nmode,modemax,
     &                     anorm)
          ana(nmode,nt)=anorm
        enddo
c       write(6,100)nj,(ana(nmode,nj),nmode=1,10)
        enddo
C* project "target data" onto eof's*******
c
        call f3d_2_f2d(imsst,jmsst,ntt-2,no,fld2d,obs3d)
        do nmode=1,modemax
        call inprod4_sst(e,fld2d,imsst,jmsst,coslsst,nmode,modemax,
     &                     anorm)
          ana(nmode,ny+1)=anorm
        enddo
c* get alpha
      call getalpha(ana,alpha,modemax,nhs,fak,ridge)
c
c     call prout(alpha,njbase,mm,mm,ntt,6)
c
        af=0.
        do i=1,nhs
          af=af+alpha(i)*alpha(i)
        enddo
        write(6,*) 'alpha**2=',af
c       write(6,100) alpha
        do nmode=1,modemax
          anac(nmode)=0.
        enddo
c
       do nmode=1,modemax
       do ntime=1,nhs
         anac(nmode)=anac(nmode)+ana(nmode,ntime)*alpha(ntime)
       enddo
       enddo
C
       do i=1,imsst
       do j=1,jmsst
         t3c(i,j)=0.
       enddo
       enddo
       do nmode=1,modemax
       do i=1,imsst
       do j=1,jmsst
        if(abs(e(nmode,i,j)).lt.50) then
         t3c(i,j)=t3c(i,j)+anac(nmode)*e(nmode,i,j)
        else
         t3c(i,j)=undef
        end if
       enddo
       enddo
       enddo
c      call f3d_2_f2d(imsst,jmsst,ntt-2,no,obs,obs3d) !for persistent prd
c      call rmsd1(obs,t3c,imp,jmp,ims,ime,cosl,cr1d(no))
c
       write(40) t3c    ! write IC-error for grads1
c      call f2d_2_f3d(imp,jmp,ntt-2,no,t3c,ca3d)
c* construct prediction for precip
       call ca_prd(15,ntt,ntgt,nhs,imp,jmp,alpha,t3,prd)
       call f2d_2_f3d(imp,jmp,ntt-2,no,prd,prd3d)
       call f2d_2_f3d(imp,jmp,ntt-2,no,t3,obs3d2)
       call rmsd1(t3,prd,imp,jmp,ims,ime,coslprcp,cr1d2(no))
c      call rmsd1(t3,obs,imp,jmp,ims,ime,coslprcp,cr1d3(no)) !persistent prd
       write(45) prd
c* construct prediction for sst
      call ca_prd_sst_spc(11,ntt,ntgt,nhs,imsst,jmsst,
     &        alpha,sst_t3,sst_prd,coslsst,ngrd,modemax,undef)
c      call ca_prd_sst_grd(11,ntt,ntgt,nhs,imsst,jmsst,alpha,
c    &                 sst_t3,sst_prd)
       call f2d_2_f3d(imsst,jmsst,ntt-2,no,sst_prd,sst_prd3d)
       call f2d_2_f3d(imsst,jmsst,ntt-2,no,sst_t3,sst_obs3d2)
c      call rmsd1(t3,prd,imp,jmp,ims,ime,coslprcp,cr1d2(no))
c      call rmsd1(t3,obs,imp,jmp,ims,ime,coslprcp,cr1d3(no)) !persistent prd
       write(46) prd
      enddo   !loop over target years
c
c* write out corr
c
      call corr_2d(imp,jmp,ntt-2,obs3d2,prd3d,corr)
      write(50) corr   !ca prd for prcp
c
      call corr_2d_sst(imsst,jmsst,ntt-2,sst_obs3d2,
     &                 sst_prd3d,fld2d)
      write(51) fld2d  !ca prd for SST
      call corr_2d_sst(imsst,jmsst,ntt-2,sst_obs3d2,
     &                 obs3d,fld2d)
      write(51) fld2d  !persistency prd for SST
c     call corr_2d(imp,jmp,ntt-2,obs3d,ca3d,corr)
c     write(50) corr   !ca for IC month
c     call corr_2d(imp,jmp,ntt-2,obs3d2,obs3d,corr)  !persistent prd
c     write(50) corr   !persistent prd
c
      write(6,*) 'spatial ac of ca_ic'
      write(6,100) cr1d
      write(6,*) 'spatial ac of ca_prd'
      write(6,100) cr1d2
      write(6,*) 'spatial ac of persistent prd'
      write(6,100) cr1d3
c
      write(55) cr1d2
c     write(55) cr1d
c     write(55) cr1d3
c
C*********************************************
100   format(12f6.2)
c100   format(1h ,i6,10f6.2)
102   format(1h ,i6,3f6.2,i6)
103   format()
120   format(2i8)
121   format(2i8,' month+1,month')
1100   format(i4,12i5)
1102   format(2i4,12i6)
1104   format(1h ,12f6.1)
1105   format(1h ,i4,12f6.1)
1106   format(1h ,12f6.1,' obs us ave')
1112   format(1h ,2i5,f7.3)
307    format(1h ,'natural analogues')
308    format(1h ,'constructed analogue')
      stop
      end
c*
      subroutine ca_prd(iu,ntt,ntgt,nhs,im,jm,alpha,obs,prd)
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
c
      subroutine ca_prd_sst_spc(iu,ntt,ntgt,nhs,im,jm,alpha,obs,
     &           prd,coslsst,ngrd,modemax,undef)
      dimension aaa(ngrd,nhs),WK(nhs,ngrd)
      dimension ana(modemax,nhs+1),anac(modemax)
      dimension EVAL(nhs),EVEC(ngrd,nhs),PC(nhs,nhs)
      dimension e(modemax,im,jm),coslsst(jm)
      dimension fld2d(im,jm),fld3d(im,jm,nhs)
      dimension obs(im,jm),prd(im,jm),alpha(nhs)
      id=0
      do nt=1,ntt !have historical given month data for constructing prd
          read(iu,rec=nt) fld2d
          if(nt.eq.ntgt) go to 666
          if(nt.eq.ntgt-1) go to 666
          if(nt.eq.ntgt+1) go to 666
          id=id+1
          do i=1,im
          do j=1,jm
            fld3d(i,j,id)=fld2d(i,j)
          enddo
          enddo
 666      continue
      enddo
        call anom_clim_sst(im,jm,nhs,nhs,fld3d,fld2d,undef)
        read(iu,rec=ntgt) obs
        do i=1,im
        do j=1,jm
          obs(i,j)=obs(i,j)-fld2d(i,j)
        enddo
        enddo
c* input data for EOF analysis
        do it=1,nhs
          id=0
          do j=1,jm
          do i=1,im
          if(abs(fld3d(i,j,it)).lt.50) then
            id=id+1
            aaa(id,it)=fld3d(i,j,it)*sqrt(COSLSST(j))
          end if
          end do
          end do
        enddo
c       
      call eofs_4_ca(aaa,ngrd,nhs,nhs,eval,evec,pc,wk,0)
c
      write(6,*) 'eval=',eval
c* have 2D EOF 
c
        do nm=1,modemax
        ng=0
        do j=1,jm
        do i=1,im
          if(abs(obs(i,j)).lt.50) then
          ng=ng+1
           e(nm,i,j)=evec(ng,nm)
          else
           e(nm,i,j)=undef
          endif
        end do
        end do
        end do
C* standardize spatial patterns to unity****
        do m1=1,modemax
        call inprod1_sst(im,jm,modemax,e,coslsst,m1,m1,anorm,
     &                   undef,obs)
c       write(6,*)m1,anorm
        do i=1,im
        do j=1,jm
         if(abs(obs(i,j)).lt.50) then
          e(m1,i,j)=e(m1,i,j)/sqrt(anorm)
         end if
        end do
        end do
        call inprod1_sst(im,jm,modemax,e,coslsst,m1,m1,anorm,
     &                   undef,obs)
c       write(6,*)m1,anorm
        do i=1,im
        do j=1,jm
          fld2d(i,j)=e(m1,i,j)
        end do
        end do
c       write(30) fld2d ! write out eof
        enddo
C* project "historical data" onto current eof's*******
        do nt=1,nhs
        call f3d_2_f2d(im,jm,nhs,nt,fld2d,fld3d)
        do nmode=1,modemax
        call inprod4_sst(e,fld2d,im,jm,coslsst,nmode,modemax,
     &                     anorm)
          ana(nmode,nt)=anorm
        enddo
c       write(6,100)nj,(ana(nmode,nj),nmode=1,10)
        enddo
c
       do nmode=1,modemax
         anac(nmode)=0.
       enddo
       do nmode=1,modemax
       do ntime=1,nhs
         anac(nmode)=anac(nmode)+ana(nmode,ntime)*alpha(ntime)
       enddo
       enddo
C
       do i=1,im
       do j=1,jm
         prd(i,j)=0.
       enddo
       enddo
       do nmode=1,modemax
       do i=1,im
       do j=1,jm
        if(abs(e(nmode,i,j)).lt.50) then
         prd(i,j)=prd(i,j)+anac(nmode)*e(nmode,i,j)
        else
         prd(i,j)=undef
        end if
       enddo
       enddo
       enddo
c
      return
      end
c*
      subroutine ca_prd_sst_grd(iu,ntt,ntgt,nhs,im,jm,alpha,obs,prd)
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
        call anom_clim_sst(im,jm,nhs,nhs,fld3d,wk,-999.0)
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
         if(abs(fld3d(i,j,nt)).lt.50) then
          prd(i,j)=prd(i,j)+fld3d(i,j,nt)*alpha(nt)
         endif
        enddo
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
      subroutine anom_clim_sst(im,jm,ntt,nys,fld3d,fld2d,undef)
      dimension fld3d(im,jm,ntt),fld2d(im,jm)
        xnys=float(nys)
        do i=1,im
        do j=1,jm
          fld2d(i,j)=0.
        enddo
        enddo
        do it=1,nys
        do i=1,im
        do j=1,jm
         if(abs(fld3d(i,j,it)).lt.abs(undef/xnys)) then
          fld2d(i,j)=fld2d(i,j)+fld3d(i,j,it)/xnys
         endif
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
      subroutine corr_2d_sst(im,jm,n,obs,prd,corr)
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
      if(abs(obs(i,j,1)).lt.50) then
       corr(i,j)=xy/(sqrt(x)*sqrt(y))
      else
       corr(i,j)=-999.0
      endif
      enddo
      enddo
c     write(6,101) corr
101   format(1h ,10f7.2)
      return
      end
*
      subroutine inprod1_sst(im,jm,mmx,e,cosl,m1,m2,anorm,
     & undef,refer)
c* inner product in space among eofs of length n
      dimension e(mmx,im,jm),refer(im,jm)
      dimension cosl(jm)
      x=0.
      do i=1,im
      do j=1,jm
      if(abs(refer(i,j)).lt.50) then
      x=x+e(m1,i,j)*e(m2,i,j)*cosl(j)
      end if
      enddo
      enddo
      anorm=x
      return
      end
c
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
      subroutine inprod4_sst(e,academic,im,jm,cosl,m1,modemax,
     &                       anorm)
c* inner product in space among one eof and an academic anomaly
      dimension e(modemax,im,jm),academic(im,jm)
      dimension cosl(jm)
      x=0.
      y=0.
      do i=1,im
      do j=1,jm
      if(abs(e(m1,i,j)).lt.50) then
      cosw=cosl(j)
      x=x+e(m1,i,j)*academic(i,j)*cosw
      y=y+e(m1,i,j)*e(m1,i,j)*cosw
      end if
      enddo
      enddo
c     write(6,100)m1,x/y
      anorm=x/y
100   format(1h ,'ip4= ',i5,3f10.6)
      return
      end
c
      subroutine inprod4(e,academic,im,jm,cosl,m1,modemax,anorm)
c* inner product in space among one eof and an academic anomaly
      dimension e(modemax,im,jm),academic(im,jm)
      dimension cosl(jm)
      x=0.
      y=0.
      do i=1,im
      do j=1,jm
      cosw=cosl(j)
      x=x+e(m1,i,j)*academic(i,j)*cosw
      y=y+e(m1,i,j)*e(m1,i,j)*cosw
      enddo
      enddo
c     write(6,100)m1,x/y
      anorm=x/y
100   format(1h ,'ip4= ',i5,3f10.6)
      return
      end
c
      subroutine rmsd1(anom,anomp,im,jm,ims,ime,cosl,zc)
      dimension anomp(im,jm),anom(im,jm)
      dimension cosl(jm)
      x=0.
      y=0.
      z=0.
      zc=0.
      w=0.
      do i=ims,ime
c     do i=1,im
      do j=1,jm
      cosw=cosl(j)
      w=w+cosw
      x=x+anom(i,j)*anom(i,j)*cosw
      y=y+anomp(i,j)*anomp(i,j)*cosw
      z=z+(anomp(i,j)-anom(i,j))*(anomp(i,j)-anom(i,j))*cosw
      zc=zc+anomp(i,j)*anom(i,j)*cosw
      enddo
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
c     do i=1,im
      do j=1,jm
      cosw=cosl(j)
      w=w+cosw
      x=x+anom(i,j)*cosw
      y=y+anomp(i,j)*cosw
      z=z+(anom(i,j)-anomp(i,j))*cosw
      enddo
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
