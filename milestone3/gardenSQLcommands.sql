DROP TABLE COMMUNITYGARDEN1 cascade constraints;
DROP TABLE COMMUNITYGARDEN2 cascade constraints;
DROP TABLE ORGANIZATION1 cascade constraints;
DROP TABLE ORGANIZATION2 cascade constraints;
DROP TABLE SUPPLIER1 cascade constraints;
DROP TABLE SUPPLIER2 cascade constraints;
DROP TABLE DeliveryRequest1 cascade constraints;
DROP TABLE DeliveryRequest2 cascade constraints;
DROP TABLE MATERIAL cascade constraints;
DROP TABLE Contains cascade constraints;
DROP TABLE SOIL cascade constraints;
DROP TABLE SEED cascade constraints;
DROP TABLE TOOL cascade constraints;
DROP TABLE Plot cascade constraints;
DROP TABLE UsedIn cascade constraints;
DROP TABLE Plant cascade constraints;
DROP TABLE GrowsIn cascade constraints;
DROP TABLE GARDENER1 cascade constraints;
DROP TABLE GARDENER2 cascade constraints;
DROP TABLE TendsTo cascade constraints;
DROP TABLE MemberOf cascade constraints;
DROP TABLE Event1 cascade constraints;
DROP TABLE Event2 cascade constraints;
DROP TABLE Attends cascade constraints;
DROP TABLE TASK cascade constraints;
DROP TABLE WATER cascade constraints;
DROP TABLE WEED cascade constraints;
DROP TABLE SOW cascade constraints;
DROP TABLE HARVEST cascade constraints;
DROP TABLE Performs cascade constraints;



-- FOREIGN KEY (PlotNumber) REFERENCES Plot(PlotNumber),
-- FOREIGN KEY (GardenID) REFERENCES CommunityGarden2(GardenID), 
-- removed from tables usedin, growsin, tendsto because
-- FK can't be set fot plot (plotnumber) because FK is only set for the PK not the part of PK
-- plotnumber is not a PK of plot but a part of the PK.



CREATE TABLE CommunityGarden1(
	TotalPlots int,
	OccupiedPlots int,
	AvailablePlots int,
	PRIMARY KEY (TotalPlots, OccupiedPlots)
	);

CREATE TABLE CommunityGarden2(
	GardenID varchar(255),
	Name varchar(255),
	Address varchar(255) NOT NULL UNIQUE,
	TotalPlots int,
	OccupiedPlots int,
	DailySunExposure int,
	MonthlyPrecipitation int,
	PRIMARY KEY (GardenID),
	FOREIGN KEY (TotalPlots, OccupiedPlots) REFERENCES CommunityGarden1(TotalPlots, OccupiedPlots)
		ON DELETE CASCADE
	);



CREATE TABLE Organization1(
	Name varchar(255),
	Address varchar(255),
	PhoneNumber varchar(255) NOT NULL,
	PRIMARY KEY (Name, Address)
	);

CREATE TABLE Organization2(
	OrganizationID varchar(255),
	Name varchar(255) NOT NULL,
	GardenID varchar(255) NOT NULL UNIQUE,
	Address varchar(255) NOT NULL,
	Budget int,
	PRIMARY KEY (OrganizationID),
	FOREIGN KEY (Name, Address) REFERENCES Organization1(Name, Address)
		ON DELETE CASCADE,
	FOREIGN KEY (GardenID) REFERENCES CommunityGarden2(GardenID)
		ON DELETE CASCADE
	);


CREATE TABLE Supplier1(
	Name varchar(255) NOT NULL,
	Address varchar(255) NOT NULL,
	PhoneNumber varchar(255) NOT NULL,
	PRIMARY KEY (Name, Address)
	);

CREATE TABLE Supplier2(
	SupplierID varchar(255),
	Name varchar(255) NOT NULL,
	Address varchar(255) NOT NULL,
	PRIMARY KEY (SupplierID),
	FOREIGN KEY (Name, Address) REFERENCES Supplier1(Name, Address)
		ON DELETE CASCADE
	);

CREATE TABLE DeliveryRequest1(
	TotalCost float,
	Quantity int,
	AvgCostPerUnit float,
	PRIMARY KEY (Quantity, AvgCostPerUnit)
	);

