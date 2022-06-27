Create Database if not exists `order-directory` ;
use `order-directory`;

create table Supplier(Supplier_ID int primary key, Supplier_NAME varchar(50),Supplier_CITY varchar(50),Supplier_PHONE bigint);
create table Customer(Customer__ID int primary key, Customer_NAME varchar(50),Customer_PHONE bigint ,Customer_CITY varchar(50),Customer_GENDER varchar(50));

create table Category(Category_ID int primary key,Category_NAME varchar(50));

create table Product
(Product_ID int primary key,Product_NAME varchar(50),Product_DESC varchar(50),CAT_ID int,
foreign key (CAT_ID) references Category(Category_ID) );

create table ProductDetails(PROD_ID int,Product_ID int,SUPP_ID int ,PRICE int,
foreign key (PROD_ID) references Product(Product_ID),
foreign key (SUPP_ID) references Supplier(Supplier_ID));

create table Orders(ORD_ID int,ORD_AMOUNT int,ORD_DATE date,CUS_ID int ,PROD_ID int,
foreign key (CUS_ID) references Customer (Customer__ID),
foreign key (PROD_ID) references Product(Product_ID)
);

create table Rating(RAT_ID int,CUS_ID int ,SUPP_ID int,RAT_RATSTARS int,
foreign key (CUS_ID) references Customer (Customer__ID),
foreign key (SUPP_ID) references Supplier(Supplier_ID)
);


insert into Supplier values(1, "Rajesh Retails","Delhi", 1234567890);
insert into Supplier values(2, "Appario Ltd.","Mumbai", 2589631470);
insert into Supplier values(3, "Knome products","Banglore", 9785462315);
insert into Supplier values(4, "Bansal Retails","Kochi", 8975463285);
insert into Supplier values(5, "Mittal Ltd.","Lucknow", 7898456532);


insert into Customer values(1, "AAKASH",9999999999 , "DELHI", "M");
insert into Customer values(2, "AMAN",9785463215 , "NOIDA", "M");
insert into Customer values(3, "NEHA",9999999999 , "MUMBAI", "F");
insert into Customer values(4, "MEGHA",9994562399 , "KOLKATA", "F");
insert into Customer values(5, "PULKIT",7895999999 , "7895999999", "M");


insert into Category values(1, "BOOKS");
insert into Category values(2, "GAMES");
insert into Category values(3, "GROCERIES");
insert into Category values(4, "ELECTRONICS");
insert into Category values(5, "CLOTHES");

insert into product values(1, "GTA V", "DFJDJFDJFDJFDJFJF", 2);
insert into product values(2, "TSHIRT", "DFDFJDFJDKFD", 5);
insert into product values(3, "ROG LAPTOP", "DFNTTNTNTERND", 4);
insert into product values(4, "OATS", "REURENTBTOTH", 3);
insert into product values(5, "HARRY POTTER", "NBEMCTHTJTH", 1);

insert into ProductDetails values(1,1,2,1500);
insert into ProductDetails values(2,3,5,30000);
insert into ProductDetails values(3,5,1,3000);
insert into ProductDetails values(4,2,3,2500);
insert into ProductDetails values(5,4,1,1000);

insert into orders values(20,1500,'2021-10-12',3,5);
insert into orders values(25,30500,'2021-09-16',5,2);
insert into orders values(26,2000,'2021-10-05',1,1);
insert into orders values(30,3500,'2021-08-16',4,3);
insert into orders values(50,2000,'2021-10-06',2,1);

insert into Rating values(1,2,2,4);
insert into Rating values(2,3,4,3);
insert into Rating values(3,5,1,5);
insert into Rating values(4,1,3,2);
insert into Rating values(5,4,5,4);

select customer.cus_gender,count(customer.cus_gender) as count from customer inner join `order` on customer.cus_id=`order`.cus_id where `order`.ord_amount>=3000 group by customer.cus_gender;

select `order`.*,product.pro_name from `order` ,product_details,product where `order`.cus_id=2 and `order`.prod_id=product_details.prod_id and product_details.prod_id=product.pro_id;

select supplier.* from supplier,product_details where supplier.supp_id in (select product_details.supp_id from product_details group by product_details.supp_id having count(product_details.supp_id)>1) group by supplier.supp_id;


select category.* from `order` inner join product_details on `order`.prod_id=product_details.prod_id inner join product on product.pro_id=product_details.pro_id inner join category on category.cat_id=product.cat_id having min(`order`.ord_amount);

select product.pro_id,product.pro_name from `order` inner join product_details on product_details.prod_id=`order`.prod_id inner join product on product.pro_id=product_details.pro_id where `order`.ord_date>"2021-10-05";

select supplier.supp_id,supplier.supp_name,customer.cus_name,rating.rat_ratstars from rating inner join supplier on rating.supp_id=supplier.supp_id inner join customer on rating.cus_id=customer.cus_id order by rating.rat_ratstars desc limit 3;

select customer.cus_name ,customer.cus_gender from customer where customer.cus_name like 'A%' or customer.cus_name like '%A';


select sum(`order`.ord_amount) as Amount from `order` inner join customer on `order`.cus_id=customer.cus_id where customer.cus_gender='M';


select *  from customer left outer join `order` on customer.cus_id=`order`.cus_id; 


DELIMITER &&  
CREATE PROCEDURE proc()
BEGIN
select supplier.supp_id,supplier.supp_name,rating.rat_ratstars,
CASE
    WHEN rating.rat_ratstars >4 THEN 'Genuine Supplier'
    WHEN rating.rat_ratstars>2 THEN 'Average Supplier'
    ELSE 'Supplier should not be considered'
END AS verdict from rating inner join supplier on supplier.supp_id=rating.supp_id;
END &&  
DELIMITER ;  
call proc();