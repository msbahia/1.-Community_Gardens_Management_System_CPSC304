drop table ATTENDS cascade constraints;
drop table COMMUNITYGARDEN cascade constraints;
drop table CONTAINS cascade constraints;
drop table DELIVERYREQUEST1 cascade constraints;
drop table DELIVERYREQUEST2 cascade constraints;
drop table EVENT1 cascade constraints;
drop table EVENT2 cascade constraints;
drop table GARDENER1 cascade constraints;
drop table GARDENER2 cascade constraints;
drop table GROWSIN cascade constraints;
drop table HARVEST cascade constraints;
drop table MATERIAL cascade constraints;
drop table MEMBEROF cascade constraints;
drop table ORGANIZATION cascade constraints;
drop table PERFORMS cascade constraints;
drop table PLANT cascade constraints;
drop table PLOT cascade constraints;
drop table SEED cascade constraints;
drop table SOIL cascade constraints;
drop table SOW cascade constraints;
drop table SUPPLIER1 cascade constraints;
drop table SUPPLIER2 cascade constraints;
drop table TASK cascade constraints;
drop table TENDSTO cascade constraints;
drop table TOOL cascade constraints;
drop table USEDIN cascade constraints;
drop table WATER cascade constraints;
drop table WEED cascade constraints;

CREATE TABLE CommunityGarden(
	GardenId INT,
	Name VARCHAR(100),
	Address VARCHAR(100) NOT NULL UNIQUE,
	TotalPlots INT NOT NULL,
	AvailablePlots INT NOT NULL,
	DailySunExposure INT,
	MonthlyPrecipitation INT,
	OrganizationId INT NOT NULL,
	PRIMARY KEY (GardenId)
);

CREATE TABLE Organization(
	OrganizationID INT,
	Name VARCHAR(100),
	Address VARCHAR(100),
	Budget INT,
	PhoneNumber VARCHAR(100) UNIQUE,
	PRIMARY KEY (OrganizationID)
);

CREATE TABLE DeliveryRequest1(
	DeliveryID INT,
	Status VARCHAR(100) NOT NULL,
	Quantity INT NOT NULL,
	AvgCostPerUnit FLOAT NOT NULL,
	DateCreated DATE NOT NULL,
	DateFulfilled DATE,
	OrganizationID INT NOT NULL,
	SupplierID INT NOT NULL,
	PRIMARY KEY (DeliveryID)
);

CREATE TABLE DeliveryRequest2(
	Quantity INT,
	AvgCostPerUnit FLOAT,
	TotalCost FLOAT NOT NULL,
	PRIMARY KEY (Quantity, AvgCostPerUnit)
);

CREATE TABLE Supplier1(
	SupplierID INT,
	Name VARCHAR(100) NOT NULL,
	Address VARCHAR(100) NOT NULL,
	PRIMARY KEY (SupplierID)
);

CREATE TABLE Supplier2(
	Name VARCHAR(100),
	Address VARCHAR(100),
	PhoneNumber VARCHAR(100) NOT NULL,
	PRIMARY KEY (Name, Address)
);

CREATE TABLE Contains(
	DeliveryID INT,
	MaterialID INT,
	PRIMARY KEY(DeliveryID, MaterialID)
);

CREATE TABLE Material(
	MaterialID INT,
	Name VARCHAR(100) UNIQUE NOT NULL,
	PRIMARY KEY (MaterialID)
);

CREATE TABLE Soil(
	MaterialID INT,
	Coverage INT,
	Composition VARCHAR(100),
	PRIMARY KEY (MaterialID)
);

CREATE TABLE Seed(
	MaterialID INT,
	Species VARCHAR(100),
	PRIMARY KEY (MaterialID)
);

CREATE TABLE Tool(
	MaterialID INT,
	Function VARCHAR(100),
	PRIMARY KEY (MaterialID)
);

CREATE TABLE Plot(
	GardenID INT,
	PlotNumber INT,
	PlotSize INT,
	Status VARCHAR(100),
	PRIMARY KEY (GardenID, PlotNumber)
);

CREATE TABLE UsedIn(
	GardenID INT,
	PlotNumber INT,
	MaterialID INT,
	Quantity INT,
	PRIMARY KEY (GardenID, MaterialID, PlotNumber)
);

