-- DATA CLEANING
-- Rename table
ALTER TABLE "DairyFarm"
RENAME TO dairy_farm;

-- Rename columns
ALTER TABLE dairy_farm
RENAME COLUMN "Location" TO Location;

ALTER TABLE dairy_farm
RENAME COLUMN "Total Land Area (acres)" TO Total_Land_Area;

ALTER TABLE dairy_farm
RENAME COLUMN "Number of Cows" TO Number_of_Cows;

ALTER TABLE dairy_farm
RENAME COLUMN "Farm Size" TO Farm_Size;

ALTER TABLE dairy_farm
RENAME COLUMN "Date" TO Recording_Date;

ALTER TABLE dairy_farm
RENAME COLUMN "Product ID" TO Product_ID;

ALTER TABLE dairy_farm
RENAME COLUMN "Product Name" TO Product_Name;

ALTER TABLE dairy_farm
RENAME COLUMN "Brand" TO Brand;

ALTER TABLE dairy_farm
RENAME COLUMN "Quantity (liters/kg)" TO Quantity;

ALTER TABLE dairy_farm
RENAME COLUMN "Price per Unit" TO Price_per_Unit; 

ALTER TABLE dairy_farm
RENAME COLUMN "Total Value" TO Total_Value;

ALTER TABLE dairy_farm
RENAME COLUMN "Shelf Life (days)" TO Shelf_Life;

ALTER TABLE dairy_farm
RENAME COLUMN "Storage Condition" TO Storage_Condition;

ALTER TABLE dairy_farm
RENAME COLUMN "Production Date" TO Production_Date;

ALTER TABLE dairy_farm
RENAME COLUMN "Expiration Date" TO Expiration_Date;

ALTER TABLE dairy_farm
RENAME COLUMN "Quantity Sold (liters/kg)" TO Quantity_Sold;

ALTER TABLE dairy_farm
RENAME COLUMN "Price per Unit (sold)" TO "Sold_per_Unit";

ALTER TABLE dairy_farm
RENAME COLUMN "Approx. Total Revenue(INR)" TO Total_Revenue;

ALTER TABLE dairy_farm
RENAME COLUMN "Customer Location" TO Customer_Location;

ALTER TABLE dairy_farm
RENAME COLUMN "Sales Channel" TO Sales_Channel;

ALTER TABLE dairy_farm
RENAME COLUMN "Quantity in Stock (liters/kg)" TO Quantity_in_Stock;

ALTER TABLE dairy_farm
RENAME COLUMN "Minimum Stock Threshold (liters/kg)" TO Minimum_Stock_Threshold;

ALTER TABLE dairy_farm
RENAME COLUMN "Reorder Quantity (liters/kg)" TO Reorder_Quantity;


-- Recasting the date columns data type from varchar to date
ALTER TABLE dairy_farm
	ALTER COLUMN recording_date TYPE DATE
	USING recording_date::DATE;
	
ALTER TABLE dairy_farm	
	ALTER COLUMN production_date TYPE DATE
	USING production_date::DATE;
	
ALTER TABLE dairy_farm
	ALTER COLUMN expiration_date TYPE DATE
	USING expiration_date::DATE;
	
-- To check if the data_type of all columns are correct
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND 
table_name = 'dairy_farm';


-- Check for null data in the dataset
SELECT * 
FROM dairy_farm 
WHERE NOT (dairy_farm IS NOT NULL);
--This shows there is no null data anywhere in the dataset1