--
-- PostgreSQL database dump
--

\restrict 2nf8h8Id4PJmgqAwaYXRUkNeoWXKbBWAbrUG829RTNT1yiL8vcfPG42G3zgo3zb

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA "public"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA "public" IS 'standard public schema';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "public";


--
-- Name: EXTENSION "pg_stat_statements"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "pg_stat_statements" IS 'track planning and execution statistics of all SQL statements executed';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: agendamento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."agendamento" (
    "id_agendamento" integer NOT NULL,
    "data" "date" NOT NULL,
    "horario" time without time zone NOT NULL,
    "tipo_procedimento" character varying(100) NOT NULL,
    "status" character varying(30) DEFAULT 'agendado'::character varying NOT NULL,
    "pet_id" integer NOT NULL,
    CONSTRAINT "agendamento_status_check" CHECK ((("status")::"text" = ANY ((ARRAY['agendado'::character varying, 'confirmado'::character varying, 'concluido'::character varying, 'cancelado'::character varying])::"text"[])))
);


--
-- Name: agendamento_id_agendamento_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."agendamento_id_agendamento_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: agendamento_id_agendamento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."agendamento_id_agendamento_seq" OWNED BY "public"."agendamento"."id_agendamento";


--
-- Name: categoria; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."categoria" (
    "id_categoria" integer NOT NULL,
    "nome" character varying(100) NOT NULL,
    "descricao" "text"
);


--
-- Name: categoria_id_categoria_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."categoria_id_categoria_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categoria_id_categoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."categoria_id_categoria_seq" OWNED BY "public"."categoria"."id_categoria";


--
-- Name: cliente; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cliente" (
    "id_cliente" integer NOT NULL,
    "nome" character varying(120) NOT NULL,
    "telefone" character varying(20),
    "email" character varying(150),
    "endereco" character varying(255),
    "data_cadastro" timestamp without time zone DEFAULT "now"() NOT NULL
);


--
-- Name: cliente_id_cliente_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cliente_id_cliente_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cliente_id_cliente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cliente_id_cliente_seq" OWNED BY "public"."cliente"."id_cliente";


--
-- Name: estoque; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."estoque" (
    "id_estoque" integer NOT NULL,
    "quantidade" integer DEFAULT 0 NOT NULL,
    "estoque_minimo" integer DEFAULT 0 NOT NULL,
    "produto_id" integer NOT NULL,
    "fornecedor_id" integer,
    CONSTRAINT "estoque_estoque_minimo_check" CHECK (("estoque_minimo" >= 0)),
    CONSTRAINT "estoque_quantidade_check" CHECK (("quantidade" >= 0))
);


--
-- Name: estoque_id_estoque_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."estoque_id_estoque_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: estoque_id_estoque_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."estoque_id_estoque_seq" OWNED BY "public"."estoque"."id_estoque";


--
-- Name: feedback; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."feedback" (
    "id_feedback" integer NOT NULL,
    "nota" smallint NOT NULL,
    "comentario" "text",
    "cliente_id" integer NOT NULL,
    "pedido_id" integer NOT NULL,
    CONSTRAINT "feedback_nota_check" CHECK ((("nota" >= 1) AND ("nota" <= 5)))
);


--
-- Name: feedback_id_feedback_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."feedback_id_feedback_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedback_id_feedback_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."feedback_id_feedback_seq" OWNED BY "public"."feedback"."id_feedback";


--
-- Name: fornecedor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."fornecedor" (
    "id_fornecedor" integer NOT NULL,
    "nome" character varying(150) NOT NULL,
    "cnpj" character varying(18) NOT NULL,
    "telefone" character varying(20),
    "email" character varying(150),
    "endereco" character varying(255)
);


--
-- Name: fornecedor_id_fornecedor_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."fornecedor_id_fornecedor_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fornecedor_id_fornecedor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."fornecedor_id_fornecedor_seq" OWNED BY "public"."fornecedor"."id_fornecedor";


--
-- Name: fornecedor_produto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."fornecedor_produto" (
    "id" integer NOT NULL,
    "fornecedor_id" integer NOT NULL,
    "produto_id" integer NOT NULL,
    "preco_compra" numeric(10,2) NOT NULL,
    "data_fornecimento" "date",
    CONSTRAINT "fornecedor_produto_preco_compra_check" CHECK (("preco_compra" >= (0)::numeric))
);


