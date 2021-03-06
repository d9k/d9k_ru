--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.13
-- Dumped by pg_dump version 9.5.13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: enum_article_content_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_article_content_type AS ENUM (
    'markdown',
    'html'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: article; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.article (
    name text,
    system_name text NOT NULL,
    content_type public.enum_article_content_type DEFAULT 'html'::public.enum_article_content_type,
    content text,
    active boolean DEFAULT true NOT NULL,
    global_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    url_alias text,
    revision uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    create_time timestamp without time zone DEFAULT timezone('utc'::text, now()),
    modify_time timestamp without time zone DEFAULT timezone('utc'::text, now())
);


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.migrations (
    version character varying NOT NULL,
    apply_date timestamp without time zone DEFAULT timezone('utc'::text, now())
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    login character varying(20) NOT NULL,
    email character varying(120),
    password_hash character varying(80) NOT NULL
);


--
-- Name: article_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.article
    ADD CONSTRAINT article_pkey PRIMARY KEY (system_name);


--
-- Name: migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: users_email_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (login);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.13
-- Dumped by pg_dump version 9.5.13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.migrations (version, apply_date) FROM stdin;
2018_04_30__01_33_13__article	2018-04-30 03:23:50.141058
2018_05_02__05_40_00__article__global_name	2018-05-02 02:44:18.732221
2018_06_16__14_27_22__article__pkey	2018-06-16 11:30:12.327214
2018_06_17__07_33_23__article__published	2018-06-17 04:37:06.314348
2018_06_17__09_32_34__article__url_alias	2018-06-17 06:41:25.735432
2018_06_22__06_34_21__article__add__revision__and__create_time	2018-06-22 03:52:48.61804
2018_07_02__04_03_25__article__rm_published	2018-07-02 01:05:30.760006
2018_07_02__04_24_32__article__rm_id	2018-07-02 01:29:55.893268
\.


--
-- PostgreSQL database dump complete
--