CREATE TABLE DeliveryRequest2(
	DeliveryID varchar(255),
	Status varchar(255),
	Quantity int,
	AvgCostPerUnit int,
	DateCreated date,
	DateFulfilled date,
	OrganizationID varchar(255) NOT NULL,
	SupplierID varchar(255) NOT NULL,
	PRIMARY KEY (DeliveryID),
	FOREIGN KEY (Quantity, AvgCostPerUnit) REFERENCES DeliveryRequest1(Quantity, AvgCostPerUnit)
		ON DELETE CASCADE,
	FOREIGN KEY (OrganizationID) REFERENCES Organization2(OrganizationID)
		ON DELETE CASCADE,
	FOREIGN KEY (SupplierID) REFERENCES Supplier2(SupplierID)
		ON DELETE CASCADE
	);

CREATE TABLE Material(
	MaterialID varchar(255),
	Name varchar(255) UNIQUE NOT NULL,
	PRIMARY KEY (MaterialID)
	);

CREATE TABLE Contains(
	DeliveryID varchar(255) NOT NULL,
	MaterialID varchar(255),
	PRIMARY KEY(DeliveryID, MaterialID),
	FOREIGN KEY (DeliveryID) REFERENCES DeliveryRequest2(DeliveryID)
		ON DELETE CASCADE,
	FOREIGN KEY (MaterialID) REFERENCES Material(MaterialID)
		ON DELETE CASCADE
	);

CREATE TABLE Soil(
	MaterialID varchar(255),
	Coverage varchar(255),
	Composition varchar(255),
	PRIMARY KEY (MaterialID),
	FOREIGN KEY (MaterialID) REFERENCES Material(MaterialID)
		ON DELETE CASCADE
	);

CREATE TABLE Seed(
	MaterialID varchar(255),
	Species varchar(255),
	PRIMARY KEY (MaterialID),
	FOREIGN KEY (MaterialID) REFERENCES Material(MaterialID)
		ON DELETE CASCADE
	);

CREATE TABLE Tool(
	MaterialID varchar(255),
	Function varchar(255),
	PRIMARY KEY (MaterialID),
	FOREIGN KEY (MaterialID) REFERENCES Material(MaterialID)
		ON DELETE CASCADE
	);

CREATE TABLE Plot(
	GardenID varchar(255) NOT NULL,
	PlotNumber varchar(255) NOT NULL,
	PlotSize int,
	Status varchar(255),
	PRIMARY KEY (GardenID, PlotNumber),
	FOREIGN KEY (GardenID) REFERENCES CommunityGarden2(GardenID)
		ON DELETE CASCADE
	);

CREATE TABLE UsedIn(
	GardenID varchar(255),
	PlotNumber varchar(255),
	MaterialID varchar(255),
	Quantity int,
	PRIMARY KEY (GardenID, MaterialID, PlotNumber),
	FOREIGN KEY (MaterialID) REFERENCES Material(MaterialID)
		ON DELETE CASCADE,
	FOREIGN KEY (PlotNumber, GardenID) REFERENCES Plot(PlotNumber, GardenID)
		ON DELETE CASCADE
	);


CREATE TABLE Plant(
	PlantID varchar(255),
	Species varchar(255) NOT NULL UNIQUE,
	DailySunRequirements int,
	MonthlyWaterRequirements int,
	PRIMARY KEY (PlantID)
	);

CREATE TABLE GrowsIn(
	PlantID varchar(255) NOT NULL,
	GardenID varchar(255),
	PlotNumber varchar(255),
	Quantity int NOT NULL,
	PRIMARY KEY (PlantID, GardenID, PlotNumber),
	FOREIGN KEY (PlantID) REFERENCES Plant(PlantID)
		ON DELETE CASCADE,
	FOREIGN KEY (PlotNumber, GardenID) REFERENCES Plot(PlotNumber, GardenID)
		ON DELETE CASCADE
	);

CREATE TABLE Gardener1(
	Name varchar(255) NOT NULL,
	Address varchar(255),
	PhoneNumber varchar(255) NOT NULL,
	PRIMARY KEY(Name, Address)
	);

CREATE TABLE Gardener2(
	GardenerID varchar(255),
	Name varchar(255) NOT NULL,
	Address varchar(255),
	PRIMARY KEY(GardenerID),
	FOREIGN KEY (Name, Address) REFERENCES Gardener1(Name, Address)
		ON DELETE CASCADE
	);

