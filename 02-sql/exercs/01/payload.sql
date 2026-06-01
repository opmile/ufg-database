-- ============================================================
-- Banco de prática: MÚSICA
-- Compatível com PostgreSQL e SQLite.
-- Relações: ARTISTA 1:N MUSICA  |  USUARIO N:M MUSICA (via CURTE)
-- ============================================================

DROP TABLE IF EXISTS CURTE;
DROP TABLE IF EXISTS MUSICA;
DROP TABLE IF EXISTS ARTISTA;
DROP TABLE IF EXISTS USUARIO;

CREATE TABLE ARTISTA (
    id    INTEGER PRIMARY KEY,
    nome  TEXT NOT NULL,
    pais  TEXT NOT NULL
);

CREATE TABLE MUSICA (
    id           INTEGER PRIMARY KEY,
    titulo       TEXT NOT NULL,
    genero       TEXT NOT NULL,
    duracao_seg  INTEGER NOT NULL,
    artista_id   INTEGER NOT NULL,
    FOREIGN KEY (artista_id) REFERENCES ARTISTA (id)
);

CREATE TABLE USUARIO (
    id      INTEGER PRIMARY KEY,
    nome    TEXT NOT NULL,
    cidade  TEXT NOT NULL
);

CREATE TABLE CURTE (
    usuario_id  INTEGER NOT NULL,
    musica_id   INTEGER NOT NULL,
    PRIMARY KEY (usuario_id, musica_id),
    FOREIGN KEY (usuario_id) REFERENCES USUARIO (id),
    FOREIGN KEY (musica_id)  REFERENCES MUSICA (id)
);

-- ----------------------------------------------------------
-- ARTISTA
-- ----------------------------------------------------------
INSERT INTO ARTISTA (id, nome, pais) VALUES
(1, 'Tame Impala',   'Austrália'),
(2, 'Racionais MCs', 'Brasil'),
(3, 'Daft Punk',     'França'),
(4, 'Tim Maia',      'Brasil'),
(5, 'Radiohead',     'Reino Unido'),
(6, 'Anavitória',    'Brasil');

-- ----------------------------------------------------------
-- MUSICA  (contagem por artista: 1=3, 2=2, 3=3, 4=2, 5=2, 6=1)
-- ----------------------------------------------------------
INSERT INTO MUSICA (id, titulo, genero, duracao_seg, artista_id) VALUES
(1,  'The Less I Know the Better',     'rock',        216, 1),
(2,  'Let It Happen',                  'rock',        467, 1),
(3,  'Borderline',                     'rock',        238, 1),
(4,  'Diário de um Detento',           'rap',         440, 2),
(5,  'Negro Drama',                    'rap',         350, 2),
(6,  'Get Lucky',                      'eletronica',  369, 3),
(7,  'Harder Better Faster Stronger',  'eletronica',  224, 3),
(8,  'Around the World',               'eletronica',  428, 3),
(9,  'Gostava Tanto de Você',          'mpb',         200, 4),
(10, 'Não Quero Dinheiro',             'mpb',         180, 4),
(11, 'Creep',                          'rock',        238, 5),
(12, 'Karma Police',                   'rock',        261, 5),
(13, 'Trevo',                          'mpb',         200, 6);

-- ----------------------------------------------------------
-- USUARIO
-- ----------------------------------------------------------
INSERT INTO USUARIO (id, nome, cidade) VALUES
(1, 'Ana',   'Goiânia'),
(2, 'Bruno', 'São Paulo'),
(3, 'Carla', 'Goiânia'),
(4, 'Diego', 'Rio de Janeiro'),
(5, 'Elis',  'São Paulo');

-- ----------------------------------------------------------
-- CURTE  (desenhado para os exercícios)
--   músicas de rock = ids 1,2,3,11,12
--   Ana   -> 3 de rock   | Bruno -> 2 de rock | Carla -> 1 de rock
--   Diego -> 0 de rock   | Elis  -> 3 de rock
--   músicas 7, 8 e 13 ninguém curte
-- ----------------------------------------------------------
INSERT INTO CURTE (usuario_id, musica_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 6),       -- Ana
(2, 11), (2, 12), (2, 4),             -- Bruno
(3, 1), (3, 9), (3, 10),              -- Carla
(4, 4), (4, 5), (4, 9),               -- Diego
(5, 2), (5, 11), (5, 12);             -- Elis