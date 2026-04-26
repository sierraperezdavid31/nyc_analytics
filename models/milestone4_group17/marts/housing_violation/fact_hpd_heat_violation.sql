-- Grain: one row per violation

-- --Pattern for fact table model:
-- --   WITH
-- --     [fact_source] AS (SELECT * FROM staging),
-- --     [dim1] AS (SELECT surrogate_key, join_keys FROM dim1),
-- --     [dim2] AS (SELECT surrogate_key, join_keys FROM dim2),
-- --     ...
-- --     final AS (
-- --       SELECT
-- --         [fact fields from staging data, maybe renamed with AS ___],
-- --         [dim1 surrogate key] as dim1_key_or_whatever_name,
-- --         [dim2 surrogate key] as dim2_key_or_whatever_name, ...
-- --       FROM [fact_source]
-- --       LEFT JOIN [dim1] ON ... (join fields match)
-- --       LEFT JOIN [dim2] ON ... (join fields match)
-- --     )
-- --   SELECT * FROM final

-- Getting all the data from the staging nyc_open_housing_violation
WITH violation_table AS (
    SELECT * FROM {{ref('stg_nyc_open_housing_violations')}}
),

-- Getting all the dimensions that was created
-- Starting with the date dimension
dim_date AS (
    SELECT date_key, full_date FROM {{ref('dim_date_m4')}}
),

-- Location dimension
dim_location AS (
    SELECT location_key, borough, zipcode, community_board, council_district
    FROM {{ref("dim_location_m4")}}
),

-- Building Location dimension
dim_building_location AS (
    SELECT building_key, building_id, house_number, street_name, zip, borough, low_house_number, high_house_number,
    street_code
    FROM {{ref("dim_building_location")}}
),

-- Violation Status dimension
dim_violation_status AS (
    SELECT violation_status_key, current_status_id, current_status, violation_status
    FROM {{ref("dim_violation_status")}}
),

-- Violation Type dimension
dim_violation_type AS (
    SELECT violation_type_key, order_number, violation_class, rent_impairing, nov_type, nov_description
    FROM {{ref("dim_violation_type")}}
),

-- Creating final Fact TABLE

final AS (
    SELECT
        -- Creating a surrogatew key for the FACT Table
        {{dbt_utils.generate_surrogate_key(['v.violation_id'])}} AS violation_key,

    FROM violation_table v

    -- Left Join with date table
    LEFT JOIN dim_date
)