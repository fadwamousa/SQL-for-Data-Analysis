DROP TABLE IF EXISTS Physician;
CREATE TABLE Physician (
  EmployeeID INTEGER NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Position VARCHAR(30) NOT NULL,
  SSN INTEGER NOT NULL,
  CONSTRAINT pk_physician PRIMARY KEY(EmployeeID)
); 

DROP TABLE IF EXISTS Department;
CREATE TABLE Department (
  DepartmentID INTEGER NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Head INTEGER NOT NULL,
  CONSTRAINT pk_Department PRIMARY KEY(DepartmentID),
  CONSTRAINT fk_Department_Physician_EmployeeID FOREIGN KEY(Head) REFERENCES Physician(EmployeeID)
);


DROP TABLE IF EXISTS Affiliated_With;
CREATE TABLE Affiliated_With (
  Physician INTEGER NOT NULL,
  Department INTEGER NOT NULL,
  PrimaryAffiliation varchar(1) NOT NULL,
  CONSTRAINT fk_Affiliated_With_Physician_EmployeeID FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID),
  CONSTRAINT fk_Affiliated_With_Department_DepartmentID FOREIGN KEY(Department) REFERENCES Department(DepartmentID),
  PRIMARY KEY(Physician, Department)
);

DROP TABLE IF EXISTS Procedures;
CREATE TABLE Procedures (
  Code INTEGER PRIMARY KEY NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Cost REAL NOT NULL
);

DROP TABLE IF EXISTS Trained_In;
CREATE TABLE Trained_In (
  Physician INTEGER NOT NULL,
  Treatment INTEGER NOT NULL,
  CertificationDate DATETIME NOT NULL,
  CertificationExpires DATETIME NOT NULL,
  CONSTRAINT fk_Trained_In_Physician_EmployeeID FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID),
  CONSTRAINT fk_Trained_In_Procedures_Code FOREIGN KEY(Treatment) REFERENCES Procedures(Code),
  PRIMARY KEY(Physician, Treatment)
);

DROP TABLE IF EXISTS Patient;
CREATE TABLE Patient (
  SSN INTEGER PRIMARY KEY NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Address VARCHAR(30) NOT NULL,
  Phone VARCHAR(30) NOT NULL,
  InsuranceID INTEGER NOT NULL,
  PCP INTEGER NOT NULL,
  CONSTRAINT fk_Patient_Physician_EmployeeID FOREIGN KEY(PCP) REFERENCES Physician(EmployeeID)
);

DROP TABLE IF EXISTS Nurse;
CREATE TABLE Nurse (
  EmployeeID INTEGER PRIMARY KEY NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Position VARCHAR(30) NOT NULL,
  Registered varchar(1) NOT NULL,
  SSN INTEGER NOT NULL
);

DROP TABLE IF EXISTS Appointment;
CREATE TABLE Appointment (
  AppointmentID INTEGER PRIMARY KEY NOT NULL,
  Patient INTEGER NOT NULL,    
  PrepNurse INTEGER,
  Physician INTEGER NOT NULL,
  Start DATETIME NOT NULL,
  Endz DATETIME NOT NULL,
  ExaminationRoom TEXT NOT NULL,
  CONSTRAINT fk_Appointment_Patient_SSN FOREIGN KEY(Patient) REFERENCES Patient(SSN),
  CONSTRAINT fk_Appointment_Nurse_EmployeeID FOREIGN KEY(PrepNurse) REFERENCES Nurse(EmployeeID),
  CONSTRAINT fk_Appointment_Physician_EmployeeID FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID)
);

DROP TABLE IF EXISTS Medication;
CREATE TABLE Medication (
  Code INTEGER PRIMARY KEY NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Brand VARCHAR(30) NOT NULL,
  Description VARCHAR(30) NOT NULL
);


DROP TABLE IF EXISTS Prescribes;
CREATE TABLE Prescribes (
  Physician INTEGER NOT NULL,
  Patient INTEGER NOT NULL, 
  Medication INTEGER NOT NULL, 
  Date DATETIME NOT NULL,
  Appointment INTEGER,  
  Dose VARCHAR(30) NOT NULL,
  PRIMARY KEY(Physician, Patient, Medication, Date),
  CONSTRAINT fk_Prescribes_Physician_EmployeeID FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID),
  CONSTRAINT fk_Prescribes_Patient_SSN FOREIGN KEY(Patient) REFERENCES Patient(SSN),
  CONSTRAINT fk_Prescribes_Medication_Code FOREIGN KEY(Medication) REFERENCES Medication(Code),
  CONSTRAINT fk_Prescribes_Appointment_AppointmentID FOREIGN KEY(Appointment) REFERENCES Appointment(AppointmentID)
);