--
-- Name: fornecedor_produto_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."fornecedor_produto_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fornecedor_produto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."fornecedor_produto_id_seq" OWNED BY "public"."fornecedor_produto"."id";


--
-- Name: item_pedido; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."item_pedido" (
    "id_item" integer NOT NULL,
    "quantidade" integer NOT NULL,
    "preco_unitario" numeric(10,2) NOT NULL,
    "pedido_id" integer NOT NULL,
    "produto_id" integer NOT NULL,
    CONSTRAINT "item_pedido_preco_unitario_check" CHECK (("preco_unitario" >= (0)::numeric)),
    CONSTRAINT "item_pedido_quantidade_check" CHECK (("quantidade" > 0))
);


--
-- Name: item_pedido_id_item_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."item_pedido_id_item_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_pedido_id_item_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."item_pedido_id_item_seq" OWNED BY "public"."item_pedido"."id_item";


--
-- Name: orcamento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."orcamento" (
    "id_orcamento" integer NOT NULL,
    "data" timestamp without time zone DEFAULT "now"() NOT NULL,
    "status" character varying(30) DEFAULT 'aberto'::character varying NOT NULL,
    "total" numeric(10,2) DEFAULT 0 NOT NULL,
    "cliente_id" integer NOT NULL,
    "pedido_id" integer,
    CONSTRAINT "orcamento_status_check" CHECK ((("status")::"text" = ANY ((ARRAY['aberto'::character varying, 'aprovado'::character varying, 'recusado'::character varying, 'expirado'::character varying])::"text"[]))),
    CONSTRAINT "orcamento_total_check" CHECK (("total" >= (0)::numeric))
);


--
-- Name: orcamento_id_orcamento_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."orcamento_id_orcamento_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orcamento_id_orcamento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."orcamento_id_orcamento_seq" OWNED BY "public"."orcamento"."id_orcamento";


--
-- Name: pedido; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."pedido" (
    "id_pedido" integer NOT NULL,
    "data" timestamp without time zone DEFAULT "now"() NOT NULL,
    "status" character varying(30) DEFAULT 'pendente'::character varying NOT NULL,
    "total" numeric(10,2) DEFAULT 0 NOT NULL,
    "cliente_id" integer NOT NULL,
    CONSTRAINT "pedido_status_check" CHECK ((("status")::"text" = ANY ((ARRAY['pendente'::character varying, 'pago'::character varying, 'enviado'::character varying, 'entregue'::character varying, 'cancelado'::character varying])::"text"[]))),
    CONSTRAINT "pedido_total_check" CHECK (("total" >= (0)::numeric))
);


--
-- Name: pedido_id_pedido_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."pedido_id_pedido_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pedido_id_pedido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."pedido_id_pedido_seq" OWNED BY "public"."pedido"."id_pedido";


--
-- Name: pet; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."pet" (
    "id_pet" integer NOT NULL,
    "nome" character varying(100) NOT NULL,
    "tipo" character varying(50) NOT NULL,
    "raca" character varying(100),
    "idade" smallint,
    "cliente_id" integer NOT NULL,
    CONSTRAINT "pet_idade_check" CHECK (("idade" >= 0))
);


--
-- Name: pet_id_pet_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."pet_id_pet_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pet_id_pet_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."pet_id_pet_seq" OWNED BY "public"."pet"."id_pet";


--
-- Name: produto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produto" (
    "id_produto" integer NOT NULL,
    "nome" character varying(150) NOT NULL,
    "descricao" "text",
    "preco" numeric(10,2) NOT NULL,
    "categoria_id" integer NOT NULL,
    CONSTRAINT "produto_preco_check" CHECK (("preco" >= (0)::numeric))
);


--
-- Name: produto_id_produto_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."produto_id_produto_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: produto_id_produto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."produto_id_produto_seq" OWNED BY "public"."produto"."id_produto";


--
-- Name: agendamento id_agendamento; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."agendamento" ALTER COLUMN "id_agendamento" SET DEFAULT "nextval"('"public"."agendamento_id_agendamento_seq"'::"regclass");


