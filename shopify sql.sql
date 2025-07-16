create database shopify_db;

use shopify_db;

create table shopify(
Admin_Graphql_Api_Id varchar(50),
Order_Number bigint primary key,	
Billing_Address_Country	varchar(20),
Billing_Address_First_Name	varchar(50),
Billing_Address_Last_Name	varchar(50),
Billing_Address_Province	varchar(50),
Billing_Address_Zip	bigint,
CITY	varchar(50),
Currency varchar(10),
Customer_Id bigint,	
Invoice_Date datetime,
Gateway	varchar(30),
Product_Id	bigint,
Product_Type varchar(40),	
Variant_Id bigint,	
Quantity tinyint,
Subtotal_Price	mediumint,
Total_Price_Usd	mediumint,
Total_Tax mediumint
);

alter table shopify modify invoice_date date;

desc shopify;

-- truncate table shopify;

select count(*) from shopify;