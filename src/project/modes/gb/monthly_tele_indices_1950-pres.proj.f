c23456789012345678901234567890123456789012345678901234567890123456789012
c This program projects the normalized monthly 500 mb height anomalies 
c (20N-87.5N) onto seasonal rotated loading patterns. It then updates 
c the PC time series for each eof. The indices are calculated with  
c respect to the 1950-2000 base period monthly means.
c The explained variance for each month
c associaiated with the 10 leading un-rotated modes is also calculated.
c This program is run after standardized anomaly file is created
c in Grads: run monthly_tele_indices_1950-pres.gs
c
c The teleconnection fields can be plotted using 
c run oper_monthly_tele_indices_plot.gs
c
c***********************************************************
      program indices
      include "parm.h"
      integer dyri,dyrf,bmi,bmf     
      character*3 monlet(12),dmoi,dmof
      
      data monlet/'JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG',
     &'SEP','OCT','NOV','DEC'/ 

c read in time values produced by Grads script
      
      open (2,file='daymon.dat',
     &status='unknown')
c
c specify nrotat=0/1 for unrotated/ rotated EOF's
c
c      print *,'Enter 0 for non-rotated EOFs, or 1 for rotated EOFs'
c      read(5,105) nrotat
c 105  format(i1)
      nrotat=1
     
c read in month and year to calculate eof amplitudes for

      read(2,311) ngrid  
 311  format(i3) 
      read(2,312) dmoi
 312  format(a3)      
      read(2,313) dyri  
 313  format(i4)
      read(2,312) dmof     
      read(2,313) dyrf  
   
      do bmi=1,12
      if(dmoi .eq. monlet(bmi)) go to 1211
      end do
 1211 do bmf=1,12
      if(dmof .eq. monlet(bmf)) go to 1212
      end do
   
 1212 ntim=(dyrf-1950)*12+bmf
               
      call eofcalc(dmoi,dyri,dmof,dyrf,ntim,ngrid,nrotat)         
   
      STOP
      END
      
      subroutine eofcalc(cmoi,cyri,cmof,cyrf,nmon,ngrids,irotat)
      parameter(nsn=12,ieof=10,neof=10,iln=144,ilt=28,ngpt=iln*ilt,
     &neof1=neof+1)

      dimension z(ngpt),ampl(ieof),rawtele(neof),zout(neof),
     &anortm(nmon,neof),timser(nmon,neof),pcdata(neof),
     &aeof(nsn,ieof,ngpt),zunrot(ngpt),
     &aeofun(nsn,ieof,ngpt),eofunr(ieof,ngpt)
      real expvar2(nmon)

      integer cyri,cyrf,bmi,bmf,iposn(neof,nsn),ipos2(ieof)
      real neweofs(ieof,ngpt),expvar
     
      character*3 monlet(nsn),cmoi,cmof
      character*29 filedir
c
      data monlet/'JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG',
     &'SEP','OCT','NOV','DEC'/ 
      data filedir/'/cpc/consistency/telecon/gb/'/

c Data statement containing mode number and sign of loading 
c pattern as calculated by EOF code. This data statement
c tells the code how the key loading patterns have been stored 
c in the data files.
c
c Data statement rows are for the 3-month running 
c seasons beginning in January
c
c column 1: North Atlantic Oscillation (NAO)
c column 2: East Atlantic Pattern (EA)
c Column 3: West Pacific Pattern (WP)
c Column 4: East/North Pacific Pattern (EP) 
c Column 5: Pacific/ North American Pattern (PNA)
c Column 6: East Atlantic/West Russia Pattern (EA/WR)
c Column 7: Scandinavia Pattern (SCAND)
c Column 8: Tropical/ Northern Hemisphere Pattern (TNH)
c Column 9: Polar/ Eurasia Pattern (POLEUR)
c Column 10: Pacific Transition Pattern (PT)

c ieof is the number of rotated EOFs
c neof is the number of EOF patterns that we calculate indices for 
 