--
-- Name: categoria id_categoria; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."categoria" ALTER COLUMN "id_categoria" SET DEFAULT "nextval"('"public"."categoria_id_categoria_seq"'::"regclass");


--
-- Name: cliente id_cliente; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cliente" ALTER COLUMN "id_cliente" SET DEFAULT "nextval"('"public"."cliente_id_cliente_seq"'::"regclass");


--
-- Name: estoque id_estoque; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."estoque" ALTER COLUMN "id_estoque" SET DEFAULT "nextval"('"public"."estoque_id_estoque_seq"'::"regclass");


--
-- Name: feedback id_feedback; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."feedback" ALTER COLUMN "id_feedback" SET DEFAULT "nextval"('"public"."feedback_id_feedback_seq"'::"regclass");


--
-- Name: fornecedor id_fornecedor; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fornecedor" ALTER COLUMN "id_fornecedor" SET DEFAULT "nextval"('"public"."fornecedor_id_fornecedor_seq"'::"regclass");


--
-- Name: fornecedor_produto id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fornecedor_produto" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."fornecedor_produto_id_seq"'::"regclass");


--
-- Name: item_pedido id_item; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."item_pedido" ALTER COLUMN "id_item" SET DEFAULT "nextval"('"public"."item_pedido_id_item_seq"'::"regclass");


--
-- Name: orcamento id_orcamento; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."orcamento" ALTER COLUMN "id_orcamento" SET DEFAULT "nextval"('"public"."orcamento_id_orcamento_seq"'::"regclass");


--
-- Name: pedido id_pedido; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedido" ALTER COLUMN "id_pedido" SET DEFAULT "nextval"('"public"."pedido_id_pedido_seq"'::"regclass");


--
-- Name: pet id_pet; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pet" ALTER COLUMN "id_pet" SET DEFAULT "nextval"('"public"."pet_id_pet_seq"'::"regclass");


--
-- Name: produto id_produto; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produto" ALTER COLUMN "id_produto" SET DEFAULT "nextval"('"public"."produto_id_produto_seq"'::"regclass");


--
-- Data for Name: agendamento; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."agendamento" ("id_agendamento", "data", "horario", "tipo_procedimento", "status", "pet_id") FROM stdin;
1	2026-10-20	09:00:00	Banho	concluido	1
2	2026-10-21	10:30:00	Tosa higienica	concluido	3
3	2026-10-22	14:00:00	Consulta veterinaria	concluido	4
4	2026-10-23	11:00:00	Banho e tosa	cancelado	5
5	2026-10-27	09:30:00	Banho	confirmado	6
6	2026-10-27	15:00:00	Vacinacao	confirmado	2
7	2026-10-28	10:00:00	Banho e tosa	agendado	10
8	2026-10-29	13:30:00	Consulta veterinaria	agendado	9
9	2026-10-30	16:00:00	Corte de unhas	agendado	7
10	2026-11-03	09:00:00	Banho	agendado	12
11	2026-11-05	11:30:00	Tosa higienica	agendado	8
12	2026-11-10	14:30:00	Check-up geral	agendado	11
\.


--
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."categoria" ("id_categoria", "nome", "descricao") FROM stdin;
1	Alimentacao	Racoes, saches e petiscos para caes e gatos
2	Higiene e Beleza	Shampoos, condicionadores e escovas
3	Brinquedos	Brinquedos e arranhadores para diversao e enriquecimento
4	Acessorios	Coleiras, peitorais, camas e guias
5	Saude e Bem-estar	Vermifugos, antipulgas e suplementos
\.


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."cliente" ("id_cliente", "nome", "telefone", "email", "endereco", "data_cadastro") FROM stdin;
1	Ana Beatriz Souza	(11) 98765-4321	ana.souza@email.com	Rua das Acacias, 120 - Vila Mariana, Sao Paulo/SP	2026-01-15 10:30:00
2	Carlos Eduardo Lima	(11) 97654-3210	carlos.lima@email.com	Av. Paulista, 1578 - Bela Vista, Sao Paulo/SP	2026-02-03 14:10:00
3	Fernanda Oliveira	(11) 96543-2109	fernanda.oliveira@email.com	Rua Augusta, 900 - Consolacao, Sao Paulo/SP	2026-02-20 09:45:00
4	Ricardo Mendes	(11) 95432-1098	ricardo.mendes@email.com	Rua Oscar Freire, 455 - Pinheiros, Sao Paulo/SP	2026-03-11 16:00:00
5	Juliana Castro	(11) 94321-0987	juliana.castro@email.com	Rua Vergueiro, 2300 - Liberdade, Sao Paulo/SP	2026-04-07 11:20:00
6	Marcos Vinicius Rocha	(11) 93210-9876	marcos.rocha@email.com	Rua Domingos de Morais, 640 - Vila Mariana, Sao Paulo/SP	2026-05-18 13:35:00
7	Patricia Almeida	(11) 92109-8765	patricia.almeida@email.com	Av. Brigadeiro Faria Lima, 3000 - Itaim Bibi, Sao Paulo/SP	2026-06-25 15:50:00
8	Lucas Ferreira	(11) 91098-7654	lucas.ferreira@email.com	Rua Teodoro Sampaio, 780 - Pinheiros, Sao Paulo/SP	2026-08-02 08:15:00
\.