CREATE TABLE Plant(
	PlantID INT,
	Species VARCHAR(100) NOT NULL UNIQUE,
	DailySunRequirements INT,
	MonthlyWaterRequirements INT,
	PRIMARY KEY (PlantID)
);

CREATE TABLE GrowsIn(
	PlantID INT,
	GardenID INT,
	PlotNumber INT,
	Quantity INT NOT NULL,
	PRIMARY KEY (PlantID, GardenID, PlotNumber)
);

CREATE TABLE Gardener1(
	GardenerID INT,
	Name VARCHAR(100) NOT NULL,
	Address VARCHAR(100) NOT NULL,
	PRIMARY KEY(GardenerID)
);

CREATE TABLE Gardener2(
	Name VARCHAR(100),
	Address VARCHAR(100),
	PhoneNumber VARCHAR(100) NOT NULL,
	PRIMARY KEY(Name, Address)
);

CREATE TABLE TendsTo(
	GardenerID INT,
	GardenID INT,
	PlotNumber INT,
	PRIMARY KEY(GardenerID, GardenID, PlotNumber)
 );

CREATE TABLE MemberOf(
	GardenerID INT,
	GardenID INT,
	Since DATE,
	PRIMARY KEY (GardenerID, GardenID)
);

CREATE TABLE Event1(
	EventID INT,
	Name VARCHAR(100),
	Type VARCHAR(100),
	EventDate DATE,
	MaxCapacity INT NOT NULL,
	Registered INT NOT NULL,
	GardenID INT,
	PRIMARY KEY(EventID)
);

CREATE TABLE Event2(
	MaxCapacity INT,
	Registered INT,
	SpaceAvailable INT NOT NULL,
	PRIMARY KEY(MaxCapacity, Registered)
);

CREATE TABLE Attends(
	EventID INT,
	GardenerID INT,
	PRIMARY KEY (EventID, GardenerID)
);

CREATE TABLE Task(
	TaskID INT,
	DateAssigned DATE NOT NULL,
	DateCompleted DATE,
	Status VARCHAR(100) NOT NULL,
	PRIMARY KEY (TaskID)	
);

CREATE TABLE Water(
	TaskID INT,
	Duration INT,
	PRIMARY KEY (TaskID)
 );

CREATE TABLE Weed(
	TaskID INT,
	Method VARCHAR(100),
	PRIMARY KEY (TaskID)
);

CREATE TABLE Sow(
	TaskID INT,
	Species VARCHAR(100),
	Season VARCHAR(100),
	PRIMARY KEY (TaskID)
);

CREATE TABLE Harvest(
	TaskID INT,
	Species VARCHAR(100),
	Season VARCHAR(100),
	PRIMARY KEY (TaskID)
);

CREATE TABLE Performs(
	GardenerID INT,
	TaskID INT,
	PRIMARY KEY(GardenerID, TaskID)
);

ALTER TABLE CommunityGarden ADD(
	FOREIGN KEY (OrganizationId)
		REFERENCES Organization(OrganizationId)
);

ALTER TABLE DeliveryRequest1 ADD(
	FOREIGN KEY (Quantity, AvgCostPerUnit)
		REFERENCES DeliveryRequest2(Quantity, AvgCostPerUnit),
	FOREIGN KEY (OrganizationID) 
		REFERENCES Organization(OrganizationID)
		ON DELETE CASCADE,
	FOREIGN KEY (SupplierID) 
		REFERENCES Supplier1(SupplierID)
		ON DELETE CASCADE
);

ALTER TABLE Supplier1 ADD(
	FOREIGN KEY (Name, Address) 
		REFERENCES Supplier2(Name, Address)
);

ALTER TABLE Contains ADD(
	FOREIGN KEY (DeliveryID)
 		REFERENCES DeliveryRequest1(DeliveryID),
	FOREIGN KEY (MaterialID) 
		REFERENCES Material(MaterialID)
);

ALTER TABLE Soil ADD(
	FOREIGN KEY (MaterialID) 
		REFERENCES Material(MaterialID)
);

ALTER TABLE Seed ADD(
	FOREIGN KEY (MaterialID) 
		REFERENCES Material(MaterialID)
);

ALTER TABLE Tool ADD(
	FOREIGN KEY (MaterialID) 
		REFERENCES Material(MaterialID)
);

ALTER TABLE Plot ADD(
	FOREIGN KEY (GardenID) 
		REFERENCES CommunityGarden(GardenID)
		ON DELETE CASCADE
);

