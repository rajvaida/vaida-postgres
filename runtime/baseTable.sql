CREATE TABLE paypaldata ( 
    record_id    serial PRIMARY KEY, 
	record_stamp timestamp NOT NULL, 
    order_number varchar(40), 
    contact_id   varchar(40) NOT NULL, 
    pp_string	 varchar(500) NOT NULL, 
	pp_respo	 varchar(500) NOT NULL, 
    pp_amount    double precision, 
	order_amount double precision 
); 