c reof for 1950-2020
c 1950-2020
c     data iposn/-2,  -4,  5,-10,  3, -9,  6, -7,  0,  0,
c    &           -1,  -6, -3,  9,  4, -8,  5,  7,-10,  0,
c    &            2,   5, -4,-10,  3, -7, -8, -6,  9,  0,
c    &           -2,   8,  3,-10,  4, -6,  7,  0,  9,  0,
c    &           -3,  -4, -8,  7,  2, -5,  9,  0,  8,  0,
c    &           -2,   6,  5,-10, -8,  7,  4,  0,  9,  0,
c    &           -2,  -3,  7,  9,  5, -4,  8,  0, 10, -6,
c    &           -6,  -3, -7,  4, -2,  9, 10,  0, -8, -5,
c    &            6,  -9,-10,  3, -4, -7, -8,  0,  0, -5,
c    &           -4,  -9,-10,  3, -7,  2,  6,  0, -8,  5,
c    &           -2,  -8, -7, -5, -4, -3, -6,  0,-10,  9,
c    &           -2,  -8, -5,  6, -4, 10,  7,  9,  3,  0/
c reof for 1950-2000
      data iposn/-3,  -5, -1, -9, -2,  7, 10,  8, -6,  0,
     &            2,   5,  1,  9,  3, -4,  7,  8,-10,  0,
     &            2,  -4, -1,  9,  3, -6,  7, -8,-10,  0,
     &           -3,   8, -4,-10,  2, -6,  5,  0,  0,  0,
     &           -5,  -7, -4, 10, -2, -8,  9,  0,  0,  0,
     &           -2, -10, -7,  5, -9,  8,  6,  0,  0,  0,
     &            4,  -8, -7, -6, -2,-10,  5,  0,  0,  9,
     &           -7,   4,  5, -3, -2, -8, -10, 0,  0, -6,
     &            5,  -9, 10, -4, -2,  8,  7,  0,  0,  6,
     &            3,   9,-10, -8, -6, -4,  5,  0, -7,  2,
     &            4,   5,  8, -9,  2, -6,  3, -7,  0,-10,
     &           -3,  -6, -4,  9, -2, 10, -8,  7,  5,  0/

c Input standardized anomalies--arranged south-to-north
      open (1,form='unformatted',access='direct',recl=4*ngpt)
c
c Input rotated loading patterns--arranged south-to-north
c   
      open (10,form='unformatted',access='direct',recl=4*ngpt)
c
c Input un-rotated loading patterns---arranged south-to-north
c   
      open (11,form='unformatted',access='direct',recl=4*ngpt)
c
c Output 1950-2000 mean and standard deviation 
c for the teleconnection indices
c     
      open (12,form='formatted',status='unknown')

c Output files for standardized EOF amplitudes

      open (22,status='unknown')
      open (23,status='unknown')

c Grads files for non-standardized and standardized EOF amplitudes

      open (24,form='unformatted',access='direct',recl=4*neof1)
      open (26,status='unknown')

      open (25,form='unformatted',access='direct',recl=4*neof1)
      open (27,status='unknown')
c**************************************************************   
      do bmi=1,12
      if(cmoi .eq. monlet(bmi)) go to 1211
      end do
 1211 do bmf=1,12
      if(cmof .eq. monlet(bmf)) go to 1212
      end do
   
 1212 idbeg=cyri*100+bmi
      idend=cyrf*100+bmf
      if(nmon .eq. 1) then
         print *,'Calculating EOF Amplitudes for ',dmof,dyrf
      else
         print *,'Calculating EOF Amplitudes for ',ngrids,'months'
         print *,'beginning',idbeg,' and ending ',idend
      end if
c
c***********************************************************
c
c Read rotated and unrotated EOF loading patterns for all 
c twelve 3-month periods. 
c
       do 5 isn=1,nsn
       do 5 npat=1,ieof
       irec=(isn-1)*ieof+npat
       read(10,rec=irec) z
       read(11,rec=irec) zunrot

       do 6 i=1,ngpt
       aeof(isn,npat,i)=z(i)
       aeofun(isn,npat,i)=zunrot(i)
  6    continue
  5    continue
       print *,'done reading in initial modes'