ALTER TABLE UsedIn ADD(
	FOREIGN KEY (GardenID, PlotNumber) 
		REFERENCES Plot(GardenID, PlotNumber)
		ON DELETE CASCADE,
	FOREIGN KEY (MaterialID) 
		REFERENCES Material(MaterialID)
		ON DELETE CASCADE
);

ALTER TABLE GrowsIn ADD(
	FOREIGN KEY (PlantID) 
		REFERENCES Plant(PlantID)
		ON DELETE CASCADE,
	FOREIGN KEY (GardenID, PlotNumber) 
		REFERENCES Plot(GardenID, PlotNumber)
		ON DELETE CASCADE
);

ALTER TABLE Gardener1 ADD(
	FOREIGN KEY (Name, Address) 
		REFERENCES Gardener2(Name, Address)
);

ALTER TABLE TendsTo ADD(
	FOREIGN KEY (GardenerID) 
		REFERENCES Gardener1(GardenerID)
		ON DELETE CASCADE,
	FOREIGN KEY (GardenID, PlotNumber) 
		REFERENCES Plot(GardenID, PlotNumber)
		ON DELETE CASCADE
);

ALTER TABLE MemberOf ADD(
	FOREIGN KEY (GardenerID) 
		REFERENCES Gardener1(GardenerID),
	FOREIGN KEY (GardenID) 
		REFERENCES CommunityGarden(GardenID)
		ON DELETE CASCADE
);

ALTER TABLE Event1 ADD(
	FOREIGN KEY (MaxCapacity, Registered) 
		REFERENCES Event2(MaxCapacity, Registered),
	FOREIGN KEY (GardenID) 
		REFERENCES CommunityGarden(GardenID)
		ON DELETE SET NULL
);

ALTER TABLE Attends ADD(
	FOREIGN KEY (EventID) 
		REFERENCES Event1(EventID),
	FOREIGN KEY (GardenerID) 
		REFERENCES Gardener1(GardenerID)
);

ALTER TABLE Water ADD(
	FOREIGN KEY (TaskID)
 		REFERENCES Task(TaskID)
 );

ALTER TABLE Weed ADD(
	FOREIGN KEY (TaskID) 
		REFERENCES Task(TaskID)
);

ALTER TABLE Sow ADD(
	FOREIGN KEY (TaskID)
 		REFERENCES Task(TaskID)
);


ALTER TABLE Harvest ADD(
	FOREIGN KEY (TaskID) 
		REFERENCES Task(TaskID)
);

ALTER TABLE Performs ADD(
	FOREIGN KEY (GardenerID) 
		REFERENCES Gardener1(GardenerID),
	FOREIGN KEY (TaskID)
 		REFERENCES Task(TaskID)
);

INSERT INTO Organization (OrganizationID, Name, Address, Budget, PhoneNumber)
	VALUES (5001, 'Vancouver Park Board', '2099 Beach Avenue, Vancouver', 100, '604-311-1111');
INSERT INTO Organization (OrganizationID, Name, Address, Budget, PhoneNumber)
	VALUES (5002, 'Compley Park Board', '13 Queens Street, Beach Avenue, Vancouver', 100, '604-123-4567');
INSERT INTO Organization (OrganizationID, Name, Address, Budget, PhoneNumber)
	VALUES (5003, 'McBride Park Board', '45 Marine Drive, Vancouver', 50, '604-113-3333');
INSERT INTO Organization (OrganizationID, Name, Address, Budget, PhoneNumber)
	VALUES (5004, 'Maple Park Board', '453 Cambie Street, Vancouver', 30, '604-585-1245');
INSERT INTO Organization (OrganizationID, Name, Address, Budget, PhoneNumber)
	VALUES (5005, 'LadyBug Park Board', '150 Rosewat Street, Vancouver', 34, '604-788-6565');
INSERT INTO Organization (OrganizationID, Name, Address, Budget, PhoneNumber)
	VALUES (5006, 'Trout Lake Community Centre', '1234 Victoria Drive, Vancouver', 500, '604-111-1111');

INSERT INTO CommunityGarden (GardenId, Name, Address, TotalPlots, AvailablePlots, DailySunExposure, MonthlyPrecipitation, OrganizationID)
	VALUES (101, 'East Boulevard Allotment Plots', '11879 Gilmore Crescent, Vancouver', 7, 2, 5, 50, 5001);
