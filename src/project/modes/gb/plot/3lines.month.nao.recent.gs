** Create standardized 3-month running mean NAO index plot
'reinit'
'open /cpc/consistency/telecon/gb/monthly_nao_indices.gb2000.ctl'
'open /cpc/consistency/telecon/gb/monthly_raw_tele_indices.2000.ctl'
'open /cpc/consistency/telecon/gb/monthly_raw_tele_indices.2020.ctl'
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
'define clm1=ave('nao',t+0,t=852,12)'
'define clm2=ave('nao.2',t+0,t=852,12)'
'define clm3=ave('nao.3',t+0,t=852,12)'
'modify clm1 seasonal'
'modify clm2 seasonal'
'modify clm3 seasonal'
*'define var = ave(pow('nao'-clim,2),t+372,t=732,12)'
'define var1 = ave(pow('nao'-clm1,2),t+0,t=852,12)'
'define var2 = ave(pow('nao.2'-clm2,2),t+0,t=852,12)'
'define var3 = ave(pow('nao.3'-clm3,2),t+0,t=852,12)'
'modify var1 seasonal'
'modify var2 seasonal'
'modify var3 seasonal'
'set time jan1950 'cmon''year
'define nidx1=('nao'-clm1)/sqrt(var1)'
'define nidx2=('nao.2'-clm2)/sqrt(var2)'
'define nidx3=('nao.3'-clm3)/sqrt(var3)'
*
'set vpage 0 11 0 8.5'
'set grads off'
'set parea 0.5 10.7 4.0 7.5'
'set axlim -3.5 3.5'
*
'set time jan2010 dec2022'
'set gxout line'
'set cstyle 1'
'set cthick 5'
'set ccolor 2'
'set cmark 0'
'd nidx1'
'set cmark 0'
'set ccolor 1'
'd nidx3'
*
'set vpage 0 11 0 8.5'
'set strsiz 0.15'
'set string 4 tc 6'
'draw string 5.5 8.2 Monthly NAO Index'
'set cthick 5'
'set line 2'
'set cmark 0'
'draw line 1.5 7.75 2.0 7.75'
'set string 1 tl 5'
'set strsiz 0.12'
'draw string 2.0 7.82 OPR(Gerry)'
*
'set line 1'
'set cmark 0'
'draw line 4.5 7.75 5.0 7.75'
'set string 1 tl 5'
'set strsiz 0.12'
'draw string 5.0 7.82 new-2'
*
'printim mon.nao.3lines.recent.gif white'
'set t 1'
'define ac12=ave(nidx1*nidx2,t=1,t=870)'
'define ac13=ave(nidx1*nidx3,t=1,t=870)'
*'disable'
*'quit'
