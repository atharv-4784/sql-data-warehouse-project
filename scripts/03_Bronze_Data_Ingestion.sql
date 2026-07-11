/*==============================================================================
Purpose:
    This script loads the source CRM and ERP datasets into the Bronze layer
    of the data warehouse.

Description:
    - Truncates all existing Bronze layer tables.
    - Loads fresh data from CSV source files using PostgreSQL COPY.
    - Records the execution time for each table load.
    - Displays the total ETL execution time.

Source Systems:
    - CRM
        • cust_info.csv
        • prd_info.csv
        • sales_details.csv

    - ERP
        • CUST_AZ12.csv
        • LOC_A101.csv
        • PX_CAT_G1V2.csv

Target Schema:
    bronze
==============================================================================*/

DO $$
DECLARE
    etl_start  TIMESTAMP;
    step_start TIMESTAMP;
BEGIN

    -- =========================================================================
    -- Start Bronze Layer ETL
    -- =========================================================================
    etl_start := clock_timestamp();

    RAISE NOTICE '';
    RAISE NOTICE '=========================================================';
    RAISE NOTICE '        BRONZE LAYER DATA LOADING STARTED';
    RAISE NOTICE '=========================================================';
    RAISE NOTICE 'Start Time : %', etl_start;
    RAISE NOTICE '';

    -- =========================================================================
    -- Clear Existing Data
    -- =========================================================================
    RAISE NOTICE 'Truncating Bronze Tables...';

    TRUNCATE TABLE
        bronze.crm_customers_info,
        bronze.crm_product_info,
        bronze.crm_sales_details,
        bronze.erp_loc_a101,
        bronze.erp_cust_az12,
        bronze.erp_px_cat_g1v2;

    RAISE NOTICE 'Bronze Tables Truncated Successfully.';
    RAISE NOTICE '';

    -- =========================================================================
    -- Load CRM Customer Information
    -- =========================================================================
    step_start := clock_timestamp();

    RAISE NOTICE 'Loading bronze.crm_customers_info...';

    COPY bronze.crm_customers_info
    FROM 'C:/Users/athar/Desktop/Warehouse/Dataset/source_crm/cust_info.csv'
    DELIMITER ','
    CSV HEADER;

    RAISE NOTICE 'Completed bronze.crm_customers_info';
    RAISE NOTICE 'Execution Time : %', clock_timestamp() - step_start;
    RAISE NOTICE '';

    -- =========================================================================
    -- Load CRM Product Information
    -- =========================================================================
    step_start := clock_timestamp();

    RAISE NOTICE 'Loading bronze.crm_product_info...';

    COPY bronze.crm_product_info
    FROM 'C:/Users/athar/Desktop/Warehouse/Dataset/source_crm/prd_info.csv'
    DELIMITER ','
    CSV HEADER;

    RAISE NOTICE 'Completed bronze.crm_product_info';
    RAISE NOTICE 'Execution Time : %', clock_timestamp() - step_start;
    RAISE NOTICE '';

    -- =========================================================================
    -- Load CRM Sales Details
    -- =========================================================================
    step_start := clock_timestamp();

    RAISE NOTICE 'Loading bronze.crm_sales_details...';

    COPY bronze.crm_sales_details
    FROM 'C:/Users/athar/Desktop/Warehouse/Dataset/source_crm/sales_details.csv'
    DELIMITER ','
    CSV HEADER;

    RAISE NOTICE 'Completed bronze.crm_sales_details';
    RAISE NOTICE 'Execution Time : %', clock_timestamp() - step_start;
    RAISE NOTICE '';

    -- =========================================================================
    -- Load ERP Location Data
    -- =========================================================================
    step_start := clock_timestamp();

    RAISE NOTICE 'Loading bronze.erp_loc_a101...';

    COPY bronze.erp_loc_a101
    FROM 'C:/Users/athar/Desktop/Warehouse/Dataset/source_erp/LOC_A101.csv'
    DELIMITER ','
    CSV HEADER;

    RAISE NOTICE 'Completed bronze.erp_loc_a101';
    RAISE NOTICE 'Execution Time : %', clock_timestamp() - step_start;
    RAISE NOTICE '';

    -- =========================================================================
    -- Load ERP Customer Data
    -- =========================================================================
    step_start := clock_timestamp();

    RAISE NOTICE 'Loading bronze.erp_cust_az12...';

    COPY bronze.erp_cust_az12
    FROM 'C:/Users/athar/Desktop/Warehouse/Dataset/source_erp/CUST_AZ12.csv'
    DELIMITER ','
    CSV HEADER;

    RAISE NOTICE 'Completed bronze.erp_cust_az12';
    RAISE NOTICE 'Execution Time : %', clock_timestamp() - step_start;
    RAISE NOTICE '';

    -- =========================================================================
    -- Load ERP Product Category Data
    -- =========================================================================
    step_start := clock_timestamp();

    RAISE NOTICE 'Loading bronze.erp_px_cat_g1v2...';

    COPY bronze.erp_px_cat_g1v2
    FROM 'C:/Users/athar/Desktop/Warehouse/Dataset/source_erp/PX_CAT_G1V2.csv'
    DELIMITER ','
    CSV HEADER;

    RAISE NOTICE 'Completed bronze.erp_px_cat_g1v2';
    RAISE NOTICE 'Execution Time : %', clock_timestamp() - step_start;
    RAISE NOTICE '';

    -- =========================================================================
    -- ETL Completed
    -- =========================================================================
    RAISE NOTICE '=========================================================';
    RAISE NOTICE '        BRONZE LAYER DATA LOADING COMPLETED';
    RAISE NOTICE '=========================================================';
    RAISE NOTICE 'End Time   : %', clock_timestamp();
    RAISE NOTICE 'Total Time : %', clock_timestamp() - etl_start;
    RAISE NOTICE '=========================================================';

END $$;