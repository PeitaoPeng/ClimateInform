c-----/homes/cola/hu/dataHU/ZZ_reof01.f--HU Zeng-Zhen, COLA, Oct. 30~  , 2000-----c
c     EOF and REOF/region (0~360,20N~90N) & H850
c-------------------------------------------------------------c
      parameter(mlo0=144,mla0=73,IYEAR=52,j0=44)
      parameter(mlo=mlo0,mla=mla0-j0)
      parameter(m=mlo*mla,n=IYEAR,ip=15,kt=15,nj=20)
c-------------------------------------------------------------c
c m----space
c n------time
c ip------first ip components
c kt -------iteration times in REOF
c-------------------------------------------------------------c
      REAL*4 datDJF(mlo0,mla0,n),datMAM(mlo0,mla0,n)
     *      ,datJJA(mlo0,mla0,n),datSON(mlo0,mla0,n)
     * ,data0(mlo,mla,n),data00(n,m),dataLF(mlo,mla,n)
     * ,xLF(n),xHF(n)

      REAL*4 d(n),tna(n,n),vna1(m,n),aa(n,n),vna(n,n)
     * ,seig(ip),b(m,ip),f(ip,n),vv(m),ua(m),va(m)
     * ,h(m),bn(m,ip),fn(ip,n),dy(ip),ddy(ip),bb(m,ip)
     * ,v(m,ip),t(ip,n),percent1(n),Seof(mlo,mla,ip)
     * ,ff(ip,n),Sreof(mlo,mla,ip),percent2(n)
     * ,ser1(n),ps1(nj,6),sk1(nj,6),t1(nj,6),sx1(ip)
     * ,ser2(n),ps2(nj,6),sk2(nj,6),t2(nj,6),rsx1(ip)
c-------------------------------------------------------------c
c I: INPUT & PREPARE DATA
c-------------------------------------------------------------c
      open(139,file='/data/ed/hu/hudata1/NCEP_h850_season',
     * form='unformatted')
      do 15 k=1,IYEAR
      read(139)((datDJF(i,j,k),i=1,mlo0),j=1,mla0)
      read(139)((datMAM(i,j,k),i=1,mlo0),j=1,mla0)
      read(139)((datJJA(i,j,k),i=1,mlo0),j=1,mla0)
15    read(139)((datSON(i,j,k),i=1,mlo0),j=1,mla0)
c-------------------------------------------------------------c
c 20N~90N DJF 1948-1999
c interpolation the polar values
c-------------------------------------------------------------c
      do 20 i=1,mlo
      do 20 k=1,n
c      do 10 j=mla-3,mla
c10    data0(i,j,k)=datDJF(i,j+j0,k)
c     * +(datDJF(i,j+j0-1,k)-datDJF(i,j+j0-2,k))
c      do 20 j=1,mla-4
      do 20 j=1,mla
20    data0(i,j,k)=datDJF(i,j+j0,k)

      do 25 i=1,mlo
      do 25 j=1,mla
      ij=(j-1)*mlo+i
      do 25 k=1,n
25    data00(k,ij)=data0(i,j,k)
c-------------------------------------------------------------c
c  high-pass filter
c------------------------------------------------------------c
c      do 25 i=1,mlo
c      do 25 j=1,mla
c      ij=(j-1)*mlo+i
c      do 22 k=1,n
c22    xHF(k)=data0(i,j,k)
c      CALL bpfilter(xHF,xLF)
cc      CALL lpfilter(xHF,xLF)
c        do 27 k=1,n
c        dataLF(i,j,k)=xLF(k)
c27      data00(k,ij)=xHF(k)
c25    continue
c-------------------------------------------------------------c
c normalized or anomalzed data  (?)
c-------------------------------------------------------------c
      do 35 i=1,m
c35     CALL teedss(1,n,data00(1,i),ex,dx,sx,nr)
        CALL teedss(0,n,data00(1,i),ex,dx,sx,nr)
       do 35 k=1,n
35     data00(k,i)=data00(k,i)-ex
c-------------------------------------------------------------c
c give a latitute weight
c Note: about the weight, can refer to the :
c   North, G. R., Bell, T. L., Cahalan, R. F. and Moeng, F. J., 1982:
c   Sampling errors in the estimation of empirical orthogonal
c   functions. Mon. Wea. Rev. 110, 699-706.
c-------------------------------------------------------------c
      do 50 j=1,mla
c      weight=(abs(cos((-90.+2.5*(j+j0))/180.*3.14)))**0.5
      weight=1.0
      do 50 i=1,mlo
        ij=(j-1)*mlo+i
         do 50 k=1,n
50    data00(k,ij)=data00(k,ij)*weight
c-------------------------------------------------------------c
c II: EOF ANALYSIS
c-------------------------------------------------------------c
      CALL eof(d,tna,vna1,data00,vna,aa,n,m)
c-------------------------------------------------------------c
C III: ROTATION OF THE EOF RERULT
c-------------------------------------------------------------c
      do 300 i=n,n+1-ip,-1
      seig(n+1-i)=d(i)
      do 310 j=1,m
310   v(j,n+1-i)=vna1(j,i)
      do 300 j=1,n
