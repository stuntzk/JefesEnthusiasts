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
    StoreId       INT(1)        ,
    OrderDate     DATE           ,
    TotalPrice    DECIMAL(19, 2),
    TimeOrdered   TIME          ,
    TimeCompleted TIME           ,
    TimeToMake    TIME           ,
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
    ShiftHours  TIME,
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
    NeededQuantity int            NOT NULL,
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
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (100, 'Paulo', 'Dupoy', 936364885, 'Store Manager', '1975-05-09', '2018-08-21', 10, 'pdupoy0@ibm.com', 6164352439, '59 Eagle Crest Place', 'Detroit', 'MI', '48206', 100);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (101, 'Corie', 'Buddle', 384528346, 'Support', '1985-05-06', '2021-03-02', 26, 'cbuddle1@globo.com', 9379887580, '568 Fairview Drive', 'Austin', 'TX', '78778', 100);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (102, 'Cherilynn', 'Kleeborn', 317900059, 'Cook', '1973-03-10', '2014-11-19', 13, 'ckleeborn2@blog.com', 8958361215, '01 Ryan Drive', 'Topeka', 'KS', '66667', 100);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (103, 'Wye', 'Gallahar', 292089875, 'Store Manager', '1982-04-17', '2015-04-16', 40, 'wgallahar3@people.com.cn', 1426591496, '3348 Clove Park', 'Chattanooga', 'TN', '37410', 103);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (104, 'Vladimir', 'Dohmer', 525867246, 'Cashier', '1976-03-03', '2016-05-22', 14, 'vdohmer4@nbcnews.com', 9607472369, '0446 Sauthoff Crossing', 'Alexandria', 'LA', '71307', 100);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (105, 'Theo', 'Harrill', 181214221, 'Cook', '1989-05-10', '2022-02-18', 10, 'tharrill5@shop-pro.jp', 2717955175, '38785 Buena Vista Court', 'Oklahoma City', 'OK', '73173', 100);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (106, 'Lin', 'Mereweather', 448200351, 'Store Manager', '1993-12-02', '2015-02-07', 40, 'lmereweather6@people.com.cn', 6904715928, '71819 Russell Drive', 'Maple Plain', 'MN', '55572', 106);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (107, 'Herb', 'Loncaster', 500811271, 'Support', '2002-05-08', '2017-04-24', 12, 'hloncaster7@mysql.com', 1692656576, '10499 Fairview Pass', 'Portland', 'OR', '97216', 100);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (108, 'Jewelle', 'Cochet', 981660055, 'Support', '1965-11-18', '2017-08-06', 18, 'jcochet8@ycombinator.com', 7231413231, '8 Heath Plaza', 'Dallas', 'TX', '75379', 100);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (109, 'Lilias', 'Schroder', 858613046, 'Cashier', '1986-11-08', '2013-02-10', 22, 'lschroder9@answers.com', 4808016443, '26 Green Ridge Street', 'Knoxville', 'TN', '37924', 103);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (110, 'Gerhardt', 'McQueen', 268951717, 'Store Manager', '1991-02-18', '2012-09-08', 40, 'gmcqueena@princeton.edu', 3254875760, '03 Forest Run Lane', 'San Antonio', 'TX', '78235', 110);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (111, 'Maxi', 'Overill', 321635376, 'Store Manager', '1993-01-03', '2022-04-12', 40, 'moverillb@aboutads.info', 3527420306, '161 Hanson Junction', 'Knoxville', 'TN', '37914', 111);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (112, 'Kristine', 'Nowaczyk', 900273561, 'Cashier', '1970-07-29', '2013-11-15', 30, 'knowaczykc@microsoft.com', 8757223104, '29 North Terrace', 'Kansas City', 'MO', '64190', 103);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (113, 'Lock', 'Swiers', 774610797, 'Cook', '1968-10-23', '2010-10-05', 22, 'lswiersd@fc2.com', 1348618597, '3051 Anthes Plaza', 'Chula Vista', 'CA', '91913', 103);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (114, 'Rubina', 'Grammer', 866829242, 'Support', '1981-01-18', '2018-12-30', 18, 'rgrammere@drupal.org', 8889258926, '475 Westport Drive', 'Colorado Springs', 'CO', '80945', 103);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (115, 'Domingo', 'Boij', 690703778, 'Cashier', '1980-09-26', '2021-01-18', 11, 'dboijf@rambler.ru', 1249363765, '18438 Charing Cross Junction', 'Manchester', 'NH', '03105', 103);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (116, 'Anders', 'McGarrity', 260197937, 'Store Manager', '1989-06-28', '2016-03-23', 40, 'amcgarrityg@rambler.ru', 5214658786, '30 3rd Plaza', 'Lubbock', 'TX', '79410', 116);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (117, 'Odelle', 'Leftley', 268989292, 'Support', '1976-08-05', '2012-03-25', 20, 'oleftleyh@paypal.com', 2704232444, '63140 Everett Trail', 'Fort Lauderdale', 'FL', '33320', 103);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (118, 'Hussein', 'Rapps', 472992585, 'Cook', '1967-12-30', '2010-07-20', 24, 'hrappsi@fastcompany.com', 5260379383, '66 Pepper Wood Trail', 'Missoula', 'MT', '59806', 116);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (119, 'Carola', 'Dowding', 804066351, 'Cashier', '1988-05-08', '2022-09-07', 24, 'cdowdingj@canalblog.com', 3360391577, '5628 Kinsman Circle', 'Baltimore', 'MD', '21211', 116);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (120, 'Fabien', 'Stores', 546515865, 'Store Manager', '1979-11-26', '2022-02-20', 40, 'fstoresk@yellowbook.com', 1609898430, '3 Schiller Hill', 'Washington', 'DC', '20503', 120);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (121, 'Richard', 'Mulhall', 293160784, 'Store Manager', '1971-03-31', '2019-03-07', 40, 'rmulhalll@cdbaby.com', 5239687587, '5067 Namekagon Park', 'Athens', 'GA', '30605', 121);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (122, 'Britte', 'Mallock', 710542571, 'Support', '1995-05-23', '2022-09-13', 27, 'bmallockm@opensource.org', 2513909842, '3 Logan Crossing', 'Dallas', 'TX', '75251', 120);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (123, 'Stan', 'Travis', 788000383, 'Cook', '1980-04-03', '2017-08-21', 16, 'stravisn@squidoo.com', 4268532665, '0257 Lotheville Road', 'Salem', 'OR', '97306', 116);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (124, 'Bevvy', 'Roderighi', 766769687, 'Cook', '1984-01-07', '2020-05-27', 26, 'broderighio@dell.com', 4909883530, '2 Johnson Trail', 'Kansas City', 'MO', '64160', 116);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (125, 'Ezmeralda', 'Vero', 504035953, 'Cook', '1981-10-18', '2015-08-24', 10, 'everop@lycos.com', 3033464587, '19467 Hintze Circle', 'Providence', 'RI', '02912', 116);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (126, 'Hershel', 'Anelay', 689657562, 'Cashier', '2006-02-20', '2012-07-20', 25, 'hanelayq@loc.gov', 3933535404, '009 Scofield Way', 'Las Vegas', 'NV', '89140', 116);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (127, 'Will', 'De Blasiis', 793918923, 'Store Manager', '1980-05-25', '2017-07-12', 40, 'wdeblasiisr@paginegialle.it', 4868455624, '84 Hayes Point', 'Mobile', 'AL', '36670', 127);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (128, 'Ruttger', 'Twittey', 869176017, 'Cook', '1982-12-16', '2018-01-21', 11, 'rtwitteys@theguardian.com', 4005713879, '7 Holy Cross Crossing', 'Odessa', 'TX', '79769', 121);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (129, 'Desdemona', 'Fritche', 111327605, 'Support', '2004-09-16', '2020-02-22', 19, 'dfritchet@networkadvertising.org', 4221029769, '6063 Glacier Hill Circle', 'Omaha', 'NE', '68144', 121);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (130, 'Barnard', 'Busst', 728383209, 'Cook', '1984-08-09', '2012-04-28', 24, 'bbusstu@creativecommons.org', 9630101130, '4255 Lakewood Gardens Pass', 'Fresno', 'CA', '93786', 121);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (131, 'Joell', 'Jackways', 498743335, 'Cashier', '1985-01-09', '2015-09-06', 24, 'jjackwaysv@e-recht24.de', 8725147704, '50 Lotheville Lane', 'White Plains', 'NY', '10633', 121);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (132, 'Isa', 'Orable', 726515115, 'Store Manager', '1980-01-12', '2019-10-24', 40, 'iorablew@dyndns.org', 9824443380, '5 Mayfield Hill', 'Kansas City', 'KS', '66105', 132);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (133, 'Elicia', 'Frankowski', 550246370, 'Cook', '1979-12-16', '2018-10-29', 12, 'efrankowskix@prweb.com', 3782655345, '34982 Kinsman Avenue', 'Virginia Beach', 'VA', '23459', 132);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (134, 'Fritz', 'Mannie', 755289959, 'Cook', '1975-09-17', '2013-07-13', 25, 'fmanniey@hatena.ne.jp', 9075185555, '939 Sommers Point', 'San Bernardino', 'CA', '92405', 132);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (135, 'Mead', 'Rowlett', 466510881, 'Store Manager', '1993-09-07', '2017-02-06', 40, 'mrowlettz@abc.net.au', 4844672687, '25 Merrick Road', 'Kansas City', 'MO', '64190', 135);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (136, 'Broderick', 'Chatten', 326816749, 'Support', '1997-04-02', '2022-07-25', 27, 'bchatten10@phoca.cz', 4546195114, '9287 Paget Lane', 'North Little Rock', 'AR', '72199', 132);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (137, 'Hanson', 'McKeighan', 771097691, 'Cashier', '1994-07-07', '2013-07-13', 28, 'hmckeighan11@ezinearticles.com', 2536138763, '20633 Huxley Avenue', 'Washington', 'DC', '20310', 132);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (138, 'Esther', 'Mumford', 553885728, 'Store Manager', '2000-10-04', '2019-06-16', 40, 'emumford12@clickbank.net', 1882507184, '17100 Weeping Birch Trail', 'South Bend', 'IN', '46614', 138);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (139, 'Mahmud', 'McGrah', 328847364, 'Cook', '1994-01-27', '2013-06-07', 11, 'mmcgrah13@cnet.com', 3272638629, '32385 Texas Street', 'Beaumont', 'TX', '77713', 138);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (140, 'Aurelea', 'Ilyinykh', 427928041, 'Cook', '1976-06-18', '2013-01-05', 21, 'ailyinykh14@jiathis.com', 1240072310, '37832 Milwaukee Point', 'El Paso', 'TX', '79923', 138);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (141, 'Genia', 'Gratrex', 196275577, 'Support', '2002-04-01', '2015-03-10', 17, 'ggratrex15@washingtonpost.com', 4891166351, '104 Fairfield Avenue', 'Washington', 'DC', '20370', 138);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (142, 'Haslett', 'Ripon', 136330626, 'Store Manager', '1987-04-24', '2022-01-22', 40, 'hripon16@comcast.net', 2024919582, '4 Forest Dale Circle', 'New Brunswick', 'NJ', '08922', 142);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (143, 'Lamond', 'Athy', 245246840, 'Support', '1999-08-08', '2022-04-25', 29, 'lathy17@va.gov', 9392323359, '7 Debra Court', 'Jacksonville', 'FL', '32277', 138);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (144, 'Fan', 'Beves', 460053815, 'Store Manager', '1996-04-10', '2012-06-08', 40, 'fbeves18@redcross.org', 2513087207, '317 Hintze Parkway', 'Kansas City', 'MO', '64114', 144);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (145, 'Denis', 'Charman', 447928229, 'Cashier', '1967-10-31', '2017-08-16', 19, 'dcharman19@free.fr', 7856580451, '5052 Main Court', 'Fort Lauderdale', 'FL', '33355', 138);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (146, 'Andros', 'Mateos', 816263093, 'Support', '1967-09-10', '2010-05-22', 23, 'amateos1a@i2i.jp', 7763033902, '69250 Continental Park', 'Topeka', 'KS', '66642', 138);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (147, 'Jammal', 'Scanderet', 570091223, 'Cook', '1988-03-19', '2011-03-03', 14, 'jscanderet1b@about.com', 4231908795, '8912 Clove Pass', 'Fort Wayne', 'IN', '46814', 144);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (148, 'Ted', 'Weich', 457795495, 'Cook', '2003-02-26', '2013-08-26', 23, 'tweich1c@behance.net', 5424323162, '8 Sage Lane', 'Oklahoma City', 'OK', '73173', 144);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (149, 'Nichols', 'Evason', 943417973, 'Support', '1997-01-16', '2013-09-23', 10, 'nevason1d@deviantart.com', 8472633317, '1542 Clarendon Plaza', 'Detroit', 'MI', '48224', 144);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (150, 'Cyrus', 'Pellissier', 360780621, 'Store Manager', '1998-03-06', '2015-09-27', 40, 'cpellissier0@blogspot.com', 8708478012, '02 Londonderry Drive', 'El Paso', 'TX', '88579', 150);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (151, 'Tami', 'Denslow', 211910023, 'Store Manager', '2005-12-29', '2019-11-09', 40, 'tdenslow1@oracle.com', 8070726572, '440 Rowland Place', 'Dallas', 'TX', '75246', 151);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (152, 'Theobald', 'Rackam', 193874224, 'Store Manager', '1977-02-08', '2012-03-01', 40, 'trackam2@illinois.edu', 5611616388, '12542 Toban Circle', 'San Diego', 'CA', '92165', 152);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (153, 'Hermon', 'Pearne', 134972272, 'Store Manager', '2006-01-09', '2011-12-05', 40, 'hpearne3@independent.co.uk', 6709322246, '49 Charing Cross Drive', 'Burbank', 'CA', '91505', 153);
insert into Employee (EmpId, FirstName, LastName, SSN, Title, BDay, StartDate, Wage, Email, Phone, EmpStreet, EmpCity, EmpState, EmpZip, ManagerId) values (154, 'Clemmie', 'Courtin', 477207504, 'Store Manager', '2000-09-06', '2022-05-23', 40, 'ccourtin4@nih.gov', 2052128541, '54 Banding Pass', 'Fairfield', 'CT', '06825', 154);

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
        110000.00, 500.00, 150, 11),
       (2, 'Harvard Square', '14 Brattle Street', 'Cambridge', 'MA', 02138, '08:00:00', '04:00:00', 222222.22, 2222.22,
        220000.00, 600.00, 151, 11),
       (3, 'New Brunswick', '97 Hamilton Street', 'New Brunswick', 'NJ', 08901, '08:00:00', '04:00:00', 111111.11,
        1111.11, 110000.00, 600.00, 152, 11),
       (4, 'State College', '352 E. Calder Way ', 'State College', 'PA', 16801, '08:00:00', '04:00:00', 222222.22,
        2222.22, 220000.00, 700.00, 153, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (5, 'Clarendon', '48843 Oakridge Crossing', 'Hartford', 'CT', '06160', '11:05:22', '4:31:02', 383568244.73, 80160.12, 140879249.59, 76950.84, 100, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (6, 'Lillian', '355 Muir Hill', 'Midland', 'TX', '79705', '8:38:53', '5:55:02', 868378672.0, 63260.08, 191675067.03, 56664.93, 103, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (7, 'Colorado', '7259 Lunder Crossing', 'Birmingham', 'AL', '35225', '11:13:23', '5:38:37', 147577851.53, 98782.54, 608827150.35, 48389.63, 106, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (8, 'Stang', '50303 Morrow Place', 'Raleigh', 'NC', '27635', '7:22:08', '3:07:52', 403806492.38, 17865.52, 135514810.47, 4699.97, 110, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (9, 'Carey', '362 Fisk Crossing', 'Staten Island', 'NY', '10310', '8:22:57', '3:11:57', 341719627.7, 89349.47, 137457260.59, 57435.72, 111, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (10, 'Claremont', '65054 Hayes Road', 'Brooklyn', 'NY', '11231', '6:44:27', '5:52:17', 411690806.24, 91348.8, 436274685.72, 64302.96, 116, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (11, 'Crest Line', '89 Dorton Park', 'Lansing', 'MI', '48912', '8:16:11', '3:43:00', 473382655.41, 59344.13, 672909179.77, 40751.24, 120, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (12, 'Anhalt', '6 Tennyson Hill', 'Irving', 'TX', '75062', '8:13:38', '5:31:55', 921774628.91, 78265.27, 102699993.29, 62293.97, 121, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (13, 'Delladonna', '56 Glendale Crossing', 'Kansas City', 'MO', '64109', '9:19:48', '3:37:49', 185459229.61, 36161.05, 447633328.26, 81726.61, 127, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (14, 'Maywood', '808 Ruskin Road', 'Boca Raton', 'FL', '33432', '7:03:50', '3:05:01', 682581387.94, 21879.47, 397613007.55, 25266.36, 132, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (15, 'Boyd', '116 Dahle Plaza', 'Seattle', 'WA', '98121', '11:02:22', '3:20:51', 511452968.63, 29518.35, 923291044.79, 68346.92, 135, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (16, 'Meadow Valley', '4 Mandrake Place', 'Tacoma', 'WA', '98411', '8:13:14', '3:03:44', 62811844.18, 70954.63, 586867065.41, 80369.22, 138, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (17, 'Eliot', '20 Forest Dale Court', 'Houston', 'TX', '77070', '9:26:57', '5:53:49', 67641837.05, 68864.4, 834130877.81, 59865.03, 142, 11);
insert into Store (StoreId, StoreName, StoreStreet, StoreCity, StoreState, StoreZip, StoreHourOpen, StoreHourClose, Profit, Cost, Revenue, MonthlyUpkeep, ManagerId, FranchiseId) values (18, 'Village', '1806 Stone Corner Court', 'Jacksonville', 'FL', '32215', '9:51:38', '2:13:02', 33113704.52, 48935.49, 763832107.35, 84470.79, 144, 11);

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
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (26, 113, 'new', 7);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (18, 108, 'new', 15);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (11, 122, 'longtime', 25);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (20, 130, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (23, 123, 'longtime', 76);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (16, 131, 'new', 20);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (14, 123, 'longtime', 60);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (12, 106, 'new', 12);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (16, 112, 'potential', 0);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (14, 105, 'longtime', 43);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (15, 126, 'longtime', 68);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (22, 102, 'new', 16);
insert into Investments (FranchiseId, InvId, InvStatus, Stake) values (19, 115, 'potential', 0);
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


insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (129, '2022-05-31', '22:28:56', '02:26:32', '03:57:36', 9);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (153, '2022-09-02', '16:58:26', '19:18:50', '02:20:24', 6);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (133, '2022-07-16', '23:32:49', '01:46:01', '02:13:12', 12);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (127, '2022-10-17', '11:12:47', '17:04:23', '05:51:36', 5);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (151, '2022-02-26', '10:37:09', '11:49:09', '01:12:00', 13);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (134, '2022-04-04', '11:12:21', '18:58:33', '07:46:12', 4);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (113, '2022-06-25', '01:36:16', '02:53:40', '01:17:24', 9);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (146, '2022-06-21', '12:39:47', '15:50:35', '03:10:48', 9);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (108, '2022-09-12', '19:47:59', '20:56:59', '01:09:00', 7);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (106, '2022-06-07', '06:39:03', '10:57:03', '04:18:00', 7);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (126, '2022-01-25', '04:56:38', '07:21:14', '02:24:36', 9);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (101, '2022-06-25', '15:57:56', '19:00:56', '03:03:00', 18);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (143, '2022-01-15', '20:21:19', '04:16:31', '07:55:12', 8);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (131, '2022-10-09', '21:42:22', '00:30:58', '02:48:36', 11);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (123, '2022-10-15', '11:13:12', '14:18:00', '03:04:48', 14);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (143, '2022-03-11', '22:47:03', '02:46:27', '03:59:24', 2);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (141, '2022-05-15', '04:52:03', '09:46:39', '04:54:36', 18);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (154, '2022-09-18', '01:02:00', '05:47:00', '04:45:00', 5);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (101, '2022-09-12', '10:06:52', '17:41:04', '07:34:12', 5);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (153, '2022-09-03', '04:23:47', '09:45:23', '05:21:36', 18);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (105, '2022-01-16', '14:25:26', '20:23:38', '05:58:12', 13);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (131, '2022-04-12', '02:42:04', '09:21:40', '06:39:36', 5);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (136, '2022-04-20', '23:02:38', '03:02:02', '03:59:24', 13);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (106, '2022-06-07', '10:38:11', '18:13:35', '07:35:24', 6);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (139, '2022-08-30', '10:48:14', '16:23:38', '05:35:24', 5);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (151, '2022-07-23', '16:20:14', '18:55:38', '02:35:24', 7);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (129, '2022-07-01', '03:38:35', '08:17:35', '04:39:00', 13);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (146, '2022-04-16', '12:59:07', '20:56:07', '07:57:00', 6);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (150, '2022-07-30', '09:41:24', '12:58:12', '03:16:48', 13);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (151, '2022-07-14', '03:14:08', '10:09:20', '06:55:12', 2);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (131, '2022-01-03', '19:27:56', '22:23:44', '02:55:48', 5);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (112, '2022-05-09', '20:38:19', '23:31:07', '02:52:48', 10);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (122, '2022-10-26', '04:11:45', '10:27:21', '06:15:36', 17);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (100, '2022-01-28', '03:11:23', '08:11:59', '05:00:36', 3);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (144, '2022-05-15', '08:22:02', '13:14:50', '04:52:48', 1);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (121, '2022-06-07', '09:44:22', '13:22:46', '03:38:24', 15);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (121, '2022-04-18', '09:35:12', '11:49:36', '02:14:24', 4);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (127, '2022-10-26', '16:12:26', '18:46:38', '02:34:12', 9);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (130, '2022-09-15', '06:35:46', '09:08:46', '02:33:00', 5);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (130, '2022-01-07', '13:03:54', '18:17:06', '05:13:12', 3);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (118, '2022-10-27', '16:12:23', '19:04:35', '02:52:12', 18);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (104, '2022-02-19', '23:47:06', '02:00:54', '02:13:48', 3);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (151, '2022-06-01', '15:39:57', '17:45:57', '02:06:00', 6);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (118, '2022-02-07', '13:39:59', '17:10:35', '03:30:36', 4);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (131, '2022-08-21', '22:30:46', '05:52:22', '07:21:36', 6);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (102, '2022-11-06', '01:47:38', '08:17:02', '06:29:24', 7);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (106, '2022-07-18', '03:30:53', '05:45:17', '02:14:24', 10);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (132, '2022-11-28', '13:22:15', '14:27:39', '01:05:24', 10);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (140, '2022-10-18', '17:37:56', '21:30:44', '03:52:48', 1);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (109, '2022-04-20', '19:24:14', '23:11:38', '03:47:24', 8);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (139, '2022-02-24', '19:32:10', '02:59:46', '07:27:36', 10);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (102, '2022-03-01', '02:10:03', '03:13:39', '01:03:36', 2);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (151, '2022-08-10', '00:17:34', '07:22:22', '07:04:48', 8);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (110, '2022-06-19', '04:36:20', '12:23:08', '07:46:48', 17);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (136, '2022-04-23', '06:20:09', '10:11:09', '03:51:00', 13);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (110, '2022-04-10', '02:42:11', '09:10:23', '06:28:12', 15);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (105, '2022-03-27', '07:06:22', '13:33:22', '06:27:00', 12);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (141, '2022-02-06', '18:18:14', '21:46:26', '03:28:12', 3);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (152, '2022-11-22', '06:37:35', '13:17:47', '06:40:12', 3);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (150, '2022-03-06', '19:16:57', '23:15:45', '03:58:48', 17);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (143, '2022-10-31', '16:12:36', '00:08:24', '07:55:48', 10);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (135, '2022-02-27', '20:16:33', '21:23:45', '01:07:12', 17);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (137, '2022-10-18', '02:42:25', '05:10:01', '02:27:36', 7);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (102, '2022-11-17', '13:10:47', '20:39:35', '07:28:48', 6);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (128, '2022-01-01', '19:18:18', '02:32:06', '07:13:48', 16);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (110, '2022-06-04', '08:07:09', '10:34:45', '02:27:36', 11);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (125, '2022-09-03', '04:44:01', '11:06:49', '06:22:48', 6);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (142, '2022-07-10', '15:17:07', '21:38:43', '06:21:36', 8);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (114, '2022-02-13', '01:06:56', '03:39:56', '02:33:00', 2);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (125, '2022-09-27', '15:15:42', '22:04:54', '06:49:12', 2);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (139, '2022-02-14', '04:05:13', '09:10:37', '05:05:24', 12);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (148, '2022-03-15', '01:04:23', '05:00:47', '03:56:24', 1);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (122, '2022-07-09', '05:56:28', '12:57:40', '07:01:12', 10);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (139, '2022-06-19', '14:09:21', '15:41:09', '01:31:48', 8);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (141, '2022-05-02', '01:18:19', '07:01:31', '05:43:12', 10);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (105, '2022-08-24', '00:22:27', '05:36:15', '05:13:48', 3);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (116, '2022-06-27', '18:15:30', '23:53:18', '05:37:48', 10);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (135, '2022-01-01', '20:41:01', '00:10:25', '03:29:24', 7);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (104, '2022-03-11', '11:42:13', '19:17:01', '07:34:48', 10);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (144, '2022-06-20', '19:55:03', '21:26:15', '01:31:12', 12);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (125, '2022-01-06', '22:27:37', '05:05:25', '06:37:48', 15);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (135, '2022-11-01', '10:17:33', '13:27:45', '03:10:12', 11);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (135, '2022-02-12', '15:22:51', '19:54:39', '04:31:48', 10);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (133, '2022-04-19', '05:51:20', '06:57:20', '01:06:00', 5);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (154, '2022-03-11', '11:27:55', '15:25:31', '03:57:36', 6);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (150, '2022-06-10', '02:11:46', '08:53:10', '06:41:24', 3);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (112, '2022-11-27', '10:10:33', '12:33:21', '02:22:48', 16);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (128, '2022-08-29', '01:21:12', '07:36:48', '06:15:36', 6);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (151, '2022-10-14', '12:34:27', '20:30:51', '07:56:24', 5);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (145, '2022-08-16', '02:31:55', '08:49:19', '06:17:24', 2);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (111, '2022-04-11', '14:37:32', '21:59:08', '07:21:36', 4);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (113, '2022-03-10', '05:10:52', '10:03:04', '04:52:12', 2);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (139, '2022-01-09', '09:02:41', '13:56:41', '04:54:00', 9);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (104, '2022-05-10', '15:57:53', '22:31:29', '06:33:36', 12);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (104, '2022-01-22', '19:17:43', '01:08:07', '05:50:24', 8);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (102, '2022-05-26', '07:25:19', '13:33:07', '06:07:48', 9);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (148, '2022-08-07', '02:58:49', '05:42:01', '02:43:12', 12);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (147, '2022-08-06', '04:00:32', '09:35:20', '05:34:48', 16);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (111, '2022-06-26', '06:36:43', '13:34:19', '06:57:36', 18);
insert into Shift (EmpId, ShiftDate, ShiftStart, ShiftEnd, ShiftHours, StoreWorked) values (116, '2022-08-05', '02:26:37', '05:26:37', '03:00:00', 2);

INSERT INTO FoodType
    (TypeId, TypeName, BasePrice)
VALUES (111, 'Burrito', 10.25),
       (112, 'Bowl', 10.50),
       (113, 'Quesadilla', 6.00),
       (114, 'Taco', 3.95),
       (115, 'Nachos', 9.25),
       (116, 'Chips', 2.75),
       (117, 'Soup', 6.50),
       (118, 'Chili', 6.50),
       (119, 'Taco Salad', 9.00),
       (120, 'Salad Bowl', 9.75),
       (121, 'Churro', 3.00);

insert into Product (ProductId, Price, OrderId, TypeId) values (1000, 7.36, 12386, 118);
insert into Product (ProductId, Price, OrderId, TypeId) values (1001, 15.25, 12419, 117);
insert into Product (ProductId, Price, OrderId, TypeId) values (1002, 10.81, 12362, 113);
insert into Product (ProductId, Price, OrderId, TypeId) values (1003, 7.44, 12432, 112);
insert into Product (ProductId, Price, OrderId, TypeId) values (1004, 13.51, 12400, 121);
insert into Product (ProductId, Price, OrderId, TypeId) values (1005, 7.69, 12356, 119);
insert into Product (ProductId, Price, OrderId, TypeId) values (1006, 7.51, 12441, 118);
insert into Product (ProductId, Price, OrderId, TypeId) values (1007, 8.25, 12378, 117);
insert into Product (ProductId, Price, OrderId, TypeId) values (1008, 14.99, 12377, 114);
insert into Product (ProductId, Price, OrderId, TypeId) values (1009, 14.21, 12439, 113);
insert into Product (ProductId, Price, OrderId, TypeId) values (1010, 10.48, 12362, 117);
insert into Product (ProductId, Price, OrderId, TypeId) values (1011, 11.19, 12403, 120);
insert into Product (ProductId, Price, OrderId, TypeId) values (1012, 9.57, 12372, 121);
insert into Product (ProductId, Price, OrderId, TypeId) values (1013, 15.53, 12391, 111);
insert into Product (ProductId, Price, OrderId, TypeId) values (1014, 14.32, 12412, 119);
insert into Product (ProductId, Price, OrderId, TypeId) values (1015, 8.24, 12410, 121);
insert into Product (ProductId, Price, OrderId, TypeId) values (1016, 8.05, 12449, 119);
insert into Product (ProductId, Price, OrderId, TypeId) values (1017, 12.86, 12358, 112);
insert into Product (ProductId, Price, OrderId, TypeId) values (1018, 14.26, 12411, 112);
insert into Product (ProductId, Price, OrderId, TypeId) values (1019, 10.66, 12439, 117);
insert into Product (ProductId, Price, OrderId, TypeId) values (1020, 15.72, 12422, 112);
insert into Product (ProductId, Price, OrderId, TypeId) values (1021, 13.16, 12420, 114);
insert into Product (ProductId, Price, OrderId, TypeId) values (1022, 12.77, 12408, 116);
insert into Product (ProductId, Price, OrderId, TypeId) values (1023, 15.47, 12392, 117);
insert into Product (ProductId, Price, OrderId, TypeId) values (1024, 13.78, 12408, 118);
insert into Product (ProductId, Price, OrderId, TypeId) values (1025, 15.87, 12375, 114);
insert into Product (ProductId, Price, OrderId, TypeId) values (1026, 11.65, 12434, 118);
insert into Product (ProductId, Price, OrderId, TypeId) values (1027, 7.33, 12368, 117);
insert into Product (ProductId, Price, OrderId, TypeId) values (1028, 13.15, 12355, 118);
insert into Product (ProductId, Price, OrderId, TypeId) values (1029, 12.9, 12370, 116);
insert into Product (ProductId, Price, OrderId, TypeId) values (1030, 9.66, 12397, 116);
insert into Product (ProductId, Price, OrderId, TypeId) values (1031, 13.26, 12397, 116);
insert into Product (ProductId, Price, OrderId, TypeId) values (1032, 12.65, 12439, 116);
insert into Product (ProductId, Price, OrderId, TypeId) values (1033, 9.38, 12366, 115);
insert into Product (ProductId, Price, OrderId, TypeId) values (1034, 11.11, 12442, 115);
insert into Product (ProductId, Price, OrderId, TypeId) values (1035, 14.09, 12420, 112);
insert into Product (ProductId, Price, OrderId, TypeId) values (1036, 11.82, 12377, 114);
insert into Product (ProductId, Price, OrderId, TypeId) values (1037, 10.1, 12379, 115);
insert into Product (ProductId, Price, OrderId, TypeId) values (1038, 14.38, 12396, 121);
insert into Product (ProductId, Price, OrderId, TypeId) values (1039, 14.32, 12371, 121);
insert into Product (ProductId, Price, OrderId, TypeId) values (1040, 11.5, 12411, 115);
insert into Product (ProductId, Price, OrderId, TypeId) values (1041, 15.61, 12356, 114);
insert into Product (ProductId, Price, OrderId, TypeId) values (1042, 15.55, 12375, 119);
insert into Product (ProductId, Price, OrderId, TypeId) values (1043, 7.22, 12446, 118);
insert into Product (ProductId, Price, OrderId, TypeId) values (1044, 7.05, 12407, 119);
insert into Product (ProductId, Price, OrderId, TypeId) values (1045, 14.91, 12437, 117);
insert into Product (ProductId, Price, OrderId, TypeId) values (1046, 12.86, 12444, 112);
insert into Product (ProductId, Price, OrderId, TypeId) values (1047, 12.96, 12353, 116);
insert into Product (ProductId, Price, OrderId, TypeId) values (1048, 12.84, 12358, 121);
insert into Product (ProductId, Price, OrderId, TypeId) values (1049, 12.78, 12355, 119);
insert into Product (ProductId, Price, OrderId, TypeId) values (1050, 10.74, 12356, 113);
insert into Product (ProductId, Price, OrderId, TypeId) values (1051, 7.56, 12433, 117);
insert into Product (ProductId, Price, OrderId, TypeId) values (1052, 7.42, 12361, 120);
insert into Product (ProductId, Price, OrderId, TypeId) values (1053, 14.61, 12395, 119);
insert into Product (ProductId, Price, OrderId, TypeId) values (1054, 11.58, 12450, 116);
insert into Product (ProductId, Price, OrderId, TypeId) values (1055, 13.57, 12396, 111);
insert into Product (ProductId, Price, OrderId, TypeId) values (1056, 7.73, 12373, 111);
insert into Product (ProductId, Price, OrderId, TypeId) values (1057, 13.95, 12374, 118);
insert into Product (ProductId, Price, OrderId, TypeId) values (1058, 9.1, 12365, 119);
insert into Product (ProductId, Price, OrderId, TypeId) values (1059, 14.77, 12433, 117);
insert into Product (ProductId, Price, OrderId, TypeId) values (1060, 12.99, 12369, 114);
insert into Product (ProductId, Price, OrderId, TypeId) values (1061, 8.33, 12415, 117);
insert into Product (ProductId, Price, OrderId, TypeId) values (1062, 8.55, 12440, 114);
insert into Product (ProductId, Price, OrderId, TypeId) values (1063, 8.92, 12417, 117);
insert into Product (ProductId, Price, OrderId, TypeId) values (1064, 12.81, 12390, 113);
insert into Product (ProductId, Price, OrderId, TypeId) values (1065, 9.95, 12436, 115);
insert into Product (ProductId, Price, OrderId, TypeId) values (1066, 14.03, 12398, 115);
insert into Product (ProductId, Price, OrderId, TypeId) values (1067, 7.65, 12400, 120);
insert into Product (ProductId, Price, OrderId, TypeId) values (1068, 10.18, 12378, 113);
insert into Product (ProductId, Price, OrderId, TypeId) values (1069, 13.95, 12366, 120);
insert into Product (ProductId, Price, OrderId, TypeId) values (1070, 9.38, 12435, 113);
insert into Product (ProductId, Price, OrderId, TypeId) values (1071, 13.22, 12414, 119);
insert into Product (ProductId, Price, OrderId, TypeId) values (1072, 12.16, 12399, 119);
insert into Product (ProductId, Price, OrderId, TypeId) values (1073, 7.47, 12387, 112);
insert into Product (ProductId, Price, OrderId, TypeId) values (1074, 14.34, 12376, 117);
insert into Product (ProductId, Price, OrderId, TypeId) values (1075, 10.43, 12363, 114);
insert into Product (ProductId, Price, OrderId, TypeId) values (1076, 13.6, 12369, 120);
insert into Product (ProductId, Price, OrderId, TypeId) values (1077, 15.64, 12416, 121);
insert into Product (ProductId, Price, OrderId, TypeId) values (1078, 8.45, 12353, 112);
insert into Product (ProductId, Price, OrderId, TypeId) values (1079, 11.75, 12359, 116);
insert into Product (ProductId, Price, OrderId, TypeId) values (1080, 8.92, 12413, 121);
insert into Product (ProductId, Price, OrderId, TypeId) values (1081, 15.8, 12381, 120);
insert into Product (ProductId, Price, OrderId, TypeId) values (1082, 15.39, 12441, 121);
insert into Product (ProductId, Price, OrderId, TypeId) values (1083, 12.8, 12370, 116);
insert into Product (ProductId, Price, OrderId, TypeId) values (1084, 13.57, 12383, 117);
insert into Product (ProductId, Price, OrderId, TypeId) values (1085, 11.74, 12430, 112);
insert into Product (ProductId, Price, OrderId, TypeId) values (1086, 12.7, 12441, 121);
insert into Product (ProductId, Price, OrderId, TypeId) values (1087, 9.9, 12430, 121);
insert into Product (ProductId, Price, OrderId, TypeId) values (1088, 7.15, 12357, 112);
insert into Product (ProductId, Price, OrderId, TypeId) values (1089, 11.13, 12372, 118);


insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1113, 'Black Beans', 35.49, 1.32, 'Hot', 22, 15, 15);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1114, 'Lettuce', 25.61, 0.68, 'Cold', 16, 23, 5);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1115, 'Chipotle Mayo', 41.94, 0.69, 'Cold', 12, 12, 1);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1116, 'Black Beans', 37.55, 2.0, 'Hot', 17, 14, 7);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1117, 'Mexican Rice', 51.78, 0.86, 'Hot', 3, 15, 7);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1118, 'Sour Cream', 44.25, 1.37, 'Cold', 11, 2, 7);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1119, 'Guacamole', 48.36, 1.05, 'Cold', 23, 14, 9);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1120, 'Grilled Steak', 30.53, 1.08, 'Protein', 13, 0, 15);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1121, 'Chipotle Mayo', 43.8, 0.39, 'Cold', 9, 19, 6);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1122, 'Pickled Onions', 52.26, 0.08, 'Cold', 11, 24, 4);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1123, 'Black Beans', 47.4, 0.84, 'Hot', 25, 13, 1);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1124, 'Cilantro Lime Rice', 45.47, 1.5, 'Hot', 11, 25, 8);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1125, 'Queso', 32.22, 1.51, 'Hot', 23, 21, 15);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1126, 'Pico de Gallo', 47.35, 0.55, 'Cold', 4, 13, 3);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1127, 'Cheese', 38.82, 1.11, 'Cold', 3, 22, 9);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1128, 'Spicy Ground Beef', 23.78, 0.4, 'Protein', 18, 7, 4);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1129, 'Cheese', 33.98, 0.23, 'Cold', 25, 8, 7);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1130, 'Green Salsa', 58.84, 1.62, 'Cold', 6, 24, 5);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1131, 'Braised Pork', 29.3, 0.33, 'Protein', 24, 5, 18);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1132, 'Spicy Ground Beef', 48.7, 0.5, 'Protein', 16, 3, 15);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1133, 'Queso', 32.9, 0.49, 'Hot', 20, 16, 11);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1134, 'Roasted Veggies', 46.27, 1.26, 'Protein', 8, 9, 15);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1135, 'Sour Cream', 23.2, 0.68, 'Cold', 10, 16, 16);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1136, 'Spicy Ground Beef', 44.75, 1.18, 'Protein', 16, 16, 10);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1137, 'Red Cabbage', 36.16, 1.8, 'Cold', 10, 12, 18);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1138, 'Roasted Veggies', 54.41, 1.61, 'Protein', 21, 18, 1);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1139, 'Pickled Onions', 26.78, 1.61, 'Cold', 3, 17, 11);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1140, 'Pinto Beans', 44.55, 0.31, 'Hot', 6, 17, 11);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1141, 'Pickled Onions', 37.6, 1.64, 'Cold', 23, 7, 16);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1142, 'Spicy Pork Sausage', 47.78, 0.45, 'Protein', 5, 23, 6);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1143, 'Refried Beans', 56.34, 0.95, 'Hot', 3, 18, 16);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1144, 'Mango Habanero Salsa', 33.88, 0.72, 'Cold', 21, 6, 9);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1145, 'Red Salsa', 43.13, 1.97, 'Cold', 25, 10, 12);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1146, 'Pinto Beans', 39.79, 0.4, 'Hot', 19, 22, 1);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1147, 'Black Beans', 46.01, 1.92, 'Hot', 11, 8, 14);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1148, 'Pickled Onions', 48.37, 1.48, 'Cold', 20, 4, 16);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1149, 'Cheese', 24.66, 1.95, 'Cold', 13, 7, 15);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1150, 'Cilantro', 29.74, 1.5, 'Cold', 10, 24, 4);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1151, 'Fajita Veggies', 44.74, 0.3, 'Protein', 10, 10, 17);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1152, 'Pickled Onions', 48.67, 0.47, 'Cold', 0, 17, 6);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1153, 'Green Salsa', 26.13, 1.04, 'Cold', 8, 23, 9);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1154, 'Roasted Vegetables', 53.82, 0.8, 'Protein', 3, 25, 15);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1155, 'Sour Cream', 38.48, 1.3, 'Cold', 10, 22, 16);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1156, 'Cilantro', 50.26, 0.66, 'Cold', 1, 23, 2);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1157, 'Refried Beans', 47.46, 1.53, 'Hot', 2, 24, 12);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1158, 'Spicy Ground Beef', 34.73, 1.32, 'Protein', 5, 3, 12);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1159, 'Sour Cream', 40.39, 1.92, 'Cold', 19, 2, 18);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1160, 'Black Beans', 47.6, 1.13, 'Hot', 1, 1, 1);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1161, 'Fried Tilapia', 20.7, 0.2, 'Protein', 14, 21, 8);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1162, 'Fajita Veggies', 37.6, 0.91, 'Protein', 8, 2, 12);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1163, 'Red Salsa', 49.77, 1.21, 'Cold', 12, 16, 1);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1164, 'Chipotle Mayo', 48.65, 1.38, 'Cold', 6, 13, 11);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1165, 'Grilled Steak', 45.67, 0.19, 'Protein', 20, 15, 15);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1166, 'Guacamole', 21.08, 1.95, 'Cold', 0, 2, 9);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1167, 'Grilled Steak', 41.87, 1.67, 'Protein', 7, 21, 10);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1168, 'Sauteed Shrimp', 36.18, 1.12, 'Protein', 19, 22, 12);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1169, 'Mexican Rice', 43.38, 1.91, 'Hot', 6, 24, 4);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1170, 'Cilantro Lime Rice', 30.99, 1.78, 'Hot', 7, 10, 9);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1171, 'Braised Pork', 23.44, 1.63, 'Protein', 2, 12, 9);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1172, 'Guacamole', 44.59, 1.29, 'Cold', 14, 17, 5);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1173, 'Roasted Vegetables', 38.92, 1.66, 'Protein', 1, 8, 3);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1174, 'Roasted Veggies', 50.36, 0.82, 'Protein', 21, 20, 18);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1175, 'Chipotle Mayo', 37.37, 0.63, 'Cold', 3, 12, 4);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1176, 'Guacamole', 54.83, 0.69, 'Cold', 15, 19, 9);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1177, 'Roasted Veggies', 39.86, 1.03, 'Protein', 20, 8, 9);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1178, 'Chipotle Mayo', 22.62, 1.69, 'Cold', 20, 15, 6);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1179, 'Spit-Grilled Pork', 54.95, 1.09, 'Protein', 1, 14, 18);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1180, 'Mexican Rice', 24.68, 0.72, 'Hot', 21, 12, 1);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1181, 'Red Cabbage', 20.32, 0.97, 'Cold', 4, 2, 9);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1182, 'Cheese', 53.14, 1.26, 'Cold', 14, 13, 9);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1183, 'Mexican Rice', 36.11, 1.4, 'Hot', 21, 13, 9);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1184, 'Braised Pork', 47.08, 0.0, 'Protein', 7, 6, 13);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1185, 'Pinto Beans', 22.04, 0.62, 'Hot', 9, 0, 16);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1186, 'Green Salsa', 41.7, 1.55, 'Cold', 6, 5, 6);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1187, 'Mango Habanero Salsa', 28.17, 0.96, 'Cold', 11, 23, 10);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1188, 'Mango Habanero Salsa', 41.02, 0.86, 'Cold', 21, 1, 8);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1189, 'Fajita Veggies', 32.27, 1.73, 'Protein', 4, 22, 5);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1190, 'Black Beans', 45.6, 0.56, 'Hot', 24, 18, 16);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1191, 'Spicy Ground Beef', 26.12, 1.7, 'Protein', 23, 14, 9);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1192, 'Grilled Steak', 48.16, 1.88, 'Protein', 19, 1, 18);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1193, 'Grilled Steak', 41.95, 0.27, 'Protein', 17, 10, 7);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1194, 'Grilled Steak', 22.52, 0.65, 'Protein', 10, 17, 11);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1195, 'Spit-Grilled Pork', 31.57, 1.35, 'Protein', 18, 2, 18);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1196, 'Guacamole', 50.49, 1.96, 'Cold', 0, 25, 11);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1197, 'Cilantro', 52.6, 1.2, 'Cold', 1, 21, 1);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1198, 'Cilantro', 29.59, 0.06, 'Cold', 9, 24, 17);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1199, 'Cilantro', 25.01, 1.17, 'Cold', 18, 12, 1);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1200, 'Lettuce', 41.73, 0.07, 'Cold', 18, 25, 15);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1201, 'Mexican Rice', 23.43, 1.28, 'Hot', 24, 18, 1);
insert into Ingredient (IngrId, IngrName, WholesalePrice, Upcharge, IngrCategory, CurrQuantity, NeededQuantity, StoreId) values (1202, 'Cilantro Lime Rice', 59.21, 0.76, 'Hot', 4, 14, 11);


insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1022, 1177, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1055, 1114, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1071, 1188, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1028, 1191, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1086, 1168, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1081, 1134, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1027, 1191, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1023, 1165, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1023, 1149, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1068, 1179, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1007, 1156, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1023, 1163, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1026, 1136, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1041, 1196, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1005, 1173, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1030, 1136, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1075, 1149, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1008, 1198, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1013, 1181, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1060, 1122, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1058, 1144, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1088, 1121, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1027, 1190, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1009, 1161, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1024, 1163, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1041, 1127, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1071, 1122, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1010, 1174, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1016, 1116, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1010, 1137, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1084, 1171, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1022, 1185, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1054, 1202, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1054, 1162, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1026, 1174, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1072, 1127, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1047, 1195, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1065, 1126, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1002, 1158, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1049, 1115, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1030, 1183, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1053, 1165, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1087, 1143, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1049, 1155, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1082, 1119, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1064, 1200, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1071, 1166, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1073, 1129, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1030, 1178, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1031, 1197, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1010, 1149, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1077, 1171, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1000, 1135, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1042, 1146, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1003, 1148, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1051, 1190, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1073, 1189, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1086, 1157, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1047, 1176, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1040, 1124, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1076, 1174, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1015, 1123, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1054, 1197, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1071, 1113, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1044, 1194, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1043, 1121, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1032, 1174, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1058, 1130, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1051, 1179, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1022, 1134, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1039, 1133, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1014, 1171, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1015, 1121, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1019, 1136, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1029, 1124, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1071, 1167, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1047, 1186, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1043, 1139, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1024, 1119, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1065, 1167, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1083, 1130, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1021, 1178, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1002, 1161, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1028, 1136, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1007, 1116, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1088, 1191, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1087, 1115, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1030, 1157, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1084, 1115, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1078, 1200, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1024, 1197, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1022, 1167, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1002, 1202, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1001, 1186, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1023, 1129, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1021, 1153, 2);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1080, 1142, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1046, 1160, 3);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1001, 1148, 1);
insert into ProductIngredient (ProductId, IngredientId, Quantity) values (1024, 1192, 3);

