-- QUERY 1.1

WITH LatestAddress AS (
    SELECT
        customeraddress.CustomerID,
        MAX(address.AddressID) AS AddressID
    FROM
        tc-da-1.adwentureworks_db.customeraddress AS customeraddress
    JOIN
        tc-da-1.adwentureworks_db.address AS address
      ON customeraddress.AddressID = address.AddressID
    GROUP BY
        customeraddress.CustomerID
),
CustomerAddressDetails AS (
    SELECT 
        la.CustomerID,
        address.AddressID,
        address.AddressLine1,
        address.AddressLine2,
        address.City,
        stateprovince.Name AS State,
        countryregion.Name AS Country
    FROM
        LatestAddress la
    JOIN
        tc-da-1.adwentureworks_db.address AS address
      ON la.AddressID = address.AddressID
    JOIN
        tc-da-1.adwentureworks_db.stateprovince AS stateprovince
      ON address.StateProvinceID = stateprovince.StateProvinceID
    JOIN
        tc-da-1.adwentureworks_db.countryregion AS countryregion
      ON stateprovince.CountryRegionCode = countryregion.CountryRegionCode
),
CustomerInfo AS (
    SELECT
        individual.CustomerID,
        contact.FirstName,
        contact.LastName,
        contact.FirstName || ' ' || contact.LastName AS FullName,
        COALESCE(contact.Title || ' ', 'Dear ') || contact.LastName AS AddressingTitle,
        contact.EmailAddress AS Email,
        contact.Phone,
        customer.AccountNumber,
        customer.CustomerType,
        cad.City,
        cad.State,
        cad.Country,
        cad.AddressLine1
    FROM
        tc-da-1.adwentureworks_db.individual AS individual
    JOIN
        tc-da-1.adwentureworks_db.contact AS contact
      ON individual.ContactID = contact.ContactID
    JOIN
        tc-da-1.adwentureworks_db.customer AS customer
      ON individual.CustomerID = customer.CustomerID
    JOIN
        CustomerAddressDetails cad
      ON customer.CustomerID = cad.CustomerID
    WHERE
        customer.CustomerType = 'I'
),
SalesInfo AS (
    SELECT
        CustomerID,
        COUNT(*) AS No_of_Orders,
        ROUND(SUM(TotalDue),3) AS TotalAmtWithTax,
        MAX(OrderDate) AS LastOrderDate
    FROM
        tc-da-1.adwentureworks_db.salesorderheader AS salesorderheader
    GROUP BY
        CustomerID
)
SELECT
    ci.CustomerID,
    ci.FirstName,
    ci.LastName,
    ci.FullName,
    ci.AddressingTitle,
    ci.Email,
    ci.Phone,
    ci.AccountNumber,
    ci.CustomerType,
    ci.City,
    ci.State,
    ci.Country,
    ci.AddressLine1,
    si.No_of_Orders,
    si.TotalAmtWithTax,
    si.LastOrderDate

FROM
    CustomerInfo ci
JOIN
    SalesInfo si ON ci.CustomerID = si.CustomerID
    
ORDER BY
     si.TotalAmtWithTax DESC
LIMIT 200;
#########################################################################################################