--
-- Data for Name: estoque; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."estoque" ("id_estoque", "quantidade", "estoque_minimo", "produto_id", "fornecedor_id") FROM stdin;
1	25	10	1	1
2	18	8	2	1
3	60	20	3	1
4	150	50	4	1
5	40	15	5	2
6	35	15	6	2
7	22	10	7	2
8	45	15	8	3
9	8	5	9	3
10	70	25	10	3
11	30	12	11	3
12	12	6	12	3
13	20	8	13	3
14	28	10	14	4
15	4	10	15	4
\.


--
-- Data for Name: feedback; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."feedback" ("id_feedback", "nota", "comentario", "cliente_id", "pedido_id") FROM stdin;
1	5	Entrega rapida e produtos de otima qualidade. Meu Thor adorou a racao!	1	1
2	4	Gostei muito, so demorou um pouco para chegar.	2	2
3	5	Atendimento excelente e a coleira e muito confortavel.	5	5
4	4	A cama e otima, as bolinhas poderiam ser um pouco maiores.	1	7
5	3	Produtos bons, mas o pedido veio sem a nota fiscal.	3	3
\.


--
-- Data for Name: fornecedor; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."fornecedor" ("id_fornecedor", "nome", "cnpj", "telefone", "email", "endereco") FROM stdin;
1	NutriPet Alimentos Ltda	12.345.678/0001-90	(11) 3456-7890	contato@nutripet.com.br	Av. das Industrias, 1500 - Sao Paulo/SP
2	BelaPet Cosmeticos	23.456.789/0001-01	(11) 3567-8901	vendas@belapet.com.br	Rua das Flores, 220 - Guarulhos/SP
3	Diverte Pet Acessorios	34.567.890/0001-12	(19) 3678-9012	comercial@divertepet.com	Rod. Anhanguera km 98 - Campinas/SP
4	VetSaude Distribuidora	45.678.901/0001-23	(11) 3789-0123	pedidos@vetsaude.com.br	Rua Dr. Almeida, 85 - Sao Paulo/SP
\.


--
-- Data for Name: fornecedor_produto; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."fornecedor_produto" ("id", "fornecedor_id", "produto_id", "preco_compra", "data_fornecimento") FROM stdin;
1	1	1	135.00	2026-09-10
2	1	2	112.00	2026-09-10
3	1	3	14.50	2026-09-10
4	1	4	2.80	2026-09-10
5	2	5	19.00	2026-09-15
6	2	6	21.50	2026-09-15
7	2	7	16.00	2026-09-15
8	3	7	17.50	2026-09-20
9	3	8	9.50	2026-09-20
10	3	9	75.00	2026-09-20
11	3	10	8.00	2026-09-20
12	3	11	22.00	2026-09-22
13	3	12	55.00	2026-09-22
14	3	13	32.00	2026-09-22
15	4	14	31.00	2026-10-01
16	4	15	45.00	2026-10-01
\.


--
-- Data for Name: item_pedido; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."item_pedido" ("id_item", "quantidade", "preco_unitario", "pedido_id", "produto_id") FROM stdin;
1	1	189.90	1	1
2	2	24.90	1	3
3	1	159.90	2	2
4	6	4.50	2	4
5	1	32.00	3	5
6	1	35.50	3	6
7	1	29.90	3	7
8	1	119.00	4	9
9	2	15.50	4	10
10	1	39.90	5	11
11	1	54.90	5	13
12	1	49.90	6	14
13	2	69.90	6	15
14	1	89.90	7	12
15	3	18.90	7	8
16	1	189.90	8	1
\.


