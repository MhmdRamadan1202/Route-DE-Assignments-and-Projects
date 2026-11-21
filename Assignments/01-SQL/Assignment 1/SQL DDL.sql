CREATE TABLE MembershipPlan (
    Plan_ID INTEGER PRIMARY KEY,
    Plan_Name VARCHAR(100) NOT NULL,
    Duration_Months INTEGER NOT NULL,
    Monthly_Fee DECIMAL(10,2) NOT NULL,
    CONSTRAINT CK_Plan_Duration CHECK (Duration_Months > 0),
    CONSTRAINT CK_Plan_Fee CHECK (Monthly_Fee >= 0)
);

CREATE TABLE Trainer (
    Trainer_ID INTEGER PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Phone_Number VARCHAR(30),
    Hire_Date DATE NOT NULL,
    Specialty VARCHAR(100)
);

CREATE TABLE Room (
    Room_Number INTEGER PRIMARY KEY,
    Room_Name VARCHAR(100) NOT NULL,
    Capacity INTEGER NOT NULL,
    CONSTRAINT CK_Room_Capacity CHECK (Capacity > 0)
);

CREATE TABLE Certification (
    Certification_Code VARCHAR(30) PRIMARY KEY,
    Certification_Name VARCHAR(100) NOT NULL,
    Issuing_Organization VARCHAR(150) NOT NULL
);

CREATE TABLE Member (
    Member_ID INTEGER PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Date_Of_Birth DATE NOT NULL,
    Phone_Number VARCHAR(30),
    Street VARCHAR(150) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Plan_ID INTEGER NOT NULL,
    CONSTRAINT FK_Member_Plan
        FOREIGN KEY (Plan_ID) REFERENCES MembershipPlan(Plan_ID)
);

CREATE TABLE FitnessClass (
    Class_ID INTEGER PRIMARY KEY,
    Class_Name VARCHAR(100) NOT NULL,
    Difficulty_Level VARCHAR(30) NOT NULL,
    Class_Date DATE NOT NULL,
    Start_Time TIME NOT NULL,
    Maximum_Capacity INTEGER NOT NULL,
    Trainer_ID INTEGER NOT NULL,
    Room_Number INTEGER NOT NULL,
    CONSTRAINT FK_Class_Trainer
        FOREIGN KEY (Trainer_ID) REFERENCES Trainer(Trainer_ID),
    CONSTRAINT FK_Class_Room
        FOREIGN KEY (Room_Number) REFERENCES Room(Room_Number),
    CONSTRAINT CK_Class_Capacity CHECK (Maximum_Capacity > 0),
    CONSTRAINT CK_Class_Difficulty
        CHECK (Difficulty_Level IN ('Beginner', 'Intermediate', 'Advanced'))
);

CREATE TABLE Registration (
    Member_ID INTEGER NOT NULL,
    Class_ID INTEGER NOT NULL,
    Registration_Date DATE NOT NULL,
    Registration_Status VARCHAR(20) NOT NULL,
    PRIMARY KEY (Member_ID, Class_ID),
    CONSTRAINT FK_Registration_Member
        FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID),
    CONSTRAINT FK_Registration_Class
        FOREIGN KEY (Class_ID) REFERENCES FitnessClass(Class_ID),
    CONSTRAINT CK_Registration_Status
        CHECK (Registration_Status IN ('Registered', 'Attended', 'Cancelled'))
);

CREATE TABLE TrainerCertification (
    Trainer_ID INTEGER NOT NULL,
    Certification_Code VARCHAR(30) NOT NULL,
    Earned_Date DATE NOT NULL,
    PRIMARY KEY (Trainer_ID, Certification_Code),
    CONSTRAINT FK_TC_Trainer
        FOREIGN KEY (Trainer_ID) REFERENCES Trainer(Trainer_ID),
    CONSTRAINT FK_TC_Certification
        FOREIGN KEY (Certification_Code) REFERENCES Certification(Certification_Code)
);
