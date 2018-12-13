select o.nev as "Oktató név"
, t.kod as "Tanfolyamkód"
, t.kezdodatum as "Kezdõdátum"
, h.nev as "Helyszín neve"
, count(f.resztvevo) as "Résztvevõk száma"

from oktato o
inner join tanfolyam t on o.kod = t.oktato_kod
inner join helyszin h on t.helyszin_kod = h.kod
inner join foglalas f on f.tanfolyam_kod = t.kod
where o.kod = 'NB' and f.statusz ='Megerositett'
group by o.nev, t.kod, t.kezdodatum, h.nev

/*
Oktató név                                         Tanfolyamk Kezdõdátu Helyszín neve                                      Résztvevõk száma
-------------------------------------------------- ---------- --------- -------------------------------------------------- ----------------
Nagy Béla                                          EXSFEB1    18-FEB-15 Zöld ház                                                          5
Nagy Béla                                          CSTJAN2    18-JAN-20 Piros ház                                                         5
Nagy Béla                                          STSFEB1    18-FEB-20 Fehér ház                                                         3
*/