--
-- Data for Name: orcamento; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."orcamento" ("id_orcamento", "data", "status", "total", "cliente_id", "pedido_id") FROM stdin;
1	2026-10-01 18:00:00	aprovado	239.70	1	1
2	2026-10-09 10:30:00	aprovado	97.40	3	3
3	2026-10-15 14:20:00	aprovado	94.80	5	5
4	2026-10-20 09:10:00	aberto	320.00	8	\N
5	2026-10-21 16:45:00	recusado	85.00	2	\N
\.


--
-- Data for Name: pedido; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."pedido" ("id_pedido", "data", "status", "total", "cliente_id") FROM stdin;
1	2026-10-02 10:15:00	entregue	239.70	1
2	2026-10-05 15:40:00	entregue	186.90	2
3	2026-10-10 11:05:00	pago	97.40	3
4	2026-10-14 17:30:00	enviado	150.00	4
5	2026-10-16 09:20:00	entregue	94.80	5
6	2026-10-22 13:55:00	pendente	189.70	6
7	2026-10-24 16:10:00	entregue	146.60	1
8	2026-10-25 12:00:00	cancelado	189.90	7
\.


--
-- Data for Name: pet; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."pet" ("id_pet", "nome", "tipo", "raca", "idade", "cliente_id") FROM stdin;
1	Thor	Cao	Golden Retriever	4	1
2	Mel	Gato	Siames	2	1
3	Bobby	Cao	Poodle	7	2
4	Luna	Gato	Persa	3	3
5	Rex	Cao	Pastor Alemao	5	4
6	Nina	Cao	Shih Tzu	2	5
7	Pipoca	Coelho	Mini Lop	1	5
8	Zeca	Cao	Vira-lata	9	6
9	Mimi	Gato	SRD	6	7
10	Bidu	Cao	Beagle	3	7
11	Kiwi	Ave	Calopsita	2	8
12	Fred	Cao	Bulldog Frances	4	8
\.


--
-- Data for Name: produto; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."produto" ("id_produto", "nome", "descricao", "preco", "categoria_id") FROM stdin;
1	Racao Premium Caes Adultos 15kg	Racao super premium sabor frango e arroz para caes adultos	189.90	1
2	Racao Premium Gatos Castrados 10kg	Racao com controle de peso para gatos castrados	159.90	1
3	Petisco Bifinho Carne 500g	Petisco macio sabor carne para caes	24.90	1
4	Sache Gatos Filhotes 85g	Alimento umido para gatos filhotes	4.50	1
5	Shampoo Neutro 500ml	Shampoo hipoalergenico para caes e gatos	32.00	2
6	Condicionador Pelos Longos 500ml	Facilita o desembaraco e deixa o pelo macio	35.50	2
7	Escova Removedora de Pelos	Escova com cerdas macias para remocao de pelos soltos	29.90	2
8	Bola de Borracha Macica	Brinquedo resistente para caes de medio porte	18.90	3
9	Arranhador Torre para Gatos	Torre com 3 andares e esconderijo	119.00	3
10	Corda Mordedor	Corda de algodao trancado para brincar e limpar os dentes	15.50	3
11	Coleira Ajustavel M	Coleira de nylon com fecho de seguranca, tamanho M	39.90	4
12	Cama Pet Media	Cama acolchoada lavavel para caes e gatos de porte medio	89.90	4
13	Peitoral com Guia	Peitoral acolchoado com guia de 1,2m	54.90	4
14	Vermifugo Caes 4 comprimidos	Vermifugo de amplo espectro para caes	49.90	5
15	Antipulgas Gatos Pipeta	Pipeta antipulgas e carrapatos para gatos	69.90	5
\.


--
-- Name: agendamento_id_agendamento_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."agendamento_id_agendamento_seq"', 12, true);


--
-- Name: categoria_id_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."categoria_id_categoria_seq"', 5, true);


--
-- Name: cliente_id_cliente_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."cliente_id_cliente_seq"', 8, true);


