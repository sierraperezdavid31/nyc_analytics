-- violation type dimesion

WITH violation_type_table AS (
    
    SELECT
        -- Adding a new column that was not in the dimension table
        violation_id,-- column that was not in the original dimension
        order_number,
        violation_class,
        rent_impairing,
        nov_type,
        nov_description

    FROM {{ref('stg_nyc_open_housing_violations')}}
    GROUP BY 
        violation_id,
        order_number,
        violation_class,
        rent_impairing,
        nov_type,
        nov_description
),

violation_type_dimension AS (
    SELECT
        {{
            dbt_utils.generate_surrogate_key([
            'violation_id',
            'order_number',
            'violation_class',
            'rent_impairing',
            'nov_type',
            'nov_description'
            ])
        }} AS violation_type_key,
        
        violation_id,
        order_number,
        violation_class,
        rent_impairing,
        nov_type,
        nov_description

    FROM violation_type_table
)

SELECT * FROM violation_type_dimension
