CREATE DATABASE stock_db;
CREATE SCHEMA stock;

CREATE TABLE stock.address (
    address_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 ),
    address varchar(250) NOT NULL,
    postal_code varchar(20),
    record_ts DATE DEFAULT current_date,
    CONSTRAINT address_pk PRIMARY KEY (address_id)
);

CREATE TABLE stock.stock (
    stock_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 ),
    stock_date date NOT NULL,
    stock_time time NOT NULL,
    address_id BIGINT NOT NULL REFERENCES stock.address,
    record_ts DATE DEFAULT current_date,
    CONSTRAINT stock_pk PRIMARY KEY (stock_id)
);

CREATE TABLE stock.buyer (
    buyer_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 ),
    first_name varchar(100) NOT NULL,
    last_name varchar(100) NOT NULL,
    email varchar(150) NOT NULL,
    phone varchar(20),
    gender char NOT NULL,
    address_id BIGINT NOT NULL REFERENCES stock.address,
    record_ts DATE DEFAULT current_date,
    CONSTRAINT buyer_pk PRIMARY KEY (buyer_id),
    CONSTRAINT "UNQ_buyer_email" UNIQUE (email),
    CONSTRAINT "UNQ_buyer_phone" UNIQUE (phone),
    CONSTRAINT check_buyer_gender CHECK (gender IN ('M', 'F'))
);

CREATE TABLE stock.seller (
    seller_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 ),
    first_name varchar(100) NOT NULL,
    last_name varchar(100) NOT NULL,
    email varchar(150) NOT NULL,
    phone varchar(20),
    gender char NOT NULL,
    address_id BIGINT NOT NULL REFERENCES stock.address,
    record_ts DATE DEFAULT current_date,
    CONSTRAINT seller_pk PRIMARY KEY (seller_id),
    CONSTRAINT "UNQ_seller_email" UNIQUE (email),
    CONSTRAINT "UNQ_seller_phone" UNIQUE (phone),
    CONSTRAINT check_seller_gender CHECK (gender IN ('M', 'F'))
);

CREATE TABLE stock.lot (
    lot_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 ),
    lot_number integer NOT NULL,
    record_ts DATE DEFAULT current_date,
    CONSTRAINT lot_pk PRIMARY KEY (lot_id)
);

CREATE TABLE stock.item (
    item_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 ),
    item_name varchar(250) NOT NULL,
    item_description text DEFAULT 'no description',
    item_price decimal(10,2) NOT NULL CHECK (item_price >= 0),
    seller_id BIGINT NOT NULL REFERENCES stock.seller,
    lot_id BIGINT NOT NULL REFERENCES stock.lot,
    record_ts DATE DEFAULT current_date,
    CONSTRAINT item_pk PRIMARY KEY (item_id)
);

CREATE TABLE stock.category (
    category_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 ),
    description varchar(250) DEFAULT 'there is no category',
    record_ts DATE DEFAULT current_date,
    CONSTRAINT category_pk PRIMARY KEY (category_id)
);

CREATE TABLE stock.item_category (
    item_id BIGINT NOT NULL REFERENCES stock.item,
    category_id BIGINT NOT NULL REFERENCES stock.category,
    record_ts DATE DEFAULT current_date,
    CONSTRAINT item_category_pk PRIMARY KEY (item_id, category_id)
);

CREATE TABLE stock.purchase (
    purchase_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 ),
    purchase_actual_price decimal(10,2) NOT NULL,
    buyer_id BIGINT NOT NULL REFERENCES stock.buyer,
    record_ts DATE DEFAULT current_date,
    CONSTRAINT purchase_pk PRIMARY KEY (purchase_id),
    CONSTRAINT check_price_positive CHECK (purchase_actual_price >= 0)
);

CREATE TABLE stock.purchase_method (
    purchase_method_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 ),
    description varchar(250) NOT NULL,
    purchase_id BIGINT NOT NULL REFERENCES stock.purchase,
    record_ts DATE DEFAULT current_date,
    CONSTRAINT purchase_method_pk PRIMARY KEY (purchase_method_id)
);

CREATE TABLE stock.stock_item (
    stock_id BIGINT NOT NULL REFERENCES stock.stock,
    lot_id BIGINT NOT NULL REFERENCES stock.lot,
    purchase_id BIGINT NOT NULL REFERENCES stock.purchase,
    record_ts DATE DEFAULT current_date,
    CONSTRAINT stock_item_pk PRIMARY KEY (stock_id, lot_id, purchase_id)
);

ALTER TABLE stock.stock
ADD CONSTRAINT check_date_after_2000
CHECK (stock_date > '2000-01-01');

ALTER TABLE stock.purchase
ADD CONSTRAINT check_price_positive
CHECK (purchase_actual_price >= 0);
  
ALTER TABLE stock.item
ADD CONSTRAINT check_price_positive
CHECK (item_price >= 0);
  
ALTER TABLE stock.buyer
ADD CONSTRAINT check_buyer_gender
CHECK (gender IN ('M', 'F'));
  
ALTER TABLE stock.seller
ADD CONSTRAINT check_seller_gender
CHECK (gender IN ('M', 'F'));

INSERT INTO stock.address (address, postal_code)
VALUES ('16 Main Street', '22345'),
       ('46 Wall Street', '67290'),
       ('79 Oak Street', '14321'),
       ('521 Row Avenue', '68765');

INSERT INTO stock.stock (stock_date, stock_time, address_id)
VALUES ('2024-8-29', '10:00:00', 1),
       ('2024-10-05', '14:30:00', 2);
	   
INSERT INTO stock.buyer (first_name, last_name, email, phone, gender, address_id)
VALUES ('Jim', 'Kim', 'johndoe@example.com', '1234567890', 'M', 3),
       ('Ana', 'Smoa', 'janesmith@example.com', '9876543210', 'F', 4);
	   
INSERT INTO stock.seller (first_name, last_name, email, phone, gender, address_id)
VALUES ('Sam', 'Kal', 'michaeljohnson@example.com', '5551234567', 'M', 1),
       ('Max', 'Rambo', 'emilydavis@example.com', '5559876543', 'M', 4);
	   
INSERT INTO stock.lot (lot_number)
VALUES (1),
       (2);
	   
INSERT INTO stock.item (item_name, item_description, item_price, seller_id, lot_id)
VALUES ('Iphone', '128gb/6gb/45mp/black', 100.00, 1, 1),
       ('Smart watch', 'New product of apple', 250.00, 2, 2);

INSERT INTO stock.category (description)
VALUES ('Phone'),
       ('Laptop');

INSERT INTO stock.item_category (item_id, category_id)
VALUES (1, 1),
       (2, 2);


INSERT INTO stock.purchase (purchase_actual_price, buyer_id)
VALUES (80.00, 1),
       (200.00, 2);


INSERT INTO stock.purchase_method (description, purchase_id)
VALUES ('Credit Card', 1),
       ('Cash', 2);


INSERT INTO stock.stock_item (stock_id, lot_id, purchase_id)
VALUES (1, 1, 1),
       (2, 2, 2);	
       
ALTER TABLE stock.address 
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE stock.stock 
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE stock.buyer 
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE stock.seller
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE stock.lot 
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE stock.item 
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE stock.category 
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE stock.item_category 
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE stock.purchase 
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE stock.purchase_method 
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE stock.stock_item 
ADD COLUMN record_ts DATE DEFAULT current_date;

SELECT *
FROM stock.purchase;