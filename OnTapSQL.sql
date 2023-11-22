use demo2007;
-- mức 1
-- In ra các sản phẩm có số lượng từ 30 trở lên.
select * from product 
where quantity >= 30;
-- In ra các sản phẩm có số lượng từ 30 trở lên và có giá trong khoảng 100 đến 200.
select * from product
where quantity >= 30 and (price between 100 and 200); 
-- In ra thông tin khách hàng tuổi lớn hơn 18
select * from customer 
where age > 18;
-- In ra thông tin khách hàng họ Nguyễn và lớn hơn 20 tuổi
select * from customer
where name like "Nguyễn%" and age >20;
-- In ra sản phẩm tên bắt đầu bằng chữ M
select * from product
where name like "M%";
-- In ra sản phẩm kết thúc bằng chữ E
select * from product
where name like "%E";
-- In ra danh sách sản phẩm số lượng tăng dần
select * from product
order by quantity;
-- In ra danh sách sản phẩm giá giảm dần
select * from product
order by quantity DESC;
-- mức 2
-- In ra tổng số lượng sản phẩm giá nhỏ hơn 300
select sum(quantity) from product 
where price <= 300;
-- In tổng số sản phẩm theo từng giá
select price,sum(quantity) from product
group by price;
-- In ra sản phẩm có giá cao nhất
select * from product
where price = (select max(price) from product);
-- In ra giá trung bình của tất cả các sản phẩm
select avg(price) from product;
-- In ra tổng số tiền nếu bán hết tất cả sản phẩm.
select sum(orderdetail.quantity * product.price) from orderdetail
join product on orderdetail.productId = product.id;
-- Tính tổng số tiền của các sản phẩm giá <300.
select sum(price) from product
where price < 300;
-- Tìm giá bán cao nhất của các sản phẩm bắt đầu bằng chữ M.
select * from product
where price = ( select max(price) from product) and name like "M%";
-- Tìm giá bán thấp nhất của các sản phẩm bắt đầu bằng chữ M.
select * from product
where price = ( select min(price) from product) and name like"M%";
-- Tìm giá bán trung bình của các sản phẩm bắt đầu bằng chữ M.
select avg(price) from product
where name like"M%";
-- mức 3
create table category(
id int primary key auto_increment, 
name varchar(255)
);

insert into category(name)
values("Đồ gia dụng"),
("Đồ điện tử");

alter table product
add foreign key (idCategory)  REFERENCES category (id);
 
update product set idCategory = 2 where id = 7;
SET SQL_SAFE_UPDATES = 0;
-- 1.In ra tên khách hàng và thời gian mua hàng.
select customer.name, orders.time from orders
join customer on orders.customerId = customer.id;
-- 2.In ra tên khách hàng và tên sản phẩm đã mua
select customer.name, product.name from orderdetail
join orders on orderdetail.orderId=orders.id
join customer on orders.customerId=customer.id
join product on orderdetail.productId=product.id;
-- 3.In ra tổng số lượng sản phẩm từng loại
select category.name, sum(quantity) from product
join category on category.id = product.idCategory
group by category.name;
-- 4.Đếm số mặt hàng từng loại
select category.name,count(idCategory) from category
join product on product.idCategory=category.id
group by category.id; 
-- 5.Tính giá trung bình tất cả các sản phẩm
select avg(price) from product;
-- 6.Tính giá trung bình từng loại
select category.name, avg(price) from product
join category on category.id = product.idCategory
group by category.name;
-- 7.Tìm sản phẩm có giá lớn nhất theo từng loại
select product.name,price from product
join category on category.id = product.idCategory
where price=(select max(price) from product);
-- 8.Tính tuổi trung bình của các khách hàng
select avg(age) from customer;
-- 9.Đếm số khách hàng tuổi lớn hơn 30
select count(age) from customer
where age > 30;
-- 10.Đếm số lần mua hàng của từng khách hàng
select customer.name,count(orders.id) from orders
 join customer on orders.customerId=customer.id
 group by customer.id;
-- 11.Đếm số lượng hóa đơn theo từng tháng
select month(time) as month,count(*) as quantity
from orders 
group by month;
-- 12.In ra mã hoá đơn và giá trị hoá đơn
select orderdetail.orderId, orderdetail.quantity * product.price as total from orderdetail
join product on orderdetail.productId=product.id;
-- 13.In ra mã hoá đơn và giá trị hoá đơn giảm dần
select orderdetail.orderId, orderdetail.quantity * product.price as total from orderdetail
join product on orderdetail.productId=product.id
order by total desc;
-- 14.Tính tổng tiền từng khách hàng đã mua
select customer.name, sum(orderdetail.quantity * product.price) as total from orders
join orderdetail on orders.id=orderdetail.orderId
join product on orderdetail.productId=product.id
join customer on customer.id= orders.customerId
group by customer.name;

