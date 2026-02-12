CLASS z_generate_travel_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z_generate_travel_data IMPLEMENTATION.
METHOD if_oo_adt_classrun~main.

    " 1. Delete existing data to avoid duplicates
    DELETE FROM zsai_travel_m.

    " 2. Insert dummy data (Change table name if needed)
    INSERT zsai_travel_m FROM (
        SELECT FROM /dmo/travel
        FIELDS
            travel_id,
            agency_id,
            customer_id,
            begin_date,
            end_date,
            booking_fee,
            total_price,
            currency_code,
            description,
            status AS overall_status,
            createdby AS created_by,
            createdat AS created_at,
            lastchangedby AS last_changed_by,
            lastchangedat AS last_changed_at
    ).

    " 3. Print a success message to the console
    out->write( 'Data inserted successfully! Check your table now.' ).

  ENDMETHOD.
ENDCLASS.
