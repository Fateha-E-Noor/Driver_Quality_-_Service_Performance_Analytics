-- ============================================================
-- Q1. What is the overall health of the booking operation?
-- ============================================================

-- Q1.1 Booking outcome distribution

SELECT
    "Booking Status",
    COUNT(*) AS total_bookings,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM uber_data_cleaned
GROUP BY "Booking Status"
ORDER BY total_bookings DESC;


-- Q1.2 Overall completion vs non-completion

SELECT
    COUNT(*) AS total_bookings,
    SUM("Is_Completed") AS completed_bookings,
    COUNT(*) - SUM("Is_Completed") AS non_completed_bookings,
    ROUND(
        SUM("Is_Completed") * 100.0 / COUNT(*),
        2
    ) AS completion_rate,
    ROUND(
        (COUNT(*) - SUM("Is_Completed")) * 100.0 / COUNT(*),
        2
    ) AS non_completion_rate
FROM uber_data_cleaned;


-- ============================================================
-- Q2. Where are service performance issues more prevalent?
-- ============================================================

-- Q2.1 Operational performance by pickup location

SELECT
    "Pickup Location",
    COUNT(*) AS total_bookings,

    ROUND(
        AVG("Is_Driver_Cancelled") * 100,
        2
    ) AS driver_cancellation_rate,

    ROUND(
        AVG("Is_Customer_Cancelled") * 100,
        2
    ) AS customer_cancellation_rate,

    ROUND(
        AVG("Is_Incomplete") * 100,
        2
    ) AS incomplete_rate,

    ROUND(
        (1 - AVG("Is_Completed")) * 100,
        2
    ) AS non_completion_rate

FROM uber_data_cleaned
GROUP BY "Pickup Location"
ORDER BY non_completion_rate DESC;


-- ============================================================
-- Q3. What is driving driver cancellations?
-- ============================================================

-- Q3.1 Overall driver cancellation reasons

SELECT
    "Driver Cancellation Reason",
    COUNT(*) AS cancellation_count,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM uber_data_cleaned
WHERE "Booking Status" = 'Cancelled by Driver'
GROUP BY "Driver Cancellation Reason"
ORDER BY cancellation_count DESC;


-- Q3.2 Driver cancellation rate by pickup location

SELECT
    "Pickup Location",
    COUNT(*) AS total_bookings,
    SUM("Is_Driver_Cancelled") AS driver_cancellations,
    ROUND(
        AVG("Is_Driver_Cancelled") * 100,
        2
    ) AS driver_cancellation_rate
FROM uber_data_cleaned
GROUP BY "Pickup Location"
ORDER BY driver_cancellation_rate DESC;


-- ============================================================
-- Q4. Is pickup/service time associated with customer cancellations?
-- ============================================================

-- Q4.1 Customer cancellation rate by VTAT band

SELECT
    "VTAT_Band",
    COUNT(*) AS total_bookings,
    SUM("Is_Customer_Cancelled") AS customer_cancellations,
    ROUND(
        AVG("Is_Customer_Cancelled") * 100,
        2
    ) AS customer_cancellation_rate
FROM uber_data_cleaned
WHERE "VTAT_Band" IS NOT NULL
GROUP BY "VTAT_Band"
ORDER BY
    CASE "VTAT_Band"
        WHEN 'Fast' THEN 1
        WHEN 'Moderate' THEN 2
        WHEN 'Slow' THEN 3
        WHEN 'Very Slow' THEN 4
    END;


-- ============================================================
-- Q5. Are there meaningful differences between vehicle types?
-- ============================================================

-- Q5.1 Vehicle type operational performance

SELECT
    "Vehicle Type",
    COUNT(*) AS total_bookings,

    ROUND(
        AVG("Is_Completed") * 100,
        2
    ) AS completion_rate,

    ROUND(
        AVG("Is_Driver_Cancelled") * 100,
        2
    ) AS driver_cancellation_rate,

    ROUND(
        AVG("Is_Customer_Cancelled") * 100,
        2
    ) AS customer_cancellation_rate,

    ROUND(
        AVG("Is_Incomplete") * 100,
        2
    ) AS incomplete_rate,

    ROUND(
        AVG("Avg VTAT")::numeric,
        2
    ) AS avg_vtat