-- QUERY 1.2
WITH LatestOrderDate AS (
  SELECT 
        MAX(OrderDate) AS LatestOrderDate
  FROM 
      tc-da-1.adwentureworks_db.salesorderheader
),
 LatestAddress AS (
    SELECT
        customeraddress.CustomerID,
        MAX(address.AddressID) AS AddressID
    FROM
        tc-da-1.adwentureworks_db.customeraddress AS customeraddress
    JOIN
        tc-da-1.adwentureworks_db.address AS address
      ON customeraddress.AddressID = address.AddressID
    GROUP BY
        customeraddress.CustomerID
),
CustomerAddressDetails AS (
    SELECT 
        la.CustomerID,
        address.AddressID,
        address.AddressLine1,
        address.AddressLine2,
        address.City,
        stateprovince.Name AS State,
        countryregion.Name AS Country
    FROM
        LatestAddress la
    JOIN
        tc-da-1.adwentureworks_db.address AS address
      ON la.AddressID = address.AddressID
    JOIN
        tc-da-1.adwentureworks_db.stateprovince AS stateprovince
      ON address.StateProvinceID = stateprovince.StateProvinceID
    JOIN
        tc-da-1.adwentureworks_db.countryregion AS countryregion
      ON stateprovince.CountryRegionCode = countryregion.CountryRegionCode
),
CustomerInfo AS (
    SELECT
        individual.CustomerID,
        contact.FirstName,
        contact.LastName,
        contact.FirstName || ' ' || contact.LastName AS FullName,
        COALESCE(contact.Title || ' ', 'Dear ') || contact.LastName AS AddressingTitle,
        contact.EmailAddress AS Email,
        contact.Phone,
        customer.AccountNumber,
        customer.CustomerType,
        cad.City,
        cad.State,
        cad.Country,
        cad.AddressLine1
    FROM
        tc-da-1.adwentureworks_db.individual AS individual
    JOIN
        tc-da-1.adwentureworks_db.contact AS contact
      ON individual.ContactID = contact.ContactID
    JOIN
        tc-da-1.adwentureworks_db.customer AS customer
      ON individual.CustomerID = customer.CustomerID
    JOIN
        CustomerAddressDetails cad
      ON customer.CustomerID = cad.CustomerID
    WHERE
        customer.CustomerType = 'I'
),
SalesInfo AS (
    SELECT
        CustomerID,
        COUNT(*) AS No_of_Orders,
        ROUND(SUM(TotalDue),3) AS TotalAmtWithTax,
        MAX(OrderDate) AS LastOrderDate
    FROM
        tc-da-1.adwentureworks_db.salesorderheader AS salesorderheader
    GROUP BY
        CustomerID
)
SELECT
    ci.CustomerID,
    ci.FirstName,
    ci.LastName,
    ci.FullName,
    ci.AddressingTitle,
    ci.Email,
    ci.Phone,
    ci.AccountNumber,
    ci.CustomerType,
    ci.City,
    ci.State,
    ci.Country,
    ci.AddressLine1,
    si.No_of_Orders,
    si.TotalAmtWithTax,
    si.LastOrderDate
   
FROM
    CustomerInfo ci
JOIN
    SalesInfo si ON ci.CustomerID = si.CustomerID
 WHERE
    si.LastOrderDate <= (
        SELECT DATE_SUB(LatestOrderDate.LatestOrderDate, INTERVAL 365 DAY)
        FROM LatestOrderDate
    )
ORDER BY
    si.TotalAmtWithTax DESC
LIMIT 200;
#############################################################################################################

-- QUERY 1.3
WITH LatestOrderDate AS (
  SELECT 
        MAX(OrderDate) AS LatestOrderDate
  FROM 
      tc-da-1.adwentureworks_db.salesorderheader
),
 LatestAddress AS (
    SELECT
        customeraddress.CustomerID,
        MAX(address.AddressID) AS AddressID
    FROM
        tc-da-1.adwentureworks_db.customeraddress AS customeraddress
    JOIN
        tc-da-1.adwentureworks_db.address AS address
      ON customeraddress.AddressID = address.AddressID
    GROUP BY
        customeraddress.CustomerID
),
CustomerAddressDetails AS (
    SELECT 
        la.CustomerID,
        address.AddressID,
        address.AddressLine1,
        address.AddressLine2,
        address.City,
        stateprovince.Name AS State,
        countryregion.Name AS Country
    FROM
        LatestAddress la
    JOIN
        tc-da-1.adwentureworks_db.address AS address
      ON la.AddressID = address.AddressID
    JOIN
        tc-da-1.adwentureworks_db.stateprovince AS stateprovince
      ON address.StateProvinceID = stateprovince.StateProvinceID
    JOIN
        tc-da-1.adwentureworks_db.countryregion AS countryregion
      ON stateprovince.CountryRegionCode = countryregion.CountryRegionCode
),
CustomerInfo AS (
    SELECT
        individual.CustomerID,
        contact.FirstName,
        contact.LastName,
        contact.FirstName || ' ' || contact.LastName AS FullName,
        COALESCE(contact.Title || ' ', 'Dear ') || contact.LastName AS AddressingTitle,
        contact.EmailAddress AS Email,
        contact.Phone,
        customer.AccountNumber,
        customer.CustomerType,
        cad.City,
        cad.State,
        cad.Country,
        cad.AddressLine1
    FROM
        tc-da-1.adwentureworks_db.individual AS individual
    JOIN
        tc-da-1.adwentureworks_db.contact AS contact
      ON individual.ContactID = contact.ContactID
    JOIN
        tc-da-1.adwentureworks_db.customer AS customer
      ON individual.CustomerID = customer.CustomerID
    JOIN
        CustomerAddressDetails cad
      ON customer.CustomerID = cad.CustomerID
    WHERE
        customer.CustomerType = 'I'
),
SalesInfo AS (
    SELECT
        CustomerID,
        COUNT(*) AS No_of_Orders,
       ROUND(SUM(TotalDue),3) AS TotalAmtWithTax,
        MAX(OrderDate) AS LastOrderDate
    FROM
        tc-da-1.adwentureworks_db.salesorderheader AS salesorderheader
    GROUP BY
        CustomerID
)
SELECT
    ci.CustomerID,
    ci.FirstName,
    ci.LastName,
    ci.FullName,
    ci.AddressingTitle,
    ci.Email,
    ci.Phone,
    ci.AccountNumber,
    ci.CustomerType,
    ci.City,
    ci.State,
    ci.Country,
    ci.AddressLine1,
    si.No_of_Orders,
    si.TotalAmtWithTax,
    si.LastOrderDate,
    CASE 
        WHEN si.LastOrderDate >= DATE_SUB((SELECT LatestOrderDate.LatestOrderDate FROM LatestOrderDate), INTERVAL 365 DAY)
        THEN 'Active'
        ELSE 'Inactive'
    END AS CustomerStatus
