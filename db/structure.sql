--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: played_quizzes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE played_quizzes (
    id integer NOT NULL,
    created_at timestamp without time zone,
    quiz_snapshot_id integer,
    question_answers text,
    begin_time timestamp without time zone,
    end_time timestamp without time zone,
    has_answers boolean DEFAULT true,
    interrupted boolean DEFAULT false
);


--
-- Name: played_quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE played_quizzes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: played_quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE played_quizzes_id_seq OWNED BY played_quizzes.id;


--
-- Name: playings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE playings (
    player_id integer,
    played_quiz_id integer,
    "position" integer,
    id integer NOT NULL
);


--
-- Name: playings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE playings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE playings_id_seq OWNED BY playings.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE posts (
    id integer NOT NULL,
    title character varying(255),
    body text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE questions (
    id integer NOT NULL,
    content text,
    hint character varying(255),
    type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    data text DEFAULT '--- {}
'::text,
    quiz_id integer,
    "position" integer,
    image character varying(255)
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE questions_id_seq OWNED BY questions.id;


--
-- Name: quiz_snapshots; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE quiz_snapshots (
    id integer NOT NULL,
    quiz_attributes text,
    questions_attributes text,
    created_at timestamp without time zone,
    quiz_id integer
);


--
-- Name: quiz_snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quiz_snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quiz_snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quiz_snapshots_id_seq OWNED BY quiz_snapshots.id;


--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE quizzes (
    id integer NOT NULL,
    name character varying(255),
    activated boolean DEFAULT false,
    school_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    shuffle_questions boolean DEFAULT false
);


--
-- Name: quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quizzes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quizzes_id_seq OWNED BY quizzes.id;


--
-- Name: readings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE readings (
    user_id integer,
    user_type integer,
    post_id integer,
    id integer NOT NULL
);


--
-- Name: readings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE readings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: readings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE readings_id_seq OWNED BY readings.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: schools; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schools (
    id integer NOT NULL,
    name character varying(255),
    username character varying(255),
    encrypted_password character varying(255),
    level character varying(255),
    key character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    place character varying(255),
    region character varying(255),
    email character varying(255),
    notified boolean DEFAULT true,
    admin boolean DEFAULT false,
    completed_survey boolean DEFAULT false,
    last_activity timestamp without time zone,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255)
);


--
-- Name: schools_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE schools_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE schools_id_seq OWNED BY schools.id;


--
-- Name: students; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE students (
    id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    username character varying(255),
    encrypted_password character varying(255),
    school_id integer,
    grade character varying(2),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    gender character varying(255),
    year_of_birth integer,
    email character varying(255),
    completed_survey boolean DEFAULT false,
    last_activity timestamp without time zone,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255)
);


--
-- Name: students_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE students_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE students_id_seq OWNED BY students.id;


--
-- Name: survey_fields; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE survey_fields (
    id integer NOT NULL,
    question character varying(255),
    choices text,
    answer text,
    category character varying(255),
    survey_id integer
);


--
-- Name: survey_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE survey_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE survey_fields_id_seq OWNED BY survey_fields.id;


--
-- Name: surveys; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE surveys (
    id integer NOT NULL,
    created_at timestamp without time zone
);


