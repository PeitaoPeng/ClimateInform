
c    67  1         2         3         4         5         6         7 2
c* This does a CCA analysis on a given set of data.  This is for
c* specification using data from only one time (the specified time). 
c* The modes are written out, and for all times the observed and
c* predicted specification are written out.
c* The output files are labeled with the season or month.
c* Inputs:  pdodat.....predictor data set, dimensions (npdor,ntim)
c*          pdadat.....predictand data set, dimensions (ndnd,ntim)
c*          wdor.......weights for the predictors, dimension (npdor)
c*          wdnd.......weights for the predictands, dimension (ndnd)
c*          npdor......the number of predictors
c*          ndnd.......the number of predictands
c*          ntim.......the number of time steps
c*          ntfc.......the number of forecast times
c*          num........the maximum number of modes to use
c*
c* Results are written directly to files and are as follows.
c* Outputs: predictor modes.....written to units 61, 62, ..., one
c                               for each mode
c*          predictor time series, predictand modes, eigenvalues...
c                          .....all written to unit 12
c*          prediction and verification for independent data: unit 8
c*
c* Parameters in the subroutine must set the predictor, predictand,
c* and time dimension size to at least npdor, ndnd, and ntim.  Both
c* npdor and ndnd must be greater or equal to ntim for a work array
c* in subroutine cca.  NOTE: It's wise to set them larger (by 20%) 
c* than in the main program. Also in subroutine cca parameter nsst 
c* must be set to match that in the main code.
c*
c* Set ifld = 0 (GCM only),  ifld = 1 (SST only),  ifld = 2 (SST+GCM).!choose
c                                                           ! predictor fields
cx    parameter(nsst=796,ndnd=327,npdor=nsst+ndnd,ntim=43)
c   ===pick desired predictand dimensionality; check to see if subrout also okay
c     parameter(nsst=796,ndnd=133,npdor=nsst+327,ntim=45)  !for NH pna diamond
      parameter(nsst=796,ndnd=197,npdor=nsst+327,ntim=45)  !for reanl, pna
c     parameter(nsst=796,ndnd=203,npdor=nsst+327,ntim=45)  !for reanl, NH,SH
c     parameter(nsst=796,ndnd=288,npdor=nsst+327,ntim=45)  !for reanl, tropics
c     parameter(nsst=796,ndnd=417,npdor=nsst+327,ntim=45)  !for reanl, globe
cx    parameter(numo=28,numi=6,ifld=1) !# pdor,pdand eofs
      parameter(numo=6,numi=6,ifld=1) !# pdor,pdand eofs  ==== set # of modes
      real pdodat(npdor,ntim),pdadat(ndnd,ntim),wdor(npdor),wdnd(ndnd)
      real pdodxv(npdor,ntim),pdadxv(ndnd,ntim),wk(npdor)
      character cmo(12)*3,type*4,modes*4,path2*31
c* Weight by number of points, with model wgt = 1.  Only use if the
c* GCM model is used as a predictor.
      data wdor/npdor*1.0/,wdnd/ndnd*1.0/
      data cmo/'djf','jfm','fma','mam','amj','mjj',
     *         'jja','jas','aso','son','ond','ndj'/
      data type/'xtmp'/,modes/'28_6'/
      data path2/'/export/sgi25/wd52ts/amip/data/'/
      call print(1)
c
c* Read in the p-dnd area weights, scale so largest = 1.0
c      open(16,file='data/cca.poga.lat.lon.wgt')
c      amax=-1.e9
c      do n=1,ndnd
c       read(16,42) wdnd(n)
c       if(wdnd(n).gt.amax)amax=wdnd(n)
c      end do
c      do n=1,ndnd
c       wdnd(n)=wdnd(n)/amax
c       wdor(n)=wdnd(n)
c      end do
c      print*, 'Max pdnd wgt = ',amax
c* Read in the SST p-dor cos(lat).
c      do n=ndnd+1,ndnd+nsst
c       read(16,42) wdor(n)
c      end do
c      close(16)
c 42   format(20x,f10.3)
c
c* Adjust the weights so that they retain the variance within each fld.
c      asum=0.0
c      asum2=0.0
c      do n=1,ndnd
c       asum2=asum2+wdnd(n)
c       wdnd(n)=sqrt(wdnd(n))
c       asum=asum+wdnd(n)
c      end do
c      ssum=0.0
c      ssum2=0.0
c      do n=ndnd+1,ndnd+nsst
c       ssum2=ssum2+wdor(n)
c       wdor(n)=sqrt(wdor(n))
c       ssum=ssum+wdor(n)
c      end do
c* The defalt case: SST+GCM predictor.
c      vv=sqrt(real(nsst+ndnd)/2.)
c      v1=vv/sqrt(ssum2)
c      v2=vv/sqrt(asum2)
c      do n=ndnd+1,ndnd+nsst
c       wdor(n)=v1*wdor(n)
c      end do
c      do n=1,ndnd
c       wdnd(n)=v2*wdnd(n)
c       wdor(n)=wdnd(n)
c      end do
c
c* The case of GCM only predictor:
      if(ifld.eq.0)then
       do n=1,nsst
        wdor(n)=0.0  !weights of predictor
       end do
      endif
c* The case of SST only predictor: ! set gcm wts to 0
      if(ifld.eq.1)then
       do n=nsst+1,npdor
        wdor(n)=0.0
       end do
      endif
c
      do 1000 mon=02,02  ! season   ===choose season
c
       do iu=8,66
        close(iu)
       end do