300   t(n+1-i,j)=tna(j,i)
c-------------------------------------------------------------c
C the percentage of variance explained by the first ip EOF modes
c-------------------------------------------------------------c
      axx=0.0
      do 320 i=1,n
320   axx=axx+d(i)
        bxx=0.0
        do 330 i=n,n+1-ip,-1
330        bxx=bxx+d(i)
        bxx=bxx/axx
        do 340 i=1,n
340        percent1(i)=d(n+1-i)/axx*100.
c-------------------------------------------------------------c
c IV: OUTPUTING THE EOF RESULT
C      v(m,ip):the first ip spatial EOF modes
C      t(ip,n):the corresponding first ip time cofficients 
C      seig(ip):the variance explained by the first ip EOF modes 
C      percent1(ip):the percentage of variance explained by the 
C        first n EOF modes 
c-------------------------------------------------------------c
      open (31,file='NCEP_reof_h850.var',form='formatted')
	write(31,*)'EOF variance contribution'
        write(31,13)(percent1(k),k=1,n/10)
      print*,'Percent/EOF'
      print*,(percent1(k),k=1,n/10)
13      format(10f8.2)
	do 430 i=1,ip
430       seig(i)=sqrt(seig(i))
	do 440 j=1,ip
	do 440 i=1,m
440        b(i,j)=v(i,j)*seig(j)
	do 470 i=1,ip
	do 470 j=1,n
470        f(i,j)=t(i,j)/seig(i)
100     format(10f8.2)
c-------------------------------------------------------------c
C V: TO ROTATE THE EOF RESULT
c-------------------------------------------------------------c
      do 520 kk=1,kt
      print*,'Iteration time of REOF=',kk
	CALL   roteof(b,vv,f,dy,ua,va,h,bn,fn,m,n,ip)
520    continue
c-------------------------------------------------------------c
C make sequence from the largest to the smallest
c-------------------------------------------------------------c
        do 530 i=1,ip
        CALL amax1(dy,ip,ama,ii)
        ddy(i)=ama
        dy(ii)=0.
c-------------------------------------------------------------c
C  space 
c-------------------------------------------------------------c
        do 540 j=1,m
540        bb(j,i)=b(j,ii)
c-------------------------------------------------------------c
C  time
c-------------------------------------------------------------c
        do 550 k=1,n
550        ff(i,k)=f(ii,k)
530     continue
c-------------------------------------------------------------c
C  percent2(ip): the percentage of the total variance 
c       explained by the first ip EOF modes 
c-------------------------------------------------------------c
        axx=0.0
        do 560 i=1,ip
560        axx=axx+ddy(i)
        do 570 i=1,ip
570        percent2(i)=ddy(i)/axx*bxx*100.
        do 580 i=ip+1,n
580        percent2(i)=percent1(i)
c-------------------------------------------------------------c
c VI: OUTPUT THE REOF RESULT
C   b(m,ip):the first ip spatial REOF modes
C   f(ip,n):the corresponding first ip time cofficients in REOF 
C   dy(ip):the variance explained by the first ip REOF modes 
C   percent2(ip):the percent of variance explained by the 
C    first ip REOF modes 
c-------------------------------------------------------------c
	do 615 i=1,m
	do 615 j=1,ip
615	  bb(i,j)=bb(i,j)/sqrt(float(n))
	do 625 i=1,ip
	do 625 j=1,n
625	  ff(i,j)=ff(i,j)*sqrt(float(n))
	write(31,*)'REOF variance contribution'
	write(31,13)(percent2(k),k=1,n/10)

      print*,'Percent/REOF'
      print*,(percent2(k),k=1,n/10)

      open (32,file='NCEP_reof_h850.space',form='unformatted')
      open (33,file='NCEP_reof_h850.time',form='unformatted')
      open (20,file='NCEP_reof_h850.power',form='unformatted')
c-------------------------------------------------------------c
c  change the output for GRADS ploting 
c  and standardize the time serieses
c-------------------------------------------------------------c
        CALL output1(t,sx1,n,ip)
        CALL output1(ff,rsx1,n,ip)

      do 640 k=1,n
	write(33)t(1,k)
	write(33)t(2,k)
	write(33)t(3,k)
	write(33)t(4,k)
	write(33)t(5,k)
	write(33)t(6,k)
	write(33)ff(1,k)
	write(33)ff(2,k)
	write(33)ff(3,k)
	write(33)ff(4,k)
	write(33)ff(5,k)
	write(33)ff(6,k)
640   continue
c-------------------------------------------------------------c
c  the spatial patterns 
c-------------------------------------------------------------c
      do 630 i=1,mlo
      do 630 j=1,mla
      ij=(j-1)*mlo+i
      do 635 k=1,ip
       Seof(i,j,k)=v(ij,k)*sx1(k)
