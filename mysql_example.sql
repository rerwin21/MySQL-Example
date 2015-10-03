use rmee_dh;



select a.store, a.week, a.day, a.Avg_Price
	from (select store, week, count(day) Days
			from carbo_transactions
			where upc = 3620000432
			group by store, week
			having count(day) > 1 
			order by store, week asc) b
	join (select store, week, day, sum(dollar_sales)/sum(units) Avg_Price, sum(units) total_units
			from carbo_transactions
			where upc = 3620000432
			group by store, week, day
			order by store, week asc) a
on concat(a.week,a.store) = concat(b.week,b.store)
	group by a.store, a.week, a.day asc;
	



# Actual Answer for 3
select c.store, c.week, c.Avg_Price, b.Max_Price, ((b.Max_Price - c.Avg_Price)/b.Max_Price) '% Diff', c.total_units

from (select store, week, sum(dollar_sales)/sum(units) Avg_Price, sum(units) total_units
			from carbo_transactions
			where upc = 3620000432
			group by store, week
			order by store, week asc) c

left outer join (select a.store, max(Avg_Price) Max_Price
				  from	(select store, week, sum(dollar_sales)/sum(units) Avg_Price, sum(units) total_units
						from carbo_transactions
						where upc = 3620000432
						group by store, week
						order by store, week asc) a
				group by a.store asc) b
on c.store = b.store
group by c.store, c.week
order by c.store, c.week asc;

###################



#### Zipcode and Geography
select c.store, c.week, c.Avg_Price, b.Max_Price, ((b.Max_Price - c.Avg_Price)/b.Max_Price) '% Diff', c.total_units, carbo_store_lookup.zipcode, c.geography

from (select store, week, sum(dollar_sales)/sum(units) Avg_Price, sum(units) total_units, geography
			from carbo_transactions
			where upc = 3620000432
			group by store, week
			order by store, week asc) c

left outer join (select a.store, max(Avg_Price) Max_Price
				  from	(select store, week, sum(dollar_sales)/sum(units) Avg_Price, sum(units) total_units
						from carbo_transactions
						where upc = 3620000432
						group by store, week
						order by store, week asc) a
				group by a.store asc) b
on c.store = b.store
join carbo_store_lookup
on carbo_store_lookup.store = c.store
group by c.store, c.week
order by c.store, c.week asc;




#### Top 10 Brands
select c.brand, c.store, c.week, c.Avg_Price, b.Max_Price, ((b.Max_Price - c.Avg_Price)/b.Max_Price) '% Diff', c.total_units, carbo_store_lookup.zipcode, c.geography

from (select brand, store, week, sum(dollar_sales)/sum(units) Avg_Price, sum(units) total_units, geography
			from carbo_transactions
			join carbo_product_lookup cp
			on cp.upc = carbo_transactions.upc
			where brand in ('Ragu','Prego','Classico','Private Label','Bertolli',"Hunt's","Newman's",'Private Label Premium',"Emeril's",'Barilla') and
				  commodity = 'pasta sauce'	
			group by brand, store, week
			order by brand, store, week asc) c

left outer join (select a.brand, a.store, max(Avg_Price) Max_Price
				  from	(select brand, store, week, sum(dollar_sales)/sum(units) Avg_Price, sum(units) total_units
						from carbo_transactions
						join carbo_product_lookup cp
						on cp.upc = carbo_transactions.upc
						where brand in ('Ragu','Prego','Classico','Private Label','Bertolli',"Hunt's","Newman's",'Private Label Premium',"Emeril's",'Barilla') and
							commodity = 'pasta sauce'	
						group by brand, store, week
						order by brand, store, week asc) a
				group by a.brand, a.store asc) b
on c.store = b.store and c.brand = b.brand
join carbo_store_lookup
on carbo_store_lookup.store = c.store
group by c.brand, c.store, c.week
order by c.brand, c.store, c.week asc;





#miscellaneous
select brand, cp.upc, store, week, sum(dollar_sales)/sum(units) Avg_Price, sum(units) total_units
						from carbo_transactions
						join carbo_product_lookup cp
						on cp.upc = carbo_transactions.upc
						where brand in ('Ragu') and
							commodity = 'pasta sauce'	
						group by brand, cp.upc, store, week
						order by brand, store, week asc;






## All Brands and UPC's
select c.brand, c.upc, c.store, c.week, c.Avg_Price, b.Max_Price, ((b.Max_Price - c.Avg_Price)/b.Max_Price) '% Diff', c.total_units, carbo_store_lookup.zipcode, c.geography

from (select brand, cp.upc, store, week, sum(dollar_sales)/sum(units) Avg_Price, sum(units) total_units, geography
			from carbo_transactions
			join carbo_product_lookup cp
			on cp.upc = carbo_transactions.upc
			where brand in ('Ragu','Prego','Classico','Private Label','Bertolli',"Hunt's","Newman's",'Private Label Premium',"Emeril's",'Barilla') and
				  commodity = 'pasta sauce'	
			group by brand, store, week
			order by brand, store, week asc) c

left outer join (select a.brand, a.upc, a.store, max(Avg_Price) Max_Price
				  from	(select brand, cp.upc, store, week, sum(dollar_sales)/sum(units) Avg_Price, sum(units) total_units
						from carbo_transactions
						join carbo_product_lookup cp
						on cp.upc = carbo_transactions.upc
						where brand in ('Ragu','Prego','Classico','Private Label','Bertolli',"Hunt's","Newman's",'Private Label Premium',"Emeril's",'Barilla') and
							commodity = 'pasta sauce'	
						group by brand, cp.upc, store, week
						order by brand, cp.upc, store, week asc) a
				group by a.brand, a.upc, a.store asc) b
on c.store = b.store and c.brand = b.brand and c.upc = b.upc
join carbo_store_lookup
on carbo_store_lookup.store = c.store
group by c.brand, c.upc, c.store, c.week
order by c.brand, c.upc, c.store, c.week asc;