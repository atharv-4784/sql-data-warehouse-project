/*
===============================================================================
Script Name : load_silver.sql
Description :
Loads all Silver layer tables from Bronze.

Author : Atharv Bhore
===============================================================================
*/

CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$

BEGIN

    ----------------------------------------------------------------------------
    -- Start Loading Silver Layer
    ----------------------------------------------------------------------------

    RAISE NOTICE '============================================================';
    RAISE NOTICE 'Loading Silver Layer';
    RAISE NOTICE 'Started At : %', CURRENT_TIMESTAMP;
    RAISE NOTICE '============================================================';


    ----------------------------------------------------------------------------
    -- Load CRM Customer Information
    ----------------------------------------------------------------------------

    RAISE NOTICE 'Loading Table : silver.crm_customers_info';

    TRUNCATE TABLE silver.crm_customers_info;

    INSERT INTO silver.crm_customers_info
    (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,
        cst_create_date,
        dwh_create_date
    )

    WITH latest_customer AS
    (
        SELECT *,
               ROW_NUMBER() OVER
               (
                    PARTITION BY cst_id
                    ORDER BY cst_create_date DESC
               ) AS flag_last

        FROM bronze.crm_customers_info
    )

    SELECT

        cst_id,

        cst_key,

        TRIM(cst_firstname),

        TRIM(cst_lastname),

        CASE
            WHEN UPPER(TRIM(cst_marital_status))='S' THEN 'Single'
            WHEN UPPER(TRIM(cst_marital_status))='M' THEN 'Married'
            ELSE 'NA'
        END,

        CASE
            WHEN UPPER(TRIM(cst_gndr))='M' THEN 'Male'
            WHEN UPPER(TRIM(cst_gndr))='F' THEN 'Female'
            ELSE 'NA'
        END,

        cst_create_date,

        CURRENT_TIMESTAMP

    FROM latest_customer

    WHERE flag_last = 1;

    RAISE NOTICE 'Completed : silver.crm_customers_info';
	    ----------------------------------------------------------------------------
    -- Load CRM Product Information
    ----------------------------------------------------------------------------

    RAISE NOTICE 'Loading Table : silver.crm_product_info';

    TRUNCATE TABLE silver.crm_product_info;

    INSERT INTO silver.crm_product_info
    (
        prd_id,
        cst_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )

    SELECT

        prd_id,

        REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cst_id,

        SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key,

        prd_nm,

        COALESCE(prd_cost,0) AS prd_cost,

        CASE
            WHEN UPPER(TRIM(prd_line))='M' THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line))='R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line))='S' THEN 'Other'
            WHEN UPPER(TRIM(prd_line))='T' THEN 'Touring'
            ELSE 'NA'
        END AS prd_line,

        CAST(prd_start_dt AS DATE),

        CAST(
            LEAD(prd_start_dt)
            OVER(
                PARTITION BY prd_key
                ORDER BY prd_start_dt
            ) AS DATE
        ) AS prd_end_dt

    FROM bronze.crm_product_info;

    RAISE NOTICE 'Completed : silver.crm_product_info';


    ----------------------------------------------------------------------------
    -- Load CRM Sales Details
    ----------------------------------------------------------------------------

    RAISE NOTICE 'Loading Table : silver.crm_sales_details';

    TRUNCATE TABLE silver.crm_sales_details;

    INSERT INTO silver.crm_sales_details
    (
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_price,
        sls_quantity,
        sls_sales
    )

    SELECT

        sls_ord_num,

        sls_prd_key,

        sls_cust_id,

        CASE
            WHEN sls_order_dt = 0
                 OR LENGTH(sls_order_dt::TEXT) <> 8
            THEN NULL
            ELSE TO_DATE(sls_order_dt::TEXT,'YYYYMMDD')
        END,

        CASE
            WHEN sls_ship_dt = 0
                 OR LENGTH(sls_ship_dt::TEXT) <> 8
            THEN NULL
            ELSE TO_DATE(sls_ship_dt::TEXT,'YYYYMMDD')
        END,

        CASE
            WHEN sls_due_dt = 0
                 OR LENGTH(sls_due_dt::TEXT) <> 8
            THEN NULL
            ELSE TO_DATE(sls_due_dt::TEXT,'YYYYMMDD')
        END,

        CASE
            WHEN sls_price IS NULL
                 OR sls_price <= 0
            THEN sls_sales / NULLIF(sls_quantity,0)
            ELSE sls_price
        END,

        sls_quantity,

        CASE
            WHEN sls_sales IS NULL
                 OR sls_sales <= 0
                 OR sls_sales <> sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
        END

    FROM bronze.crm_sales_details;

    RAISE NOTICE 'Completed : silver.crm_sales_details';

	    ----------------------------------------------------------------------------
    -- Load ERP Customer Information
    ----------------------------------------------------------------------------

    RAISE NOTICE 'Loading Table : silver.erp_cust_az12';

    TRUNCATE TABLE silver.erp_cust_az12;

    INSERT INTO silver.erp_cust_az12
    (
        cid,
        bdate,
        gen
    )

    SELECT

        CASE
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4)
            ELSE cid
        END,

        CASE
            WHEN bdate > CURRENT_DATE THEN NULL
            ELSE bdate
        END,

        CASE
            WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
            ELSE gen
        END

    FROM bronze.erp_cust_az12;

    RAISE NOTICE 'Completed : silver.erp_cust_az12';


    ----------------------------------------------------------------------------
    -- Load ERP Location Information
    ----------------------------------------------------------------------------

    RAISE NOTICE 'Loading Table : silver.erp_loc_a101';

    TRUNCATE TABLE silver.erp_loc_a101;

    INSERT INTO silver.erp_loc_a101
    (
        cid,
        cntry
    )

    SELECT

        REPLACE(cid,'-',''),

        CASE
            WHEN TRIM(cntry)='DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
            WHEN TRIM(cntry)='' OR cntry IS NULL THEN 'N/A'
            ELSE TRIM(cntry)
        END

    FROM bronze.erp_loc_a101;

    RAISE NOTICE 'Completed : silver.erp_loc_a101';


    ----------------------------------------------------------------------------
    -- Load ERP Product Categories
    ----------------------------------------------------------------------------

    RAISE NOTICE 'Loading Table : silver.erp_px_cat_g1v2';

    TRUNCATE TABLE silver.erp_px_cat_g1v2;

    INSERT INTO silver.erp_px_cat_g1v2
    (
        id,
        cat,
        subcat,
        maintenance
    )

    SELECT
        id,
        cat,
        subcat,
        maintenance
    FROM bronze.erp_px_cat_g1v2;

    RAISE NOTICE 'Completed : silver.erp_px_cat_g1v2';


    ----------------------------------------------------------------------------
    -- Load Completed
    ----------------------------------------------------------------------------

    RAISE NOTICE '============================================================';
    RAISE NOTICE 'Silver Layer Loaded Successfully';
    RAISE NOTICE 'Completed At : %', CURRENT_TIMESTAMP;
    RAISE NOTICE '============================================================';

EXCEPTION
    WHEN OTHERS THEN

        RAISE NOTICE '==============================================';
        RAISE NOTICE 'ERROR OCCURRED';
        RAISE NOTICE 'Error Message : %', SQLERRM;
        RAISE NOTICE '==============================================';

        RAISE;

END;
$$;

CALL silver.load_silver();