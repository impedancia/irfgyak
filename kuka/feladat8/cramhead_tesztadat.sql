--ügyfél
insert into ugyfel values ('Ugyfel1','Cim1','6666666','Kapcs1');
insert into ugyfel values ('Ugyfel2','Cim2','7777777','Kapcs2');
insert into ugyfel values ('Ugyfel3','Cim3','8888888','Kapcs3');

--helyszín
insert into helyszin values ('PH','Piros ház','Piros u. 1.','1111111');
insert into helyszin values ('FH','Fehér ház','Washington u. 1.','2222222');
insert into helyszin values ('ZH','Zöld ház','Zöld u. 1.','3333333');

--oktató
insert into oktato values ('GJ','Gipsz Jakab',1);
insert into oktato values ('NB','Nagy Béla',0);
insert into oktato values ('KJ','Kiss János',0);
insert into oktato values ('VD','Vad Dalma',1);

--tanfolyam típus
insert into tanfolyam_tipus values ('CST','Cégek stratégiai Tervezése','5','10','GJ');
insert into tanfolyam_tipus values ('EXS','Exportáljunk a sikerért','5','10','VD');
insert into tanfolyam_tipus values ('STS','Stratégiai tervezés','5','10','GJ');
insert into tanfolyam_tipus values ('KZS','Közszereplés','5','10','VD');

--tanfolyam ára
insert into tanfolyam_ara values ('CST',CURRENT_DATE, null,'30000',1);
insert into tanfolyam_ara values ('EXS',CURRENT_DATE, null,'40000',1);
insert into tanfolyam_ara values ('STS',CURRENT_DATE, null,'25000',1);
insert into tanfolyam_ara values ('KZS',CURRENT_DATE, null,'50000',1);

--tanfolyam ár módosítás
update tanfolyam_ara set ervenyesseg_vege= to_date('2018-1-31', 'yyyy-mm-dd'), aktiv = 0  where tipuskod_fk like 'CST' and aktiv = 1;
insert into tanfolyam_ara values ('CST',to_date('2018-2-1', 'yyyy-mm-dd'), null,'35000',1);

update tanfolyam_ara set ervenyesseg_vege= to_date('2018-1-31', 'yyyy-mm-dd'), aktiv=0 where tipuskod_fk = 'EXS' and aktiv = 1;
insert into tanfolyam_ara values ('EXS',to_date('2018-2-1', 'yyyy-mm-dd'), null,'45000',1);

update tanfolyam_ara set ervenyesseg_vege= to_date('2018-1-31', 'yyyy-mm-dd'), aktiv=0 where tipuskod_fk = 'STS' and aktiv = 1;
insert into tanfolyam_ara values ('STS',to_date('2018-2-1', 'yyyy-mm-dd'), null,'30000',1);

--tanfolyam lebonyolítás
insert into tanfolyam_lebonyolitas values ('CST','CSTJAN1',to_date('2018-01-15', 'yyyy-mm-dd'), to_date('2018-01-19', 'yyyy-mm-dd'),'PH');
insert into tanfolyam_lebonyolitas values ('CST','CSTJAN2',to_date('2018-01-20', 'yyyy-mm-dd'), to_date('2018-01-24', 'yyyy-mm-dd'),'PH');
insert into tanfolyam_lebonyolitas values ('CST','CSTFEB1',to_date('2018-02-15', 'yyyy-mm-dd'), to_date('2018-02-19', 'yyyy-mm-dd'),'PH');
insert into tanfolyam_lebonyolitas values ('EXS','EXSJAN1',to_date('2018-01-15', 'yyyy-mm-dd'), to_date('2018-01-19', 'yyyy-mm-dd'),'ZH');
insert into tanfolyam_lebonyolitas values ('EXS','EXSFEB1',to_date('2018-02-15', 'yyyy-mm-dd'), to_date('2018-02-19', 'yyyy-mm-dd'),'ZH');
insert into tanfolyam_lebonyolitas values ('STS','STSJAN1',to_date('2018-01-20', 'yyyy-mm-dd'), to_date('2018-01-24', 'yyyy-mm-dd'),'FH');
insert into tanfolyam_lebonyolitas values ('STS','STSFEB1',to_date('2018-02-20', 'yyyy-mm-dd'), to_date('2018-02-24', 'yyyy-mm-dd'),'FH');
insert into tanfolyam_lebonyolitas values ('KZS','KZSFEB1',to_date('2018-02-10', 'yyyy-mm-dd'), to_date('2018-02-14', 'yyyy-mm-dd'),'ZH');

--oktató - tanfolyam
insert into oktatotanfolyam values ('GJ','CSTJAN1');
insert into oktatotanfolyam values ('NB','CSTJAN2');
insert into oktatotanfolyam values ('KJ','CSTFEB1');
insert into oktatotanfolyam values ('VD','EXSJAN1');
insert into oktatotanfolyam values ('NB','EXSFEB1');
insert into oktatotanfolyam values ('GJ','STSJAN1');
insert into oktatotanfolyam values ('NB','STSFEB1');
insert into oktatotanfolyam values ('VD','KZSFEB1');

