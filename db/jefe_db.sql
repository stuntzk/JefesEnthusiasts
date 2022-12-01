CREATE DATABASE jefe_db;

CREATE USER 'main'@'%' IDENTIFIED BY 'main123';
GRANT ALL PRIVILEGES ON jefe_db.* to 'main'@'%';
FLUSH PRIVILEGES;


-- Move into the database we just created.
USE jefe_db;

-- PUT your DDL
CREATE TABLE Employee
(
    EmpId     INT(3)         NOT NULL,
    FirstName VARCHAR(20)    NOT NULL,
    LastName  VARCHAR(20)    NOT NULL,
    SSN       INT(9)         NOT NULL,
    Title     VARCHAR(20)    NOT NULL,
    BDay      DATE           NOT NULL,
    StartDate DATE           NOT NULL,
    Wage      DECIMAL(19, 2) NOT NULL,
    Email     VARCHAR(65),
    Phone     INT(10),
    EmpStreet VARCHAR(65),
    EmpCity   VARCHAR(65),
    EmpState  VARCHAR(65),
    EmpZip    CHAR(5),
    ManagerId INT(3)         NOT NULL,
    PRIMARY KEY (EmpId),
    CONSTRAINT fk_2 FOREIGN KEY (ManagerId) REFERENCES Employee (EmpId) ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE Franchise
(
    FranchiseId   INT(2)          NOT NULL,
    FranchiseName VARCHAR(20)     NOT NULL,
    Networth      DECIMAL(65, 19) NOT NULL,
    PRIMARY KEY (FranchiseId)
);

CREATE TABLE Store
(
    StoreId        int(1)         NOT NULL,
    StoreName      VARCHAR(20)    NOT NULL,
    StoreStreet    VARCHAR(65)    NOT NULL,
    StoreCity      VARCHAR(20)    NOT NULL,
    StoreState     VARCHAR(20)    NOT NULL,
    StoreZip       INT(5)         NOT NULL,
    StoreHourOpen  TIME           NOT NULL,
    StoreHourClose TIME           NOT NULL,
    Profit         DECIMAL(19, 2) NOT NULL,
    Cost           DECIMAL(19, 2) NOT NULL,
    Revenue        DECIMAL(19, 2) NOT NULL,
    MonthlyUpkeep  DECIMAL(19, 2) NOT NULL,
    ManagerId      INT(3)         NOT NULL,
    FranchiseId    INT(2)         NOT NULL,
    PRIMARY KEY (StoreId),
    CONSTRAINT fk_1 FOREIGN KEY (ManagerId) REFERENCES Employee (EmpId) ON DELETE restrict ON UPDATE cascade,
    CONSTRAINT fk_3 FOREIGN KEY (FranchiseId) REFERENCES Franchise (FranchiseId) ON UPDATE cascade ON DELETE restrict

);

CREATE TABLE Customer
(
    CustId        INT(6)      NOT NULL,
    FirstName     VARCHAR(20) NOT NULL,
    LastName      VARCHAR(20) NOT NULL,
    CurrentStreet VARCHAR(65) NOT NULL,
    CurrentCity   VARCHAR(20) NOT NULL,
    CurrentZip    INT(5)      NOT NULL,
    Email         VARCHAR(65) NOT NULL,
    Pass          VARCHAR(20) NOT NULL,
    HomeStoreId   INT(1)      NOT NULL,
    PRIMARY KEY (CustId),
    CONSTRAINT fk_4 FOREIGN KEY (HomeStoreId) REFERENCES Store (StoreId) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Orders
(
    OrderId       INT(5)         NOT NULL,
    StoreId       INT(1)         NOT NULL,
    OrderDate     DATE           NOT NULL,
    TotalPrice    DECIMAL(19, 2) NOT NULL,
    TimeOrdered   TIME           NOT NULL,
    TimeCompleted TIME           NOT NULL,
    TimeToMake    TIME           NOT NULL,
    CustomerId    INT(6)         NOT NULL,
    PRIMARY KEY (OrderId),
    CONSTRAINT fk_5 FOREIGN KEY (CustomerId) REFERENCES Customer (CustId) ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_6 FOREIGN KEY (StoreId) REFERENCES Store (StoreId) ON UPDATE cascade ON DELETE restrict

);

CREATE TABLE Investor
(
    InvId     int(3)      NOT NULL,
    FirstName VARCHAR(20) NOT NULL,
    LastName  VARCHAR(20) NOT NULL,
    Email     VARCHAR(65) NOT NULL,
    Phone     INT(10)     NOT NULL,
    InvStreet VARCHAR(65) NOT NULL,
    InvCity   VARCHAR(20) NOT NULL,
    InvState  VARCHAR(20) NOT NULL,
    InvZip    INT(5)      NOT NULL,
    PRIMARY KEY (InvId)
);

CREATE TABLE Investments
(
    FranchiseId INT(2)        NOT NULL,
    InvId       INT(3)        NOT NULL,
    InvStatus   VARCHAR(20)   NOT NULL,
    Stake       DECIMAL(4, 2) NOT NULL,
    PRIMARY KEY (FranchiseId, InvId),
    CONSTRAINT fk_7 FOREIGN KEY (InvId) REFERENCES Investor (InvId) ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_8 FOREIGN KEY (FranchiseId) REFERENCES Franchise (FranchiseId) ON UPDATE cascade ON DELETE restrict

);

CREATE TABLE Shift
(
    EmpId       INT(3) NOT NULL,
    ShiftDate   DATE,
    ShiftStart  TIME,
    ShiftEnd    TIME,
    ShiftHours  INT,
    StoreWorked INT(1) NOT NULL,
    PRIMARY KEY (EmpId, ShiftDate, ShiftStart, ShiftEnd),
    CONSTRAINT fk_9 FOREIGN KEY (EmpId) REFERENCES Employee (EmpId) ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_15 FOREIGN KEY (StoreWorked) REFERENCES Store (StoreId) ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE FoodType
(
    TypeId    INT(3)         NOT NULL,
    TypeName  VARCHAR(20)    NOT NULL,
    BasePrice DECIMAL(19, 2) NOT NULL,
    PRIMARY KEY (TypeId)
);

CREATE TABLE Product
(
    ProductId INT(4)         NOT NULL,
    Price     DECIMAL(19, 2) NOT NULL,
    OrderId   INT(5)         NOT NULL,
    TypeId    INT(3)         NOT NULL,
    PRIMARY KEY (ProductId),
    CONSTRAINT fk_10 FOREIGN KEY (OrderId) REFERENCES Orders (OrderId) ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_11 FOREIGN KEY (TypeId) REFERENCES FoodType (TypeId) ON UPDATE cascade ON DELETE restrict
);
CREATE TABLE Ingredient
(
    IngrId         INT(4)         NOT NULL,
    IngrName       VARCHAR(25)    NOT NULL,
    WholesalePrice DECIMAL(19, 2) NOT NULL,
    Upcharge       DECIMAL(19, 2),
    IngrCategory   VARCHAR(20)    NOT NULL,
    CurrQuantity   int            NOT NULL,
    StoreId        INT(1)         NOT NULL,
    PRIMARY KEY (IngrId),
    CONSTRAINT fk_12 FOREIGN KEY (StoreId) REFERENCES Store (StoreId)
);

CREATE TABLE ProductIngredient
(
    ProductId    INT(4) NOT NULL,
    IngredientId INT(4) NOT NULL,
    Quantity     INT    NOT NULL,
    PRIMARY KEY (ProductId, IngredientId),
    CONSTRAINT fk_13 FOREIGN KEY (ProductId) REFERENCES Product (ProductId) ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_14 FOREIGN KEY (IngredientId) REFERENCES Ingredient (IngrId) ON UPDATE cascade ON DELETE restrict
);


-- Add sample data
INSERT INTO Employee
(EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone,
 EmpStreet, EmpCity, EmpState, EmpZip, ManagerId)
VALUES (435, 'Cornelius', 'Prinnett', 123456789, 'Store Manager', '1999-03-18', '2010-02-15', 35.00,
        'cprinnett4@multiply.com', 502 - 802 - 1754,
        '711 Bluestem Avenue', 'Boston', 'MA', '02115', 435),
       (762, 'Tulley', 'Landall', 111111111, 'Cook', '1985-10-17', '2019-04-20', 18.00, 'tlandall6@mediafire.com',
        394 - 256 - 4307,
        '60 Briar Crest Trail', 'Fayetteville', 'NC', 33594, 435),
       (111, 'Kate', 'Stuntz', 111101111, 'Cashier', '2003-04-27', '2021-03-20', 21.00, 'stuntz.k@northeastern.com',
        617 - 256 - 4307,
        '68 Orchard Drive', 'New Canaan', 'CT', 03432, 435),
       (594, 'JJ', 'Farts', 132101111, 'Cook', '2000-01-01', '2019-03-23', 18.00, 'jj.farts@gmail.com',
        617 - 444 - 1221,
        '939 Gingerroot Road', 'Lincoln', 'NE', 33310, 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (989, 'Marin', 'Van Hove', 898109519, 'Cook', '1976-06-14', '2000-07-11', 22.43, 'mvanhove0@adobe.com', 2603561391, '05689 Kenwood Park', 'Saint Joseph', 'MO', '64504', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (454, 'Seamus', 'Sausman', 508925539, 'Cook', '1982-04-16', '2022-03-19', 17.6, 'ssausman1@alibaba.com', 9377860445, '2454 Bellgrove Trail', 'South Bend', 'IN', '46620', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (302, 'Ranna', 'Cayzer', 754056581, 'Cook', '1997-04-17', '2000-12-22', 29.24, 'rcayzer2@sbwire.com', 1823859921, '8 Prairieview Point', 'Minneapolis', 'MN', '55470', 121);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (434, 'Jed', 'Kinchlea', 548911676, 'Cook', '1985-03-19', '2016-07-16', 39.92, 'jkinchlea3@mapquest.com', 9823693440, '186 Victoria Alley', 'Norfolk', 'VA', '23504', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (238, 'Cordey', 'Watkiss', 870161078, 'Support', '2000-03-11', '2018-03-21', 57.26, 'cwatkiss4@state.tx.us', 2795573427, '90 Di Loreto Terrace', 'Lansing', 'MI', '48912', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (583, 'Faber', 'Jobbings', 217043463, 'Support', '1996-01-08', '2019-03-23', 23.77, 'fjobbings5@spiegel.de', 7738381377, '75 Helena Pass', 'Buffalo', 'NY', '14225', 333);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (686, 'Ian', 'Bon', 196807795, 'Store Manager', '2008-08-30', '2009-07-30', 29.02, 'ibon6@theatlantic.com', 5950161376, '38 Center Circle', 'Washington', 'DC', '20575', 686);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (255, 'Avery', 'Covell', 564119951, 'Cook', '1975-09-25', '2006-06-06', 20.68, 'acovell7@twitter.com', 9578232065, '4999 Nancy Parkway', 'South Bend', 'IN', '46614', 121);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (976, 'Thatcher', 'Tatershall', 621447560, 'Support', '1996-10-20', '2020-06-04', 43.33, 'ttatershall8@tripadvisor.com', 3793118732, '5361 Holmberg Way', 'Newark', 'NJ', '07104', 121);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (817, 'Devan', 'Pettigrew', 532434924, 'Store Manager', '1973-06-17', '2005-05-07', 17.97, 'dpettigrew9@weibo.com', 2414860860, '8467 Eastlawn Pass', 'Charlotte', 'NC', '28205', 817);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (723, 'Raimundo', 'Dugget', 543934166, 'Store Manager', '1973-06-06', '2000-09-30', 10.65, 'rduggeta@mysql.com', 9959327446, '86 Maryland Crossing', 'El Paso', 'TX', '88579', 723);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (162, 'Tiff', 'Vigne', 639612513, 'Cook', '2003-07-05', '2008-07-20', 43.35, 'tvigneb@photobucket.com', 4091918582, '8506 Westridge Drive', 'Albuquerque', 'NM', '87140', 333);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (535, 'Gertrude', 'Manser', 340498764, 'Cook', '1995-05-31', '2017-05-25', 10.32, 'gmanserc@patch.com', 9969982222, '29951 Beilfuss Place', 'Iowa City', 'IA', '52245', 333);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (983, 'Giacinta', 'Huckerby', 257428602, 'Store Manager', '1978-11-30', '2009-08-06', 27.7, 'ghuckerbyd@gov.uk', 3600986312, '608 Packers Way', 'Dallas', 'TX', '75277', 983);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (718, 'Pavia', 'Kitteman', 860829636, 'Store Manager', '1991-10-10', '2010-05-21', 19.22, 'pkittemane@e-recht24.de', 9842908265, '97347 Mayfield Park', 'Boston', 'MA', '02203', 718);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (399, 'Nero', 'Fendt', 937564583, 'Cashier', '1997-11-12', '2007-09-23', 26.91, 'nfendtf@nationalgeographic.com', 6921503804, '39600 Mesta Plaza', 'Baltimore', 'MD', '21275', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (729, 'Marline', 'Bischoff', 907659714, 'Cook', '1967-08-15', '2010-01-28', 59.37, 'mbischoffg@imdb.com', 6004843106, '51 Clove Center', 'Saint Louis', 'MO', '63136', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (626, 'Francesco', 'Rubens', 738983054, 'Cashier', '2007-03-25', '2015-04-06', 55.68, 'frubensh@sohu.com', 9684034224, '17 Shoshone Hill', 'Norfolk', 'VA', '23520', 333);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (502, 'Lauraine', 'Purtell', 740492042, 'Cook', '1985-05-27', '2020-03-15', 18.51, 'lpurtelli@elpais.com', 6210253403, '305 Bluestem Lane', 'Elizabeth', 'NJ', '07208', 121);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (369, 'Dulce', 'Tendahl', 246281172, 'Cook', '1966-08-09', '2001-12-22', 22.48, 'dtendahlj@pcworld.com', 7575211313, '3 Schurz Trail', 'Fort Worth', 'TX', '76162', 121);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (478, 'Vivie', 'Attfield', 917370399, 'Support', '1990-04-10', '2020-12-27', 23.97, 'vattfieldk@tmall.com', 6439467658, '0230 Spohn Trail', 'Cumming', 'GA', '30130', 333);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (122, 'Lenore', 'Benedek', 327526429, 'Cook', '2004-04-04', '2013-11-03', 46.09, 'lbenedekl@google.ca', 6368178496, '2399 5th Pass', 'Philadelphia', 'PA', '19131', 121);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (201, 'Myrilla', 'Paslow', 744343231, 'Store Manager', '2007-04-14', '2013-08-10', 57.37, 'mpaslowm@loc.gov', 8510469971, '82 Nevada Junction', 'Houston', 'TX', '77260', 201);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (528, 'Leesa', 'Renzini', 544353875, 'Cashier', '2007-01-16', '2014-09-10', 13.94, 'lrenzinin@w3.org', 9839119791, '96 Main Place', 'Riverside', 'CA', '92519', 333);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (864, 'Pall', 'Hark', 930801764, 'Cook', '1977-05-17', '2016-05-14', 48.87, 'pharko@auda.org.au', 3407727002, '5806 Russell Crossing', 'Atlanta', 'GA', '30328', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (293, 'Maison', 'Stygall', 472400068, 'Support', '1995-10-06', '2013-11-17', 32.76, 'mstygallp@dropbox.com', 7206717102, '8 Old Shore Trail', 'Cincinnati', 'OH', '45223', 121);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (209, 'Gannon', 'Pitrollo', 410764936, 'Cook', '1977-05-22', '2016-07-11', 38.24, 'gpitrolloq@hexun.com', 9348692610, '0 Crest Line Junction', 'Toledo', 'OH', '43615', 121);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (814, 'Glennis', 'Eslie', 337504525, 'Cashier', '1997-06-06', '2000-09-13', 25.97, 'geslier@amazonaws.com', 5931402512, '7314 Florence Way', 'San Diego', 'CA', '92105', 121);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (681, 'Onfre', 'Clissell', 831070199, 'Store Manager', '1982-06-30', '2017-10-21', 56.31, 'oclissells@icq.com', 6141784435, '4 Anniversary Junction', 'Detroit', 'MI', '48232', 681);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (785, 'Brina', 'Burchmore', 316865781, 'Store Manager', '2001-11-08', '2021-11-15', 48.37, 'bburchmoret@tinyurl.com', 3048835649, '37011 Anderson Parkway', 'San Antonio', 'TX', '78285', 785);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (758, 'Batholomew', 'Krollman', 202301054, 'Cashier', '1967-09-10', '2020-11-14', 23.93, 'bkrollmanu@ihg.com', 3576533790, '3373 Columbus Park', 'Cleveland', 'OH', '44125', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (999, 'Hadrian', 'Wayt', 363639945, 'Cook', '1968-05-16', '2019-07-22', 32.6, 'hwaytv@goo.ne.jp', 7572200625, '04 Clarendon Trail', 'Shreveport', 'LA', '71115', 333);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (856, 'Jsandye', 'Guess', 111524110, 'Store Manager', '1994-11-29', '2007-07-31', 59.4, 'jguessw@posterous.com', 3231390307, '49 Raven Alley', 'Minneapolis', 'MN', '55446', 856);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (127, 'Idette', 'Tuckwood', 746645651, 'Support', '1977-12-02', '2018-11-13', 35.07, 'ituckwoodx@marketwatch.com', 5539448036, '0049 Dovetail Junction', 'Norfolk', 'VA', '23520', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (295, 'Rudolph', 'MacKinnon', 147265637, 'Store Manager', '1993-11-01', '2022-01-06', 15.36, 'rmackinnony@msn.com', 5905782551, '82944 Mcguire Place', 'Herndon', 'VA', '22070', 295);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (488, 'Wade', 'Gailor', 671268028, 'Support', '1974-05-03', '2012-07-30', 33.48, 'wgailorz@dmoz.org', 4314257339, '4127 Melby Crossing', 'Norfolk', 'VA', '23514', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (620, 'Twyla', 'Vaudre', 849770302, 'Cashier', '2004-08-26', '2019-02-14', 16.75, 'tvaudre10@usda.gov', 8272703156, '532 Manufacturers Street', 'Sarasota', 'FL', '34238', 333);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (552, 'Masha', 'Dunkerly', 671384626, 'Cook', '1982-02-08', '2009-08-08', 56.85, 'mdunkerly11@purevolume.com', 7885959406, '32 Kinsman Court', 'Pueblo', 'CO', '81015', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (117, 'Rosanne', 'Nutbean', 815356886, 'Cashier', '1976-03-06', '2002-03-08', 48.69, 'rnutbean12@hud.gov', 8926026966, '22853 Pankratz Drive', 'Berkeley', 'CA', '94712', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (705, 'Alisha', 'Rydings', 566268027, 'Store Manager', '1979-07-15', '2010-06-28', 57.44, 'arydings13@creativecommons.org', 7368926840, '9084 Clove Alley', 'El Paso', 'TX', '79984', 705);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (360, 'Isis', 'Rathbourne', 311008305, 'Store Manager', '2004-08-04', '2020-11-23', 17.49, 'irathbourne14@people.com.cn', 1796360519, '35392 Hoard Avenue', 'Seattle', 'WA', '98127', 360);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (313, 'Constance', 'Aimson', 222521608, 'Store Manager', '2003-08-26', '2001-08-06', 55.19, 'caimson15@upenn.edu', 5336295698, '64850 Melby Court', 'Jackson', 'MS', '39210', 313);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (477, 'Doralynne', 'Branney', 876839770, 'Cook', '1979-10-09', '2006-06-12', 11.16, 'dbranney16@hatena.ne.jp', 4824351913, '087 Carioca Lane', 'Jacksonville', 'FL', '32277', 333);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (439, 'Keith', 'Manvell', 703806137, 'Cook', '1994-12-20', '2021-01-22', 24.16, 'kmanvell17@eventbrite.com', 9935998703, '18241 Bayside Terrace', 'Sacramento', 'CA', '94291', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (479, 'Reta', 'Dare', 153393278, 'Cashier', '1991-10-04', '2015-03-05', 54.69, 'rdare18@whitehouse.gov', 5039384014, '495 Elka Road', 'Los Angeles', 'CA', '90081', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (129, 'Ced', 'Douris', 284777421, 'Store Manager', '1982-08-13', '2019-08-27', 51.33, 'cdouris19@toplist.cz', 7131112858, '1831 Crescent Oaks Court', 'Erie', 'PA', '16505', 129);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (602, 'Nevins', 'Dod', 351165984, 'Cook', '2002-12-08', '2000-05-29', 39.3, 'ndod1a@exblog.jp', 3643463474, '99 Clarendon Hill', 'Birmingham', 'AL', '35220', 121);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (127, 'Mario', 'Menego', 500294846, 'Support', '1975-09-27', '2002-06-13', 37.06, 'mmenego1b@behance.net', 9949218748, '87 Harbort Parkway', 'Atlanta', 'GA', '31132', 121);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (424, 'Willie', 'Vaney', 654544243, 'Store Manager', '2001-06-30', '2011-05-15', 11.34, 'wvaney1c@booking.com', 6470846936, '79 Aberg Point', 'Concord', 'CA', '94522', 424);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (240, 'Nanice', 'Rappport', 986052586, 'Cashier', '1985-12-29', '2006-07-26', 49.04, 'nrappport1d@printfriendly.com', 8294621402, '3359 Victoria Road', 'Pittsburgh', 'PA', '15255', 121);

INSERT INTO Franchise
    (FranchiseId, FranchiseName, Networth)
VALUES (11, 'El Jefes Taqeria', 8293742.22);

INSERT INTO Store
(StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose,
 Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId)
VALUES (1, 'Symphony', '269 Huntington Avenue', 'Boston', 'MA', 02115, '08:00:00', '03:00:00', 111111.11, 1111.11,
        110000.00, 500.00, 435, 11),
       (2, 'Harvard Square', '14 Brattle Street', 'Cambridge', 'MA', 02138, '08:00:00', '04:00:00', 222222.22, 2222.22,
        220000.00, 600.00, 111, 11),
       (3, 'New Brunswick', '97 Hamilton Street', 'New Brunswick', 'NJ', 08901, '08:00:00', '04:00:00', 111111.11,
        1111.11, 110000.00, 600.00, 762, 11),
       (4, 'State College', '352 E. Calder Way ', 'State College', 'PA', 16801, '08:00:00', '04:00:00', 222222.22,
        2222.22, 220000.00, 700.00, 594, 11);

INSERT INTO Customer
(CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentZip, Email, Pass, HomeStoreId)
VALUES (975141, 'Gabbie', 'Ashplant', '51395 Columbus Parkway', 'Pasadena', 92293, 'gashplant0@tripadvisor.com',
        'McBHEnb', 1),
       (604561, 'Currie', 'Jantot', '03 Vidon Avenue', 'San Antonio', 86161, 'cjantot1@economist.com', 'PuJBEs', 1),
       (889787, 'Anjela', 'Leverette', '40 Anniversary Circle', 'Jamaica', 68882, 'aleverette2@statcounter.com',
        'o2LjPcN0Y', 2),
       (671090, 'Nichole', 'Trevear', '5 Mcguire Lane', 'Chicago', 70501, 'ntrevear3@whitehouse.gov', 'frrT1PayI07I',
        2),
       (854684, 'Fabian', 'Titterton', '58960 Grover Drive', 'Tulsa', 64851, 'ftitterton4@aboutads.info', 'HAZ8X42', 3),
       (881631, 'Beaufort', 'Eadie', '065 Melby Terrace', 'Jamaica', 49111, 'beadie5@state.tx.us', 'yAiK89', 4);

INSERT INTO Orders
(OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeCompleted, TimeToMake, CustomerId)
VALUES (12345, 1, '2022-01-23', 23.45, '15:06:47', '15:25:47', '00:19:00', 975141),
       (12346, 1, '2022-03-24', 12.58, '12:10:00', '12:15:01', '00:05:01', 604561),
       (12347, 2, '2022-05-01', 34.71, '01:16:10', '01:24:21', '00:08:11', 889787),
       (12348, 2, '2022-06-15', 62.61, '15:31:14', '15:45:14', '00:14:00', 671090),
       (12349, 3, '2022-07-12', 8.42, '19:16:24', '19:25:24', '00:09:00', 854684),
       (12350, 4, '2022-11-22', 32.28, '21:50:38', '22:05:40', '00:15:02', 881631);

INSERT INTO Investor
(InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip)
VALUES (100, 'Marshal', 'Semble', 'msemble0@ebay.co.uk', 418 - 170 - 9012, '84459 5th Park', 'Kansas City', 'MO',
        69829),
       (101, 'Bartie', 'Ardern', 'bardern0@prnewswire.com', 916 - 668 - 2767, '82 Carpenter Crossing', 'Boston', 'MA',
        02115),
       (102, 'Abigal', 'Barnes', 'barnes.a@hotwire.com', 413 - 905 - 4653, '76 Fanwood Road', 'Salem', 'MA', 23012);



INSERT INTO Investments
    (FranchiseId, InvId, InvStatus, Stake)
VALUES (11, 100, 'longtime', 51.00),
       (11, 101, 'new', 15.00),
       (11, 102, 'potential', 00.00);


INSERT INTO Shift
    (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked)
VALUES (111, '2022-11-10', '08:00:00', '12:00:00', 4, 3),
       (435, '2022-11-10', '15:00:00', '20:00:00', 5, 2);

INSERT INTO FoodType
    (TypeId, TypeName, BasePrice)
VALUES (111, 'Burrito', 11.00),
       (112, 'Bowl', 11.00),
       (113, 'Quesadilla', 12.00);

INSERT INTO Product
    (ProductId, Price, OrderId, TypeId)
VALUES (3212, 11.00, 12345, 111),
       (2838, 11.00, 12345, 112),
       (3722, 13.00, 12347, 113);

INSERT INTO Ingredient
(IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, StoreId)
VALUES (1111, 'White Rice', 103.54, 1.00, 'Hot', 5, 1),
       (1112, 'Grilled Chicken', 435.87, 2.50, 'Protein', 10, 2),
       (1232, 'Chipotle Mayo', 90.45, 0.00, 'Sauce', 12, 2);

INSERT INTO ProductIngredient
    (ProductId, IngredientId, Quantity)
VALUES (3212, 1111, 1),
       (3212, 1112, 2),
       (2838, 1111, 2),
       (3722, 1232, 4);


