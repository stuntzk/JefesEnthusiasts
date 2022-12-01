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
    Phone     BIGINT(10),
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
    StoreZip       CHAR(5)         NOT NULL,
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
    CurrentState  VARCHAR(20) NOT NULL,
    CurrentZip    CHAR(5)      NOT NULL,
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
    Phone     BIGINT(10)     NOT NULL,
    InvStreet VARCHAR(65) NOT NULL,
    InvCity   VARCHAR(20) NOT NULL,
    InvState  VARCHAR(20) NOT NULL,
    InvZip    CHAR(5)      NOT NULL,
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
        'cprinnett4@multiply.com', 5028021754,
        '711 Bluestem Avenue', 'Boston', 'MA', '02115', 435),
       (762, 'Tulley', 'Landall', 111111111, 'Cook', '1985-10-17', '2019-04-20', 18.00, 'tlandall6@mediafire.com',
        3942564307,
        '60 Briar Crest Trail', 'Fayetteville', 'NC', 33594, 435),
       (111, 'Kate', 'Stuntz', 111101111, 'Cashier', '2003-04-27', '2021-03-20', 21.00, 'stuntz.k@northeastern.com',
        6172564307,
        '68 Orchard Drive', 'New Canaan', 'CT', 03432, 435),
       (594, 'JJ', 'Farts', 132101111, 'Cook', '2000-01-01', '2019-03-23', 18.00, 'jj.farts@gmail.com',
        6174441221,
        '939 Gingerroot Road', 'Lincoln', 'NE', 33310, 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (989, 'Marin', 'Van Hove', 898109519, 'Cook', '1976-06-14', '2000-07-11', 22.43, 'mvanhove0@adobe.com', 2603561391, '05689 Kenwood Park', 'Saint Joseph', 'MO', '64504', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (454, 'Seamus', 'Sausman', 508925539, 'Cook', '1982-04-16', '2022-03-19', 17.60, 'ssausman1@alibaba.com', 9377860445, '2454 Bellgrove Trail', 'South Bend', 'IN', '46620', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (302, 'Ranna', 'Cayzer', 754056581, 'Cook', '1997-04-17', '2000-12-22', 29.24, 'rcayzer2@sbwire.com', 1823859921, '8 Prairieview Point', 'Minneapolis', 'MN', '55470', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (434, 'Jed', 'Kinchlea', 548911676, 'Cook', '1985-03-19', '2016-07-16', 39.92, 'jkinchlea3@mapquest.com', 9823693440, '186 Victoria Alley', 'Norfolk', 'VA', '23504', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (238, 'Cordey', 'Watkiss', 870161078, 'Support', '2000-03-11', '2018-03-21', 57.26, 'cwatkiss4@state.tx.us', 2795573427, '90 Di Loreto Terrace', 'Lansing', 'MI', '48912', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (583, 'Faber', 'Jobbings', 217043463, 'Support', '1996-01-08', '2019-03-23', 23.77, 'fjobbings5@spiegel.de', 7738381377, '75 Helena Pass', 'Buffalo', 'NY', '14225', 435);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (686, 'Ian', 'Bon', 196807795, 'Store Manager', '2008-08-30', '2009-07-30', 29.02, 'ibon6@theatlantic.com', 5950161376, '38 Center Circle', 'Washington', 'DC', '20575', 686);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (255, 'Avery', 'Covell', 564119951, 'Cook', '1975-09-25', '2006-06-06', 20.68, 'acovell7@twitter.com', 9578232065, '4999 Nancy Parkway', 'South Bend', 'IN', '46614', 686);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (976, 'Thatcher', 'Tatershall', 621447560, 'Support', '1996-10-20', '2020-06-04', 43.33, 'ttatershall8@tripadvisor.com', 3793118732, '5361 Holmberg Way', 'Newark', 'NJ', '07104', 686);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (817, 'Devan', 'Pettigrew', 532434924, 'Store Manager', '1973-06-17', '2005-05-07', 17.97, 'dpettigrew9@weibo.com', 2414860860, '8467 Eastlawn Pass', 'Charlotte', 'NC', '28205', 817);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (723, 'Raimundo', 'Dugget', 543934166, 'Store Manager', '1973-06-06', '2000-09-30', 10.65, 'rduggeta@mysql.com', 9959327446, '86 Maryland Crossing', 'El Paso', 'TX', '88579', 723);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (162, 'Tiff', 'Vigne', 639612513, 'Cook', '2003-07-05', '2008-07-20', 43.35, 'tvigneb@photobucket.com', 4091918582, '8506 Westridge Drive', 'Albuquerque', 'NM', '87140', 723);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (535, 'Gertrude', 'Manser', 340498764, 'Cook', '1995-05-31', '2017-05-25', 10.32, 'gmanserc@patch.com', 9969982222, '29951 Beilfuss Place', 'Iowa City', 'IA', '52245', 723);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (983, 'Giacinta', 'Huckerby', 257428602, 'Store Manager', '1978-11-30', '2009-08-06', 27.70, 'ghuckerbyd@gov.uk', 3600986312, '608 Packers Way', 'Dallas', 'TX', '75277', 983);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (718, 'Pavia', 'Kitteman', 860829636, 'Store Manager', '1991-10-10', '2010-05-21', 19.22, 'pkittemane@e-recht24.de', 9842908265, '97347 Mayfield Park', 'Boston', 'MA', '02203', 718);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (399, 'Nero', 'Fendt', 937564583, 'Cashier', '1997-11-12', '2007-09-23', 26.91, 'nfendtf@nationalgeographic.com', 6921503804, '39600 Mesta Plaza', 'Baltimore', 'MD', '21275', 817);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (729, 'Marline', 'Bischoff', 907659714, 'Cook', '1967-08-15', '2010-01-28', 59.37, 'mbischoffg@imdb.com', 6004843106, '51 Clove Center', 'Saint Louis', 'MO', '63136', 817);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (626, 'Francesco', 'Rubens', 738983054, 'Cashier', '2007-03-25', '2015-04-06', 55.68, 'frubensh@sohu.com', 9684034224, '17 Shoshone Hill', 'Norfolk', 'VA', '23520', 983);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (502, 'Lauraine', 'Purtell', 740492042, 'Cook', '1985-05-27', '2020-03-15', 18.51, 'lpurtelli@elpais.com', 6210253403, '305 Bluestem Lane', 'Elizabeth', 'NJ', '07208', 983);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (369, 'Dulce', 'Tendahl', 246281172, 'Cook', '1966-08-09', '2001-12-22', 22.48, 'dtendahlj@pcworld.com', 7575211313, '3 Schurz Trail', 'Fort Worth', 'TX', '76162', 983);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (478, 'Vivie', 'Attfield', 917370399, 'Support', '1990-04-10', '2020-12-27', 23.97, 'vattfieldk@tmall.com', 6439467658, '0230 Spohn Trail', 'Cumming', 'GA', '30130', 983);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (122, 'Lenore', 'Benedek', 327526429, 'Cook', '2004-04-04', '2013-11-03', 46.09, 'lbenedekl@google.ca', 6368178496, '2399 5th Pass', 'Philadelphia', 'PA', '19131', 983);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (201, 'Myrilla', 'Paslow', 744343231, 'Store Manager', '2007-04-14', '2013-08-10', 57.37, 'mpaslowm@loc.gov', 8510469971, '82 Nevada Junction', 'Houston', 'TX', '77260', 983);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (528, 'Leesa', 'Renzini', 544353875, 'Cashier', '2007-01-16', '2014-09-10', 13.94, 'lrenzinin@w3.org', 9839119791, '96 Main Place', 'Riverside', 'CA', '92519', 718);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (864, 'Pall', 'Hark', 930801764, 'Cook', '1977-05-17', '2016-05-14', 48.87, 'pharko@auda.org.au', 3407727002, '5806 Russell Crossing', 'Atlanta', 'GA', '30328', 718);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (293, 'Maison', 'Stygall', 472400068, 'Support', '1995-10-06', '2013-11-17', 32.76, 'mstygallp@dropbox.com', 7206717102, '8 Old Shore Trail', 'Cincinnati', 'OH', '45223', 718);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (209, 'Gannon', 'Pitrollo', 410764936, 'Cook', '1977-05-22', '2016-07-11', 38.24, 'gpitrolloq@hexun.com', 9348692610, '0 Crest Line Junction', 'Toledo', 'OH', '43615', 718);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (814, 'Glennis', 'Eslie', 337504525, 'Cashier', '1997-06-06', '2000-09-13', 25.97, 'geslier@amazonaws.com', 5931402512, '7314 Florence Way', 'San Diego', 'CA', '92105', 718);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (681, 'Onfre', 'Clissell', 831070199, 'Store Manager', '1982-06-30', '2017-10-21', 56.31, 'oclissells@icq.com', 6141784435, '4 Anniversary Junction', 'Detroit', 'MI', '48232', 681);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (785, 'Brina', 'Burchmore', 316865781, 'Store Manager', '2001-11-08', '2021-11-15', 48.37, 'bburchmoret@tinyurl.com', 3048835649, '37011 Anderson Parkway', 'San Antonio', 'TX', '78285', 785);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (758, 'Batholomew', 'Krollman', 202301054, 'Cashier', '1967-09-10', '2020-11-14', 23.93, 'bkrollmanu@ihg.com', 3576533790, '3373 Columbus Park', 'Cleveland', 'OH', '44125', 681);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (999, 'Hadrian', 'Wayt', 363639945, 'Cook', '1968-05-16', '2019-07-22', 32.6, 'hwaytv@goo.ne.jp', 7572200625, '04 Clarendon Trail', 'Shreveport', 'LA', '71115', 681);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (856, 'Jsandye', 'Guess', 111524110, 'Store Manager', '1994-11-29', '2007-07-31', 59.4, 'jguessw@posterous.com', 3231390307, '49 Raven Alley', 'Minneapolis', 'MN', '55446', 856);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (127, 'Idette', 'Tuckwood', 746645651, 'Support', '1977-12-02', '2018-11-13', 35.07, 'ituckwoodx@marketwatch.com', 5539448036, '0049 Dovetail Junction', 'Norfolk', 'VA', '23520', 681);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (295, 'Rudolph', 'MacKinnon', 147265637, 'Store Manager', '1993-11-01', '2022-01-06', 15.36, 'rmackinnony@msn.com', 5905782551, '82944 Mcguire Place', 'Herndon', 'VA', '22070', 295);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (488, 'Wade', 'Gailor', 671268028, 'Support', '1974-05-03', '2012-07-30', 33.48, 'wgailorz@dmoz.org', 4314257339, '4127 Melby Crossing', 'Norfolk', 'VA', '23514', 856);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (620, 'Twyla', 'Vaudre', 849770302, 'Cashier', '2004-08-26', '2019-02-14', 16.75, 'tvaudre10@usda.gov', 8272703156, '532 Manufacturers Street', 'Sarasota', 'FL', '34238', 856);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (552, 'Masha', 'Dunkerly', 671384626, 'Cook', '1982-02-08', '2009-08-08', 56.85, 'mdunkerly11@purevolume.com', 7885959406, '32 Kinsman Court', 'Pueblo', 'CO', '81015', 856);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (117, 'Rosanne', 'Nutbean', 815356886, 'Cashier', '1976-03-06', '2002-03-08', 48.69, 'rnutbean12@hud.gov', 8926026966, '22853 Pankratz Drive', 'Berkeley', 'CA', '94712', 856);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (705, 'Alisha', 'Rydings', 566268027, 'Store Manager', '1979-07-15', '2010-06-28', 57.44, 'arydings13@creativecommons.org', 7368926840, '9084 Clove Alley', 'El Paso', 'TX', '79984', 705);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (360, 'Isis', 'Rathbourne', 311008305, 'Store Manager', '2004-08-04', '2020-11-23', 17.49, 'irathbourne14@people.com.cn', 1796360519, '35392 Hoard Avenue', 'Seattle', 'WA', '98127', 360);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (313, 'Constance', 'Aimson', 222521608, 'Store Manager', '2003-08-26', '2001-08-06', 55.19, 'caimson15@upenn.edu', 5336295698, '64850 Melby Court', 'Jackson', 'MS', '39210', 313);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (477, 'Doralynne', 'Branney', 876839770, 'Cook', '1979-10-09', '2006-06-12', 11.16, 'dbranney16@hatena.ne.jp', 4824351913, '087 Carioca Lane', 'Jacksonville', 'FL', '32277', 681);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (439, 'Keith', 'Manvell', 703806137, 'Cook', '1994-12-20', '2021-01-22', 24.16, 'kmanvell17@eventbrite.com', 9935998703, '18241 Bayside Terrace', 'Sacramento', 'CA', '94291', 681);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (479, 'Reta', 'Dare', 153393278, 'Cashier', '1991-10-04', '2015-03-05', 54.69, 'rdare18@whitehouse.gov', 5039384014, '495 Elka Road', 'Los Angeles', 'CA', '90081', 681);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (129, 'Ced', 'Douris', 284777421, 'Store Manager', '1982-08-13', '2019-08-27', 51.33, 'cdouris19@toplist.cz', 7131112858, '1831 Crescent Oaks Court', 'Erie', 'PA', '16505', 129);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (602, 'Nevins', 'Dod', 351165984, 'Cook', '2002-12-08', '2000-05-29', 39.37, 'ndod1a@exblog.jp', 3643463474, '99 Clarendon Hill', 'Birmingham', 'AL', '35220', 129);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (424, 'Willie', 'Vaney', 654544243, 'Store Manager', '2001-06-30', '2011-05-15', 11.34, 'wvaney1c@booking.com', 6470846936, '79 Aberg Point', 'Concord', 'CA', '94522', 424);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (240, 'Nanice', 'Rappport', 986052586, 'Cashier', '1985-12-29', '2006-07-26', 49.04, 'nrappport1d@printfriendly.com', 8294621402, '3359 Victoria Road', 'Pittsburgh', 'PA', '15255', 129);

INSERT INTO Franchise
    (FranchiseId, FranchiseName, Networth)
VALUES (11, 'El Jefes Taqeria', 8293742.22);
insert into Franchise (FranchiseId, FranchiseName, Networth) values (12, 'Buzzster', 8010321999.24);
insert into Franchise (FranchiseId, FranchiseName, Networth) values (13, 'Skaboo', 7669541403.45);
insert into Franchise (FranchiseId, FranchiseName, Networth) values (14, 'Jabberstorm', 5098751417.31);
insert into Franchise (FranchiseId, FranchiseName, Networth) values (15, 'Snaptags', 7692006753.98);
insert into Franchise (FranchiseId, FranchiseName, Networth) values (16, 'Roombo', 9641188555.41);
insert into Franchise (FranchiseId, FranchiseName, Networth) values (17, 'Browsecat', 662276782.83);
insert into Franchise (FranchiseId, FranchiseName, Networth) values (18, 'Skynoodle', 5777465209.91);
insert into Franchise (FranchiseId, FranchiseName, Networth) values (19, 'Pixoboo', 6300835485.44);
insert into Franchise (FranchiseId, FranchiseName, Networth) values (20, 'Kwideo', 6817624229.46);
insert into Franchise (FranchiseId, FranchiseName, Networth) values (21, 'Riffwire', 7977271398.98);
insert into Franchise (FranchiseId, FranchiseName, Networth) values (22, 'Zazio', 9795468394.96);
insert into Franchise (FranchiseId, FranchiseName, Networth) values (23, 'BlogXS', 9250362452.43);
insert into Franchise (FranchiseId, FranchiseName, Networth) values (24, 'Yombu', 4643740063.49);
insert into Franchise (FranchiseId, FranchiseName, Networth) values (25, 'Podcat', 2112097663.85);
insert into Franchise (FranchiseId, FranchiseName, Networth) values (26, 'Vipe', 7356041098.29);

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
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (5, 'Clarendon', '48843 Oakridge Crossing', 'Hartford', 'CT', '06160', '11:05:22', '4:31:02', 383568244.73, 80160.12, 140879249.59, 76950.84, 686, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (6, 'Lillian', '355 Muir Hill', 'Midland', 'TX', '79705', '8:38:53', '5:55:02', 868378672.0, 63260.08, 191675067.03, 56664.93, 817, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (7, 'Colorado', '7259 Lunder Crossing', 'Birmingham', 'AL', '35225', '11:13:23', '5:38:37', 147577851.53, 98782.54, 608827150.35, 48389.63, 723, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (8, 'Stang', '50303 Morrow Place', 'Raleigh', 'NC', '27635', '7:22:08', '3:07:52', 403806492.38, 17865.52, 135514810.47, 4699.97, 983, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (9, 'Carey', '362 Fisk Crossing', 'Staten Island', 'NY', '10310', '8:22:57', '3:11:57', 341719627.7, 89349.47, 137457260.59, 57435.72, 718, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (10, 'Claremont', '65054 Hayes Road', 'Brooklyn', 'NY', '11231', '6:44:27', '5:52:17', 411690806.24, 91348.8, 436274685.72, 64302.96, 681, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (11, 'Crest Line', '89 Dorton Park', 'Lansing', 'MI', '48912', '8:16:11', '3:43:00', 473382655.41, 59344.13, 672909179.77, 40751.24, 785, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (12, 'Anhalt', '6 Tennyson Hill', 'Irving', 'TX', '75062', '8:13:38', '5:31:55', 921774628.91, 78265.27, 102699993.29, 62293.97, 856, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (13, 'Delladonna', '56 Glendale Crossing', 'Kansas City', 'MO', '64109', '9:19:48', '3:37:49', 185459229.61, 36161.05, 447633328.26, 81726.61, 295, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (14, 'Maywood', '808 Ruskin Road', 'Boca Raton', 'FL', '33432', '7:03:50', '3:05:01', 682581387.94, 21879.47, 397613007.55, 25266.36, 705, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (15, 'Boyd', '116 Dahle Plaza', 'Seattle', 'WA', '98121', '11:02:22', '3:20:51', 511452968.63, 29518.35, 923291044.79, 68346.92, 360, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (16, 'Meadow Valley', '4 Mandrake Place', 'Tacoma', 'WA', '98411', '8:13:14', '3:03:44', 62811844.18, 70954.63, 586867065.41, 80369.22, 313, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (17, 'Eliot', '20 Forest Dale Court', 'Houston', 'TX', '77070', '9:26:57', '5:53:49', 67641837.05, 68864.4, 834130877.81, 59865.03, 129, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (18, 'Village', '1806 Stone Corner Court', 'Jacksonville', 'FL', '32215', '9:51:38', '2:13:02', 33113704.52, 48935.49, 763832107.35, 84470.79, 424, 11);

INSERT INTO Customer
(CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId)
VALUES (975141, 'Gabbie', 'Ashplant', '51395 Columbus Parkway', 'Pasadena','CA', 92293, 'gashplant0@tripadvisor.com',
        'McBHEnb', 1),
       (604561, 'Currie', 'Jantot', '03 Vidon Avenue', 'San Antonio', 'CA', 86161, 'cjantot1@economist.com', 'PuJBEs', 1),
       (889787, 'Anjela', 'Leverette', '40 Anniversary Circle', 'Jamaica','NY', 68882, 'aleverette2@statcounter.com',
        'o2LjPcN0Y', 2),
       (671090, 'Nichole', 'Trevear', '5 Mcguire Lane', 'Chicago', 'IL', 70501, 'ntrevear3@whitehouse.gov', 'frrT1PayI07I',
        2),
       (854684, 'Fabian', 'Titterton', '58960 Grover Drive', 'Tulsa','OK', 64851, 'ftitterton4@aboutads.info', 'HAZ8X42', 3),
       (881631, 'Beaufort', 'Eadie', '065 Melby Terrace', 'Jamaica','NY', 49111, 'beadie5@state.tx.us', 'yAiK89', 4);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12351, 'Ashien', 'Crimes', '74 Everett Road', 'Pittsburgh', 'PA', '15274', 'acrimes0@bbc.co.uk', '5Brg8m', 10);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12352, 'Pet', 'Dabes', '28912 Linden Trail', 'Portland', 'OR', '97206', 'pdabes1@plala.or.jp', 'WtDY2djZ', 2);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12353, 'Jesus', 'Huntriss', '3065 Wayridge Place', 'Charleston', 'WV', '25362', 'jhuntriss2@marriott.com', 'KVyQQh0PrJ', 7);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12354, 'Carlene', 'Kelcey', '5741 Autumn Leaf Alley', 'New York City', 'NY', '10034', 'ckelcey3@army.mil', 'SSd9FlwtR', 18);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12355, 'Enos', 'Guihen', '78168 Crowley Hill', 'Tulsa', 'OK', '74149', 'eguihen4@state.tx.us', 'GfZi9wakPC', 14);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12356, 'Kandy', 'Saylor', '99 Ludington Lane', 'Monroe', 'LA', '71213', 'ksaylor5@yandex.ru', '82Rt8bpI2f', 12);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12357, 'Dolli', 'Tichelaar', '646 Fulton Hill', 'Simi Valley', 'CA', '93094', 'dtichelaar6@home.pl', 'rtMgr4m', 10);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12358, 'Blake', 'Andriulis', '6841 Basil Avenue', 'Dayton', 'OH', '45470', 'bandriulis7@xinhuanet.com', 'saGVgNoPTBZs', 2);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12359, 'Ashley', 'Whatmough', '54 Hintze Lane', 'Naples', 'FL', '33961', 'awhatmough8@tumblr.com', 'EXruJVUl9', 11);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12360, 'Ailsun', 'Berka', '97 Dunning Junction', 'Miami', 'FL', '33164', 'aberka9@state.tx.us', 'BdbgnTCwV', 17);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12361, 'Ariella', 'Binnie', '1456 Pine View Parkway', 'Omaha', 'NE', '68124', 'abinniea@delicious.com', 'KZ0vI38xt', 13);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12362, 'Ermentrude', 'Stutely', '664 Sycamore Lane', 'Jefferson City', 'MO', '65105', 'estutelyb@foxnews.com', 'eQ1oy7t', 14);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12363, 'Hamil', 'Forsyde', '850 Hoffman Hill', 'Providence', 'RI', '02912', 'hforsydec@51.la', 'Wv8jTCb9E3A', 1);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12364, 'Cymbre', 'Rambaut', '38996 Heffernan Point', 'Clearwater', 'FL', '33758', 'crambautd@techcrunch.com', 'WZxMkoz', 14);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12365, 'Craggy', 'Lanfere', '2 Superior Road', 'Durham', 'NC', '27705', 'clanferee@friendfeed.com', 'GIdGOm', 12);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12366, 'Edgar', 'Harrill', '068 Arrowood Alley', 'Los Angeles', 'CA', '90076', 'eharrillf@ucla.edu', 'ByS43wAfBl', 13);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12367, 'Wandie', 'Palethorpe', '9 Pearson Point', 'Kansas City', 'MO', '64136', 'wpalethorpeg@theglobeandmail.com', 'Tay7O3PdiduP', 8);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12368, 'Orelee', 'Skough', '17729 Shoshone Lane', 'Aiken', 'SC', '29805', 'oskoughh@eventbrite.com', 'sQFrRrC', 6);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12369, 'Weider', 'Melly', '7382 Hoepker Place', 'Orlando', 'FL', '32891', 'wmellyi@artisteer.com', 'U0Oe39', 14);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12370, 'Cyrille', 'Bartels', '43 Anderson Road', 'San Diego', 'CA', '92196', 'cbartelsj@amazon.de', 'ykKDb6V6st6', 16);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12371, 'Benny', 'Ravenscroft', '0098 Mayfield Point', 'Great Neck', 'NY', '11024', 'bravenscroftk@rakuten.co.jp', 'XTbqEku6', 10);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12372, 'Frances', 'Jude', '598 Merchant Junction', 'Birmingham', 'AL', '35279', 'fjudel@hhs.gov', 'opt777aUfPG', 15);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12373, 'Lucky', 'Clewes', '4907 Sheridan Road', 'Tampa', 'FL', '33625', 'lclewesm@oracle.com', 'TNKIMk5fM', 5);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12374, 'Alis', 'Northcliffe', '70 Veith Plaza', 'Midland', 'MI', '48670', 'anorthcliffen@chron.com', 'nhSyqjWb54', 4);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12375, 'Natty', 'Arrigo', '05160 Porter Center', 'Wilmington', 'DE', '19886', 'narrigoo@liveinternet.ru', 'C8Xguj', 8);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12376, 'Kimmie', 'Genicke', '3235 Hovde Park', 'Falls Church', 'VA', '22047', 'kgenickep@mysql.com', 'tgYfpnpsc9uw', 10);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12377, 'Walt', 'Brant', '59680 Kingsford Way', 'Phoenix', 'AZ', '85020', 'wbrantq@alibaba.com', 'KWJOL0my', 18);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12378, 'Luca', 'Mendoza', '7949 Norway Maple Plaza', 'White Plains', 'NY', '10606', 'lmendozar@bloglines.com', 'tvZtDhtY', 16);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12379, 'Colette', 'Durham', '1 Crest Line Road', 'Ogden', 'UT', '84409', 'cdurhams@blinklist.com', '7gcKhb0ngI5', 10);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12380, 'Arlina', 'Ing', '27 Spohn Street', 'Houston', 'TX', '77080', 'aingt@about.com', '0VChXRperD', 6);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12381, 'Eilis', 'Kegg', '0 Artisan Park', 'New York City', 'NY', '10160', 'ekeggu@sitemeter.com', 's62HNO2lMSLH', 9);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12382, 'Meridith', 'Coggings', '91290 Marcy Drive', 'Davenport', 'IA', '52809', 'mcoggingsv@salon.com', 'TqGVkNS', 14);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12383, 'Reade', 'Veale', '91 Arapahoe Avenue', 'Sacramento', 'CA', '94297', 'rvealew@globo.com', 'mPIa9NjiV7w8', 6);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12384, 'Cory', 'Pawlik', '871 Birchwood Park', 'Charlotte', 'NC', '28205', 'cpawlikx@economist.com', 'L4IFaGFeyUu', 18);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12385, 'Renaldo', 'Greenway', '81 Dwight Way', 'Beaverton', 'OR', '97075', 'rgreenwayy@jugem.jp', 'ohCmbKra5', 5);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12386, 'Stoddard', 'Dedmam', '7 Norway Maple Trail', 'Atlanta', 'GA', '31165', 'sdedmamz@go.com', 'SiZchAt', 1);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12387, 'Artemus', 'Quare', '15418 Riverside Crossing', 'Seminole', 'FL', '34642', 'aquare10@businesswire.com', 'QJpiLc8sv', 11);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12388, 'Alon', 'Fellows', '99297 Badeau Place', 'Lawrenceville', 'GA', '30245', 'afellows11@china.com.cn', 'aawyIoXPf', 12);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12389, 'Aretha', 'Dooman', '00 Grover Park', 'Wilmington', 'DE', '19886', 'adooman12@icio.us', 'YGH3ltLHHF4', 7);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12390, 'Virginia', 'Romme', '1081 Green Circle', 'New Haven', 'CT', '06510', 'vromme13@issuu.com', 'm7qRqbgf', 15);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12391, 'Penelopa', 'Temblett', '1 Shasta Terrace', 'Albany', 'NY', '12247', 'ptemblett14@oaic.gov.au', 'JXCFJXM', 14);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12392, 'Randell', 'Whapham', '537 Quincy Place', 'Saint Louis', 'MO', '63150', 'rwhapham15@omniture.com', 'JRG9TmugptD', 7);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12393, 'Stanfield', 'Harwin', '38 Mayer Road', 'Washington', 'DC', '20430', 'sharwin16@miitbeian.gov.cn', 'M2XMUxXW9g', 11);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12394, 'Cory', 'Kaemena', '2967 Paget Pass', 'Chattanooga', 'TN', '37410', 'ckaemena17@msn.com', 'sHuQWYfQ', 18);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12395, 'Charla', 'Spadollini', '3536 7th Park', 'Houston', 'TX', '77060', 'cspadollini18@loc.gov', 'dl86Yuo', 5);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12396, 'Effie', 'Stilldale', '9373 Banding Street', 'Louisville', 'KY', '40293', 'estilldale19@homestead.com', 'Yky0sdz7Vth', 7);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12397, 'Rutter', 'Bacon', '1314 Kennedy Street', 'Lubbock', 'TX', '79410', 'rbacon1a@cnn.com', 'B3hAIp6', 11);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12398, 'Christophorus', 'Monument', '73710 Katie Drive', 'Galveston', 'TX', '77554', 'cmonument1b@engadget.com', 'ejvRoDJnaF', 14);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12399, 'Heddi', 'McLauchlin', '593 Shelley Plaza', 'Houston', 'TX', '77293', 'hmclauchlin1c@comcast.net', '2gpJLjk3S', 8);
