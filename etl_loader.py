import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import quote_plus
import os
from dotenv import load_dotenv

# 1. Load the hidden password from the .env file
load_dotenv()
raw_password = os.getenv("MYSQL_PASSWORD")

if not raw_password:
    print("❌ Error: Could not find MYSQL_PASSWORD in .env file.")
    exit()

# 2. URL-Encode the password to safely handle the '@' symbol
safe_password = quote_plus(raw_password)

# 3. Connect to MySQL securely
print("Connecting to database...")
engine = create_engine(f"mysql+pymysql://root:{safe_password}@localhost/sales_db")

# 4. Extract
print("Reading the large Fact table...")
file_path = r"C:\Users\vnska\Desktop\sales_enterprise_analytics\data\raw_csv\fact_sales_monthly.csv"
df = pd.read_csv(file_path)

# 5. Transform
print("Standardizing date formats to bypass MySQL restrictions...")
df['date'] = pd.to_datetime(df['date']).dt.strftime('%Y-%m-%d')

# ADD THIS LINE RIGHT HERE:
print("Aligning column names with database schema...")
df.rename(columns={'Qty': 'sold_quantity'}, inplace=True)

# 6. Load
print("Uploading to MySQL (this may take a minute or two depending on file size)...")
df.to_sql(name='fact_sales_monthly', con=engine, if_exists='append', index=False)

print(f"✅ Success! {len(df)} rows loaded perfectly into fact_sales_monthly.")