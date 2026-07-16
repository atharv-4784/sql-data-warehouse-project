# 📖 Data Catalog

---

# Overview

The Gold Layer contains business-ready analytical tables built using a Star Schema.

It consists of:

- Customer Dimension
- Product Dimension
- Sales Fact

---

# Gold Layer Data Model

<p align="center">
<img src="images/star_schema.png" width="850">
</p>

---

# Data Flow

<p align="center">
<img src="images/architecture.png" width="850">
</p>

---

# 1. gold.dim_customers

Stores enriched customer information.

| Column | Description |
|----------|------------|
| customer_key | Surrogate Primary Key |
| customer_id | Customer ID from CRM |
| customer_number | Business Customer Number |
| first_name | First Name |
| last_name | Last Name |
| country | Customer Country |
| marital_status | Married / Single |
| gender | Male / Female |
| birthdate | Customer Birthdate |
| create_date | Record Creation Date |

---

Business Notes

- Birthdate comes from ERP
- Country comes from ERP
- Customer profile comes from CRM

---

# 2. gold.dim_products

Stores business product information.

| Column | Description |
|----------|------------|
| product_key | Surrogate Key |
| product_id | Product ID |
| product_number | Business Product Number |
| product_name | Product Name |
| category_id | Category Identifier |
| category | Product Category |
| subcategory | Product Subcategory |
| maintenance_required | Yes / No |
| cost | Product Cost |
| product_line | Product Line |
| start_date | Product Availability Date |

---

Business Notes

- Category information originates from ERP.
- Product information originates from CRM.

---

# 3. gold.fact_sales

Contains transactional sales records.

| Column | Description |
|----------|------------|
| order_number | Sales Order Number |
| product_key | FK → dim_products |
| customer_key | FK → dim_customers |
| order_date | Order Date |
| shipping_date | Shipping Date |
| due_date | Due Date |
| sales_amount | Total Sales |
| quantity | Quantity Sold |
| price | Unit Price |

---

Business Rule

```
Sales Amount = Quantity × Price
```

---

# Star Schema Relationships

| Parent | Child | Relationship |
|---------|-------|--------------|
| dim_customers | fact_sales | One-to-Many |
| dim_products | fact_sales | One-to-Many |

---

# Source Mapping

<p align="center">
<img src="images/source_systems.png" width="850">
</p>

---

# Medallion Architecture

<p align="center">
<img src="images/medallion_layers.png" width="900">
</p>

---

# Table Summary

| Table | Type | Purpose |
|---------|------|----------|
| dim_customers | Dimension | Customer Analytics |
| dim_products | Dimension | Product Analytics |
| fact_sales | Fact | Sales Analytics |

---

# Analytical Use Cases

The Gold Layer supports:

- Sales Reporting
- Product Performance
- Customer Analysis
- Revenue Trends
- Country-wise Sales
- Product Category Analysis
- Customer Segmentation
- Dashboard Development
- Business Intelligence