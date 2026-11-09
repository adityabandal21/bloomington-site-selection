import os
import requests
import pandas as pd

url = "https://api.census.gov/data/2023/acs/acs5"
vars_ = {
    "B01003_001E": "pop",
    "B19013_001E": "median_income",
    "B19013_001M": "median_income_moe",
    "B01002_001E": "median_age",
    "B25064_001E": "median_rent",
}
params = {
    "get": "NAME," + ",".join(vars_),
    "for": "tract:*",
    "in": "state:18 county:105",
    "key": os.environ["CENSUS_API_KEY"],
}
resp = requests.get(url, params=params)
print(resp.status_code, resp.headers.get("content-type"))
rows = resp.json()
df = pd.DataFrame(rows[1:], columns=rows[0]).rename(columns=vars_)
df["geoid"] = df["state"] + df["county"] + df["tract"]
df.to_csv("data/raw/acs_tracts.csv", index=False)
print(df.shape)
print(df.head())
