-- total loan applications
select COUNT(id) as total_loan_applicantions from bank_loan_data

--  total loan application in latest month i.e MTD
select COUNT(id) as current_month__loan_applicantions
from bank_loan_data where   MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data) 
and YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data)

-- total application in previous month i.e PMTD
select COUNT(id) as previous_current_month__loan_applicantions
from bank_loan_data where   MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data) - 1 
and YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data)


--  total funded amount in latest month i.e MTD
select SUM(loan_amount) as current_month_to_date_funded_amount
from bank_loan_data where   MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data) 
and YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data)

-- total fundedd amount in previous month i.e PMTD
select SUM(loan_amount) as previous_MOD_funded_amount
from bank_loan_data where   MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data) - 1 
and YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data)

-- total received amont in latest month i.e MTD
select SUM(total_payment) as MTD_total_amount_received
from bank_loan_data where MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data)
and YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data)

-- total received amont in previous month i.e pMTD
select SUM(total_payment) as PMTD_total_amount_received
from bank_loan_data where MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data)-1
and YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data)

-- average intrest rate
select ROUND(AVG(int_rate),5)*100 as avg_intrest_rate from bank_loan_data

-- MTD average intrest rate
select ROUND(AVG(int_rate),5)*100 as MTD_avg_intrest_rate from bank_loan_data where MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data)
and YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data)

-- PMTD average intrest rate
select ROUND(AVG(int_rate),5)*100 as PMTD_avg_intrest_rate from bank_loan_data where MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data) - 1
and YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data)

-- MTD avg DTI debt to income ratio
select ROUND(AVG(dti),4) * 100 as avg_DTI  from bank_loan_data where MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data)
and YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data)

-- PMTD avg DTI debt to income ratio
select ROUND(AVG(dti),4) * 100 as avg_DTI  from bank_loan_data where MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data) - 1
and YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data)

-- GOOD LOAN PERCENTAGE
select ( COUNT( case when loan_status = 'Fully paid' or loan_status = 'Current' then id end ) *100 ) / COUNT(id) as good_loan_percentage
from bank_loan_data

-- total GOOD LOAN appplicaions
select COUNT( case when loan_status = 'Fully paid' or loan_status = 'Current' then id end ) as good_loan_applicantions
from bank_loan_data

select COUNT( case when loan_status in ('Fully paid','Current' ) then id end ) as good_loan_applicantions
from bank_loan_data 

--good loan funded amount
select SUM(loan_amount) as good_loan_funded_amount
from bank_loan_data where loan_status in ('Fully paid','Current' )

--good loan received amount
select SUM(total_payment) as good_loan_received_amount
from bank_loan_data where loan_status in ('Fully paid','Current' )

-- bad LOAN PERCENTAGE
select ( COUNT( case when loan_status = 'Charged off' then id end ) *100 ) / COUNT(id) as bad_loan_percentage
from bank_loan_data

-- total bad LOAN appplicaions
select COUNT( case when loan_status = 'Charged off' then id end ) as bad_loan_applicantions
from bank_loan_data

--bad loan funded amount
select SUM(loan_amount) as bad_loan_funded_amount
from bank_loan_data where loan_status = 'Charged off'

--bad loan received amount
select SUM(total_payment) as good_bad_received_amount
from bank_loan_data where loan_status = 'Charged off'

-- grid view for kpis
select loan_status,
        COUNT(id) as total_loan_applications,
        SUM(loan_amount) as total_loan_amount,
        SUM(total_payment) as total_amount_received,
        ROUND(AVG(int_rate), 4) *100 as interest_rate,
        ROUND(AVG(dti), 4) * 100 as DTI
from bank_loan_data
GROUP BY loan_status    


-- grid view for MTD
select loan_status,
        SUM(loan_amount) as MTD_total_loan_amount,
        SUM(total_payment) as MTD_total_amount_received
from bank_loan_data
where MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data)
and YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data)
GROUP BY loan_status

-- grid view for PMTD
select loan_status,
        SUM(loan_amount) as PMTD_total_loan_amount,
        SUM(total_payment) as PMTD_total_amount_received
from bank_loan_data
where MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data) -1
and YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data)
GROUP BY loan_status


-- grid view for monhly trend / monthly trend by issue date
select MONTH(issue_date),
        DATENAME(MONTH,issue_date),
        COUNT(id) as total_loan_applications,
        SUM(loan_amount) as total_loan_amount,
        SUM(total_payment) as total_amount_received
from bank_loan_data
GROUP BY MONTH(issue_date),DATENAME(MONTH,issue_date)
ORDER BY MONTH(issue_date)

-- regional analysis by state
select address_state,
        COUNT(id) as total_loan_applications,
        SUM(loan_amount) as total_loan_amount,
        SUM(total_payment) as total_amount_received
from bank_loan_data
GROUP BY address_state
ORDER BY SUM(loan_amount) desc

--loan term analysis
select term,
        COUNT(id) as total_loan_applications,
        SUM(loan_amount) as total_loan_amount,
        SUM(total_payment) as total_amount_received
from bank_loan_data
GROUP BY term
ORDER BY term

-- employee length analysis
select emp_length,
        COUNT(id) as total_loan_applications,
        SUM(loan_amount) as total_loan_amount,
        SUM(total_payment) as total_amount_received
from bank_loan_data
GROUP BY emp_length
ORDER BY COUNT(id) DESC

-- loan purpose breakdown
select purpose,
        COUNT(id) as total_loan_applications,
        SUM(loan_amount) as total_loan_amount,
        SUM(total_payment) as total_amount_received
from bank_loan_data
GROUP BY purpose
ORDER BY COUNT(id) DESC 


-- Home owner analysis
select home_ownership,
        COUNT(id) as total_loan_applications,
        SUM(loan_amount) as total_loan_amount,
        SUM(total_payment) as total_amount_received
from bank_loan_data
GROUP BY home_ownership
ORDER BY COUNT(id) DESC 