c        
c******Read in anomaly grids****
c                                                                                      
c Read in the standardized anomaly grids 
c
      irec=0
      do 20 iyr=cyri,cyrf
      do 25 imo=1,nsn
      if(iyr .eq. cyri .and. imo .lt. bmi) go to 25
      if(iyr .eq. cyrf .and. imo .gt. bmf) go to 35
      
      irec=irec+1
      read(1,rec=irec,err=90) z
c
      ieofcnt=0
      do 335 i=1,ieof
      ipos2(i)=iposn(i,imo)
      ampl(i)=0.
      do 335 j=1,ngpt
      neweofs(i,j)=0.
      eofunr(i,j)=0.
 335  continue
 
      do 40 ieofs=1,ieof
      do 641 i=1,ngpt
 641  eofunr(ieofs,i)=aeofun(imo,ieofs,i)

      if(iposn(ieofs,imo).eq. 0) go to 40 
       	    
        ieofcnt=ieofcnt+1
      	ifac=0
      	if(iposn(ieofs,imo) .lt. 0) ifac=-1
      	if(iposn(ieofs,imo) .gt. 0) ifac=1
      	ipo=ifac*iposn(ieofs,imo)
c
      do 640 i=1,ngpt
 640  if(ifac .ne. 0) neweofs(ieofcnt,i)=ifac*aeof(imo,ipo,i)
 40   continue
c
c Calculate raw PC amplitudes. The choice of obtaining amplitudes for 
c unrotated (irotat=0) or rotated (irotat=1) EOF's is specified above.
c
      if(irotat .eq. 0) call ampl2(z,neweofs,ieofcnt,ipos2,ampl)
c     if(irotat .eq. 1) call amplit(z,neweofs,ieofcnt,ipos2,ampl)
      if(irotat .eq. 1) call ampl2(z,neweofs,ieofcnt,ipos2,ampl)
      if(irotat .eq. 1) call explvar(z,eofunr,ieof,expvar)
c
c write non-standardized indices to file, and also write to 
c an array called timser in order to standardize the indices
c
      itim=(iyr-1950)*nsn+imo
      expvar2(itim)=100*expvar
c     write(6,546) iyr,imo,(ampl(i),i=1,neof),expvar2(itim)
      if (imo.eq.7) then
c     write(6,*) iyr,imo,(ampl(i),i=1,neof)
      endif
      do 70 i=1,neof
 70   timser(itim,i)=ampl(i)
      write(24,rec=itim) ampl,expvar2(itim)
 25   continue
 20   continue

 35   continue
c      
c***********************STANDARDIZED AMPLITUDES***************
c
c Standardize the PC amplitudes using
c the 1950-2000 base period mean and standard deviation
c
      call nortim(timser,anortm,idend,nmon)
c  
c Write entire standardized time series' to files 
c eofmonftp.tim (file 23) and eofmonrot.tim (plotting file 22)
c   
      write(23,597) 
 597  format(12X,'STANDARDIZED NORTHERN HEMISPHERE',1x,
     *'TELECONNECTION INDICES',/) 
      write(23,598) 
 598  format('column 1: Year (yy)') 
      write(23,599) 
 599  format('column 2: Month (mm)')
      write(23,600) 
 600  format('column 3: North Atlantic Oscillation (NAO)')
      write(23,601) 
 601  format('column 4: East Atlantic Pattern (EA)') 
      write(23,603)       
 603  format('column 5: West Pacific Pattern (WP)')
      write(23,604) 
 604  format('column 6: EastPacific/ North Pacific Pattern (EP/NP)') 
      write(23,606) 
 606  format('column 7: Pacific/ North American Pattern (PNA)')
      write(23,607) 
 607  format('column 8: East Atlantic/West Russia Pattern (EA/WR)')
      write(23,608) 
 608  format('column 9: Scandinavia Pattern (SCA)') 
      write(23,609) 
 609  format('column 10: Tropical/ Northern Hemisphere Pattern (TNH)')
      write(23,610) 
 610  format('column 11: Polar/ Eurasia Pattern (POL)')    
      write(23,611)      
 611  format('column 12: Pacific Transition Pattern (PT)')
      write(23,616)
 616  format('column 13: Explained Variance (%) of leading 10 modes')
       write(23,614)
 614  format('PATTERN VALUES ARE SET TO -99.9 FOR MONTHS ',
     *'IN WHICH THE PATTERN IS NOT A LEADING MODE',/)
      write(23,615)
 615  format('yyyy mm   NAO   EA    WP   EP/NP  PNA  EA/WR  SCA   TNH',
     *'   POL  PT    Expl. Var.',/) 

