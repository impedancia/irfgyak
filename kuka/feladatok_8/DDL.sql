-- Generated by Oracle SQL Developer Data Modeler 18.2.0.179.0806
--   at:        2018-12-02 00:36:30 CET
--   site:      Oracle Database 12c
--   type:      Oracle Database 12c



CREATE TABLE ertekeles (
    tanfkod   VARCHAR2(128) NOT NULL,
    temakor   VARCHAR2(128),
    darab     INTEGER,
    atlag     FLOAT
);

CREATE TABLE foglalas (
    ugyfelnev      VARCHAR2(128) NOT NULL,
    tanfkod        VARCHAR2(128) NOT NULL,
    fogldatum      DATE,
    resztvevonev   VARCHAR2(128) NOT NULL,
    statusz        VARCHAR2(128)
);

ALTER TABLE foglalas ADD CONSTRAINT foglalas_pk PRIMARY KEY ( tanfkod,
                                                              resztvevonev );

CREATE TABLE helyszin (
    helyszinkod   VARCHAR2(128) NOT NULL,
    nev           VARCHAR2(128),
    cim           VARCHAR2(128),
    telefon       VARCHAR2(128)
);

ALTER TABLE helyszin ADD CONSTRAINT helyszin_pk PRIMARY KEY ( helyszinkod );

CREATE TABLE oktato (
    oktatokod     VARCHAR2(128) NOT NULL,
    nev           VARCHAR2(128),
    tanffelelos   VARCHAR2(128)
);

ALTER TABLE oktato ADD CONSTRAINT oktato_pk PRIMARY KEY ( oktatokod );

CREATE TABLE oktatotanfolyam (
    oktatokod   VARCHAR2(128) NOT NULL,
    tanfkod     VARCHAR2(128) NOT NULL
);

CREATE TABLE tanfolyam (
    tipuskod1     VARCHAR2(128) NOT NULL,
    tanfkod       VARCHAR2(128) NOT NULL,
    kezdodatum    DATE,
    vegedatum     DATE,
    helyszinkod   VARCHAR2(128) NOT NULL
);

ALTER TABLE tanfolyam ADD CONSTRAINT tanfolyam_pk PRIMARY KEY ( tanfkod );

CREATE TABLE ttipus (
    tipuskod      VARCHAR2(128) NOT NULL,
    tipusnev      VARCHAR2(128),
    minletszam    INTEGER,
    maxletszam    INTEGER,
    ar            INTEGER NOT NULL,
    tanffelelos   VARCHAR2(128) NOT NULL
);

ALTER TABLE ttipus ADD CONSTRAINT ttipus_pk PRIMARY KEY ( tipuskod );

CREATE TABLE ugyfel (
    ugyfelnev    VARCHAR2(128) NOT NULL,
    cim          VARCHAR2(128),
    telefon      VARCHAR2(128),
    kapcstarto   VARCHAR2(128)
);

ALTER TABLE ugyfel ADD CONSTRAINT ugyfel_pk PRIMARY KEY ( ugyfelnev );

CREATE TABLE ujarak (
    tipuskod1    VARCHAR2(128) NOT NULL,
    kezdodatum   DATE,
    ar           INTEGER
);

ALTER TABLE ertekeles
    ADD CONSTRAINT ertekeles_tanfolyam_fk FOREIGN KEY ( tanfkod )
        REFERENCES tanfolyam ( tanfkod );

ALTER TABLE foglalas
    ADD CONSTRAINT foglalas_tanfolyam_fk FOREIGN KEY ( tanfkod )
        REFERENCES tanfolyam ( tanfkod );

ALTER TABLE foglalas
    ADD CONSTRAINT foglalas_ugyfel_fk FOREIGN KEY ( ugyfelnev )
        REFERENCES ugyfel ( ugyfelnev );

ALTER TABLE oktatotanfolyam
    ADD CONSTRAINT oktatotanfolyam_oktato_fk FOREIGN KEY ( oktatokod )
        REFERENCES oktato ( oktatokod );

ALTER TABLE oktatotanfolyam
    ADD CONSTRAINT oktatotanfolyam_tanfolyam_fk FOREIGN KEY ( tanfkod )
        REFERENCES tanfolyam ( tanfkod );

ALTER TABLE tanfolyam
    ADD CONSTRAINT tanfolyam_helyszin_fk FOREIGN KEY ( helyszinkod )
        REFERENCES helyszin ( helyszinkod );

ALTER TABLE tanfolyam
    ADD CONSTRAINT tanfolyam_ttipus_fk FOREIGN KEY ( tipuskod1 )
        REFERENCES ttipus ( tipuskod );

ALTER TABLE ttipus
    ADD CONSTRAINT ttipus_oktato_fk FOREIGN KEY ( tanffelelos )
        REFERENCES oktato ( oktatokod );

ALTER TABLE ujarak
    ADD CONSTRAINT ujarak_ttipus_fk FOREIGN KEY ( tipuskod1 )
        REFERENCES ttipus ( tipuskod );

CREATE SEQUENCE helyszin_helyszinkod_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER helyszin_helyszinkod_trg BEFORE
    INSERT ON helyszin
    FOR EACH ROW
    WHEN ( new.helyszinkod IS NULL )
BEGIN
    :new.helyszinkod := helyszin_helyszinkod_seq.nextval;
END;
/

CREATE SEQUENCE oktato_oktatokod_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER oktato_oktatokod_trg BEFORE
    INSERT ON oktato
    FOR EACH ROW
    WHEN ( new.oktatokod IS NULL )
BEGIN
    :new.oktatokod := oktato_oktatokod_seq.nextval;
END;
/

CREATE SEQUENCE tanfolyam_tanfkod_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER tanfolyam_tanfkod_trg BEFORE
    INSERT ON tanfolyam
    FOR EACH ROW
    WHEN ( new.tanfkod IS NULL )
BEGIN
    :new.tanfkod := tanfolyam_tanfkod_seq.nextval;
END;
/

CREATE SEQUENCE ttipus_tipuskod_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER ttipus_tipuskod_trg BEFORE
    INSERT ON ttipus
    FOR EACH ROW
    WHEN ( new.tipuskod IS NULL )
BEGIN
    :new.tipuskod := ttipus_tipuskod_seq.nextval;
END;
/

CREATE SEQUENCE ugyfel_ugyfelnev_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER ugyfel_ugyfelnev_trg BEFORE
    INSERT ON ugyfel
    FOR EACH ROW
    WHEN ( new.ugyfelnev IS NULL )
BEGIN
    :new.ugyfelnev := ugyfel_ugyfelnev_seq.nextval;
END;
/



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             9
-- CREATE INDEX                             0
-- ALTER TABLE                             15
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           5
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          5
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