635    Sreof(i,j,k)=bb(ij,k)*rsx1(k)
630   continue
	write(32)((Seof(i,j,1),i=1,mlo),j=1,mla)
	write(32)((Seof(i,j,2),i=1,mlo),j=1,mla)
	write(32)((Seof(i,j,3),i=1,mlo),j=1,mla)
	write(32)((Seof(i,j,4),i=1,mlo),j=1,mla)
	write(32)((Seof(i,j,5),i=1,mlo),j=1,mla)
	write(32)((Seof(i,j,6),i=1,mlo),j=1,mla)
	write(32)((Sreof(i,j,1),i=1,mlo),j=1,mla)
	write(32)((Sreof(i,j,2),i=1,mlo),j=1,mla)
	write(32)((Sreof(i,j,3),i=1,mlo),j=1,mla)
	write(32)((Sreof(i,j,4),i=1,mlo),j=1,mla)
	write(32)((Sreof(i,j,5),i=1,mlo),j=1,mla)
	write(32)((Sreof(i,j,6),i=1,mlo),j=1,mla)
c-------------------------------------------------------------c
c  CALCULATE THE POWER SPECTRUM
c-------------------------------------------------------------c
      do 750 k=1,6
        do 740 i=1,n
          ser1(i)=t(k,i)
740       ser2(i)=ff(k,i)
      if(k.eq.1)ip0=1 
      call pspe(n,nj-1,nj,ser1,ps1(1,k),sk1(1,k),t1(1,k),ip0)
750   call pspe(n,nj-1,nj,ser2,ps2(1,k),sk2(1,k),t2(1,k),0)
c-------------------------------------------------------------c
c OUTPUT THE RESULT
c-------------------------------------------------------------c
      do 712 i=1,nj
        write(20)ps1(i,1)
        write(20)sk1(i,1)
        write(20)ps1(i,2)
        write(20)sk1(i,2)
        write(20)ps1(i,3)
        write(20)sk1(i,3)
        write(20)ps1(i,4)
        write(20)sk1(i,4)
        write(20)ps1(i,5)
        write(20)sk1(i,5)
        write(20)ps1(i,6)
        write(20)sk1(i,6)

        write(20)ps2(i,1)
        write(20)sk2(i,1)
        write(20)ps2(i,2)
        write(20)sk2(i,2)
        write(20)ps2(i,3)
        write(20)sk2(i,3)
        write(20)ps2(i,4)
        write(20)sk2(i,4)
        write(20)ps2(i,5)
        write(20)sk2(i,5)
        write(20)ps2(i,6)
        write(20)sk2(i,6)
712   continue
          stop
          end
      
	SUBROUTINE PSPE(N,J,J1,SER,PS,SK,T,IP0)
c  this SUBROUTINE is available for calculating power spectra
c   N--number of the sample
c   J--the maximum lag length
c   J1=J+1
c   SER--data sources
c   PS--power spactra(solutions)
c   SK--statistical significence
c   T--length of cycle
c   n0>J1
        parameter (n0=500)
	DIMENSION CC(n0),SPE(n0),SER(N),PS(J1),SK(J1),T(J1),T0(n0),LT(n0)
c	
c  calculating auto-connection coefficient
	A=0.
	C=0.
	DO 100 I=1,N
100	A=A+SER(I)
	A=A/N
	DO 110 I=1,N
	SER(I)=SER(I)-A
110	C=C+SER(I)**2
	C=C/N
	if (C.le.0.00000001) goto 777 
	DO 120 L=1,J
	CC(L)=0.
	DO 125 I=1,N-L
125	CC(L)=CC(L)+SER(I)*SER(I+L)
	CC(L)=CC(L)/(N-L)
120	CC(L)=CC(L)/C
	C=1.
c
c  estimating rude power spectra
	SPE(1)=0.
	DO 200 L=1,J-1
200	SPE(1)=SPE(1)+CC(L)
	SPE(1)=SPE(1)/J+(C+CC(J))/(2*J)
	DO 210 L=1,J-1
	SPE(L+1)=0.
	DO 220 I=1,J-1
220	SPE(L+1)=SPE(L+1)+CC(I)*COS(3.14159*L*I/J)
210	SPE(L+1)=2*SPE(L+1)/J+C/J+(-1)**L*CC(J)/J
	SPE(J1)=0.
	DO 230 I=1,J-1
230	SPE(J1)=SPE(J1)+(-1)**I*CC(J)
	SPE(J1)=SPE(J1)/J+(C+(-1)**J*CC(J))/(2*J)
c
c  smoothing power spectra
	PS(1)=.54*SPE(1)+.46*SPE(2)
	DO 300 L=2,J
300	PS(L)=.23*SPE(L-1)+.54*SPE(L)+.23*SPE(L+1)
	PS(J1)=.46*SPE(J)+.54*SPE(J1)
c
c  statistical significence of PS
	W=0.
	DO 400 L=1,J-1
400	W=W+SPE(L+1)
	W=W/J+(SPE(1)+SPE(J1))/(2*J)

c---------give the value of alpha in the test-----
        alpha=0.05
c-NOTE: W=a*W, a=(Xv)**2/v, v=(2n-m/2)/m, m is the largest back-lag 
c        length, value 'a' can be found in X**2 test table

        if(alpha.eq.0.1)then
