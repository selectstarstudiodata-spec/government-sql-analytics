# Patterns Used in This Repo (Portfolio)

Government datasets often use coded values and history tables.
These patterns are used here to keep reporting correct and auditable.

## 1) Code mapping (make logic readable)
Many systems store meanings as opaque codes (example: '02', '00', 4).
In portfolio SQL, codes are translated into readable labels using a small
mapping CTE (or a real code table in production).

Why:
- makes business rules explicit
- reduces mistakes caused by “magic numbers”
- improves maintainability and reviewability

## 2) Latest record per entity (avoid stale history)
History tables can store multiple rows per person/case over time.
To avoid counting outdated records, this repo uses:

- `ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ... DESC)`

Then filters to `rn = 1`.

Why:
- avoids correlated subqueries that are slower and harder to audit
- guarantees you are evaluating the most recent status row

## 3) Counting cases safely
When joining participants to cases, row multiplication can occur.
This repo typically uses:

- `COUNT(DISTINCT case_id)`

Why:
- prevents accidental overcounting
- preserves correctness when joins expand rows