CREATE TABLE TendsTo(
	GardenerID varchar(255),
	GardenID varchar(255),
	PlotNumber varchar(255),
	PRIMARY KEY(GardenerID, GardenID, PlotNumber),
	FOREIGN KEY (GardenerID) REFERENCES Gardener2(GardenerID)
		ON DELETE CASCADE,
	FOREIGN KEY (PlotNumber, GardenID) REFERENCES Plot(PlotNumber, GardenID)
		ON DELETE CASCADE
	);

CREATE TABLE MemberOf(
	GardenerID varchar(255),
	GardenID varchar(255),
	Since date,
	PRIMARY KEY (GardenerID, GardenID),
	FOREIGN KEY (GardenerID) REFERENCES Gardener2(GardenerID)
		ON DELETE CASCADE,
	FOREIGN KEY (GardenID) REFERENCES CommunityGarden2(GardenID)
		ON DELETE CASCADE
	);

CREATE TABLE Event1(
	MaxCapacity int NOT NULL,
	Registered int NOT NULL,
	SpaceAvailable int NOT NULL,
	PRIMARY KEY(MaxCapacity, Registered)
	);

CREATE TABLE Event2(
	EventID varchar(255),
	Name varchar(255),
	Type varchar(255),
	EventDate date,
	MaxCapacity int NOT NULL,
	Registered int NOT NULL,
	GardenID varchar(255) NOT NULL,
	PRIMARY KEY(EventID),
	FOREIGN KEY (MaxCapacity, Registered) REFERENCES Event1(MaxCapacity, Registered)
		ON DELETE CASCADE,
	FOREIGN KEY (GardenID) REFERENCES CommunityGarden2(GardenID)
		ON DELETE CASCADE
	);

CREATE TABLE Attends(
	EventID varchar(255),
	GardenerID varchar(255),
	PRIMARY KEY (EventID, GardenerID),
	FOREIGN KEY (EventID) REFERENCES Event2(EventID)
		ON DELETE CASCADE,
	FOREIGN KEY (GardenerID) REFERENCES Gardener2(GardenerID)
		ON DELETE CASCADE
	);

CREATE TABLE Task(
	TaskID varchar(255),
	DateAssigned date NOT NULL,
	DateCompleted date,
	Status varchar(255) NOT NULL,
	PRIMARY KEY (TaskID)
	);

CREATE TABLE Water(
	TaskID varchar(255),
	Duration int,
	PRIMARY KEY (TaskID),
	FOREIGN KEY (TaskID) REFERENCES Task(TaskID)
		ON DELETE CASCADE
	);

CREATE TABLE Weed(
	TaskID varchar(255),
	Method varchar(255),
	PRIMARY KEY (TaskID),
	FOREIGN KEY (TaskID) REFERENCES Task(TaskID)
		ON DELETE CASCADE
	);

CREATE TABLE Sow(
	TaskID varchar(255),
	Species varchar(255),
	Season varchar(255),
	PRIMARY KEY (TaskID),
	FOREIGN KEY (TaskID) REFERENCES Task(TaskID)
		ON DELETE CASCADE
	);

CREATE TABLE Harvest(
	TaskID varchar(255),
	Species varchar(255),
	Season varchar(255),
	PRIMARY KEY (TaskID),
	FOREIGN KEY (TaskID) REFERENCES Task(TaskID)
		ON DELETE CASCADE
	);

CREATE TABLE Performs(
	GardenerID varchar(255),
	TaskID varchar(255),
	PRIMARY KEY(GardenerID, TaskID),
	FOREIGN KEY (GardenerID) REFERENCES Gardener2(GardenerID)
		ON DELETE CASCADE,
	FOREIGN KEY (TaskID) REFERENCES Task(TaskID)
		ON DELETE CASCADE
	);



-- Adding to CommunityGarden1

INSERT INTO CommunityGarden1 (TotalPlots, OccupiedPlots, AvailablePlots)
VALUES (19, 6, 13);
INSERT INTO CommunityGarden1 (TotalPlots, OccupiedPlots, AvailablePlots)
VALUES (17, 4, 13);
INSERT INTO CommunityGarden1 (TotalPlots, OccupiedPlots, AvailablePlots)
VALUES (21, 1, 20);
INSERT INTO CommunityGarden1 (TotalPlots, OccupiedPlots, AvailablePlots)
VALUES (28, 0, 28);
INSERT INTO CommunityGarden1 (TotalPlots, OccupiedPlots, AvailablePlots)
VALUES (54, 10, 44);

-- Adding to CommunityGarden2