--foglalások
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel1','CSTJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Lakatos Jakab','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel1','CSTJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Lakatos Andrea','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel1','CSTJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Lakatos Elek','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel1','CSTJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Lakatos Tibor','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel1','CSTJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Lakatos Gergely','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','CSTJAN1',to_date('2017-12-21','yyyy-mm-dd'),'Kiss Jakab','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','CSTJAN1',to_date('2017-12-21','yyyy-mm-dd'),'Kiss Andrea','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','CSTJAN1',to_date('2017-12-21','yyyy-mm-dd'),'Kiss Elek','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','CSTJAN1',to_date('2017-12-21','yyyy-mm-dd'),'Kiss Tibor','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','CSTJAN1',to_date('2017-12-21','yyyy-mm-dd'),'Kiss Gergely','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel3','CSTJAN1',to_date('2017-12-22','yyyy-mm-dd'),'Nagy Jakab','Ideiglenes + Készenlét');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel3','CSTJAN1',to_date('2017-12-22','yyyy-mm-dd'),'Nagy Andrea','Ideiglenes + Készenlét');

insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','CSTJAN2',to_date('2017-12-10','yyyy-mm-dd'),'Kiss Gizi','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','CSTJAN2',to_date('2017-12-10','yyyy-mm-dd'),'Kiss Alma','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','CSTJAN2',to_date('2017-12-10','yyyy-mm-dd'),'Kiss Viola','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','CSTJAN2',to_date('2017-12-10','yyyy-mm-dd'),'Kiss Endre','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','CSTJAN2',to_date('2017-12-10','yyyy-mm-dd'),'Kiss Dalma','Megerositett');

insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel3','CSTFEB1',to_date('2017-12-15','yyyy-mm-dd'),'Nagy Alma','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel3','CSTFEB1',to_date('2017-12-15','yyyy-mm-dd'),'Nagy Gergely','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel3','CSTFEB1',to_date('2017-12-15','yyyy-mm-dd'),'Nagy Tibor','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel3','CSTFEB1',to_date('2017-12-15','yyyy-mm-dd'),'Nagy Elek','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel3','CSTFEB1',to_date('2017-12-15','yyyy-mm-dd'),'Nagy Endre','Megerositett');

insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel1','EXSJAN1',to_date('2017-12-18','yyyy-mm-dd'),'Lakatos Alma','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel1','EXSJAN1',to_date('2017-12-18','yyyy-mm-dd'),'Lakatos Endre','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel1','EXSJAN1',to_date('2017-12-18','yyyy-mm-dd'),'Lakatos Viola','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel1','EXSJAN1',to_date('2017-12-18','yyyy-mm-dd'),'Lakatos Attila','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel1','EXSJAN1',to_date('2017-12-18','yyyy-mm-dd'),'Lakatos Imre','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel1','EXSJAN1',to_date('2017-12-18','yyyy-mm-dd'),'Lakatos Ambrus','Megerositett');

insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','EXSFEB1',to_date('2017-12-28','yyyy-mm-dd'),'Kiss Gizi','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','EXSFEB1',to_date('2017-12-28','yyyy-mm-dd'),'Kiss Endre','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','EXSFEB1',to_date('2017-12-28','yyyy-mm-dd'),'Kiss Dalma','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','EXSFEB1',to_date('2017-12-28','yyyy-mm-dd'),'Kiss Jakab','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','EXSFEB1',to_date('2017-12-28','yyyy-mm-dd'),'Kiss Ambrus','Megerositett');

insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel3','STSJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Nagy Gergely','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel3','STSJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Nagy Elek','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel3','STSJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Nagy Gizi','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel3','STSJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Nagy Tibor','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel3','STSJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Nagy Lajos','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel3','STSJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Nagy Imre','Megerositett');

insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel1','STSFEB1',to_date('2017-12-22','yyyy-mm-dd'),'Lakatos Andrea','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel1','STSFEB1',to_date('2017-12-22','yyyy-mm-dd'),'Lakatos Imre','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel1','STSFEB1',to_date('2017-12-22','yyyy-mm-dd'),'Lakatos Gergely','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','STSFEB1',to_date('2017-12-21','yyyy-mm-dd'),'Kiss Gergely','Ideiglenes');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','STSFEB1',to_date('2017-12-21','yyyy-mm-dd'),'Kiss Elek','Ideiglenes');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','STSFEB1',to_date('2017-12-21','yyyy-mm-dd'),'Kiss Andrea','Ideiglenes');

insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','KZSFEB1',to_date('2017-12-12','yyyy-mm-dd'),'Kiss Andrea','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','KZSFEB1',to_date('2017-12-12','yyyy-mm-dd'),'Kiss Elek','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel2','KZSFEB1',to_date('2017-12-12','yyyy-mm-dd'),'Kiss Gergely','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel1','KZSFEB1',to_date('2017-12-23','yyyy-mm-dd'),'Lakatos Andrea','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel1','KZSFEB1',to_date('2017-12-23','yyyy-mm-dd'),'Lakatos Endre','Megerositett');
insert into foglalas (ugyfelnev,tanfolyamkod_fk, fogldatum, resztvevonev, statusz) values ('Ugyfel1','KZSFEB1',to_date('2017-12-23','yyyy-mm-dd'),'Lakatos Elek','Megerositett');

---értékelések
insert into ertekeles values ('CSTJAN1','Cegismeretek',8,4.25);
insert into ertekeles values ('CSTJAN1','Cegjog',6,4.5);
insert into ertekeles values ('CSTJAN2','Cegismeretek',5,4.8);
insert into ertekeles values ('CSTJAN2','Cegjog',5,4.2);