c column 1: North Atlantic Oscillation (NAO)
c column 2: East Atlantic Pattern (EA)
c Column 3: West Pacific Pattern (WP)
c Column 4: East/North Pacific Pattern (EP) 
c Column 5: Pacific/ North American Pattern (PNA)
c Column 6: East Atlantic/West Russia Pattern (EA/WR)
c Column 7: Scandinavia Pattern (SCAND)
c Column 8: Tropical/ Northern Hemisphere Pattern (TNH)
c Column 9: Polar/ Eurasia Pattern (POLEUR)
c Column 10: Pacific Transition Pattern (PT)

c  
c Write standardized time series' to plotting files eofmonftp.tim
c and to direct access file for use with grads
c   
      do i=1,nmon
      iyr=1950+(i-1)/12
      imo=i-(iyr-1950)*12
      write(6,546) iyr,imo,(anortm(i,k),k=1,neof),expvar2(i)
      write(23,546) iyr,imo,(anortm(i,k),k=1,neof),expvar2(i)
 546  format(i4,1x,i2,1x,10(f6.2),1x,f6.1)
c
      irec=(iyr-1950)*nsn+imo
      write(25,rec=irec) (anortm(i,k),k=1,neof),expvar2(i)
      end do
c 
c Write standardized time series' to plotting files eofmonrot.tim
c For this file set all values of -99.9 to zero   

      do 66 i=1,nmon     
      iyr=1950+(i-1)/12
      imo=i-(iyr-1950)*12
      do 67 j=1,neof
 67   if(anortm(i,j) .eq. -99.9) anortm(i,j)=0.
      write(22,45) i,iyr,imo,(anortm(i,kk),kk=1,neof),expvar2(i)
 45   format(2(i4,1x),i2,1x,10(f6.2),1x,f6.1)
 66   continue  
c  
c Create Grads control file for tele indices
c 
      call control(nmon,neof1)

      go to 909
c***************************************************  

 490   print *,'Error getting all tele indices prior to first date of'
       print *,'anomaly data now being read in. PROGRAM STOPPED'
       go to 909
 90    print *,'error reading in the Anomaly data. PROGRAM STOPPED'
 
 909   return
       end
c
      subroutine control(nmon,iieof)
c This subroutine re-creates the control file for Grads
c
       print *,'writing .ctl file: monthly teleconection indices' 
       
       write(26,300)
 300  format('DSET ^monthly_raw_tele_indices.2000.proj.bi')
       write(27,301)
c23456789012345678901234567890123456789012345678901234567890123456789012
 301  format('DSET ^monthly_tele_indices.2000.proj.bi')
       write(26,302) 
       write(27,302)
 302   format('*') 
       write(26,785)
       write(27,785)
 785   format('OPTIONS little_endian')
       write(26,601) 
       write(27,601) 
 601   format('UNDEF',1x,'-99.9')
       write(26,302) 
       write(27,302) 
       write(26,333) 
 333  format('title Monthly Rotated, non-standardized Telecon. Indces')
       write(27,303) 