INSERT INTO CommunityGarden2 (GardenID, Name, Address, TotalPlots, OccupiedPlots, DailySunExposure, MonthlyPrecipitation)
VALUES ('GD0101', 'East boulevard allotment plots', '11879 Gilmore Crescent, Vancouver', 19, 6, 5, 50);
INSERT INTO CommunityGarden2 (GardenID, Name, Address, TotalPlots, OccupiedPlots, DailySunExposure, MonthlyPrecipitation)
VALUES ('GD0102', 'Copley Community Orchards', '14173 68 Avenue, Vancouver', 17, 4, 5, 60);
INSERT INTO CommunityGarden2 (GardenID, Name, Address, TotalPlots, OccupiedPlots, DailySunExposure, MonthlyPrecipitation)
VALUES ('GD0103', 'John McBride Community Garden', '7324 55 Avenue, Vancouver', 21, 1, 3, 60);
INSERT INTO CommunityGarden2 (GardenID, Name, Address, TotalPlots, OccupiedPlots, DailySunExposure, MonthlyPrecipitation)
VALUES ('GD0104', 'Maple Community Garden', '87911 Kings Boulevard, Vancouver', 28, 0, 8, 45);
INSERT INTO CommunityGarden2 (GardenID, Name, Address, TotalPlots, OccupiedPlots, DailySunExposure, MonthlyPrecipitation)
VALUES ('GD0105', 'Ladybug Garden', '45 Steam Clock Street, Vancouver', 54, 10, 4, 25);

-- Adding Organization1

INSERT INTO Organization1 (Name, Address, PhoneNumber)
VALUES ('Vancouver Park Board', '2099 Beach Avenue, Vancouver', '+1 111 111 111');
INSERT INTO Organization1 (Name, Address, PhoneNumber)
VALUES ('Compley Park Board', '13 Queens Street, Beach Avenue, Vancouver', '+1 222 222 2222');
INSERT INTO Organization1 (Name, Address, PhoneNumber)
VALUES ('McBride Park Board', '45 Marine Drive, Vancouver', '+1 333 333 3333');
INSERT INTO Organization1 (Name, Address, PhoneNumber)
VALUES ('Maple Park Board', '453 Cambie Street, Vancouver', '+1 444 444 4444');
INSERT INTO Organization1 (Name, Address, PhoneNumber)
VALUES ('LadyBug Park Board', '150 Rosewat Street, Vancouver', '+1 555 555 5555');

--Adding Organization2

INSERT INTO Organization2 (OrganizationID, Name, GardenID, Address, Budget)
VALUES ('Org5001', 'Vancouver Park Board', 'GD0101', '2099 Beach Avenue, Vancouver', 100);
INSERT INTO Organization2 (OrganizationID, Name, GardenID, Address, Budget)
VALUES ('Org5002', 'Compley Park Board', 'GD0102', '13 Queens Street, Beach Avenue, Vancouver', 100);
INSERT INTO Organization2 (OrganizationID, Name, GardenID, Address, Budget)
VALUES ('Org5003', 'McBride Park Board', 'GD0103', '45 Marine Drive, Vancouver', 50);
INSERT INTO Organization2 (OrganizationID, Name, GardenID, Address, Budget)
VALUES ('Org5004', 'Maple Park Board', 'GD0104', '453 Cambie Street, Vancouver', 30);
INSERT INTO Organization2 (OrganizationID, Name, GardenID, Address, Budget)
VALUES ('Org5005', 'LadyBug Park Board', 'GD0105', '150 Rosewat Street, Vancouver', 34);

-- --Adding Supplier1

INSERT INTO Supplier1 (Name, Address, PhoneNumber)
VALUES ( 'Home Depot', '120 Burnaby', '675 483 6633');
INSERT INTO Supplier1 (Name, Address, PhoneNumber)
VALUES ( 'JYSK', '122 Delta', '345 341 8888');
INSERT INTO Supplier1 (Name, Address, PhoneNumber)
VALUES ( 'Walmart', '56 Surrey', '783 783 9999');
INSERT INTO Supplier1 (Name, Address, PhoneNumber)
VALUES ( 'Costco', '78 Richmond', '232 783 7777');
INSERT INTO Supplier1 (Name, Address, PhoneNumber)
VALUES ( 'Staples', '12 Coquitlam', '344 532 444');

-- -- Adding Supplier2

