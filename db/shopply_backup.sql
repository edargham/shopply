toc.dat                                                                                             0000600 0004000 0002000 00000035362 14463144556 0014464 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP           0                {           shopply    15.3    15.3 +    ?           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false         @           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false         A           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false         B           1262    16394    shopply    DATABASE        CREATE DATABASE shopply WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE shopply;
                postgres    false                     2615    16395    shopply    SCHEMA        CREATE SCHEMA shopply;
    DROP SCHEMA shopply;
                postgres    false         á            1255    16396 $   fn_liked_products(character varying)    FUNCTION     ©  CREATE FUNCTION shopply.fn_liked_products(in_username character varying) RETURNS TABLE(id character varying, title character varying, description character varying, "imageUrl" character varying, price double precision, stock integer, liked boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT 
	"shopply"."products".*,
	(
		CASE 
			WHEN "shopply"."user_likes_products"."username" IS NOT NULL 
			AND  "shopply"."user_likes_products"."username" = in_username
			THEN TRUE 
			ELSE FALSE
		END
	) AS "liked" 
	FROM "shopply"."products"
	LEFT JOIN "shopply"."user_likes_products" 
	ON "shopply"."products"."id" = "shopply"."user_likes_products"."product_id";
END
$$;
 H   DROP FUNCTION shopply.fn_liked_products(in_username character varying);
       shopply          postgres    false    6         ×            1259    16397 	   cart_item    TABLE       CREATE TABLE shopply.cart_item (
    id character varying(128) NOT NULL,
    username character varying(16) NOT NULL,
    product_id character varying(128) NOT NULL,
    quantity integer NOT NULL,
    price double precision NOT NULL,
    order_id character varying(128)
);
    DROP TABLE shopply.cart_item;
       shopply         heap    postgres    false    6         Ø            1259    16400    order    TABLE     ø   CREATE TABLE shopply."order" (
    id character varying(128) NOT NULL,
    amount_paid double precision NOT NULL,
    date_ordered timestamp without time zone NOT NULL,
    username character varying(16) NOT NULL,
    status_id integer NOT NULL
);
    DROP TABLE shopply."order";
       shopply         heap    postgres    false    6         Ù            1259    16403    order_status    TABLE     j   CREATE TABLE shopply.order_status (
    id integer NOT NULL,
    status character varying(64) NOT NULL
);
 !   DROP TABLE shopply.order_status;
       shopply         heap    postgres    false    6         Ú            1259    16406    products    TABLE       CREATE TABLE shopply.products (
    id character varying(128) NOT NULL,
    title character varying(128) NOT NULL,
    description character varying(4096),
    image_url character varying(512),
    price double precision NOT NULL,
    stock integer NOT NULL
);
    DROP TABLE shopply.products;
       shopply         heap    postgres    false    6         Û            1259    16411    rating    TABLE     ¾   CREATE TABLE shopply.rating (
    id character varying(128) NOT NULL,
    star_rating integer NOT NULL,
    review character varying(4096),
    product_id character varying(128) NOT NULL
);
    DROP TABLE shopply.rating;
       shopply         heap    postgres    false    6         Ü            1259    16416    star_rating    TABLE     Z   CREATE TABLE shopply.star_rating (
    id integer NOT NULL,
    stars integer NOT NULL
);
     DROP TABLE shopply.star_rating;
       shopply         heap    postgres    false    6         Ý            1259    16419 
   sys_admins    TABLE       CREATE TABLE shopply.sys_admins (
    username character varying(16) NOT NULL,
    first_name character varying(64) NOT NULL,
    last_name character varying(64) NOT NULL,
    email character varying(256) NOT NULL,
    phone_number character varying(128) NOT NULL,
    password character varying(512) NOT NULL,
    stamp character varying(128) NOT NULL,
    date_created timestamp without time zone NOT NULL
);
    DROP TABLE shopply.sys_admins;
       shopply         heap    postgres    false    6         Þ            1259    16424    user    TABLE     x  CREATE TABLE shopply."user" (
    username character varying(16) NOT NULL,
    first_name character varying(64) NOT NULL,
    middle_name character varying(64),
    last_name character varying(64) NOT NULL,
    date_of_birth date NOT NULL,
    sex boolean NOT NULL,
    email character varying(256) NOT NULL,
    phone_number character varying(128),
    password character varying(512) NOT NULL,
    stamp character varying(128) NOT NULL,
    date_joined timestamp without time zone NOT NULL,
    profile_photo_url character varying(512)[],
    is_verified boolean NOT NULL,
    verification_hash character varying(128) NOT NULL
);
    DROP TABLE shopply."user";
       shopply         heap    postgres    false    6         ß            1259    16429    user_likes_products    TABLE     ²   CREATE TABLE shopply.user_likes_products (
    id character varying(128) NOT NULL,
    username character varying(16) NOT NULL,
    product_id character varying(128) NOT NULL
);
 (   DROP TABLE shopply.user_likes_products;
       shopply         heap    postgres    false    6         à            1259    16432    vw_cart_item    VIEW     6  CREATE VIEW shopply.vw_cart_item AS
 SELECT cart_item.id,
    cart_item.username,
    cart_item.product_id,
    cart_item.quantity,
    cart_item.price,
    cart_item.order_id,
    products.title
   FROM (shopply.cart_item
     JOIN shopply.products ON (((cart_item.product_id)::text = (products.id)::text)));
     DROP VIEW shopply.vw_cart_item;
       shopply          postgres    false    215    215    218    218    215    215    215    215    6         4          0    16397 	   cart_item 
   TABLE DATA           Y   COPY shopply.cart_item (id, username, product_id, quantity, price, order_id) FROM stdin;
    shopply          postgres    false    215       3380.dat 5          0    16400    order 
   TABLE DATA           V   COPY shopply."order" (id, amount_paid, date_ordered, username, status_id) FROM stdin;
    shopply          postgres    false    216       3381.dat 6          0    16403    order_status 
   TABLE DATA           3   COPY shopply.order_status (id, status) FROM stdin;
    shopply          postgres    false    217       3382.dat 7          0    16406    products 
   TABLE DATA           T   COPY shopply.products (id, title, description, image_url, price, stock) FROM stdin;
    shopply          postgres    false    218       3383.dat 8          0    16411    rating 
   TABLE DATA           F   COPY shopply.rating (id, star_rating, review, product_id) FROM stdin;
    shopply          postgres    false    219       3384.dat 9          0    16416    star_rating 
   TABLE DATA           1   COPY shopply.star_rating (id, stars) FROM stdin;
    shopply          postgres    false    220       3385.dat :          0    16419 
   sys_admins 
   TABLE DATA           z   COPY shopply.sys_admins (username, first_name, last_name, email, phone_number, password, stamp, date_created) FROM stdin;
    shopply          postgres    false    221       3386.dat ;          0    16424    user 
   TABLE DATA           É   COPY shopply."user" (username, first_name, middle_name, last_name, date_of_birth, sex, email, phone_number, password, stamp, date_joined, profile_photo_url, is_verified, verification_hash) FROM stdin;
    shopply          postgres    false    222       3387.dat <          0    16429    user_likes_products 
   TABLE DATA           H   COPY shopply.user_likes_products (id, username, product_id) FROM stdin;
    shopply          postgres    false    223       3388.dat            2606    16437    cart_item cart_item_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY shopply.cart_item
    ADD CONSTRAINT cart_item_pkey PRIMARY KEY (id);
 C   ALTER TABLE ONLY shopply.cart_item DROP CONSTRAINT cart_item_pkey;
       shopply            postgres    false    215                    2606    16439    order order_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY shopply."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);
 =   ALTER TABLE ONLY shopply."order" DROP CONSTRAINT order_pkey;
       shopply            postgres    false    216                    2606    16441    order_status order_status_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY shopply.order_status
    ADD CONSTRAINT order_status_pkey PRIMARY KEY (id);
 I   ALTER TABLE ONLY shopply.order_status DROP CONSTRAINT order_status_pkey;
       shopply            postgres    false    217                    2606    16443    products products_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY shopply.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);
 A   ALTER TABLE ONLY shopply.products DROP CONSTRAINT products_pkey;
       shopply            postgres    false    218                    2606    16445    rating rating_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY shopply.rating
    ADD CONSTRAINT rating_pkey PRIMARY KEY (id);
 =   ALTER TABLE ONLY shopply.rating DROP CONSTRAINT rating_pkey;
       shopply            postgres    false    219                    2606    16447    star_rating star_rating_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY shopply.star_rating
    ADD CONSTRAINT star_rating_pkey PRIMARY KEY (id);
 G   ALTER TABLE ONLY shopply.star_rating DROP CONSTRAINT star_rating_pkey;
       shopply            postgres    false    220                    2606    16449    sys_admins sys_admins_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY shopply.sys_admins
    ADD CONSTRAINT sys_admins_pkey PRIMARY KEY (username);
 E   ALTER TABLE ONLY shopply.sys_admins DROP CONSTRAINT sys_admins_pkey;
       shopply            postgres    false    221                    2606    16451 ,   user_likes_products user_likes_products_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY shopply.user_likes_products
    ADD CONSTRAINT user_likes_products_pkey PRIMARY KEY (id);
 W   ALTER TABLE ONLY shopply.user_likes_products DROP CONSTRAINT user_likes_products_pkey;
       shopply            postgres    false    223                    2606    16453    user user_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY shopply."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (username);
 ;   ALTER TABLE ONLY shopply."user" DROP CONSTRAINT user_pkey;
       shopply            postgres    false    222                    2606    16454 "   cart_item fk_cart_item_order_item1    FK CONSTRAINT        ALTER TABLE ONLY shopply.cart_item
    ADD CONSTRAINT fk_cart_item_order_item1 FOREIGN KEY (order_id) REFERENCES shopply."order"(id) ON DELETE CASCADE;
 M   ALTER TABLE ONLY shopply.cart_item DROP CONSTRAINT fk_cart_item_order_item1;
       shopply          postgres    false    216    3213    215                    2606    16459    order fk_order_order_status1    FK CONSTRAINT        ALTER TABLE ONLY shopply."order"
    ADD CONSTRAINT fk_order_order_status1 FOREIGN KEY (status_id) REFERENCES shopply.order_status(id) ON DELETE CASCADE;
 I   ALTER TABLE ONLY shopply."order" DROP CONSTRAINT fk_order_order_status1;
       shopply          postgres    false    3215    217    216                     2606    16464    order fk_order_user1    FK CONSTRAINT        ALTER TABLE ONLY shopply."order"
    ADD CONSTRAINT fk_order_user1 FOREIGN KEY (username) REFERENCES shopply."user"(username) ON DELETE CASCADE;
 A   ALTER TABLE ONLY shopply."order" DROP CONSTRAINT fk_order_user1;
       shopply          postgres    false    3225    222    216         ¡           2606    16469    rating fk_rating_products1    FK CONSTRAINT        ALTER TABLE ONLY shopply.rating
    ADD CONSTRAINT fk_rating_products1 FOREIGN KEY (product_id) REFERENCES shopply.products(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY shopply.rating DROP CONSTRAINT fk_rating_products1;
       shopply          postgres    false    219    3217    218         ¢           2606    16474    rating fk_rating_star_rating1    FK CONSTRAINT        ALTER TABLE ONLY shopply.rating
    ADD CONSTRAINT fk_rating_star_rating1 FOREIGN KEY (star_rating) REFERENCES shopply.star_rating(id);
 H   ALTER TABLE ONLY shopply.rating DROP CONSTRAINT fk_rating_star_rating1;
       shopply          postgres    false    219    3221    220                    2606    16479 (   cart_item fk_user_has_products_products1    FK CONSTRAINT     ¡   ALTER TABLE ONLY shopply.cart_item
    ADD CONSTRAINT fk_user_has_products_products1 FOREIGN KEY (product_id) REFERENCES shopply.products(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY shopply.cart_item DROP CONSTRAINT fk_user_has_products_products1;
       shopply          postgres    false    215    218    3217         £           2606    16484 2   user_likes_products fk_user_has_products_products2    FK CONSTRAINT     «   ALTER TABLE ONLY shopply.user_likes_products
    ADD CONSTRAINT fk_user_has_products_products2 FOREIGN KEY (product_id) REFERENCES shopply.products(id) ON DELETE CASCADE;
 ]   ALTER TABLE ONLY shopply.user_likes_products DROP CONSTRAINT fk_user_has_products_products2;
       shopply          postgres    false    3217    223    218                    2606    16489 #   cart_item fk_user_has_products_user    FK CONSTRAINT        ALTER TABLE ONLY shopply.cart_item
    ADD CONSTRAINT fk_user_has_products_user FOREIGN KEY (username) REFERENCES shopply."user"(username) ON DELETE CASCADE;
 N   ALTER TABLE ONLY shopply.cart_item DROP CONSTRAINT fk_user_has_products_user;
       shopply          postgres    false    222    3225    215         ¤           2606    16494 .   user_likes_products fk_user_has_products_user1    FK CONSTRAINT     ©   ALTER TABLE ONLY shopply.user_likes_products
    ADD CONSTRAINT fk_user_has_products_user1 FOREIGN KEY (username) REFERENCES shopply."user"(username) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY shopply.user_likes_products DROP CONSTRAINT fk_user_has_products_user1;
       shopply          postgres    false    222    223    3225                                                                                                                                                                                                                                                                                      3380.dat                                                                                            0000600 0004000 0002000 00000001203 14463144556 0014257 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        d6486c41-7dea-4ddf-b196-3d4f51c6f4f9	edargham	ad018f60-2ed2-49fd-ae90-1e3180616849	3	46.47	911a90b7-2e70-45bb-b37d-43028b9731ea
11056128-ac98-4a4c-9a1d-05cc6780f02b	edargham	36674f55-ae42-4e43-814f-5ccdca4dae48	1	4.99	911a90b7-2e70-45bb-b37d-43028b9731ea
0cc51bdf-32ad-4a45-a0f4-346e25400f5c	edargham	ad018f60-2ed2-49fd-ae90-1e3180616849	1	15.49	f5dd4a42-68ce-4109-96eb-f09edd4d799a
9b19d3a0-a1d9-4625-8940-291551ad84ee	edargham	36674f55-ae42-4e43-814f-5ccdca4dae48	1	4.99	ea0932d2-59d1-479c-b7de-6c9ff196ca84
eac75065-7df2-41d0-896a-6ab57de3139b	edargham	ad018f60-2ed2-49fd-ae90-1e3180616849	1	15.49	ea0932d2-59d1-479c-b7de-6c9ff196ca84
\.


                                                                                                                                                                                                                                                                                                                                                                                             3381.dat                                                                                            0000600 0004000 0002000 00000000357 14463144556 0014271 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        911a90b7-2e70-45bb-b37d-43028b9731ea	51.46	2023-07-15 08:16:46.129	edargham	1
f5dd4a42-68ce-4109-96eb-f09edd4d799a	15.49	2023-07-19 07:04:09.248	edargham	1
ea0932d2-59d1-479c-b7de-6c9ff196ca84	20.48	2023-07-19 07:05:02.832	edargham	1
\.


                                                                                                                                                                                                                                                                                 3382.dat                                                                                            0000600 0004000 0002000 00000000065 14463144556 0014266 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Pending
2	Processing
3	Delivering
4	Completed
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3383.dat                                                                                            0000600 0004000 0002000 00000003673 14463144556 0014277 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        ad018f60-2ed2-49fd-ae90-1e3180616849	Toblerone	Swiss milk chocolate with honey and almond nougat (10%). Smooth Swiss milk chocolate with delectable honey and almond nougat, Unique triangles of delicious milk chocolate to give as a gift or share with family and friends.ï»¿	uploads/products/product_2f846063-669b-4f60-ba16-a745eac44f9e_toblerone.jpg	15.49	100
36674f55-ae42-4e43-814f-5ccdca4dae48	Hershey's Chocolate	Hershey's Cookies N CrÃ¨me Bars come with the perfect blend of cookies and creme.;These wholesome, tasty and delicious bars offer a delectable taste in every bite to satisfy your sweet urges.;Hershey s Bars are perfect for snacking, sharing, or gifting;This is a pack of 8 bars of 40 G each. Also available in 100 G pack options.;Also available in Creamy Milk and Whole Almonds flavors.	uploads/products/product_82914fc1-2ae5-4d4b-b6d3-c92ebc7b4e9d_hersheys.jpg	4.99	100
09083618-d12f-4e80-b18c-7eb25efbc530	Oreo Chocolate Sandwich	- One 14.3 oz package of OREO Chocolate Sandwich Cookies (packaging may vary)\r\n- Chocolate wafers filled with original OREO creme make great afternoon snacks\r\n- Sandwich cookies are supremely dunkable cookies for children and adults\r\n- Sandwich cookies are great for sharing and entertaining\r\n- Resealable package helps keep snack cookies fresh	uploads/products/product_548879c2-cf4a-4442-8cbf-e1ab9b59fb54_OreoChocSand.jpg	10	100
52300270-c2a7-4cbf-b774-ec81071218d5	Snickers Fun Size Chocolate Candy Bars	- Contains one 10.59-ounce bag of Fun Size Chocolate Candy Bars\r\n- Perfect for office managers and fantasy football fans looking for bulk candy to stock the office pantry\r\n- Made with caramel, nougat, peanuts and milk chocolate\r\n- This bag of SNICKERS Fun Size Chocolates is perfect for your next party, to fill candy buffets, or to make your favorite dessert recipe\r\n- Great for fall tailgating or watching the big game	uploads/products/product_26574c7f-8c80-46c7-bb4d-1bf76b0466b2_snickers.jpeg	5	100
\.


                                                                     3384.dat                                                                                            0000600 0004000 0002000 00000000005 14463144556 0014262 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3385.dat                                                                                            0000600 0004000 0002000 00000000005 14463144556 0014263 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3386.dat                                                                                            0000600 0004000 0002000 00000000353 14463144556 0014272 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        root	Iam	Root	root@shopply.com	81205500	bcb9e6d35e5d86baded2195a6ee919ee244c965fe66932353c54eb0e259b0d536a3dfe7084458db5d7a3c13be061003102c7a4c4870599a950583523d0cf5755	0d36ce8a-1fc9-4bd8-b045-8b853de9e2b5	2023-07-19 07:12:13.969
\.


                                                                                                                                                                                                                                                                                     3387.dat                                                                                            0000600 0004000 0002000 00000001130 14463144556 0014265 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        tiesto	DeeJay	Avigilon	Tiesto	1998-09-11	t	tiesto@test.com	\N	8429e403a593cf38bfadb68145a0d3c760064d84599bf5f45d7f1a66818687537b12ed42e0384b6a878c67474922f4b2f1c31f2aad49800dcbad269bc05b0b4a	cd9b4c72-7937-42da-a2dc-075be39d759d	2023-07-15 07:22:12.511	\N	f	fd86b9a6-5bf1-4b98-a257-a57de27f5185
edargham	Elias	\N	Dargham	2023-07-15	t	edargham@hotmail.com	71052353	e0186d476f9107ee2123893018f4fc2dff94e0774ce6ed9c832f4030e00b15985e99eda0d0c2cf69999a49932afd8141ca7c5c051f3ecddcc5ad7052b14e9772	e4e2e0bf-1951-442a-8ea8-117d45937cd2	2023-07-15 08:15:55.315	\N	f	75477597-643c-4ef7-92f7-04b6132bd917
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                        3388.dat                                                                                            0000600 0004000 0002000 00000000130 14463144556 0014265 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        49695693-d57c-4da7-bf90-169be2f7f925	edargham	ad018f60-2ed2-49fd-ae90-1e3180616849
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                        restore.sql                                                                                         0000600 0004000 0002000 00000031221 14463144556 0015377 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE shopply;
--
-- Name: shopply; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE shopply WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';


ALTER DATABASE shopply OWNER TO postgres;

\connect shopply

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: shopply; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA shopply;


ALTER SCHEMA shopply OWNER TO postgres;

--
-- Name: fn_liked_products(character varying); Type: FUNCTION; Schema: shopply; Owner: postgres
--

CREATE FUNCTION shopply.fn_liked_products(in_username character varying) RETURNS TABLE(id character varying, title character varying, description character varying, "imageUrl" character varying, price double precision, stock integer, liked boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT 
	"shopply"."products".*,
	(
		CASE 
			WHEN "shopply"."user_likes_products"."username" IS NOT NULL 
			AND  "shopply"."user_likes_products"."username" = in_username
			THEN TRUE 
			ELSE FALSE
		END
	) AS "liked" 
	FROM "shopply"."products"
	LEFT JOIN "shopply"."user_likes_products" 
	ON "shopply"."products"."id" = "shopply"."user_likes_products"."product_id";
END
$$;


ALTER FUNCTION shopply.fn_liked_products(in_username character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cart_item; Type: TABLE; Schema: shopply; Owner: postgres
--

CREATE TABLE shopply.cart_item (
    id character varying(128) NOT NULL,
    username character varying(16) NOT NULL,
    product_id character varying(128) NOT NULL,
    quantity integer NOT NULL,
    price double precision NOT NULL,
    order_id character varying(128)
);


ALTER TABLE shopply.cart_item OWNER TO postgres;

--
-- Name: order; Type: TABLE; Schema: shopply; Owner: postgres
--

CREATE TABLE shopply."order" (
    id character varying(128) NOT NULL,
    amount_paid double precision NOT NULL,
    date_ordered timestamp without time zone NOT NULL,
    username character varying(16) NOT NULL,
    status_id integer NOT NULL
);


ALTER TABLE shopply."order" OWNER TO postgres;

--
-- Name: order_status; Type: TABLE; Schema: shopply; Owner: postgres
--

CREATE TABLE shopply.order_status (
    id integer NOT NULL,
    status character varying(64) NOT NULL
);


ALTER TABLE shopply.order_status OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: shopply; Owner: postgres
--

CREATE TABLE shopply.products (
    id character varying(128) NOT NULL,
    title character varying(128) NOT NULL,
    description character varying(4096),
    image_url character varying(512),
    price double precision NOT NULL,
    stock integer NOT NULL
);


ALTER TABLE shopply.products OWNER TO postgres;

--
-- Name: rating; Type: TABLE; Schema: shopply; Owner: postgres
--

CREATE TABLE shopply.rating (
    id character varying(128) NOT NULL,
    star_rating integer NOT NULL,
    review character varying(4096),
    product_id character varying(128) NOT NULL
);


ALTER TABLE shopply.rating OWNER TO postgres;

--
-- Name: star_rating; Type: TABLE; Schema: shopply; Owner: postgres
--

CREATE TABLE shopply.star_rating (
    id integer NOT NULL,
    stars integer NOT NULL
);


ALTER TABLE shopply.star_rating OWNER TO postgres;

--
-- Name: sys_admins; Type: TABLE; Schema: shopply; Owner: postgres
--

CREATE TABLE shopply.sys_admins (
    username character varying(16) NOT NULL,
    first_name character varying(64) NOT NULL,
    last_name character varying(64) NOT NULL,
    email character varying(256) NOT NULL,
    phone_number character varying(128) NOT NULL,
    password character varying(512) NOT NULL,
    stamp character varying(128) NOT NULL,
    date_created timestamp without time zone NOT NULL
);


ALTER TABLE shopply.sys_admins OWNER TO postgres;

--
-- Name: user; Type: TABLE; Schema: shopply; Owner: postgres
--

CREATE TABLE shopply."user" (
    username character varying(16) NOT NULL,
    first_name character varying(64) NOT NULL,
    middle_name character varying(64),
    last_name character varying(64) NOT NULL,
    date_of_birth date NOT NULL,
    sex boolean NOT NULL,
    email character varying(256) NOT NULL,
    phone_number character varying(128),
    password character varying(512) NOT NULL,
    stamp character varying(128) NOT NULL,
    date_joined timestamp without time zone NOT NULL,
    profile_photo_url character varying(512)[],
    is_verified boolean NOT NULL,
    verification_hash character varying(128) NOT NULL
);


ALTER TABLE shopply."user" OWNER TO postgres;

--
-- Name: user_likes_products; Type: TABLE; Schema: shopply; Owner: postgres
--

CREATE TABLE shopply.user_likes_products (
    id character varying(128) NOT NULL,
    username character varying(16) NOT NULL,
    product_id character varying(128) NOT NULL
);


ALTER TABLE shopply.user_likes_products OWNER TO postgres;

--
-- Name: vw_cart_item; Type: VIEW; Schema: shopply; Owner: postgres
--

CREATE VIEW shopply.vw_cart_item AS
 SELECT cart_item.id,
    cart_item.username,
    cart_item.product_id,
    cart_item.quantity,
    cart_item.price,
    cart_item.order_id,
    products.title
   FROM (shopply.cart_item
     JOIN shopply.products ON (((cart_item.product_id)::text = (products.id)::text)));


ALTER TABLE shopply.vw_cart_item OWNER TO postgres;

--
-- Data for Name: cart_item; Type: TABLE DATA; Schema: shopply; Owner: postgres
--

COPY shopply.cart_item (id, username, product_id, quantity, price, order_id) FROM stdin;
\.
COPY shopply.cart_item (id, username, product_id, quantity, price, order_id) FROM '$$PATH$$/3380.dat';

--
-- Data for Name: order; Type: TABLE DATA; Schema: shopply; Owner: postgres
--

COPY shopply."order" (id, amount_paid, date_ordered, username, status_id) FROM stdin;
\.
COPY shopply."order" (id, amount_paid, date_ordered, username, status_id) FROM '$$PATH$$/3381.dat';

--
-- Data for Name: order_status; Type: TABLE DATA; Schema: shopply; Owner: postgres
--

COPY shopply.order_status (id, status) FROM stdin;
\.
COPY shopply.order_status (id, status) FROM '$$PATH$$/3382.dat';

--
-- Data for Name: products; Type: TABLE DATA; Schema: shopply; Owner: postgres
--

COPY shopply.products (id, title, description, image_url, price, stock) FROM stdin;
\.
COPY shopply.products (id, title, description, image_url, price, stock) FROM '$$PATH$$/3383.dat';

--
-- Data for Name: rating; Type: TABLE DATA; Schema: shopply; Owner: postgres
--

COPY shopply.rating (id, star_rating, review, product_id) FROM stdin;
\.
COPY shopply.rating (id, star_rating, review, product_id) FROM '$$PATH$$/3384.dat';

--
-- Data for Name: star_rating; Type: TABLE DATA; Schema: shopply; Owner: postgres
--

COPY shopply.star_rating (id, stars) FROM stdin;
\.
COPY shopply.star_rating (id, stars) FROM '$$PATH$$/3385.dat';

--
-- Data for Name: sys_admins; Type: TABLE DATA; Schema: shopply; Owner: postgres
--

COPY shopply.sys_admins (username, first_name, last_name, email, phone_number, password, stamp, date_created) FROM stdin;
\.
COPY shopply.sys_admins (username, first_name, last_name, email, phone_number, password, stamp, date_created) FROM '$$PATH$$/3386.dat';

--
-- Data for Name: user; Type: TABLE DATA; Schema: shopply; Owner: postgres
--

COPY shopply."user" (username, first_name, middle_name, last_name, date_of_birth, sex, email, phone_number, password, stamp, date_joined, profile_photo_url, is_verified, verification_hash) FROM stdin;
\.
COPY shopply."user" (username, first_name, middle_name, last_name, date_of_birth, sex, email, phone_number, password, stamp, date_joined, profile_photo_url, is_verified, verification_hash) FROM '$$PATH$$/3387.dat';

--
-- Data for Name: user_likes_products; Type: TABLE DATA; Schema: shopply; Owner: postgres
--

COPY shopply.user_likes_products (id, username, product_id) FROM stdin;
\.
COPY shopply.user_likes_products (id, username, product_id) FROM '$$PATH$$/3388.dat';

--
-- Name: cart_item cart_item_pkey; Type: CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply.cart_item
    ADD CONSTRAINT cart_item_pkey PRIMARY KEY (id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: order_status order_status_pkey; Type: CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply.order_status
    ADD CONSTRAINT order_status_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: rating rating_pkey; Type: CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply.rating
    ADD CONSTRAINT rating_pkey PRIMARY KEY (id);


--
-- Name: star_rating star_rating_pkey; Type: CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply.star_rating
    ADD CONSTRAINT star_rating_pkey PRIMARY KEY (id);


--
-- Name: sys_admins sys_admins_pkey; Type: CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply.sys_admins
    ADD CONSTRAINT sys_admins_pkey PRIMARY KEY (username);


--
-- Name: user_likes_products user_likes_products_pkey; Type: CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply.user_likes_products
    ADD CONSTRAINT user_likes_products_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (username);


--
-- Name: cart_item fk_cart_item_order_item1; Type: FK CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply.cart_item
    ADD CONSTRAINT fk_cart_item_order_item1 FOREIGN KEY (order_id) REFERENCES shopply."order"(id) ON DELETE CASCADE;


--
-- Name: order fk_order_order_status1; Type: FK CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply."order"
    ADD CONSTRAINT fk_order_order_status1 FOREIGN KEY (status_id) REFERENCES shopply.order_status(id) ON DELETE CASCADE;


--
-- Name: order fk_order_user1; Type: FK CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply."order"
    ADD CONSTRAINT fk_order_user1 FOREIGN KEY (username) REFERENCES shopply."user"(username) ON DELETE CASCADE;


--
-- Name: rating fk_rating_products1; Type: FK CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply.rating
    ADD CONSTRAINT fk_rating_products1 FOREIGN KEY (product_id) REFERENCES shopply.products(id) ON DELETE CASCADE;


--
-- Name: rating fk_rating_star_rating1; Type: FK CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply.rating
    ADD CONSTRAINT fk_rating_star_rating1 FOREIGN KEY (star_rating) REFERENCES shopply.star_rating(id);


--
-- Name: cart_item fk_user_has_products_products1; Type: FK CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply.cart_item
    ADD CONSTRAINT fk_user_has_products_products1 FOREIGN KEY (product_id) REFERENCES shopply.products(id) ON DELETE CASCADE;


--
-- Name: user_likes_products fk_user_has_products_products2; Type: FK CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply.user_likes_products
    ADD CONSTRAINT fk_user_has_products_products2 FOREIGN KEY (product_id) REFERENCES shopply.products(id) ON DELETE CASCADE;


--
-- Name: cart_item fk_user_has_products_user; Type: FK CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply.cart_item
    ADD CONSTRAINT fk_user_has_products_user FOREIGN KEY (username) REFERENCES shopply."user"(username) ON DELETE CASCADE;


--
-- Name: user_likes_products fk_user_has_products_user1; Type: FK CONSTRAINT; Schema: shopply; Owner: postgres
--

ALTER TABLE ONLY shopply.user_likes_products
    ADD CONSTRAINT fk_user_has_products_user1 FOREIGN KEY (username) REFERENCES shopply."user"(username) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               