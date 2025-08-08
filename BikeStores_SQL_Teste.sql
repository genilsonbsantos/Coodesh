
/*
########################################################################
#         	   			     QUERY 1  			                       
#  Listar todos Clientes que não tenham realizado uma compra;          
######################################################################## 
*/

select cus.[customer_id],[first_name],[last_name],[order_id]
From sales.customers cus
left join sales.orders ord
		On ord.customer_id = cus.customer_id
where ord.[order_id] is null

/*
########################################################################
#         	   			     QUERY 2  			                       
#  Listar os Produtos que não tenham sido comprados        
######################################################################## 
*/

/*Podemos utilizar os campos [order_status] e [shipped_date] para identificar quais produtos não efetivaram a compra */

select  pro.[product_id], pro.[product_name] 
from	production.products pro
where	pro.[product_id] 
	not in (
		select  ite.[product_id]
		from sales.order_items ite
			 join sales.orders ordOn ord.order_id = ite.order_id
			 where	  [shipped_date] is not null 
			and	  [order_status] = 4) -- Completed
 

 

 /*
########################################################################
#         	   			     QUERY 3  			                       
# Listar os Produtos sem Estoque;                                      
######################################################################## 
*/


 select sto.[store_name], pro.[product_id], pro.[product_name], cks.[quantity] 
 from  [production].[stocks] cks
 inner join production.products pro
	on cks.[product_id] = pro.[product_id] 
inner join sales.stores sto
	On cks.store_id = sto.store_id
 where cks.[quantity] =0


/*
########################################################################
#         	   			     QUERY 4  			                       
#   Agrupar a quantidade de vendas que uma determinada Marca por Loja. 
######################################################################## 
*/


 select bra.[brand_name], sto.[store_name],  
 count(distinct ord.[order_id]) as Qtde_Vendas , 
 count (ite.product_id) as Qtde_Itens_Vendidos

 From sales.orders ord
 
 inner join sales.order_items ite
	On ord.order_id = ite.order_id
 
 inner join production.products pro
	On ite.product_id = pro.product_id

 inner join production.brands bra
	ON pro.brand_id = bra.brand_id

 inner join sales.stores sto
	On ord.store_id = sto.store_id

where  ord.[shipped_date] is not null 

group by bra.[brand_name], sto.[store_name]



/*
#######################################################################
#         	   			     QUERY 5  			                       
#   Listar os Funcionarios que não estejam relacionados a um Pedido.   
######################################################################## 
*/

select sta.[staff_id], sta.[first_name], sta.[last_name]
from  sales.staffs sta
where sta.[staff_id] not in (select ord.[staff_id]  From sales.orders ord)
 
-- É possível obter o mesmo resultado utilizando duas formas diferentes de escrita da consulta, através de join ou do comando not in

select sta.[staff_id], sta.[first_name], sta.[last_name]
from  sales.staffs sta
left join sales.orders ord
on sta.[staff_id] = ord.[staff_id]
where ord.[staff_id] is null

