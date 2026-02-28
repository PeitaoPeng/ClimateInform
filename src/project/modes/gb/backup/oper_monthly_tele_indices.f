c*****************************************************************
c PROGRAM: oper_monthly_tele_indices.f
c
c LANGUAGE: FORTRAN
c
c MACHINE: Compute Farm
c----------------------------------------------------------------*
c
c Purpose: Calculate standardized monthly teleconnection indices
c from standardized monthly 500 mb height anomalies
c (20N-87.5N). The indices are standardized with
c respect to the 1981-2010 base period monthly means.
c
c----------------------------------------------------------------*
c
c USAGE:   These are the operational monthly teleconnection indices 
c          for the Climate Diagnostics Bulletin and for the CPC web site
c          "Northern Hemisphere Teleconnection Patterns"
c         
c----------------------------------------------------------------*
c Notes:
c Prior to running this code, the script ../scripts/oper_monthly_tele_indices.gs
c must first be run to extract the monthly standardized 500-hpa height anomalies.
c
c---------------------------------------------------------------*
c INPUT FILES:   
c ../work/daymon.gerry.dat: date file produced by ../scripts/oper_monthly_tele_indices.gs
c ../work/oper_monthly_tele_indices.gerry.in: input monthly 500-hPa standardized anomalies produced by above script.      
c../input/eofmon_meansd.dat: monthly tele means and standard deviations
c                            calculated for 1981-2020 base period
c ../input/eof_unrotated_500hpa_loadingpatterns_little_endian.bi: Un-rotated loading patterns  
c ../input/500z.loading.patterns_little_endian: Rotated loading patterns 
c   ifilein: path name and file of archived tabulated 500-hPa tele indices to be updated
c   ibifile: path name and file of archived binary format 500-hPa tele indices to be updated
c   ictlin: path name and control file for Grads to be updated
c              
c OUTPUT FILES:   
c icdbout: path name and file for latest month of tele indices for CDB
c   ifilein: path name and file of archived tabulated 500-hPa tele indices to be updated
c   ibifile: path name and file of archived binary format 500-hPa tele indices to be updated
c   ictlin: path name and control file for Grads to be updated
c   nao_index.tim: ASCII Time series of NAO teleconnection index
c   ea_index.tim: ASCII Time series of East Atlantic teleconnection index
c   wp_index.tim: ASCII Time series of West Pacific teleconnection index
c   epnp_index.tim: ASCII Time series of East Pacific-North Pacific teleconnection index
c   wp_index.tim: ASCII Time series of West Pacific teleconnection index
c   pna_index.tim: ASCII Time series of Pacific/ North American (PNA) Pattern teleconnection index
c   eawr_index.tim: ASCII Time series of East Atlantic/ Western Russia  teleconnection index
c   scand_index.tim: ASCII Time series of Scandinavia teleconnection index
c   poleur_index.tim: ASCII Time series of Polar/ EurasiaPattern teleconnection index
c   tnh_index.tim: ASCII Time series of Tropical/ Northern Hemisphere (TNH) teleconnection index
c   pt_index.tim: ASCII Time series of Pacific Transitionteleconnection index
c----------------------------------------------------------------*
c
c SUBROUTINES USED:  MATLAB75- used in subroutine AMPLIT 
c                    AMPLIT:  Internal routine- Calculates the teleconnection indices                                                               
c                    EXPLVAR: Internal routine- Calculates explained variance of the ten leading 
c                             un-rotated modes for the specified month            
c                    CONTROL: Internal routine- Re-creates and updates grads control file for tele indices (monthly_tele_indices.ctl)
c
c FUNCTIONS USED:   None
c                     
c----------------------------------------------------------------*
c INPUT VARIABLES:   
c ngrid: number of time periods to read in
c dmoi: character for beginning month of data
c dmof: character for latest month of data
c dyri: Year pertaining to the beginning month
c dyrf: Year pertaining to the latest month
c meantel: 1981-2010 means of each tele index
c sdevtel: 1981-2010 st. dev's of each tele index
c aeof: array containing all of the rotated loading patterns
c aeofun: array containing all of the un-rotated loading patterns
c
c LOCAL VARIABLES:   
c monlet: Array containing abbreviations for each calendar month
c idbeg: begining data of data
c idend: ending data of data
c iposn: Data statement containing mode number and sign of loading 
c        patterns. 
c z: input 500-hPa standardized height anomalies
c neweofs: array with rotated loading patterns put in proper position and sign
c ampl: standardized tele indices for a given month
c ipo, ifac: variables used to give tele indices their correct sign and to
c            put tele indices in their final order for output
c expvar: explaine variance computed in EXPVAR subroutine
c                    
c----------------------------------------------------------------*
c AUTHOR(S):        Gerry Bell
c----------------------------------------------------------------*
c DATE               2/24/2011
c----------------------------------------------------------------*
c MODIFICATIONS:
******************************************************************
#include "fintrf.h"
#if 0
#endif
c
      integer dyri,dyrf,bmi,bmf
      character*3 monlet(12),dmoi,dmof,ichar
      
      data monlet/'JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG',
     &'SEP','OCT','NOV','DEC'/ 

