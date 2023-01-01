select *
from Nashville

---cleaning data in SQL
--standardize date format

select SaleDate
from Nashville

--create a new column to convert date

alter table Nashville
add SalesDateConverted Date;

update Nashville
set SalesDateConverted = CONVERT(date,SaleDate)

 CONVERT(date,SaleDate)

 --populate Property address

 select PropertyAddress
 from Nashville
 where PropertyAddress is null

 select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,
			ISNULL(a.PropertyAddress,b.PropertyAddress)
 from Nashville a
 join Nashville b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where b.PropertyAddress is null


update a
set PropertyAddress = 	ISNULL(a.PropertyAddress,b.PropertyAddress)
from Nashville a
 join Nashville b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null
from Nashville a
 join Nashville b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

select PropertyAddress
from Nashville
where PropertyAddress is null


---breaking out address into individual columns,,( address, city, state)

select PropertyAddress
from Nashville


select 
SUBSTRING( PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1 ) as Address
	--CHARINDEX(',', PropertyAddress)
from Nashville

select PropertyAddress,
		SUBSTRING( PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1 ) as StreetAddress
		,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as City
from Nashville


---add column

alter table Nashville
add StreetAddress nvarchar(255);

update Nashville
set	StreetAddress = SUBSTRING( PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1 )

select StreetAddress
from Nashville

alter table Nashville
add City nvarchar(255);

update Nashville
set	City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

select City
from Nashville

select PropertyAddress ,StreetAddress,City
from Nashville

--find the owner address /. split by delimeter

select OwnerAddress
from Nashville

select  OwnerAddress,
	PARSENAME(replace(OwnerAddress, ',' , '.') ,3),
	PARSENAME(replace(OwnerAddress, ',' , '.') ,2),
	PARSENAME(replace(OwnerAddress, ',' , '.') ,1)
from Nashville

alter table Nashville
add OwnerStreetAddress nvarchar(255);

update Nashville
set	OwnerStreetAddress = PARSENAME(replace(OwnerAddress, ',' , '.') ,3)

alter table Nashville
add OwnerStreetCity nvarchar(255);

update Nashville
set	OwnerStreetCity = PARSENAME(replace(OwnerAddress, ',' , '.') ,2)

alter table Nashville
add OwnerStreetState  nvarchar(255);

update Nashville
set	OwnerStreetState = PARSENAME(replace(OwnerAddress, ',' , '.') ,1)

select OwnerAddress,OwnerStreetAddress,OwnerStreetCity ,OwnerStreetState 
from Nashville


---changes Y and N to Yes and NO in "sold as vacant" field

select distinct(SoldAsVacant), COUNT(SoldAsVacant) as count
from Nashville
group by SoldAsVacant
order by 2


select SoldAsVacant,
		(Case 
			when SoldAsVacant = 'Y' then 'Yes'
			when SoldAsVacant = 'N' then 'No'
			else SoldAsVacant
			end) SoldAsVacantUpdated
				
from Nashville


update Nashville
set	SoldAsVacant = Case 
			when SoldAsVacant = 'Y' then 'Yes'
			when SoldAsVacant = 'N' then 'No'
			else SoldAsVacant
			end


select distinct(SoldAsVacant), COUNT(SoldAsVacant) as count
from Nashville
group by SoldAsVacant
order by 2


---remove duplicates

WITH RowNumCTE AS(
select *,
	ROW_NUMBER() over (
	partition by 
		ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		Order by 
			UniqueID
		) row_num
from Nashville)
--order by ParcelID

select *
from RowNumCTE


-- Delete Unused Columns



Select *
From Nashville


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