DROP TABLE IF EXISTS Block;
CREATE TABLE Block (
  BlockFloor INTEGER NOT NULL,
  BlockCode INTEGER NOT NULL,
  PRIMARY KEY(BlockFloor, BlockCode)
); 

DROP TABLE IF EXISTS Room;
CREATE TABLE Room (
  RoomNumber INTEGER PRIMARY KEY NOT NULL,
  RoomType VARCHAR(30) NOT NULL,
  BlockFloor INTEGER NOT NULL,  
  BlockCode INTEGER NOT NULL,  
  Unavailable varchar(1) NOT NULL,
  CONSTRAINT fk_Room_Block_PK FOREIGN KEY(BlockFloor, BlockCode) REFERENCES Block(BlockFloor, BlockCode)
);

DROP TABLE IF EXISTS On_Call;
CREATE TABLE On_Call (
  Nurse INTEGER NOT NULL,
  BlockFloor INTEGER NOT NULL, 
  BlockCode INTEGER NOT NULL,
  OnCallStart DATETIME NOT NULL,
  OnCallEnd DATETIME NOT NULL,
  PRIMARY KEY(Nurse, BlockFloor, BlockCode, OnCallStart, OnCallEnd),
  CONSTRAINT fk_OnCall_Nurse_EmployeeID FOREIGN KEY(Nurse) REFERENCES Nurse(EmployeeID),
  CONSTRAINT fk_OnCall_Block_Floor FOREIGN KEY(BlockFloor, BlockCode) REFERENCES Block(BlockFloor, BlockCode) 
);

DROP TABLE IF EXISTS Stay;
CREATE TABLE Stay (
  StayID INTEGER PRIMARY KEY NOT NULL,
  Patient INTEGER NOT NULL,
  Room INTEGER NOT NULL,
  StayStart DATETIME NOT NULL,
  StayEnd DATETIME NOT NULL,
  CONSTRAINT fk_Stay_Patient_SSN FOREIGN KEY(Patient) REFERENCES Patient(SSN),
  CONSTRAINT fk_Stay_Room_Number FOREIGN KEY(Room) REFERENCES Room(RoomNumber)
);

DROP TABLE IF EXISTS Undergoes;
CREATE TABLE Undergoes (
  Patient INTEGER NOT NULL,
  Procedures INTEGER NOT NULL,
  Stay INTEGER NOT NULL,
  DateUndergoes DATETIME NOT NULL,
  Physician INTEGER NOT NULL,
  AssistingNurse INTEGER,
  PRIMARY KEY(Patient, Procedures, Stay, DateUndergoes),
  CONSTRAINT fk_Undergoes_Patient_SSN FOREIGN KEY(Patient) REFERENCES Patient(SSN),
  CONSTRAINT fk_Undergoes_Procedures_Code FOREIGN KEY(Procedures) REFERENCES Procedures(Code),
  CONSTRAINT fk_Undergoes_Stay_StayID FOREIGN KEY(Stay) REFERENCES Stay(StayID),
  CONSTRAINT fk_Undergoes_Physician_EmployeeID FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID),
  CONSTRAINT fk_Undergoes_Nurse_EmployeeID FOREIGN KEY(AssistingNurse) REFERENCES Nurse(EmployeeID)
);


INSERT INTO Physician VALUES(1,'John Dorian','Staff Internist',111111111);
INSERT INTO Physician VALUES(2,'Elliot Reid','Attending Physician',222222222);
INSERT INTO Physician VALUES(3,'Christopher Turk','Surgical Attending Physician',333333333);
INSERT INTO Physician VALUES(4,'Percival Cox','Senior Attending Physician',444444444);
INSERT INTO Physician VALUES(5,'Bob Kelso','Head Chief of Medicine',555555555);
INSERT INTO Physician VALUES(6,'Todd Quinlan','Surgical Attending Physician',666666666);
INSERT INTO Physician VALUES(7,'John Wen','Surgical Attending Physician',777777777);
INSERT INTO Physician VALUES(8,'Keith Dudemeister','MD Resident',888888888);
INSERT INTO Physician VALUES(9,'Molly Clock','Attending Psychiatrist',999999999);