c* Input: Pdnd file 1950-92 (43 yrs), Pdor file 1951-94 (44 yrs).
c      open(25,file='data/cca.pdnd.'//cmo(mon))
c      open(25,file=path2//'cca.pdnd.'//cmo(mon))
c      open(25,file='cca.pdnd55.'//cmo(mon))
cx     open(25,file='cca.pdnd13355.'//cmo(mon))
c      open(25,file='cca.dnd.'//cmo(mon)) !usual, dand
c   ===pick desired predictand file (including season designation)
       open(25,file='/disk11/cpcpred/wd51ab/echam/z5obpnjfm1390')  !reanal pna
c      open(25,file='/disk11/cpcpred/wd51ab/echam/z5obshjfm1390')  !reanal NH,SH
c      open(25,file='/disk11/cpcpred/wd51ab/echam/z5obtrjfm1390')  !reanal trop
c      open(25,file='/disk11/cpcpred/wd51ab/echam/z5objfm1390')  !reanal glob
c      open(25,file='cca.dnd56.'//cmo(mon)) !used occasionally ('56=1st dand yr)
cx     open(31,file=path2//'cca.pdorsst.'//cmo(mon))
c      open(31,file='cca.pdorsst.'//cmo(mon+0))  ! use "+0" for specification
       open(31,file='cca.pdorsst37.'//cmo(mon+0))  ! always use "+0" (Peitao)
c      open(31,file='cca.pdorsst41.'//cmo(mon+9))  ! use "+9" pred; only 41 yrs
c* Output:
c      open(8,file=type//'/semp.'//modes//'.'//cmo(mon)) ! output
       open(8,file='semp')
c      open(8,file='semp2m.'//cmo(mon))
c       open(12,file=type//'/ccaout.'//cmo(mon)) ! cca time series,dand map
c       open(61,file=type//'/sdorm1.'//cmo(mon)) !sst mode 1
c       open(62,file=type//'/sdorm2.'//cmo(mon)) !sst mode 2
c       open(63,file=type//'/sdorm3.'//cmo(mon))
c       open(64,file=type//'/sdorm4.'//cmo(mon))
c       open(65,file=type//'/sdorm5.'//cmo(mon))
c       open(66,file=type//'/sdorm6.'//cmo(mon))
c
c* Read in the (setup) predictor data, skip last two years.
      read(31,86) nyrs,nstn
c
 86   format(8x,i3,8x,i4)
      backspace 31
c     iskip=3
c     nyrs=nyrs-iskip
      do 22 j=1,nyrs
c      if(j.eq.1)then    ! skip iskip years at the beginning
c           do 118 irep=1,iskip
c118        read(31,26)(pdodat(i,j),i=1,nstn)
c      end if
       read(31,26)(pdodat(i,j),i=1,nstn)
c      write(6,26)(pdodat(i,j),i=1,nstn)
 22   continue
 26   format(/350(20f6.2/))
      do iyy=1,nyrs
      write(6,107)iyy
 107  format('iyy=',i4)
       read(25,105,end=94) (pdadat(nr,iyy),nr=1,ndnd)
       if(iyy.le.2.or.iyy.eq.nyrs)write(6,105)(pdadat(nr,iyy),nr=1,ndnd)
      end do
c   ===pick desired format for predictand
c105  format(6x,19f6.2,20(/20f6.2))   ! Tom's predictand data format
 105  format(/,90(10f7.1/))   ! Reanalysis data; Peitao/Arun CCA
c105  format(/,90(5(7x,f7.1)/))   ! Reanalysis data; Peitao/Arun CCA; skips 1/2
c105  format(/,138(3(7x,f7.1,7x)/),3(7x,f7.1,7x)) ! Reanalysis data; skips .7
c     do 113 iyy=1,nyrs
c113  write(6,106)iyy,(pdadat(nr,iyy),nr=1,ndnd)
 106  format(i6,19f6.2,20(/20f6.2))
 94   continue
c* Loop through the data setting up the x-validation data set, 
c* renormalizing each time and calling the cca subroutine to get
c* the specification.
c* Open the file for results. 
       do 500 nx=1,nyrs
c* Get the data.
        ky=0
        do k=1,nyrs
         if(k.ne.nx)then
          ky=ky+1
          do i=1,nstn
           pdodxv(i,ky)=pdodat(i,k)
          end do
          do i=1,ndnd
           pdadxv(i,ky)=pdadat(i,k)
          end do
         else
          do i=1,nstn
           pdodxv(i,nyrs)=pdodat(i,nx)
          end do
          do i=1,ndnd
           pdadxv(i,nyrs)=pdadat(i,nx)
          end do
         endif
        end do
c* Get the cca-based specification.  Output is to unit 8 for the
c* predicted and observed every time.  For the last time statistical
c* data are written to units 12, 61, 62, ..., up to 60+m, m=# modes.
c* All normalization, etc. is done within the subroutine.
c       call cca(pdodxv,pdadxv,wdor,wdnd,npdor,ndnd,nyrs,
        call cca(pdodxv,pdadxv,nsst,wdor,wdnd,npdor,ndnd,nyrs,
     *           numo,numi,nx)
        if(mod(nx,1).eq.0) print*, ' Done for x-v year = ',nx
 500   continue
       print*, ' Done for ',cmo(mon)
 1000 continue
      stop
      end
c
c    67  1         2         3         4         5         6         7 2
c* This does a CCA analysis on a given set of data.  Input and outputs
c* are as follows.
c* Inputs:  pdodat.....predictor data set, dimensions (npdorc,ntim)
c*                     this has 1 extra time for the forecast.
c*          pdadat.....predictand data set, dimensions (ndndc,ntim)
c*          wdor.......weights for the predictors, dimension (npdorc)
c*          wdnd.......weights for the predictands, dimension (ndndc)
c*          npdorc.....the number of predictors
c*          ndndc......the number of predictands
c*          ntimc......the number of dependent time steps
c*          numeof.....the maximum number of modes to use
c*
c* Results are written directly to files and are as follows.
c* Outputs: predictor modes.....written to units 61, 62, ..., one
c                               for each mode
c*          predictor time series, predictand modes, eigenvalues...
c                          .....all written to unit 12
c*          prediction and verification for dependent period: unit 8
c*          prediction for independent period: unit 9
c*
c* Parameters in the subroutine must set the predictor, predictand,
c* and time dimension size to at least npdor, ndnd, and ntim.  Both
c* npdor and ndnd must be greater or equal to ntim for a work array
c* in cca.
c
c     subroutine cca(pdodat,pdadat,wdor,wdnd,npdorc,ndndc,ntimc,
      subroutine cca(pdodat,pdadat,nsst,wdor,wdnd,npdorc,ndndc,ntimc,
     *               numo,numi,nchk)
c     parameter(ntim=54,ndnd=600,nmod=60,npdor=1200,nsst=796)
      parameter(ntim=54,ndnd=600,nmod=60,npdor=1200)
      parameter(ncor=ndnd*(ndnd+1)/2)
      common/dv/dat(npdor,ndnd),var
      common/l/c(ncor)
      real dorvec(nmod,npdor),doramp(ntim,nmod),danvec(nmod,ndnd)
      real danamp(ntim,nmod),optdor(ntim,nmod),sfact(nmod,nmod)
      real skill(ntim,ndnd),skill2(ntim,ndnd),varsum(nmod)
      real ppaa(nmod),danmap(nmod,ndnd),ppbb(nmod),xlag(nmod,nmod)
      real xlagt(nmod,nmod),xx3(ndnd+ntim),b(nmod,nmod),xlam(nmod)
      real savz(ntim,ndnd),dormap(nmod,npdor),ev(ndnd+ntim+nmod)
      real eigvec(nmod,ndnd),a(npdor,nmod),varnc(nmod),doraf(ntim,nmod)
      real wdor(*),wdnd(*),optdof(ntim,nmod),pdodat(npdorc,*)
cc      real pdadat(ndndc,*),dat1(npdor),datmod(ndnd)
      real pdadat(ndndc,*),dat1(npdor),datmod(ntim,ndnd)
      character ciu(9)*1
      data ciu/'1','2','3','4','5','6','7','8','9'/
      data eps/1.e-06/,tol/1.e-30/,small/0.001/
      rewind(12)
      nstn=npdorc
      nyrs=ntimc-1
      icor=0
c* The weights specified as 0.0 will be raised to 0.001 below,
c* as easy way to keep dimensions while nearly zeroing them out.
      do i=1,nstn
       if(wdor(i).lt.0.000001)wdor(i)=0.001
      end do
      do i=1,ndndc
       if(wdnd(i).lt.0.000001)wdnd(i)=0.001
      end do
c initialize.
      do 231 j=1,nmod
      do 231 k=1,npdor
  231 dormap(j,k)=0.
c* Set the predictor data.
      np=nyrs
      do 22 j=1,nyrs
       do i=1,nstn
        dat(i,j)=pdodat(i,j)
       end do
 22   continue
c* Get the data for the independent prediction
      do i=1,nstn
       dat1(i)=pdodat(i,ntimc)
      end do
      nt=nstn
      do 32 j=1,nstn
       ii=0
       do 30 i=1,nyrs
        ii=ii+1
        xx3(ii)=dat(j,i)
 30    continue
       call stats(xx3,nyrs,-99999.0,nx,xbar,stdev,xmax,xmin)
       if(stdev.le.0.0)stdev=1.0
c* Anomalize the normalized predictors.
       do 31 ii=1,nyrs
        dat(j,ii)=wdor(j)*(xx3(ii)-xbar)/stdev
 31    continue
       dat1(j)=wdor(j)*(dat1(j)-xbar)/stdev
 32   continue
c* Save the model predictors for the verification (i=nsst+1,nstn).
c* Remove weights.
      do ntime=1,nyrs
      do i=nsst+1,nstn
       datmod(ntime,i-nsst)=dat(i,ntime)/wdor(i)
      end do
      end do
      do i=nsst+1,nstn
       datmod(ntimc,i-nsst)=dat1(i)/wdor(i)
c       datmod(i-nsst)=dat1(i)/wdor(i)
      end do
c* Estimate total field variance; var is computed from dat (both in
c* common); for predictor only, dat has dimensions: (points,years).
      call vvar(np,nt,icor)
c* Get correl/covar matrix c from dat (both in common).
      call cov(np,nt,icor)
c* Now orthogonalize (predictor eof).
      num=numo
      iu=11
c* Compute eigenvalues (ev), eigenvectors (to store on unit iu file).
      call ahouse(eps,tol,np,num,iu,ev,nev)
      write(12,703) nev,(ev(jkl),jkl=1,6)
  100 format(i3,'  MODES FOUND BY AHOUSE FOR PREDICTORS',
     $'.  TOT YRS=',i3,'  #SFCTMP STNS=',i3/)
  703 format(1x,'PREDICTOR EOF*S, NO.MODES(NEV)=',i2,' EVALS=',6f7.3)
c* Get eigenvectors(stored) and(compute) amplitude series (stand'ized).
      call evamp(np,nt,ev,eigvec,a,iu,nev)
c* Transform switched-eof results to normal-eof; var is normal total
c* field variance.
      var=var*(float(nt-1)/float(np-1))                                 
      dorvar=var                                                        
      ntsav=nt                                                          
c* Normal #time pts, one after that is normal #space pts.
      nt=np
      np=ntsav
c* Scaling constant.
      chat=float(nt)/float(np)
      chai=1.0/chat
      sum=0.0
c* Nev is number of predictor modes used.
      do 96 i=1,nev
      eve=float(np)*ev(i)
      const=1.0/sqrt(eve)
c* Get normal eigenvalue.
      ev(i)=chai*ev(i)
c* Compute normal variance accounted for.
      sum=sum+ev(i)
      sum1=100.0*sum/var
      sum2=100.0*ev(i)/var
c      write(8,6100)i,ev(i),sum2,sum1,var
 6100 format(4x,'MODE=',i3,'  EV   =',e12.3,14x,
     1 'VAR/CUM VAR=',2f8.1,'  TOT VAR=',e12.3)
c* Get normal eigenvector.
      do 33 j=1,np
       dorvec(i,j)=const*a(j,i)
   33 continue
   96 continue
c* Compute normal principal components (using normal eigenvec.).
c* Also get the normal forecast variable.
      do 34 i=1,nev
       do 36 m=1,nyrs
        sum=0.0
        do 37 n=1,np
         sum=sum+dorvec(i,n)*dat(n,m)
 37     continue
        doramp(m,i)=sum
        doraf(m,i)=sum
 36    continue
       sum=0.0
       do n=1,np
        sum=sum+dorvec(i,n)*dat1(n)
       end do
       doraf(ntimc,i)=sum
c* Normalize the principal components.
       call stats(doramp(1,i),nt,-99999.0,nx,xbar,stdev,xmax,xmin)
       if(stdev.le.0.0)stdev=1.0
       do m=1,nyrs
        doramp(m,i)=(doramp(m,i)-xbar)/stdev
       end do
       do m=1,ntimc
        doraf(m,i)=(doraf(m,i)-xbar)/stdev
       end do
 34   continue
c* SAVE PREDICTOR'S EIGEN-STUFF & ORIGINAL DATA.
      do 20 j=1,nev
       if(ev(j).gt.small)ppbb(j)=sqrt(ev(j))
   20 continue
c* Get predictands secondly for nq stations.
      nq=ndndc
c* Set the predictand data.
      do iyy=1,ntimc
       do nr=1,ndndc
        savz(iyy,nr)=pdadat(nr,iyy)
       end do
      end do
c* Get the normalized predictand data for ndnd stations, for all times
c* (put in the dat array).
      nt=nyrs
      do 52 j=1,ndndc
       do 51 i =1,nyrs
        xx3(i)=savz(i,j)
 51    continue
       call stats(xx3,nyrs,-99999.0,nx,xbar,stdev,xmax,xmin)
       if(stdev.le.0.0)stdev=1.0
       do 53 ii=1,nyrs
        dat(ii,j)=wdnd(j)*(xx3(ii)-xbar)/stdev
 53    continue
       dat(ntimc,j)=wdnd(j)*(savz(ntimc,j)-xbar)/stdev
 52   continue
c* Computation of field variance, var, uses dat (both in common);
c* var is not used in upcoming p'dand orthog'zation, since no
c* scale factor is needed for a time-space reversal (unlike p'dor).
      call vvar(nq,nyrs,icor)                                    
c* Dat uses dimensions (years, points) here, since no time-space
c* reversal as in predictor case.
      danvar=var
      call cov(nq,nyrs,icor)
c* Now orthogonalize (predictand eof).
      num=numi
      iu=11
      call ahouse(eps,tol,nq,num,iu,ev,mev)
c      write(8,101)mev
  101 format(9x,i3,'  MODES FOUND BY AHOUSE FOR PREDICTANDS'/)
      mevsav=mev
c* For predictand:
c* Get eigenvectors and (ampl.fns.) principal components.
      call evamp(nq,nyrs,ev,eigvec,a,iu,mev)
c* Normalize the principal components.
      do 54 i=1,mev                                                     
       call stats(a(1,i),nyrs,-99999.0,nx,xbar,stdev,xmax,xmin)       
       if(stdev.le.0.0)stdev=1.0                                        
       do 56 m=1,nyrs                                                   
        danamp(m,i)=(a(m,i)-xbar)/stdev                                 
 56    continue                                                         
 54   continue                                                          
c* Save predictand's eigen-stuff.
      do 7720 j=1,mev
       if(ev(j).gt.small)ppaa(j)=sqrt(ev(j))
       do 7715 i=1,nq
        danvec(j,i)=eigvec(j,i)
 7715  continue
 7720 continue
c* Define lag correlation matrix & transpose, for heart of cca.
      igo=1
      do 35 i=1,nev
      do 35 k=1,mev
       sum=0.0
       do 57 m=igo,nyrs
        sum=sum+doramp(m,i)*danamp(m,k)
   57  continue
       xlag(i,k)=sum/float(nyrs)
       xlagt(k,i)=xlag(i,k)
   35 continue
c* Multiply 2 matrices & store like cov. matrix.
      iii=0
      do 40 i=1,nev
      do 40 jj=i,nev
       iii=iii+1
       sum=0.0
       do 58 j=1,mev
        sum=sum+xlag(i,j)*xlagt(j,jj)
   58  continue
       c(iii)=sum
   40 continue
c* Set # of cca modes to # of prev*ly determ*d p*dand modes.  Note       
c* that ahouse uses min0(3rd,4th argumnt)--here, min0(num,nev2).        
      num=min0(mev,nev)                                                 
c* Compute eigen-values & -vectors.
      nev2=nev
      nevz=mev
      call eignmn(xlam,b,num,nev2,mev)
      write(12,3957) mev
 3957 format(1x,'---JUST PERFORMED CORE OF CCA ANALYSIS (AHOUSE,',
     $ ' THROUGH EIGNMN); MAX NO. CANON. MODES POSSIBLE =',i2)
C* Form optimal predictor t.s.
c      write(8,9014) mev
 9014 format(7x,i2,'  MODES FOUND BY AHOUSE FOR OPT.PREDICTORS')
c* Determine critical canonical cutoff mode.
      crit=.01*xlam(1)
      do 59 i=1,mev
       if(xlam(i).ge.crit) mevcrt=i
   59 continue
c* Write out sume eigen-stuff.
      write(12,7915)mevcrt,mev,(xlam(i),i=1,mev)
 7915 format(/,4x,i5,'  OUT OF ',i5,'  CANONICAL MODES USED',
     1       /,' LAMDA FOR C-HAT=',40f8.3)
      mev=mevcrt
      var=0.0
      do 61 i=1,mev
       if(xlam(i).gt.small)var=var+xlam(i)
 61   continue
      sum=0.0
      do 62 i=1,mev
       sum=sum+xlam(i)
       sum1=100.0*sum/var
       sum2=100.0*xlam(i)/var
       write(12,6100) i,xlam(i),sum2,sum1,var
 62   continue
c* Compute optimal (cca) predictor time series.  Also get the forecast
c* weights.
      kit=mev
      do 60 k=1,kit
       do 50 i=1,nyrs
        sum=0.0
        do 63 j=1,nev2
         sum=sum+doramp(i,j)*b(k,j)
   63   continue
        optdor(i,k)=sum
   50  continue
       sum=0.0
       do j=1,nev2
        sum=sum+doraf(ntimc,j)*b(k,j)
       end do
c       write(14,6967) k,sum
c 6967  format(2x,' FOR CCA MODE',i3,
c     $       ' X-VAL TIME OPTIMAL PDOR TIME COEF=',2x,f6.2)
       write(12,6968) k,(i,optdor(i,k),i=1,nyrs)
 6968  format(2x,' FOR CCA MODE',i3,
     $       ' OPTIMAL PREDICTOR TIME SERIES'/9(2x,10(i5,f6.2)/))
       do i=1,ntimc
        sum=0.0
        do j=1,nev2
         sum=sum+doraf(i,j)*b(k,j)
        end do
        optdof(i,k)=sum
       end do
c* Compute a scaling factor neaded to compute skill.
       do 55 j=1,nev2
        sum=0.0
        do 64 i=1,nyrs
         sum=sum+danamp(i,j)*optdor(i,k)
   64   continue
        if(xlam(k).gt.small) then
         sfact(j,k)=sum/(sqrt(xlam(k))*float(nyrs))
        else
         sfact(j,k)=0.0
        end if
   55  continue
   60 continue
c* Loop over stations, compute the CCA forecast for each.
      do 80 ireg=1,nq
       sksum=0.0
       sksum2=0.0
       do 70 i=1,ntimc
        sum=0.0
        do 66 k=1,kit
         sum2=0.0
         do 102 j=1,nevz
          sum2=sum2+ppaa(j)*sfact(j,k)*danvec(j,ireg)
 102     continue
         if(xlam(k).gt.small)sum=sum+sqrt(xlam(k))*optdof(i,k)*sum2
 66     continue
        skill(i,ireg)=sum
        skill2(i,ireg)=dat(i,ireg)/wdnd(ireg)
 70    continue
c* Compute the predictand maps in their original geographical space.
       do 76 k=1,kit
        sum=0.
        do 75 j=1,mev
         tum2=0.0
         do 67 i=1,nt
          tum2=tum2+optdor(i,k)*danamp(i,j)
 67      continue
         danmaj=ppaa(j)*tum2*danvec(j,ireg)/float(nt)
         sum=sum+danmaj
 75     continue
        danmap(k,ireg)=sum
 76    continue
 80   continue
c* Print out the predictand map for each canon mode.
      do 1321 k=1,kit
 1321 varsum(k)=0.
      do 1323 k=1,kit
       varnc(k)=0.
       do 1319 nsta=1,nq
 1319  varnc(k)=varnc(k)+danmap(k,nsta)*danmap(k,nsta)
       if(k.eq.1)varsum(k)=varnc(k)
 1323 if(k.ge.2)varsum(k)=varsum(k-1)+varnc(k)
      do 1320 k=1,kit
       sum1=varnc(k)*100./danvar
       sum2=varsum(k)*100./danvar
 1320 write(12,1322) k,varnc(k),kit,sum1,sum2,varsum(k)
 1322 format(2x,'CANON PDAND MAP VAR-CCA MODE',i2,f8.3,                 
     $ ' ..OF',i3,' MODES, %VAR,CUM=',2f6.2,'   VARCUM=',f9.3)          
      write(12,734) kit
  734 format(2x,'  PREDICTAND MAP FOR THE',i2,' CANONICAL MODES')
      do 735 k=1,kit
       write(12,736)k,ndndc,(ireg,danmap(k,ireg),ireg=1,ndndc)
  736  format(2x,'PRINC PDAND MAP, MODE',i2,' FOR THE',i3,
     $        ' SFC T STNS'/200(1x,10(i4,f7.3)/))
  735  continue
c* Compute the predictor modes in their original geographical space.
      do 180 msta=1,np                                                  
       do 176 k=1,kit                                                   
        sum=0.                                                          
        do 175 j=1,nev                                                  
         tum=0.0                                                        
         do 69 i=1,nt                                                   
          tum =tum +optdor(i,k)*doramp(i,j)                             
   69    continue                                                       
         dormaj=ppbb(j)*tum *dorvec(j,msta)/float(nt)                   
         sum=sum+dormaj                                                 
  175   continue                                                        
        dormap(k+20,msta)=dormap(k+20,msta)+sum                         
        dormap(k,msta)=sum                                              
  176  continue                                                         
  180 continue                                                          
c* Compute variance of principal predictor map for each canon mode.
      do 5321 k=1,kit
 5321 varsum(k)=0.
      do 5318 k=1,kit
       varnc(k)=0.
       do 5319 msta=1,np
 5319  varnc(k)=varnc(k)+dormap(k,msta)*dormap(k,msta)
       if(k.eq.1)varsum(k)=varnc(k)
 5318 if(k.ge.2)varsum(k)=varsum(k-1)+varnc(k)
      do 5320 k=1,kit
       sum1=varnc(k)*100./dorvar
       sum2=varsum(k)*100./dorvar
 5320 write(12,5322)k,varnc(k),kit,sum1,sum2,varsum(k)
 5322 format(2x,'CANON PDOR MAP VAR-CCA MODE',i2,f9.3,
     $ ' ..OF',i3,' MODES, %VAR,CUM=',2f6.2,'   VARCUM=',f10.3)
c* Print out the predictor modes to unit 61, 62, ... for mode 1, 2, ...
      if(nchk.eq.ntimc)then
       do 87 k=1,kit
       iusst=60+k
       do 87 ipt=1,nstn
        write(iusst,85) dormap(k,ipt)
 85     format(f8.2)
 87    continue
      endif
c* Print out the prediction, observed, and model values for each time.
      write(8,41) nchk,(skill(ntimc,i),i=1,ndndc) ! zhat
c     write(8,42)      (datmod(ntimc,i),i=1,ndndc)! model
      write(8,43)      (skill2(ntimc,i),i=1,ndndc)! obs
c      do n=1,ntimc
c      write(8,41)    n,(skill(n,i),i=1,ndndc)
c      write(8,42)      (datmod(n,i),i=1,ndndc)
c      write(8,43)      (skill2(n,i),i=1,ndndc)
c      end do
 41   format('ZHAT K=',i2,15f6.3/30(9x,15f6.3/))
 42   format('MODEL-Z  ',15f6.3/30(9x,15f6.3/))
 43   format('REAL-Z   ',15f6.3/30(9x,15f6.3/))
      return                                                              
      end                                                               
c
C SUBR. WILL COMPUTE MEAN AND STD. DEV. OF A TIME SERIES                
C CHECK WILL BE MADE FOR MISSING DATA                                   
C   TS     IS THE TIME SERIES                                           
C   NDIM   IS THE NO. OF PTS. IN TS                                     
C   XMISNG IS VALUE FOR MISSING DATA IN TS                              
C   NX     IS NO. OF PTS. IN TS NOT EQUAL TO XMISNG                     
C   XBAR   IS MEAN OF TS (OVER NX PTS.)                                 
C   STDEV  IS STANDARD DEVIATION OF TS                                  
C   XMAX IS MAX VALUE IN TIME SERIES                                    
C   XMIN IS MIN VALUE IN TIME SERIES                                    
      subroutine stats( ts,ndim,xmisng,nx,xbar,stdev,xmax,xmin)         
      dimension ts(ndim)                                                
      x=0.0                                                             
      xx=0.0                                                            
      nx=0                                                              
      xmax=-99999.0                                                     
      xmin= 99999.0                                                     
      do 10 i=1,ndim                                                    
      if(ts(i).eq.xmisng)go to 10                                       
      if(ts(i).gt.xmax)xmax=ts(i)                                       
      if(ts(i).lt.xmin)xmin=ts(i)                                       
      nx=nx+1                                                           
      x=x+ts(i)                                                         
      xx=xx+ts(i)*ts(i)                                                 
   10 continue                                                          
      xbar=999.                                                         
      stdev=-999.999                                                    
      if(nx.eq.0)go to 20                                               
      xbar=x/nx                                                         
      if(nx.eq.1)go to 20                                               
      stdev=(nx*xx-x*x)/(nx*(nx-0.0))                                   
      if(stdev.ge.0.0)stdev=sqrt(stdev)                                 
   20 return                                                            
      end                                                               
c                                                                       
C DIMENSION C AS (PDAND PTS)(SAME+1)/2  (2485 IS FOR 70 PDAND PTS)      
      subroutine cov(np,nt,icor)                                        
      parameter (npdor=1200,ndnd=600,ncor=ndnd*(ndnd+1)/2)                                  
      common/dv/dat(npdor,ndnd),var                                    
      common/l/c(ncor)                                                  
      i=0                                                               
      do 1 n=1,np                                                       
      do 1 nn=n,np                                                      
      s=0.                                                              
      ss=0.                                                             
      sss=0.                                                            
      i=i+1                                                             
      do 2 m=1,nt                                                       
      s=s+dat(m,n)*dat(m,nn)                                            
      ss=ss+dat(m,n)**2                                                 
 2      sss=sss+dat(m,nn)**2                                            
      if(icor.eq.1)c(i)=s/(sqrt(ss)*sqrt(sss))                          
      if(icor.eq.0)c(i)=s/float(nt-1)                                   
 1      continue                                                        
cc      print 10                                                        
 10      format('    return from cov  ')                                
      return                                                            
      end                                                               
C                                                                       
      subroutine evamp(np,nt,ev,eigvec,a,iu,nev)                        
      parameter (npdor=1200,ndnd=600,ntim=54,nmod=60)                   
      dimension ev(ndnd+ntim+nmod),eigvec(nmod,ndnd),a(npdor,nmod)     
      dimension vr(nmod)                                                
      common/dv/dat(npdor,ndnd),var                                    
      rewind iu                                                         
      if(np.eq.2)go to 87                                               
      do 1 i=1,nev                                                      
 1      read(iu,883)(eigvec(i,n),n=1,np)                                
 883  format(10e12.5)                                                   
 87      continue                                                       
      do 2 i=1,nev                                                      
      do 2 m=1,nt                                                       
 2      a(m,i)=0.                                                       
      do 4 i=1,nev                                                      
      do 5 m=1,nt                                                       
      do 6 n=1,np                                                       
      a(m,i)=a(m,i)+eigvec(i,n)*dat(m,n)                                
 6      continue                                                        
 5      continue                                                        
 4      continue                                                        
      ishiz=0                                                           
      if(ishiz.ne.1)go to 8888                                          
c                                                                       
c* normalize the principal components                                   
      do 20 i=1,nev                                                     
      s=0.                                                              
      do 21 m=1,nt                                                      
 21      s=s+a(m,i)                                                     
      s=s/float(nt)                                                     
      ss=0.                                                             
      do 22 m=1,nt                                                      
 22      ss=ss+(a(m,i)-s)**2                                            
      ss=sqrt(ss/float(nt-1))                                           
      vr(i)=ss                                                          
      do 23 m=1,nt                                                      
 23      a(m,i)=(a(m,i)-s)/ss                                           
 20      continue                                                       
 8888 continue                                                          
      s=0.                                                              
      do 10 i=1,nev                                                     
      s=s+ev(i)                                                         
      s1=100.*s/var                                                     
      s2=100.*ev(i)/var                                                 
cc        print 100,i,ev(i),vr(i),s2,s1,var                             
 10      continue                                                       
 100     format(5x,'mode=',i3,'  ev/vr=',2e12.3,'  var/cum var=',2f8.1, 
     1  '  tot var=',e12.3)                                             
cc      write(12,101)                                                    
 101      format(///)                                                   
cc      print 102                                                       
 102      format('  returned from evamp  ')                             
c next card (8888) is jump address for skip normalizing and prints      
cc 8888 continue                                                        
      return                                                            
      end                                                               
C                                                                       
      subroutine vvar(np,nt,icor)                                  
      parameter (npdor=1200,ndnd=600)                          
      common/dv/dat(npdor,ndnd),var                                    
      var=0.                                                            
      if(icor.eq.1)then                                                 
       var=float(np)                                                    
       return                                                           
      endif                                                             
      do 1 n=1,np                                                       
       s=0.                                                             
       do 2 m=1,nt                                                      
 2     s=s+dat(m,n)**2                                                  
       var=var+s/float(nt-1)                                            
 1    continue                                                          
c      write(8,10)var                                               
c 10   format('   RETURN FROM VVAR***  VAR= ',e12.3)                     
      return                                                            
      end                                                               
c                                                                       
      subroutine eignmn(xlam,b,num,nev,mev)                             
      parameter(ndnd=600,ntim=54,nmod=60,ncor=ndnd*(ndnd+1)/2)                                  
c dimension c as (pdand pts)(same+1)/2  (2485 is for 70 pdand pts)      
      common/l/c(ncor)                                                  
      dimension xlam(nmod),blam(ndnd+ntim+nmod)                         
      dimension b(nmod,nmod),astar(2,2)                                 
      eps=1.e-06                                                        
      tol=1.e-30                                                        
      iu=11                                                             
      rewind iu                                                         
      if(nev.gt.2)go to 89                                              
      astar(1,1)=c(1)                                                   
      astar(2,2)=c(3)                                                   
      astar(2,1)=c(2)                                                   
      astar(1,2)=c(2)                                                   
      call tobyto(astar,b,xlam)                                         
      mev=2                                                             
      go to 88                                                          
 89      call ahouse(eps,tol,nev,num,iu,blam,mev)                       
cc        print 100,num,mev                                             
      rewind iu                                                         
      do 2 i=1,mev                                                      
        xlam(i)=blam(i)                                                 
 2      read(iu,884)(b(i,j),j=1,nev)                                    
 884  format(10e12.5)                                                   
      rewind iu                                                         
 88      continue                                                       
 100       format(/5x,'num=',i4,'  mev=',i4)                            
  189 continue                                                          
cc 189      print 10                                                    
 10      format('  got eigenstuff for c-hat')                           
c                                                                       
c      check                                                            
      do 300 i=1,nev                                                    
      s=0.                                                              
      do 201 j=1,nev                                                    
 201      s=s+b(i,j)*b(i,j)                                             
cc      print 202,xlam(i),s                                             
 202      format(10x,'xlam(i)=',f10.3,5x,'check=',f10.3)                
  300 continue                                                          
      return                                                            
      end                                                               
c                                                                       
C      SEE DESCRIOPTION OF 'AHOUSE' IN PROGRAM 'REGSL.FOR'              
C******SUGGEST YOU DON'T MESS WITH THIS CODE                            
C                                                                       
C  *  EIGENVECTORS ARE WRITTEN TO UNIT NO. IU                           
C DIMENSION C AS (PDAND PTS)(SAME+1)/2  (2485 IS FOR 70 PDAND PTS)      
      subroutine ahouse(eps,tol,n,num,iu,ev,nev)                        
      parameter(npdor=1200,ndnd=600,ntim=54,nmod=60)
      parameter (ncor=ndnd*(ndnd+1)/2)
      common/l/c(ncor)                                                  
      dimension   a(npdor),b(npdor),p(npdor),ta(npdor),v(npdor),   
     1  w(npdor),y(npdor),x(npdor),tb(npdor)                        
      dimension ev(ndnd+ntim+nmod)                                      
      num=min0(num,n)                                                   
      umeps=1.-eps                                                      
      jskip=0                                                           
      kskip=0                                                           
      nm1=n-1                                                           
      i=1                                                               
      idm1=0                                                            
c     p(1)=v(1)=w(1)=0.0                                                
      p(1)=0.0                                                          
      v(1)=0.0                                                          
      w(1)=0.0                                                          
 4    ip1=i+1                                                           
      nmi=n-i                                                           
      kj=idm1                                                           
      j=i                                                               
 5    jp1=j+1                                                           
      vj=v(j)                                                           
      k=j                                                               
      lj=n-j+1                                                          
      jd=kj+1                                                           
      if(i.eq.1)go to 6                                                 
      pj=p(j)                                                           
      wj=w(j)                                                           
 6    kj=kj+1                                                           
      ckj=c(kj)                                                         
      if(i.eq.1)go to 7                                                 
      if(kskip.eq.1)go to 7                                             
      dc=-(pj*w(k)+wj*p(k))                                             
      ckj=dc+ckj                                                        
      c(kj)=ckj                                                         
 7    if(j.gt.i)go to 14                                                
      if(k.gt.j)go to 8                                                 
      a(i)=ckj                                                          
      k=k+1                                                             
      go to 6                                                           
 8    y(k)=0.0                                                          
      v(k)=ckj                                                          
      k=k+1                                                             
      if(k.le.n)go to 6                                                 
      jskip=0                                                           
      lj1=lj-1                                                          
      sum=dot(v(jp1),v(jp1),lj1)                                        
      if(sum.le.tol)go to 10                                            
      s=sqrt(sum)                                                       
      csd=v(jp1)                                                        
      if(csd.lt.0.0)s=-s                                                
      v(jp1)=csd+s                                                      
      c(jd+1)=v(jp1)                                                    
      h=sum+csd*s                                                       
      b(i)=-s                                                           
      go to 12                                                          
 10   b(i)=0.0                                                          
      jskip=i                                                           
 12   idm1=kj                                                           
      j=jp1                                                             
      go to 5                                                           
 14   if(jskip.eq.0)go to 15                                            
      k=k+1                                                             
      if(k.le.n)go to 6                                                 
      j=jp1                                                             
      if(j.le.n)go to 5                                                 
      go to 215                                                         
 15   y(k)=y(k)+ckj*vj                                                  
      k=k+1                                                             
      if(k.le.n)go to 6                                                 
      if(j.eq.n)go to 17                                                
      lj1=lj-1                                                          
      do 1099 kq=1,lj1                                                  
 1099 x(kq)=c(jd+kq)                                                    
      y(j)=y(j)+dot(x,v(jp1),lj1)                                       
      j=jp1                                                             
      go to 5                                                           
 17   sp=dot(v(ip1),y(ip1),nmi)/(h+h)                                   
      do 21 j=ip1,n                                                     
      w(j)=v(j)                                                         
 21   p(j)=(y(j)-sp*v(j))/h                                             
 215  kskip=jskip                                                       
      i=ip1                                                             
      if(i.le.nm1)go to 4                                               
      a(n)=ckj                                                          
      b(nm1)=-b(nm1)                                                    
      b(n)=0.0                                                          
      u=abs(a(1))+abs(b(1))                                             
      do 22 i=2,n                                                       
 22   u=amax1(u,abs(a(i))+abs(b(i))+abs(b(i-1)))                        
      bd=u                                                              
      rbd=1./u                                                          
      do 23 i=1,n                                                       
      w(i)=b(i)                                                         
      b(i)=(b(i)/u)**2                                                  
      a(i)=a(i)/u                                                       
      v(i)=0.0                                                          
 23   ev(i)=-1.0                                                        
      u=1.0                                                             
      ik=1                                                              
      ndim=kj                                                           
      rewind iu                                                         
 1000 k=ik                                                              
      el=ev(k)                                                          
 24   elam=.5*(u+el)                                                    
      du=(4.0*abs(elam)+rbd)*eps                                        
      if(abs(u-el).le.du)go to 42                                       
      iag=0                                                             
      q=a(1)-elam                                                       
      if(q.ge.0.0)iag=iag+1                                             
      do 339 i=2,n                                                      
      if(q.eq.0.0)x(1)=abs(w(i-1)/bd)/eps                               
      if(q.ne.0.0)x(1)=b(i-1)/q                                         
      q=a(i)-elam-x(1)                                                  
      if(q.ge.0.0)iag=iag+1                                             
  339 continue                                                          
      if(iag.ge.k)go to 39                                              
      u=elam                                                            
      go to 24                                                          
 39   if(iag.eq.k)go to 41                                              
      m=k+1                                                             
      do 40 mm=m,iag                                                    
 40   ev(mm)=elam                                                       
 41   el=elam                                                           
      go to 24                                                          
 42   continue                                                          
      elam=bd*elam                                                      
      ev(k)=elam                                                        
      if(ik.eq.1)go to 44                                               
      if(elam.ge.ev(ik-1))ev(ik)=umeps*ev(ik-1)                         
 44   i=ik                                                              
      ii=1                                                              
      do 49 j=1,n                                                       
 49   y(j)=1.0                                                          
 50   do 51 k=1,n                                                       
      p(k)=0.0                                                          
      tb(k)=w(k)                                                        
 51   ta(k)=bd*a(k)-ev(i)                                               
      l=n-1                                                             
      do 57 j=1,l                                                       
      if(abs(ta(j)).lt.abs(w(j)))go to 53                               
      if(ta(j).eq.0.0)ta(j)=eps                                         
      f=w(j)/ta(j)                                                      
      go to 55                                                          
 53   f=ta(j)/w(j)                                                      
      ta(j)=w(j)                                                        
      t=ta(j+1)                                                         
      ta(j+1)=tb(j)                                                     
      tb(j)=t                                                           
      p(j)=tb(j+1)                                                      
      tb(j+1)=0.0                                                       
      t=y(j)                                                            
      y(j)=y(j+1)                                                       
      y(j+1)=t                                                          
 55   tb(j+1)=tb(j+1)-f*p(j)                                            
      ta(j+1)=ta(j+1)-f*tb(j)                                           
      y(j+1)=y(j+1)-f*y(j)                                              
 57   continue                                                          
      if(ta(n).eq.0.0)ta(n)=eps                                         
      if(ta(n-1).eq.0.0)ta(n-1)=eps                                     
      y(n)=y(n)/ta(n)                                                   
      y(n-1)=(y(n-1)-y(n)*tb(n-1))/ta(n-1)                              
      l=n-2                                                             
      do 62 j=1,l                                                       
      k=n-j-1                                                           
      if(ta(k).eq.0.0)ta(k)=eps                                         
 62   y(k)=(y(k)-y(k+1)*tb(k)-y(k+2)*p(k))/ta(k)                        
      ay=abs(y(1))                                                      
      do 63 j=2,n                                                       
 63   ay=amax1(ay,abs(y(j)))                                            
      do 64 j=1,n                                                       
 64   y(j)=y(j)/ay                                                      
      ii=ii+1                                                           
      if(ii.le.2)go to 50                                               
      id=ndim-2                                                         
      do 68 j=1,l                                                       
      id=id-j-2                                                         
      m=n-j                                                             
      h=w(m-1)                                                          
      if(h.eq.0.0)go to 68                                              
      jp1=j+1                                                           
      do 1098 kq=1,jp1                                                  
 1098 x(kq)=c(id+kq)                                                    
      t=dot(x,y(m),jp1)/(h*x(1))                                        
      kj=id                                                             
      do 67 k=m,n                                                       
      kj=kj+1                                                           
 67   y(k)=y(k)+t*c(kj)                                                 
 68   continue                                                          
      t=dot(y,y,n)                                                      
      xnorm=sqrt(t)                                                     
      do 70 j=1,n                                                       
 70   y(j)=y(j)/xnorm                                                   
      write(iu,882)(y(j),j=1,n)                                         
  882 format(10e12.5)                                                   
      ik=ik+1                                                           
      if(ik.le.num)go to 1000                                           
      rewind iu                                                         
      nev=i                                                             
      return                                                            
      end                                                               
c                                                                       
      function dot(z,zz,n)                                              
      dimension z(1),zz(1)                                              
      s=0.0                                                             
      do 1 i=1,n                                                        
 1    s=s+z(i)*zz(i)                                                    
      dot=s                                                             
      return                                                            
      end                                                               
C                                                                       
C COMPUTES EIGENVALUES/VECTORS OF A 2 X 2 MATRIX                        
C     ("AHOUSE" FAILS FOR THIS CASE)                                    
      subroutine tobyto(astar,sea,ev)                                   
      parameter(ndnd=600,ntim=54,nmod=60)                               
      dimension sea(nmod,nmod),ev(ndnd+ntim+nmod),astar(2,2)            
c special case for 2 x 2 "astar" matrix                                 
      fa=astar(1,1)                                                     
      fb=astar(2,2)                                                     
      fd=astar(1,2)                                                     
      fe=astar(2,1)                                                     
      fc=fe*fd                                                          
      fg=fa+fb                                                          
      ff=fg*fg-4.0*(fa*fb-fc)                                           
      ff=sqrt(ff)                                                       
c eigenvalues                                                           
      flam1=(fg+ff)/(2.0)                                               
      ev(1)=flam1                                                       
      flam2=(fg-ff)/(2.0)                                               
      ev(2)=flam2                                                       
c now compute eigenvector components                                    
c  "sea (modes,spacial pts. )"                                          
      fg1=(fa-flam1)**2+fd*fd                                           
      fg1=sqrt(fg1)                                                     
      if(fg1.eq.0.0)fg1=1.0                                             
      fg2=(fa-flam2)**2+fd*fd                                           
      fg2=sqrt(fg2)                                                     
      if(fg2.eq.0.0)fg2=1.0                                             
      sea(1,1)=(fa-flam1)/fg1                                           
      sea(1,2)=fd/fg1                                                   
      sea(2,1)=(fa-flam2)/fg2                                           
      sea(2,2)=fd/fg2                                                   
      return                                                            
      end                                                               
      subroutine print(n)
      write(6,1)n
    1 format('test print',i3)
      return
      end

