--CLEANING DATA WITH QUERIES

SELECT *
FROM SQL_Project_1.dbo.Housing$

--------------------------------------------------------------------------------------------------------------------------
-- DATE FORMATING

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM SQL_Project_1.dbo.Housing$

UPDATE SQL_Project_1.dbo.Housing$
SET SaleDate = CONVERT(Date,SaleDate)

Alter Table SQL_Project_1.dbo.Housing$
Add SaleDateConverted Date;

UPDATE SQL_Project_1.dbo.Housing$
SET SaleDateConverted = CONVERT(Date,SaleDate)

--------------------------------------------------------------------------------------------------------------------------
-- PROPERTY ADDRESS DATA

SELECT *
FROM SQL_Project_1.dbo.Housing$
ORDER BY ParcelID

SELECT set1.ParcelID, set1.PropertyAddress, set2.ParcelID,set2.PropertyAddress, ISNULL(set1.PropertyAddress,set2.PropertyAddress) 
FROM SQL_Project_1.dbo.Housing$ set1
JOIN SQL_Project_1.dbo.Housing$ set2
	ON set1.ParcelID = set2.ParcelID
	AND set1.[UniqueID ] <> set2.[UniqueID ]
Where set1.PropertyAddress is null

UPDATE set1
SET PropertyAddress = ISNULL(set1.PropertyAddress,'No Address')
FROM SQL_Project_1.dbo.Housing$ set1
JOIN SQL_Project_1.dbo.Housing$ set2
	ON set1.ParcelID = set2.ParcelID
	AND set1.[UniqueID ] <> set2.[UniqueID ]
Where set1.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------
-- BREAKING ADDRESS COLUMN INDIVIDUALLY BY Address, City, State

SELECT PropertyAddress
FROM SQL_Project_1.dbo.Housing$;

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM SQL_Project_1.dbo.Housing$

Alter Table SQL_Project_1.dbo.Housing$
Add PropertyByAddress NVARCHAR(255);

UPDATE SQL_Project_1.dbo.Housing$
SET PropertyByAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table SQL_Project_1.dbo.Housing$
Add PropertyByCity NVARCHAR(255);

UPDATE SQL_Project_1.dbo.Housing$
SET PropertyByCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT * FROM SQL_Project_1.dbo.Housing$

--OWNERS ADDRESS

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM SQL_Project_1.dbo.Housing$

Alter Table SQL_Project_1.dbo.Housing$
Add OwnerPropertyAddress NVARCHAR(255);

UPDATE SQL_Project_1.dbo.Housing$
SET OwnerPropertyAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Alter Table SQL_Project_1.dbo.Housing$
Add OwnerPropertyCity NVARCHAR(255);

UPDATE SQL_Project_1.dbo.Housing$
SET OwnerPropertyCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter Table SQL_Project_1.dbo.Housing$
Add OwnerPropertyState NVARCHAR(255);

UPDATE SQL_Project_1.dbo.Housing$
SET OwnerPropertyState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT * FROM SQL_Project_1.dbo.Housing$

--------------------------------------------------------------------------------------------------------------------------
-- CHANGING Y AND N TO YES AND NO

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM SQL_Project_1.dbo.Housing$
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
	CASE
		WHEN SoldAsVacant = 'Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
	END
FROM SQL_Project_1.dbo.Housing$

UPDATE SQL_Project_1.dbo.Housing$
	SET SoldAsVacant = CASE
		WHEN SoldAsVacant = 'Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
	END

--------------------------------------------------------------------------------------------------------------------------
-- REMOVE DUPLICATE

WITH ROWNUM_CTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 ORDER BY
						UniqueID)
						row_num

FROM SQL_Project_1.dbo.Housing$)
SELECT *
FROM ROWNUM_CTE
Where row_num > 1
Order By PropertyAddress

--------------------------------------------------------------------------------------------------------------------------
-- REMOVE UNUSED COLUMNS

SELECT *
FROM SQL_Project_1.dbo.Housing$

ALTER TABLE SQL_Project_1.dbo.Housing$
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict

