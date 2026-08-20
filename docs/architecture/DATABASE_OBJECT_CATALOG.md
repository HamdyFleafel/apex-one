<!--====================================================================
APEXONE Enterprise Platform
Document Name : DATABASE_OBJECT_CATALOG
Document Type : Architecture
Module        : Database Architecture
Version       : 1.0.0-alpha.1
Status        : Approved
Database      : Oracle AI Database 26ai
Schema        : APEXONE

Purpose
Provides a catalog of database objects.

Change History
-----------------------------------------------------------------------
Version          Date         Description
-----------------------------------------------------------------------
1.0.0-alpha.1    2026-08-04   Initial Version
=====================================================================-->

# Database Object Catalog

## Tables

- APP_SCHEMA_VERSION
- APP_USERS
- APP_ROLES
- APP_PERMISSIONS
- APP_ROLE_PERMISSIONS
- APP_CONFIG_GROUPS
- APP_CONFIG
- APP_NOTIFICATION_TEMPLATES
- APP_NOTIFICATIONS
- APP_WORKFLOW_DEFINITIONS
- APP_WORKFLOW_TASKS
- APP_AUDIT_LOG

## Packages

- PKG_SECURITY
- PKG_CONFIGURATION
- PKG_NOTIFICATION
- PKG_WORKFLOW
- PKG_AUDIT

## Infrastructure

- Tablespaces
- Indexes
- Constraints
- Sequences
- LOB Storage

## Verification

Objects are validated through:

- Installation scripts
- Verification scripts
- Deployment scripts
- Git version control

## Future Catalog

This document will be expanded automatically as new modules are introduced.