INSERT INTO Department VALUES(1,'General Medicine',4);
INSERT INTO Department VALUES(2,'Surgery',7);
INSERT INTO Department VALUES(3,'Psychiatry',9);

INSERT INTO Affiliated_With VALUES(1,1,1);
INSERT INTO Affiliated_With VALUES(2,1,1);
INSERT INTO Affiliated_With VALUES(3,1,0);
INSERT INTO Affiliated_With VALUES(3,2,1);
INSERT INTO Affiliated_With VALUES(4,1,1);
INSERT INTO Affiliated_With VALUES(5,1,1);
INSERT INTO Affiliated_With VALUES(6,2,1);
INSERT INTO Affiliated_With VALUES(7,1,0);
INSERT INTO Affiliated_With VALUES(7,2,1);
INSERT INTO Affiliated_With VALUES(8,1,1);
INSERT INTO Affiliated_With VALUES(9,3,1);

INSERT INTO Procedures VALUES(1,'Reverse Rhinopodoplasty',1500.0);
INSERT INTO Procedures VALUES(2,'Obtuse Pyloric Recombobulation',3750.0);
INSERT INTO Procedures VALUES(3,'Folded Demiophtalmectomy',4500.0);
INSERT INTO Procedures VALUES(4,'Complete Walletectomy',10000.0);
INSERT INTO Procedures VALUES(5,'Obfuscated Dermogastrotomy',4899.0);
INSERT INTO Procedures VALUES(6,'Reversible Pancreomyoplasty',5600.0);
INSERT INTO Procedures VALUES(7,'Follicular Demiectomy',25.0);

INSERT INTO Patient VALUES(100000001,'John Smith','42 Foobar Lane','555-0256',68476213,1);
INSERT INTO Patient VALUES(100000002,'Grace Ritchie','37 Snafu Drive','555-0512',36546321,2);
INSERT INTO Patient VALUES(100000003,'Random J. Patient','101 Omgbbq Street','555-1204',65465421,2);
INSERT INTO Patient VALUES(100000004,'Dennis Doe','1100 Foobaz Avenue','555-2048',68421879,3);

INSERT INTO Nurse VALUES(101,'Carla Espinosa','Head Nurse',1,111111110);
INSERT INTO Nurse VALUES(102,'Laverne Roberts','Nurse',1,222222220);
INSERT INTO Nurse VALUES(103,'Paul Flowers','Nurse',0,333333330);

INSERT INTO Appointment VALUES(13216584,100000001,101,1,'2008-04-24 10:00','2008-04-24 11:00','A');
INSERT INTO Appointment VALUES(26548913,100000002,101,2,'2008-04-24 10:00','2008-04-24 11:00','B');
INSERT INTO Appointment VALUES(36549879,100000001,102,1,'2008-04-25 10:00','2008-04-25 11:00','A');
INSERT INTO Appointment VALUES(46846589,100000004,103,4,'2008-04-25 10:00','2008-04-25 11:00','B');
INSERT INTO Appointment VALUES(59871321,100000004,NULL,4,'2008-04-26 10:00','2008-04-26 11:00','C');
INSERT INTO Appointment VALUES(69879231,100000003,103,2,'2008-04-26 11:00','2008-04-26 12:00','C');
INSERT INTO Appointment VALUES(76983231,100000001,NULL,3,'2008-04-26 12:00','2008-04-26 13:00','C');
INSERT INTO Appointment VALUES(86213939,100000004,102,9,'2008-04-27 10:00','2008-04-21 11:00','A');
INSERT INTO Appointment VALUES(93216548,100000002,101,2,'2008-04-27 10:00','2008-04-27 11:00','B');

INSERT INTO Medication VALUES(1,'Procrastin-X','X','N/A');
INSERT INTO Medication VALUES(2,'Thesisin','Foo Labs','N/A');
INSERT INTO Medication VALUES(3,'Awakin','Bar Laboratories','N/A');
INSERT INTO Medication VALUES(4,'Crescavitin','Baz Industries','N/A');
INSERT INTO Medication VALUES(5,'Melioraurin','Snafu Pharmaceuticals','N/A');

