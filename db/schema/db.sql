--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.12
-- Dumped by pg_dump version 9.5.12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: enum_article_content_type; Type: TYPE; Schema: public; Owner: d9k_local_sailor
--

CREATE TYPE public.enum_article_content_type AS ENUM (
    'markdown',
    'html'
);


ALTER TYPE public.enum_article_content_type OWNER TO d9k_local_sailor;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: article; Type: TABLE; Schema: public; Owner: d9k_local_sailor
--

CREATE TABLE public.article (
    id integer NOT NULL,
    name text,
    system_name text NOT NULL,
    content_type public.enum_article_content_type DEFAULT 'html'::public.enum_article_content_type,
    content text,
    active boolean DEFAULT true NOT NULL,
    global_id uuid DEFAULT public.uuid_generate_v4() NOT NULL
);


ALTER TABLE public.article OWNER TO d9k_local_sailor;

--
-- Name: article_id_seq; Type: SEQUENCE; Schema: public; Owner: d9k_local_sailor
--

CREATE SEQUENCE public.article_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.article_id_seq OWNER TO d9k_local_sailor;

--
-- Name: article_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: d9k_local_sailor
--

ALTER SEQUENCE public.article_id_seq OWNED BY public.article.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: d9k_local_sailor
--

CREATE TABLE public.migrations (
    version character varying NOT NULL,
    apply_date timestamp without time zone DEFAULT timezone('utc'::text, now())
);


ALTER TABLE public.migrations OWNER TO d9k_local_sailor;

--
-- Name: users; Type: TABLE; Schema: public; Owner: adm1104
--

CREATE TABLE public.users (
    login character varying(20) NOT NULL,
    email character varying(120),
    password_hash character varying(80) NOT NULL
);


ALTER TABLE public.users OWNER TO adm1104;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: d9k_local_sailor
--

ALTER TABLE ONLY public.article ALTER COLUMN id SET DEFAULT nextval('public.article_id_seq'::regclass);


--
-- Name: migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: d9k_local_sailor
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: users_email_unique; Type: CONSTRAINT; Schema: public; Owner: adm1104
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: adm1104
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (login);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.12
-- Dumped by pg_dump version 9.5.12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: d9k_local_sailor
--

COPY public.migrations (version, apply_date) FROM stdin;
2018_04_30__01_33_13__article	2018-04-30 03:23:50.141058
2018_05_02__05_40_00__article__global_name	2018-05-02 02:44:18.732221
\.


--
-- PostgreSQL database dump complete
--