c alpha=0.1
	IF(J.GT.(N/2)) W=2.08*W
        IF(J.EQ.(N/2)) W=2.00*W
      	IF(J.LT.(N/2).AND.J.GT.(N/3)) W=1.89*W
	IF(J.EQ.(N/3)) W=1.81*W
	IF(J.GT.(N/5).AND.J.LT.(N/3)) W=1.69*W
	IF(J.EQ.(N/5)) W=1.61*W
	IF(J.LT.(N/5)) W=1.56*W

        else if(alpha.eq.0.05)then
c alpha=0.05
	IF(J.GT.(N/2)) W=2.57*W
	IF(J.EQ.(N/2)) W=2.49*W
        IF(J.LT.(N/2).AND.J.GT.(N/3)) W=2.323*W
	IF(J.EQ.(N/3)) W=2.157*W
	IF(J.GT.(N/5).AND.J.LT.(N/3)) W=1.979*W
	IF(J.EQ.(N/5)) W=1.85*W
	IF(J.EQ.(N/5)) W=1.85*W
	IF(J.LT.(N/5)) W=1.77*W
	IF(J.LT.(N/5)) W=1.77*W

        else if(alpha.eq.0.01)then
c alpha=0.01
	IF(J.GT.(N/2)) W=3.78*W
	IF(J.EQ.(N/2)) W=3.52*W
	IF(J.LT.(N/2).AND.J.GT.(N/3)) W=3.15*W
	IF(J.EQ.(N/3)) W=2.90*W
	IF(J.GT.(N/5).AND.J.LT.(N/3)) W=2.57*W
	IF(J.EQ.(N/5)) W=2.36*W
	IF(J.LT.(N/5)) W=2.21*W

        else if (alpha.eq.0.001)then
c alpha=0.0001
	IF(J.GT.(N/2)) W=5.42*W
        IF(J.EQ.(N/2)) W=4.96*W
	IF(J.LT.(N/2).AND.J.GT.(N/3)) W=4.33*W
	IF(J.EQ.(N/3)) W=3.91*W
	IF(J.GT.(N/5).AND.J.LT.(N/3)) W=3.36*W
	IF(J.EQ.(N/5)) W=3.02*W
	IF(J.LT.(N/5)) W=2.79*W
        end if

c  the red noice examination
	DO 410 L=1,J1
410	SK(L)=W*(1-CC(1)**2)/(1+CC(1)**2-2*CC(1)*COS(3.14159*(L-1)/J))
	IF(CC(1).GT.0..AND.CC(1).GE.CC(2))GOTO 500
c
c  the white noice examination
	DO 420 L=1,J1
420	SK(L)=W
500	CONTINUE
c
c  calculating the length of cycle
c
c T(1)=TREND, so its period should be unlimited
c*	T(1)=100.
        T(1)=float(N)
c
	DO 600 L=2,J1
600	T(L)=2.*J/(L-1.)
	M=0
777     continue
	DO 700 L=1,J1
	IF(PS(L).LT.SK(L))GOTO 700
	M=M+1
        T0(M)=T(L)
	LT(M)=L-1
700	CONTINUE
c
c  OUTPUT---------------
        open(21,file='NCEP_reof_h850.powerb',form='formatted')
        if(IP0.eq.1)then
	WRITE(21,10)
	WRITE(21,20)(L-1,T(L),PS(L),SK(L),L=1,J1)
        endif
	WRITE(21,30)(LT(L),L=1,M)
	WRITE(21,40)(T0(L),L=1,M)
