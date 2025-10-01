SELECT * 
FROM [Portfolio Projects Housing Data].dbo.Housing

SELECT SaleDate
FROM [Portfolio Projects Housing Data].dbo.Housing

SELECT SaleDate, CONVERT(Date, SaleDate) AS Date_of_Sales
FROM [Portfolio Projects Housing Data].dbo.housing

UPDATE Housing
SET SaleDate = CONVERT(Date, SaleDate) 

ALTER TABLE Housing
ADD SaleDateConverted DATE;

UPDATE Housing
SET SaleDateConverted = CONVERT(Date, SaleDate) 


SELECT * FROM [Portfolio Projects Housing Data].dbo.Housing
WHERE PropertyAddress IS NOT NULL
ORDER BY ParcelID


--PROPERTYADDRESS FILL UP

SELECT A1.ParcelID, A1.PropertyAddress, B1.ParcelID, B1.PropertyAddress, ISNULL(A1.PropertyAddress, B1.PropertyAddress)
FROM [Portfolio Projects Housing Data].dbo.Housing AS A1
INNER JOIN [Portfolio Projects Housing Data].dbo.Housing AS B1
   ON A1.ParcelID=B1.ParcelID
   AND A1.[UniqueID ] <> B1.[UniqueID ]
WHERE A1.PropertyAddress IS NULL

UPDATE A1
SET PropertyAddress = ISNULL(A1.PropertyAddress, B1.PropertyAddress)
FROM [Portfolio Projects Housing Data].dbo.Housing AS A1
INNER JOIN [Portfolio Projects Housing Data].dbo.Housing AS B1
   ON A1.ParcelID=B1.ParcelID
   AND A1.[UniqueID ] <> B1.[UniqueID ]
WHERE A1.PropertyAddress IS NULL

--Breaking Out Address into Individual coloumns (Address, city, State)

SELECT PropertyAddress
FROM [Portfolio Projects Housing Data].dbo.Housing
--WHERE PropertyAddress IS NOT NULL
--ORDER BY ParcelID


--Creating PropertyAddress AS Address

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM [Portfolio Projects Housing Data].dbo.Housing


--Separating PropertyAddress As CITY AND ADDRESS

ALTER TABLE Housing
ADD PropertySplitAddress NVARCHAR(260);

UPDATE Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Housing
ADD PropertySplitCity NVARCHAR(260);

UPDATE Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 

SELECT * 
FROM [Portfolio Projects Housing Data].dbo.Housing


--Usinig the ParseName to Seperate property address into (owneraddress, city and state)


SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM [Portfolio Projects Housing Data].dbo.Housing


ALTER TABLE Housing
ADD OwnerSplitAddress NVARCHAR(260);

UPDATE Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Housing
ADD OwnerSplitCity NVARCHAR(260);

UPDATE Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE Housing
ADD OwnerSplitState NVARCHAR(260);

UPDATE Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT *
FROM [Portfolio Projects Housing Data].dbo.Housing


--changing the Y and N into "YES" and "NO" in  the SoldAsVacant 

SELECT SoldAsVacant 
, CASE WHEN SoldAsVacant = 'Y' THEN 'YES'  
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END AS newsoldvacant
FROM [Portfolio Projects Housing Data].dbo.Housing


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) 
FROM [Portfolio Projects Housing Data].dbo.Housing
GROUP BY SoldAsVacant
ORDER BY 2

UPDATE Housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'  
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END 


--REMOVE DUPLICATES

WITH RowNumCTE AS(
SELECT *
    ROW_NUMBER () OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SalaDate,
				 LegalReference
				 ORDER BY 
				   UniqueID
				  ) row_num		  
FROM [Portfolio Projects Housing Data].dbo.Housing
)

SELECT * 
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


--DELETE DUPLICATES

SELECT *
FROM [Portfolio Projects Housing Data].dbo.Housing

ALTER TABLE [Portfolio Projects Housing Data].dbo.Housing
DROP COLUMN OWnerAddress, PropertyAddress

ALTER TABLE [Portfolio Projects Housing Data].dbo.Housing
DROP COLUMN SaleDate
