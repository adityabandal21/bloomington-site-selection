## 2026-11-09
- Problem: ModuleNotFoundError after pip install
- Cause: pip and python3 pointed to different Python installs, and macOS blocked system-wide installs
- Fix: virtual environment (python3 -m venv .venv)

- Problem: Census API returned 200 but the body was not JSON
- Cause: API redirected to a Missing Key page
- Fix: free API key stored in an environment variable. Lesson: inspect r.text before calling r.json()

- Problem: median_income mean was about -20 million
- Cause: Census placeholder codes (-666666666) mean "not available"
- Fix: convert negative values to NULL before averaging. Lesson: run describe() on raw data first

- Caveat: low-income tracts near campus likely reflect student populations, and ACS margins of error can exceed 50% of the estimate

- Spot check: 7 of 15 known coffee places found in OSM after broadening tags. Category alone is not a reliable competitor definition, so define a flag in SQL.

## 2026-11-17
- Problem: Q10 ranked rural tracts (001200, 001501) as the top coffee opportunities
- Cause: raw population rewards large land area; 001200 is 64 sq mi at 96 people/sq mi
- Fix: score on population density instead of raw population
- Lesson: cross-check model output against a second query (Q6) before trusting it

## 2026-11-21 (Excel)
- Problem: Excel formula error "The syntax of this name isn't correct"
- Cause: macOS smart quotes turned " into curly quotes
- Fix: turned off "Use smart quotes and dashes" in System Settings > Keyboard > Text Input

- Problem: typed structured references like [@pop] failed
- Fix: built formulas by clicking cells instead (=IFERROR(B2/H2,0))

- Problem: dragging the fill handle overwrote 5 columns in opportunity_scores
- Fix: Data > Refresh All reloaded the table from the CSV (the Power Query refresh test, passed by accident)

- Problem: chart plotted geoid as a data series (bars at 1.8E+10)
- Cause: geoid stored as a number, so Excel treated it as values
- Fix: Select Data, removed geoid series, set it as axis labels

- Reconciled: Excel matches SQL for Q3 (29 coffee shops), Q4, Q5 (same 7 tracts) and Q6. Only difference: Excel shows 0 where SQL shows NULL for tracts with no coffee shops
