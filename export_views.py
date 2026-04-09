import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import quote_plus
import os
from dotenv import load_dotenv

# Connect to the database
load_dotenv()
safe_password = quote_plus(os.getenv("MYSQL_PASSWORD"))
engine = create_engine(f"mysql+pymysql://root:{safe_password}@localhost/sales_db")

# The exact views we built
views_to_export = [
    "vw_clean_fact_sales",
    "dim_date",
    "dim_product",
    "dim_customer",
    "dim_market",
    "vw_quarterly_performance",
    "vw_channel_contribution",
    "vw_top_products_by_category"
]

print("Extracting Data Warehouse to Flat Files for Tableau Public...")

# Create an export folder if it doesn't exist
os.makedirs("data/dashboard_export", exist_ok=True)

# Loop through and export each view
for view in views_to_export:
    print(f"Exporting {view}...")
    df = pd.read_sql(f"SELECT * FROM {view}", engine)
    df.to_csv(f"data/dashboard_export/{view}.csv", index=False)

print("✅ Success! All views exported to data/dashboard_export/")