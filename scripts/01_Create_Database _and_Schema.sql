/*
===============================================================================
 Project      : Data Warehouse Project
 File         : init_database.sql
 Author       : Atharv Bhore
 Description  : Database initialization script for the Data Warehouse project.

 Purpose
 -------
 This script creates the initial database and schemas required for implementing
 a Medallion Architecture in PostgreSQL.

 Architecture
 ------------
 warehouse
 ├── bronze   : Raw data ingested from source systems (ERP, CRM, APIs, CSV, etc.)
 ├── silver   : Cleaned, validated, and standardized data
 └── gold     : Business-ready analytical tables (Fact & Dimension tables)

 Execution Instructions
 ----------------------
 1. Connect to the default 'postgres' database.
 2. Execute the CREATE DATABASE statement.
 3. Connect to the newly created 'warehouse' database.
 4. Execute the schema creation statements.

 Compatible With
 ---------------
 - PostgreSQL 13+
 - pgAdmin 4
 - psql

===============================================================================
*/

-- ============================================================================
-- STEP 1: Create Data Warehouse Database
-- Execute this while connected to the default 'postgres' database.
-- ============================================================================

CREATE DATABASE warehouse;

-- ============================================================================
-- STEP 2: Connect to the Warehouse Database
--
-- If using psql:
-- \c warehouse
--
-- If using pgAdmin:
-- Open a new Query Tool connected to the "warehouse" database.
-- ============================================================================


-- ============================================================================
-- STEP 3: Create Bronze Schema
-- Stores raw, unmodified data exactly as received from source systems.
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS bronze;


-- ============================================================================
-- STEP 4: Create Silver Schema
-- Stores cleaned, validated, and transformed data ready for integration.
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS silver;


-- ============================================================================
-- STEP 5: Create Gold Schema
-- Stores business-ready dimensional models (Fact & Dimension tables)
-- optimized for reporting and analytics.
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS gold;


-- ============================================================================
-- STEP 6: Verify Schema Creation
-- ============================================================================

SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('bronze', 'silver', 'gold')
ORDER BY schema_name;


-- ============================================================================
-- Database Initialization Complete
--
-- Final Structure
--
-- warehouse
-- ├── bronze
-- ├── silver
-- └── gold
--
-- Next Steps
-- 1. Load raw data into the Bronze layer.
-- 2. Transform data into the Silver layer.
-- 3. Build Star Schema tables in the Gold layer.
-- 4. Connect BI tools (Power BI, Tableau, etc.) to the Gold layer.
-- ============================================================================