FROM
    CustomerInfo ci
JOIN
    SalesInfo si ON ci.CustomerID = si.CustomerID
    
ORDER BY
     ci.CustomerID DESC
LIMIT 500;
##############################################################################################################################

-- QUERY 1.4
WITH LatestOrderDate AS (
    SELECT 
        MAX(OrderDate) AS LatestOrderDate
    FROM 
        tc-da-1.adwentureworks_db.salesorderheader
),
LatestAddress AS (
    SELECT
        customeraddress.CustomerID,
        MAX(address.AddressID) AS AddressID
    FROM
        tc-da-1.adwentureworks_db.customeraddress AS customeraddress
    JOIN
        tc-da-1.adwentureworks_db.address AS address
      ON customeraddress.AddressID = address.AddressID
    GROUP BY
        customeraddress.CustomerID
),
CustomerAddressDetails AS (
    SELECT 
        la.CustomerID,
        address.AddressID,
        address.AddressLine1,
        address.AddressLine2,
        address.City,
        stateprovince.Name AS State,
        countryregion.Name AS Country
    FROM
        LatestAddress la
    JOIN
        tc-da-1.adwentureworks_db.address AS address
      ON la.AddressID = address.AddressID
    JOIN
        tc-da-1.adwentureworks_db.stateprovince AS stateprovince
      ON address.StateProvinceID = stateprovince.StateProvinceID
    JOIN
        tc-da-1.adwentureworks_db.countryregion AS countryregion
      ON stateprovince.CountryRegionCode = countryregion.CountryRegionCode
),
CustomerInfo AS (
    SELECT
        individual.CustomerID,
        contact.FirstName,
        contact.LastName,
        contact.FirstName || ' ' || contact.LastName AS FullName,
        COALESCE(contact.Title || ' ', 'Dear ') || contact.LastName AS AddressingTitle,
        contact.EmailAddress AS Email,
        contact.Phone,
        customer.AccountNumber,
        customer.CustomerType,
        cad.City,
        cad.State,
        cad.Country,
        cad.AddressLine1
    FROM
        tc-da-1.adwentureworks_db.individual AS individual
    JOIN
        tc-da-1.adwentureworks_db.contact AS contact
      ON individual.ContactID = contact.ContactID
    JOIN
        tc-da-1.adwentureworks_db.customer AS customer
      ON individual.CustomerID = customer.CustomerID
    JOIN
        CustomerAddressDetails cad
      ON customer.CustomerID = cad.CustomerID
    WHERE
        customer.CustomerType = 'I'
),
SalesInfo AS (
    SELECT
        CustomerID,
        COUNT(*) AS No_of_Orders,
       ROUND(SUM(TotalDue),3) AS TotalAmtWithTax,
        MAX(OrderDate) AS LastOrderDate
    FROM
        tc-da-1.adwentureworks_db.salesorderheader AS salesorderheader
    GROUP BY
        CustomerID
)
SELECT
    ci.CustomerID,
    ci.FirstName,
    ci.LastName,
    ci.FullName,
    ci.AddressingTitle,
    ci.Email,
    ci.Phone,
    ci.AccountNumber,
    ci.CustomerType,
    ci.City,
    ci.State,
    ci.Country,
    ci.AddressLine1,
    SUBSTR(ci.AddressLine1, 1, INSTR(ci.AddressLine1, ' ') - 1) AS address_no,
    SUBSTR(ci.AddressLine1, INSTR(ci.AddressLine1, ' ') + 1) AS address_st,
    si.No_of_Orders,
    si.TotalAmtWithTax,
    si.LastOrderDate,
    'Active' AS CustomerStatus
    
