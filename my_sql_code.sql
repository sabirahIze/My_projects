-- QUERY 1.1
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.ProductNumber,
    p.Size,
    p.Color,
    ps.ProductSubcategoryID,
    ps.Name AS SubcategoryName
FROM 
    `tc-da-1.adwentureworks_db.product` p
INNER JOIN 
    `tc-da-1.adwentureworks_db.productsubcategory` ps
  ON p.ProductSubcategoryID = ps.ProductSubcategoryID
ORDER BY ps.Name;

###############################################################################################################
-- QUERY 1.2
SELECT  
    p.ProductID,
    p.Name AS ProductName,
    p.ProductNumber,
    p.Size,
    p.Color,
    ps.ProductSubcategoryID,
    ps.Name AS Subcategory_Name,
    pc.Name AS Category_Name
FROM 
    `tc-da-1.adwentureworks_db.product` p
INNER JOIN 
    `tc-da-1.adwentureworks_db.productsubcategory` ps
  ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN 
    `tc-da-1.adwentureworks_db.productcategory` pc
  ON ps.ProductCategoryID = pc.ProductCategoryID
ORDER BY pc.Name;
#############################################################################################################
-- QUERY 1.3
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.ProductNumber,
    p.Size,
    p.Color,
    ps.ProductSubcategoryID,
    ps.Name AS Subcategory_Name,
    pc.Name AS Category_Name,
    plph.ListPrice
FROM 
    `tc-da-1.adwentureworks_db.product` p
INNER JOIN 
    `tc-da-1.adwentureworks_db.productsubcategory` ps
  ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN
    `tc-da-1.adwentureworks_db.productcategory` pc
  ON ps.ProductCategoryID = pc.ProductCategoryID
INNER JOIN 
    `tc-da-1.adwentureworks_db.productlistpricehistory` plph
  ON plph.ProductID = p.ProductID
WHERE 
     (plph.EndDate IS NULL AND plph.ListPrice > 2000) AND pc.Name LIKE '%Bikes%'
ORDER BY plph.ListPrice DESC;

#############################################################################################################
-- QUERY 2.1
SELECT 
    LocationID,
    COUNT(DISTINCT WorkOrderID) AS no_work_orders,
    COUNT(DISTINCT ProductID) AS no_unique_products,
    SUM(ActualCost) AS total_actual_cost

FROM 
     `tc-da-1.adwentureworks_db.workorderrouting`
WHERE 
      ActualStartDate BETWEEN '2004-01-01' AND '2004-01-31'
GROUP BY LocationID
ORDER BY 4 DESC;

#############################################################################################################
-- QUERY 2.2
SELECT 
    l.LocationID,
    l.Name AS Location,
    COUNT(DISTINCT WorkOrderID) AS no_work_orders,
    COUNT(DISTINCT ProductID) AS no_unique_products,
    SUM(ActualCost) AS total_actual_cost,
    ROUND(AVG(DATE_DIFF(wr.ActualEndDate,wr.ActualStartDate, DAY)),2) AS avg_days_diff

FROM 
     `tc-da-1.adwentureworks_db.workorderrouting` wr
INNER JOIN 
     `tc-da-1.adwentureworks_db.location` l
   ON wr.LocationID = l.LocationID
WHERE 
      wr.ActualStartDate BETWEEN'2004-01-01' AND '2004-01-31'
GROUP BY l.LocationID, l.Name
ORDER BY 3 DESC;

#############################################################################################################
-- QUERY 2.3
SELECT 
     WorkOrderID,
     SUM(ActualCost) as actual_cost
    
FROM `tc-da-1.adwentureworks_db.workorderrouting` 
    
WHERE ActualStartDate BETWEEN '2004-01-01' AND '2004-01-31'
GROUP BY WorkOrderID
HAVING actual_cost > 300;

#############################################################################################################
-- QUERY 3.1
SELECT 
    sales_detail.SalesOrderId,
    sales_detail.OrderQty,
    sales_detail.UnitPrice,
    sales_detail.LineTotal,
    sales_detail.ProductId,
    sales_detail.SpecialOfferID,
    spec_offer_product.ModifiedDate,
    spec_offer.Category,
    spec_offer.Description
FROM
      `tc-da-1.adwentureworks_db.salesorderdetail` sales_detail
LEFT JOIN
      `tc-da-1.adwentureworks_db.specialofferproduct` spec_offer_product
      ON sales_detail.ProductId = spec_offer_product.ProductID
      AND -- Join on the two Primary keys in SpecialOfferProduct Table
      sales_detail.SpecialOfferID = spec_offer_product.SpecialOfferID
LEFT JOIN
      `tc-da-1.adwentureworks_db.specialoffer` spec_offer
      ON sales_detail.SpecialOfferID = spec_offer.SpecialOfferID
ORDER BY 4 DESC;

###############################################################################################################
-- QUERY 3.2
SELECT 
    v.VendorID as Id,
    vc.ContactID,
    vc.ContactTypeId,
    v.Name,
    v.CreditRating,
    v.ActiveFlag,
    va.AddressID,
    a.City
FROM 
     `tc-da-1.adwentureworks_db.vendor` v
LEFT JOIN 
     `tc-da-1.adwentureworks_db.vendorcontact` vc
    ON v.VendorID = vc.VendorID
LEFT JOIN 
    `tc-da-1.adwentureworks_db.vendoraddress` va 
    ON vc.VendorID = va.VendorID
INNER JOIN 
          `tc-da-1.adwentureworks_db.address` a
    ON va.AddressID = a.AddressID
ORDER BY 1;

#############################################################################################################