10	FORMAT(/5X,'POWER SPECTRA'/,3X,'N    T',5X,'PS',5X,'SK')
20	FORMAT(3(1X,I3,1F6.1,2F7.4))
30	FORMAT(//'NUMBER PS>SK'/'NUMBER:',40(1X,20I5))
40	FORMAT('PERIOD:'50(1X,20f5.1))
	RETURN
	END

      SUBROUTINE bpfilter(x0,xLF)
      parameter (pts1=10.,pts2=50.,m=150)
C FFT-Filtering (Press et al., 1989: Numerical 
c  Recipies, Cambridge University Press, Cambridge, 702pp)
c
      REAL*4 x0(m),xLF(m),Y1(1024), Y2(1024)

c-----detrend
      call trend(x0,m,b0,b1,xLF)
      do 25 k=1,m
       Y1(k)=x0(k)-xLF(k)
25     Y2(k)=Y1(k)

c --- Lowpass filtering on the basis of FFT
c --- (Third parameter of "SMOOFT" is responsible for the number of 
c      time steps to be smoothed)

        CALL SMOOFT(Y1,M,pts2)
        DO 35 k=1,M
          xLF(k)=xLF(k)+Y1(k)
          x0(k)=Y2(k)-Y1(k)
          Y2(k)=x0(k)
 35     CONTINUE
         CALL SMOOFT(Y2,M,pts1)
        DO 45 k=1,M
          x0(k)=Y2(k)
 45     CONTINUE

      RETURN
      END
   
      SUBROUTINE lpfilter(x0,xLF)
      parameter (pts=10.,m=150)
C FFT-Filtering (Press et al., 1989: Numerical 
c  Recipies, Cambridge University Press, Cambridge, 702pp)
c
      REAL*4 x0(m),xLF(m),Y1(1024), Y2(1024)

c-----detrend
      call trend(x0,m,b0,b1,xLF)
      do 25 k=1,m
       Y1(k)=x0(k)-xLF(k)
25     Y2(k)=Y1(k)

c --- Lowpass filtering on the basis of FFT
c --- (Third parameter of "SMOOFT" is responsible for the number of 
c      time steps to be smoothed)

        CALL SMOOFT(Y1,M,pts)
        DO 35 k=1,M
          xLF(k)=xLF(k)+Y1(k)
          x0(k)=Y2(k)-Y1(k)
 35     CONTINUE

      RETURN
      END
   

      SUBROUTINE trend(y,n,b0,b1,x)
c---y(n): data source
c---n:data length
c---x(n):=b1*x(i)+b0
      dimension y(n),x(n)
      xm=0.0
      ym=0.0
      xy=0.0
      x2=0.0
      y2=0.0
      do 11 i=1,n
      x(i)=float(i)
      xm=xm+x(i)
      ym=ym+y(i)
      xy=xy+x(i)+y(i)
      x2=x2+x(i)*x(i)
      y2=y2+y(i)*y(i)
11    continue
      xy=xy-xm*ym/float(n)
      x2=x2-xm*xm/float(n)
      y2=y2-ym*ym/float(n)
      b1=xy/x2
      b0=(ym-b1*xm)/n
      do 12 i=1,n
12    x(i)=b1*x(i)+b0
      return
      end

      SUBROUTINE SMOOFT(Y,N,PTS)
c---- Lowpass filtering on the basis of FFT
c---- From: Press, W. H., B. P. Flannery, S. A. Teukolsky and W. T.
c----       Vetterling, 1989: Numerical Recipies, Cambridge University
c----       Press, Cambridge, U. K., 702pp.
c---- Y: data source with length N
c----    but, must define its dimension with length MMAX
c---- N: length of the data
c---- PTS: number of time steps to be smoothed)

      PARAMETER(MMAX=1024)
      DIMENSION Y(MMAX)
      M=2
      NMIN=N+2.*PTS
1     IF(M.LT.NMIN)THEN
        M=2*M
      GO TO 1
      ENDIF
      IF(M.GT.MMAX) STOP 'MMAX too small'
      CONST=(PTS/M)**2
      Y1=Y(1)
      YN=Y(N)
      RN1=1./(N-1.)
      DO 11 J=1,N
        Y(J)=Y(J)-RN1*(Y1*(N-J)+YN*(J-1))
11    CONTINUE
      IF(N+1.LE.M)THEN
        DO 12 J=N+1,M
          Y(J)=0.
12      CONTINUE
      ENDIF
      MO2=M/2
      CALL REALFT(Y,MO2,1)
      Y(1)=Y(1)/MO2
      FAC=1.
      DO 13 J=1,MO2-1
        K=2*J+1
        IF(FAC.NE.0.)THEN
          FAC=AMAX1(0.,(1.-CONST*J**2)/MO2)
          Y(K)=FAC*Y(K)
          Y(K+1)=FAC*Y(K+1)
        ELSE
          Y(K)=0.
          Y(K+1)=0.
        ENDIF
13    CONTINUE
      FAC=AMAX1(0.,(1.-0.25*PTS**2)/MO2)
      Y(2)=FAC*Y(2)
      CALL REALFT(Y,MO2,-1)
      DO 14 J=1,N
        Y(J)=RN1*(Y1*(N-J)+YN*(J-1))+Y(J)
14    CONTINUE
      RETURN
      END
      SUBROUTINE REALFT(DATA,N,ISIGN)
      REAL*8 WR,WI,WPR,WPI,WTEMP,THETA
      DIMENSION DATA(*)
      THETA=6.28318530717959D0/2.0D0/DBLE(N)
      C1=0.5
      IF (ISIGN.EQ.1) THEN
        C2=-0.5
        CALL FOUR1(DATA,N,+1)
      ELSE
        C2=0.5
        THETA=-THETA
      ENDIF
      WPR=-2.0D0*DSIN(0.5D0*THETA)**2
      WPI=DSIN(1.D0*THETA)
      WR=1.0D0+WPR
      WI=WPI
      N2P3=2*N+3
      DO 11 I=2,N/2+1
        I1=2*I-1
        I2=I1+1
        I3=N2P3-I2
        I4=I3+1
        WRS=REAL(WR)
        WIS=REAL(WI)
        H1R=C1*(DATA(I1)+DATA(I3))
        H1I=C1*(DATA(I2)-DATA(I4))
        H2R=-C2*(DATA(I2)+DATA(I4))
        H2I=C2*(DATA(I1)-DATA(I3))
        DATA(I1)=H1R+WRS*H2R-WIS*H2I
        DATA(I2)=H1I+WRS*H2I+WIS*H2R
        DATA(I3)=H1R-WRS*H2R+WIS*H2I
        DATA(I4)=-H1I+WRS*H2I+WIS*H2R
        WTEMP=WR
        WR=WR*WPR-WI*WPI+WR
        WI=WI*WPR+WTEMP*WPI+WI
