/* admin */
create table admin(
 	id serial primary key,
 	name varchar(255),
 	email varchar(255),
 	password varchar(255)
);


/* Health Care provider having their own nurses, doctors .... each patient needs to enroll into health care provider for services */

create table health_care_provider(
	id serial primary key,
	admin_id int references admin(id) on delete cascade
);

/* nurse belonging to one health care provider oganisation */
create table nurse(
	id serial primary key,
	name varchar(255),
	email varchar(255),
	password varchar(255),
	health_care_provider_id int references health_care_provider(id) on delete cascade
);

/* doctor belonging to one health organisation */

create table doctor(
	id serial primary key,
	name varchar(255),
	email varchar(255),
	password varchar(255),
	health_care_provider_id int references health_care_provider(id) on delete cascade
);

/* patient can enroll to multiple health care organisation and enjoy their services */

create table patient(
	id serial primary key,
	name varchar(255),
	email varchar(255),
	password varchar(255),
	nurse_id int references nurse(id) on delete cascade
);

create table patient_health_care_provider(
	id serial primary key,
	patient_id int references patient(id) on delete cascade,
	health_care_provider_id int references health_care_provider(id) on delete cascade
);

/* a patient can have multiple appointments with doctor */


create table patient_doctor(
	id serial primary key,
	patient_id int references patient(id) on delete cascade,
	doctor_id int references doctor(id) on delete cascade,
	UNIQUE(patient_id, doctor_id)
);


/* complaint made by any patient can belong to any entity except patient can be taken care in server */

create table complaint(
	id serial primary key,
	complainee int references patient(id) on delete cascade,
	text varchar(255),
	table_name varchar(255) not null,
	type int not null
);

/* each entity except patient can respond to the complaint */

create table reason(
	id serial primary key,
	text varchar(255),
	type int not null,
	complaint_id int references complaint(id),
	table_name varchar(255) not null
);



/* health care provider will decide what to do with the reason and on that basis remmove the complaint */
create table health_care_provider_reason(
	id serial primary key,
	reason_id int references reason(id),
	health_car_provider_id int references health_care_provider(id) on delete cascade
);

/* Each doctor on critical situation can assign nurse to a patient */

create table nurse_assignment(
	id serial primary key,
	nurse_id int references nurse(id) on delete cascade,
	doctor_id int references doctor(id) on delete cascade,
	UNIQUE(nurse_id, doctor_id)
);

/* prescription given by doctor to a patient */

create table prescription(
	id serial primary key
);


/* prescription can contain multiple medicines */

create table medicine(
	id serial primary key,
	name varchar(255),
	dose int
);

create table MedicineTimes (
    id serial PRIMARY KEY,
    medicine_id int references medicine(id),
    time VARCHAR(10)
);

create table prescribed_medicines(
	id serial primary key,
	medicine_id int references medicine(id),
	prescription_id int references prescription(id)
);


/* Health Record is a combination of vital_record, prescription and lab_test*/

create table vital_record(
	id serial primary key,
	status varchar(255),
	advice varchar(255)
);

create table lab_test(
	id serial primary key	
);

create table report(
	id serial primary key,
	text varchar(255),
	lab_test_id int references lab_test(id) on delete cascade
);

/* finally the health record */

create table health_record(
	id serial primary key,
	health_care_provider_id int references health_care_provider(id) on delete cascade,
	doctor_id int references doctor(id) on delete cascade,
	patient_id int references patient(id),
	prescription_id int references prescription(id),
	vital_record_id int references vital_record(id),
	lab_test_id int references lab_test(id)
);

/* patient and doctor can have appointment */

create table appointment(
	id serial primary key,
	startTime timestamp,
	endTime timestamp,
	doctor_id int references doctor(id),
	patient_id int references patient(id),
	status boolean,
	UNIQUE(patient_id, doctor_id)
);

/* For clinical test of patient we have services provided by clinical lab */

create table clinical_lab(
	id serial primary key,
	name varchar(255),
	password varchar(255),
	location varchar(255),
	email varchar(255)
);

/* health provider can connect to multiple clinical lab to get its work done */

create table health_care_provider_clinical_lab(
	id serial primary key,
	clinical_lab_id int references clinical_lab(id),
	health_care_provider_id int references health_care_provider(id) on delete cascade,
	UNIQUE(clinical_lab_id, health_care_provider_id)
);


/*in a clinical lab we have clinial technician who will be responsible for modifying patient health record by adding test results*/


create table clinical_technician(
	id serial primary key,
	name varchar(255),
	password varchar(255),
	email varchar(255),
	clinical_lab_id int references clinical_lab(id) on delete cascade
);

/* clinincal manager will overall handle the clinical lab */
create table clinical_manager(
	id serial primary key,
	name varchar(255),
	password varchar(255),
	email varchar(255),
	clinical_lab_id int references clinical_lab(id) on delete cascade
);


--Insert values into admin
INSERT INTO admin (name, email, password)
VALUES
    ('Admin 1', 'admin1@example.com', 'password1'),
    ('Admin 2', 'admin2@example.com', 'password2'),
    ('Admin 3', 'admin3@example.com', 'password3');



--Insert values into health-care-provider
INSERT INTO health_care_provider (admin_id)
VALUES
    (1),
    (2),
    (3);


--Insert values into nurse table
INSERT INTO nurse (name, email, password, health_care_provider_id)
VALUES
    ('Nurse 1', 'nurse1@example.com', 'nursepassword1', 1),
    ('Nurse 2', 'nurse2@example.com', 'nursepassword2', 1),
    ('Nurse 3', 'nurse3@example.com', 'nursepassword3', 2),
    ('Nurse 4', 'nurse4@example.com', 'nursepassword4', 2),
    ('Nurse 5', 'nurse5@example.com', 'nursepassword5', 3);




--Insert values into patient table
INSERT INTO patient (name, email, password, nurse_id)
VALUES
    ('John Doe', 'john@example.com', 'password123', 1),
    ('Alice Smith', 'alice@example.com', 'securepassword', 2),
    ('Bob Johnson', 'bob@example.com', 'strongpassword', 1),
    ('Emma Brown', 'emma@example.com', 'secretpass', 3),
    ('Michael Lee', 'michael@example.com', 'mypassword', 2),
    ('Sarah Wilson', 'sarah@example.com', 'password1234', 1),
    ('David Davis', 'david@example.com', 'davidpass', 3),
    ('Jennifer White', 'jennifer@example.com', 'jennifer123', 2),
    ('Daniel Taylor', 'daniel@example.com', 'danielpass', 1),
    ('Olivia Martinez', 'olivia@example.com', 'oliviapass', 3);


--Read operation for patient table
SELECT * FROM patient where nurse_id = 1;

--Update operation for patient table
UPDATE patient SET email = 'newemail@example.com' WHERE id = 1;

--Delete operation for patient table
Delete from patient where id = 3;

--Search query with like filter
SELECT * from patient where name LIKE '%vi%';

--Sorting operation in table
SELECT * from patient order by LENGTH(name);

--Pagination
SELECT * from patient limit 2 offset 1;

--Usage of joins
SELECT * from patient inner join nurse on patient.nurse_id = nurse.id;

--Usage of counts
SELECT COUNT(*),nurse_id,nurse.name from patient inner join nurse on patient.nurse_id = nurse.id group by nurse_id,nurse.name;

--Usage of count with order by
SELECT COUNT(*),nurse_id,nurse.name from patient inner join nurse on patient.nurse_id = nurse.id group by nurse_id,nurse.name order by count(*) desc;

