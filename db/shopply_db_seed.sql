-- -----------------------------------------------------
-- Schema shopply
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table "shopply"."products"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "shopply"."products" (
  "id" VARCHAR(128) NOT NULL,
  "title" VARCHAR(128) NOT NULL,
  "description" VARCHAR(4096) NULL,
  "image_url" VARCHAR(512) NULL,
  "price" FLOAT NOT NULL,
  "stock" INT NOT NULL,
  PRIMARY KEY ("id"));


-- -----------------------------------------------------
-- Table "shopply"."user"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "shopply"."user" (
  "username" VARCHAR(16) NOT NULL,
  "first_name" VARCHAR(64) NOT NULL,
  "middle_name" VARCHAR(64) NULL,
  "last_name" VARCHAR(64) NOT NULL,
  "date_of_birth" TIMESTAMP NOT NULL,
  "sex" BOOLEAN NOT NULL,
  "email" VARCHAR(256) NOT NULL,
  "phone_number" VARCHAR(128) NULL,
  "password" VARCHAR(512) NOT NULL,
  "stamp" VARCHAR(128) NOT NULL,
  "date_joined" TIMESTAMP NOT NULL,
  "profile_photo_url" VARCHAR(512) NULL,
  "is_verified" BOOLEAN NOT NULL,
  "verification_hash" VARCHAR(128) NOT NULL,
  PRIMARY KEY ("username"));

-- -----------------------------------------------------
-- Table "shopply"."order_status"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "shopply"."order_status" (
  "id" INT NOT NULL,
  "status" VARCHAR(64) NOT NULL,
  PRIMARY KEY ("id"));

-- -----------------------------------------------------
-- Table "shopply"."order"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "shopply"."order" (
  "id" VARCHAR(128) NOT NULL,
  "amount_paid" FLOAT NOT NULL,
  "date_ordered" TIMESTAMP NOT NULL,
  "username" VARCHAR(16) NOT NULL,
  "status_id" INT NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_order_user1"
    FOREIGN KEY ("username")
    REFERENCES "shopply"."user" ("username")
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT "fk_order_order_status1"
    FOREIGN KEY ("status_id")
    REFERENCES "shopply"."order_status" ("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table "shopply"."cart_item"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "shopply"."cart_item" (
  "id" VARCHAR(128) NOT NULL,
  "username" VARCHAR(16) NOT NULL,
  "product_id" VARCHAR(128) NOT NULL,
  "quantity" INT NOT NULL,
  "price" FLOAT NOT NULL,
  "order_id" VARCHAR(128) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_user_has_products_user"
    FOREIGN KEY ("username")
    REFERENCES "shopply"."user" ("username")
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT "fk_user_has_products_products1"
    FOREIGN KEY ("product_id")
    REFERENCES "shopply"."products" ("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT "fk_cart_item_order_item1"
    FOREIGN KEY ("order_id")
    REFERENCES "shopply"."order" ("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table "shopply"."user_likes_products"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "shopply"."user_likes_products" (
  "id" VARCHAR(128) NOT NULL,
  "username" VARCHAR(16) NOT NULL,
  "product_id" VARCHAR(128) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_user_has_products_user1"
    FOREIGN KEY ("username")
    REFERENCES "shopply"."user" ("username")
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT "fk_user_has_products_products2"
    FOREIGN KEY ("product_id")
    REFERENCES "shopply"."products" ("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table "shopply"."star_rating"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "shopply"."star_rating" (
  "id" INT NOT NULL,
  "stars" INT NOT NULL,
  PRIMARY KEY ("id"));


-- -----------------------------------------------------
-- Table "shopply"."rating"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "shopply"."rating" (
  "id" VARCHAR(128) NOT NULL,
  "star_rating" INT NOT NULL,
  "review" VARCHAR(4096) NULL,
  "product_id" VARCHAR(128) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_rating_star_rating1"
    FOREIGN KEY ("star_rating")
    REFERENCES "shopply"."star_rating" ("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT "fk_rating_products1"
    FOREIGN KEY ("product_id")
    REFERENCES "shopply"."products" ("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION);


CREATE TABLE IF NOT EXISTS "shopply"."sys_admins" (
  "username" VARCHAR(16) NOT NULL,
  "first_name" VARCHAR(64) NOT NULL,
  "last_name" VARCHAR(64) NOT NULL,
  "email" VARCHAR(256) NOT NULL,
  "phone_number" VARCHAR(128) NOT NULL,
  "password" VARCHAR(512) NOT NULL,
  "stamp" VARCHAR(128) NOT NULL,
  "date_created" TIMESTAMP NOT NULL,
  PRIMARY KEY ("username"));

-- View: shopply.vw_cart_item

-- DROP VIEW shopply.vw_cart_item;

CREATE OR REPLACE VIEW shopply.vw_cart_item
 AS
 SELECT cart_item.id,
    cart_item.username,
    cart_item.product_id,
    cart_item.quantity,
    cart_item.price,
    cart_item.order_id,
    products.title
   FROM shopply.cart_item
     JOIN shopply.products ON cart_item.product_id::text = products.id::text;

CREATE OR REPLACE FUNCTION shopply.fn_liked_products(
	in_username character varying)
    RETURNS TABLE
    (
      id character varying, 
      title character varying, 
      "description" character varying, 
      "imageUrl" character varying, 
      price double precision, 
      stock integer, 
      liked boolean
    ) 
    LANGUAGE 'plpgsql'

AS $BODY$
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
$BODY$;

     