<!--====================================================================
APEXONE Enterprise Platform
Document Name : INDEX_POLICY
Document Type : Engineering Standard
Module        : Database Standards
Version       : 1.0.0-alpha.1
Status        : Approved
Database      : Oracle AI Database 26ai
Schema        : APEXONE

Purpose
Defines index creation standards.

Change History
-----------------------------------------------------------------------
Version          Date         Description
-----------------------------------------------------------------------
1.0.0-alpha.1    2026-08-04   Initial Version
=====================================================================-->

# Index Policy

## Naming

IDX_<TABLE>_<COLUMN>

## Rules

- Index foreign keys.
- Index frequently searched columns.
- Avoid duplicate indexes.
- Remove unused indexes.
- Review index statistics regularly.

## Storage

Store all indexes in APEXONE_INDEX.

## Maintenance

Rebuild fragmented indexes only when justified by monitoring.

## Related Documents

- STORAGE_POLICY.md
- TABLESPACE_POLICY.md