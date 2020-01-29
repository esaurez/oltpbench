-- TODO: c_since ON UPDATE CURRENT_TIMESTAMP,

DROP TABLE IF EXISTS order_line1;
CREATE TABLE order_line1 (
  ol_w_id int NOT NULL,
  ol_d_id int NOT NULL,
  ol_o_id int NOT NULL,
  ol_number int NOT NULL,
  ol_i_id int NOT NULL,
  ol_delivery_d timestamp NULL DEFAULT NULL,
  ol_amount decimal(6,2) NOT NULL,
  ol_supply_w_id int NOT NULL,
  ol_quantity decimal(2,0) NOT NULL,
  ol_dist_info char(24) NOT NULL,
  PRIMARY KEY (ol_w_id,ol_d_id,ol_o_id,ol_number)
);

DROP TABLE IF EXISTS new_order1;
CREATE TABLE new_order1 (
  no_w_id int NOT NULL,
  no_d_id int NOT NULL,
  no_o_id int NOT NULL,
  PRIMARY KEY (no_w_id,no_d_id,no_o_id)
);

DROP TABLE IF EXISTS stock1;
CREATE TABLE stock1 (
  s_w_id int NOT NULL,
  s_i_id int NOT NULL,
  s_quantity decimal(4,0) NOT NULL,
  s_ytd decimal(8,2) NOT NULL,
  s_order_cnt int NOT NULL,
  s_remote_cnt int NOT NULL,
  s_data varchar(50) NOT NULL,
  s_dist_01 char(24) NOT NULL,
  s_dist_02 char(24) NOT NULL,
  s_dist_03 char(24) NOT NULL,
  s_dist_04 char(24) NOT NULL,
  s_dist_05 char(24) NOT NULL,
  s_dist_06 char(24) NOT NULL,
  s_dist_07 char(24) NOT NULL,
  s_dist_08 char(24) NOT NULL,
  s_dist_09 char(24) NOT NULL,
  s_dist_10 char(24) NOT NULL,
  PRIMARY KEY (s_w_id,s_i_id)
);

-- TODO: o_entry_d  ON UPDATE CURRENT_TIMESTAMP
DROP TABLE IF EXISTS oorder1;
CREATE TABLE oorder1 (
  o_w_id int NOT NULL,
  o_d_id int NOT NULL,
  o_id int NOT NULL,
  o_c_id int NOT NULL,
  o_carrier_id int DEFAULT NULL,
  o_ol_cnt decimal(2,0) NOT NULL,
  o_all_local decimal(1,0) NOT NULL,
  o_entry_d timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (o_w_id,o_d_id,o_id),
  UNIQUE (o_w_id,o_d_id,o_c_id,o_id)
);

-- TODO: h_date ON UPDATE CURRENT_TIMESTAMP
DROP TABLE IF EXISTS history1;
CREATE TABLE history1 (
  h_c_id int NOT NULL,
  h_c_d_id int NOT NULL,
  h_c_w_id int NOT NULL,
  h_d_id int NOT NULL,
  h_w_id int NOT NULL,
  h_date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  h_amount decimal(6,2) NOT NULL,
  h_data varchar(24) NOT NULL
);

DROP TABLE IF EXISTS customer1;
CREATE TABLE customer1 (
  c_w_id int NOT NULL,
  c_d_id int NOT NULL,
  c_id int NOT NULL,
  c_discount decimal(4,4) NOT NULL,
  c_credit char(2) NOT NULL,
  c_last varchar(16) NOT NULL,
  c_first varchar(16) NOT NULL,
  c_credit_lim decimal(12,2) NOT NULL,
  c_balance decimal(12,2) NOT NULL,
  c_ytd_payment float NOT NULL,
  c_payment_cnt int NOT NULL,
  c_delivery_cnt int NOT NULL,
  c_street_1 varchar(20) NOT NULL,
  c_street_2 varchar(20) NOT NULL,
  c_city varchar(20) NOT NULL,
  c_state char(2) NOT NULL,
  c_zip char(9) NOT NULL,
  c_phone char(16) NOT NULL,
  c_since timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  c_middle char(2) NOT NULL,
  c_data varchar(500) NOT NULL,
  PRIMARY KEY (c_w_id,c_d_id,c_id)
);

