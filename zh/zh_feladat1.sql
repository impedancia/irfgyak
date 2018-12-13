select o.nev as "Oktat� n�v"
, t.kod as "Tanfolyamk�d"
, t.kezdodatum as "Kezd�d�tum"
, h.nev as "Helysz�n neve"
, count(f.resztvevo) as "R�sztvev�k sz�ma"

from oktato o
inner join tanfolyam t on o.kod = t.oktato_kod
inner join helyszin h on t.helyszin_kod = h.kod
inner join foglalas f on f.tanfolyam_kod = t.kod
where o.kod = 'NB' and f.statusz ='Megerositett'
group by o.nev, t.kod, t.kezdodatum, h.nev

/*
Oktat� n�v                                         Tanfolyamk Kezd�d�tu Helysz�n neve                                      R�sztvev�k sz�ma
-------------------------------------------------- ---------- --------- -------------------------------------------------- ----------------
Nagy B�la                                          EXSFEB1    18-FEB-15 Z�ld h�z                                                          5
Nagy B�la                                          CSTJAN2    18-JAN-20 Piros h�z                                                         5
Nagy B�la                                          STSFEB1    18-FEB-20 Feh�r h�z                                                         3
*/
