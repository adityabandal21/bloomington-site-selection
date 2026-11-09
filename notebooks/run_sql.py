import sys
import duckdb

con = duckdb.connect("bloom.duckdb")
con.execute("INSTALL spatial; LOAD spatial;")
con.execute(open(sys.argv[1]).read())
print("ran", sys.argv[1])
