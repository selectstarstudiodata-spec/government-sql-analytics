/*
Title: Active SNAP Cases by County (Portfolio)

Purpose:
Counts active SNAP cases by county/region using a robust "latest status row"
pattern to avoid double counting and stale participant records.

This demonstrates common public-sector reporting needs:
- effective-date logic
- selecting latest record per case/participant
- business rule documentation
- aggregation by geography

Parameters:
- :as_of_date   DATE  -- Evaluate participation as of this date (nullable)

Output:
- county_code
- active_case_count

Generalized code meanings (example):
- participation_status = 'ACTIVE'    (represents participating/eligible)
- relationship_code    = 'PRIMARY'   (represents head of household / primary member)
- program_code         = 'SNAP'

Notes:
- Table/field names are generalized for portfolio use.
- No server names, schemas, or internal environment references are included.
- If your real system uses coded values (ex: '02', '00', 4), document them here
  and translate them into readable constants in a mapping CTE.

Change Log:
- 2026-01-12 - Initial version
*/

WITH code_map AS (
    -- Translate opaque codes into readable labels (replace with your real meanings)
    SELECT 'SNAP'    AS program_code,
           'ACTIVE'  AS participation_status,
           'PRIMARY' AS relationship_code
),
latest_participant_row AS (
    SELECT
        p.case_id,
        p.participant_id,
        p.participation_status,
        p.status_success_date,
        ROW_NUMBER() OVER (
            PARTITION BY p.case_id, p.participant_id
            ORDER BY p.participant_history_id DESC
        ) AS rn
    FROM case_participant_history p
    WHERE p.status_success_date IS NOT NULL
      AND (
            :as_of_date IS NULL
            OR p.status_success_date <= :as_of_date
          )
),
active_primary_cases AS (
    SELECT DISTINCT
        l.case_id
    FROM latest_participant_row l
    JOIN case_composition c
      ON c.case_id = l.case_id
     AND c.participant_id = l.participant_id
    JOIN code_map m
      ON 1 = 1
    WHERE l.rn = 1
      AND l.participation_status = m.participation_status
      AND c.relationship_code = m.relationship_code
),
snap_cases AS (
    SELECT
        b.case_id,
        b.county_code
    FROM benefit_cases b
    JOIN code_map m
      ON 1 = 1
    WHERE b.program_code = m.program_code
      AND b.county_code IS NOT NULL
)
SELECT
    sc.county_code,
    COUNT(DISTINCT sc.case_id) AS active_case_count
FROM snap_cases sc
JOIN active_primary_cases ap
  ON ap.case_id = sc.case_id
GROUP BY sc.county_code
ORDER BY sc.county_code;
