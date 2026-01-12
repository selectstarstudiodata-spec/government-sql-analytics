# government-sql-analytics
Portfolio-ready SQL analytics patterns for government and public-sector systems, including benefits, eligibility, and case-based reporting. Focused on correctness, documentation, and reproducibility.

# Government SQL Analytics (Portfolio)

This repository demonstrates how I approach SQL analytics in
government and public-sector environments, where correctness,
auditability, and clear business logic matter.

All queries in this repo are **sanitized and generalized**.
No real system names, credentials, or sensitive data are included.

## What this repo demonstrates
- Case-based analytics (benefits, eligibility, participation)
- “Latest record” and effective-date logic
- Longitudinal reporting across time windows
- Grouping and aggregation for operational reporting
- Clear documentation of assumptions and codes

## What this repo does NOT include
- Production server names or schemas
- PII or case-level identifiers
- Proprietary agency documentation

## Design principles
- SQL is written for correctness before performance
- Business rules are documented explicitly
- Queries are auditable and reproducible
- Logic is generalized to apply across agencies

## Quick tour
- Analytics example: `sql/analytics/active_cases_by_region.sql`
- Standards template: `sql/_TEMPLATE.sql`
