CREATE DATABASE jefe_db;

CREATE USER 'main'@'%' IDENTIFIED BY 'main123';
GRANT ALL PRIVILEGES ON jefe_db.* to 'main'@'%';
FLUSH PRIVILEGES;


-- Move into the database we just created.
USE jefe_db;

-- PUT your DDL
CREATE TABLE Employee (
    EmpId INT(3) NOT NULL,
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    SSN INT(9) NOT NULL,
    Title VARCHAR(20) NOT NULL,
    BDay DATE NOT NULL,
    StartDate DATE NOT NULL,
    Wage DECIMAL(19, 2) NOT NULL,
    Email VARCHAR(65),
    Phone INT(10),
    EmpStreet VARCHAR(20),
    EmpCity VARCHAR(20),
    EmpState VARCHAR(20),
    EmpZip CHAR(5),
    ManagerId INT(3) NOT NULL,
    PRIMARY KEY(EmpId),
    CONSTRAINT fk_2 FOREIGN KEY (ManagerId) REFERENCES Employee (EmpId) ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE Franchise (
    FranchiseId INT(2) NOT NULL,
    FranchiseName VARCHAR(20) NOT NULL,
    Networth DECIMAL(65, 19) NOT NULL,
    PRIMARY KEY(FranchiseId)
);

CREATE TABLE Store (
    StoreId int(1) NOT NULL,
    StoreName VARCHAR(20) NOT NULL,
    StoreStreet VARCHAR(65) NOT NULL,
    StoreCity VARCHAR(20) NOT NULL,
    StoreState VARCHAR(20) NOT NULL,
    StoreZip INT(5) NOT NULL,
    StoreHourOpen TIME NOT NULL,
    StoreHourClose TIME NOT NULL,
    Profit DECIMAL(19, 2) NOT NULL,
    Cost DECIMAL(19, 2) NOT NULL,
    Revenue DECIMAL(19, 2) NOT NULL,
    MonthlyUpkeep DECIMAL(19, 2) NOT NULL,
    ManagerId INT(3) NOT NULL,
    FranchiseId INT(2) NOT NULL,
    PRIMARY KEY(StoreId),
    CONSTRAINT fk_1 FOREIGN KEY (ManagerId) REFERENCES Employee (EmpId) ON DELETE restrict ON UPDATE cascade,
    CONSTRAINT fk_3 FOREIGN KEY (FranchiseId) REFERENCES Franchise (FranchiseId) ON UPDATE cascade ON DELETE restrict

);

CREATE TABLE Customer (
    CustId INT(6) NOT NULL,
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    CurrentStreet VARCHAR(65) NOT NULL,
    CurrentCity VARCHAR(20) NOT NULL,
    CurrentZip INT(5) NOT NULL,
    Email VARCHAR(65) NOT NULL,
    Pass VARCHAR(20) NOT NULL,
    HomeStoreId INT(1) NOT NULL,
    PRIMARY KEY(CustId),
    CONSTRAINT fk_4 FOREIGN KEY (HomeStoreId) REFERENCES Store (StoreId) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Orders (
    OrderId INT(5) NOT NULL,
    StoreId INT(1) NOT NULL,
    OrderDate DATE NOT NULL,
    TotalPrice DECIMAL(19, 2) NOT NULL,
    TimeOrdered TIME NOT NULL,
    TimeCompleted TIME NOT NULL,
    TimeToMake TIME NOT NULL,
    CustomerId INT(6) NOT NULL,
    PRIMARY KEY(OrderId),
    CONSTRAINT fk_5 FOREIGN KEY (CustomerId) REFERENCES Customer (CustId) ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_6 FOREIGN KEY (StoreId) REFERENCES Store (StoreId) ON UPDATE cascade ON DELETE restrict

);

CREATE TABLE Investor (
    InvId int(3) NOT NULL,
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    Email VARCHAR(65) NOT NULL,
    Phone INT(10) NOT NULL,
    InvStreet VARCHAR(65) NOT NULL,
    InvCity VARCHAR(20) NOT NULL,
    InvState VARCHAR(20) NOT NULL,
    InvZip INT(5) NOT NULL,
    PRIMARY KEY(InvId)
);

CREATE TABLE Investments (
    FranchiseId INT(2) NOT NULL,
    InvId INT(3) NOT NULL,
    InvStatus VARCHAR(20) NOT NULL,
    Stake DECIMAL(4, 2) NOT NULL,
    PRIMARY KEY(FranchiseId, InvId),
    CONSTRAINT fk_7 FOREIGN KEY (InvId) REFERENCES Investor (InvId) ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_8 FOREIGN KEY (FranchiseId) REFERENCES Franchise (FranchiseId) ON UPDATE cascade ON DELETE restrict

);

CREATE TABLE Shift (
    EmpId INT(3) NOT NULL,
    ShiftDate DATE,
    ShiftStart TIME,
    ShiftEnd TIME,
    ShiftHours INT,
    PRIMARY KEY(EmpId, ShiftDate, ShiftStart, ShiftEnd),
    CONSTRAINT fk_9 FOREIGN KEY (EmpId) REFERENCES Employee (EmpId) ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE FoodType (
    TypeId INT(3) NOT NULL,
    TypeName VARCHAR(20) NOT NULL,
    BasePrice DECIMAL(19, 2) NOT NULL,
    PRIMARY KEY(TypeId)
);

CREATE TABLE Product (
    ProductId INT(4) NOT NULL,
    Price DECIMAL(19, 2) NOT NULL,
    OrderId INT(5) NOT NULL,
    TypeId INT(3) NOT NULL,
    PRIMARY KEY(ProductId),
    CONSTRAINT fk_10 FOREIGN KEY (OrderId) REFERENCES Orders (OrderId) ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_11 FOREIGN KEY (TypeId) REFERENCES FoodType (TypeId) ON UPDATE cascade ON DELETE restrict
);
CREATE TABLE Ingredient (
    IngrId INT(4) NOT NULL,
    IngrName VARCHAR(25) NOT NULL,
    WholesalePrice DECIMAL(19, 2) NOT NULL,
    Upcharge DECIMAL(19, 2),
    IngrCategory VARCHAR(20) NOT NULL,
    CurrQuantity int NOT NULL,
    StoreId INT(1) NOT NULL,
    PRIMARY KEY(IngrId),
    CONSTRAINT fk_12 FOREIGN KEY (StoreId) REFERENCES Store (StoreId)
);

CREATE TABLE ProductIngredient (
    ProductId INT(4) NOT NULL,
    IngredientId INT(4) NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY(ProductId, IngredientId),
    CONSTRAINT fk_13 FOREIGN KEY (ProductId) REFERENCES Product (ProductId) ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_14 FOREIGN KEY (IngredientId) REFERENCES Ingredient (IngrId) ON UPDATE cascade ON DELETE restrict
);


-- Add sample data
INSERT INTO Employee
    (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone,
    EmpStreet, EmpCity, EmpState, EmpZip, ManagerId)
VALUES
    (435, 'Cornelius', 'Prinnett', 123456789, 'Store Manager', '1999-03-18', '2010-02-15', 35.00, 'cprinnett4@multiply.com', 502-802-1754,
    '711 Bluestem Avenue', 'Boston', 'MA', '02115', 435),
    (762, 'Tulley', 'Landall', 111111111, 'Cook', '1985-10-17', '2019-04-20', 18.00, 'tlandall6@mediafire.com', 394-256-4307,
    '60 Briar Crest Trail', 'Fayetteville', 'NC', 33594, 435),
    (111, 'Kate', 'Stuntz', 111101111, 'Cashier', '2003-04-27', '2021-03-20', 21.00, 'stuntz.k@northeastern.com', 617-256-4307,
    '68 Orchard Drive', 'New Canaan', 'CT', 03432, 435),
    (594, 'JJ', 'Farts', 132101111, 'Cook', '2000-01-01', '2019-03-23', 18.00, 'jj.farts@gmail.com', 617-444-1221,
    '939 Gingerroot Road', 'Lincoln', 'NE', 33310, 435);


INSERT INTO Franchise
    (FranchiseId, FranchiseName, Networth)
VALUES
    (11, 'El Jefes Taqeria', 8293742.22);

INSERT INTO Store
    (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose,
    Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId)
VALUES
    (1, 'Symphony', '269 Huntington Avenue', 'Boston', 'MA', 02115, '08:00:00', '03:00:00', 111111.11, 1111.11, 110000.00, 500.00, 435, 11),
    (2, 'Harvard Square', '14 Brattle Street', 'Cambridge', 'MA', 02138, '08:00:00', '04:00:00', 222222.22, 2222.22, 220000.00, 600.00, 111, 11),
    (3, 'New Brunswick', '97 Hamilton Street', 'New Brunswick', 'NJ', 08901, '08:00:00', '04:00:00', 111111.11, 1111.11, 110000.00, 600.00, 762, 11),
    (4, 'State College', '352 E. Calder Way ', 'State College', 'PA', 16801, '08:00:00', '04:00:00', 222222.22, 2222.22, 220000.00, 700.00, 594, 11);

INSERT INTO Customer
    (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentZip, Email, Pass, HomeStoreId)
VALUES
    (975141, 'Gabbie', 'Ashplant', '51395 Columbus Parkway', 'Pasadena', 92293, 'gashplant0@tripadvisor.com', 'McBHEnb', 1),
    (604561, 'Currie', 'Jantot', '03 Vidon Avenue', 'San Antonio', 86161, 'cjantot1@economist.com', 'PuJBEs', 1),
    (889787, 'Anjela', 'Leverette', '40 Anniversary Circle', 'Jamaica', 68882, 'aleverette2@statcounter.com', 'o2LjPcN0Y', 2),
    (671090, 'Nichole', 'Trevear', '5 Mcguire Lane', 'Chicago', 70501, 'ntrevear3@whitehouse.gov', 'frrT1PayI07I', 2),
    (854684, 'Fabian', 'Titterton', '58960 Grover Drive', 'Tulsa', 64851, 'ftitterton4@aboutads.info', 'HAZ8X42', 3),
    (881631, 'Beaufort', 'Eadie', '065 Melby Terrace', 'Jamaica', 49111, 'beadie5@state.tx.us', 'yAiK89', 4);

INSERT INTO Orders
    (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeCompleted, TimeToMake, CustomerId)
VALUES
    (12345, 1, '2022-01-23', 23.45, '15:06:47', '15:25:47', '00:19:00', 975141),
    (12346, 1, '2022-03-24', 12.58, '12:10:00', '12:15:01', '00:05:01', 604561),
    (12347, 2, '2022-05-01', 34.71, '01:16:10', '01:24:21', '00:08:11', 889787),
    (12348, 2, '2022-06-15', 62.61, '15:31:14', '15:45:14', '00:14:00', 671090),
    (12349, 3, '2022-07-12', 8.42, '19:16:24', '19:25:24', '00:09:00', 854684),
    (12350, 4, '2022-11-22', 32.28, '21:50:38', '22:05:40', '00:15:02', 881631);

INSERT INTO Investor
    (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip)
VALUES
    (100, 'Marshal', 'Semble', 'msemble0@ebay.co.uk', 418-170-9012, '84459 5th Park', 'Kansas City', 'MO', 69829),
    (101, 'Bartie', 'Ardern', 'bardern0@prnewswire.com', 916-668-2767, '82 Carpenter Crossing', 'Boston', 'MA', 02115),
    (102, 'Abigal', 'Barnes', 'barnes.a@hotwire.com', 413-905-4653, '76 Fanwood Road', 'Salem', 'MA', 23012);



INSERT INTO Investments
    (FranchiseId, InvId, InvStatus, Stake)
VALUES
    (11, 100, 'longtime', 51.00),
    (11, 101, 'new', 15.00),
    (11, 102, 'potential', 00.00);

    
INSERT INTO Shift
    (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours)
VALUES
    (111, '2022-11-10', '08:00:00', '12:00:00', 4),
    (435, '2022-11-10', '15:00:00', '20:00:00', 5);

INSERT INTO FoodType
    (TypeId, TypeName, BasePrice)
VALUES
    (111, 'Burrito', 11.00),
    (112, 'Bowl', 11.00),
    (113, 'Quesadilla', 12.00);

INSERT INTO Product
    (ProductId, Price, OrderId, TypeId)
VALUES  
    (3212, 11.00, 12345, 111),
    (2838, 11.00, 12345, 112),
    (3722, 13.00, 12347, 113);

INSERT INTO Ingredient
    (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, StoreId)
VALUES
    (1111, 'White Rice', 103.54, 1.00, 'Hot', 5, 1),
    (1112, 'Grilled Chicken', 435.87, 2.50, 'Protein', 10, 2),
    (1232, 'Chipotle Mayo', 90.45, 0.00, 'Sauce', 12, 2);

INSERT INTO ProductIngredient
    (ProductId, IngredientId, Quantity)
VALUES 
    (3212, 1111, 1),
    (3212, 1112, 2),
    (2838, 1111, 2),
    (3722, 1232, 4);





