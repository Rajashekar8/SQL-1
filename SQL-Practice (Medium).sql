--Show unique birth years from patients and order them by ascending.
select distinct year(birth_date)
from patients
order by year(birth_date);


--Show unique first names from the patients table which only occurs once in the list.
Select first_name
from patients
group by first_name
having count(*)=1;


--Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
Select patient_id
,first_name
from patients
where first_name like 'S____%s';


--Show patient_id, first_name, last_name from patients whos primary_diagnosis is 'Dementia'.
Select p.patient_id
,p.first_name
,p.last_name
from patients p
join admissions a on p.patient_id=a.patient_id where primary_diagnosis='Dementia';


--Display every patient's first_name. Order the list by the length of each name and then by alphbetically.
Select first_name
from patients
order by length(first_name)
,first_name;


--Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
Select count(case when gender='M' then 1 end) as male_count
,count(case when gender='F' then 1 end) as female_count
from patients;


--Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.
select first_name
,last_name
,allergies
from patients
where allergies in ('Penicillin','Morphine')
order by allergies
,first_name
,last_name;


--Show patient_id, primary_diagnosis from admissions. Find patients admitted multiple times for the same primary_diagnosis.
select patient_id
,primary_diagnosis
from admissions
group by patient_id
,primary_diagnosis
having count(*)>1;


--Show the city and the total number of patients in the city in the order from most to least patients.
select city
,count(distinct patient_id)
from patients
group by city
order by count(patient_id) desc;


--Show first name, last name and role of every person that is either patient or physician.
select first_name
,last_name
,case when patient_id is not null then 'Patient' end as role
from patients
union
select first_name
,last_name
,case when physician_id is not null then 'Physician' end as role
from physicians;


--Show all allergies ordered by popularity. Remove 'NKA' and NULL values from query.
select allergies
,count(allergies)
from patients
where allergies is not null and allergies<>'NKA'
group by allergies
order by count(allergies) desc;


--Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
select first_name
,last_name
,birth_date
from patients
where birth_date between '1970-01-01' and '1979-12-31'
order by birth_date;


--We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order.
select concat(upper(last_name),',',lower(first_name)) as full_name
from patients
order by first_name desc;


--Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
select province_id
,sum(height)
from patients
group by province_id
having sum(height)>6999;


--Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'.
select max(weight)-min(weight)
from patients
where last_name='Maroni';


--Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
select day(admission_date)
,count(admission_date)
from admissions
group by day(admission_date)
order by count(admission_date) desc;


--Show the patient_id, nursing_unit_id, room, and bed for patient_id 542's most recent admission_date.
select patient_id
,nursing_unit_id
,room
,bed
from admissions
where patient_id=542
order by admission_date desc
limit 1;


--Show the nursing_unit_id and count of admissions for each nursing_unit_id. Exclude the following nursing_unit_ids: 'CCU', 'OR', 'ICU', 'ER'.
select nursing_unit_id
,count(patient_id)
from admissions
where nursing_unit_id not in ('CCU','OR','ICU','ER')
group by nursing_unit_id;


/*Show patient_id, attending_physician_id, and primary_diagnosis for admissions that match one of the two criteria:
1. patient_id is an odd number and attending_physician_id is either 1, 5, or 19.
2. attending_physician_id contains a 2 and the length of patient_id is 3 characters.*/
select patient_id
,attending_physician_id
,primary_diagnosis
from admissions
where (patient_id%2<>0 and attending_physician_id in (1,5,19)) or (attending_physician_id like '%2%' and length(patient_id)=3);


--Show first_name, last_name, and the total amount of admissions attended for each physician.
select first_name
,last_name
,count(patient_id) as total_amount_of_admissions_attended
from physicians p
join admissions a on p.physician_id=a.attending_physician_id
group by physician_id;


--For each physician, display their id, full name, and the first and last admission date they attended.
select physician_id
,concat(first_name,' ',last_name) as full_name
,max(a.admission_date)
,min(a.admission_date)
from physicians p
join admissions a on p.physician_id=a.attending_physician_id
group by physician_id;