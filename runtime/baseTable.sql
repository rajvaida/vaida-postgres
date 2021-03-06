CREATE TABLE paypaldata ( 
    record_id    serial PRIMARY KEY, 
	record_stamp timestamp default current_timestamp, 
    product_csv  text, 
    contact_id   varchar(40), 
    pp_string	 text NOT NULL, 
	pp_respo	 text NOT NULL, 
    pp_amount    double precision, 
	order_amount double precision 
); 

GRANT ALL on paypaldata TO Clipper;
GRANT ALL on paypaldata TO postgres;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public to Clipper;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public to postgres;
