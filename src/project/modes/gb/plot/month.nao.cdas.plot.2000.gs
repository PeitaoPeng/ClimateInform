** Create standardized 3-month running mean NAO index plot
eyr=2000
'reinit'
'open /cpc/consistency/telecon/gb/monthly_raw_tele_indices.'eyr'.ctl'
'open /cpc/consistency/telecon/gb/monthly_nao_indices.gb2000.ctl'
*
'define sd1=sqrt(ave(nao*nao,t=1,t=870))'
'define sd2=sqrt(ave(nao.2*nao.2,t=1,t=870))'
'define ac=ave(nao*nao.2,t=1,t=870)/(sd1*sd2)'
*
'enable print mon.nao.gx' 
*
*pull month
*pull year
month=June
year=2022
say month year
if(month = "December");imoend=12;cmon=dec;endif
if(month = "January");imoend=1;cmon=jan;endif
if(month = "February");imoend=2;cmon=feb;endif
if(month = "March");imoend=3;cmon=mar;endif
if(month = "April");imoend=4;cmon=apr;endif
if(month = "May");imoend=5;cmon=may;endif
if(month = "June");imoend=6;cmon=jun;endif
if(month = "July");imoend=7;cmon=jul;endif
if(month = "August");imoend=8;cmon=aug;endif
if(month = "September");imoend=9;cmon=sep;endif
if(month = "October");imoend=10;cmon=oct;endif
if(month = "November");imoend=11;cmon=nov;endif
*
'set t 1 12'
*'define clim=ave('nao',t+372,t=732,12)'
'define clim=ave('nao',t+0,t=612,12)'
'modify clim seasonal'
*'define var = ave(pow('nao'-clim,2),t+372,t=732,12)'
'define var = ave(pow('nao'-clim,2),t+0,t=612,12)'
'modify var seasonal'
'set time jan1950 'cmon''year
'define normtel=('nao'-clim)/sqrt(var)'
*
*calculate standarized 3-month running mean index values
*
'define runmean=ave(normtel,t-2,t+0)'
'set t 1 12'
*'define clim2=ave(runmean,t+372,t=732,12)'
'define clim2=ave(runmean,t+0,t=612,12)'
'modify clim2 seasonal'
*'define var2 = ave(pow(runmean-clim2,2),t+372,t=732,12)'
'define var2 = ave(pow(runmean-clim2,2),t+0,t=612,12)'
'modify var2 seasonal'
'set time jan1950 'cmon''year
'define nortel2=(runmean-clim2)/sqrt(var2)'
*
'set grads off'
'set vpage .1 8.4 7.9 10.9'
*'set parea 1.0 10 6.3 7.8'
'set axlim -3 3'
'set gxout linefill'
'set lfcols 2 4'
'set time jan1950 dec1964'
'aa=0'
'set cmark 0'
'set yaxis -3 3 1'
'set grads off'
'd nortel2;aa'
*
'set grads off'
*'set parea 1.0 10 4.4 5.9'
'set vpage .1 8.4 6.0 9.0'
'set axlim -3 3'
'set gxout linefill'
'set lfcols 2 4'
'set time jan1965 dec1979'
'aa=0'
'set cmark 0'
'set yaxis -3 3 1'
'set grads off'
'd nortel2;aa'
*
'set grads off'
'set vpage .1 8.4 4.1 7.1'
*'set parea 1.0 10 2.4 3.9'
'set axlim -3 3'
'set gxout linefill'
'set lfcols 2 4'
'set time jan1980 dec1994'
'aa=0'
'set cmark 0'
'set yaxis -3 3 1'
'set grads off'
'd nortel2;aa'
*
'set grads off'
'set vpage .1 8.4 2.2 5.2'
*'set parea 1.0 10 0.4 1.9'
'set axlim -3 3'
'set gxout linefill'
'set lfcols 2 4'
'set time jan1995 dec2009'
'aa=0'
'set cmark 0'
'set yaxis -3 3 1'
'set grads off'
'd nortel2;aa'
*
'set grads off'
'set vpage .1 8.5 .3 3.3'
'set axlim -3 3'
'set gxout linefill'
'set lfcols 2 4'
'set time jan2010 dec2024'
'aa=0'
'set cmark 0'
'set yaxis -3 3 1'
'set grads off'
'd nortel2;aa'
*

*'draw line 0.1 0.1 10.7 0.1'
*'draw line 0.1 0.1  0.1 8.4'
*'draw line 0.1 8.4 10.7 8.4'
*'draw line 10.7 0.1 10.7 8.4'
'set vpage 0 8.5 0 11.0'
'set strsiz 0.17'
'set string 4 tc 6'
'draw string 5 10.8 3-Month Running Mean NAO Index'
'draw string 5 10.5 Through 'month' 'year '(1950-2000 pattern)'
*
'printim mon.nao.'eyr'.gif white'
*'define sd1=sqrt(ave(nao*nao,t=1,t=870))'
*'define sd2=sqrt(ave(nao.2*nao.2,t=1,t=870))'
*'define ac=ave(nao*nao.2,t=1,t=870)/(sd1*sd2)'
*'disable'
*'quit'