DROP TABLE IF EXISTS district1;
CREATE TABLE district1 (
  d_w_id int NOT NULL,
  d_id int NOT NULL,
  d_ytd decimal(12,2) NOT NULL,
  d_tax decimal(4,4) NOT NULL,
  d_next_o_id int NOT NULL,
  d_name varchar(10) NOT NULL,
  d_street_1 varchar(20) NOT NULL,
  d_street_2 varchar(20) NOT NULL,
  d_city varchar(20) NOT NULL,
  d_state char(2) NOT NULL,
  d_zip char(9) NOT NULL,
  PRIMARY KEY (d_w_id,d_id)
);


DROP TABLE IF EXISTS item1;
CREATE TABLE item1 (
  i_id int NOT NULL,
  i_name varchar(24) NOT NULL,
  i_price decimal(5,2) NOT NULL,
  i_data varchar(50) NOT NULL,
  i_im_id int NOT NULL,
  PRIMARY KEY (i_id)
);

DROP TABLE IF EXISTS warehouse1;
CREATE TABLE warehouse1 (
  w_id int NOT NULL,
  w_ytd decimal(12,2) NOT NULL,
  w_tax decimal(4,4) NOT NULL,
  w_name varchar(10) NOT NULL,
  w_street_1 varchar(20) NOT NULL,
  w_street_2 varchar(20) NOT NULL,
  w_city varchar(20) NOT NULL,
  w_state char(2) NOT NULL,
  w_zip char(9) NOT NULL,
  PRIMARY KEY (w_id)
);


--add constraints and indexes
CREATE INDEX idx_customer1_name ON customer1 (c_w_id,c_d_id,c_last,c_first);
CREATE INDEX idx_order1 ON oorder1 (o_w_id,o_d_id,o_c_id,o_id);
-- tpcc-mysql create two indexes for the foreign key constraints, Is it really necessary?
-- CREATE INDEX FKEY_STOCK_2 ON STOCK (S_I_ID);
-- CREATE INDEX FKEY_ORDER_LINE_2 ON ORDER_LINE (OL_SUPPLY_W_ID,OL_I_ID);

--add 'ON DELETE CASCADE'  to clear table work correctly

ALTER TABLE district1  ADD CONSTRAINT fkey_district1_1 FOREIGN KEY(d_w_id) REFERENCES warehouse1(w_id) ON DELETE CASCADE;
ALTER TABLE customer1 ADD CONSTRAINT fkey_customer1_1 FOREIGN KEY(c_w_id,c_d_id) REFERENCES district1(d_w_id,d_id)  ON DELETE CASCADE ;
ALTER TABLE history1  ADD CONSTRAINT fkey_history1_1 FOREIGN KEY(h_c_w_id,h_c_d_id,h_c_id) REFERENCES customer1(c_w_id,c_d_id,c_id) ON DELETE CASCADE;
ALTER TABLE history1  ADD CONSTRAINT fkey_history1_2 FOREIGN KEY(h_w_id,h_d_id) REFERENCES district1(d_w_id,d_id) ON DELETE CASCADE;
ALTER TABLE new_order1 ADD CONSTRAINT fkey_new_order1_1 FOREIGN KEY(no_w_id,no_d_id,no_o_id) REFERENCES oorder1(o_w_id,o_d_id,o_id) ON DELETE CASCADE;
ALTER TABLE oorder1 ADD CONSTRAINT fkey_order1_1 FOREIGN KEY(o_w_id,o_d_id,o_c_id) REFERENCES customer1(c_w_id,c_d_id,c_id) ON DELETE CASCADE;
ALTER TABLE order_line1 ADD CONSTRAINT fkey_order_line1_1 FOREIGN KEY(ol_w_id,ol_d_id,ol_o_id) REFERENCES oorder1(o_w_id,o_d_id,o_id) ON DELETE CASCADE;
ALTER TABLE order_line1 ADD CONSTRAINT fkey_order_line1_2 FOREIGN KEY(ol_supply_w_id,ol_i_id) REFERENCES stock1(s_w_id,s_i_id) ON DELETE CASCADE;
ALTER TABLE stock1 ADD CONSTRAINT fkey_stock1_1 FOREIGN KEY(s_w_id) REFERENCES warehouse1(w_id) ON DELETE CASCADE;
ALTER TABLE stock1 ADD CONSTRAINT fkey_stock1_2 FOREIGN KEY(s_i_id) REFERENCES item1(i_id) ON DELETE CASCADE;