insert into Customer (CustId, FirstName, LastName, CurrentStreet, CurrentCity, CurrentState, CurrentZip, Email, Pass, HomeStoreId) values (12400, 'Ira', 'Hame', '2223 Fremont Pass', 'Carol Stream', 'IL', '60351', 'ihame1d@behance.net', 'jETPuZvSR8O', 7);

INSERT INTO Orders
(OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeCompleted, TimeToMake, CustomerId)
VALUES (12345, 1, '2022-01-23', 23.45, '15:06:47', '15:25:47', '00:19:00', 975141),
       (12346, 1, '2022-03-24', 12.58, '12:10:00', '12:15:01', '00:05:01', 604561),
       (12347, 2, '2022-05-01', 34.71, '01:16:10', '01:24:21', '00:08:11', 889787),
       (12348, 2, '2022-06-15', 62.61, '15:31:14', '15:45:14', '00:14:00', 671090),
       (12349, 3, '2022-07-12', 8.42, '19:16:24', '19:25:24', '00:09:00', 854684),
       (12350, 4, '2022-11-22', 32.28, '21:50:38', '22:05:40', '00:15:02', 881631);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12351, 15, '2022-09-16', 50.5, '18:23:00', '00:20:18', '18:43:18', 12386);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12352, 11, '2022-06-14', 70.93, '13:04:44', '00:22:27', '13:27:11', 12372);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12353, 8, '2022-09-27', 87.83, '03:02:54', '00:10:22', '03:13:16', 12364);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12354, 16, '2022-01-09', 65.4, '00:43:49', '00:00:58', '00:44:47', 12390);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12355, 11, '2022-02-21', 12.46, '19:52:51', '00:08:32', '20:01:23', 12393);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12356, 4, '2022-03-15', 109.4, '02:17:59', '00:13:18', '02:31:17', 12394);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12357, 7, '2022-10-15', 49.33, '03:46:58', '00:15:28', '04:02:26', 12373);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12358, 12, '2022-09-04', 11.11, '06:26:50', '00:02:29', '06:29:19', 12391);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12359, 8, '2022-04-14', 66.86, '02:53:48', '00:16:20', '03:10:08', 12394);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12360, 3, '2022-04-03', 63.29, '08:28:12', '00:00:04', '08:28:16', 12358);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12361, 5, '2022-03-22', 13.49, '11:22:50', '00:11:50', '11:34:40', 12399);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12362, 11, '2022-11-12', 38.68, '07:35:43', '00:03:42', '07:39:25', 12398);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12363, 3, '2022-04-22', 113.37, '13:28:25', '00:09:25', '13:37:50', 12392);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12364, 4, '2022-09-10', 112.5, '08:21:30', '00:07:44', '08:29:14', 12378);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12365, 5, '2022-07-11', 107.64, '16:16:31', '00:20:43', '16:37:14', 12370);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12366, 4, '2022-01-01', 25.99, '01:06:40', '00:21:27', '01:28:07', 12380);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12367, 4, '2022-08-18', 27.53, '21:58:09', '00:14:17', '22:12:26', 12360);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12368, 8, '2022-08-06', 27.88, '05:31:24', '00:05:06', '05:36:30', 12370);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12369, 11, '2022-01-17', 145.82, '01:24:08', '00:23:31', '01:47:39', 12376);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12370, 1, '2022-02-04', 78.84, '03:22:51', '00:19:41', '03:42:32', 12382);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12371, 5, '2022-11-14', 144.96, '01:23:52', '00:17:49', '01:41:41', 12394);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12372, 3, '2022-06-02', 55.59, '22:57:20', '00:15:49', '23:13:09', 12397);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12373, 6, '2022-02-14', 97.2, '05:33:25', '00:02:35', '05:36:00', 12353);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12374, 15, '2022-10-12', 16.4, '14:28:44', '00:19:48', '14:48:32', 12394);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12375, 18, '2022-09-15', 49.86, '21:01:08', '00:17:34', '21:18:42', 12366);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12376, 13, '2022-07-14', 20.69, '10:44:56', '00:08:05', '10:53:01', 12380);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12377, 12, '2022-05-31', 101.26, '22:06:15', '00:07:13', '22:13:28', 12374);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12378, 10, '2022-10-11', 145.15, '22:43:52', '00:03:22', '22:47:14', 12400);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12379, 15, '2022-07-10', 60.2, '21:23:23', '00:01:49', '21:25:12', 12374);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12380, 2, '2022-08-12', 144.56, '11:37:43', '00:18:24', '11:56:07', 12400);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12381, 11, '2022-02-21', 18.22, '01:12:01', '00:20:28', '01:32:29', 12354);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12382, 13, '2022-10-20', 12.01, '17:40:33', '00:03:03', '17:43:36', 12359);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12383, 11, '2022-02-16', 23.56, '06:22:26', '00:20:20', '06:42:46', 12356);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12384, 1, '2022-04-27', 109.43, '22:50:40', '00:00:14', '22:50:54', 12356);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12385, 1, '2022-02-21', 139.03, '14:54:37', '00:19:54', '15:14:31', 12398);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12386, 17, '2022-01-25', 123.02, '09:47:46', '00:09:16', '09:57:02', 12372);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12387, 4, '2022-07-14', 47.5, '13:14:00', '00:22:21', '13:36:21', 12375);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12388, 5, '2022-07-29', 36.15, '23:12:19', '00:22:54', '23:35:13', 12394);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12389, 10, '2022-11-29', 94.23, '16:37:10', '00:20:30', '16:57:40', 12397);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12390, 13, '2022-05-21', 71.19, '07:20:25', '00:03:08', '07:23:33', 12393);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12391, 9, '2022-03-19', 134.95, '20:26:36', '00:08:04', '20:34:40', 12368);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12392, 3, '2022-08-21', 100.67, '10:12:13', '00:16:57', '10:29:10', 12373);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12393, 7, '2022-07-25', 47.57, '13:05:28', '00:20:45', '13:26:13', 12354);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12394, 7, '2022-04-17', 124.13, '06:09:04', '00:21:19', '06:30:23', 12355);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12395, 14, '2022-06-06', 59.59, '07:54:05', '00:15:03', '08:09:08', 12384);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12396, 13, '2022-11-20', 53.66, '03:07:28', '00:12:21', '03:19:49', 12363);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12397, 7, '2022-09-30', 39.12, '13:46:41', '00:07:38', '13:54:19', 12384);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12398, 15, '2022-09-05', 96.83, '00:33:32', '00:04:30', '00:38:02', 12368);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12399, 13, '2022-02-26', 19.04, '10:57:23', '00:01:41', '10:59:04', 12362);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12400, 18, '2022-01-02', 14.82, '20:42:13', '00:24:16', '21:06:29', 12366);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12401, 6, '2022-09-02', 37.31, '16:14:42', '00:09:04', '16:23:46', 12376);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12402, 12, '2022-04-27', 142.62, '12:21:25', '00:07:30', '12:28:55', 12375);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12403, 10, '2022-04-28', 130.73, '19:31:09', '00:07:58', '19:39:07', 12363);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12404, 2, '2022-09-14', 8.29, '06:46:37', '00:04:13', '06:50:50', 12375);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12405, 13, '2022-05-16', 77.53, '11:56:00', '00:04:28', '12:00:28', 12400);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12406, 1, '2022-04-18', 21.84, '03:36:06', '00:07:53', '03:43:59', 12395);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12407, 16, '2022-01-18', 65.83, '16:23:58', '00:00:52', '16:24:50', 12390);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12408, 2, '2022-11-21', 65.54, '11:22:51', '00:19:24', '11:42:15', 12358);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12409, 3, '2022-09-06', 95.89, '17:24:00', '00:10:13', '17:34:13', 12382);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12410, 12, '2022-10-03', 128.21, '12:27:31', '00:10:45', '12:38:16', 12400);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12411, 18, '2022-07-15', 118.55, '02:27:22', '00:02:45', '02:30:07', 12393);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12412, 9, '2022-02-01', 113.3, '19:19:02', '00:02:37', '19:21:39', 12378);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12413, 18, '2022-03-05', 109.14, '07:00:53', '00:02:03', '07:02:56', 12388);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12414, 2, '2022-08-17', 39.33, '08:29:43', '00:15:34', '08:45:17', 12367);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12415, 13, '2022-10-12', 87.38, '10:29:46', '00:12:14', '10:42:00', 12365);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12416, 15, '2022-11-27', 100.16, '10:59:11', '00:08:50', '11:08:01', 12388);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12417, 4, '2022-09-21', 117.74, '10:17:44', '00:20:18', '10:38:02', 12363);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12418, 4, '2022-05-04', 32.27, '14:50:04', '00:04:48', '14:54:52', 12386);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12419, 6, '2022-07-12', 105.1, '16:30:35', '00:18:34', '16:49:09', 12379);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12420, 8, '2022-10-25', 132.28, '09:53:11', '00:11:19', '10:04:30', 12397);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12421, 4, '2022-03-31', 23.83, '16:21:06', '00:17:10', '16:38:16', 12389);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12422, 14, '2022-04-22', 89.73, '15:03:09', '00:17:44', '15:20:53', 12389);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12423, 2, '2022-09-13', 19.35, '02:11:56', '00:13:18', '02:25:14', 12382);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12424, 15, '2022-03-15', 86.79, '08:05:10', '00:04:37', '08:09:47', 12391);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12425, 11, '2022-07-20', 96.71, '02:11:02', '00:22:04', '02:33:06', 12383);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12426, 9, '2022-01-31', 140.72, '19:44:31', '00:06:14', '19:50:45', 12381);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12427, 12, '2022-06-16', 134.03, '15:04:12', '00:24:29', '15:28:41', 12358);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12428, 2, '2022-04-26', 120.06, '22:23:50', '00:23:18', '22:47:08', 12374);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12429, 16, '2022-07-19', 113.53, '17:22:18', '00:22:13', '17:44:31', 12380);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12430, 1, '2022-08-29', 22.15, '22:04:01', '00:11:01', '22:15:02', 12398);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12431, 6, '2022-01-18', 64.83, '14:05:57', '00:12:08', '14:18:05', 12377);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12432, 3, '2022-08-20', 135.66, '03:49:08', '00:18:02', '04:07:10', 12380);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12433, 5, '2022-04-22', 19.55, '18:02:27', '00:01:31', '18:03:58', 12370);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12434, 15, '2022-05-12', 115.61, '03:37:43', '00:09:14', '03:46:57', 12359);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12435, 3, '2022-09-21', 134.41, '07:08:09', '00:19:58', '07:28:07', 12354);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12436, 13, '2022-07-14', 112.01, '07:01:29', '00:07:06', '07:08:35', 12378);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12437, 10, '2022-01-10', 64.31, '00:39:28', '00:16:56', '00:56:24', 12387);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12438, 2, '2022-08-30', 8.13, '02:42:23', '00:14:10', '02:56:33', 12380);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12439, 8, '2022-08-01', 149.82, '04:59:33', '00:17:28', '05:17:01', 12358);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12440, 14, '2022-08-30', 58.17, '20:22:04', '00:00:07', '20:22:11', 12387);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12441, 11, '2022-03-02', 24.05, '07:35:54', '00:17:21', '07:53:15', 12399);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12442, 4, '2022-05-20', 77.52, '04:11:14', '00:08:13', '04:19:27', 12376);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12443, 1, '2022-10-05', 48.66, '09:29:05', '00:05:45', '09:34:50', 12355);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12444, 2, '2022-10-31', 65.78, '15:17:22', '00:14:16', '15:31:38', 12395);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12445, 3, '2022-07-13', 70.05, '17:15:12', '00:03:25', '17:18:37', 12368);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12446, 1, '2022-08-10', 90.7, '02:18:41', '00:15:00', '02:33:41', 12363);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12447, 17, '2022-11-22', 50.74, '10:58:20', '00:11:08', '11:09:28', 12371);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12448, 12, '2022-04-07', 124.82, '14:22:10', '00:09:13', '14:31:23', 12362);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12449, 6, '2022-09-16', 14.15, '07:37:24', '00:21:43', '07:59:07', 12385);
