c23456789012345678901234567890123456789012345678901234567890123456789012
c This program writes the original rotated EOF loading patterns
c (20N-87.5N) onto grids that always show positive phase of the mode. 
c
c  The I/O is little endian, and record lengths
c
c***********************************************************
c
      
      parameter(nsn=12,ieof=10,iln=144,ilt=28,ngpt=iln*ilt)

      dimension aeof(nsn,ieof,ngpt),aneof(ngpt),z(ngpt)

      integer iposn(ieof,nsn)
     
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

c gb reof for 1950-2000
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

c ieof is the number of rotated EOFs
c
c Input rotated loading patterns--arranged south-to-north
c   
      open(10,form='unformatted',access='direct',recl=ngpt*4)

c Output rotated loading patterns--arranged south-to-north 
      open(11,form='unformatted',access='direct',recl=ngpt*4)
c
c Read rotated EOF loading patterns for all twelve 3-month periods.
c Write -999 for a non-named loading pattern.
c Multiply by -1 for loading patterns with negative phase indicated 
c
c fill output array with missing values
c
      do 15 npat=1,ieof
      do 15 isn=1,nsn
         do 641 i=1,ngpt
 641     aneof(i)=-9.99E+8
      irec=(isn-1)*ieof+npat
      write(11,rec=irec) aneof
 15   continue

      do 5 npat=1,ieof
      do 5 isn=1,nsn
      print *,"isn, npat iposn= ",isn, npat,iposn(npat,isn)
      irec=(isn-1)*ieof+npat
      print *,"irec = ",irec
      read(10,rec=irec) z
c     print *,"irec, z(25,10) = ",irec,z(225)

      do 6 i=1,ngpt
  6   aeof(isn,npat,i)=z(i)        
  5   continue

c write the arrays to a new data file with columns being the modes 
c positioned in columns 1-10 as specified above (lines 27-36) 
c e.g. NAO will be in Col. 1, EA in col 2, etc....PT in col 10

      do 20 npat=1,ieof
      do 20 isn=1,nsn
 
      	if(iposn(npat,isn) .eq. 0) go to 20	
       	if(iposn(npat,isn) .lt. 0) ifac=-1
      	if(iposn(npat,isn) .gt. 0) ifac=1
      	ipos2=ifac*iposn(npat,isn)
        
         do 640 i=1,ngpt
 640     aneof(i)=ifac*aeof(isn,ipos2,i)

c write the data to file 11
 
      irec=(isn-1)*ieof+npat
      call noreof(aneof,ngpt)
      write(11,rec=irec) aneof
c     write(6,*) 'irec=',irec
c20   continue
c
      sd=0
      do i=1,ngpt
      sd=sd+aneof(i)**2
      enddo
      sd=sqrt(sd/float(ngpt))
      write(6,*) 'irec=',irec,' npat=',npat,' isn=',isn,' std=',sd
 20   continue

      stop
      end

      subroutine noreof(f,n)
      dimension f(n)

      if(abs(f(1)).gt.10000) go to 10
      av=0.
      do i=1,n
      av=av+f(i)
      enddo
      av=av/float(n)

      sd=0
      do i=1,n
      sd=sd+(f(i)-av)**2
      enddo
      sd=sqrt(sd/float(n))
      do i=1,n
      f(i)=(f(i)-av)/sd
      enddo
  10  continue

      return
      end