FROM
    CustomerInfo ci
JOIN
    SalesInfo si ON ci.CustomerID = si.CustomerID
WHERE
    (si.TotalAmtWithTax >= 2500 OR si.No_of_Orders >= 5)
    AND ci.Country IN ('United States', 'Canada')
    AND si.LastOrderDate >= DATE_SUB((SELECT LatestOrderDate.LatestOrderDate FROM LatestOrderDate), INTERVAL 365 DAY)
ORDER BY
    ci.Country,
    ci.State,
    si.LastOrderDate
LIMIT 500;
##########################################################################################################################

-- QUERY 2.1
SELECT
LAST_DAY(DATE(OrderDate)) AS order_month,
salesterritory.CountryRegionCode AS CountryRegionCode,
salesterritory.Name AS Region,
COUNT(DISTINCT salesorderheader.SalesOrderID) AS NumberOfOrders,
COUNT(DISTINCT salesorderheader.CustomerID) AS NumberOfCustomers,
COUNT(DISTINCT salesorderheader.SalesPersonID) AS NumberOfSalesPersons,
CAST(SUM(salesorderheader.TotalDue) AS INTEGER) AS Total_w_Tax

FROM `adwentureworks_db.salesorderheader` salesorderheader    
JOIN `adwentureworks_db.salesterritory` salesterritory ON salesorderheader.TerritoryID = salesterritory.TerritoryID
  GROUP BY
      order_month,
      Region,
      CountryRegionCode
##########################################################################################################################

-- QUERY 2.2
 WITH Monthly_orders AS (
  SELECT
      LAST_DAY(DATE(OrderDate)) AS order_month,
      salesterritory.CountryRegionCode AS CountryRegionCode,
      salesterritory.Name AS Region,
      COUNT(DISTINCT salesorderheader.SalesOrderID) AS NumberOfOrders,
      COUNT(DISTINCT salesorderheader.CustomerID) AS NumberOfCustomers,
      COUNT(DISTINCT salesorderheader.SalesPersonID) AS NumberOfSalesPersons,
      CAST(SUM(salesorderheader.TotalDue) AS INTEGER) AS Total_w_Tax

FROM `adwentureworks_db.salesorderheader` salesorderheader    
JOIN `adwentureworks_db.salesterritory` salesterritory ON salesorderheader.TerritoryID = salesterritory.TerritoryID
  GROUP BY
      order_month,
      Region,
      CountryRegionCode
)
SELECT
    order_month,
    CountryRegionCode,
    Region,
    NumberOfOrders,
    NumberOfCustomers,
    NumberOfSalesPersons,
    Total_w_Tax,
    SUM(Total_w_Tax) OVER (PARTITION BY CountryRegionCode, Region ORDER BY order_month) AS Cumulative_Total_w_Tax
FROM
    Monthly_orders
ORDER BY
    order_month DESC,
    CountryRegionCode DESC,
    Region DESC;
    
    #############################################################################################################################