INSERT INTO Supplier2 (SupplierID, Name, Address)
VALUES ('SuP21', 'Home Depot', '120 Burnaby');
INSERT INTO Supplier2 (SupplierID, Name, Address)
VALUES ('SuP22', 'JYSK', '122 Delta');
INSERT INTO Supplier2 (SupplierID, Name, Address)
VALUES ('SuP23', 'Walmart', '56 Surrey');
INSERT INTO Supplier2 (SupplierID, Name, Address)
VALUES ('SuP24', 'Costco', '78 Richmond');
INSERT INTO Supplier2 (SupplierID, Name, Address)
VALUES ('SuP25', 'Staples', '12 Coquitlam');

-- -- Adding DeliveryRequest1

INSERT INTO DeliveryRequest1 (TotalCost, Quantity, AvgCostPerUnit)
VALUES (120, 3, 40);
INSERT INTO DeliveryRequest1 (TotalCost, Quantity, AvgCostPerUnit)
VALUES (150, 5, 30);
INSERT INTO DeliveryRequest1 (TotalCost, Quantity, AvgCostPerUnit)
VALUES (28, 7, 4);
INSERT INTO DeliveryRequest1 (TotalCost, Quantity, AvgCostPerUnit)
VALUES (56, 2, 23);
INSERT INTO DeliveryRequest1 (TotalCost, Quantity, AvgCostPerUnit)
VALUES (200, 10, 20);

-- -- Adding DeliveryRequest2

INSERT INTO DeliveryRequest2 (DeliveryID, Status, AvgCostPerUnit, Quantity, OrganizationID, SupplierID, DateCreated, DateFulfilled)
VALUES ('Del4567', 'Fulfilled', 40, 3, 'Org5001', 'SuP21', to_date('2023-06-12', 'yyyy-mm-dd'),  to_date('2023-06-22', 'yyyy-mm-dd'));
INSERT INTO DeliveryRequest2 (DeliveryID, Status, AvgCostPerUnit, Quantity, OrganizationID, SupplierID, DateCreated, DateFulfilled)
VALUES ('Del6432', 'in process', 30, 5, 'Org5001', 'SuP21', to_date('2023-02-16', 'yyyy-mm-dd'), NULL);
INSERT INTO DeliveryRequest2 (DeliveryID, Status, AvgCostPerUnit, Quantity, OrganizationID, SupplierID, DateCreated, DateFulfilled)
VALUES ('Del9072', 'delayed', 4, 7, 'Org5003', 'SuP22', to_date('2023-08-19', 'yyyy-mm-dd'), NULL);
INSERT INTO DeliveryRequest2 (DeliveryID, Status, AvgCostPerUnit, Quantity, OrganizationID, SupplierID, DateCreated, DateFulfilled)
VALUES ('Del8975', 'in process', 23, 2, 'Org5004', 'SuP23', to_date('2023-02-23', 'yyyy-mm-dd'), NULL);
INSERT INTO DeliveryRequest2 (DeliveryID, Status, AvgCostPerUnit, Quantity, OrganizationID, SupplierID, DateCreated, DateFulfilled)
VALUES ('Del3526', 'fulfilled', 20, 10, 'Org5005', 'SuP24', to_date('2023-07-22', 'yyyy-mm-dd'), to_date('2023-08-20' ,'yyyy-mm-dd'));

-- -- Adding Material

INSERT INTO Material (MaterialID, Name)
VALUES (1001, 'Soil and Mulch');
INSERT INTO Material (MaterialID, Name)
VALUES (1002, 'Seeds');
INSERT INTO Material (MaterialID, Name)
VALUES (1003, 'Tools');
INSERT INTO Material (MaterialID, Name)
VALUES (1004, 'Plants');
INSERT INTO Material (MaterialID, Name)
VALUES (1005, 'Fertilizers');

-- -- Adding Contains

INSERT INTO Contains (DeliveryID, MaterialID)
VALUES ('Del4567', '1001');
INSERT INTO Contains (DeliveryID, MaterialID)
VALUES ('Del6432', '1002');
INSERT INTO Contains (DeliveryID, MaterialID)
VALUES ('Del9072', '1003');
INSERT INTO Contains (DeliveryID, MaterialID)
VALUES ('Del8975', '1004');
INSERT INTO Contains (DeliveryID, MaterialID)
VALUES ('Del3526', '1005');

-- -- Adding Soil

