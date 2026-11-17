import sys
import duckdb

con = duckdb.connect("bloom.duckdb", read_only=True)
con.execute("LOAD spatial")
print(con.sql(open(sys.argv[1]).read()).df().to_string())
