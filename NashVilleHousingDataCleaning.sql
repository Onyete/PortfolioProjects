
--Cleaning data in Sql Queries


Select SaleDateConverted
From PortfolioProject.dbo.NashvilleHousing

-- Standardize date format

Select SaleDateConverted, CONVERT(Date,Saledate)
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject..NashvilleHousing
ADD SaleDateConverted Date;

Update PortfolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(date,saledate)


--Populate Property Address Data

Select *
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID 
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID 
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

select * from PortfolioProject..NashvilleHousing
where PropertyAddress is not null


--Breaking out Address Into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject..NashvilleHousing


Select
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address

From PortfolioProject..NashvilleHousing


ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Alter table PortfolioProject..NashvilleHousing
drop column PrpoertySplitCity;


Select OwnerAddress
From PortfolioProject..NashvilleHousing


Select
PARSENAME(REPLACE(Owneraddress, ',','.') , 3) as Address,
PARSENAME(REPLACE(Owneraddress, ',','.') , 2) as City,
PARSENAME(REPLACE(Owneraddress, ',','.') , 1) as State
From PortfolioProject..NashvilleHousing


ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(Owneraddress, ',','.') , 3)


ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(Owneraddress, ',','.') , 2)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(Owneraddress, ',','.') , 1)


Select * 
From PortfolioProject..NashvilleHousing



-- Change Y and N to Yes and No in " Sold as Vacant" Field

Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
,	Case When SoldAsVacant = 'Y' Then 'Yes'
		 When SoldAsVacant = 'N' Then 'No'
		 Else SoldAsVacant
		 End
From PortfolioProject..NashvilleHousing

UPDATE PortfolioProject..NashvilleHousing
SET		SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
		 When SoldAsVacant = 'N' Then 'No'
		 Else SoldAsVacant
		 End



--Remove Duplicates


WITH RowNumCTE AS(
Select * 
,	ROW_NUMBER() Over (
	Partition By ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) Row_Num


From PortfolioProject..NashvilleHousing
--Order By ParcelID
)
Select *
From RowNumCTE
Where Row_Num > 1
Order by PropertyAddress



--WITH RowNumCTE AS(
--Select * 
--,	ROW_NUMBER() Over (
--	Partition By ParcelID,
--				 PropertyAddress,
--				 SalePrice,
--				 SaleDate,
--				 LegalReference
--				 ORDER BY
--					UniqueID
--					) Row_Num


--From PortfolioProject..NashvilleHousing
----Order By ParcelID
--)
--DELETE
--From RowNumCTE
--Where Row_Num > 1
----Order by PropertyAddress




-- Deleting Unused Column


ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate


Select *
From PortfolioProject..NashvilleHousing