INSERT INTO CommunityGarden (GardenId, Name, Address, TotalPlots, AvailablePlots, DailySunExposure, MonthlyPrecipitation, OrganizationID)
	VALUES (102, 'Copley Community Orchards', '14173 68 Avenue, Vancouver', 6, 2, 5, 60, 5002);
INSERT INTO CommunityGarden (GardenId, Name, Address, TotalPlots, AvailablePlots, DailySunExposure, MonthlyPrecipitation, OrganizationID)
	VALUES (103, 'John McBride Community Garden', '7324 55 Avenue, Vancouver', 5, 1, 3, 60, 5003);
INSERT INTO CommunityGarden (GardenId, Name, Address, TotalPlots, AvailablePlots, DailySunExposure, MonthlyPrecipitation, OrganizationID)
	VALUES (104, 'Maple Community Garden', '87911 Kings Boulevard, Vancouver', 5, 3, 8, 45, 5004);
INSERT INTO CommunityGarden (GardenId, Name, Address, TotalPlots, AvailablePlots, DailySunExposure, MonthlyPrecipitation, OrganizationID)
	VALUES (105, 'Ladybug Garden', '45 Steam Clock Street, Vancouver', 4, 0, 4, 25, 5005);

INSERT INTO Supplier2 (Name, Address, PhoneNumber)
	VALUES ( 'Home Depot', '120 Burnaby', '675 483 6633');
INSERT INTO Supplier2 (Name, Address, PhoneNumber)
	VALUES ( 'JYSK', '122 Delta', '345 341 8888');
INSERT INTO Supplier2 (Name, Address, PhoneNumber)
	VALUES ( 'Walmart', '56 Surrey', '783 783 9999');
INSERT INTO Supplier2 (Name, Address, PhoneNumber)
	VALUES ( 'Costco', '78 Richmond', '232 783 7777');
INSERT INTO Supplier2 (Name, Address, PhoneNumber)
	VALUES ( 'Staples', '12 Coquitlam', '344 532 444');

INSERT INTO Supplier1 (SupplierID, Name, Address)
	VALUES (21, 'Home Depot', '120 Burnaby');
INSERT INTO Supplier1 (SupplierID, Name, Address)
	VALUES (22, 'JYSK', '122 Delta');
INSERT INTO Supplier1 (SupplierID, Name, Address)
	VALUES (23, 'Walmart', '56 Surrey');
INSERT INTO Supplier1 (SupplierID, Name, Address)
	VALUES (24, 'Costco', '78 Richmond');
INSERT INTO Supplier1 (SupplierID, Name, Address)
	VALUES (25, 'Staples', '12 Coquitlam');

INSERT INTO DeliveryRequest2 (TotalCost, Quantity, AvgCostPerUnit)
	VALUES (30, 3, 10);
INSERT INTO DeliveryRequest2 (TotalCost, Quantity, AvgCostPerUnit)
	VALUES (200.00, 10, 20.00);
INSERT INTO DeliveryRequest2 (TotalCost, Quantity, AvgCostPerUnit)
	VALUES (250, 10, 25);
INSERT INTO DeliveryRequest2 (TotalCost, Quantity, AvgCostPerUnit)
	VALUES (500, 10, 50);
INSERT INTO DeliveryRequest2 (TotalCost, Quantity, AvgCostPerUnit)
	VALUES (220, 11, 20);

INSERT INTO DeliveryRequest2 (TotalCost, Quantity, AvgCostPerUnit)
	VALUES (151.25, 5, 30.25);
INSERT INTO DeliveryRequest2 (TotalCost, Quantity, AvgCostPerUnit)
	VALUES (57.00, 2, 23.50);
INSERT INTO DeliveryRequest2 (TotalCost, Quantity, AvgCostPerUnit)
	VALUES (150, 5, 30);
INSERT INTO DeliveryRequest2 (TotalCost, Quantity, AvgCostPerUnit)
	VALUES (46, 2, 23);
INSERT INTO DeliveryRequest2 (TotalCost, Quantity, AvgCostPerUnit)
	VALUES (58, 2, 29);

INSERT INTO DeliveryRequest2 (TotalCost, Quantity, AvgCostPerUnit)
	VALUES (210, 7, 30);
INSERT INTO DeliveryRequest2 (TotalCost, Quantity, AvgCostPerUnit)
	VALUES (190, 5, 38);

