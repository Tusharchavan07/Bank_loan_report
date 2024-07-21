use  bank_loan;

SELECT * FROM loan_data;

SELECT issue_date
FROM loan_data;

ALTER TABLE loan_data ADD CONSTRAINT id PRIMARY KEY (id);

-- converting date into correct format
UPDATE loan_data
SET issue_date = STR_TO_DATE(issue_date, '%d-%m-%Y'),
last_credit_pull_date = STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y'),
last_payment_date = STR_TO_DATE(last_payment_date, '%d-%m-%Y'),
next_payment_date = STR_TO_DATE(next_payment_date, '%d-%m-%Y')
WHERE issue_date IS NOT NULL OR
last_credit_pull_date IS NOT NULL OR
last_payment_date IS NOT NULL OR
next_payment_date IS NOT NULL;

ALTER TABLE loan_data MODIFY issue_date DATE;
ALTER TABLE loan_data MODIFY last_credit_pull_date DATE;
ALTER TABLE loan_data MODIFY last_payment_date DATE;
ALTER TABLE loan_data MODIFY next_payment_date DATE;

-- Checking constraints
DESCRIBE loan_data;

-- checking total number of applications received
SELECT COUNT(id) AS total_loan_applications
FROM loan_data;

-- number of applications received on current month (Since we are working on 2021 data year is fixed)
SELECT COUNT(id) AS MTD_Total_loan_applications FROM loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Total number of payment received for current month
SELECT SUM(total_payment) AS MTD_Total_amount_of_payment_received FROM loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Average interset for the current year(Multiplying it with 100 to convert it to percentage)
SELECT ROUND(AVG(int_rate)*100,2) AS Avg_interest_rate FROM loan_data;

SELECT ROUND(AVG(int_rate)*100,2) AS MTD_Avg_interest_rate FROM loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;




-- working on loan status for "Good loans" and "Bad loans"
-- Good Loans

SELECT 
COUNT(CASE WHEN loan_status='Fully Paid' OR loan_status='Current' THEN id END) * 100
/
COUNT(id) AS Good_loan_percentage
FROM loan_data;

SELECT COUNT(id) AS Good_loan_applications FROM loan_data 
WHERE loan_status='Fully Paid' OR loan_status='Current';

SELECT SUM(loan_amount) AS Good_loan_funded_amount FROM loan_data 
WHERE loan_status='Fully Paid' OR loan_status='Current';

SELECT SUM(total_payment) AS Good_loan_total_payment FROM loan_data 
WHERE loan_status='Fully Paid' OR loan_status='Current';




-- Bad loans

SELECT 
COUNT(CASE WHEN loan_status='Charged Off' THEN id END) * 100
/
COUNT(id) AS Bad_loan_percentage
FROM loan_data;

SELECT COUNT(id) AS Bad_loan_applications FROM loan_data 
WHERE loan_status='Charged Off';

SELECT SUM(loan_amount) AS Bad_loan_funded_amount FROM loan_data 
WHERE loan_status='Charged Off';

SELECT SUM(total_payment) AS Bad_loan_total_payment FROM loan_data 
WHERE loan_status='Charged Off';


-- Bank performance 
SELECT 
	loan_status,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received,
	AVG(int_rate *100) AS Interest_Rate,
	AVG(dti *100) AS DTI
FROM loan_data
GROUP BY loan_status;


SELECT 
	MONTH(issue_date) AS Month_Number,
    DATE_FORMAT(issue_date, '%M') AS Month_Name, 
  	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loan_data
GROUP BY MONTH(issue_date), DATE_FORMAT(issue_date, '%M')
ORDER BY MONTH(issue_date);
    


SELECT 
	term,
  	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loan_data
GROUP BY term
ORDER BY term DESC;


-- Employment length
SELECT 
	emp_length,
  	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loan_data
GROUP BY emp_length
ORDER BY emp_length;


SELECT 
	purpose,
  	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loan_data
GROUP BY purpose
ORDER BY COUNT(id) DESC;

SELECT 
	home_ownership,
  	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loan_data
GROUP BY home_ownership
ORDER BY COUNT(id) DESC;