11    CONTINUE
      IF (ISIGN.EQ.1) THEN
        H1R=DATA(1)
        DATA(1)=H1R+DATA(2)
        DATA(2)=H1R-DATA(2)
      ELSE
        H1R=DATA(1)
        DATA(1)=C1*(H1R+DATA(2))
        DATA(2)=C1*(H1R-DATA(2))
        CALL FOUR1(DATA,N,-1)
      ENDIF
      RETURN
      END

      SUBROUTINE FOUR1(DATA,NN,ISIGN)
      REAL*8 WR,WI,WPR,WPI,WTEMP,THETA
      DIMENSION DATA(*)
      N=2*NN
      J=1
      DO 11 I=1,N,2
        IF(J.GT.I)THEN
          TEMPR=DATA(J)
          TEMPI=DATA(J+1)
          DATA(J)=DATA(I)
          DATA(J+1)=DATA(I+1)
          DATA(I)=TEMPR
          DATA(I+1)=TEMPI
        ENDIF
        M=N/2
1       IF ((M.GE.2).AND.(J.GT.M)) THEN
          J=J-M
          M=M/2
        GO TO 1
        ENDIF
        J=J+M
11    CONTINUE
      MMAX=2
2     IF (N.GT.MMAX) THEN
        ISTEP=2*MMAX
        THETA=6.28318530717959D0/(ISIGN*MMAX)
        WPR=-2.D0*DSIN(0.5D0*THETA)**2
        WPI=DSIN(1.D0*THETA)
        WR=1.D0
        WI=0.D0
        DO 13 M=1,MMAX,2
          DO 12 I=M,N,ISTEP
            J=I+MMAX
            TEMPR=REAL(WR)*DATA(J)-REAL(WI)*DATA(J+1)
            TEMPI=REAL(WR)*DATA(J+1)+REAL(WI)*DATA(J)
            DATA(J)=DATA(I)-TEMPR
            DATA(J+1)=DATA(I+1)-TEMPI
            DATA(I)=DATA(I)+TEMPR
            DATA(I+1)=DATA(I+1)+TEMPI
12        CONTINUE
          WTEMP=WR
          WR=WR*WPR-WI*WPI+WR
          WI=WI*WPR+WTEMP*WPI+WI
13      CONTINUE
        MMAX=ISTEP
      GO TO 2
      ENDIF
      RETURN
      END

      SUBROUTINE output1(x,sx,n,ip)
      real*4 x(ip,n),y(n,ip),sx(ip)

      do 10 k=1,ip
      do 10 i=1,n
10    y(i,k)=x(k,i)

      do 20 k=1,ip
20      CALL teedss(1,n,y(1,k),ex,dx,sx(k),nr)

      do 30 k=1,ip
      do 30 i=1,n
30    x(k,i)=y(i,k)
       return
       end

      SUBROUTINE amax1(a,ix,b,ii)
      REAL*4 a(ix)
      b=0.
      do i=1,ix
       if (abs(a(i)).gt.abs(b)) then
      b=a(i)
      ii=i
       endif
      enddo
      return
      end

      SUBROUTINE eof(d,tna,vna1,ah,vna,aa,m,n)
      REAL*4 d(m),tna(m,m),vna(m,m),vna1(n,m),ah(m,n),aa(m,m)
c--ATTENTION: n<Ie (the parameter in subroutines tql2,treda2,qlm)
c
c     m--time   n---space
c      
      CALL hm(m,n,aa,ah)
      CALL qlm(m,aa,1e-10,1e-20,d,vna,kfail)
      print*,'kfail of EOF =',kfail
c      print*,'d/EOF',d
      do 44 i=1,n
      do 44 j=1,m
       vna1(i,j)=ah(1,i)*vna(1,j)
       do 45 k=2,m
  45   vna1(i,j)=vna1(i,j)+ah(k,i)*vna(k,j)
  44    vna1(i,j)=vna1(i,j)/sqrt(abs(d(j)))
      CALL hm1(m,n,vna1,tna,ah)
      return
      end
  
      SUBROUTINE hm(m,n,a,f)
      REAL*4 a(m,m),f(m,n)
      do 10 i=1,m
      do 10 j=1,m
       a(i,j)=f(i,1)*f(j,1)
       do 10 k=2,n
10      a(i,j)=a(i,j)+f(i,k)*f(j,k)
      return  
      end
    
      SUBROUTINE hm1(m,n,v,t,f)
      REAL*4 v(n,m),t(m,m),f(m,n)
      do 10 i=1,m
      do 10 j=1,m
       t(i,j)=f(i,1)*v(1,j)
       do 10 k=2,n
