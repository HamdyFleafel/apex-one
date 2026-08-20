<!--====================================================================
APEXONE Enterprise Platform
Document Name : TABLESPACE_POLICY
Document Type : Engineering Standard
Module        : Database Standards
Version       : 1.0.0-alpha.1
Status        : Approved
Database      : Oracle AI Database 26ai
Schema        : APEXONE

Purpose
Defines the official tablespace allocation policy.

Change History
-----------------------------------------------------------------------
Version          Date         Description
-----------------------------------------------------------------------
1.0.0-alpha.1    2026-08-04   Initial Version
=====================================================================-->

# Tablespace Policy

## Purpose

Defines how database objects are distributed across tablespaces.

## Standard Tablespaces

| Tablespace | Purpose |
|------------|---------|
|APEXONE_DATA|Application Tables|
|APEXONE_INDEX|Indexes|
|APEXONE_LOB|LOB Storage|
|APEXONE_AUDIT|Audit Data|
|USERS|Development Objects Only|

## Rules

- Tables must not store indexes.
- LOB columns must use APEXONE_LOB.
- Audit objects must use APEXONE_AUDIT.
- Indexes must use APEXONE_INDEX.
- AUTOEXTEND must remain enabled.
- SYSTEM and SYSAUX must never contain application objects.

## Growth Policy

- DATA Autoextend ON
- INDEX Autoextend ON
- LOB Autoextend ON
- AUDIT Autoextend ON

## Related Documents

- STORAGE_POLICY.md
- INDEX_POLICY.md
- DATABASE_STANDARDS.md