INSERT INTO Soil (MaterialID, Coverage, Composition)
VALUES (1001, 'organic mulch', 'loamy soil');
INSERT INTO Soil (MaterialID, Coverage, Composition)
VALUES (1002, 'bark chips', 'sandy soil');
INSERT INTO Soil (MaterialID, Coverage, Composition)
VALUES (1003, 'gravel', 'clayey soil');
INSERT INTO Soil (MaterialID, Coverage, Composition)
VALUES (1004, 'wood shavings', 'peat soil');
INSERT INTO Soil (MaterialID, Coverage, Composition)
VALUES (1005, 'straw', 'silt soil');

-- -- Adding Seed

INSERT INTO Seed (MaterialID, Species)
VALUES (1001, 'tomato');
INSERT INTO Seed (MaterialID, Species)
VALUES (1002, 'carrot');
INSERT INTO Seed (MaterialID, Species)
VALUES (1003, 'lettuce');
INSERT INTO Seed (MaterialID, Species)
VALUES (1004, 'sunflower');
INSERT INTO Seed (MaterialID, Species)
VALUES (1005, 'basil');

-- -- Adding Tool

INSERT INTO Tool (MaterialID, Function)
VALUES (1001, 'trimming');
INSERT INTO Tool (MaterialID, Function)
VALUES (1002, 'Digging');
INSERT INTO Tool (MaterialID, Function)
VALUES (1003, 'soil leveling');
INSERT INTO Tool (MaterialID, Function)
VALUES (1004, 'weeding');
INSERT INTO Tool (MaterialID, Function)
VALUES (1005, 'loosening soil');

-- -- Adding Plot

INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
VALUES ('Plot01', 'GD0101',  100, 'occupied');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
VALUES ('Plot02', 'GD0102', 250, 'occupied');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
VALUES ('Plot03', 'GD0101', 100, 'available');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
VALUES ('Plot01', 'GD0103', 50, 'available');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
VALUES ('Plot03', 'GD0104', 300, 'occupied');

-- -- Adding UsedIn

INSERT INTO UsedIn (GardenID, PlotNumber, MaterialID, Quantity)
VALUES ('GD0101', 'Plot01', 1001, 5);
INSERT INTO UsedIn (GardenID, PlotNumber, MaterialID, Quantity)
VALUES ('GD0102', 'Plot02', 1002, 4);
INSERT INTO UsedIn (GardenID, PlotNumber, MaterialID, Quantity)
VALUES ('GD0101', 'Plot03', 1003, 7);
INSERT INTO UsedIn (GardenID, PlotNumber, MaterialID, Quantity)
VALUES ('GD0103', 'Plot01', 1004, 3);
INSERT INTO UsedIn (GardenID, PlotNumber, MaterialID, Quantity)
VALUES ('GD0104', 'Plot03', 1004, 2);

-- -- Adding Plant

INSERT INTO Plant (PlantID, Species, MonthlyWaterRequirements, DailySunRequirements)
VALUES ('plant101', 'rose', 250, 4);
INSERT INTO Plant (PlantID, Species, MonthlyWaterRequirements, DailySunRequirements)
VALUES ('plant102', 'cactus', 300, 5);
INSERT INTO Plant (PlantID, Species, MonthlyWaterRequirements, DailySunRequirements)
VALUES ('plant103', 'citrus', 500, 3);
INSERT INTO Plant (PlantID, Species, MonthlyWaterRequirements, DailySunRequirements)
VALUES ('plant104', 'lily', 200, 7);
INSERT INTO Plant (PlantID, Species, MonthlyWaterRequirements, DailySunRequirements)
VALUES ('plant105', 'succulent', 350, 1);

-- -- Adding GrowsIn

INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
VALUES ('plant101', 'Plot01', 'GD0101', 60);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
VALUES ('plant102', 'Plot02', 'GD0102', 44);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
VALUES ('plant105', 'Plot03', 'GD0101', 81);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
VALUES ('plant104', 'Plot01', 'GD0103', 18);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
VALUES ('plant104', 'Plot03', 'GD0104', 18);

-- -- Adding Gardener1

