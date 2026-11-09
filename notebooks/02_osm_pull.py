import time
import requests
import pandas as pd

BBOX = "39.10,-86.62,39.23,-86.43"
NAME = "coffee|cafe|caf\u00e9|roast|espresso|bakery|donut|doughnut"
query = f"""
[out:json][timeout:90];
(
  nwr["amenity"~"^(cafe|restaurant|fast_food|ice_cream)$"]({BBOX});
  nwr["shop"~"^(coffee|bakery|confectionery|tea)$"]({BBOX});
  nwr["cuisine"="coffee_shop"]({BBOX});
  nwr["amenity"]["name"~"{NAME}",i]({BBOX});
  nwr["shop"]["name"~"{NAME}",i]({BBOX});
  nwr["leisure"="fitness_centre"]({BBOX});
);
out center;
"""

servers = [
    "https://overpass-api.de/api/interpreter",
    "https://overpass.private.coffee/api/interpreter",
]
headers = {"User-Agent": "bloomington-site-selection-learning-project"}

data = None
for attempt in range(4):
    url = servers[attempt % len(servers)]
    r = requests.post(url, data={"data": query}, headers=headers)
    print(attempt, url, r.status_code, r.headers.get("content-type"))
    if r.status_code == 200 and "json" in r.headers.get("content-type", ""):
        data = r.json()
        break
    print("body:", r.text[:300])
    time.sleep(20)

if data is None:
    raise SystemExit("All attempts failed. Wait a few minutes and rerun.")

recs = []
for e in data["elements"]:
    tags = e.get("tags", {})
    recs.append({
        "osm_id": e["id"],
        "type": e["type"],
        "name": tags.get("name"),
        "amenity": tags.get("amenity"),
        "shop": tags.get("shop"),
        "leisure": tags.get("leisure"),
        "cuisine": tags.get("cuisine"),
        "category": tags.get("amenity") or tags.get("shop") or tags.get("leisure") or "other",
        "lat": e.get("lat") or e.get("center", {}).get("lat"),
        "lon": e.get("lon") or e.get("center", {}).get("lon"),
    })
df = pd.DataFrame(recs).drop_duplicates(subset=["type", "osm_id"])
df.to_csv("data/raw/pois.csv", index=False)
print(df.shape)
print(df["category"].value_counts())
