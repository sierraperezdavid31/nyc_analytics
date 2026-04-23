-- housing violation dimension: One row per building location

WITH building_location AS (
SELECT
    -- bin, this field seems to be empty
    building_id,
    house_number,
    street_name,
    zip, 
    borough,
    MAX(low_house_number) as low_house_number,
    MIN(high_house_number) as high_house_number,
    MAX(street_code)
    --apartment,
    --story

FROM {{ref('stg_nyc_open_housing_violations')}}
GROUP BY 
    building_id,
    house_number,
    street_name,
    zip, 
    borough,
    --low_house_number,
    --high_house_number,
    --street_code
    --apartment,
    --story
),

dim_building_location AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key([
            'food_service_establishment',
            'business_address'
        ]) }} AS restaurant_key,

        restaurant_name,
        legal_business_name,
        doing_business_as_dba,
        business_address,
        latitude,
        longitude,
        food_service_establishment

    FROM restaurants
)

SELECT * FROM restaurant_dimension
