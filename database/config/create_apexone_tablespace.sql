-- =====================================================
-- APEXONE Enterprise Platform
-- Database Storage Foundation
-- Script: create_apexone_tablespace.sql
-- Version: V001
-- =====================================================

CREATE TABLESPACE APEXONE_DATA
DATAFILE 'D:\ORACLE\DB\ORADATA\FREE\APEXONE_DATA01.DBF'
SIZE 200M
AUTOEXTEND ON
NEXT 100M
MAXSIZE 8G;

ALTER DATABASE DEFAULT TABLESPACE APEXONE_DATA;