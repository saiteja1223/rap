CLASS z_generate_booking_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z_generate_booking_data IMPLEMENTATION.
METHOD if_oo_adt_classrun~main.

    " -----------------------------------------------------------------
    " 1. CLEANUP: Clear old data to avoid duplicates
    " -----------------------------------------------------------------
    DELETE FROM zsai_bsupply_m.
    DELETE FROM zsai_booking_m.

    out->write( 'Existing data deleted.' ).

    " -----------------------------------------------------------------
    " 2. INSERT BOOKINGS (zsai_booking_m)
    " We copy from the standard demo table /dmo/booking_m
    " -----------------------------------------------------------------
    INSERT zsai_booking_m FROM (
        SELECT FROM /dmo/booking_m
        FIELDS
            travel_id,
            booking_id,
            booking_date,
            customer_id,
            carrier_id,
            connection_id,
            flight_date,
            flight_price,
            currency_code,
            booking_status,
            last_changed_at
    ).

    out->write( |Booking Data Inserted: { sy-dbcnt } rows.| ).

    " -----------------------------------------------------------------
    " 3. INSERT SUPPLEMENTS (zsai_bsupply_m)
    " We copy from the standard demo table /dmo/booksuppl_m
    " -----------------------------------------------------------------
    INSERT zsai_bsupply_m FROM (
        SELECT FROM /dmo/booksuppl_m
        FIELDS
            travel_id,
            booking_id,
            booking_supplement_id,
            supplement_id,
            price,
            currency_code,
            last_changed_at
    ).

    out->write( |Supplement Data Inserted: { sy-dbcnt } rows.| ).

  ENDMETHOD.
ENDCLASS.