INSERT INTO Prescribes VALUES(1,100000001,1,'2008-04-24 10:47',13216584,'5');
INSERT INTO Prescribes VALUES(9,100000004,2,'2008-04-27 10:53',86213939,'10');
INSERT INTO Prescribes VALUES(9,100000004,2,'2008-04-30 16:53',NULL,'5');

INSERT INTO Block VALUES(1,1);
INSERT INTO Block VALUES(1,2);
INSERT INTO Block VALUES(1,3);
INSERT INTO Block VALUES(2,1);
INSERT INTO Block VALUES(2,2);
INSERT INTO Block VALUES(2,3);
INSERT INTO Block VALUES(3,1);
INSERT INTO Block VALUES(3,2);
INSERT INTO Block VALUES(3,3);
INSERT INTO Block VALUES(4,1);
INSERT INTO Block VALUES(4,2);
INSERT INTO Block VALUES(4,3);

INSERT INTO Room VALUES(101,'Single',1,1,0);
INSERT INTO Room VALUES(102,'Single',1,1,0);
INSERT INTO Room VALUES(103,'Single',1,1,0);
INSERT INTO Room VALUES(111,'Single',1,2,0);
INSERT INTO Room VALUES(112,'Single',1,2,1);
INSERT INTO Room VALUES(113,'Single',1,2,0);
INSERT INTO Room VALUES(121,'Single',1,3,0);
INSERT INTO Room VALUES(122,'Single',1,3,0);
INSERT INTO Room VALUES(123,'Single',1,3,0);
INSERT INTO Room VALUES(201,'Single',2,1,1);
INSERT INTO Room VALUES(202,'Single',2,1,0);
INSERT INTO Room VALUES(203,'Single',2,1,0);
INSERT INTO Room VALUES(211,'Single',2,2,0);
INSERT INTO Room VALUES(212,'Single',2,2,0);
INSERT INTO Room VALUES(213,'Single',2,2,1);
INSERT INTO Room VALUES(221,'Single',2,3,0);
INSERT INTO Room VALUES(222,'Single',2,3,0);
INSERT INTO Room VALUES(223,'Single',2,3,0);
INSERT INTO Room VALUES(301,'Single',3,1,0);
INSERT INTO Room VALUES(302,'Single',3,1,1);
INSERT INTO Room VALUES(303,'Single',3,1,0);
INSERT INTO Room VALUES(311,'Single',3,2,0);
INSERT INTO Room VALUES(312,'Single',3,2,0);
INSERT INTO Room VALUES(313,'Single',3,2,0);
INSERT INTO Room VALUES(321,'Single',3,3,1);
INSERT INTO Room VALUES(322,'Single',3,3,0);
INSERT INTO Room VALUES(323,'Single',3,3,0);
INSERT INTO Room VALUES(401,'Single',4,1,0);
INSERT INTO Room VALUES(402,'Single',4,1,1);
INSERT INTO Room VALUES(403,'Single',4,1,0);
INSERT INTO Room VALUES(411,'Single',4,2,0);
INSERT INTO Room VALUES(412,'Single',4,2,0);
INSERT INTO Room VALUES(413,'Single',4,2,0);
INSERT INTO Room VALUES(421,'Single',4,3,1);
INSERT INTO Room VALUES(422,'Single',4,3,0);
INSERT INTO Room VALUES(423,'Single',4,3,0);

INSERT INTO On_Call VALUES(101,1,1,'2008-11-04 11:00','2008-11-04 19:00');
INSERT INTO On_Call VALUES(101,1,2,'2008-11-04 11:00','2008-11-04 19:00');
INSERT INTO On_Call VALUES(102,1,3,'2008-11-04 11:00','2008-11-04 19:00');
INSERT INTO On_Call VALUES(103,1,1,'2008-11-04 19:00','2008-11-05 03:00');
INSERT INTO On_Call VALUES(103,1,2,'2008-11-04 19:00','2008-11-05 03:00');
INSERT INTO On_Call VALUES(103,1,3,'2008-11-04 19:00','2008-11-05 03:00');

INSERT INTO Stay VALUES(3215,100000001,111,'2008-05-01','2008-05-04');
INSERT INTO Stay VALUES(3216,100000003,123,'2008-05-03','2008-05-14');
INSERT INTO Stay VALUES(3217,100000004,112,'2008-05-02','2008-05-03');

