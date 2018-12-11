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

--tanfolyam típus árakkal
insert into tanfolyam_tipus values ('CST','Cégek stratégiai Tervezése','5','10','GJ');
insert into tanfolyam_tipus values ('EXS','Exportáljunk a sikerért','5','10','VD');
insert into tanfolyam_tipus values ('STS','Stratégiai tervezés','5','10','GJ');
insert into tanfolyam_tipus values ('KZS','Közszereplés','5','10','VD');

insert into tanfolyam_ar values ('CST', to_date('2018.01.01','yyyy.mm.dd'), 30000);
insert into tanfolyam_ar values ('EXS', to_date('2018.01.01','yyyy.mm.dd'), 40000);
insert into tanfolyam_ar values ('STS', to_date('2018.01.01','yyyy.mm.dd'), 25000);
insert into tanfolyam_ar values ('KZS', to_date('2018.01.01','yyyy.mm.dd'), 50000);

--tanfolyam ár módosítás
insert into tanfolyam_ar values ('CST', to_date('2018-2-1', 'yyyy-mm-dd'), 35000);
insert into tanfolyam_ar values ('EXS', to_date('2018-2-1', 'yyyy-mm-dd'), 45000);
insert into tanfolyam_ar values ('STS', to_date('2018-2-1', 'yyyy-mm-dd'), 30000);

--tanfolyam lebonyolítás
insert into tanfolyam values ('CST','CSTJAN1',to_date('2018-01-15', 'yyyy-mm-dd'), to_date('2018-01-19', 'yyyy-mm-dd'),'PH','GJ');
insert into tanfolyam values ('CST','CSTJAN2',to_date('2018-01-20', 'yyyy-mm-dd'), to_date('2018-01-24', 'yyyy-mm-dd'),'PH','NB');
insert into tanfolyam values ('CST','CSTFEB1',to_date('2018-02-15', 'yyyy-mm-dd'), to_date('2018-02-19', 'yyyy-mm-dd'),'PH','KJ');
insert into tanfolyam values ('EXS','EXSJAN1',to_date('2018-01-15', 'yyyy-mm-dd'), to_date('2018-01-19', 'yyyy-mm-dd'),'ZH','VD');
insert into tanfolyam values ('EXS','EXSFEB1',to_date('2018-02-15', 'yyyy-mm-dd'), to_date('2018-02-19', 'yyyy-mm-dd'),'ZH','NB');
insert into tanfolyam values ('STS','STSJAN1',to_date('2018-01-20', 'yyyy-mm-dd'), to_date('2018-01-24', 'yyyy-mm-dd'),'FH','GJ');
insert into tanfolyam values ('STS','STSFEB1',to_date('2018-02-20', 'yyyy-mm-dd'), to_date('2018-02-24', 'yyyy-mm-dd'),'FH','NB');
insert into tanfolyam values ('KZS','KZSFEB1',to_date('2018-02-10', 'yyyy-mm-dd'), to_date('2018-02-14', 'yyyy-mm-dd'),'ZH','VD');

--foglalások
insert into foglalas values ('Ugyfel1','CSTJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Lakatos Jakab','Megerositett');
insert into foglalas values ('Ugyfel1','CSTJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Lakatos Andrea','Megerositett');
insert into foglalas values ('Ugyfel1','CSTJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Lakatos Elek','Megerositett');
insert into foglalas values ('Ugyfel1','CSTJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Lakatos Tibor','Megerositett');
insert into foglalas values ('Ugyfel1','CSTJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Lakatos Gergely','Megerositett');
insert into foglalas values ('Ugyfel2','CSTJAN1',to_date('2017-12-21','yyyy-mm-dd'),'Kiss Jakab','Megerositett');
insert into foglalas values ('Ugyfel2','CSTJAN1',to_date('2017-12-21','yyyy-mm-dd'),'Kiss Andrea','Megerositett');
insert into foglalas values ('Ugyfel2','CSTJAN1',to_date('2017-12-21','yyyy-mm-dd'),'Kiss Elek','Megerositett');
insert into foglalas values ('Ugyfel2','CSTJAN1',to_date('2017-12-21','yyyy-mm-dd'),'Kiss Tibor','Megerositett');
insert into foglalas values ('Ugyfel2','CSTJAN1',to_date('2017-12-21','yyyy-mm-dd'),'Kiss Gergely','Megerositett');
insert into foglalas values ('Ugyfel3','CSTJAN1',to_date('2017-12-22','yyyy-mm-dd'),'Nagy Jakab','Ideiglenes + Készenlét');
insert into foglalas values ('Ugyfel3','CSTJAN1',to_date('2017-12-22','yyyy-mm-dd'),'Nagy Andrea','Ideiglenes + Készenlét');

insert into foglalas values ('Ugyfel2','CSTJAN2',to_date('2017-12-10','yyyy-mm-dd'),'Kiss Gizi','Megerositett');
insert into foglalas values ('Ugyfel2','CSTJAN2',to_date('2017-12-10','yyyy-mm-dd'),'Kiss Alma','Megerositett');
insert into foglalas values ('Ugyfel2','CSTJAN2',to_date('2017-12-10','yyyy-mm-dd'),'Kiss Viola','Megerositett');
insert into foglalas values ('Ugyfel2','CSTJAN2',to_date('2017-12-10','yyyy-mm-dd'),'Kiss Endre','Megerositett');
insert into foglalas values ('Ugyfel2','CSTJAN2',to_date('2017-12-10','yyyy-mm-dd'),'Kiss Dalma','Megerositett');