INSERT INTO DeliveryRequest1(DeliveryID, Status, AvgCostPerUnit, Quantity, OrganizationID, SupplierID, DateCreated, DateFulfilled)
	VALUES (4567, 'complete', 10, 3, 5001, 21, to_date('2023-06-12', 'yyyy-mm-dd'), to_date('2023-06-22', 'yyyy-mm-dd'));
INSERT INTO DeliveryRequest1 (DeliveryID, Status, AvgCostPerUnit, Quantity, OrganizationID, SupplierID, DateCreated, DateFulfilled)
	VALUES (3526, 'complete', 20.00, 10, 5005, 25, to_date('2023-07-22', 'yyyy-mm-dd'), to_date('2023-08-20', 'yyyy-mm-dd'));
INSERT INTO DeliveryRequest1 (DeliveryID, Status, AvgCostPerUnit, Quantity, OrganizationID, SupplierID, DateCreated, DateFulfilled)
	VALUES (3529, 'complete', 25.00, 10, 5005, 25, to_date('2023-07-21', 'yyyy-mm-dd'), to_date('2023-08-23', 'yyyy-mm-dd'));
INSERT INTO DeliveryRequest1 (DeliveryID, Status, AvgCostPerUnit, Quantity, OrganizationID, SupplierID, DateCreated, DateFulfilled)
	VALUES (3530, 'complete', 50.00, 10, 5005, 25, to_date('2023-07-20', 'yyyy-mm-dd'), to_date('2023-08-23', 'yyyy-mm-dd'));
INSERT INTO DeliveryRequest1 (DeliveryID, Status, AvgCostPerUnit, Quantity, OrganizationID, SupplierID, DateCreated, DateFulfilled)
	VALUES (3531, 'complete', 20.00, 11, 5005, 25, to_date('2023-07-19', 'yyyy-mm-dd'), to_date('2023-08-23', 'yyyy-mm-dd'));

INSERT INTO DeliveryRequest1 (DeliveryID, Status, AvgCostPerUnit, Quantity, OrganizationID, SupplierID, DateCreated, DateFulfilled)
	VALUES (6432, 'in process', 30.25, 5, 5002, 22, to_date('2023-02-16', 'yyyy-mm-dd') , NULL);
INSERT INTO DeliveryRequest1 (DeliveryID, Status, AvgCostPerUnit, Quantity, OrganizationID, SupplierID, DateCreated, DateFulfilled)
	VALUES (8975, 'in process', 23.50, 2, 5004, 24, to_date('2023-02-23', 'yyyy-mm-dd'), NULL);
INSERT INTO DeliveryRequest1 (DeliveryID, Status, AvgCostPerUnit, Quantity, OrganizationID, SupplierID, DateCreated, DateFulfilled)
	VALUES (6435, 'in process', 30, 5, 5002, 22, to_date('2023-02-18', 'yyyy-mm-dd') , NULL);
INSERT INTO DeliveryRequest1 (DeliveryID, Status, AvgCostPerUnit, Quantity, OrganizationID, SupplierID, DateCreated, DateFulfilled)
	VALUES (8977, 'in process', 23, 2, 5004, 24, to_date('2023-02-25', 'yyyy-mm-dd'), NULL);
INSERT INTO DeliveryRequest1 (DeliveryID, Status, AvgCostPerUnit, Quantity, OrganizationID, SupplierID, DateCreated, DateFulfilled)
	VALUES (8979, 'in process', 29, 2, 5004, 24, to_date('2023-02-27', 'yyyy-mm-dd'), NULL);

INSERT INTO DeliveryRequest1 (DeliveryID, Status, AvgCostPerUnit, Quantity, OrganizationID, SupplierID, DateCreated, DateFulfilled)
	VALUES (9072, 'delayed', 30, 7, 5003, 23, to_date('2023-08-19', 'yyyy-mm-dd') , NULL);
INSERT INTO DeliveryRequest1 (DeliveryID, Status, AvgCostPerUnit, Quantity, OrganizationID, SupplierID, DateCreated, DateFulfilled)
	VALUES (9079, 'delayed', 38, 5, 5003, 23, to_date('2023-08-19', 'yyyy-mm-dd') , NULL);

INSERT INTO Material (MaterialID, Name)
	VALUES (1001, 'Top Soil');
INSERT INTO Material (MaterialID, Name)
	VALUES (1002, 'Mulch');
