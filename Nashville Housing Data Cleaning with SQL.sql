--Data Cleaning with SQL Queries


Select *
From DataCleaning..NashvilleHousing


-- Standardize the SaleDate column Format

Select SaleDate
From DataCleaning..NashvilleHousing

Select SaleDate, CONVERT(Date, SaleDate)
From DataCleaning..NashvilleHousing

ALTER TABLE DataCleaning..NashvilleHousing
Add SaleDateConverted Date;

Update DataCleaning..NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted, CONVERT(Date, SaleDate)
From DataCleaning..NashvilleHousing


-- Populate Property Address data

Select *
From DataCleaning.dbo.NashvilleHousing
where PropertyAddress is NULL
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From DataCleaning.dbo.NashvilleHousing a
JOIN DataCleaning.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From DataCleaning.dbo.NashvilleHousing a
JOIN DataCleaning.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Select *
From DataCleaning.dbo.NashvilleHousing
where PropertyAddress is NULL 


-- Breaking  PropertyAddress into Individual Columns (Address, City, State)

Select PropertyAddress
From DataCleaning.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From DataCleaning.dbo.NashvilleHousing


ALTER TABLE DataCleaning..NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update DataCleaning..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE DataCleaning..NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update DataCleaning..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From DataCleaning.dbo.NashvilleHousing


--Split OwnerAddress column

Select OwnerAddress
From DataCleaning.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From DataCleaning.dbo.NashvilleHousing


ALTER TABLE DataCleaning..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update DataCleaning..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE DataCleaning..NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update DataCleaning..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE DataCleaning..NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update DataCleaning..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
From DataCleaning.dbo.NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant)
From DataCleaning.dbo.NashvilleHousing

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From DataCleaning.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From DataCleaning.dbo.NashvilleHousing


Update DataCleaning..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From DataCleaning.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


-- Delete Unused Columns

Select *
From DataCleaning.dbo.NashvilleHousing


ALTER TABLE DataCleaning.dbo.NashvilleHousing
DROP COLUMN   PropertyAddress, OwnerAddress, SaleDate, TaxDistrict

Select *
From DataCleaning.dbo.NashvilleHousing