--
-- Name: surveys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE surveys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: surveys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE surveys_id_seq OWNED BY surveys.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying(255) NOT NULL,
    item_id integer NOT NULL,
    event character varying(255) NOT NULL,
    whodunnit character varying(255),
    object text,
    created_at timestamp without time zone
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY played_quizzes ALTER COLUMN id SET DEFAULT nextval('played_quizzes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY playings ALTER COLUMN id SET DEFAULT nextval('playings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY questions ALTER COLUMN id SET DEFAULT nextval('questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quiz_snapshots ALTER COLUMN id SET DEFAULT nextval('quiz_snapshots_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quizzes ALTER COLUMN id SET DEFAULT nextval('quizzes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY readings ALTER COLUMN id SET DEFAULT nextval('readings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY schools ALTER COLUMN id SET DEFAULT nextval('schools_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY students ALTER COLUMN id SET DEFAULT nextval('students_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY survey_fields ALTER COLUMN id SET DEFAULT nextval('survey_fields_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY surveys ALTER COLUMN id SET DEFAULT nextval('surveys_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY played_quizzes
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: playings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY playings
    ADD CONSTRAINT playings_pkey PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: quiz_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY quiz_snapshots
    ADD CONSTRAINT quiz_snapshots_pkey PRIMARY KEY (id);


--
-- Name: quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- Name: readings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY readings
    ADD CONSTRAINT readings_pkey PRIMARY KEY (id);


--
-- Name: schools_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schools
    ADD CONSTRAINT schools_pkey PRIMARY KEY (id);


--
-- Name: students_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- Name: survey_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY survey_fields
    ADD CONSTRAINT survey_fields_pkey PRIMARY KEY (id);


--
-- Name: surveys_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY surveys
    ADD CONSTRAINT surveys_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20120709164746');

INSERT INTO schema_migrations (version) VALUES ('20120709165237');

INSERT INTO schema_migrations (version) VALUES ('20120709165327');

INSERT INTO schema_migrations (version) VALUES ('20120709165519');

INSERT INTO schema_migrations (version) VALUES ('20120818073000');

INSERT INTO schema_migrations (version) VALUES ('20120915154622');

INSERT INTO schema_migrations (version) VALUES ('20120915174634');

INSERT INTO schema_migrations (version) VALUES ('20120919190608');

INSERT INTO schema_migrations (version) VALUES ('20120919192044');

INSERT INTO schema_migrations (version) VALUES ('20121008014801');

INSERT INTO schema_migrations (version) VALUES ('20121008014837');

INSERT INTO schema_migrations (version) VALUES ('20121011194607');

INSERT INTO schema_migrations (version) VALUES ('20121016223551');

INSERT INTO schema_migrations (version) VALUES ('20121021174122');

INSERT INTO schema_migrations (version) VALUES ('20121021183343');

INSERT INTO schema_migrations (version) VALUES ('20121021183641');

INSERT INTO schema_migrations (version) VALUES ('20121021192106');

INSERT INTO schema_migrations (version) VALUES ('20121021200442');

INSERT INTO schema_migrations (version) VALUES ('20121024130719');

INSERT INTO schema_migrations (version) VALUES ('20121025172235');

INSERT INTO schema_migrations (version) VALUES ('20121027184715');

INSERT INTO schema_migrations (version) VALUES ('20121102233327');

INSERT INTO schema_migrations (version) VALUES ('20121110203228');

INSERT INTO schema_migrations (version) VALUES ('20121110222149');

INSERT INTO schema_migrations (version) VALUES ('20121110225446');

INSERT INTO schema_migrations (version) VALUES ('20121111164634');

INSERT INTO schema_migrations (version) VALUES ('20121119215439');

INSERT INTO schema_migrations (version) VALUES ('20121119220110');

INSERT INTO schema_migrations (version) VALUES ('20121120153852');

INSERT INTO schema_migrations (version) VALUES ('20121122204234');

INSERT INTO schema_migrations (version) VALUES ('20121122215818');

INSERT INTO schema_migrations (version) VALUES ('20121122220011');

INSERT INTO schema_migrations (version) VALUES ('20121122220159');

INSERT INTO schema_migrations (version) VALUES ('20121123181236');

INSERT INTO schema_migrations (version) VALUES ('20121124120426');

INSERT INTO schema_migrations (version) VALUES ('20130324164318');

INSERT INTO schema_migrations (version) VALUES ('20130324164613');

INSERT INTO schema_migrations (version) VALUES ('20130412094935');

INSERT INTO schema_migrations (version) VALUES ('20130413205932');

INSERT INTO schema_migrations (version) VALUES ('20130414074306');

INSERT INTO schema_migrations (version) VALUES ('20130415190305');

INSERT INTO schema_migrations (version) VALUES ('20130415190338');

INSERT INTO schema_migrations (version) VALUES ('20130415195327');

INSERT INTO schema_migrations (version) VALUES ('20130415222943');

INSERT INTO schema_migrations (version) VALUES ('20130425132651');

INSERT INTO schema_migrations (version) VALUES ('20130426014257');

INSERT INTO schema_migrations (version) VALUES ('20130426130237');

INSERT INTO schema_migrations (version) VALUES ('20130426145704');

INSERT INTO schema_migrations (version) VALUES ('20130428211333');

INSERT INTO schema_migrations (version) VALUES ('20130429123055');

INSERT INTO schema_migrations (version) VALUES ('20130430142123');

INSERT INTO schema_migrations (version) VALUES ('20130507163732');

INSERT INTO schema_migrations (version) VALUES ('20130507165302');

INSERT INTO schema_migrations (version) VALUES ('20130507173307');

INSERT INTO schema_migrations (version) VALUES ('20130507191942');

INSERT INTO schema_migrations (version) VALUES ('20130510124042');

INSERT INTO schema_migrations (version) VALUES ('20130510131151');

INSERT INTO schema_migrations (version) VALUES ('20130511222413');

INSERT INTO schema_migrations (version) VALUES ('20130513220138');

INSERT INTO schema_migrations (version) VALUES ('20130513221823');

INSERT INTO schema_migrations (version) VALUES ('20130528223724');

INSERT INTO schema_migrations (version) VALUES ('20130529003303');

INSERT INTO schema_migrations (version) VALUES ('20130529093316');

INSERT INTO schema_migrations (version) VALUES ('20130604173444');

INSERT INTO schema_migrations (version) VALUES ('20130604194303');

INSERT INTO schema_migrations (version) VALUES ('20130604222432');

INSERT INTO schema_migrations (version) VALUES ('20130605083739');

INSERT INTO schema_migrations (version) VALUES ('20130605102955');

INSERT INTO schema_migrations (version) VALUES ('20130605103112');

INSERT INTO schema_migrations (version) VALUES ('20130605103450');

INSERT INTO schema_migrations (version) VALUES ('20130609121040');

INSERT INTO schema_migrations (version) VALUES ('20130609122000');

INSERT INTO schema_migrations (version) VALUES ('20130613144605');

INSERT INTO schema_migrations (version) VALUES ('20130613161732');

INSERT INTO schema_migrations (version) VALUES ('20130613163748');

INSERT INTO schema_migrations (version) VALUES ('20131031231517');

INSERT INTO schema_migrations (version) VALUES ('20131031232457');

INSERT INTO schema_migrations (version) VALUES ('20131101083735');

INSERT INTO schema_migrations (version) VALUES ('20131101163648');

INSERT INTO schema_migrations (version) VALUES ('20131103165731');

INSERT INTO schema_migrations (version) VALUES ('20131114192301');

INSERT INTO schema_migrations (version) VALUES ('20131117022724');

INSERT INTO schema_migrations (version) VALUES ('20131118223640');

INSERT INTO schema_migrations (version) VALUES ('20131118231304');

INSERT INTO schema_migrations (version) VALUES ('20131119003335');

INSERT INTO schema_migrations (version) VALUES ('20131119130746');

INSERT INTO schema_migrations (version) VALUES ('20140320103450');