-- mức 4
-- 1.In ra các mã hóa đơn, trị giá hóa đơn bán ra trong ngày 19/6/2006 và ngày 20/6/2006.
select orderdetail.orderId, orderdetail.quantity * product.price from orderdetail
join orders on orderdetail.orderId=orders.id
join product on orderdetail.productId=product.id
where orders.time between "2006-06-19" and "2006-06-20";

-- 2.In ra các mã hóa đơn, trị giá hóa đơn trong tháng 6/2006, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).
select orderdetail.orderId, orderdetail.quantity * product.price as total from orderdetail
join orders on orderdetail.orderId=orders.id
join product on orderdetail.productId=product.id
where DATE_FORMAT(orders.time, '%Y-%m') = '2006-06'
order by orders.time and total desc;

-- 4.In ra danh sách các sản phẩm (MASP, TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.
select product.id, product.name from orderdetail
join orders on orderdetail.orderId=orders.id
join product on orderdetail.productId=product.id
join customer on customer.id=orders.customerId
where customer.name = "Nguyen Van A" AND DATE_FORMAT(orders.time, '%Y-%m') = '2006-10';

-- 5.Tìm các số hóa đơn đã mua sản phẩm “Máy giặt” hoặc “Tủ lạnh”.
select ord.orderId from orderdetail ord
join product p on ord.productId=p.id
where name like "Máy giặt%" or name like "Tủ lạnh%";

-- 6.In ra danh sách các sản phẩm (MASP, TENSP) không bán được.
select product.id, product.name from orderdetail
right join product on orderdetail.productId=product.id
where orderdetail.productId is null;

-- 7.In ra danh sách các sản phẩm (MASP, TENSP) không bán được trong năm 2006.
select product.id, product.name from orderdetail
right join product on orderdetail.productId=product.id
left join orders on orderdetail.orderId=orders.id
where orderdetail.productId is null
and (DATE_FORMAT(orders.time, '%Y') = '2006') is null;

-- 8.In ra danh sách các sản phẩm (MASP, TENSP) có giá >300 sản xuất bán được trong năm 2006.
select p.id, p.name, count(*) from orderdetail ord
join product p on ord.productId=p.id
join orders o on ord.orderId=o.id
where price > 300 and DATE_FORMAT(o.time, '%Y') = '2006'
group by p.id;

-- 9.Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
select count(distinct p.id) as total from product p
join orderdetail ord on p.id=ord.productId
join orders o on ord.orderId=o.id
where DATE_FORMAT(o.time, '%Y') = '2006';

-- 10.Tìm các số hóa đơn đã mua sản phẩm “Máy giặt” hoặc “Tủ lạnh”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
select * from orderdetail ord
join product p on ord.productId=p.id
where (p.name like "Máy giặt%" or p.name like "Tủ lạnh%")
and  (ord.quantity between 10 and 20);

-- 11.Tìm các số hóa đơn mua cùng lúc 2 sản phẩm “Máy giặt” và “Tủ lạnh”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
select ord.orderId from orderdetail ord
join product p on ord.productId=p.id
where (p.name like "Máy giặt%" or p.name like "Tủ lạnh%")
and  (ord.quantity between 10 and 20)
group by ord.orderId
having count(distinct p.name)=2;

-- 12.Tìm số hóa đơn đã mua tất cả các sản phẩm có giá >200.
select ord.orderId from orderdetail ord
join product p on ord.productId=p.id
where price > 200
group by ord.orderId;

select od.id, od.time
From orders od
JOIN orderDetail ord
ON od.id = ord.orderId
JOIN product p
ON ord.productId = p.id
where od.id NOT IN (select od.id
From orders od
JOIN orderDetail ord
ON od.id = ord.orderId
JOIN product p
ON ord.productId = p.id
WHERE p.price < 200)
group by od.id;

-- 13.Tìm số hóa đơn trong năm 2006 đã mua tất cả các sản phẩm có giá <300.
select * from orderdetail ord
join product p on ord.productId=p.id
join orders o on ord.orderId=o.id
where price <300 and DATE_FORMAT(o.time, '%Y') = '2006';

-- 15.Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?
select  max(ord.quantity * p.price) as max,min(ord.quantity * p.price) as min from orderdetail ord
join product p on ord.productId=p.id;

-- 16.Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
select avg(ord.quantity * p.price) from orderdetail ord
join product p on ord.productId=p.id
join orders o on ord.orderId=o.id
where DATE_FORMAT(o.time, '%Y') = '2006'; 

-- 17.Tính doanh thu bán hàng trong năm 2006
select sum(ord.quantity * p.price) from orderdetail ord
join product p on ord.productId=p.id
join orders o on ord.orderId=o.id
where DATE_FORMAT(o.time, '%Y') = '2006'; 

-- 18.Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
select ord.orderId,max(ord.quantity * p.price) as max from orderdetail ord
join product p on ord.productId=p.id
join orders o on ord.orderId=o.id
where DATE_FORMAT(o.time, '%Y') = '2006'
group by ord.orderId
order by max desc
limit 1; 

-- 19.Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
select c.name,ord.orderId,max(ord.quantity * p.price) as max from orderdetail ord
join product p on ord.productId=p.id
join orders o on ord.orderId=o.id
join customer c on o.customerId=c.id
where DATE_FORMAT(o.time, '%Y') = '2006'
group by ord.orderId
order by max desc
limit 1; 

-- 20.In ra danh sách 3 khách hàng (MAKH, HOTEN) mua nhiều hàng nhất (tính theo số lượng).
select c.name,c.id, max(ord.quantity) as max from orders o
join orderdetail ord on o.id=ord.orderId
join product p on ord.productId=p.id
join customer c on c.id= o.customerId
group by c.id
order by max desc
limit 3;

-- 21.In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
select p.price,p.id,p.name from product p
group by p.id
order by p.price desc
limit 3;

-- 22.In ra danh sách các sản phẩm (MASP, TENSP) có tên bắt đầu bằng chữ M, có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
select p.id,p.name from product p
where name like "M%"
group by p.id
order by p.price desc
limit 3;

-- 23.Tính doanh thu bán hàng mỗi ngày.
select o.time,sum(ord.quantity * p.price) as total from orders o
join orderdetail ord on o.id=ord.orderId
join product p on ord.productId=p.id
group by o.time;

-- 24.Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
select p.id,sum(ord.quantity) from orderdetail ord 
join orders o on ord.orderId=o.id
join product p on ord.productId=p.id
where DATE_FORMAT(o.time, '%Y-%m') = '2006-10'
group by p.id;

-- 25.Tính doanh thu bán hàng của từng tháng trong năm 2006.
select month(o.time),sum(ord.quantity * p.price) as total from orders o
join orderdetail ord on o.id=ord.orderId
join product p on ord.productId=p.id
where DATE_FORMAT(o.time, '%Y') = '2006'
group by month(o.time);

-- 26.Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
select ord.orderId from orderdetail ord
join product p on ord.productId=p.id
group by ord.orderId
having count(distinct ord.productId) >= 4;

-- 27.Tìm hóa đơn có mua 3 sản phẩm có giá <300 (3 sản phẩm khác nhau).
select ord.orderId from orderdetail ord
join product p on ord.productId=p.id
group by ord.orderId
having count(distinct ord.productId) >= 3 and max(p.price) <300;

-- 28.Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
select c.id, c.name, count(ord.orderId) as max from orderdetail ord
join orders o on ord.orderId=o.id
join customer c on o.customerId=c.id
group by c.id
order by max desc
limit 1;

-- 29.Tháng mấy trong năm 2006, doanh số bán hàng cao nhất?
select month(o.time),sum(ord.quantity * p.price) as total from orders o
join orderdetail ord on o.id=ord.orderId
join product p on ord.productId=p.id
where DATE_FORMAT(o.time, '%Y') = '2006'
group by month(o.time)
order by month(o.time) desc
limit 1;

-- 30.Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
select p.id,p.name, sum(ord.quantity) as sum from orderdetail ord
join product p on ord.productId=p.id
join orders o on ord.orderId=o.id
where DATE_FORMAT(o.time, '%Y') = '2006'
group by p.id
order by sum
limit 1;

-- 31.Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
select customer.name, sum(orderdetail.quantity * product.price) as total from orders
join orderdetail on orders.id=orderdetail.orderId
join product on orderdetail.productId=product.id
join customer on customer.id= orders.customerId
group by customer.name
order by total desc
limit 1;
