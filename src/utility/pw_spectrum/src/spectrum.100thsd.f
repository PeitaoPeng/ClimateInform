cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
C.....computing periodogram
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      parameter(NX=21000,NTIM=10000)
      parameter(neof=4,LDPM=NTIM/2+1)
      dimension ucoef(NX),XIN(NTIM)
      dimension PM(LDPM,5),out(LDPM)
      COMMON /WORKSP/  RWKSP
      REAL RWKSP(1000039)
      CALL IWKIN(1000039)
C
C.....read in u&psi and have clim mean
      do n=1,neof
       read(10) ucoef
       do i=1,NTIM
        XIN(i)=ucoef(i)
c       XIN(i)=sin(2*3.14159*5*i/1000)
       end do
      call PFFT(NTIM,XIN,0,0,0,1,1,PM,LDPM)
       do i=1,LDPM
	out(i)=PM(i,3)
       end do
       write(80) out
       write(6,888)
  888 format(1x,'frequency',2x,'period',5x,'I(w(k))',5x,
     &       'A(w(k))',5x,'B(w(k))')
      do 10 i=1,1000
       write(6,999) (PM(i,j),J=1,5)
  999 format(1x,F9.4,2x,F6.2,3(2x,F10.2))
   10 continue
      end do
      stop
      end
