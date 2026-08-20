<!--====================================================================
APEXONE Enterprise Platform
Document Name : LOB_POLICY
Document Type : Engineering Standard
Module        : Database Standards
Version       : 1.0.0-alpha.1
Status        : Approved
Database      : Oracle AI Database 26ai
Schema        : APEXONE

Purpose
Defines SecureFile LOB standards.

Change History
-----------------------------------------------------------------------
Version          Date         Description
-----------------------------------------------------------------------
1.0.0-alpha.1    2026-08-04   Initial Version
=====================================================================-->

# LOB Policy

## Supported Types

- CLOB
- BLOB
- NCLOB

## Storage

Store all LOB segments in APEXONE_LOB.

## Rules

- Prefer SecureFile LOB.
- Enable compression only when beneficial.
- Enable deduplication only after testing.
- Keep LOBs outside primary table segments where practical.

## Backup

LOB tablespaces are included in every backup.

## Related Documents

- STORAGE_POLICY.md
- TABLESPACE_POLICY.md