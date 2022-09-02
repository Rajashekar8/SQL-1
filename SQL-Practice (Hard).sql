--Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group. Order the list by the weight group decending.*/
select count(patient_id) as patients_in_group
,floor(weight/10)*10 as weight_group
from patients
group by weight_group
order by weight_group desc;


--Show patient_id, weight, height, isObese from the patients table. Display isObese as a boolean 0 or 1.
select patient_id
,weight
,height
,case when (weight/power((height/100.0),2))>=30 then 1 else 0 end as isObese
from patients;


--Show patient_id, first_name, last_name, and attending physician's specialty. Show only the patients who has a primary_diagnosis as 'Dementia' and the physician's first name is 'Lisa'
select a.patient_id
,p.first_name as patient_first_name
,p.last_name as patient_last_name
,ph.specialty as attending_physician_specialty
from admissions a
join patients p on a.patient_id=p.patient_id
join physicians ph on a.attending_physician_id=ph.physician_id
where a.primary_diagnosis='Dementia' and ph.first_name='Lisa';


/*All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
The password must be the following, in order:
1. patient_id
2. the numerical length of patient's last_name
3. year of patient's birth_date*/
select distinct(a.patient_id)
,concat(distinct(p.patient_id),len(p.last_name),year(p.birth_date)) as temp_password
from patients p
join admissions a on a.patient_id=p.patient_id;


--Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance. Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.
select case when patient_id%2=0 then 'Yes' else 'No' end as has_insurance
,case when patient_id%2=0 then count(patient_id)*10 else count(patient_id)*50 end as cost_after_insurance
from admissions
group by has_insurance;


--Show the provinces that has more patients identified as 'M' than 'F'.
select p.province_name from patients a 
join provinces p on a.province_id=p.province_id
group by province_name
having count(case when gender='M' then 1 end)>count(case when gender='F' then 1 end);


/*We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
- First_name contains an 'r' after the first two letters.
- Identifies their gender as 'F'
- Born in February, May, or December
- Their weight would be between 60kg and 80kg
- Their patient_id is an odd number
- They are from the city 'Halifax'*/
select *
from patients
where first_name like '__r%' and gender='F' and month(birth_date) in (2,5,12) and weight between 60 and 80 and patient_id%2<>0 and city='Halifax';


--Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.
select concat(
    round(
        (select count(*) from patients where gender='M')/cast(count(*) as float)
        ,4)
    *100
,%) as percent_of_male_patients
from patients;


--Show the patient_id and total_spent for patients who spent over 150 in medication_cost. Sort by most total_spent to least total_spent.
select u.patient_id
,sum(m.medication_cost)
from unit_dose_orders u
join medications m on m.medication_id=u.medication_id
group by patient_id
having sum(m.medication_cost)>150
order by sum(medication_cost) desc;


--Provide the description of each item, along with the total cost of the quantity on hand (rounded to the nearest whole dollar), and the associated primary vendor.
select item_description
,round(quantity_on_hand*item_cost,0)
,v.vendor_name
from items i
join vendors v on v.vendor_id=i.primary_vendor_id;


--For each day display the total amount of admissions on that day. Display the amount changed from the previous date.
with admission_counts_table as (
    select admission_date
    , count(patient_id) as admission_count
    from admissions
    group by admission_date
)
select admission_date
,admission_count
,admission_count - LAG(admission_count) over(order by admission_date) as admission_count_change 
from admission_counts_table;


--For each province, display the total amount patients spent on medication. Order by the most to least spent.
select pr.province_name
,round(sum(m.medication_cost)) as total_spent
from patients pa
join unit_dose_orders u on pa.patient_id=u.patient_id
join medications m on u.medication_id=m.medication_id
join provinces pr on pa.province_id=pr.province_id
group by province_name
order by total_spent desc;