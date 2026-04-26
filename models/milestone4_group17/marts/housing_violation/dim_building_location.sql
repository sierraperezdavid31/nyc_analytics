-- housing violation dimension: One row per building location

WITH building_location AS (
SELECT
    -- bin, this field seems to be empty
    building_id,
    house_number,
    street_name,
    zip, 
    borough,
    low_house_number,
    high_house_number,
    street_code
    --apartment,
    --story

FROM {{ref('stg_nyc_open_housing_violations')}}
GROUP BY 
    building_id,
    house_number,
    street_name,
    zip, 
    borough,
    low_house_number,
    high_house_number,
    street_code
    --apartment,
    --story
),

building_location_dimension AS (
    SELECT
    {{  dbt_utils.generate_surrogate_key(
        [
        'building_id',
        'house_number',
        'street_name',
        'zip', 
        'borough',
        'low_house_number',
        'high_house_number',
        'street_code' 
        ]
    )

    }} as building_key,
    building_id,
    house_number,
    street_name,
    zip, 
    borough,
    low_house_number,
    high_house_number,
    street_code

    FROM building_location
)

SELECT * FROM building_location_dimension