c read in time values produced by Grads script
      
      open (2,file=
     &'../work/daymon.gerry.dat',form='formatted',status='old')
c
     
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
   
 1212 ntimbeg=(dyri-1950)*12+bmi
      ntimend=(dyrf-1950)*12+bmf
               
      call eofcalc(dmoi,dyri,dmof,dyrf,ntimbeg,ntimend,ngrid,nrotat)
      print *,dmoi,dyri,dmof,dyrf
   
      STOP
      END
      
      subroutine eofcalc(cmoi,cyri,cmof,cyrf,nmbeg,nmend,ngrids)
      parameter(nsn=12,ieof=10,neof=10,iln=144,ilt=28,ngpt=iln*ilt,
     &neof1=neof+1)

      dimension z(ngpt),ampl(ieof),pcdata(neof),
     &aeof(nsn,ieof,ngpt),zunrot(ngpt),
     &aeofun(nsn,ieof,ngpt),eofunr(ieof,ngpt)
      real meantel(nsn,neof),sdevtel(nsn,neof),
     &neweofs(ieof,ngpt)

      integer cyri,cyrf,bmi,bmf,iposn(neof,nsn),ipos2(ieof)
     
      character*3 monlet(nsn),cmoi,cmof
      character*300 ifilein,ibifile,ictlin,icdbout
      character*80 telname(neof)
c
      data monlet/'JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG',
     &'SEP','OCT','NOV','DEC'/ 

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
 
      data iposn/ 2,  -6, -4,  3,  5, 10, -9,  8, -1,  0,
     &            2,  -7, -3,  5, -4,  8,  6, 10, -1,  0,
     &            2,   9,  4,  6,  3,  8,  5,  0, -1,  0,
     &           -2, -10, -6, -8, -5, -7,  4,  0, -1,  0,
     &           -3,  -9,  7, -8,  4, -5,  6,  0,  1,  0,
     &           -3,  10,  5,  9,  6, -8,  7,  0, -4,  0,
     &           -3,  -8,  7,  6,-10, -9,  5,  0, -4,  0,
     &            3,   6, -7, -9, -2,  8,  5,  0,  4, 10,
     &           -4,  -9,  8,  6,  3,  7,  5,  0,  2,-10,
     &            4, -10, -8,  9, -7,  6,  5,  0, -1,  0,
     &           -2, -10, -8,  5,  7,  4,  6,  0, -1,  0,
     &            7,   9, -6,  0, -4, -8, -2, -3, -1,  0/  
      
      telname(1)='North Atlantic Oscillation (NAO)'
      telname(2)='East Atlantic Pattern'
      telname(3)='West Pacific Pattern'
      telname(4)='East Pacific-North Pacific Pattern'
      telname(5)='Pacific/ North American (PNA) Pattern'
      telname(6)='East Atlantic/ Western Russia Pattern'
      telname(7)='Scandinavia Pattern'
      telname(8)='Tropical/ Northern Hemisphere (TNH) Pattern'
      telname(9)='Polar/ Eurasia Pattern'
      telname(10)='Pacific Transition Pattern'
c
c Open standardized anomalies 
      open (1,file=
     &'../work/oper_monthly_tele_indices.gerry.in',
     &status='old',form='unformatted',access='direct',recl=ngpt*4)                    
c
c Input rotated loading patterns--arranged south-to-north
c   
      open (10,
     &file='../input/500z.loading.patterns_little_endian',
     &status='old',form='unformatted',access='direct',recl=ngpt*4)
