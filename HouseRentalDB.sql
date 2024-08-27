CREATE DATABASE HOUSE_RENTAL_DATABASE;
USE HOUSE_RENTAL_DATABASE;

CREATE TABLE Region_cod (
    reg_cod VARCHAR(20) PRIMARY KEY,
    city VARCHAR(20),
    RH_state VARCHAR(20)
);


CREATE TABLE Rent_house (
    H_ID INT PRIMARY KEY,
    no_of_floors INT,
    no_of_rooms INT,
	regionCode varchar(20)  FOREIGN KEY references Region_cod(reg_cod)
);


CREATE TABLE House_Owner (
    own_ID INT PRIMARY KEY,
    own_Fname VARCHAR(20),
    own_Lname VARCHAR(20),
    own_email VARCHAR(20)
);

CREATE TABLE Tenant (
    T_ID INT PRIMARY KEY,
    T_Fname VARCHAR(20),
    T_Lname VARCHAR(20),
    H_ID INT,
    FOREIGN KEY (H_ID) REFERENCES Rent_house(H_ID)
);

CREATE TABLE House_contract (
    C_ID INT PRIMARY KEY,
    startDate INT,
    endDate INT,
    T_ID INT,
    own_ID INT,
    H_ID INT,
    FOREIGN KEY (T_ID) REFERENCES Tenant(T_ID),
    FOREIGN KEY (own_ID) REFERENCES House_Owner(own_ID),
    FOREIGN KEY (H_ID) REFERENCES Rent_house(H_ID)
);

CREATE TABLE Tenant_Tel (
    T_tel INT PRIMARY KEY,
    T_ID INT,
    FOREIGN KEY (T_ID) REFERENCES Tenant(T_ID)
);

CREATE TABLE Owner_tel (
    own_tel INT PRIMARY KEY,
    own_ID INT,
    FOREIGN KEY (own_ID) REFERENCES House_Owner(own_ID)
);

CREATE TABLE Payment (
    P_ID INT PRIMARY KEY,
    P_date INT,
    fee_amt INT,
    own_ID INT,
    C_ID INT,
    T_ID INT,
    FOREIGN KEY (own_ID) REFERENCES House_Owner(own_ID),
    FOREIGN KEY (C_ID) REFERENCES House_contract(C_ID),
    FOREIGN KEY (T_ID) REFERENCES Tenant(T_ID)
);



CREATE VIEW Tenant_View AS SELECT * FROM Tenant;
CREATE VIEW Tenant_Tel_View AS SELECT * FROM Tenant_Tel;
CREATE VIEW House_Owner_View AS SELECT * FROM House_Owner;
CREATE VIEW Owner_tel_View AS SELECT * FROM Owner_tel;
CREATE VIEW Rent_house_View AS SELECT * FROM Rent_house;
CREATE VIEW Region_cod_View AS SELECT * FROM Region_cod;
CREATE VIEW House_contract_View AS SELECT * FROM House_contract;
CREATE VIEW Payment_View AS SELECT * FROM Payment;

-- Indexes
CREATE INDEX IDX_Tenant_T_ID ON Tenant(T_ID);
CREATE INDEX IDX_Tenant_Tel_T_ID ON Tenant_Tel(T_ID);
CREATE INDEX IDX_House_Owner_own_ID ON House_Owner(own_ID);
CREATE INDEX IDX_Owner_tel_own_ID ON Owner_tel(own_ID);
CREATE INDEX IDX_Rent_house_H_ID ON Rent_house(H_ID);
CREATE INDEX IDX_Region_cod_reg_cod ON Region_cod(reg_cod);
CREATE INDEX IDX_House_contract_C_ID ON House_contract(C_ID);
CREATE INDEX IDX_Payment_P_ID ON Payment(P_ID);

select *from Rent_house

-- Table Population with Data
INSERT INTO Rent_house (H_ID, no_of_floors, no_of_rooms, regionCode) VALUES
(101, 2, 5, 'ET-ADD-001'),
(102, 3, 6, 'ET-AD-002'),
(103, 1, 3, 'ET-BHR-003');

INSERT INTO Region_cod (reg_cod, city, RH_state) VALUES
('ET-ADD-001', 'Addis Ababa', 'Addis Ababa'),
('ET-AD-002', 'Adama', 'Oromia'),
('ET-BHR-003', 'Bahir Dar', 'Amhara');

