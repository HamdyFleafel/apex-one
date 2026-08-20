<!--====================================================================
APEXONE Enterprise Platform
Document Name : STORAGE_POLICY
Document Type : Engineering Standard
Module        : Database Standards
Version       : 1.0.0-alpha.1
Status        : Approved
Database      : Oracle AI Database 26ai
Schema        : APEXONE

Purpose
Defines storage allocation standards.

Change History
-----------------------------------------------------------------------
Version          Date         Description
-----------------------------------------------------------------------
1.0.0-alpha.1    2026-08-04   Initial Version
=====================================================================-->

# Storage Policy

## Data Storage

- Business tables use APEXONE_DATA.
- Audit tables use APEXONE_AUDIT.

## Index Storage

- All indexes use APEXONE_INDEX.

## LOB Storage

- SecureFile LOB preferred.
- Store LOBs in APEXONE_LOB.

## Autoextend

Enabled for all application tablespaces.

## Compression

Enable only after performance validation.

## Large Objects

Separate from table segments whenever possible.

## Related Documents

- TABLESPACE_POLICY.md
- LOB_POLICY.md