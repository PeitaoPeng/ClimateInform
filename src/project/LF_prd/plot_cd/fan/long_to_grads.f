C     read w.long (station by staion for entire time) and re-organize it
c     to be plot by grads
c
      parameter(nstx=344,nyear=72)  ! nyear=72 -->year 2002 (start from 1931)
      dimension wlong(nyear,12)
      dimension w(nstx,nyear,12)
      dimension lalo(nstx,2),ibad(17)
      character*8 stid
      DATA IBAD/9,12,15,33,63,182,183,209,247,248,253,264,274,295
     *,297,299,300/
                           
      open(11,status='old',form='formatted')
      open(12,status='old',form='formatted')
      open(20,status='unknown',form='unformatted')     ! sequential

c *** read in w.long
100   format(10f8.3)
200   format(3i8)
      do icd=1,nstx
         read(11,100,end=888) wlong 
         read(12,200) i,lalo(icd,1),lalo(icd,2)
         do iyr=1,nyear
         do mon=1,12
            w(icd,iyr,mon)=wlong(iyr,mon)
         enddo
         enddo
      enddo
888   continue
         
c *** write data in grads station format
      do iyr=1,nyear
      do mon=1,12
         tim=0.
         nlev=1
         nflag=1
         do 10 icd=1,nstx
            iflag=0
            nwmo=icd
            do 9 j=1,17
               if(icd.eq.ibad(j)) iflag=1
9           continue
            if(iflag.eq.1) go to 10
            slat=float(lalo(icd,1))/100.
            slon=-float(lalo(icd,2))/100.
            rval=w(icd,iyr,mon)
            write(stid,'(i8)') nwmo
            write(20) stid,slat,slon,tim,nlev,nflag,rval
10       continue

c *** ** write time terminator
         nlev=0
         slat=0.
         slon=0.
         stid='        '
         write(20) stid,slat,slon,tim,nlev,nflag
      enddo    
      enddo    
 999  stop 'all done'
      end	  