FROM uber_data_cleaned
GROUP BY "Vehicle Type"
ORDER BY completion_rate ASC;


-- ============================================================
-- Q6. Are there meaningful time-based operational patterns?
-- ============================================================

-- Q6.1 Performance by time period

SELECT
    "Time_Period",
    COUNT(*) AS total_bookings,

    ROUND(
        AVG("Is_Completed") * 100,
        2
    ) AS completion_rate,

    ROUND(
        AVG("Is_Driver_Cancelled") * 100,
        2
    ) AS driver_cancellation_rate,

    ROUND(
        AVG("Is_Customer_Cancelled") * 100,
        2
    ) AS customer_cancellation_rate,

    ROUND(
        AVG("Is_Incomplete") * 100,
        2
    ) AS incomplete_rate

FROM uber_data_cleaned
GROUP BY "Time_Period"
ORDER BY
    CASE "Time_Period"
        WHEN 'Night' THEN 1
        WHEN 'Morning' THEN 2
        WHEN 'Afternoon' THEN 3
        WHEN 'Evening' THEN 4
        WHEN 'Late Night' THEN 5
    END;


-- Q6.2 Hourly operational performance

SELECT
    "Hour",
    COUNT(*) AS total_bookings,

    ROUND(
        AVG("Is_Completed") * 100,
        2
    ) AS completion_rate,

    ROUND(
        AVG("Is_Driver_Cancelled") * 100,
        2
    ) AS driver_cancellation_rate,

    ROUND(
        AVG("Is_Customer_Cancelled") * 100,
        2
    ) AS customer_cancellation_rate

FROM uber_data_cleaned
GROUP BY "Hour"
ORDER BY "Hour";


-- ============================================================
-- Q7. What does service quality look like from customer and driver ratings?
-- ============================================================

-- Q7.1 Overall rating profile

SELECT
    COUNT(*) AS completed_rides_with_ratings,
    ROUND(AVG("Driver Ratings")::numeric, 2) AS avg_driver_rating,
    ROUND(AVG("Customer Rating")::numeric, 2) AS avg_customer_rating,
    ROUND(MIN("Driver Ratings")::numeric, 2) AS min_driver_rating,
    ROUND(MAX("Driver Ratings")::numeric, 2) AS max_driver_rating,
    ROUND(MIN("Customer Rating")::numeric, 2) AS min_customer_rating,
    ROUND(MAX("Customer Rating")::numeric, 2) AS max_customer_rating
FROM uber_data_cleaned
WHERE "Booking Status" = 'Completed';


-- Q7.2 Relationship between driver and customer ratings

SELECT
    ROUND(
        CORR(
            "Driver Ratings",
            "Customer Rating"
        )::numeric,
        3
    ) AS driver_customer_rating_correlation
FROM uber_data_cleaned
WHERE "Booking Status" = 'Completed';


-- ============================================================
-- Q8. Where should operations focus attention?
-- ============================================================

-- Q8.1 Combined location performance

SELECT
    "Pickup Location",
    COUNT(*) AS total_bookings,

    ROUND(
        (1 - AVG("Is_Completed")) * 100,
        2
    ) AS non_completion_rate,

    ROUND(
        AVG("Is_Driver_Cancelled") * 100,
        2
    ) AS driver_cancellation_rate,

    ROUND(
        AVG("Is_Customer_Cancelled") * 100,
        2
    ) AS customer_cancellation_rate,

    ROUND(
        AVG("Is_Incomplete") * 100,
        2
    ) AS incomplete_rate

FROM uber_data_cleaned
GROUP BY "Pickup Location"
ORDER BY non_completion_rate DESC;