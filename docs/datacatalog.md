# Data Catalog

## Overview

The **Gold Layer** represents the business-ready data model of the data warehouse. It contains cleaned, transformed, and analytics-optimized data organized into **dimension** and **fact** tables following a **Star Schema** design.

### Tables

| Schema | Table | Type | Description |
|--------|-------|------|-------------|
| gold | dim_customers | Dimension | Stores customer information enriched with demographic and geographic attributes. |
| gold | dim_products | Dimension | Stores product information and business attributes. |
| gold | fact_sales | Fact | Stores transactional sales data linked to customer and product dimensions. |

---

# 1. gold.dim_customers

### Purpose
Stores customer details enriched with demographic and geographic information.

## Columns

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| customer_key | INT | Surrogate key uniquely identifying each customer record in the dimension table. |
| customer_id | INT | Original customer identifier from the source system. |
| customer_number | NVARCHAR(50) | Business identifier assigned to the customer. |
| first_name | NVARCHAR(50) | Customer's first name. |
| last_name | NVARCHAR(50) | Customer's last name. |
| country | NVARCHAR(50) | Country where the customer resides. |
| marital_status | NVARCHAR(50) | Customer's marital status (e.g., Married, Single). |
| gender | NVARCHAR(50) | Customer gender (e.g., Male, Female, n/a). |
| birthdate | DATE | Customer's date of birth. |
| create_date | DATE | Date when the customer record was created in the source system. |

---

# 2. gold.dim_products

### Purpose
Stores product information along with business attributes used for reporting and analysis.

## Columns

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| product_key | INT | Surrogate key uniquely identifying each product record in the dimension table. |
| product_id | INT | Original product identifier from the source system. |
| product_number | NVARCHAR(50) | Business identifier assigned to the product. |
| product_name | NVARCHAR(50) | Descriptive name of the product. |
| category_id | NVARCHAR(50) | Identifier representing the product category. |
| category | NVARCHAR(50) | High-level product category (e.g., Bikes, Components). |
| subcategory | NVARCHAR(50) | Detailed product classification within a category. |
| maintenance_required | NVARCHAR(50) | Indicates whether the product requires maintenance (Yes/No). |
| cost | INT | Base cost of the product. |
| product_line | NVARCHAR(50) | Product line or series to which the product belongs. |
| start_date | DATE | Date when the product became available for sale. |

---

# 3. gold.fact_sales

### Purpose
Stores transactional sales data used for analytical reporting and business intelligence.

## Columns

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| order_number | NVARCHAR(50) | Unique identifier assigned to each sales order. |
| product_key | INT | Foreign key referencing **gold.dim_products**. |
| customer_key | INT | Foreign key referencing **gold.dim_customers**. |
| order_date | DATE | Date when the order was placed. |
| shipping_date | DATE | Date when the order was shipped. |
| due_date | DATE | Payment due date for the order. |
| sales_amount | INT | Total sales amount for the order line. |
| quantity | INT | Number of units sold. |
| price | INT | Selling price per unit. |

---

# Data Model

The Gold Layer follows a **Star Schema**.

```
                    +----------------------+
                    |   dim_customers      |
                    +----------------------+
                    | customer_key (PK)    |
                    | customer_id          |
                    | first_name           |
                    | last_name            |
                    | country              |
                    | ...                  |
                    +----------+-----------+
                               |
                               |
                               |
+----------------------+       |       +----------------------+
|   dim_products       |       |       |     fact_sales       |
+----------------------+       |       +----------------------+
| product_key (PK)     |<------+------>| product_key (FK)     |
| product_id           |               | customer_key (FK)    |
| product_name         |               | order_number         |
| category             |               | order_date           |
| subcategory          |               | shipping_date        |
| cost                 |               | due_date             |
| ...                  |               | quantity             |
+----------------------+               | price                |
                                       | sales_amount         |
                                       +----------------------+
```

## Relationships

| Parent Table | Primary Key | Child Table | Foreign Key | Relationship |
|--------------|-------------|-------------|-------------|--------------|
| gold.dim_customers | customer_key | gold.fact_sales | customer_key | One-to-Many |
| gold.dim_products | product_key | gold.fact_sales | product_key | One-to-Many |

---

# Notes

- The **Gold Layer** is designed for reporting, dashboards, and business analytics.
- **Dimension tables** store descriptive attributes.
- **Fact tables** store measurable business events.
- Surrogate keys (`customer_key`, `product_key`) are used to improve performance and maintain historical consistency.
- The model follows **Star Schema** best practices to simplify analytical queries and optimize aggregation performance.