--
-- Name: estoque_id_estoque_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."estoque_id_estoque_seq"', 15, true);


--
-- Name: feedback_id_feedback_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."feedback_id_feedback_seq"', 5, true);


--
-- Name: fornecedor_id_fornecedor_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."fornecedor_id_fornecedor_seq"', 4, true);


--
-- Name: fornecedor_produto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."fornecedor_produto_id_seq"', 16, true);


--
-- Name: item_pedido_id_item_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."item_pedido_id_item_seq"', 16, true);


--
-- Name: orcamento_id_orcamento_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."orcamento_id_orcamento_seq"', 5, true);


--
-- Name: pedido_id_pedido_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."pedido_id_pedido_seq"', 8, true);


--
-- Name: pet_id_pet_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."pet_id_pet_seq"', 12, true);


--
-- Name: produto_id_produto_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."produto_id_produto_seq"', 15, true);


--
-- Name: agendamento agendamento_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."agendamento"
    ADD CONSTRAINT "agendamento_pkey" PRIMARY KEY ("id_agendamento");


--
-- Name: categoria categoria_nome_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."categoria"
    ADD CONSTRAINT "categoria_nome_key" UNIQUE ("nome");


--
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."categoria"
    ADD CONSTRAINT "categoria_pkey" PRIMARY KEY ("id_categoria");


--
-- Name: cliente cliente_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cliente"
    ADD CONSTRAINT "cliente_email_key" UNIQUE ("email");


--
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cliente"
    ADD CONSTRAINT "cliente_pkey" PRIMARY KEY ("id_cliente");


--
-- Name: estoque estoque_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."estoque"
    ADD CONSTRAINT "estoque_pkey" PRIMARY KEY ("id_estoque");


--
-- Name: estoque estoque_produto_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."estoque"
    ADD CONSTRAINT "estoque_produto_id_key" UNIQUE ("produto_id");


--
-- Name: feedback feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."feedback"
    ADD CONSTRAINT "feedback_pkey" PRIMARY KEY ("id_feedback");


--
-- Name: fornecedor fornecedor_cnpj_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fornecedor"
    ADD CONSTRAINT "fornecedor_cnpj_key" UNIQUE ("cnpj");


--
-- Name: fornecedor fornecedor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fornecedor"
    ADD CONSTRAINT "fornecedor_pkey" PRIMARY KEY ("id_fornecedor");


--
-- Name: fornecedor_produto fornecedor_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fornecedor_produto"
    ADD CONSTRAINT "fornecedor_produto_pkey" PRIMARY KEY ("id");


--
-- Name: item_pedido item_pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."item_pedido"
    ADD CONSTRAINT "item_pedido_pkey" PRIMARY KEY ("id_item");


--
-- Name: orcamento orcamento_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."orcamento"
    ADD CONSTRAINT "orcamento_pkey" PRIMARY KEY ("id_orcamento");


--
-- Name: pedido pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedido"
    ADD CONSTRAINT "pedido_pkey" PRIMARY KEY ("id_pedido");


--
-- Name: pet pet_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pet"
    ADD CONSTRAINT "pet_pkey" PRIMARY KEY ("id_pet");


--
-- Name: produto produto_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produto"
    ADD CONSTRAINT "produto_pkey" PRIMARY KEY ("id_produto");


--
-- Name: fornecedor_produto uq_fornecedor_produto; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fornecedor_produto"
    ADD CONSTRAINT "uq_fornecedor_produto" UNIQUE ("fornecedor_id", "produto_id");


--
-- Name: idx_agendamento_data; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_agendamento_data" ON "public"."agendamento" USING "btree" ("data", "horario");


--
-- Name: idx_agendamento_pet; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_agendamento_pet" ON "public"."agendamento" USING "btree" ("pet_id");


--
-- Name: idx_estoque_fornecedor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_estoque_fornecedor" ON "public"."estoque" USING "btree" ("fornecedor_id");


--
-- Name: idx_feedback_cliente; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_feedback_cliente" ON "public"."feedback" USING "btree" ("cliente_id");


--
-- Name: idx_feedback_pedido; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_feedback_pedido" ON "public"."feedback" USING "btree" ("pedido_id");