INSERT INTO House_Owner (own_ID, own_Fname, own_Lname, own_email) VALUES
(1, 'Yohannes', 'Girma', 'yohannes@example.com'),
(2, 'Tigist', 'Kebede', 'tigist@example.com'),
(3, 'Mulu', 'Assefa', 'mulu@example.com');

INSERT INTO Tenant (T_ID, T_Fname, T_Lname, H_ID) VALUES
(1, 'Abebe', 'Tadesse', 101),
(2, 'Meseret', 'Mengistu', 102),
(3, 'Habtamu', 'Berhanu', 103);

INSERT INTO House_contract (C_ID, startDate, endDate, T_ID, own_ID, H_ID) VALUES
(1, 20230101, 20240101, 1, 1, 101),
(2, 20230201, 20240201, 2, 2, 102),
(3, 20230301, 20240301, 3, 3, 103);

INSERT INTO Tenant_Tel (T_tel, T_ID) VALUES
(123456789, 1),
(987654321, 2),
(555555555, 3);

INSERT INTO Owner_tel (own_tel, own_ID) VALUES
(111111111, 1),
(222222222, 2),
(333333333, 3);

INSERT INTO Payment (P_ID, P_date, fee_amt, own_ID, C_ID, T_ID) VALUES
(1, 20230115, 2000, 1, 1, 1),
(2, 20230215, 2500, 2, 2, 2),
(3, 20230315, 1800, 3, 3, 3);



-- SQL Statements to Retrieve, Delete, and Update Data
-- Retrieving Data
SELECT * FROM Tenant;
SELECT own_Fname, own_Lname FROM House_Owner;
SELECT * FROM Rent_house WHERE no_of_floors > 2;
SELECT t.T_Fname, t.T_Lname, h.no_of_floors
FROM Tenant t
JOIN House_contract hc ON t.T_ID = hc.T_ID
JOIN Rent_house h ON hc.H_ID = h.H_ID;

-- Deleting Data
DELETE FROM Payment;

-- Updating Data
UPDATE House_Owner SET own_email = 'new_email@exam.com' WHERE own_ID = 1;
UPDATE Rent_house SET no_of_floors = 3 WHERE H_ID = 101;

  -- Triggers
-- Prevent attempt to insert duplicate Payment ID using triggers
CREATE TRIGGER PreventDuplicatePaymentID
ON Payment
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Payment p ON i.P_ID = p.P_ID
    )
    BEGIN
        RAISERROR ('Duplicate Payment ID detected', 16, 1);
        ROLLBACK TRANSACTION; -- Optionally rollback the transaction
    END
    ELSE
    BEGIN
        INSERT INTO Payment (P_ID, P_date, fee_amt, own_ID, C_ID, T_ID)
        SELECT P_ID, P_date, fee_amt, own_ID, C_ID, T_ID FROM inserted;
    END
END;

-- Prevent attempt to insert duplicate House ID using triggers
CREATE TRIGGER PreventDuplicateHouseID
ON Rent_house
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Rent_house rh ON i.H_ID = rh.H_ID
    )
    BEGIN
        print ('Duplicate House ID detected');
        ROLLBACK TRANSACTION; 
    END
    ELSE
    BEGIN
        INSERT INTO Rent_house (H_ID, no_of_floors)
        SELECT H_ID, no_of_floors FROM inserted;
    END
END;

-- Functions
-- Calculate Total Amount of payment using function
CREATE FUNCTION CalculateTotalPaymentAmount (@contract_id INT) 
RETURNS INT
AS
BEGIN
    DECLARE @total_payment INT;
    DECLARE @start_date DATE;
    DECLARE @end_date DATE;
    DECLARE @monthly_payment_amount INT;

    SELECT @start_date = CONVERT(DATE, CONVERT(VARCHAR(8), startDate)),
           @end_date = CONVERT(DATE, CONVERT(VARCHAR(8), endDate))
    FROM House_contract
    WHERE C_ID = @contract_id;

    IF @start_date IS NULL OR @end_date IS NULL
    BEGIN
       
        RETURN 0; 
    END
    DECLARE @duration INT;
    SET @duration = DATEDIFF(MONTH, @start_date, @end_date) + 1; 

    SELECT @monthly_payment_amount = fee_amt
    FROM Payment
    WHERE C_ID = @contract_id;
    SET @total_payment = @duration * @monthly_payment_amount;
    RETURN @total_payment
END;

--Sample call
select dbo.CalculateTotalPaymentAmount(2) as total_payment;

