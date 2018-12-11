with sorok as (select u.nev, u.cim, u.kapcsolattarto, t.kod kurzus, tt.nev kurzus_nev, t.kezdodatum, t.vegedatum, f.resztvevo, ta.ar
    from foglalas f, ugyfel u, tanfolyam t, tanfolyam_tipus tt, tanfolyam_ar ta
    where f.ugyfel_nev = u.nev
    and f.tanfolyam_kod = t.kod
    and tt.kod = t.tanfolyam_tipus_kod
    and ta.tanfolyam_tipus_kod = t.tanfolyam_tipus_kod
    and ta.ervenyes = (select max(x.ervenyes) from tanfolyam_ar x where x.tanfolyam_tipus_kod = t.tanfolyam_tipus_kod and x.ervenyes <= t.kezdodatum)
    order by u.nev, t.kod, f.resztvevo)
select s1.*, s2.*
from sorok s1, (select nev, kurzus, sum(ar) netto, sum(ar)*0.27 afa_27, sum(ar)*1.27 brutto from sorok group by nev, kurzus) s2
where s1.nev = s2.nev
and s1.kurzus = s2.kurzus