10      t(i,j)=t(i,j)+f(i,k)*v(k,j)
      return
      end

      SUBROUTINE tql2(n,eps,d,e,z,kfail) 
      REAL*4 d(n),e(9000),z(n,n)
      do 10 i=2,n
      im1=i-1
   10 e(im1)=e(i)
      f=0.0
      b=0.0
      e(n)=0.0
      do 20 l=1,n
      j=0
      h=eps*(abs(d(l))+abs(e(l)))
      lp1=l+1
      if(b-h) 30,40,40
   30 b=h
   40 do 50 m=l,n
      if(abs(e(m))-b) 60,60,50
   50 continue
   60 if(m-l) 70,80,70
   70 if(j-30)90,100,90
   90 j=j+1
      p=(d(lp1)-d(l))/(2.*e(l))
      r=sqrt(p*p+1.)
      if(p) 110,120,120
  110 h=d(l)-e(l)/(p-r)
      go to 130
  120 h=d(l)-e(l)/(p+r)
  130 do 140 i=l,n
  140 d(i)=d(i)-h
      f=f+h
      p=d(m)
      c=1.
      s=0.
      mm1=m-1
      if(mm1-l) 270,280,280
  280 do 150 lmipmm=l,mm1
      i=l+mm1-lmipmm
      ip1=i+1
      g=c*e(i)
      h=c*p
      if(abs(p)-abs(e(i))) 160,170,170
  170 c=e(i)/p
      r=sqrt(c*c+1.)
      e(ip1)=s*p*r
      s=c/r
      c=1./r
      go to 180
  160 c=p/e(i)
      r=sqrt(c*c+1.)
      e(ip1)=s*e(i)*r
      s=1./r
      c=c/r
  180 p=c*d(i)-s*g
      d(ip1)=h+s*(c*g+s*d(i))
      do 190 k=1,n
      h=z(k,ip1)
      z(k,ip1)=s*z(k,i)+c*h
  190 z(k,i)=c*z(k,i)-s*h
  150 continue
  270 e(l)=s*p
      d(l)=c*p
      if(abs(e(l))-b) 80,80,70
   80 d(l)=d(l)+f
   20 continue
      do 200 i=1,n
      ip1=i+1
      k=i
      p=d(i)
      if(n-i) 230,230,300
  300 do 210 j=ip1,n
      if(d(j)-p) 220,210,210
  220 k=j
      p=d(j)
  210 continue
  230 if(k-i) 240,200,240
  240 d(k)=d(i)
      d(i)=p
      do 260 j=1,n
      p=z(j,i)
      z(j,i)=z(j,k)
  260 z(j,k)=p
  200 continue
      kfail=0
      return
  100 kfail=1
      return
      end

      SUBROUTINE treda2(n,beta,a,d,e,z)
      REAL*4 a(n,n),d(n),e(9000),z(n,n)
      do 10 i=1,n
      do 10 j=1,i
   10 z(i,j)=a(i,j)
      do 20 nmip2=2,n
      i=n+2-nmip2
      im1=i-1
      im2=i-2
      l=im2
      f=z(i,im1)
      g=0.0
      if(l) 30,30,40
   40 do 50 k=1,l
   50 g=g+z(i,k)*z(i,k)
   30 h=g+f*f
      if(g-beta) 60,60,70
   60 e(i)=f
      h=0.0
      go to 180
   70 l=l+1
      if(f) 80,90,90
   90 e(i)=-sqrt(h)
      g=e(i)
      go to 100
   80 e(i)=sqrt(h)
      g=e(i)
  100 h=h-f*g
      z(i,im1)=f-g
      f=0.0
      do 110 j=1,l
      z(j,i)=z(i,j)/h
      g=0.0
      do 120 k=1,j
  120 g=g+z(j,k)*z(i,k)
      jp1=j+1
      if(jp1-l) 130,130,140
  130 do 150 k=jp1,l
  150 g=g+z(k,j)*z(i,k)
  140 e(j)=g/h
      f=f+g*z(j,i)
  110 continue
      hh=f/(h+h)
      do 160 j=1,l
      f=z(i,j)
      e(j)=e(j)-hh*f
      g=e(j)
      do 170 k=1,j
  170 z(j,k)=z(j,k)-f*e(k)-g*z(i,k)
  160 continue
  180 d(i)=h
   20 continue
      d(1)=0.0
      e(1)=0.0
      do 190 i=1,n
      l=i-1
      if(d(i)) 200,210,200
  200 if(l) 210,210,220
  220 do 230 j=1,l
      g=0.
      do 240 k=1,l
  240 g=g+z(i,k)*z(k,j)
      do 250 k=1,l
  250 z(k,j)=z(k,j)-g*z(k,i)
  230 continue
  210 d(i)=z(i,i)
      z(i,i)=1.
      if(l) 260,260,270
  270 do 280 j=1,l
      z(i,j)=0.0
  280 z(j,i)=0.0
  260 continue
  190 continue
      return
      end
      
      SUBROUTINE qlm(n,a,eps,beta,d,z,kfail)
      REAL*4 a(n,n),d(n),e(9000),z(n,n)
      CALL treda2(n,beta,a,d,e,z)
      CALL tql2(n,eps,d,e,z,kfail)
      return
      end

      SUBROUTINE teedss(nm1,n,ax,ex,dx,sx,nr)
      integer nm1,n,nr
      real    ax(n),ex,dx,sx
c
      data   epsilo/0.1e-8/
      double precision x,a,exd,dxd
c--------------------------------------------------------c
      nr=1
      exd=ax(1)
      dxd=0.0d0
      do 10 i=2,n
      x=ax(i)
      a=x-exd
      exd=exd+a/float(i)