-- QUERY 2.3    
 WITH Monthly_orders AS (
  SELECT
      LAST_DAY(DATE(OrderDate)) AS order_month,
      salesterritory.CountryRegionCode AS CountryRegionCode,
      salesterritory.Name AS Region,
      COUNT(DISTINCT salesorderheader.SalesOrderID) AS NumberOfOrders,
      COUNT(DISTINCT salesorderheader.CustomerID) AS NumberOfCustomers,
      COUNT(DISTINCT salesorderheader.SalesPersonID) AS NumberOfSalesPersons,
      CAST(SUM(salesorderheader.TotalDue) AS INTEGER) AS Total_w_Tax,
      
FROM `adwentureworks_db.salesorderheader` salesorderheader    
JOIN `adwentureworks_db.salesterritory` salesterritory ON salesorderheader.TerritoryID = salesterritory.TerritoryID
  GROUP BY
      order_month,
      Region,
      CountryRegionCode
)
SELECT
    order_month,
    CountryRegionCode,
    Region,
    NumberOfOrders,
    NumberOfCustomers,
    NumberOfSalesPersons,
    Total_w_Tax,
    RANK() OVER(PARTITION BY CountryRegionCode, Region ORDER BY Total_w_Tax DESC) AS Country_sales_rank,
    SUM(Total_w_Tax) OVER (PARTITION BY CountryRegionCode, Region ORDER BY order_month) AS Cumulative_Total_w_Tax
    
FROM
    Monthly_orders
WHERE
    CountryRegionCode = 'FR'
ORDER BY Country_sales_rank;
######################################################################################################################

-- QUERY 2.4
WITH Monthly_orders AS (
    SELECT
        LAST_DAY(DATE(OrderDate)) AS order_month,
        salesterritory.CountryRegionCode AS CountryRegionCode,
        salesterritory.Name AS Region,
        COUNT(DISTINCT salesorderheader.SalesOrderID) AS NumberOfOrders,
        COUNT(DISTINCT salesorderheader.CustomerID) AS NumberOfCustomers,
        COUNT(DISTINCT salesorderheader.SalesPersonID) AS NumberOfSalesPersons,
        CAST(SUM(salesorderheader.TotalDue) AS INTEGER) AS Total_w_Tax
    FROM
        `adwentureworks_db.salesorderheader` salesorderheader    
    JOIN
        `adwentureworks_db.salesterritory` salesterritory ON salesorderheader.TerritoryID = salesterritory.TerritoryID
    GROUP BY
        order_month,
        Region,
        CountryRegionCode
),
Max_tax_rate_per_province AS (
    SELECT
        stateprovince.StateProvinceID,
        stateprovince.CountryRegionCode,
        MAX(taxrate.TaxRate) AS MaxTaxRate
    FROM
        `adwentureworks_db.stateprovince` stateprovince
    LEFT JOIN
        `adwentureworks_db.salestaxrate` taxrate ON stateprovince.StateProvinceID = taxrate.StateProvinceID
    GROUP BY
        stateprovince.StateProvinceID,
        stateprovince.CountryRegionCode
),
Province_tax_info AS (
    SELECT
        CountryRegionCode,
        COUNT(DISTINCT StateProvinceID) AS TotalProvinces,
        COUNT(DISTINCT CASE WHEN MaxTaxRate IS NOT NULL THEN StateProvinceID END) AS ProvincesWithTax,
        ROUND(AVG(MaxTaxRate),2) AS MeanTaxRate
    FROM
        Max_tax_rate_per_province
    GROUP BY
        CountryRegionCode
),
Country_tax_summary AS (
    SELECT
        CountryRegionCode,
        MeanTaxRate AS mean_tax_rate,
        ROUND(CAST(ProvincesWithTax AS FLOAT64) / CAST(TotalProvinces AS FLOAT64),2) AS perc_provinces_w_tax
    FROM
        Province_tax_info
)
SELECT
    mo.order_month,
    mo.CountryRegionCode,
    mo.Region,
    mo.NumberOfOrders,
    mo.NumberOfCustomers,
    mo.NumberOfSalesPersons,
    mo.Total_w_Tax,
    RANK() OVER(PARTITION BY mo.CountryRegionCode, mo.Region ORDER BY mo.Total_w_Tax DESC) AS Country_sales_rank,
    SUM(mo.Total_w_Tax) OVER (PARTITION BY mo.CountryRegionCode, mo.Region ORDER BY mo.order_month) AS Cumulative_Total_w_Tax,
    cts.mean_tax_rate,
    cts.perc_provinces_w_tax
FROM
    Monthly_orders mo
JOIN
    Country_tax_summary cts ON mo.CountryRegionCode = cts.CountryRegionCode

WHERE mo.CountryRegionCode = 'US'

ORDER BY
    mo.CountryRegionCode,
    mo.Region,
    mo.order_month;

