c     program     :     sample_read_gauge_peng.lnx.f 
c     objective   :     sample program 
c                       1) to convert 0.5deg grid to 2.0deg grid 
c                       2) to define weekly mean precip 
c
      parameter  ( kyy_str = 2006, kyy_end = 2007 ) 
c 
c 
      parameter  ( nx025 = 1440, ny025 = 720 ) 
      parameter  ( nx050 =  720, ny050 = 360 ) 
      parameter  ( nx250 =  144, ny250 =  72 ) 
c
      character  cyear*4, cdate*8, 
     #           cfile11*89, cfile12*92, 
     #           cfile50*24, cfile60*24  
c
      dimension  rain025 (nx025,ny025), 
     #           rain050 (nx050,ny050), 
     #           nn250 (nx250,ny250,52),  
     #           ss250 (nx250,ny250,52), 
     #           rain250 (nx250,ny250) 
c
      dimension  nday (12)
      data       nday / 31, 28, 31, 30, 31, 30,
     #                  31, 31, 30, 31, 30, 31 /
c   
      kyy = kyy_str 
 1000 write  (6,*)  'started  processing for :', kyy 
c
c     1.  to open the output yearly files 
c 
      write  (cyear,1951)  kyy 
 1951 format  (i4) 
      cfile50 ( 1:24) = 'CUDP_dy_2.50deg.lnx.yyyy' 
      cfile50 (21:24) = cyear (1:4) 
      cfile60 ( 1:24) = 'CUDP_wk_2.50deg.lnx.yyyy'
      cfile60 (21:24) = cyear (1:4)
      write  (6,*)  cfile50 
      write  (6,*)  cfile60 
      open  (unit=50, 
     #       file=cfile50, 
     #       access='direct', recl=nx250*ny250*4) 
      open  (unit=60,
     #       file=cfile60,
     #       access='direct', recl=nx250*ny250*52*4)
      write  (6,*)  '     finished opening output files !!' 
c
c     2.  to determine the number of days in feb 
c
      m004 = mod (kyy,  4)
      m100 = mod (kyy,100)
      m400 = mod (kyy,400)
      kleap = 0
      if  (m004.eq.0)  then
        kleap = 1
        if  (m100.eq.0)  then
          kleap = 0
          if  (m400.eq.0)  then
            kleap = 1
          end  if
        end  if
      end  if
      if  (kleap.eq.0)  then
        nday (2) = 28
      else
        nday (2) = 29
      end  if
      write  (6,*)  '     # of days in Feb :', nday (2)
c
c     3.  to convert the daily data to 2.5deg grid  
c 
      kday  = 0 
      do 3999 kmm = 1, 12 
      do 3999 kdd = 1, nday (kmm) 
c 
c       3.1  to open daily files 
c 
        kdate = kyy*10000 + kmm*100 + kdd
        write  (cdate,3951)  kdate
 3951   format  (i8)
c
        if  (kyy.le.2006)  then
          cfile11 ( 1:31) = '/cpc/prcp/PRODUCTS/CPC_UNI_PRCP'
          cfile11 (32:46) = '/GAUGE_GLB/yyyy'
          cfile11 (47:81) = '/PRCP_CU_GAUGE_V1.0GLB_0.50deg.lnx.'
          cfile11 (43:46) = cdate (1:4)
          cfile11 (82:89) = cdate (1:8)
          open  (unit=10,
     #           file=cfile11,
     #           access='direct', recl=nx050*ny050*4)
        else
          cfile12 ( 1:31) = '/cpc/prcp/PRODUCTS/CPC_UNI_PRCP'
          cfile12 (32:46) = '/GAUGE_GLB/yyyy'
          cfile12 (47:81) = '/PRCP_CU_GAUGE_V1.0GLB_0.50deg.lnx.'
          cfile12 (43:46) = cdate (1:4)
          cfile12 (82:89) = cdate (1:8)
          cfile12 (90:92) = '.RT' 
          open  (unit=10,
     #           file=cfile12,
     #           access='direct', recl=nx050*ny050*4)
        end  if
c        write  (6,*)  cfile11  
c 
c       3.2  to read the data on 0.5deg grid 
c 
        read  (10,rec=1)  rain050  
c
c       3.3  to convert the data onto a 2.5deg lat/lon grid 
c 
        do 3303 jj = 1, ny050 
          j1 = (jj-1)*2 + 1 
          j2 = j1 + 1 
          do 3302 ii = 1, nx050 
            i1 = (ii-1)*2 + 1 
            i2 = i1 + 1 
            do 3301 j = j1, j2 
            do 3301 i = i1, i2 
              rain025 (i,j) = rain050 (ii,jj) 
 3301       continue 
 3302     continue 
 3303   continue 
c
        do 3306 jj = 1, ny250 
          j1 = (jj-1)*10 - 4 
          j2 = j1 + 9 
          if  (j1.lt.1)  then 
            j1 = 1 
          end  if  
          if  (j2.gt.ny025)  then 
            j2 = ny025 
          end  if  
          do 3305 ii = 1, nx250 
            i1 = (ii-1)*10 - 4 
            i2 = i1 + 9 
            nn = 0 
            sw = 0.0 
            ss = 0.0 
            do 3304 j = j1, j2 
            do 3304 i = i1, i2 
              js = j 
              if  (i.le.0)  then 
                is = i + nx025 
              else  if  (i.ge.1.and.i.le.nx025)  then 
                is = i 
              else 
                is = i - nx025 
              end  if  
              if  (rain025(is,js).ge.0.0)  then 
                rlat = (js-1)*0.25 - 89.875 
                rlat = rlat * 3.14159 / 180.0 
                ww   = cos (rlat) 
                nn   = nn + 1 
                sw   = sw + ww 
                ss   = ss + ww * rain025 (is,js) 
              end  if  
 3304       continue 
            if  (nn.ge.30)  then 
              rain250 (ii,jj) = ss / sw 
            else 
              rain250 (ii,jj) = -999.0 
            end  if    
 3305     continue 
 3306   continue 
c
c       3.4  to output the daily / 2.5 deg fields  
c 
        kday = kday + 1 
        kout = kday 
        write  (50,rec=kout)  rain250 
c 
 3999 continue 
      write  (6,*)  '     finished converting to 2.5 deg grid !!' 
c
c     4.  to define weekly mean precip 
c 
c     4.1  to initialize 
c 
      do 4101 kk = 1, 52 
      do 4101 jj = 1, ny250 
      do 4101 ii = 1, nx250 
        nn250 (ii,jj,kk) = 0 
        ss250 (ii,jj,kk) = 0.0 
 4101 continue 
c 
c     4.2  to read the daily fields 
c 
      kday  = 0
      do 4299 kmm = 1, 12
      do 4299 kdd = 1, nday (kmm)
c 
        kday = kday + 1 
        kinp = kday 
        read  (50,rec=kinp)  rain250 
c 
        if  (kleap.eq.0)  then
          kww = int ((kday-1.0)/7.0) + 1
        else
          if  (kday.le.56)  then
            kww = int ((kday-1.0)/7.0) + 1
          else if  (kday.le.64)  then
            kww = 9  
          else
            kww = int ((kday-2.0)/7.0) + 1
          end  if
        end  if
        if  (kww.gt.52)  then 
          kww = 52 
        end  if  
c
        do 4201 jj = 1, ny250 
        do 4201 ii = 1, nx250 
          if  (rain250(ii,jj).ge.0.0)  then 
            nn250 (ii,jj,kww) = nn250 (ii,jj,kww) + 1 
            ss250 (ii,jj,kww) = ss250 (ii,jj,kww) 
     #                        + rain250 (ii,jj)  
          end  if  
 4201   continue  
c 
 4299 continue 
c
c     4.3  to define weekly mean 
c 
      do 4301 kk = 1, 52 
      do 4301 jj = 1, ny250 
      do 4301 ii = 1, nx250 
        if  (nn250(ii,jj,kk).ge.4)  then 
          ss250 (ii,jj,kk) = ss250 (ii,jj,kk) / nn250 (ii,jj,kk)
        else 
          ss250 (ii,jj,kk) = -999.0 
        end  if  
 4301 continue 
c
c     4.4  to output 
c 
      write  (60,rec=1)  ss250 
      write  (6,*)  '     finished defining weekly fields  !!' 
c 
c 
      close  (unit=10) 
      close  (unit=50) 
      close  (unit=60) 
c
      write  (6,*)  'finished processing for :', kyy 
c 
      if  (kyy.lt.kyy_end)  then
        kyy = kyy + 1
        go  to  1000
      end  if
c
c
      stop 
      end  