c     dxd=dxd+a*(x-exd)
   10 continue
c     dxd=dxd/float(n)
c     dx=dxd

      ex=exd
c     sx=dsqrt(dxd)
      do i=1,n
      dxd=dxd+(ax(i)-ex)**2
      end do
      dxd=dxd/n
      dx=dxd
      sx=dsqrt(dxd)
      if (nm1.lt.1.or.sx.le.epsilo) go to 999
      nr=0
      k=mod(n,3)+1
      go to (25,20,15),k
   15 ax(2)=(ax(2)-ex)/sx
   20 ax(1)=(ax(1)-ex)/sx
   25 do 30 i=k,n,3
      ax(i)=(ax(i)-ex)/sx
      ax(i+1)=(ax(i+1)-ex)/sx
      ax(i+2)=(ax(i+2)-ex)/sx
   30 continue
C
  999 return 
      end 

c-------------------------------------------------------------
c  Subroutine to rotate the EOF result
c  B(m,ip)   loading array
c  VV(m)     variance of factors
c  F(ip,n)   factors  array
c  dl(ip)    variance contribution 
c  Ua(m)     working array
c  Va(m)     working array
c  H(m)      working array
c  Bn(m,ip)  working array
c  Fn(ip,n)  working array
c m----space,n----time
c----------------------------------------------------------------
      SUBROUTINE  roteof(b,vv,f,dl,ua,va,h,bn,fn,m,n,ip)
      REAL*4  b(m,ip),vv(m),f(ip,n),bn(m,ip),fn(ip,n),h(m)
      REAL*4  ua(m),va(m),dl(ip)
      rm=float(m)
c-----------------------------------------------------------------
c    to rotate the b and f array
c-----------------------------------------------------------------
	do 200 k=1,ip-1
	k1=k
	kb=k1+1
	do 201 kkx=kb,iP
	k2=kkx 
	do 202 j=1,m
	h(j)=0.
	do 202 ix=1,ip
202	h(j)=h(j)+b(j,ix)*b(j,ix)
	do 203 j=1,m
	if(h(j) .eq. 0. ) then
	u1=0.
	v1=0.
	va(j)=0.
	else
	u1=b(j,k1)*b(j,k1)
	u2=b(j,k2)*b(j,k2)
	va(j)=2.*b(j,k1)*b(j,k2)/h(j)
	endif
203	ua(j)=(u1-u2)/h(j)
	a=0.
	bd=0.
	c=0.
	d1=0.
	do 204 l=1,m
	a=a+ua(l)
	bd=bd+va(l)
	c=c+(ua(l)*ua(l)-va(l)*va(l))
204	d1=d1+ua(l)*va(l)
	d=2.*d1
	f2=d-2.*a*bd/rm
	f1=c-(a*a-bd*bd)/rm
	fff=sqrt(f2*f2+f1*f1)
	cf4=f1/fff
	cf2=sqrt((1.+cf4)*0.5)
	cf=sqrt((1.+cf2)*0.5)
	sf=sqrt(1.-cf*cf)
	if( f2 .lt. 0. ) then
	sf=-sf
	endif
c------------------------------------------------------------
c   for total variance of b(m,ip)
c------------------------------------------------------------
	do 205 j=1,ip
	vn1=0.
	vn2=0.
	do 206 ix=1,m
	if( h(ix) .eq. 0.) then
	v1=0.
	else
	sqrth=sqrt(h(ix))
	v1=b(ix,j)/sqrth
	v1=v1*v1
	endif
	v2=v1*v1
	vn1=vn1+v1
206	vn2=vn2+v2
	vs=vn1
205	vv(j)=vn2*rm-vs*vs
c-----------------------------------------------------------
c
c-----------------------------------------------------------
	tv=0.
	do 207 j=1,ip
207	tv=tv+vv(j)
c-----------------------------------------------------------
CCC	print*, 'Total variance ', tv
c-----------------------------------------------------------
c    to rotate b(m,ip) and f(ip,n)
	do 208 ix=1,m
	do 208 jx=1,ip
208	bn(ix,jx)=b(ix,jx)
	do 209 ix=1,m
	bn(ix,k1)=b(ix,k1)*cf+b(ix,k2)*sf
209	bn(ix,k2)=-b(ix,k1)*sf+b(ix,k2)*cf
	do 210 ix=1,m
	do 210 jx=1,ip
210	b(ix,jx)=bn(ix,jx)
	do 211 j1=1,n
	do 211 i1=1,ip
211	fn(i1,j1)=f(i1,j1)
	do 212 j=1,n
	fn(k1,j)=cf*f(k1,j)+sf*f(k2,j)
212	fn(k2,j)=-sf*f(k1,j)+cf*f(k2,j)
	do 213 i1=1,ip
	do 213 j1=1,n
213	f(i1,j1)=fn(i1,j1)
201     continue
200     continue
        do 131 k=1,ip
	s=0.0
	do 133 j=1,m
	ajk=b(j,k)
133     s=s+ajk*ajk
131     dl(k)=s
	return
	end
