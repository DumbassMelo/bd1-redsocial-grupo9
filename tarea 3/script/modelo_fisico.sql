-- Grupo 9 | Tarea 3 | PostgreSQL 15+

-- Ejecutar en una base de datos vacía desde pgAdmin 4

BEGIN;

CREATE SCHEMA IF NOT EXISTS red_pascualina;

SET search_path TO red_pascualina;

CREATE TABLE estudiantes (
    id_estudiante BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(254) NOT NULL UNIQUE,
    programa VARCHAR(120) NOT NULL,
    biografia TEXT,
    fecha_registro TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE intereses (
    id_interes BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE estudiante_intereses (
    id_estudiante BIGINT,
    id_interes BIGINT,
    PRIMARY KEY (id_estudiante, id_interes)
);

CREATE TABLE conexiones (
    id_seguidor BIGINT,
    id_seguido BIGINT,
    fecha_conexion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_seguidor, id_seguido),
    CONSTRAINT ck_conexiones_distintas CHECK (id_seguidor <> id_seguido)
);

CREATE TABLE publicaciones (
    id_publicacion BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_autor BIGINT NOT NULL,
    contenido TEXT NOT NULL,
    fecha_publicacion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_publicaciones_contenido CHECK (length(btrim(contenido)) > 0)
);

CREATE TABLE grupos (
    id_grupo BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_creador BIGINT NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    descripcion TEXT,
    fecha_creacion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE membresias_grupo (
    id_grupo BIGINT,
    id_estudiante BIGINT,
    fecha_union TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_grupo, id_estudiante)
);

CREATE TABLE eventos (
    id_evento BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_organizador BIGINT NOT NULL,
    id_grupo BIGINT NULL,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    lugar VARCHAR(180),
    inicio TIMESTAMPTZ NOT NULL,
    fin TIMESTAMPTZ NOT NULL,
    CONSTRAINT ck_eventos_fechas CHECK (fin > inicio)
);

CREATE TABLE asistencias_evento (
    id_evento BIGINT,
    id_estudiante BIGINT,
    estado VARCHAR(15) NOT NULL DEFAULT 'confirmado',
    PRIMARY KEY (id_evento, id_estudiante),
    CONSTRAINT ck_asistencias_estado CHECK (estado IN ('confirmado', 'pendiente', 'cancelado'))
);

ALTER TABLE estudiante_intereses ADD CONSTRAINT fk_estudiante_intereses_id_estudiante FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE estudiante_intereses ADD CONSTRAINT fk_estudiante_intereses_id_interes FOREIGN KEY (id_interes) REFERENCES intereses(id_interes) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE conexiones ADD CONSTRAINT fk_conexiones_id_seguidor FOREIGN KEY (id_seguidor) REFERENCES estudiantes(id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE conexiones ADD CONSTRAINT fk_conexiones_id_seguido FOREIGN KEY (id_seguido) REFERENCES estudiantes(id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE publicaciones ADD CONSTRAINT fk_publicaciones_id_autor FOREIGN KEY (id_autor) REFERENCES estudiantes(id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE grupos ADD CONSTRAINT fk_grupos_id_creador FOREIGN KEY (id_creador) REFERENCES estudiantes(id_estudiante) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE membresias_grupo ADD CONSTRAINT fk_membresias_grupo_id_grupo FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE membresias_grupo ADD CONSTRAINT fk_membresias_grupo_id_estudiante FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE eventos ADD CONSTRAINT fk_eventos_id_organizador FOREIGN KEY (id_organizador) REFERENCES estudiantes(id_estudiante) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE eventos ADD CONSTRAINT fk_eventos_id_grupo FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE asistencias_evento ADD CONSTRAINT fk_asistencias_evento_id_evento FOREIGN KEY (id_evento) REFERENCES eventos(id_evento) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE asistencias_evento ADD CONSTRAINT fk_asistencias_evento_id_estudiante FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE INDEX idx_publicaciones_id_autor ON publicaciones(id_autor);

CREATE INDEX idx_grupos_id_creador ON grupos(id_creador);

CREATE INDEX idx_eventos_id_organizador ON eventos(id_organizador);

CREATE INDEX idx_eventos_id_grupo ON eventos(id_grupo);

CREATE INDEX idx_membresias_grupo_id_estudiante ON membresias_grupo(id_estudiante);

CREATE INDEX idx_asistencias_evento_id_estudiante ON asistencias_evento(id_estudiante);

COMMIT;

-- Verificacion: SELECT table_name FROM information_schema.tables WHERE table_schema = 'red_pascualina' ORDER BY table_name;