insert into Orders (OrderId, StoreId, OrderDate, TotalPrice, TimeOrdered, TimeToMake, TimeCompleted, CustomerId) values (12450, 2, '2022-08-06', 40.07, '18:38:54', '00:00:14', '18:39:08', 12390);

INSERT INTO Investor
(InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip)
VALUES (100, 'Marshal', 'Semble', 'msemble0@ebay.co.uk', 418 - 170 - 9012, '84459 5th Park', 'Kansas City', 'MO',
        69829),
       (101, 'Bartie', 'Ardern', 'bardern0@prnewswire.com', 916 - 668 - 2767, '82 Carpenter Crossing', 'Boston', 'MA',
        02115),
       (102, 'Abigal', 'Barnes', 'barnes.a@hotwire.com', 413 - 905 - 4653, '76 Fanwood Road', 'Salem', 'MA', 23012);
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (103, 'Jobie', 'Harsnep', 'jharsnep0@prnewswire.com', 952825077, '63692 Westport Street', 'New York City', 'NY', '10034');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (104, 'Rufus', 'Gouldbourn', 'rgouldbourn1@flavors.me', 278803262, '330 Pierstorff Road', 'Wichita', 'KS', '67220');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (105, 'Merlina', 'Van Halle', 'mvanhalle2@purevolume.com', 979485583, '4 Basil Circle', 'Phoenix', 'AZ', '85005');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (106, 'Brittne', 'Sabate', 'bsabate3@lycos.com', 593209827, '3 Debs Parkway', 'Washington', 'DC', '20205');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (107, 'Eileen', 'Tune', 'etune4@ucoz.com', 940963825, '18 Almo Point', 'Bowie', 'MD', '20719');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (108, 'Marita', 'Grzes', 'mgrzes5@cbslocal.com', 439131439, '72 Merrick Hill', 'Springfield', 'IL', '62705');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (109, 'Loydie', 'Stace', 'lstace6@google.com', 588028706, '18878 Spohn Avenue', 'Waco', 'TX', '76796');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (110, 'Jeramey', 'Cumming', 'jcumming7@51.la', 658939292, '86 Merry Point', 'San Francisco', 'CA', '94147');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (111, 'Siana', 'Arnaudi', 'sarnaudi8@edublogs.org', 824579906, '991 Cherokee Park', 'New York City', 'NY', '10275');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (112, 'Gardiner', 'Lattka', 'glattka9@yahoo.com', 698747648, '1790 Ilene Drive', 'Santa Fe', 'NM', '87505');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (113, 'Clovis', 'McGuckin', 'cmcguckina@cnbc.com', 853429690, '6 Pine View Circle', 'Jamaica', 'NY', '11480');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (114, 'Faustine', 'Taggert', 'ftaggertb@latimes.com', 799032360, '7866 Dawn Circle', 'Brooklyn', 'NY', '11236');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (115, 'Yard', 'Thornewill', 'ythornewillc@nifty.com', 605254803, '9 Mayfield Park', 'South Lake Tahoe', 'CA', '96154');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (116, 'Katharina', 'Stitwell', 'kstitwelld@princeton.edu', 582656309, '5359 Forest Run Junction', 'Cincinnati', 'OH', '45208');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (117, 'Kendricks', 'Racher', 'krachere@1und1.de', 548058707, '4 Portage Road', 'Little Rock', 'AR', '72222');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (118, 'Randi', 'Ambler', 'ramblerf@yolasite.com', 534554255, '85538 Roxbury Alley', 'New Orleans', 'LA', '70124');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (119, 'Meredith', 'Noah', 'mnoahg@wikimedia.org', 934667007, '4762 Oriole Street', 'Nashville', 'TN', '37250');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (120, 'Charlot', 'O''Hagirtie', 'cohagirtieh@ustream.tv', 302959346, '6196 Manufacturers Crossing', 'Oklahoma City', 'OK', '73152');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (121, 'Reinaldos', 'Skerme', 'rskermei@engadget.com', 299337656, '1263 Sachs Court', 'Dayton', 'OH', '45426');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (122, 'Tammie', 'Penreth', 'tpenrethj@paginegialle.it', 378036380, '10350 Brentwood Way', 'Des Moines', 'IA', '50310');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (123, 'Reginald', 'Kynman', 'rkynmank@eventbrite.com', 639948862, '2741 Evergreen Alley', 'San Antonio', 'TX', '78225');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (124, 'Ursola', 'Caird', 'ucairdl@macromedia.com', 344328498, '1 Charing Cross Terrace', 'Corpus Christi', 'TX', '78426');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (125, 'Clement', 'Heading', 'cheadingm@cocolog-nifty.com', 952419711, '21346 Melby Place', 'Lakeland', 'FL', '33811');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (126, 'Marna', 'Batrick', 'mbatrickn@home.pl', 582317966, '79 Clove Junction', 'Fort Worth', 'TX', '76198');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (127, 'Geralda', 'Marland', 'gmarlando@goo.gl', 955607528, '7426 Chive Alley', 'Phoenix', 'AZ', '85020');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (128, 'Joice', 'Stopper', 'jstopperp@taobao.com', 140153433, '062 Park Meadow Plaza', 'Wichita Falls', 'TX', '76305');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (129, 'Pren', 'Bale', 'pbaleq@admin.ch', 242648738, '1314 Kedzie Avenue', 'Hicksville', 'NY', '11854');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (130, 'Kahlil', 'Klossmann', 'kklossmannr@nba.com', 693707433, '1 Walton Way', 'Huntington', 'WV', '25711');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (131, 'Raina', 'Boc', 'rbocs@sun.com', 930108234, '4319 Amoth Terrace', 'Mesa', 'AZ', '85205');
insert into Investor (InvId, FirstName, LastName, Email, Phone, InvStreet, InvCity, InvState, InvZip) values (132, 'Irma', 'Pownall', 'ipownallt@miitbeian.gov.cn', 697950953, '774 Continental Drive', 'Lima', 'OH', '45807');