--
-- Name: idx_fp_produto; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_fp_produto" ON "public"."fornecedor_produto" USING "btree" ("produto_id");


--
-- Name: idx_item_pedido_pedido; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_item_pedido_pedido" ON "public"."item_pedido" USING "btree" ("pedido_id");


--
-- Name: idx_item_pedido_produto; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_item_pedido_produto" ON "public"."item_pedido" USING "btree" ("produto_id");


--
-- Name: idx_orcamento_cliente; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_orcamento_cliente" ON "public"."orcamento" USING "btree" ("cliente_id");


--
-- Name: idx_orcamento_pedido; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_orcamento_pedido" ON "public"."orcamento" USING "btree" ("pedido_id");


--
-- Name: idx_pedido_cliente; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_pedido_cliente" ON "public"."pedido" USING "btree" ("cliente_id");


--
-- Name: idx_pet_cliente; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_pet_cliente" ON "public"."pet" USING "btree" ("cliente_id");


--
-- Name: idx_produto_categoria; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_produto_categoria" ON "public"."produto" USING "btree" ("categoria_id");


--
-- Name: agendamento fk_agendamento_pet; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."agendamento"
    ADD CONSTRAINT "fk_agendamento_pet" FOREIGN KEY ("pet_id") REFERENCES "public"."pet"("id_pet") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: estoque fk_estoque_fornecedor; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."estoque"
    ADD CONSTRAINT "fk_estoque_fornecedor" FOREIGN KEY ("fornecedor_id") REFERENCES "public"."fornecedor"("id_fornecedor") ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: estoque fk_estoque_produto; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."estoque"
    ADD CONSTRAINT "fk_estoque_produto" FOREIGN KEY ("produto_id") REFERENCES "public"."produto"("id_produto") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: feedback fk_feedback_cliente; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."feedback"
    ADD CONSTRAINT "fk_feedback_cliente" FOREIGN KEY ("cliente_id") REFERENCES "public"."cliente"("id_cliente") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: feedback fk_feedback_pedido; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."feedback"
    ADD CONSTRAINT "fk_feedback_pedido" FOREIGN KEY ("pedido_id") REFERENCES "public"."pedido"("id_pedido") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fornecedor_produto fk_fp_fornecedor; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fornecedor_produto"
    ADD CONSTRAINT "fk_fp_fornecedor" FOREIGN KEY ("fornecedor_id") REFERENCES "public"."fornecedor"("id_fornecedor") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fornecedor_produto fk_fp_produto; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fornecedor_produto"
    ADD CONSTRAINT "fk_fp_produto" FOREIGN KEY ("produto_id") REFERENCES "public"."produto"("id_produto") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: item_pedido fk_item_pedido; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."item_pedido"
    ADD CONSTRAINT "fk_item_pedido" FOREIGN KEY ("pedido_id") REFERENCES "public"."pedido"("id_pedido") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: item_pedido fk_item_produto; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."item_pedido"
    ADD CONSTRAINT "fk_item_produto" FOREIGN KEY ("produto_id") REFERENCES "public"."produto"("id_produto") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orcamento fk_orcamento_cliente; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."orcamento"
    ADD CONSTRAINT "fk_orcamento_cliente" FOREIGN KEY ("cliente_id") REFERENCES "public"."cliente"("id_cliente") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orcamento fk_orcamento_pedido; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."orcamento"
    ADD CONSTRAINT "fk_orcamento_pedido" FOREIGN KEY ("pedido_id") REFERENCES "public"."pedido"("id_pedido") ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pedido fk_pedido_cliente; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedido"
    ADD CONSTRAINT "fk_pedido_cliente" FOREIGN KEY ("cliente_id") REFERENCES "public"."cliente"("id_cliente") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: pet fk_pet_cliente; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pet"
    ADD CONSTRAINT "fk_pet_cliente" FOREIGN KEY ("cliente_id") REFERENCES "public"."cliente"("id_cliente") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: produto fk_produto_categoria; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produto"
    ADD CONSTRAINT "fk_produto_categoria" FOREIGN KEY ("categoria_id") REFERENCES "public"."categoria"("id_categoria") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict 2nf8h8Id4PJmgqAwaYXRUkNeoWXKbBWAbrUG829RTNT1yiL8vcfPG42G3zgo3zb

