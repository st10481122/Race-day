/* =========================================================
   RACE DAY DATABASE
   Section C - SQL Database Script
   ========================================================= */



  --- 1. DATABASE CREATION---
  
IF DB_ID('RaceDayDB') IS NULL
BEGIN
    CREATE DATABASE RaceDayDB;
END;
GO

USE RaceDayDB;
GO



   ---2. DROP EXISTING TABLES---
   
IF OBJECT_ID('dbo.Results', 'U') IS NOT NULL
    DROP TABLE dbo.Results;

IF OBJECT_ID('dbo.Enrolments', 'U') IS NOT NULL
    DROP TABLE dbo.Enrolments;

IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL
    DROP TABLE dbo.Categories;

IF OBJECT_ID('dbo.Events', 'U') IS NOT NULL
    DROP TABLE dbo.Events;

IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL
    DROP TABLE dbo.Users;

IF OBJECT_ID('dbo.Roles', 'U') IS NOT NULL
    DROP TABLE dbo.Roles;
GO



  --- 3. CREATE TABLES---
   
   ---Table 1: Roles---
   
CREATE TABLE dbo.Roles
(
    RoleId INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);
GO



   ---Table 2: Users---
   
CREATE TABLE dbo.Users
(
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    RoleId INT NOT NULL,

    CONSTRAINT FK_Users_Roles
        FOREIGN KEY (RoleId)
        REFERENCES dbo.Roles(RoleId)
);
GO


   ---Table 3: Events---
   
CREATE TABLE dbo.Events
(
    EventId INT IDENTITY(1,1) PRIMARY KEY,
    EventName NVARCHAR(200) NOT NULL,
    EventDate DATETIME NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),
    OrganiserId INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Events_Organiser
        FOREIGN KEY (OrganiserId)
        REFERENCES dbo.Users(UserId)
);
GO



   ---Table 4: Categories---
  
CREATE TABLE dbo.Categories
(
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    EventId INT NOT NULL,
    CategoryName NVARCHAR(100) NOT NULL,
    Distance DECIMAL(6,2) NOT NULL,
    EntryFee DECIMAL(10,2) NOT NULL DEFAULT 0.00,

    CONSTRAINT FK_Categories_Events
        FOREIGN KEY (EventId)
        REFERENCES dbo.Events(EventId)
        ON DELETE CASCADE,

    CONSTRAINT CK_Categories_Distance
        CHECK (Distance > 0),

    CONSTRAINT CK_Categories_EntryFee
        CHECK (EntryFee >= 0)
);
GO



   ---Table 5: Enrolments---
   
CREATE TABLE dbo.Enrolments
(
    EnrolmentId INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantId INT NOT NULL,
    CategoryId INT NOT NULL,
    EnrolmentDate DATETIME NOT NULL DEFAULT GETDATE(),
    PaymentStatus NVARCHAR(20) NOT NULL DEFAULT 'Pending',

    CONSTRAINT FK_Enrolments_Participant
        FOREIGN KEY (ParticipantId)
        REFERENCES dbo.Users(UserId),

    CONSTRAINT FK_Enrolments_Category
        FOREIGN KEY (CategoryId)
        REFERENCES dbo.Categories(CategoryId),

    CONSTRAINT UQ_Enrolments_Participant_Category
        UNIQUE (ParticipantId, CategoryId),

    CONSTRAINT CK_Enrolments_PaymentStatus
        CHECK (PaymentStatus IN ('Pending', 'Paid', 'Cancelled'))
);
GO

   ---Table 6: Results---

CREATE TABLE dbo.Results
(
    ResultId INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentId INT NOT NULL UNIQUE,
    FinishTime TIME NULL,
    Position INT NULL,
    Remarks NVARCHAR(255),

    CONSTRAINT FK_Results_Enrolments
        FOREIGN KEY (EnrolmentId)
        REFERENCES dbo.Enrolments(EnrolmentId),

    CONSTRAINT CK_Results_Position
        CHECK (Position IS NULL OR Position > 0)
);
GO



  ---4. SEED DATA---
   -- Seed Roles----
 

INSERT INTO dbo.Roles (RoleName)
VALUES
    ('Organiser'),
    ('Participant');
GO


/* ---------------------------------------------------------
   Seed Users
   2 Organisers
   2 Participants
   --------------------------------------------------------- */

INSERT INTO dbo.Users
    (FullName, Email, PasswordHash, RoleId)
VALUES
    ('John Eventman', 'john@organiser.com', 'hashed_pw_1', 1),
    ('Sarah Racepro', 'sarah@organiser.com', 'hashed_pw_2', 1),
    ('Sipho Runner', 'sipho@participant.com', 'hashed_pw_3', 2),
    ('Lerato Cyclist', 'lerato@participant.com', 'hashed_pw_4', 2);
GO


/* ---------------------------------------------------------
   Seed Events
   Three future RaceDay events.
   --------------------------------------------------------- */

INSERT INTO dbo.Events
    (EventName, EventDate, Location, Description, OrganiserId)
VALUES
    (
        'Joburg City Run',
        '2026-10-17 07:00:00',
        'Johannesburg CBD',
        'A scenic road running event through the heart of Johannesburg.',
        1
    ),
    (
        'Durban Beach Walk',
        '2026-11-07 08:30:00',
        'Durban Promenade',
        'A charity walking event along the Durban Golden Mile.',
        1
    ),
    (
        'Cape Classic Cycle',
        '2026-12-06 06:00:00',
        'Cape Town',
        'A cycling event featuring a challenging route through Cape Town.',
        2
    );
GO


/* ---------------------------------------------------------
   Seed Categories
   Each event has one or more categories.
   --------------------------------------------------------- */

INSERT INTO dbo.Categories
    (EventId, CategoryName, Distance, EntryFee)
VALUES
    (1, '10km Elite Run', 10.00, 150.00),
    (1, '5km Fun Run', 5.00, 80.00),
    (2, '5km Promenade Walk', 5.00, 50.00),
    (2, '10km Charity Walk', 10.00, 80.00),
    (3, '100km Full Course', 100.00, 450.00),
    (3, '50km Half Course', 50.00, 300.00);
GO


/* ---------------------------------------------------------
   Seed Enrolments
   Participants are enrolled into event categories.
   --------------------------------------------------------- */

INSERT INTO dbo.Enrolments
    (ParticipantId, CategoryId, PaymentStatus)
VALUES
    (3, 1, 'Paid'),
    (4, 5, 'Paid'),
    (3, 3, 'Pending'),
    (4, 2, 'Paid');
GO


/* ---------------------------------------------------------
   Seed Results
   Sample result for an enrolled participant.
   --------------------------------------------------------- */

INSERT INTO dbo.Results
    (EnrolmentId, FinishTime, Position, Remarks)
VALUES
    (1, '00:34:12', 5, 'Personal Best');
GO



   ---5. VERIFICATION QUERIES---
   

SELECT * FROM dbo.Roles;
SELECT * FROM dbo.Users;
SELECT * FROM dbo.Events;
SELECT * FROM dbo.Categories;
SELECT * FROM dbo.Enrolments;
SELECT * FROM dbo.Results;
GO