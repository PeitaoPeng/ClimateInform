** pick indices for target month
pat=pna
month=Jul
imon=7
*eyr=gb2000
eyr=2000
'reinit'
'open /cpc/consistency/telecon/gb/monthly_raw_tele_indices.'eyr'.ctl'
*'open /cpc/consistency/telecon/gb/monthly_'pat'_indices.gb2000.ctl'
*
'set gxout fwrite'
'set fwrite /cpc/consistency/telecon/gb/index_'pat'.'month'.'eyr'.gr'
it=imon
while (it <= 870)
'set t 'it
say 'it='it
'd 'pat'' 
it=it+12
endwhile
'disable fwrite'