c23456789012345678901234567890123456789012345678901234567890123456789012
 303  format('title Monthly Rotated Standardized Telecon. Indices')
       write(26,302) 
       write(27,302) 
       write(26,304) 
       write(27,304) 
 304  format('XDEF 1 LINEAR 0. 1.')
       write(26,302) 
       write(27,302) 
       write(26,305) 
       write(27,305) 
 305   format('YDEF 1 LINEAR 0. 1.')
       write(26,302) 
       write(27,302) 
       write(26,306) 
       write(27,306) 
 306   format('ZDEF 1 LEVELS 500')
       write(26,302)
       write(27,302) 
       write(26,307) nmon
       write(27,307) nmon
 307   format('TDEF ',i4,' LINEAR jan1950 1mo')
 
       write(26,302) 
       write(27,302) 
       write(26,308) iieof
       write(27,308) iieof
 308   format('VARS ',i2)
       write(26,309) 
       write(27,309) 
 309   format('nao    1   99   North Atlantic Oscillation')
       write(26,321) 
       write(27,321) 
 321   format('ea     1   99   East Atlantic Pattern')
       write(26,611) 
       write(27,611) 
 611   format('wp     1   99   West Pacific Oscillation')
       write(26,613) 
       write(27,613) 
 613   format('epnp   1   99   East Pacific/ North Pacific Pattern')
       write(26,314) 
       write(27,314) 
 314   format('pna    1   99   Pacific/ North America Pattern')
       write(26,612) 
       write(27,612) 
 612   format('eawr   1   99   East Atlantic/ Western Russia Pattern')
       write(26,319) 
       write(27,319) 
 319   format('scand  1   99   Scandinavia Pattern')
       write(26,317) 
       write(27,317) 
 317   format('tnh    1   99   Tropical/ Northern Hemisphere Pattern')
       write(26,315) 
       write(27,315) 
 315   format('poleur 1   99   Polar/ Eurasian  Pattern')
       write(26,318) 
       write(27,318) 
 318   format('pt     1   99   pacific transition pattern')
        write(26,329) 
        write(27,329) 
 329   format('expvar 1   99   Expl. variance of 10 leading unrotated mo
     &des')
       write(26,310) 
       write(27,310) 
 310   format('ENDVARS')
       return
       end
c
c
      subroutine amplit(zz,aeofs,numeofs,iipos2,ampltud)
c
c Calculate pattern amplitudes of rotated eigenvector loadings
c using least squared fit. In effect, dot-product projections are
c normalized by the linear combination of the eigenvector 
c amplitudes which maximizes the total variance explained by all
c the eigenvectors combined. Pattern amplitudes are determined
c by matrix inversion.
c
      parameter(ieof=10,iln=144,ilt=28,ngpt=iln*ilt)
      dimension zz(ngpt),a(ieof,ieof),
     &aeofs(ieof,ngpt),ampltud(ieof)
      real*8 aa(numeofs,numeofs),aiv(numeofs,numeofs)
      real*8 zproj(ieof)
      real soln(numeofs),wt(numeofs),pi,rad
      integer iipos2(ieof)
c
c step 1: project standardized anomalies for current month 
c         onto eigenvectors
c 
      do 25 i=1,numeofs
      zproj(i)=0.
      do 30 j=1,ngpt
 30   zproj(i)=zproj(i)+zz(j)*aeofs(i,j)
 25   continue
c
c step 2: form matrix A from eigenvector loadings
c                                       
      do 40 k1=1,numeofs                                 
      do 40 k2=1,numeofs                                      
      a(k1,k2)=0.                                     
      do 41 j=1,ngpt                                 
   41 a(k1,k2)=a(k1,k2)+aeofs(k1,j)*aeofs(k2,j)     
   40 continue   
c
c copy matrix a to matrix aa, since matrix aa will be destroyed
c in the imsl subroutine
c
      do 45 i=1,numeofs
      do 45 j=1,numeofs
 45   aa(i,j)=a(i,j) 
c
C add a ridge
      ridge=0.000
      dg=0
      do i=1,numeofs
       dg=dg+aa(i,i)*aa(i,i)
      enddo
      dg=sqrt(dg/float(numeofs))
c     write(6,*) 'rms of diagnal elements',dg
      do i=1,numeofs
       aa(i,i)=aa(i,i)+ridge*dg
      enddo
c
c step 3: solve the following matrix equation for sol: aa*soln=zproj
c
c     call lslrg(numeofs,aa,numeofs,zproj,1,soln)

      call mtrx_inv(aa,aiv,numeofs,numeofs)
      call solutn(aiv,zproj,soln,numeofs)

c
c put teleconnection indices in array "ampltud" 
c back into the proper columns. 
c
      izero=0
      do 740 i=1,ieof
      if(iipos2(i) .eq. 0) then
      izero=izero+1      
      ampltud(i)=-99.9
      end if
      if(iipos2(i) .ne. 0) ampltud(i)=soln(i-izero)
  740 continue
c  
      return
      end
c
c
      subroutine ampl2(zz,aeofs,numeofs,iipos2,ampltud)
c
c calculate normalized amplitudes of unrotated eigenvector Patterns
c using dot product approach. Values are normalized by the 
c amplitude of the eigenvector.
c
      parameter(nsn=12,ieof=10,iln=144,ilt=28,ngpt=iln*ilt)
      dimension zz(ngpt),aeofs(ieof,ngpt),iipos2(ieof),ampltud(ieof)
      real aa(numeofs,numeofs),zproj(numeofs),sum(numeofs),pi,rad
c
c Calculate amplitude-squared of the eigenvectors for all months
c
      do 10 i=1,numeofs
      sum(i)=0
      do 111 k=1,ngpt
 111  sum(i)=sum(i)+aeofs(i,k)**2
 10   continue
c
c project standardized anomalies for current month 
c onto eigenvectors. Normalize by the amplitude of
c the eigenvector-squared.
c
      do 25 i=1,numeofs
      zproj(i)=0.
      do 30 j=1,ngpt
 30   zproj(i)=zproj(i)+zz(j)*aeofs(i,j)/sqrt(sum(i))
 25   continue
c
c put teleconnection indices in array "ampltud" 
c back into the proper columns. 
c
      izero=0
      do 740 i=1,ieof
      if(iipos2(i) .eq. 0) then
      izero=izero+1      
      ampltud(i)=-99.9
      end if
      if(iipos2(i) .ne. 0) ampltud(i)=zproj(i-izero)
  740 continue
c     write(6,*) 'nzero=',izero, 'ampltud=',ampltud
c
      return
      end
      
c
      subroutine nortim(ain,aout,idyend,nmon)
      parameter(nsn=12,neof=10)

      dimension zmean(nsn,neof),ain(nmon,neof),
     +aout(nmon,neof),zsqr(nsn,neof)
c
      iyrend=idyend/100
      imoend=idyend-100*iyrend

      do 9 i=1,nsn
      do 9 j=1,neof
      	zmean(i,j)=0.
      	zsqr(i,j)=0.
 9    continue 
c
c calculate mean and standard deviation for 1981-2010 base period
c The mean index value for each mode in each season is zero
c
      do 20  imo=1,nsn
      do 20 iyr=1981,2010                                                      
      	 k= (iyr-1950)*nsn+imo
      	           
      do 75 ieof=1,neof
c     	if(ain(k,ieof) .eq. -99.9 .and. iyr .eq. 1950) then
      	if(ain(k,ieof) .eq. -99.9) then
      	    zmean(imo,ieof)=-99.9
      	    zsqr(imo,ieof)=-99.9
      	 end if
      	if(ain(k,ieof) .ne. -99.9) then
       	     zmean(imo,ieof)=ain(k,ieof)+zmean(imo,ieof)/30.
      	end if	
 75   continue
 20   continue
c
      do 21 imo=1,nsn
      do 21 iyr=1981,2010                                                      
      	 k= (iyr-1950)*nsn+imo
      	           
      do 76 ieof=1,neof
c     	if(ain(k,ieof) .eq. -99.9 .and. iyr .eq. 1950) then
      	if(ain(k,ieof) .eq. -99.9 ) then
      	    zsqr(imo,ieof)=-99.9
      	 end if
      	if(ain(k,ieof) .ne. -99.9) then
      	     zsqr(imo,ieof)=zsqr(imo,ieof)+
     &(ain(k,ieof)-zmean(imo,ieof))**2
      	end if	
 76   continue
 21   continue
c
      do 35 imo=1,nsn
      do 35 ieof=1,neof
      	if(zmean(imo,ieof) .ne. -99.9) then
       	    zsqr(imo,ieof)= sqrt(zsqr(imo,ieof)/30)
      	end if
 35   continue
c
c write standard deviations to file--Means of all indices are 0.0
c
      write(12,615)
 615  format('NAO  EA   WP  EP/NP PNA EA/WR SCA TNH   POL  PT ')
      do imo=1,nsn
       write(12,620) imo,(zmean(imo,j),j=1,neof)
       write(12,620) imo,(zsqr(imo,j),j=1,neof)
 620  format(i2,1x,10f6.2) 
      end do
c
c Create standardized time series: mean=0, variance=1
c
      do 40 iyr=1950,iyrend
      do 40 imo=1,nsn
      id1 = iyr*100+imo     
      k= (iyr-1950)*nsn+imo
      if(id1 .gt. idyend) go to 455
      do 42 ieof=1,neof
          if(zmean(imo,ieof) .eq. -99.9) then
             aout(k,ieof)=-99.9
          else
      aout(k,ieof)=(ain(k,ieof)-zmean(imo,ieof))/zsqr(imo,ieof)
          end if
 42   continue
 40   continue 
c
 455  return
      end
c
c
      subroutine explvar(zz,aeofs,numeofs,varexp)
c
c Calculate explained variance of the observed anomaly map
c by the 10 leading un-rotated modes
c
      parameter(ieof=10,iln=144,ilt=28,ngpt=iln*ilt)
      dimension zz(ngpt),aeofs(ieof,ngpt)
      real amnmode(numeofs),avrmode(numeofs),amode2(numeofs),
     &cov,varexp,correl
    
      varexp=0.      
      amnmap=0.
      amap2=0.
      avrmap=0.
      cov=0.
      
      do 5 i=1,numeofs
      amnmode(i)=0.
      avrmode(i)=0.
      amode2(i)=0.
 5    continue
c
c calculate spatial mean and variance of observed anomaly map
c 
      do 10 i=1,ngpt
      amnmap=amnmap+zz(i)/float(ngpt)
      amap2=amap2+zz(i)**2
 10   continue
 
      avrmap=amap2/float(ngpt)-amnmap**2
c
c calculate spatial mean and variance of the loading patterns
c 
      do 15 k=1,numeofs
      do 20 i=1,ngpt
          amnmode(k)=amnmode(k)+aeofs(k,i)/float(ngpt)
          amode2(k)=amode2(k)+aeofs(k,i)**2
 20   continue
          avrmode(k)=amode2(k)/float(ngpt)-amnmode(k)**2
 15   continue      
c
c calculate spatial correlation between observed anomaly map and
c the linear combination of the unrotated loading patterns.
c
      do 25 k=1,numeofs
          cov=0.
          denom=sqrt(avrmap)*sqrt(avrmode(k))
      do 30 i=1,ngpt
      val=(zz(i)-amnmap)*(aeofs(k,i)-amnmode(k))/float(ngpt)
      cov=cov+val
 30   continue
          correl=cov/denom
          varexp=varexp+correl**2
c      print *,'numeofs, correl, varexp  ',numeofs,correl,varexp
 25   continue
          
      return
      end
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
        parameter(max_nchan = 2378) !MAXIMUM # OF ALLOWED REGRESSION
C                                    CHANNELS

        integer max_nsamp
        parameter(max_nsamp = 600) ! MAXIMUM TRAINING SAMPLE SIZE OR THE
C                                    MAXIMUM #
                                    ! OF OBSERVATIONS TO WHICH
                                    ! COEFFICENTS ARE APPLIED

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
      SUBROUTINE hpsort(n,n2,ra,rb)
      INTEGER n,n2
      REAL ra(n),rb(n)
      INTEGER i,ir,j,l
      REAL rra
      if (n2.lt.2) return
      l=n2/2+1
      ir=n2
10    continue
        if(l.gt.1)then
          l=l-1
          rra=ra(l)
          rrb=rb(l)
        else
          rra=ra(ir)
          rrb=rb(ir)
          ra(ir)=ra(1)
          rb(ir)=rb(1)
          ir=ir-1
          if(ir.eq.1)then
            ra(1)=rra
            rb(1)=rrb
            return
          endif
        endif
        i=l
        j=l+l
20      if(j.le.ir)then
          if(j.lt.ir)then
            if(ra(j).lt.ra(j+1))j=j+1
          endif
          if(rra.lt.ra(j))then
            ra(i)=ra(j)
            rb(i)=rb(j)
            i=j
            j=j+j
          else
            j=ir+1
          endif
        goto 20
        endif
        ra(i)=rra
        rb(i)=rrb
      goto 10
      END

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
