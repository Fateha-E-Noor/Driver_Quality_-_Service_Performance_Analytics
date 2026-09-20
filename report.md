# Driver Quality & Service Performance Analytics

## 1. Executive Summary

This project analyzes ride-booking and service-performance data to identify operational issues affecting successful ride completion and customer experience. The analysis focuses on booking outcomes, driver and customer cancellations, incomplete rides, pickup locations, arrival times, vehicle types, time periods, and ratings.

The dataset contains 150,000 bookings. The overall completion rate is 62.0%, meaning that 38.0% of bookings did not result in a completed ride. Pickup location shows the clearest variation in performance, while vehicle type and time of day show relatively small differences.

## 2. Data Source

The original dataset was obtained from Kaggle:

https://www.kaggle.com/datasets/anilrohan/uber-data-india?resource=download

The raw and derived CSV files are kept locally and are not included in the repository. The notebook recreates the prepared dataset from the original Kaggle file.

## 3. Data Preparation

### Data Cleaning and Validation

The notebook performs the following checks before analysis:

- Converts `Date` and `Time` into usable datetime fields.
- Reviews missing values by booking status.
- Checks row duplicates and repeated Booking IDs.
- Validates booking statuses, cancellation reasons, and incomplete-ride reasons.
- Checks numerical fields and rating ranges.

Missing values were retained when they were structurally not applicable. For example, ratings are generally available for completed rides, while cancellation reasons apply only to the relevant cancellation status. No artificial values were imputed into these fields.

### Feature Engineering

The prepared dataset contains the original booking fields plus operational features used for SQL analysis and Power BI reporting:

- Temporal features: `Month`, `Day_of_Week`, `Hour`, `Time_Period`, and `Is_Weekend`.
- Outcome indicators: `Is_Completed`, `Is_Driver_Cancelled`, `Is_Customer_Cancelled`, and `Is_Incomplete`.
- Segmentation fields: `Driver_Rating_Band`, `VTAT_Band`, `CTAT_Band`, and `Distance_Band`.

## 4. Exploratory Data Analysis

EDA was used to understand booking outcomes, cancellations, locations, time patterns, ratings, service times, and booking values. The main descriptive results were then loaded into PostgreSQL for repeatable SQL analysis.

| Metric | Result |
| --- | ---: |
| Total bookings | 150,000 |
| Completed rides | 93,000 |
| Completion rate | 62.0% |
| Non-completion rate | 38.0% |
| Driver cancellations | 27,000 |
| Customer cancellations | 10,500 |
| Incomplete rides | 9,000 |
| No driver found | 10,500 |
| Pickup locations | 176 |

## 5. PostgreSQL and SQL Analysis

The feature-engineered data was loaded into PostgreSQL database `driver_quality` in the table `uber_data_cleaned`. SQL queries were used to calculate booking outcome distributions, cancellation rates, location rankings, VTAT patterns, vehicle-type performance, time-based performance, ratings, and operational focus areas.

This database layer provides a consistent source for the Power BI dashboard and allows the business questions to be answered using repeatable queries rather than manual calculations.

## 6. Business Questions and Answers

### Q1. What is the overall health of the booking operation?

**Answer:** 93,000 of 150,000 bookings were completed, giving a 62.0% completion rate. The remaining 38.0% were cancelled, incomplete, or had no driver found. Driver cancellations were the largest individual non-completion category at 18.0%.

### Q2. Where are service-performance issues more prevalent?

**Answer:** Pickup locations show meaningful differences. Vinobapuri had the highest observed non-completion rate at 45.32%, followed by Akshardham at 43.86%. Welcome had the lowest observed rate at 33.73%. This is a difference of approximately 11.6 percentage points.

### Q3. What is driving driver cancellations?

**Answer:** No single driver-cancellation reason dominates. Customer-related issues represented 25.32%, coughing or sickness 25.00%, personal or car-related issues 24.91%, and more than permitted passengers 24.76% of driver cancellations.

### Q4. Is pickup or service time associated with customer cancellations?

**Answer:** Customer cancellation rates increase across the VTAT bands: Fast 0.11%, Moderate 5.86%, Slow 7.68%, and Very Slow 100.00%. The Very Slow result is unusually deterministic, so it should be treated as an observed association in this dataset rather than proof of causation.

### Q5. Are there meaningful differences between vehicle types?

**Answer:** Vehicle-type performance is relatively consistent. Completion rates range from 61.44% to 62.55%, and average VTAT ranges from 8.40 to 8.58. Vehicle type is therefore more useful as a dashboard filter than as a major explanation of performance differences.

### Q6. Are there meaningful time-based operational patterns?

**Answer:** Broad time-period performance is stable. Completion rates range from 61.73% to 62.44%, while hourly completion rates range from approximately 60.88% to 63.70%. Time-based analysis is useful for monitoring, but it does not show a major operational difference in this dataset.

### Q7. What does service quality look like from ratings?

**Answer:** Among completed rides, the average driver rating is 4.23 and the average customer rating is 4.40. The driver-customer rating correlation is -0.001, indicating essentially no linear relationship. The two ratings should therefore be monitored separately.

### Q8. Where should operations focus attention?

**Answer:** Operations should begin with pickup locations that combine high non-completion and cancellation rates, particularly Vinobapuri and Akshardham. These should be treated as priority areas for further investigation into driver availability, pickup conditions, and customer behaviour.

## 7. Power BI Dashboard Design

The Power BI dashboard should present the SQL results through a small set of operational views:

- KPI cards for total bookings, completion rate, non-completion rate, and cancellations.
- Booking outcome distribution by status.
- Pickup-location ranking for completion and non-completion rates.
- Driver-cancellation reasons and location comparison.
- VTAT band versus customer cancellation rate.
- Vehicle-type and time-period comparisons.
- Driver and customer rating indicators.

Recommended slicers include date, pickup location, vehicle type, booking status, VTAT band, and time period. The dashboard should help users identify where performance is weakest and compare those segments with the overall baseline.

## 8. Recommendations

1. Prioritize high non-completion pickup locations for operational investigation.
2. Monitor driver cancellations by both location and reason.
3. Track VTAT alongside customer cancellations to identify long-wait service segments.
4. Use vehicle type and time period as monitoring and filtering dimensions.
5. Track driver and customer ratings as separate service-quality measures.
6. Add driver-level, supply, weather, traffic, and pickup-condition data in future analysis to investigate causes more directly.

## 9. Limitations

- The dataset has no unique driver identifier, so individual driver performance cannot be measured.
- Many missing values are structurally related to booking status rather than random missing data.
- Some distributions and relationships appear highly structured or synthetic.
- The analysis identifies associations, not causal relationships.
- Findings should be validated with additional operational data before business decisions are made.

## 10. Conclusion

The analysis identifies booking non-completion as the main performance issue. Driver cancellations are the largest individual contributor, and pickup location shows the strongest operational variation. VTAT is strongly associated with customer cancellation, while vehicle type and time of day show limited differences.

The combined EDA, feature-engineering, PostgreSQL, SQL, and Power BI workflow provides a practical structure for monitoring ride-service performance and prioritizing operational improvement.