/*==============================================================================
Script Name : 02_DDL_Bronze_Tables.sql

Purpose:
    This script creates all tables required for the Bronze layer
    of the data warehouse.

Description:
    - Drops existing Bronze layer tables (if they exist).
    - Creates all Bronze layer tables.
    - Displays messages indicating the progress of table creation.

Target Schema:
    bronze

Author      : Athar
Created On  : 11-Jul-2026
Database    : warehouse
==============================================================================*/

DO $$
BEGIN

    RAISE NOTICE '';
    RAISE NOTICE '=========================================================';
    RAISE NOTICE '        CREATING BRONZE LAYER TABLES';
    RAISE NOTICE '=========================================================';
    RAISE NOTICE '';

END $$;

-- ============================================================================
-- CRM Customer Information
-- ============================================================================

DROP TABLE IF EXISTS bronze.crm_customers_info;

CREATE TABLE bronze.crm_customers_info (
    cst_id              INT,
    cst_key             VARCHAR(20),
    cst_firstname       VARCHAR(50),
    cst_lastname        VARCHAR(50),
    cst_marital_status  CHAR(1),
    cst_gndr            CHAR(1),
    cst_create_date     DATE
);

DO $$ BEGIN
    RAISE NOTICE '✓ Created table : bronze.crm_customers_info';
END $$;

-- ============================================================================
-- CRM Product Information
-- ============================================================================

DROP TABLE IF EXISTS bronze.crm_product_info;

CREATE TABLE bronze.crm_product_info (
    prd_id          INT,
    prd_key         VARCHAR(50),
    prd_nm          VARCHAR(100),
    prd_cost        INT,
    prd_line        VARCHAR(10),
    prd_start_dt    DATE,
    prd_end_dt      DATE
);

DO $$ BEGIN
    RAISE NOTICE '✓ Created table : bronze.crm_product_info';
END $$;

-- ============================================================================
-- CRM Sales Details
-- ============================================================================

DROP TABLE IF EXISTS bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num     VARCHAR(50),
    sls_prd_key     VARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    INT,
    sls_ship_dt     INT,
    sls_due_dt      INT,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT
);

DO $$ BEGIN
    RAISE NOTICE '✓ Created table : bronze.crm_sales_details';
END $$;

-- ============================================================================
-- ERP Location Data
-- ============================================================================

DROP TABLE IF EXISTS bronze.erp_loc_a101;

CREATE TABLE bronze.erp_loc_a101 (
    cid     VARCHAR(50),
    cntry   VARCHAR(50)
);

DO $$ BEGIN
    RAISE NOTICE '✓ Created table : bronze.erp_loc_a101';
END $$;

-- ============================================================================
-- ERP Customer Data
-- ============================================================================

DROP TABLE IF EXISTS bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12 (
    cid     VARCHAR(50),
    bdate   DATE,
    gen     VARCHAR(50)
);

DO $$ BEGIN
    RAISE NOTICE '✓ Created table : bronze.erp_cust_az12';
END $$;

-- ============================================================================
-- ERP Product Category Data
-- ============================================================================

DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           VARCHAR(50),
    cat          VARCHAR(50),
    subcat       VARCHAR(50),
    maintenance  VARCHAR(50)
);

DO $$ BEGIN
    RAISE NOTICE '✓ Created table : bronze.erp_px_cat_g1v2';

    RAISE NOTICE '';
    RAISE NOTICE '=========================================================';
    RAISE NOTICE '      ALL BRONZE LAYER TABLES CREATED SUCCESSFULLY';
    RAISE NOTICE '=========================================================';
END $$;