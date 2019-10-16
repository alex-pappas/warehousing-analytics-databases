import pandas as pd
import sqlalchemy as sql

# 1. Extract

db = sql.create_engine("postgresql://postgres@localhost/alex")

# Create dataframes from data tables
employee_id = pd.read_sql_table("employee_id", db)
office_info = pd.read_sql_table("office_info", db)
product_inventory = pd.read_sql_table("product_inventory", db)
production = pd.read_sql_table("production", db)
order_log = pd.read_sql_table("order_log", db)
customers = pd.read_sql_table("customers", db)

# 2. Transform

# Create fact table
df_1 = pd.merge(employee_id['employee_number','office_code'], office_info['office_code','city'], on ='office_code')
df_2 = pd.merge(df_1, customers['customer_number','credit_limit','sales_rep_employee_number'], on = 'sales_rep_employee_number')
df_3 = pd.merge(df_2, order_log, on = 'customer_number')
df_4 = pd.merge(df_3, production, on = 'product_code')
fact_table = pd.merge(df_4, product_inventory[['product_code','quantity_in_stock']], on = 'product_code')
fact_table.drop(columns = ['orders_id','status','comments','product_scale','product_vendor'])

# Create new columns
fact_table['revenue'] = fact_table['quantity_ordered']*fact_table['price_each']
fact_table['profit'] = fact_table['quantity_ordered']*(fact_table['price_each']-fact_table['buy_price'])
fact_table['margin'] = fact_table['profit']/(fact_table['quantity_ordered']*fact_table['price_each'])
fact_table['day'] = fact_table['order_date'].dt.dayofweek
fact_table['quarter'] = fact_table['order_date'].dt.quarter

# Dimension tables
employee_logs = pd.merge(employee_id,office_info[['reports_to','office_code']], on = 'office_code')
employee_logs.drop('office_code')

office_logs = office_info.drop('reports_to')

order_logs = order_log.drop(columns=['orders_id','customer_number','product_code','order_line_number','quantity_ordered','price_each'])

customer_logs = customers.drop(columns=['orders_id','sales_rep_employee_number','credit_limit'])

product_logs = pd.merge(product_inventory, production, on = 'product_code')
product_logs.drop(columns=['quantity_in_stock','_m_s_r_p','buy_price'])

# 3. Load

# Load the new database
db = sql.create_engine("postgresql://postgres@localhost/star")
fact_table.to_sql('fact_table', db, if_exists = 'append', index = False)
employee_logs.to_sql('employee_logs', db, if_exists = 'append', index = False)
office_logs.to_sql('office_logs', db, if_exists = 'append', index = False)
customer_logs.to_sql('customer_logs', db, if_exists = 'append', index = False)
order_logs.to_sql('order_logs', db, if_exists = 'append', index = False)
product_logs.to_sql('product_logs', db, if_exists = 'append', index = False)
