SELECT TOP (1000) [UniqueID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[SoldAsVacaNot]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Portfolio].[dbo].[NashVilleHousing]


/*

Cleaning Data in SQL Queries

*/

select *
from [dbo].[NashVilleHousing]

-- Standardize Date Format

select SaleDateConverted, convert(Date, SaleDate)
from [dbo].[NashVilleHousing]

update [dbo].[NashVilleHousing]
set SaleDate = convert(Date, SaleDate)

-- Affected All Rows

ALTER TABLE [dbo].[NashVilleHousing]
Add SaleDateConverted Date;

Update [dbo].[NashVilleHousing]
SET SaleDateConverted = CONVERT(Date, SaleDate)

-- Populate Property Address State

select *--PropertyAddress
from [dbo].[NashVilleHousing]
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [dbo].[NashVilleHousing] a
JOIN [dbo].[NashVilleHousing] b
	on a.ParcelID = b.ParcelID
	and a.[UNIQUEID] <> b.[UNIQUEID]
where a.PropertyAddress is NULL

update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.Propertyddress)
from [dbo].[NashVilleHousing] a
JOIN [dbo].[NashVilleHousing] b
	on a.PARCELID <> b.PARCELID
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

-- Breaking out Address Into individual Columns (Address, City, State)

select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
	   SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, len(PropertyAddress)) AS Address
-- CHARINDEX(',', PropertyAddress)
from [dbo].[NashVilleHousing]
--order by ParceID

-- Making changes to data.
ALTER TABLE [dbo].[NashVilleHousing]
Add PropertySplitAddress varchar(255)

UPDATE [dbo].[NashVilleHousing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE [dbo].[NashVilleHousing]
Add PropertySplitCity varchar(255)

UPDATE [dbo].[NashVilleHousing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, len(PropertyAddress))

select *
from [dbo].[NashVilleHousing]

select OwnerAddress
from [dbo].[NashVilleHousing]

select PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM [dbo].[NashVilleHousing]

ALTER TABLE [dbo].[NashVilleHousing]
Add OwnerSplitAddress varchar(255)

UPDATE [dbo].[NashVilleHousing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE [dbo].[NashVilleHousing]
Add OwnerSplitCity varchar(255)

UPDATE [dbo].[NashVilleHousing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE [dbo].[NashVilleHousing]
Add OwnerSplitState varchar(255)

UPDATE [dbo].[NashVilleHousing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

SELECT DISTINCT(SoldAsVacaTest)
FROM [dbo].[NashVilleHousingNew]

ALTER TABLE [dbo].[NashVilleHousing]
exec sp_rename '[dbo].[NashVilleHousing].SoldAsVaca', 'SoldAsVacaTest', 'COLUMN'; 

--exec sp_rename '[dbo].[NashVilleHousing]', 'NashVilleHousingNew';

select SoldAsVacaTest, count(SoldAsVacaTest) counts
FROM [dbo].[NashVilleHousingNew]
group by SoldAsVacaTest
order by 2 DESC

SELECT SoldAsVacaTest,
	CASE WHEN SoldAsVacaTest = 'N' THEN 'NO'
	ELSE SoldAsVacaTest
	END
FROM  [dbo].[NashVilleHousingNew]

UPDATE [dbo].[NashVilleHousingNew]
SET SoldAsVacaTest = CASE WHEN SoldAsVacaTest = 'N' THEN 'NO'
	ELSE SoldAsVacaTest
	END

Select DISTINCT(SoldAsVacaTest)

From [dbo].[NashVilleHousingNew]

select *
From [dbo].[NashVilleHousingNew]

-- Remove Duplicates
WITH ROWNUMCTE AS
(select *,
	ROW_NUMBER() OVER(
	PARTITION BY PropertyAddress,
				 SalePrice,
				 SaleDate
				 ORDER BY
				     uniqueID
					 ) row_num

FROM [dbo].[NashVilleHousingNew]
--where row_num > 1
)
select *
From ROWNUMCTE
--Assignment: What does ROW_NUMBER() do? 


select *
From [dbo].[NashVilleHousingNew]




WITH ROWNUMCTE AS
(select PropertyAddress, SalePrice, SaleDate,
	ROW_NUMBER() OVER(
	PARTITION BY PropertyAddress,
				 SalePrice,
				 SaleDate
				 ORDER BY
				     uniqueID
					 ) row_num

FROM [dbo].[NashVilleHousingNew]

)
select *
From ROWNUMCTE
where row_num > 1


--delete from table 
select COUNT(*), PropertyAddress, SalePrice, SaleDate
From [dbo].[NashVilleHousingNew]
where PropertyAddress in ('1382  RURAL HILL RD, ANTIOCH')
group by PropertyAddress, SalePrice, SaleDate
having  COUNT(*) > 1



select *
From [dbo].[NashVilleHousingNew]

-- Delete Unused Columns
select *
From [dbo].[NashVilleHousingNew]

Alter Table [dbo].[NashVilleHousingNew]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

Alter Table [dbo].[NashVilleHousingNew]
DROP COLUMN SaleDate