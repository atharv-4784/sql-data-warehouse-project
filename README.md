# 🏗️ Modern Data Warehouse Project

An end-to-end **PostgreSQL Data Warehouse** project that demonstrates modern Data Engineering concepts, including data ingestion, ETL, data cleaning, data integration, and dimensional modeling.

The project consolidates raw business data from multiple operational systems into a centralized warehouse following the **Medallion Architecture (Bronze, Silver, and Gold)**. The final output is a business-ready **Star Schema** optimized for efficient SQL querying.

---

# 📑 Table of Contents

- Project Overview
- Project Objectives
- Project Architecture
- Source Systems
- Medallion Architecture
- ETL Pipeline
- Gold Layer Data Model
- Technologies Used
- Repository Structure
- Documentation
- Author

---

# 📌 Project Overview

Organizations often store data across multiple operational systems, making it difficult to perform unified reporting and decision-making.

This project demonstrates how raw business data from different sources can be consolidated into a centralized PostgreSQL Data Warehouse using a structured ETL process.

The project follows industry-standard Data Engineering practices, including:

- Data Ingestion
- ETL (Extract, Transform, Load)
- Data Cleaning
- Data Standardization
- Data Validation
- Data Integration
- Dimensional Modeling
- Star Schema Design
- Database Documentation

The final warehouse provides clean, consistent, and query-ready data for future reporting and business intelligence applications.

---

# 🎯 Project Objectives

The main objectives of this project are:

- Import data from multiple business systems.
- Store raw data without modification.
- Clean and standardize source data.
- Validate and transform records.
- Integrate CRM and ERP datasets.
- Build a dimensional data model.
- Create a Star Schema optimized for SQL queries.
- Document the complete data warehouse architecture.

---

# 🏛️ Project Architecture

<p align="center">
<img src="docs/images/architecture.png" width="900">
</p>

The project follows a layered ETL architecture.

```
CRM + ERP
      │
      ▼
 Bronze Layer
      │
      ▼
 Silver Layer
      │
      ▼
 Gold Layer
```

Each layer has a clearly defined responsibility, making the warehouse easier to maintain, extend, and troubleshoot.

---

# 📂 Source Systems

The warehouse integrates data from two operational systems.

<p align="center">
<img src="docs/images/source_systems.png" width="900">
</p>

## CRM System

The CRM system contains operational business information.

### Tables

- crm_cust_info
- crm_prd_info
- crm_sales_details

### Data Includes

- Customer Information
- Product Information
- Sales Transactions

---

## ERP System

The ERP system contains supporting master data.

### Tables

- erp_cust_az12
- erp_loc_a101
- erp_px_cat_g1v2

### Data Includes

- Customer Demographics
- Customer Locations
- Product Categories

The ETL process combines CRM and ERP datasets to create a unified analytical model.

---
# 🥉🥈🥇 Medallion Architecture

<p align="center">
<img src="docs/images/medallion_layers.png" width="900">
</p>

The warehouse follows the Medallion Architecture, which organizes data into three layers to improve data quality, maintainability, and scalability.

---

## Bronze Layer

### Purpose

The Bronze layer stores raw data exactly as received from the source systems.

### Characteristics

- Raw CSV data
- No transformations
- Preserves original source values
- Used for traceability and debugging

### Source

- CRM CSV Files
- ERP CSV Files

---

## Silver Layer

### Purpose

The Silver layer contains cleaned, validated, and standardized data.

### Operations Performed

- Data Cleaning
- Removing Duplicates
- Standardizing Formats
- Handling Missing Values
- Data Validation
- Type Conversion
- Data Integration

The Silver layer prepares the data for dimensional modeling.

---

## Gold Layer

### Purpose

The Gold layer contains the final dimensional model used for efficient SQL querying.

The layer consists of:

- Dimension Tables
- Fact Table
- Star Schema

The Gold layer represents the final output of the ETL pipeline.

---

# 🔄 ETL Pipeline

The warehouse is built using a traditional ETL process.

```
CSV Files
    │
    ▼
Bronze Layer
    │
    ▼
Data Cleaning
    │
    ▼
Data Validation
    │
    ▼
Data Standardization
    │
    ▼
Data Integration
    │
    ▼
Gold Layer
```

Each stage transforms the data into a cleaner and more structured format before loading it into the next layer.

---

# ⭐ Gold Layer Data Model

<p align="center">
<img src="docs/images/star_schema.png" width="900">
</p>

The Gold Layer follows a **Star Schema** consisting of:

## Dimension Tables

### dim_customers

Stores customer information enriched using data from CRM and ERP.

Contains:

- Customer Details
- Demographic Information
- Geographic Information

---

### dim_products

Stores product information together with business classifications.

Contains:

- Product Details
- Product Categories
- Product Line
- Cost Information

---

## Fact Table

### fact_sales

Stores transactional sales records.

Measures include:

- Sales Amount
- Quantity
- Price

The fact table references both dimension tables using surrogate keys.

---

# 🔗 Table Relationships

| Parent Table | Child Table | Relationship |
|--------------|-------------|--------------|
| dim_customers | fact_sales | One-to-Many |
| dim_products | fact_sales | One-to-Many |

---

# 🛠️ Technologies Used

- PostgreSQL
- SQL
- CSV Files
- ETL
- Data Warehousing
- Medallion Architecture
- Star Schema
- Git
- GitHub

---

# 📁 Repository Structure

```
sql-data-warehouse-project/
│
├── datasets/
│
├── scripts/
│   ├── bronze/
│   ├── silver/
│   └── gold/
│
├── docs/
│   ├── DATA_CATALOG.md
│   └── images/
│       ├── architecture.png
│       ├── source_systems.png
│       ├── medallion_layers.png
│       └── star_schema.png
│
├── README.md
│
└── LICENSE
```

---

# 📖 Documentation

Additional documentation for the Gold Layer tables is available in:

**📄 [DATA_CATALOG.md](docs/DATA_CATALOG.md)**

The catalog includes:

- Table Descriptions
- Column Definitions
- Source Mapping
- Business Rules
- Relationships
- Data Model

---

# 🎯 Project Highlights

- Built a PostgreSQL-based Data Warehouse
- Implemented the Medallion Architecture
- Integrated data from multiple source systems
- Designed a Star Schema using dimension and fact tables
- Applied data cleaning and standardization during ETL
- Documented the complete warehouse architecture and data model

---

# 👨‍💻 Author

**Atharv Bhore**

Computer Engineering Graduate (2026)

Interested in:

- Data Engineering
- Data Warehousing
- Database Design
- SQL Development