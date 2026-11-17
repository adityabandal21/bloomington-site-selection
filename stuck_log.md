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