INSERT INTO Undergoes VALUES(100000001,6,3215,'2008-05-02',3,101);
INSERT INTO Undergoes VALUES(100000001,2,3215,'2008-05-03',7,101);
INSERT INTO Undergoes VALUES(100000004,1,3217,'2008-05-07',3,102);
INSERT INTO Undergoes VALUES(100000004,5,3217,'2008-05-09',6,NULL);
INSERT INTO Undergoes VALUES(100000001,7,3217,'2008-05-10',7,101);
INSERT INTO Undergoes VALUES(100000004,4,3217,'2008-05-13',3,103);

INSERT INTO Trained_In VALUES(3,1,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(3,2,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(3,5,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(3,6,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(3,7,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(6,2,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(6,5,'2007-01-01','2007-12-31');
INSERT INTO Trained_In VALUES(6,6,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,1,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,2,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,3,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,4,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,5,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,6,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,7,'2008-01-01','2008-12-31');

--------------------------------------------------------------------------------
-- 8.1 Obtain the names of all physicians that have performed a medical procedure they have never been certified to perform.
select name from Physician

SELECT name AS "Physician"
FROM physician
WHERE employeeid IN
    ( SELECT undergoes.physician
     FROM undergoes
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician
     AND undergoes.Procedures=trained_in.treatment
     WHERE treatment IS NULL );

	 ----------------------------------------------------
	 --find those nurses who are yet to be registered. 
	 --Return all the fields of nurse table

	 select * from Nurse where Registered = 0
	 ------------------------------------------------------------
	 --find the nurse who is the head of their department. 
	 --Return Nurse Name as "name", Position as "Position".
	 select name,Position from Nurse where Position ='Head Nurse'
	 ------------------------------------------------------------------
	 --find those physicians who are the head of the department. 
	 --Return Department name as "Department" and Physician name as "Physician".

	 select Name from Physician where EmployeeID in (select Head from Department)
	 --OR-------------------------------------------------------
	 select Physician.Name from Physician inner Join Department
	 on Department.Head = Physician.EmployeeID
	 ---------------------------------------------------------------------------------
	 --count the number of patients who booked an appointment with 
	 --at least one Physician. 
	 --Return count as "Number of patients taken at least one appointment".

	 select * from Patient
	 select * from Physician

	 select Name,count(*) as Number_of_patients from Patient
	 where Patient.PCP IN (select Physician.EmployeeID from Physician)
	 group by Name

	 select Patient.Name,count(*) from Patient
	 inner join Physician
	 on Patient.PCP = Physician.EmployeeID
	 group by Patient.Name


	 SELECT count(DISTINCT patient) AS 'No. of patients taken at least one appointment'
     FROM appointment
	 ------------------------------------------------------------------------------------------
	 --find the floor and block where the room number 212 belongs. 
	 --Return block floor as "Floor" and block code as "Block".

	 select * from Room
	 select * from Block

	 select Room.RoomNumber,BlockFloor as Floor,Room.BlockCode as Block
	 from Room where RoomNumber = 212

	 -------------------------------------------------------------------------------------------
	 --count the number available rooms. Return count as "Number of available rooms"
	  select count(*) as AvailableRoom from Room where Unavailable = 0
	  select count(*) as AvailableRoom from Room where Unavailable =1
	 --------------------------------------------------------------------------
	 --find the physician and the departments they are affiliated with. 
	 --Return Physician name as "Physician",and department name as "Department"

	 select * from Physician
	 select * from Affiliated_With
	 select * from Department

	 select name from Physician where EmployeeID IN  
	             (select Physician from Affiliated_With)
				 and exists (select Department.Head from Department)


      SELECT p.name AS "Physician",
       d.name AS "Department"
      FROM physician p,
      department d,
      affiliated_with a
      WHERE p.employeeid=a.physician
      AND a.department=d.departmentid;	
	  -------------------------------------------------------------------
	  --find those physicians who have trained for special treatment. 
	  --Return Physician name as "Physician", treatment procedure name as "Treatment
	  select * from Physician
	  select * from Trained_In
	  select * from Procedures

	  select Physician.Name,Procedures.Name
	  from Physician inner Join Trained_In
	  on Physician.EmployeeID = Trained_In.Physician
	  inner Join Procedures
	  on Procedures.Code = Trained_In.Treatment

	  SELECT p.name AS "Physician",
      c.name AS "Treatment"
      FROM physician p,
      Procedures c,
      trained_in t
      WHERE t.physician=p.employeeid
      AND t.treatment=c.code;
	  --------------------------------------------------------------------
	  --find those physicians who are yet to be affiliated.
	  --Return Physician name as "Physician", Position, and department as "Department".


      select * from Physician
	  select * from Affiliated_With
	  select * from Department

	  SELECT p.name AS "Physician",
       d.name AS "Department"
      FROM physician p,
      department d,
      affiliated_with a
      WHERE p.employeeid=a.physician
      AND a.department=d.departmentid
	  And a.PrimaryAffiliation = 0
	  ---------------------------------------------------------------------------
	  -- find those physicians who are not a specialized physician.
	  --Return Physician name as "Physician", position as "Designation"

	   select * from Physician
	   select * from Trained_In

	  select Physician.Name as Physician , Physician.Position
	  from Physician where EmployeeID not in (select Physician from Trained_In)

	  SELECT p.name AS "Physician",
       p.position "Designation"
      FROM physician p
      LEFT JOIN trained_in t ON p.employeeid=t.physician
      WHERE t.treatment IS NULL
      ORDER BY employeeid;

	  ---------------------------------------------------------------------------------------------
	  --find the patients with their physicians by whom they got their preliminary treatment.
	  --Return Patient name as "Patient", address as "Address" and Physician name as "Physician".

	

	  select Name,Address from Patient
	  where PCP in (select EmployeeID from Physician)

	  SELECT t.name AS "Patient",
       t.address AS "Address",
       p.name AS "Physician"
       FROM patient t
       JOIN physician p ON t.pcp=p.employeeid;

	   -------------------------------------------------------------------------------------
	   -- find the patients and the number of physicians they have taken appointment.
	   --Return Patient name as "Patient", number of Physicians as "Appointment for No. of Physicians"

	     select * from Patient
	     select * from Physician
		 select * from Appointment

		 select Patient.Name,count(Physician) from Patient
		 inner Join Appointment
		 on Appointment.Patient = Patient.SSN
		 group by Patient.Name



		 ----------------------------------------------------------------------------------
		 --count number of unique patients who got an appointment for examination room ‘C’.
		 --Return unique patients as “No. of patients got appointment for room C”.

		 select * from Room
		 select * from Appointment

		SELECT count(DISTINCT patient) AS "No. of patients got appointment for room C"
        FROM appointment
        WHERE convert(varchar,examinationroom)='C';
        
		----------------------------------------------------------------------------------------------
		--find the name of the patients and the number of the room where they have to go for their treatment. 
		--Return patient name as “Patient”, examination room as "Room No.”,
		--and starting date time as Date "Date and Time of appointment".
		SELECT p.name AS "Patient",
        a.examinationroom AS "Room No.",
        a.Start AS "Date and Time of appointment"
        FROM patient p
        JOIN appointment a ON p.ssn=a.patient;

		---------------------------------------------------------------------------------------------------
		-- find the name of the nurses and the room scheduled, where they will assist the physicians.
		-- Return Nurse Name as “Name of the Nurse” and examination room as “Room No.”.
	    
		select name from Nurse
	    select * from Appointment

		select Name , examinationroom
		from Nurse inner join Appointment
		on Appointment.PrepNurse = Nurse.EmployeeID

		-------------------------------------------------------------------------------------------------
		-- query to find those patients who taken the appointment on the 25th of April at 10 am. Return Name of the patient,
		-- Name of the Nurse assisting the physician, Physician Name as "Name of the physician", examination room as "Room No.",
		
		select Patient.Name as Patient ,Nurse.Name As Nurse,Physician.Name as Phyician,Appointment.ExaminationRoom
		from Patient inner Join Appointment
		             on Appointment.Patient = Patient.SSN
		             inner join Physician
					 on Physician.EmployeeID = Appointment.Physician
					 inner Join Nurse
					 on Nurse.EmployeeID = Appointment.PrepNurse
					 where Appointment.Start ='2008-04-25 10:00:00'

       	-------------------------------------------------------------------------------------------------
		-- query to find those patients who taken the appointment on the 25th of April at 10 am. Return Name of the patient,
		-- Physician Name as "Name of the physician", examination room as "Room No.",

		SELECT t.name AS "Name of the patient",
           p.name AS "Name of the physician",
           a.examinationroom AS "Room No."
            FROM patient t
              JOIN appointment a ON a.patient=t.ssn
               JOIN physician p ON a.physician=p.employeeid
               WHERE a.prepnurse IS NULL;

       	-------------------------------------------------------------------------------------------------
        --find the patients and their treating physicians and medication.
		--Return Patient name as "Patient", Physician name as "Physician", Medication name as "Medication". 

		SELECT t.Name AS 'Patient',
       p.name AS "Physician",
       m.name AS "Medication"
       FROM patient t
      JOIN prescribes s ON s.patient=t.ssn
      JOIN physician p ON s.physician=p.employeeid
      JOIN medication m ON s.medication=m.code;
	  ----------------------------------------------------------------------------------------------
	  --Find the name and medication for those patients who did not take any appointment

	  SELECT t.name AS 'Patient',
       p.name AS 'Physician',
       m.name AS 'Medication'
     FROM Patient t
     JOIN prescribes s ON s.patient=t.ssn
     JOIN physician p ON s.physician=p.employeeid
     JOIN medication m ON s.medication=m.code
     WHERE s.appointment IS NULL;
	  ----------------------------------------------------------------------------------------------
	  --count the number of available rooms in each block. Sort the result-set on ID of the block.
	  --Return ID of the block as "Block", count number of available rooms as "Number of available rooms"


	  select * from Room

	  select BlockCode,count(*) as Number_of_rooms
	  from Room
	  where Room.Unavailable = 0
	  group by BlockCode
	  order by BlockCode ASC

	  -----------------------------------------------------------------------------------------------
	  --count the number of available rooms in each floor. Sort the result-set on block floor.
	  --Return floor ID as "Floor" and count the number of available rooms as "Number of available rooms"

	  select BlockFloor,count(*) as Number_of_rooms
	  from Room
	  where Room.Unavailable = 0
	  group by BlockFloor
	  order by BlockFloor ASC

	  ---------------------------------------------------------------------------------------------------
	  --

	  select BlockFloor,BlockCode,count(*) as Number_of_rooms
	  from Room
	  where Room.Unavailable = 0
	  group by BlockFloor,BlockCode
	  order by BlockFloor,BlockCode ASC
	  ---------------------------------------------------------------------------------------------------------------
	  --to find the floor where the maximum numbers of rooms are available.
	  --Return floor ID as "Floor", count "Number of available rooms". 

	      select * from (
		  select BlockFloor,count(*) as 'Number of available roomss',
		         DENSE_RANK() over(order by count(*) DESC) as DR
		  from Room
		  where room.Unavailable = 0
		  group by BlockFloor) SUB 
		  where DR = 1
	 ---------------------------------------------------------------------------------------
	      select * from (
		  select BlockFloor,count(*) as 'Number of available roomss',
		         DENSE_RANK() over(order by count(*) ASC) as DR
		  from Room
		  where room.Unavailable = 0
		  group by BlockFloor) SUB 
		  where DR = 1
		  ------------------------------------------------------------------------------
		 
		  SELECT p.name AS "Patient",
                     y.name AS "Physician",
                        n.name AS "Nurse",
                     s.StayEnd AS "Date of release",
                    pr.name as "Treatement going on",
                      r.roomnumber AS "Room",
                   r.blockfloor AS "Floor",
                       r.blockcode AS "Block"
           FROM undergoes u
           JOIN patient p ON u.patient=p.ssn
         JOIN physician y ON u.physician=y.employeeid
          LEFT JOIN nurse n ON u.assistingnurse=n.employeeid
             JOIN stay s ON u.patient=s.patient
                JOIN room r ON s.room=r.roomnumber
            JOIN Procedures pr on u.Procedures=pr.code;

	-------------------------------------------------------------------------------------
	--find all those physicians who performed a medical procedure,
	--but they are not certified to perform. Return Physician name as “Physician”

	

		SELECT name AS "Physician"
           FROM physician
             WHERE employeeid IN
        ( SELECT undergoes.physician
                FROM undergoes
                LEFT JOIN trained_In ON undergoes.physician=trained_in.physician
                AND undergoes.Procedures=trained_in.treatment
                WHERE treatment IS NULL );



	----------------------------------------------------------------------------


				  




		






	


