INSERT INTO Material (MaterialID, Name)
	VALUES (1003, 'Seeds');
INSERT INTO Material (MaterialID, Name)
	VALUES (1004, 'Trowel');
INSERT INTO Material (MaterialID, Name)
	VALUES (1005, 'Shovel');

INSERT INTO Contains (DeliveryID, MaterialID)
	VALUES (4567, 1001);
INSERT INTO Contains (DeliveryID, MaterialID)
	VALUES (6432, 1002);
INSERT INTO Contains (DeliveryID, MaterialID)
	VALUES (9072, 1003);
INSERT INTO Contains (DeliveryID, MaterialID)
	VALUES (8975, 1004);
INSERT INTO Contains (DeliveryID, MaterialID)
	VALUES (3526, 1005);

INSERT INTO Soil (MaterialID, Coverage, Composition)
	VALUES (1001, 50, 'Organic');
INSERT INTO Soil (MaterialID, Coverage, Composition)
	VALUES (1002, 25, 'Cedar');

INSERT INTO Seed (MaterialID, Species)
	VALUES (1003, 'lettuce');

INSERT INTO Tool (MaterialID, Function)
	VALUES (1004, 'planting');
INSERT INTO Tool (MaterialID, Function)
	VALUES (1005, 'digging');

INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (1, 101,  15, 'occupied');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (2, 101,  20, 'occupied');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (3, 101,  12, 'occupied');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (4, 101,  12, 'available');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (5, 101,  12, 'available');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (6, 101,  16, 'closed for renovation');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (7, 101,  25, 'under development');

INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (1, 102, 9, 'available');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (2, 102, 21, 'occupied');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (3, 102, 15, 'available');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (4, 102, 12, 'occupied');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (5, 102, 24, 'under development');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (6, 102, 36, 'under development');

INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (1, 103, 25, 'available');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (2, 103, 25, 'occupied');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (3, 103, 25, 'occupied');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (4, 103, 25, 'closed for renovation');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (5, 103, 25, 'closed for renovation');


INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (1, 104, 16, 'available');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (2, 104, 16, 'available');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (3, 104, 16, 'available');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (4, 104, 24, 'under development');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (5, 104, 24, 'under development');

INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (1, 105, 24, 'occupied');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (2, 105, 36, 'occupied');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (3, 105, 24, 'closed for renovation');
INSERT INTO Plot (PlotNumber, GardenID, PlotSize, Status)
	VALUES (4, 105, 36, 'under development');

INSERT INTO UsedIn (GardenID, PlotNumber, MaterialID, Quantity)
	VALUES (101, 1, 1001, 5);
INSERT INTO UsedIn (GardenID, PlotNumber, MaterialID, Quantity)
	VALUES (101, 1, 1002, 4);
INSERT INTO UsedIn (GardenID, PlotNumber, MaterialID, Quantity)
	VALUES (101, 1, 1003, 4);
INSERT INTO UsedIn (GardenID, PlotNumber, MaterialID, Quantity)
	VALUES (104, 1, 1004, 3);
INSERT INTO UsedIn (GardenID, PlotNumber, MaterialID, Quantity)
	VALUES (105, 1, 1004, 2);

INSERT INTO Plant (PlantID, Species, MonthlyWaterRequirements, DailySunRequirements)
	VALUES (500, 'spinach', 25, 4);
INSERT INTO Plant (PlantID, Species, MonthlyWaterRequirements, DailySunRequirements)
	VALUES (501, 'raddish', 30, 5);
INSERT INTO Plant (PlantID, Species, MonthlyWaterRequirements, DailySunRequirements)
	VALUES (502, 'kale', 50, 3);
INSERT INTO Plant (PlantID, Species, MonthlyWaterRequirements, DailySunRequirements)
	VALUES (503, 'lettuce', 20, 7);
INSERT INTO Plant (PlantID, Species, MonthlyWaterRequirements, DailySunRequirements)
	VALUES (504, 'carrot', 35, 1);
INSERT INTO Plant (PlantID, Species, MonthlyWaterRequirements, DailySunRequirements)
	VALUES (505, 'tomato', 30, 6);

INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
	VALUES (501, 1, 101, 60);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
	VALUES (503, 1, 101, 81);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
	VALUES (500, 2, 101, 12);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
	VALUES (501, 2, 101, 8);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
	VALUES (502, 2, 101, 44);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
	VALUES (503, 2, 101, 20);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
	VALUES (504, 2, 101, 25);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
	VALUES (505, 2, 101, 36);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
	VALUES (502, 2, 102, 5);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
	VALUES (500, 3, 103, 6);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
	VALUES (501, 3, 103, 4);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
	VALUES (502, 3, 103, 22);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
	VALUES (503, 3, 103, 10);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
	VALUES (504, 3, 103, 15);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
	VALUES (505, 3, 103, 18);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
	VALUES (502, 1, 105, 18);
INSERT INTO GrowsIn (PlantID, PlotNumber, GardenID, Quantity)
	VALUES (504, 1, 105, 18);
	
INSERT INTO Gardener2 (Name, Address, PhoneNumber)
	VALUES ('Malkeet S', '123 2nd Street, Vancouver', '604-777-7777');
INSERT INTO Gardener2 (Name, Address, PhoneNumber)
	VALUES ('Justin B', '345 4th Street, Vancouver', '604-999-9999');
INSERT INTO Gardener2 (Name, Address, PhoneNumber)
	VALUES ('Emilyn S', '786 8th Street, Vancouver', '604-111-1111');
INSERT INTO Gardener2 (Name, Address, PhoneNumber)
	VALUES ('Gregor Burger', '707 3rd Street, Vancouver', '604-555-5555');
INSERT INTO Gardener2 (Name, Address, PhoneNumber)
	VALUES ('Gregor Burger', '503 7th Street, Vancouver', '604-888-8888');

INSERT INTO Gardener1 (GardenerID, Name, Address)
	VALUES (7, 'Malkeet S', '123 2nd Street, Vancouver');
INSERT INTO Gardener1 (GardenerID, Name, Address)
	VALUES (8, 'Justin B',  '345 4th Street, Vancouver');
INSERT INTO Gardener1 (GardenerID, Name, Address)
	VALUES (9, 'Emilyn S',  '786 8th Street, Vancouver');
INSERT INTO Gardener1 (GardenerID, Name, Address)
	VALUES (10, 'Gregor Burger', '707 3rd Street, Vancouver');
INSERT INTO Gardener1 (GardenerID, Name, Address)
	VALUES (11, 'Gregor Burger', '503 7th Street, Vancouver');

INSERT INTO TendsTo (PlotNumber, GardenID, GardenerID)
	VALUES (1, 101, 7);
INSERT INTO TendsTo (PlotNumber, GardenID, GardenerID)
	VALUES (1, 101, 8);
INSERT INTO TendsTo (PlotNumber, GardenID, GardenerID)
	VALUES (2, 104, 9);
INSERT INTO TendsTo (PlotNumber, GardenID, GardenerID)
	VALUES (1, 105, 9);
INSERT INTO TendsTo (PlotNumber, GardenID, GardenerID)
	VALUES (2, 105, 9);

INSERT INTO MemberOf (GardenID, GardenerId, Since)
	VALUES (101, 7, to_date('2020-01-23', 'yyyy-mm-dd'));
INSERT INTO MemberOf (GardenID, GardenerId, Since)
	VALUES (101, 8, to_date('2017-01-22', 'yyyy-mm-dd'));
INSERT INTO MemberOf (GardenID, GardenerId, Since)
	VALUES (101, 9, to_date('2020-01-23', 'yyyy-mm-dd'));
INSERT INTO MemberOf (GardenID, GardenerId, Since)
	VALUES (104, 7, to_date('2016-05-16', 'yyyy-mm-dd'));
INSERT INTO MemberOf (GardenID, GardenerId, Since)
	VALUES (105, 7, to_date('2014-05-27', 'yyyy-mm-dd'));

INSERT INTO Event2 (MaxCapacity, Registered, SpaceAvailable)
	VALUES (40, 35, 5);
INSERT INTO Event2 (MaxCapacity, Registered, SpaceAvailable)
	VALUES (30, 15, 15);
INSERT INTO Event2 (MaxCapacity, Registered, SpaceAvailable)
	VALUES (40, 32, 8);
INSERT INTO Event2 (MaxCapacity, Registered, SpaceAvailable)
	VALUES (15, 5, 10);
INSERT INTO Event2 (MaxCapacity, Registered, SpaceAvailable)
	VALUES (50, 47, 3);

