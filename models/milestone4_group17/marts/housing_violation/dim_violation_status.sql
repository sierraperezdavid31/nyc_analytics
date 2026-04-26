-- Violation Status Dimension - Each row represents a violation status

WITH violation_status AS (
    SELECT
        current_status_id,
        current_status,
        violation_status
        -- is_close_flag
        -- violation_status has only two unique values
        -- closed and open. adding is_close_flag seems redundant
    FROM {{ref('stg_nyc_open_housing_violations')}}
    GROUP BY
        current_status_id,
        current_status,
        violation_status
)