c
c Input un-rotated loading patterns---arranged south-to-north
c   
      open (11,
     &file='../input/eof_unrotated_500hpa_loadingpatterns_little_endian.
     &bi',status='old',form='unformatted',access='direct',recl=ngpt*4)
c
c Input 1981-2010 mean and standard deviation 
c for the teleconnection indices
c     
      open (12,file='../input/eofmon_meansd.dat',
     &form='formatted',status='old')

      call getarg(1,ifilein)     
      call getarg(2,ibifile)     
      call getarg(3,ictlin)     
      call getarg(4,icdbout) 
          
c ASCII file for standardized EOF amplitudes

      open (23,file=ifilein,form='formatted',status='old')

c Grads binary data and control file of standardized EOF amplitudes

      open (25,file=ibifile,
     &form='unformatted',access='direct',status='unknown',recl=neof1*4)
          
      open (27,file=ictlin,form='formatted',status='old')       

c Write standardized EOF amplitudes to file for CDB Table E1

      open (28,file=icdbout,form='formatted',status='unknown')
c
c write EOF amplitudes for each teleconnection to individual files
c
      open (31,file='../output/nao_index.tim',form='formatted',
     &status='unknown')
      open (32,file='../output/ea_index.tim',form='formatted',
     &status='unknown')
      open (33,file='../output/wp_index.tim',form='formatted',
     &status='unknown')
      open (34,file='../output/epnp_index.tim',form='formatted',
     &status='unknown')
      open (35,file='../output/pna_index.tim',form='formatted',
     &status='unknown')
      open (36,file='../output/eawr_index.tim',form='formatted',
     &status='unknown')
      open (37,file='../output/scand_index.tim',form='formatted',
     &status='unknown')
      open (38,file='../output/tnh_index.tim',form='formatted',
     &status='unknown')
      open (39,file='../output/poleur_index.tim',form='formatted',
     *status='unknown')
      open (40,file='../output/pt_index.tim',form='formatted',
     &status='unknown')

c**************************************************************   
      do bmi=1,12
      if(cmoi .eq. monlet(bmi)) go to 1211
      end do
 1211 do bmf=1,12
      if(cmof .eq. monlet(bmf)) go to 1212
      end do
   
 1212 idbeg=cyri*100+bmi
      idend=cyrf*100+bmf
      print *,'idend, nmbeg, nmend = ',idend,nmbeg,nmend
      if(ngrids .eq. 1) then
         print *,'Calculating EOF Amplitudes for ',idbeg
      else
         print *,'Calculating EOF amplitudes for ',idbeg,' - ',idend
      end if
c***********************************************************
      if(ngrids .eq. 1) then
      write(28,813) cmoi,cyri
 813  format(a3,1x,i4,': Monthly Teleconnection Indices (81-10 clim)',/)
      else
      write(28,814) cmoi,cyri,cmof,cyrf
 814  format(a3,1x,i4,' to ',a3,1x,i4,': Monthly Tele. Indices',
     &'(1981-2010 climatology)',/)
      end if
      write(28,815)
 815  format('yyyy mm   NAO  EA   WP  EP/NP PNA TNH EA/WR SCAND POLEUR')
c ************************ 
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
c      print *,'done reading in initial modes'
c  
c***********************************************************
c
c read in historical archives to get to current starting date
c Also write headers for individual teleconnection files
c
c ampl 1: North Atlantic Oscillation (NAO)
c ampl 2: East Atlantic Pattern (EA)
c ampl 3: West Pacific Pattern (WP)
c ampl 4: East/North Pacific Pattern (EP) 
c ampl 5: Pacific/ North American Pattern (PNA)
c ampl 6: East Atlantic/West Russia Pattern (EA/WR)
c ampl 7: Scandinavia Pattern (SCAND)
c ampl 8: Tropical/ Northern Hemisphere Pattern (TNH)
c ampl 9: Polar/ Eurasia Pattern (POLEUR)
c ampl 10: Pacific Transition Pattern (PT)
c expvar: Explained variance of 10 leading unrotated modes
c
      do i=1,19
      read(23,5440) ichar
 5440 format(a3)
      end do
c
c Writing headers for individual teleconnection files
c 
      do 100 i=1,neof
         ifile=i+30
         write(ifile,333) telname(i)
 333     format('Monthly Teleconnection Index: ',a80)
         write(ifile, 334) 
 334  format('Indices are normalized using the 1981-2010 base period mon
     &thly means and standard deviations.'/)
      write(ifile, 345)
 345  format('Values are set to -99.90 for calendar months when the patt
     &ern')  
      write(ifile, 346)
 346  format('is not normally a leading mode of variability.'/)
 345        
      write(ifile, 335)
 335  format('The data is written in format(i4,3x,i2,1x,f6.2).'/)
      write(ifile,336)
 336  format('YEAR MONTH INDEX')
 100  continue
c
c Reading in historical archive of indices and writing to individual data files
c       
      do 105 itime=1,nmbeg-1
         read(23,546,end=9999) iyr,imo,(ampl(i),i=1,neof),expvar
      do 110 i=1,neof
         ifile=i+30
         write(ifile,337) iyr,imo,ampl(i)
 337  format(i4,3x,i2,1x,f6.2)
 110  continue
 105  continue
      
      print *,'The data for the last date in the monthly archive is'
      write(6,546) iyr,imo,(ampl(i),i=1,neof),expvar
      print *,' '
      print *,'The updated teleconnection indices are:'
      print *,' '
c
c read in 1981-2010 means and standard deviations 
c of teleconnection patterns 
c
      read(12,5440) ichar
      do imo=1,nsn
      read(12,6620) imo2,(meantel(imo,j),j=1,neof)
      read(12,6620) imo2,(sdevtel(imo,j),j=1,neof)
 6620 format(i2,1x,10f6.2,1x) 
      end do
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
      do 435 i=1,ieof
      ipos2(i)=iposn(i,imo)
      ampl(i)=0.
      do 435 j=1,ngpt
      neweofs(i,j)=0.
 435  continue
 
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
c Calculate raw PC amplitudes.
c
      call amplit(z,neweofs,ieofcnt,ipos2,ampl)
      call explvar(z,eofunr,ieof,expvar)
      expvar=100.*expvar
      itim=(iyr-1950)*nsn+imo
c
c standardize teleconnection indices, write to direct access file (25)
c Also write to screen and to monthly_eof_to_table_E1.tim (file 28)
c
      do 70 i=1,neof
      if(ampl(i) .ne. -99.9) 
     &ampl(i)=(ampl(i)-meantel(imo,i))/sdevtel(imo,i)
 70   continue
      write(25,rec=itim) ampl,expvar
c
      write(6,546)  iyr,imo,(ampl(i),i=1,neof),expvar
 546  format(i4,1x,i2,1x,10(f6.2),1x,f6.1)
c
      write(28,846) iyr,imo,(ampl(i),i=1,5),ampl(8),
     &(ampl(i),i=6,7),ampl(9)
 846  format(i4,1x,i2,1x,9(f5.1))
c      
c Write indices to eofmonftp_new.tim (file 23) 
c 
      write(23,546) iyr,imo,(ampl(i),i=1,neof),expvar
c      
c Write individual indices to separate date files for the web
c   
      do 115 i=1,neof
         ifile=i+30
         write(ifile,337) iyr,imo,ampl(i)
 115  continue
c
 25   continue
 20   continue

 35   continue
c  
c Update Grads control file for standardized tele indices
c 
      call control(nmend,neof1)
      print *,'done with monthly indices using new method'

       go to 991
 9999  print *,'****************PROGRAM ABORTED*************'
       print *,'The historical archive is only updated through '
       print *,monlet(imo),' ',iyr
       print *,'The archive is not up to date for the new data'
       print *,'which starts on ',monlet(bmi),' ',dyri
       go to 991
  90   print *,'Error reading in the data. Program stopped'
 991   stop
       end
c
      subroutine control(nmend,iieof)
c----------------------------------------------------------------*
c
c Purpose: Re-creates the Grads control file to read archive of 500-hPa tele indices
c
c----------------------------------------------------------------*
c
c USAGE:  Used to make tele plots for CDB: tele_indices_fige7_cdb.gs 
c         Used to make tele plots for web: monthly_tele_timeseries_eofnew.gs  
c         
c---------------------------------------------------------------*
c INPUT FILES:   ../input/monthly_tele_indices.ctl
c              
c OUTPUT FILES:  none
c 
c----------------------------------------------------------------*
c SUBROUTINES USED:  None
c                       
c FUNCTIONS USED:   None
c                     
c----------------------------------------------------------------*
c INPUT VARIABLES:   
c nmend: number of months in record- for Grads TDEF statement
c iieof: number of eof indices- for Grads VARS statement
c
c LOCAL VARIABLES:   
c----------------------------------------------------------------*
c AUTHOR(S):        Gerry Bell
c----------------------------------------------------------------*
c DATE               2/24/2011
c----------------------------------------------------------------*
c MODIFICATIONS:
******************************************************************
       
       write(27,301)
 301  format('DSET ^monthly_tele_indices.bi')
       write(27,302) 
 302   format('*') 
       write(27,785)
 785   format('OPTIONS little_endian')
       write(27,601) 
 601   format('UNDEF',1x,'-99.9')
       write(27,302) 
       write(27,303) 
 303  format('title Monthly Rotated Standardized Telecon. Indices (1981      
     &-2010 climo)')
       write(27,302) 
       write(27,304) 
 304  format('XDEF 1 LINEAR 0. 1.')
       write(27,302) 
       write(27,305) 
 305   format('YDEF 1 LINEAR 0. 1.')
       write(27,302) 
       write(27,306) 
 306   format('ZDEF 1 LEVELS 500')
       write(27,302) 
       write(27,307) nmend
 307   format('TDEF ',i4,' LINEAR jan1950 1mo')
 
       write(27,302) 
       write(27,308) iieof
 308   format('VARS ',i2)
       write(27,309) 
 309   format('nao    1   99   North Atlantic Oscillation')
       write(27,321) 
 321   format('ea     1   99   East Atlantic Pattern')
       write(27,611) 
 611   format('wp     1   99   West Pacific Oscillation')
       write(27,613) 
 613   format('epnp   1   99   East Pacific/ North Pacific Pattern')
       write(27,314) 
 314   format('pna    1   99   Pacific/ North America Pattern')
       write(27,612) 
 612   format('eawr   1   99   East Atlantic/ Western Russia Pattern')
       write(27,319) 
 319   format('scand  1   99   Scandinavia Pattern')
       write(27,317) 
 317   format('tnh    1   99   Tropical/ Northern Hemisphere Pattern')
       write(27,315) 
 315   format('poleur 1   99   Polar/ Eurasian  Pattern')
       write(27,318) 
 318   format('pt     1   99   Pacific transition pattern')
        write(27,329) 
 329   format('expvar 1   99   Expl. variance of 10 leading unrotated mo
     &des')
       write(27,310) 
 310   format('ENDVARS')
       return
       end
c
      subroutine amplit(zz,aeofs,numeofs,iipos2,ampltud)
c*****************************************************************
c Subroutine: Amplit
c
c LANGUAGE: FORTRAN
c
c MACHINE: Compute Farm
c----------------------------------------------------------------*
c
c Purpose: Calculate teleconnection pattern amplitudes of rotated eigenvector loadings
c using least squared fit. In effect, dot-product projections are
c normalized by the linear combination of the eigenvector 
c amplitudes which maximizes the total variance explained by all
c the eigenvectors combined. Pattern amplitudes are determined
c by matrix inversion.

c----------------------------------------------------------------*
c
c USAGE:   Used to update monthly teleconnection indices
c         
c---------------------------------------------------------------*
c INPUT FILES:   none
c              
c OUTPUT FILES:  none
c 
c----------------------------------------------------------------*
c SUBROUTINES USED:  MATLAB75
c                       
c FUNCTIONS USED:   None
c                     
c----------------------------------------------------------------*
c INPUT VARIABLES:   
c aeofs: array containing all of the loading patterns
c zz: input 500-hpa standardized height anomalies 
c nmeofs: number of eofs in a given month (non-zero values of iposn in main program)
c iipos2: array used to put the indices in their proper position
c ampltud: single-precision output raw (non-strandardized) tele indices
c
c LOCAL VARIABLES:   
c zproj: projection of standardized height anomalies onto eigenvector loading patterns
c a: temp matrix with multiplication of loading patterns
c aa: matrix with multiplication of loading patterns from which the least-squares solution 
c     for the teleconnection indices is obtained 
c The MATLAB lines solve the following matrix equation for soln: aa*soln=zproj
c soln: double-precision raw tele indices produced by MATLAB
c                  
c----------------------------------------------------------------*
c AUTHOR(S):        Gerry Bell
c----------------------------------------------------------------*
c DATE               2/24/2011
c----------------------------------------------------------------*
c MODIFICATIONS:
******************************************************************
c
      parameter(ieof=10,iln=144,ilt=28,ngpt=iln*ilt)
      dimension zz(ngpt),a(ieof,ieof),aeofs(ieof,ngpt),ampltud(ieof)
      real pi,rad
      integer iipos2(ieof)

      double precision zproj(ieof),aa(numeofs,numeofs),numb(1)
      mwpointer engOpen, engGetVariable, mxCreateDoubleMatrix
      mwpointer mxGetPr
      mwpointer ep
      mwpointer ka,b,soln2,c
      integer engPutVariable, engEvalString, engClose
      integer temp,status
      double precision productz(ieof)
      double precision soln(ieof)
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
c step 2: form matrix A from eigenvectorloadings
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
c step 3: solve the following matrix equation for sol: aa*soln=zproj
c
c      call lslrg(numeofs,aa,numeofs,zproj,1,soln)

         do j = 1,ieof
         write(79,*) zproj(j)
         enddo
         print*,'NUMEOFS IS ',numeofs
         do j = 1,numeofs
            do i = 1,numeofs
             write(80,*) aa(j,i)
            enddo
         enddo
         numb = numeofs
         print*,'numb is ', numb

ccccccccccccccc   CALL MATLAB library cccccccccccccccccc
        ep = engOpen('matlab')
        if (ep .eq. 0) then
           write(6,*) 'Can''t start MATLAB engine'
           stop
        else
           write(6,*) 'MATLAB ENGINE started'
        endif

c       Create variable space in Matlab
       ka = mxCreateDoubleMatrix(numeofs*numeofs, 1, 0)
       b = mxCreateDoubleMatrix(ieof, 1, 0)
       c = mxCreateDoubleMatrix(1, 1, 0)
       call mxCopyReal8ToPtr(aa, mxGetPr(ka), numeofs*numeofs)
       call mxCopyReal8ToPtr(zproj, mxGetPr(b), ieof)
       call mxCopyReal8ToPtr(numb, mxGetPr(c), 1)

       status = engPutVariable(ep, 'aa', ka)
       if (status .ne. 0) then
          write(6,*) 'engPutVariable failed'
          stop
       endif
       status = engPutVariable(ep, 'zproj', b)
        if (status .ne. 0) then
          write(6,*) 'engPutVariable failed'
          stop
        endif
       status = engPutVariable(ep, 'numb', c)
        if (status .ne. 0) then
          write(6,*) 'engPutVariable failed'
          stop
        endif


c     Do matrix manipulation
       if (engEvalString(ep,'t=reshape(aa,numb,numb);') .ne. 0) then
          write(6,*) 'engEvalString1 failed'
          stop
       endif


      if (engEvalString(ep,'soln2=inv(t)*zproj(1:numb);') .ne. 0) then
          write(6,*) 'engEvalString2 failed'
          stop
       endif

c     Print out soln
       soln2 = engGetVariable(ep, 'soln2')

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       call mxCopyPtrToReal8(mxGetPr(soln2), soln, ieof)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       print *, 'MATLAB computed the following values'
         do 84 i=1,ieof
c        do 84 i=1,numeofs
          print*, soln(i)
 84    continue

       status = engClose(ep)

         print*,'LEAVING MATLAB WORLD'

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

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
  
      return
      end
c

      subroutine explvar(zz,aeofs,numeofs,varexp)
c----------------------------------------------------------------*
c
c Purpose: Calculate explained variance of the observed anomaly map
c by the 10 leading un-rotated modes. Explained variance is based on the
c spatial correlation between observed anomaly map and
c the linear combination of the unrotated loading patterns.
c
c----------------------------------------------------------------*
c
c USAGE:   Website. Used for assessing relative importance of tele patterns. 
c         
c---------------------------------------------------------------*
c INPUT FILES:   none
c              
c OUTPUT FILES:  none
c 
c----------------------------------------------------------------*
c SUBROUTINES USED: None
c                       
c FUNCTIONS USED:   None
c                     
c----------------------------------------------------------------*
c INPUT VARIABLES:   
c aeofs: array containing all of the loading patterns
c zz: input 500-hpa standardized height anomalies 
c nmeofs: number of eofs in a given month (non-zero values of iposn in main program)
c
c LOCAL VARIABLES:   
c amnmap: spatial mean of observed anomaly map 
c avrmap: spatial variance of observed anomaly map
c amnmode:spatial mean of the loading patterns
c avrmode: spatial variance of the loading patterns
c cov: covariance
c denom: denominator in correlation term
c varexp: output calculated percentage of explained variance
c----------------------------------------------------------------*
c AUTHOR(S):        Gerry Bell
c----------------------------------------------------------------*
c DATE               2/24/2011
c----------------------------------------------------------------*
c MODIFICATIONS:
******************************************************************
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
      
