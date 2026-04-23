-- housing violation dimension: One row per building location
SELECT
    -- bin, this field seems to be empty
    building_id,
    house_number,
    low_house_number,
    high_house_number,
    street_name,
    zip, 
    borough

FROM {{ref('stg_nyc_open_housing_violations')}}
GROUP BY 
    building_id,
    house_number,
    low_house_number,
    high_house_number,
    street_name,
    zip, 
    borough