-- Calculate the number of late days on a house payment using function
CREATE FUNCTION CalculateLateDays (@payment_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @late_days INT;

    -- Get payment date and end date from House_contract table
    DECLARE @payment_date DATE;
    DECLARE @end_date DATE;

    SELECT @payment_date = CONVERT(DATE, CONVERT(VARCHAR(8), P_date)),
           @end_date = CONVERT(DATE, CONVERT(VARCHAR(8), endDate))
    FROM Payment p
    INNER JOIN House_contract hc ON p.C_ID = hc.C_ID
    WHERE P_ID = @payment_id;

    -- Calculate the number of late days
    IF @payment_date > @end_date
    BEGIN
        SET @late_days = DATEDIFF(DAY, @end_date, @payment_date);
    END
    ELSE
    BEGIN
        SET @late_days = 0; -- No late payment
    END

    RETURN @late_days;
END;

--Sample call
select dbo.CalculateLateDays(2) as late_days_for_payment;

-- Insert Data to all tables with procedures
CREATE PROCEDURE InsertDataIntoAllTables
	@reg_cod VARCHAR(20),
    @city VARCHAR(20),
    @RH_state VARCHAR(20),
	@own_ID BIGINT,
    @own_Fname VARCHAR(20),
    @own_Lname VARCHAR(20),
    @own_email VARCHAR(20),
    @own_tel BIGINT,
	@H_ID BIGINT,
    @no_of_floors BIGINT,
    @T_ID BIGINT,
    @T_Fname VARCHAR(20),
    @T_Lname VARCHAR(20),
    @T_tel BIGINT,
    @C_ID BIGINT,
    @startDate BIGINT,
    @endDate BIGINT,
    @P_ID BIGINT,
    @P_date BIGINT,
    @fee_amt BIGINT
AS
BEGIN
    SET NOCOUNT ON;
	-- Insert into region_cod table 
    INSERT INTO region_cod (reg_cod, city, RH_state)
    VALUES (@reg_cod, @city, @RH_state);

	 -- Insert into House_Owner table
    INSERT INTO House_Owner (own_ID, own_Fname, own_Lname, own_email)
    VALUES (@own_ID, @own_Fname, @own_Lname, @own_email);

	-- Insert into Owner_tel table
    INSERT INTO Owner_tel (own_tel, own_ID)
    VALUES (@own_tel, @own_ID);


	-- Insert into Rent_house table
    INSERT INTO Rent_house (H_ID, no_of_floors)
    VALUES (@H_ID, @no_of_floors);

    -- Insert into Tenant table
    INSERT INTO Tenant (T_ID, T_Fname, T_Lname)
    VALUES (@T_ID, @T_Fname, @T_Lname);

    -- Insert into Tenant_Tel table
    INSERT INTO Tenant_Tel (T_tel, T_ID)
    VALUES (@T_tel, @T_ID);

   -- Insert into House_contract table
    INSERT INTO House_contract (C_ID, startDate, endDate, T_ID, own_ID, H_ID)
    VALUES (@C_ID, @startDate, @endDate, @T_ID, @own_ID, @H_ID);

    

    -- Insert into Payment table
    INSERT INTO Payment (P_ID, P_date, fee_amt, own_ID, C_ID, T_ID)
    VALUES (@P_ID, @P_date, @fee_amt, @own_ID, @C_ID, @T_ID);
END;

-- Create login
CREATE LOGIN HouseRentalsUser WITH PASSWORD = 'BDU_DB_PROJ';

-- Create user and assign to login
CREATE USER HouseRentalsUser FOR LOGIN HouseRentalsUser;

-- Create roles
CREATE ROLE TenantRole;
CREATE ROLE OwnerRole;
CREATE ROLE AdminRole;

-- Assign users to roles
ALTER ROLE TenantRole ADD MEMBER HouseRentalUser;
-- Create schema
CREATE SCHEMA rental_schema AUTHORIZATION TenantRole;

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON Rent_house TO TenantRole;
GRANT SELECT ON Region_cod TO TenantRole;
GRANT SELECT, UPDATE ON Rent_house TO OwnerRole;
GRANT SELECT ON House_Owner TO OwnerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Rent_house TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Payment TO AdminRole;

-- Assign schema ownership
ALTER AUTHORIZATION ON SCHEMA::rental_schema TO TenantRole;

-- Revoke permissions if needed
REVOKE INSERT ON Rent_house FROM TenantRole;



BEGIN TRANSACTION;
DECLARE @T_ID INT;
DECLARE @T_Fname VARCHAR(20);
DECLARE @T_Lname VARCHAR(20);
DECLARE @H_ID INT;

SET @T_ID = 4;
SET @T_Fname = 'New';
SET @T_Lname = 'Tenant';
SET @H_ID = 101; -- House selected by the tenant

INSERT INTO Tenant (T_ID, T_Fname, T_Lname, H_ID) VALUES (@T_ID, @T_Fname, @T_Lname, @H_ID);
COMMIT TRANSACTION;


BEGIN TRANSACTION;
DECLARE @New_H_ID INT;
DECLARE @no_of_floors INT;
DECLARE @no_of_rooms INT;


SET @New_H_ID = 104; -- New house ID
SET @no_of_floors = 2;
SET @no_of_rooms = 4;


INSERT INTO Rent_house (H_ID, no_of_floors, no_of_rooms) VALUES (@New_H_ID, @no_of_floors, @no_of_rooms);
COMMIT TRANSACTION;

BEGIN TRANSACTION;
DECLARE @P_ID INT;
DECLARE @P_date INT;
DECLARE @fee_amt INT;
DECLARE @own_ID INT;
DECLARE @C_ID INT;
DECLARE @T_ID INT;

SET @P_ID = 4;
SET @P_date = 20240415; -- Payment date
SET @fee_amt = 2200; -- Payment amount
SET @own_ID = 1; -- House owner ID
SET @C_ID = 1; -- Contract ID
SET @T_ID = 4; -- Tenant ID

INSERT INTO Payment (P_ID, P_date, fee_amt, own_ID, C_ID, T_ID) 
VALUES (@P_ID, @P_date, @fee_amt, @own_ID, @C_ID, @T_ID);
COMMIT TRANSACTION;


BEGIN TRANSACTION;
DECLARE @Contract_ID INT;
DECLARE @New_EndDate INT;

SET @Contract_ID = 1; -- Existing contract ID
SET @New_EndDate = 20250101; -- New end date

UPDATE House_contract SET endDate = @New_EndDate WHERE C_ID = @Contract_ID;
COMMIT TRANSACTION;


BEGIN TRANSACTION;
DECLARE @Updated_T_ID INT;
DECLARE @New_Tel INT;

SET @Updated_T_ID = 4; -- Tenant ID
SET @New_Tel = 999999999; -- New telephone number

UPDATE Tenant_Tel SET T_tel = @New_Tel WHERE T_ID = @Updated_T_ID;
COMMIT TRANSACTION;


BEGIN TRANSACTION;
DECLARE @Updated_T_ID INT;
DECLARE @New_Tel INT;

SET @Updated_T_ID = 4; -- Tenant ID
SET @New_Tel = 999999999; -- New telephone number

UPDATE Tenant_Tel SET T_tel = @New_Tel WHERE T_ID = @Updated_T_ID;
COMMIT TRANSACTION;


BEGIN TRANSACTION;
DECLARE @Updated_own_ID INT;
DECLARE @New_own_tel INT;

SET @Updated_own_ID = 1; -- House owner ID
SET @New_own_tel = 444444444; -- New telephone number

UPDATE Owner_tel SET own_tel = @New_own_tel WHERE own_ID = @Updated_own_ID;
COMMIT TRANSACTION;


BEGIN TRANSACTION ExtendContract;

UPDATE House_contract
SET endDate = 20250101
WHERE C_ID = 1;

COMMIT TRANSACTION ExtendContract;


BEGIN TRANSACTION AddNewRegion;

INSERT INTO Region_cod (reg_cod, city, RH_state)
VALUES ('ET-JI-004', 'Jimma', 'Oromia');

COMMIT TRANSACTION AddNewRegion;


BEGIN TRANSACTION DeletePayment;

DELETE FROM Payment WHERE P_ID = 3;

COMMIT TRANSACTION DeletePayment;

-- Full Backup
BACKUP DATABASE HOUSE_RENTAL_DATABASE11 TO DISK = 'C:\Backup\HOUSE_RENTAL_DATABASE11_FullBackup.bak'
WITH INIT,FORMAT,NAME='FullBackup';

-- Transaction Log Backup
BACKUP LOG YourDatabaseName TO DISK = 'C:\Backup\HOUSE_RENTAL_DATABASE11_Log.trn';
WITH INIT,FORMAT,NAME='LogBackup';
 


