# 📖 Data Catalog

This document describes the structure of the **Gold Layer** in the PostgreSQL Data Warehouse.

The Gold Layer contains cleaned, integrated, and business-ready datasets created from the Bronze and Silver layers. The data model follows a **Star Schema** design, making it simple to query while maintaining clear relationships between dimension and fact tables.

---

# 📑 Table of Contents

- Overview
- Gold Layer Architecture
- Star Schema
- Gold Layer Tables
- dim_customers
- dim_products
- fact_sales
- Relationships
- Source Mapping
- Business Rules
- Notes

---

# 📌 Overview

The Data Warehouse is organized using the **Medallion Architecture**, where data progresses through three logical layers:

| Layer | Purpose |
|--------|---------|
| Bronze | Stores raw source data without modification |
| Silver | Cleanses, validates, and standardizes the data |
| Gold | Stores the final dimensional model for efficient SQL queries |

This document focuses only on the **Gold Layer**.

---

# 🏛️ Gold Layer Architecture

<p align="center">
<img src="images/architecture.png" width="900">
</p>

The ETL workflow transforms operational data into a structured warehouse.

```
CSV Files

↓

Bronze Layer

↓

Silver Layer

↓

Gold Layer
```

---

# ⭐ Star Schema

<p align="center">
<img src="images/star_schema.png" width="900">
</p>

The Gold Layer follows a Star Schema consisting of:

- Customer Dimension
- Product Dimension
- Sales Fact

This design minimizes redundancy while simplifying SQL queries.

---

# 📂 Gold Layer Tables

| Schema | Table | Type | Description |
|---------|-------|------|-------------|
| gold | dim_customers | Dimension | Stores customer information enriched from multiple source systems. |
| gold | dim_products | Dimension | Stores product information and business attributes. |
| gold | fact_sales | Fact | Stores sales transactions linked to customer and product dimensions. |

---

# 👤 gold.dim_customers

## Purpose

The **dim_customers** table stores descriptive customer information collected from both CRM and ERP systems.

It serves as the customer dimension for the Star Schema.

---

## Columns

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| customer_key | INTEGER | Surrogate primary key. |
| customer_id | INTEGER | Customer identifier from the source system. |
| customer_number | VARCHAR | Business customer number. |
| first_name | VARCHAR | Customer first name. |
| last_name | VARCHAR | Customer last name. |
| country | VARCHAR | Customer country. |
| marital_status | VARCHAR | Customer marital status. |
| gender | VARCHAR | Customer gender. |
| birthdate | DATE | Customer birth date. |
| create_date | DATE | Date the customer record was created. |

---

## Source Mapping

| Source Table | Information Used |
|--------------|------------------|
| crm_cust_info | Customer details |
| erp_cust_az12 | Birthdate |
| erp_loc_a101 | Country |

---

## Business Rules

- Customer information from multiple source systems is merged into a single record.
- Customer names are standardized.
- Gender values are normalized.
- Country names are standardized.
- Duplicate customer records are removed before loading into the Gold layer.

---
# 📦 gold.dim_products

## Purpose

The **dim_products** table stores descriptive product information enriched with category and product hierarchy data.

It serves as the product dimension within the Star Schema.

---

## Columns

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| product_key | INTEGER | Surrogate primary key. |
| product_id | INTEGER | Product identifier from the source system. |
| product_number | VARCHAR | Business product number. |
| product_name | VARCHAR | Product name. |
| category_id | VARCHAR | Product category identifier. |
| category | VARCHAR | Product category. |
| subcategory | VARCHAR | Product subcategory. |
| maintenance_required | VARCHAR | Indicates whether maintenance is required. |
| cost | NUMERIC | Product cost. |
| product_line | VARCHAR | Product line. |
| start_date | DATE | Product availability date. |

---

## Source Mapping

| Source Table | Information Used |
|--------------|------------------|
| crm_prd_info | Product details |
| erp_px_cat_g1v2 | Category and subcategory information |

---

## Business Rules

- Product information is standardized before loading.
- Category information is merged from ERP.
- Product hierarchy is preserved.
- Missing values are handled during the Silver layer transformation.

---

# 💰 gold.fact_sales

## Purpose

The **fact_sales** table stores transactional sales records.

Each record represents a sales transaction and references the customer and product dimension tables using surrogate keys.

---

## Columns

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| order_number | VARCHAR | Sales order number. |
| product_key | INTEGER | Foreign key referencing **dim_products**. |
| customer_key | INTEGER | Foreign key referencing **dim_customers**. |
| order_date | DATE | Order date. |
| shipping_date | DATE | Shipping date. |
| due_date | DATE | Due date. |
| sales_amount | NUMERIC | Total sales amount. |
| quantity | INTEGER | Quantity sold. |
| price | NUMERIC | Unit selling price. |

---

## Source Mapping

| Source Table | Information Used |
|--------------|------------------|
| crm_sales_details | Sales transactions |

---

## Business Rules

- Each row represents a single sales transaction.
- Customer and product references use surrogate keys.
- Records with missing dimension references are excluded during ETL.
- Date fields are converted to a standard date format.
- Numeric values are validated before loading.

---

# 🔗 Table Relationships

| Parent Table | Primary Key | Child Table | Foreign Key | Relationship |
|--------------|-------------|-------------|-------------|--------------|
| gold.dim_customers | customer_key | gold.fact_sales | customer_key | One-to-Many |
| gold.dim_products | product_key | gold.fact_sales | product_key | One-to-Many |

---

# 🔄 Source Systems

<p align="center">
<img src="images/source_systems.png" width="900">
</p>

The warehouse integrates data from two independent operational systems.

## CRM

Provides:

- Customer Information
- Product Information
- Sales Transactions

## ERP

Provides:

- Customer Demographics
- Customer Locations
- Product Categories

The ETL process combines these datasets into a unified dimensional model.

---

# 🥉🥈🥇 Medallion Architecture

<p align="center">
<img src="images/medallion_layers.png" width="900">
</p>

The project follows the Medallion Architecture.

| Layer | Purpose |
|--------|---------|
| Bronze | Raw data imported from source systems |
| Silver | Cleaned, validated, and standardized data |
| Gold | Final dimensional model optimized for SQL queries |

---

# 📋 Gold Layer Summary

| Table | Type | Purpose |
|--------|------|---------|
| dim_customers | Dimension | Stores customer information |
| dim_products | Dimension | Stores product information |
| fact_sales | Fact | Stores sales transactions |

---

# 📌 Notes

- The Gold Layer follows a **Star Schema** design.
- Dimension tables contain descriptive business attributes.
- The fact table stores measurable business events.
- Surrogate keys are used to maintain relationships between dimension and fact tables.
- The data model is optimized for efficient SQL querying.
- The warehouse is designed to be extensible, allowing additional dimensions and fact tables to be added in the future.