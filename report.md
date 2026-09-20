# Driver Quality & Service Performance Analytics

## Executive Summary

This project evaluates ride-booking outcomes and service-performance patterns for a ride-hailing platform. The analysis focuses on completion rates, cancellations, incomplete rides, pickup locations, vehicle arrival time, vehicle types, time periods, and customer and driver ratings.

The dataset contains 150,000 bookings. Only 62.0% resulted in completed rides, while 38.0% were cancelled, incomplete, or had no driver found. Pickup location showed the clearest operational variation, while vehicle type and time of day showed relatively small differences.

## Data and Methodology

The analysis uses the publicly available Uber India ride-bookings dataset from Kaggle:

https://www.kaggle.com/datasets/anilrohan/uber-data-india?resource=download

The notebook performs data validation, exploratory analysis, and feature engineering. Date and time fields were converted for temporal analysis. Missing values were retained when they were structurally related to booking status, such as ratings being unavailable for non-completed rides.

The following features were created:

- Month, day of week, hour, time period, and weekend indicator.
- Completion, driver-cancellation, customer-cancellation, and incomplete-ride indicators.
- Driver-rating, VTAT, CTAT, and distance bands.

The prepared data was loaded into PostgreSQL in the `driver_quality` database and analyzed using SQL. Power BI can connect to the `uber_data_cleaned` table for dashboard development.

## Key Performance Metrics

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

## Key Findings

### Booking Outcomes

Driver cancellation was the largest individual non-completion category, accounting for 18.0% of all bookings. The results indicate a significant service-performance gap because more than one-third of bookings did not become completed rides.

### Pickup Location

Pickup location showed the largest operational variation. Non-completion rates ranged from:

- **45.32%** at Vinobapuri
- **43.86%** at Akshardham
- **33.73%** at Welcome

The difference between the highest and lowest observed locations was approximately 11.6 percentage points. These locations should be treated as priority areas for operational investigation.

### Driver Cancellations

Driver cancellation reasons were relatively evenly distributed:

| Reason | Share of driver cancellations |
| --- | ---: |
| Customer related issue | 25.32% |
| Customer coughing or sick | 25.00% |
| Personal or car-related issues | 24.91% |
| More than permitted passengers | 24.76% |

No single reason dominated the driver-cancellation data.

### Vehicle Arrival Time

Customer cancellation increased across the VTAT bands:

| VTAT band | Customer cancellation rate |
| --- | ---: |
| Fast | 0.11% |
| Moderate | 5.86% |
| Slow | 7.68% |
| Very Slow | 100.00% |

The Very Slow result is unusually deterministic and should be interpreted as an observed pattern in this dataset, not proof of causation.

### Vehicle Type and Time Period

Vehicle-type completion rates ranged from 61.44% to 62.55%, showing limited variation. Completion rates across broad time periods ranged from 61.73% to 62.44%. These fields are therefore most useful as dashboard filters and monitoring dimensions rather than primary explanations of performance.

### Ratings

Among completed rides:

- Average driver rating: **4.23**
- Average customer rating: **4.40**
- Driver-customer rating correlation: **-0.001**

The near-zero correlation indicates that driver and customer ratings should be monitored as separate service-quality measures.

## Business Recommendations

1. Prioritize high non-completion locations, beginning with Vinobapuri and Akshardham.
2. Monitor driver cancellations by location and cancellation reason rather than focusing on one reason alone.
3. Track VTAT and customer cancellation together to identify service areas with long expected wait times.
4. Use vehicle type and time period as dashboard filters for operational monitoring.
5. Track driver and customer ratings separately for completed rides.
6. Use additional operational data to investigate the causes behind location-level differences.

## Power BI Dashboard Scope

The dashboard should include:

- Booking outcome and completion KPIs.
- Cancellation and incomplete-ride breakdowns.
- Pickup-location performance ranking or map.
- VTAT band versus customer cancellation.
- Driver-cancellation reasons.
- Vehicle-type and time-period comparisons.
- Driver and customer rating KPIs.

The business questions and final visual interpretations belong in the report and dashboard, while the notebook documents the technical preparation and SQL analysis.

## Limitations

- The dataset does not contain a unique driver identifier, so individual driver performance cannot be evaluated.
- Many missing values are structurally related to booking status and should not be treated as random missing data.
- Some category distributions and relationships appear highly structured or synthetic.
- The analysis identifies associations, not causal relationships.
- The findings should be validated with additional operational data before business decisions are made.

## Conclusion

The main opportunity identified is improving booking completion, particularly in pickup locations with high non-completion rates. Driver cancellations are the largest individual source of non-completion, while VTAT is strongly associated with customer cancellation in the dataset. Vehicle type and time of day show comparatively limited variation.

The proposed PostgreSQL and Power BI workflow provides an operational view for monitoring these patterns and prioritizing further investigation.