INSERT INTO Investments
    (FranchiseId, InvId, InvStatus, Stake)
VALUES (11, 100, 'longtime', 51.00),
       (11, 101, 'new', 15.00),
       (11, 102, 'potential', 00.00);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (12, 109, 'longtime', 58);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (18, 132, 'new', 8);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (17, 129, 'longtime', 50);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (12, 128, 'new', 16);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (18, 111, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (19, 130, 'longtime', 37);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (17, 131, 'longtime', 98);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (24, 107, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (23, 108, 'longtime', 69);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (16, 115, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (16, 126, 'longtime', 64);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (11, 128, 'longtime', 64);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (14, 121, 'new', 4);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (22, 120, 'new', 9);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (22, 122, 'longtime', 88);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (22, 118, 'new', 2);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (16, 108, 'longtime', 46);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (25, 118, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (15, 105, 'new', 14);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (22, 106, 'new', 8);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (25, 111, 'new', 1);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (20, 103, 'longtime', 41);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (21, 126, 'longtime', 87);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (25, 128, 'longtime', 51);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (12, 123, 'new', 1);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (13, 124, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (13, 106, 'longtime', 98);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (21, 109, 'new', 8);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (15, 131, 'longtime', 23);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (14, 122, 'longtime', 97);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (13, 105, 'longtime', 32);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (12, 102, 'longtime', 97);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (22, 105, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (25, 114, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (14, 126, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (13, 128, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (18, 126, 'longtime', 48);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (15, 120, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (12, 131, 'new', 7);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (22, 121, 'longtime', 24);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (24, 127, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (26, 110, 'longtime', 88);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (23, 121, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (19, 112, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (17, 125, 'new', 15);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (13, 114, 'new', 19);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (17, 109, 'new', 17);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (11, 105, 'new', 20);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (15, 128, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (24, 109, 'longtime', 73);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (14, 126, 'longtime', 88);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (25, 113, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (16, 118, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (22, 117, 'longtime', 57);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (26, 130, 'longtime', 62);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (22, 101, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (21, 124, 'longtime', 65);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (20, 112, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (26, 124, 'new', 2);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (13, 117, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (20, 126, 'new', 8);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (12, 112, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (12, 119, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (25, 120, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (14, 131, 'longtime', 82);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (23, 121, 'longtime', 60);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (26, 113, 'new', 7);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (18, 108, 'new', 15);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (11, 122, 'longtime', 25);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (20, 130, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (23, 123, 'longtime', 76);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (16, 131, 'new', 20);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (15, 128, 'new', 10);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (14, 123, 'longtime', 60);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (12, 106, 'new', 12);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (18, 132, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (16, 112, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (14, 105, 'longtime', 43);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (15, 126, 'longtime', 68);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (22, 102, 'new', 16);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (19, 115, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (16, 108, 'longtime', 20);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (25, 122, 'longtime', 92);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (21, 108, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (16, 129, 'new', 4);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (22, 115, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (21, 113, 'longtime', 96);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (14, 104, 'new', 15);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (24, 122, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (12, 121, 'new', 9);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (23, 126, 'new', 9);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (19, 106, 'new', 6);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (11, 120, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (24, 121, 'new', 13);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (16, 107, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (13, 118, 'longtime', 98);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (12, 132, 'longtime', 71);


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


