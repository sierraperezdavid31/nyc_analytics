-- Test model for milestone 4
SELECT
    unique_key,
    created_date,
    complaint_type,
    borough
FROM {{ source('raw', '311_hpd_service_requests_history') }}
LIMIT 10