insert into foglalas values ('Ugyfel3','CSTFEB1',to_date('2017-12-15','yyyy-mm-dd'),'Nagy Alma','Megerositett');
insert into foglalas values ('Ugyfel3','CSTFEB1',to_date('2017-12-15','yyyy-mm-dd'),'Nagy Gergely','Megerositett');
insert into foglalas values ('Ugyfel3','CSTFEB1',to_date('2017-12-15','yyyy-mm-dd'),'Nagy Tibor','Megerositett');
insert into foglalas values ('Ugyfel3','CSTFEB1',to_date('2017-12-15','yyyy-mm-dd'),'Nagy Elek','Megerositett');
insert into foglalas values ('Ugyfel3','CSTFEB1',to_date('2017-12-15','yyyy-mm-dd'),'Nagy Endre','Megerositett');

insert into foglalas values ('Ugyfel1','EXSJAN1',to_date('2017-12-18','yyyy-mm-dd'),'Lakatos Alma','Megerositett');
insert into foglalas values ('Ugyfel1','EXSJAN1',to_date('2017-12-18','yyyy-mm-dd'),'Lakatos Endre','Megerositett');
insert into foglalas values ('Ugyfel1','EXSJAN1',to_date('2017-12-18','yyyy-mm-dd'),'Lakatos Viola','Megerositett');
insert into foglalas values ('Ugyfel1','EXSJAN1',to_date('2017-12-18','yyyy-mm-dd'),'Lakatos Attila','Megerositett');
insert into foglalas values ('Ugyfel1','EXSJAN1',to_date('2017-12-18','yyyy-mm-dd'),'Lakatos Imre','Megerositett');
insert into foglalas values ('Ugyfel1','EXSJAN1',to_date('2017-12-18','yyyy-mm-dd'),'Lakatos Ambrus','Megerositett');

insert into foglalas values ('Ugyfel2','EXSFEB1',to_date('2017-12-28','yyyy-mm-dd'),'Kiss Gizi','Megerositett');
insert into foglalas values ('Ugyfel2','EXSFEB1',to_date('2017-12-28','yyyy-mm-dd'),'Kiss Endre','Megerositett');
insert into foglalas values ('Ugyfel2','EXSFEB1',to_date('2017-12-28','yyyy-mm-dd'),'Kiss Dalma','Megerositett');
insert into foglalas values ('Ugyfel2','EXSFEB1',to_date('2017-12-28','yyyy-mm-dd'),'Kiss Jakab','Megerositett');
insert into foglalas values ('Ugyfel2','EXSFEB1',to_date('2017-12-28','yyyy-mm-dd'),'Kiss Ambrus','Megerositett');

insert into foglalas values ('Ugyfel3','STSJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Nagy Gergely','Megerositett');
insert into foglalas values ('Ugyfel3','STSJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Nagy Elek','Megerositett');
insert into foglalas values ('Ugyfel3','STSJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Nagy Gizi','Megerositett');
insert into foglalas values ('Ugyfel3','STSJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Nagy Tibor','Megerositett');
insert into foglalas values ('Ugyfel3','STSJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Nagy Lajos','Megerositett');
insert into foglalas values ('Ugyfel3','STSJAN1',to_date('2017-12-20','yyyy-mm-dd'),'Nagy Imre','Megerositett');

insert into foglalas values ('Ugyfel1','STSFEB1',to_date('2017-12-22','yyyy-mm-dd'),'Lakatos Andrea','Megerositett');
insert into foglalas values ('Ugyfel1','STSFEB1',to_date('2017-12-22','yyyy-mm-dd'),'Lakatos Imre','Megerositett');
insert into foglalas values ('Ugyfel1','STSFEB1',to_date('2017-12-22','yyyy-mm-dd'),'Lakatos Gergely','Megerositett');
insert into foglalas values ('Ugyfel2','STSFEB1',to_date('2017-12-21','yyyy-mm-dd'),'Kiss Gergely','Ideiglenes');
insert into foglalas values ('Ugyfel2','STSFEB1',to_date('2017-12-21','yyyy-mm-dd'),'Kiss Elek','Ideiglenes');
insert into foglalas values ('Ugyfel2','STSFEB1',to_date('2017-12-21','yyyy-mm-dd'),'Kiss Andrea','Ideiglenes');

insert into foglalas values ('Ugyfel2','KZSFEB1',to_date('2017-12-12','yyyy-mm-dd'),'Kiss Andrea','Megerositett');
insert into foglalas values ('Ugyfel2','KZSFEB1',to_date('2017-12-12','yyyy-mm-dd'),'Kiss Elek','Megerositett');
insert into foglalas values ('Ugyfel2','KZSFEB1',to_date('2017-12-12','yyyy-mm-dd'),'Kiss Gergely','Megerositett');
insert into foglalas values ('Ugyfel1','KZSFEB1',to_date('2017-12-23','yyyy-mm-dd'),'Lakatos Andrea','Megerositett');
insert into foglalas values ('Ugyfel1','KZSFEB1',to_date('2017-12-23','yyyy-mm-dd'),'Lakatos Endre','Megerositett');
insert into foglalas values ('Ugyfel1','KZSFEB1',to_date('2017-12-23','yyyy-mm-dd'),'Lakatos Elek','Megerositett');

---értékelések
insert into ertekeles values ('CSTJAN1','Cegismeretek',8,4.25);
insert into ertekeles values ('CSTJAN1','Cegjog',6,4.5);
insert into ertekeles values ('CSTJAN2','Cegismeretek',5,4.8);
insert into ertekeles values ('CSTJAN2','Cegjog',5,4.2);