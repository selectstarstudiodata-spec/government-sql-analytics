/*
Title: Cases Missing County/Region (Validation)

Purpose:
Identifies benefit cases that are missing county/region assignments.
This prevents undercounting or "mystery totals" in county-level reports.

Parameters:
- :program_code  VARCHAR  -- Optional (ex: 'SNAP'); NULL returns all programs

Output:
- program_code
- missing_county_case_count

Notes:
- Table/field names are generalized for portfolio use.
- In real environments, "county" might be stored as service county, region, office,
  or derived from address. Document that rule here.

Change Log:
- 2026-01-12 - Initial version
*/

SELECT
    b.program_code,
    COUNT(DISTINCT b.case_id) AS missing_county_case_count
FROM benefit_cases b
WHERE b.county_code IS NULL
  AND (
      :program_code IS NULL
      OR b.program_code = :program_code
  )
GROUP BY b.program_code
ORDER BY b.program_code;
