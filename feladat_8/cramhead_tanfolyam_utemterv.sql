select kezdodatum, vegedatum, kod, nev, felelos, hely, oktato, maxletszam,
sum(ideig) ideiglenes,  sum(bizt) biztos, sum(ideig) + sum(bizt) osszes, sum(kesz) keszen
from
(select t.kezdodatum, t.vegedatum, t.kod, tt.nev, tt.oktato_kod felelos, h.nev hely, t.oktato_kod oktato, tt.maxletszam,
(case when statusz = 'Ideiglenes' then 1 else 0 end) ideig, 
(case when statusz = 'Megerositett' then 1 else 0 end) bizt, 
(case when statusz = 'Ideiglenes + Készenlét' then 1 else 0 end) kesz
from tanfolyam t, tanfolyam_tipus tt, helyszin h,
foglalas f
where tt.kod = t.tanfolyam_tipus_kod
and t.helyszin_kod = h.kod
and t.kod = f.tanfolyam_kod (+))
group by kezdodatum, vegedatum, kod, nev,felelos, hely, oktato, maxletszam
order by kezdodatum, kod