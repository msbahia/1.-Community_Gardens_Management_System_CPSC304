-- UPDATE the Organization
-- This has 4 non-primary attributes (name budget, gardenID and address)
-- OrganizationID -> PK
-- gardenID is unique
-- Address + name -> FK
-- gardenID -> FK
-- lets update 


-- update Organization2
-- 	set budget = '42'
-- 	where OrganizationID = 'Org5001';

update Organization2
	set GardenID = GD0105
	where OrganizationID = 'Org5001';


-- UPDATE the CommunityGarden2
-- This table has several non-primary attributes:
-- - Name
-- - Address
-- - TotalPlots
-- - OccupiedPlots
-- - DailySunExposure
-- - MonthlyPrecipitation
-- GardenID -> PK (Primary Key)
-- Address -> UNIQUE constraint
-- TotalPlots and OccupiedPlots -> FK referencing CommunityGarden1(TotalPlots, OccupiedPlots) with ON DELETE CASCADE

-- Update Name
UPDATE CommunityGarden2
	SET Name = 'Cool Fun Spicy Garden'
	WHERE GardenID = 'GD0101';

-- Update Address
UPDATE CommunityGarden2
	SET Address = '1234 Garden Lane'
	WHERE GardenID = 'GD0101';

-- Update TotalPlots
UPDATE CommunityGarden2
	SET TotalPlots = 10
	WHERE GardenID = 'GD0101';

-- Update OccupiedPlots
UPDATE CommunityGarden2
	SET OccupiedPlots = 5
	WHERE GardenID = 'GD0101';

-- Update DailySunExposure
UPDATE CommunityGarden2
	SET DailySunExposure = 10
	WHERE GardenID = 'GD0101';

-- Update MonthlyPrecipitation
UPDATE CommunityGarden2
	SET MonthlyPrecipitation = 10
	WHERE GardenID = 'GD0101';