INSERT INTO Event1 (EventID, Name, GardenID, Type, MaxCapacity, Registered, EventDate)
	VALUES (1001, 'Spring garden festival', 101, 'festival', 40, 35, to_date('2023-01-11', 'yyyy-mm-dd'));
INSERT INTO Event1 (EventID, Name, GardenID, Type, MaxCapacity, Registered, EventDate)
	VALUES (1002, 'Yoga in the garden', 101, 'fitness', 30, 15, to_date('2022-03-23', 'yyyy-mm-dd'));
INSERT INTO Event1 (EventID, Name, GardenID, Type, MaxCapacity, Registered, EventDate)
	VALUES (1003, 'Gardening for beginners', 103, 'educational', 40, 32, to_date('2021-05-17', 'yyyy-mm-dd'));
INSERT INTO Event1 (EventID, Name, GardenID, Type, MaxCapacity, Registered, EventDate)
	VALUES (1004, 'Gardening workshop', 104, 'educational', 15, 5, to_date('2023-05-17','yyyy-mm-dd'));
INSERT INTO Event1 (EventID, Name, GardenID, Type, MaxCapacity, Registered, EventDate)
	VALUES (1005, 'Garden tour', 105, 'tour', 50, 47, to_date('2022-01-27', 'yyyy-mm-dd'));

INSERT INTO Attends (EventID, GardenerID)
	VALUES (1001, 7);
INSERT INTO Attends (EventID, GardenerID)
	VALUES (1002, 7);
INSERT INTO Attends (EventID, GardenerID)
	VALUES (1003, 7);
INSERT INTO Attends (EventID, GardenerID)
	VALUES (1004, 7);
INSERT INTO Attends (EventID, GardenerID)
	VALUES (1005, 7);
INSERT INTO Attends (EventID, GardenerID)
	VALUES (1002, 8);
INSERT INTO Attends (EventID, GardenerID)
	VALUES (1003, 9);
INSERT INTO Attends (EventID, GardenerID)
	VALUES (1001, 10);
INSERT INTO Attends (EventID, GardenerID)
	VALUES (1002, 10);
INSERT INTO Attends (EventID, GardenerID)
	VALUES (1003, 10);
INSERT INTO Attends (EventID, GardenerID)
	VALUES (1004, 10);
INSERT INTO Attends (EventID, GardenerID)
	VALUES (1005, 10);

INSERT INTO Task (TaskID, DateAssigned, DateCompleted, Status)
	VALUES (1, to_date('2023-01-20', 'yyyy-mm-dd'), to_date('2023-01-22', 'yyyy-mm-dd'), 'completed');
INSERT INTO Task (TaskID, DateAssigned, DateCompleted, Status)
	VALUES (2, to_date('2023-01-20', 'yyyy-mm-dd'), to_date('2023-01-22', 'yyyy-mm-dd'), 'completed');
INSERT INTO Task (TaskID, DateAssigned, DateCompleted, Status)
	VALUES (3, to_date('2023-03-22', 'yyyy-mm-dd'), NULL, 'ongoing');
INSERT INTO Task (TaskID, DateAssigned, DateCompleted, Status)
	VALUES (4, to_date('2023-04-23', 'yyyy-mm-dd'), to_date('2023-05-21', 'yyyy-mm-dd'), 'completed');
INSERT INTO Task (TaskID, DateAssigned, DateCompleted, Status)
	VALUES (5, to_date('2023-05-24', 'yyyy-mm-dd'), NULL, 'ongoing');

INSERT INTO Water (TaskID, Duration)
	VALUES (1, 3);
INSERT INTO Water (TaskID, Duration)
	VALUES (2, 4);

INSERT INTO Weed (TaskID, Method)
	VALUES (3, 'chemical');

INSERT INTO Sow (TaskID, Species, Season)
	VALUES (4, 'lettuce', 'spring');

INSERT INTO Harvest (TaskID, Species, Season)
	VALUES (5, 'broccoli', 'fall');

INSERT INTO Performs (GardenerID, TaskID)
	VALUES (7, 1);
INSERT INTO Performs (GardenerID, TaskID)
	VALUES (7, 2);
INSERT INTO Performs (GardenerID, TaskID)
	VALUES (8, 2);
INSERT INTO Performs (GardenerID, TaskID)
	VALUES (8, 1);
INSERT INTO Performs (GardenerID, TaskID)
	VALUES (9, 3);