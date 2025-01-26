      program avgsigma 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C   avg sig data to have clim of b2ai
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      PARAMETER (nr=20,nv=57,nt=3)
      PARAMETER (nwp1=nr+1)
C
      complex  win(nr+1,nr+1),wave(nr+1,nr+1,nv)
      complex  wout(nr+1,nr+1,nv)
C
      open(unit=11,form='unformated',access='direct',recl=2*NWP1*NWP1)
      open(unit=12,form='unformated',access='direct',recl=2*NWP1*NWP1)
      open(unit=13,form='unformated',access='direct',recl=2*NWP1*NWP1)
      open(unit=90,form='unformated',access='direct',recl=2*NWP1*NWP1)
C
           do 10 k=1,nv
           do 10 j=1,nr+1
           do 10 i=1,nr+1
              wout(i,j,k)=(0.,0.)
  10  continue
C
         do 2000 ifile=1,nt
          iun=10+ifile
c
           do 30 k=1,nv
              read (iun) win
           do 20 j=1,nr+1
           do 20 i=1,nr+1
              wave(i,j,k)=win(i,j)
  20  continue
  30  continue
C
      do 60 k=1,nv
      do 60 j=1,nr+1
      do 60 i=1,nr+1
         wout(i,j,k)=wout(i,j,k)+wave(i,j,k)/float(nt)
  60  continue
         write(6,*)'ifile= ', ifile
C
2000       continue
C
           do 40 k=1,nv
           do 50 j=1,nr+1
           do 50 i=1,nr+1
              win(i,j)=wout(i,j,k)
  50  continue
           write(90) win
           write(6,*) 'wout(2,2)= ',win(2,2)
  40  continue
C
           stop
           end
