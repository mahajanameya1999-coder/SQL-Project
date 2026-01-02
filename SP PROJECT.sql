--  PROJECT FOR STORED PROCEDURE


create database stored_procedure_1;
use stored_procedure_1;

create table customers
(
customerId int primary key auto_increment,
name varchar(100),
email varchar(100)
);

insert into customers (name, email) values 
("ALICE JOHNSON", "alice@example.com"),
("BOB SMITH","bob@example.com"),
("CHARLIE BROWN", "charlie@example.com");


create table orders
( orderid int primary key auto_increment ,
customerid int,
orderdate date,
foreign key (customerid) references customers (customerid)
);

insert into orders (customerid, orderdate) values 
(1,"2024-03-01"),
(2,"2024-03-05"),
(1,"2024-03-10");


create table orderdetails
( orderdetailid int primary key auto_increment,
orderid int,
productname varchar(100),
quantity int ,
price decimal (10,2),
foreign key (orderid) references orders(orderid)
);


insert into orderdetails ( orderid, productname, quantity, price) values
( 1,"LAPTOP",1,1200.00),
(1, "MOUSE",2,25.00),
(2,"KEYBOARD",1,100.00),
( 3, "MONITOR",1,300.00),
(3, "MOUSE PAD", 1, 15.00);

select * from customers;
select * from orders;
select * from orderdetails;
drop procedure if exists getcustomerorders;
delimiter $
    create procedure getcustomerorders(customerid int)
    begin 
    
    select 
    c.customerid, name,
    o.orderid,  o.orderdate,
    productname,quantity,price
    from 
    customers c join orders o on c.customerid = o.customerid
    join orderdetails od on od.orderid = o.orderid
    
    where od.orderid = customerid;
    end $
    delimiter ;


call getcustomerorders(1);

-- ques 2 

delimiter $
create procedure getordersinrange (date1 date, date2 date)
begin
 select c.name ,o.orderid, o.orderdate, sum(od.price)
 from customers c inner join orders o on c.customerid = o.customerid
 inner join orderdetails od on o.orderid = od.orderid
 group by c.name ,o.orderid, o.orderdate
 having o.orderdate between "2024-03-05" and "2024-03-10" ;
 end $
 delimiter ; 
 

call getordersinrange("2024-03-05","2024-03-10");

-- ques 3 
-- n number of customers


delimiter $

create procedure gettopspendingcustomers( n int)
begin 

select 

    c.customerid, sum(od.price)
    from 
    customers c join orders o on c.customerid = o.customerid
    join orderdetails od on od.orderid = o.orderid
    group by c.customerid order by sum(od.price) desc
    limit n;
    
    end $
    delimiter ;
call gettopspendingcustomers(2);


-- question 4 

delimiter $
create procedure getcustomerlastorder (customerid int)
begin
SELECT MAX(O.ORDERDATE) -- SUM(OD.QUANTITY * OD.PRICE) AS TOTAL_AMOUNT, O.ORDERID, O.ORDERDATE
 FROM CUSTOMERS C 
INNER JOIN ORDERS O ON C.CUSTOMERID = O.CUSTOMERID
GROUP BY C.CUSTOMERID
HAVING C.CUSTOMERID = customerid ;

select orderid, orderdate from orders
where customerid =  customerid;

select c.customerid, sum(od.quantity * od.price) as total_amount from orderdetails od
join orders o on od.orderid = o.orderid
join customers c on o.customerid = c.customerid
group by  c.customerid
having c.customerid = customerid;
end $
delimiter ;
 
 drop procedure getcustomerlastorder;
 
 call getcustomerlastorder (1);
 drop procedure getcustomerlastorder;
 call getcustomerlastorder(1);
 drop procedure getcustomerlastorder;
 
 -- question 5
 
 select * from orderdetails;
 
 delimiter $
  create procedure getproductsales ( productname1 varchar (100))
 begin 
 select quantity , price * quantity as revenue
 from orderdetails
 where productname = productname1;
 end $
 delimiter ;
 
 call getproductsales (mouse);
 drop procedure getproductsales;
 call getproductsales ("mouse");
 call getproductsales ("mouse pad");