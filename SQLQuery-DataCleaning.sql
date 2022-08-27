--view the entire dataset

Select * from project_portfolio..HousingProject

-- Standardise the DateFormat

Select SaleDate from project_portfolio..HousingProject
Select SaleDateConverted , convert(Date,SaleDate)  from project_portfolio..HousingProject

Update project_portfolio..HousingProject
Set SaleDate = convert(Date,SaleDate)

Alter Table project_portfolio..HousingProject
add SaleDateConverted Date;

Update project_portfolio..HousingProject
Set SaleDateConverted = convert(Date,SaleDate)

--Populate Property Address Data

Select PropertyAddress from project_portfolio..HousingProject 
where PropertyAddress is not null order by ParcelID 

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress)
from project_portfolio..HousingProject a
join project_portfolio..HousingProject b on a.ParcelID = b.ParcelID and 
a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is Null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from project_portfolio..HousingProject a
join project_portfolio..HousingProject b on a.ParcelID = b.ParcelID and 
a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is Null

--Breaking Down Address into Indivisual Columns (Address, City, State)

Select PropertyAddress from project_portfolio..HousingProject 

Select SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, Len(PropertyAddress)) as Address
from project_portfolio..HousingProject 

Alter Table project_portfolio..HousingProject
add PropertySplitAddress nvarchar(255);

Update project_portfolio..HousingProject
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

Alter Table project_portfolio..HousingProject
add PropertySplitCity nvarchar(255);

Update project_portfolio..HousingProject
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, Len(PropertyAddress))

select * from project_portfolio..HousingProject

-- Split OwnerAddress

select OwnerAddress from project_portfolio..HousingProject
select 
PARSENAME(replace(OwnerAddress,',','.'), 3),
PARSENAME(replace(OwnerAddress,',','.'), 2),
PARSENAME(replace(OwnerAddress,',','.'), 1)
from project_portfolio..HousingProject

Alter Table project_portfolio..HousingProject
add OwnerSplitAddress nvarchar(255);

Update project_portfolio..HousingProject
Set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'), 3)

Alter Table project_portfolio..HousingProject
add OwnerSplitCity nvarchar(255);

Update project_portfolio..HousingProject
Set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'), 2)

Alter Table project_portfolio..HousingProject
add OwnerSplitState nvarchar(255);

Update project_portfolio..HousingProject
Set OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'), 1)

select * from project_portfolio..HousingProject

--Change Y and N to Yes and No in "Sold as Vacant" Field

select Distinct(SoldasVacant) from project_portfolio..HousingProject

select SoldasVacant, 
CASE When SoldasVacant = 'N' Then 'No'
						  When SoldasVacant ='Y' Then 'Yes'
						  Else SoldasVacant
						  END
from project_portfolio..HousingProject

UPDATE project_portfolio..HousingProject
SET SoldasVacant = CASE When SoldasVacant = 'N' Then 'No'
						  When SoldasVacant ='Y' Then 'Yes'
						  Else SoldasVacant
						  END


-- Remove Duplicates

With RownumCTE as(
select *,
    ROW_NUMBER() over(
	Partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference
	Order By UniqueID) as row_num 
	from project_portfolio..HousingProject)
Select *from RownumCTE
Where row_num >1

-- Delete Unused Columns

Alter Table project_portfolio..HousingProject
DROP Column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate

select * from project_portfolio..HousingProject