INSERT INTO Gardener1 (Name, Address, PhoneNumber)
VALUES ('Malkeet S',  '123 2nd street, Vancouver', '+1 456 345 8755');
INSERT INTO Gardener1 (Name, Address, PhoneNumber)
VALUES ('Justin B',  '345 4th street, Vancouver', '+1 235 896 5292');
INSERT INTO Gardener1 (Name, Address, PhoneNumber)
VALUES ('Emilyn S',  '786 8th street, Vancouver', '+1 756 456 0978');
INSERT INTO Gardener1 (Name, Address, PhoneNumber)
VALUES ('Gregor Burger',  '707 3rd street, Vancouver', '+1 897 563 6734');
INSERT INTO Gardener1 (Name, Address, PhoneNumber)
VALUES ('Gregor Burger',  '503 7th street, Vancouver', '+1 604 287 2787');

-- -- Adding Gardener2

INSERT INTO Gardener2 (GardenerID, Name, Address)
VALUES ('G007', 'Malkeet S', '123 2nd street, Vancouver');
INSERT INTO Gardener2 (GardenerID, Name, Address)
VALUES ('G008', 'Justin B',  '345 4th street, Vancouver');
INSERT INTO Gardener2 (GardenerID, Name, Address)
VALUES ('G009', 'Emilyn S',  '786 8th street, Vancouver');
INSERT INTO Gardener2 (GardenerID, Name, Address)
VALUES ('G010', 'Gregor Burger', '707 3rd street, Vancouver');
INSERT INTO Gardener2 (GardenerID, Name, Address)
VALUES ('G011', 'Gregor Burger', '503 7th street, Vancouver');

-- -- Adding TendsTo

INSERT INTO TendsTo (PlotNumber, GardenID, GardenerID)
VALUES ('Plot01', 'GD0101', 'G007');
INSERT INTO TendsTo (PlotNumber, GardenID, GardenerID)
VALUES ('Plot02', 'GD0102', 'G008');
INSERT INTO TendsTo (PlotNumber, GardenID, GardenerID)
VALUES ('Plot03', 'GD0101', 'G009');
INSERT INTO TendsTo (PlotNumber, GardenID, GardenerID)
VALUES ('Plot01', 'GD0103', 'G010');
INSERT INTO TendsTo (PlotNumber, GardenID, GardenerID)
VALUES ('Plot03', 'GD0104', 'G011');



-- -- Adding MemberOf

INSERT INTO MemberOf (GardenID, GardenerId, Since)
VALUES ('GD0101', 'G007', to_date('2020-01-23', 'yyyy-mm-dd'));
INSERT INTO MemberOf (GardenID, GardenerId, Since)
VALUES ('GD0101', 'G008', to_date('2017-01-22', 'yyyy-mm-dd'));
INSERT INTO MemberOf (GardenID, GardenerId, Since)
VALUES ('GD0101', 'G009', to_date('2020-01-23', 'yyyy-mm-dd'));
INSERT INTO MemberOf (GardenID, GardenerId, Since)
VALUES ('GD0104', 'G007', to_date('2016-05-16', 'yyyy-mm-dd'));
INSERT INTO MemberOf (GardenID, GardenerId, Since)
VALUES ('GD0105', 'G007', to_date('2014-05-27', 'yyyy-mm-dd'));

-- -- Adding Event1

INSERT INTO Event1 (MaxCapacity, Registered, SpaceAvailable)
VALUES (40, 35, 5);
INSERT INTO Event1 (MaxCapacity, Registered, SpaceAvailable)
VALUES (30, 15, 15);
INSERT INTO Event1 (MaxCapacity, Registered, SpaceAvailable)
VALUES (40, 32, 8);
INSERT INTO Event1 (MaxCapacity, Registered, SpaceAvailable)
VALUES (15, 5, 10);
INSERT INTO Event1 (MaxCapacity, Registered, SpaceAvailable)
VALUES (50, 47, 3);

-- -- Adding Event2

INSERT INTO Event2 (EventID, Name, GardenID, Type, MaxCapacity, Registered)
VALUES ('E1001', 'Spring garden festival', 'GD0101', 'festival', 40, 35);
INSERT INTO Event2 (EventID, Name, GardenID, Type, MaxCapacity, Registered)
VALUES ('E1002', 'Yoga in garden', 'GD0101', 'fitness', 30, 15);
INSERT INTO Event2 (EventID, Name, GardenID, Type, MaxCapacity, Registered)
VALUES ('E1003', 'Gardening for beginners', 'GD0103', 'educational', 40, 32);
INSERT INTO Event2 (EventID, Name, GardenID, Type, MaxCapacity, Registered)
VALUES ('E1004', 'Gardening workshop', 'GD0104', 'educational', 15, 5);
INSERT INTO Event2 (EventID, Name, GardenID, Type, MaxCapacity, Registered)
VALUES ('E1005', 'Garden tour', 'GD0105', 'tour', 50, 47);

-- -- Adding Attends

INSERT INTO Attends (EventID, GardenerID)
VALUES ('E1001', 'G007');
INSERT INTO Attends (EventID, GardenerID)
VALUES ('E1002', 'G008');
INSERT INTO Attends (EventID, GardenerID)
VALUES ('E1002', 'G009');
INSERT INTO Attends (EventID, GardenerID)
VALUES ('E1003', 'G010');
INSERT INTO Attends (EventID, GardenerID)
VALUES ('E1004', 'G011');

-- -- Adding Task

INSERT INTO Task (TaskID, DateAssigned, DateCompleted, Status)
VALUES ('T001', to_date('2023-01-20', 'yyyy-mm-dd'), to_date('2023-01-22', 'yyyy-mm-dd'), 'completed');
INSERT INTO Task (TaskID, DateAssigned, DateCompleted, Status)
VALUES ('T002', to_date('2023-01-20', 'yyyy-mm-dd'), to_date('2023-01-22', 'yyyy-mm-dd'), 'completed');
INSERT INTO Task (TaskID, DateAssigned, DateCompleted, Status)
VALUES ('T003', to_date('2023-03-22','yyyy-mm-dd'), NULL, 'ongoing');
INSERT INTO Task (TaskID, DateAssigned, DateCompleted, Status)
VALUES ('T004', to_date('2023-04-23', 'yyyy-mm-dd'), to_date('2023-05-21','yyyy-mm-dd'), 'completed');
INSERT INTO Task (TaskID, DateAssigned, DateCompleted, Status)
VALUES ('T005', to_date('2023-05-24', 'yyyy-mm-dd'), NULL, 'ongoing');

-- -- Adding Water

INSERT INTO Water (TaskID, Duration)
VALUES ('T001', 3);
INSERT INTO Water (TaskID, Duration)
VALUES ('T002', 4);
INSERT INTO Water (TaskID, Duration)
VALUES ('T003', 2);
INSERT INTO Water (TaskID, Duration)
VALUES ('T004', 1);
INSERT INTO Water (TaskID, Duration)
VALUES ('T005', 5);

-- -- Adding Weed

INSERT INTO Weed (TaskID, Method)
VALUES ('T001', 'HandPulling');
INSERT INTO Weed (TaskID, Method)
VALUES ('T002', 'Mulching');
INSERT INTO Weed (TaskID, Method)
VALUES ('T003', 'Chemical');
INSERT INTO Weed (TaskID, Method)
VALUES ('T004', 'Mowing');
INSERT INTO Weed (TaskID, Method)
VALUES ('T005', 'Hoeing');

-- -- Adding Sow

INSERT INTO Sow (TaskID, Species, Season)
VALUES ('T001', 'carrots', 'spring');
INSERT INTO Sow (TaskID, Species, Season)
VALUES ('T002', 'tomatoes', 'summer');
INSERT INTO Sow (TaskID, Species, Season)
VALUES ('T003', 'cucumber', 'summer');
INSERT INTO Sow (TaskID, Species, Season)
VALUES ('T004', 'lettuce', 'winter');
INSERT INTO Sow (TaskID, Species, Season)
VALUES ('T005', 'lettuce', 'fall');

-- -- Adding Harvest

INSERT INTO Harvest (TaskID, Species, Season)
VALUES ('T001', 'Strawberries', 'summer');
INSERT INTO Harvest (TaskID, Species, Season)
VALUES ('T002', 'pumpkin', 'fall');
INSERT INTO Harvest (TaskID, Species, Season)
VALUES ('T003', 'apples', 'autumn');
INSERT INTO Harvest (TaskID, Species, Season)
VALUES ('T004', 'pepper', 'summer');
INSERT INTO Harvest (TaskID, Species, Season)
VALUES ('T005', 'broccoli', 'winter');

-- -- Adding Performs

INSERT INTO Performs (GardenerID, TaskID)
VALUES ('G007', 'T001');
INSERT INTO Performs (GardenerID, TaskID)
VALUES ('G007', 'T002');
INSERT INTO Performs (GardenerID, TaskID)
VALUES ('G008', 'T002');
INSERT INTO Performs (GardenerID, TaskID)
VALUES ('G008', 'T001');
INSERT INTO Performs (GardenerID, TaskID)
VALUES ('G009', 'T003');








