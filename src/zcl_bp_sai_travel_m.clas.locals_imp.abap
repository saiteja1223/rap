CLASS lsc_zi_sai_travel_m DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_sai_travel_m IMPLEMENTATION.

  METHOD save_modified.
    DATA : lt_travel_log TYPE STANDARD TABLE OF zlog_sa_Travel_m.
    DATA : lt_travel_log_u TYPE STANDARD TABLE OF zlog_sa_Travel_m.
    DATA : lt_travel_log_c TYPE STANDARD TABLE OF zlog_sa_Travel_m.
    IF create-zi_sai_travel_m IS NOT INITIAL.
      lt_travel_log = CORRESPONDING #( create-zi_sai_travel_m ).
      LOOP AT lt_travel_log ASSIGNING FIELD-SYMBOL(<ls_travel_log>).
        <ls_travel_log>-changing_operation = 'CREATE'.
        GET TIME STAMP FIELD <ls_travel_log>-created_at.
        READ TABLE  create-zi_sai_travel_m  ASSIGNING FIELD-SYMBOL(<ls_travel>)
                                             WITH TABLE KEY entity
                                             COMPONENTS TravelId = <ls_travel_log>-travelid.

        IF sy-subrc IS INITIAL.
          IF <ls_travel>-%control-BookingFee = cl_abap_behv=>flag_changed.
            <ls_travel_log>-changed_field_name = 'Booking Fee'.
            <ls_travel_log>-changed_value = <ls_travel>-BookingFee.
            TRY.
                <ls_travel_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.

            APPEND <ls_travel_log> TO lt_travel_log_c.
          ENDIF.
          IF <ls_travel>-%control-OverallStatus = cl_abap_behv=>flag_changed.
            <ls_travel_log>-changed_field_name = 'Overall Status'.
            <ls_travel_log>-changed_value = <ls_travel>-OverallStatus.
            TRY.
                <ls_travel_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.

            APPEND <ls_travel_log> TO lt_travel_log_c.
          ENDIF.

        ENDIF.
      ENDLOOP.
      INSERT zlog_sa_Travel_m FROM TABLE @lt_travel_log_c.

    ENDIF.
    IF update-zi_sai_travel_m IS NOT INITIAL.
      lt_travel_log = CORRESPONDING #( update-zi_sai_travel_m ).

      LOOP AT update-zi_sai_travel_m ASSIGNING FIELD-SYMBOL(<ls_log_update>).
        ASSIGN lt_travel_log[ travelid = <ls_log_update>-travelid ] TO FIELD-SYMBOL(<ls_log_u>).

        <ls_log_u>-changing_operation = 'UPDATE'.
        GET TIME STAMP FIELD <ls_log_u>-created_at.

        IF <ls_log_update>-%control-customerid = if_abap_behv=>mk-on.
          <ls_log_u>-changed_value = <ls_log_update>-customerid.
          TRY.
              <ls_log_u>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
            CATCH cx_uuid_error.
          ENDTRY.
          <ls_log_u>-changed_field_name = 'customer_id'.
          APPEND <ls_log_u> TO lt_travel_log_u.
        ENDIF.

        IF <ls_log_update>-%control-description = if_abap_behv=>mk-on.
          <ls_log_u>-changed_value = <ls_log_update>-description.
          TRY.
              <ls_log_u>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
            CATCH cx_uuid_error.
          ENDTRY.
          <ls_log_u>-changed_field_name = 'description'.
          APPEND <ls_log_u> TO lt_travel_log_u.
        ENDIF.
        IF <ls_log_update>-%control-description = if_abap_behv=>mk-on.
          <ls_log_u>-changed_value = <ls_log_update>-description.
          TRY.
              <ls_log_u>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
            CATCH cx_uuid_error.
          ENDTRY.
          <ls_log_u>-changed_field_name = 'description'.
          APPEND <ls_log_u> TO lt_travel_log_u.
        ENDIF.
      ENDLOOP.
      INSERT zlog_sa_travel_m FROM TABLE  @lt_travel_log_u.

    ENDIF.
    IF delete-zi_sai_travel_m IS NOT INITIAL.

      lt_travel_log = CORRESPONDING #( delete-zi_sai_travel_m ).
      LOOP AT lt_travel_log ASSIGNING FIELD-SYMBOL(<ls_log_del>).
        <ls_log_del>-changing_operation = 'DELETE'.
        GET TIME STAMP FIELD <ls_log_del>-created_at.
        TRY.
            <ls_log_del>-change_id = cl_system_uuid=>create_uuid_x16_static( ).

          CATCH cx_uuid_error.
            "handle exception
        ENDTRY.
      ENDLOOP.

      " Inserts rows specified in lt_travel_log into the DB table /dmo/log_trave
      INSERT zlog_sa_travel_m FROM TABLE @lt_travel_log.


    ENDIF.

*    ********************************************************
    DATA: lt_book_suppl TYPE STANDARD TABLE OF  zsai_bsupply_m.
    IF create-zi_sai_bsupply_m IS NOT INITIAL.
*      lt_book_suppl = CORRESPONDING #( create-zi_sai_bsupply_m ).
      lt_book_suppl = VALUE #( FOR ls_booksup IN create-zi_sai_bsupply_m (
      travel_id = ls_booksup-TravelId
      booking_id = ls_booksup-BookingId
      booking_supplement_id = ls_booksup-BookingSupplementId
      supplement_id = ls_booksup-SupplementId
      price = ls_booksup-Price
      currency_code = ls_booksup-CurrencyCode
      last_changed_at = ls_booksup-LastChangedAt
      ) ).
      INSERT zsai_bsupply_m FROM TABLE @lt_book_suppl.
    ENDIF.
    IF update-zi_sai_bsupply_m IS NOT INITIAL.
*      lt_book_suppl = CORRESPONDING #( update-zi_sai_bsupply_m ).

     lt_book_suppl = VALUE #( FOR ls_booksup IN update-zi_sai_bsupply_m (
      travel_id = ls_booksup-TravelId
      booking_id = ls_booksup-BookingId
      booking_supplement_id = ls_booksup-BookingSupplementId
      supplement_id = ls_booksup-SupplementId
      price = ls_booksup-Price
      currency_code = ls_booksup-CurrencyCode
      last_changed_at = ls_booksup-LastChangedAt
      ) ).

      UPDATE zsai_bsupply_m FROM TABLE @lt_book_suppl.


    ENDIF.
    IF delete-zi_sai_bsupply_m IS NOT INITIAL.
*      lt_book_suppl = CORRESPONDING #( delete-zi_sai_bsupply_m ).

       lt_book_suppl = VALUE #( FOR ls_del IN delete-zi_sai_bsupply_m (
      travel_id = ls_del-TravelId
      booking_id = ls_del-BookingId
      booking_supplement_id = ls_del-BookingSupplementId

      ) ).

      delete zsai_bsupply_m FROM TABLE @lt_book_suppl.
    ENDIF.


  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_SAI_Travel_m DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR ZI_SAI_Travel_m RESULT result.
    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION ZI_SAI_Travel_m~acceptTravel RESULT result.

    METHODS copyTravel FOR MODIFY
      IMPORTING keys FOR ACTION ZI_SAI_Travel_m~copyTravel.

    METHODS recalcToPrice FOR MODIFY
      IMPORTING keys FOR ACTION ZI_SAI_Travel_m~recalcToPrice.

    METHODS rejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION ZI_SAI_Travel_m~rejectTravel RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR ZI_SAI_Travel_m RESULT result.
    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_sai_travel_m~validatecustomer.
    METHODS validatebookingfee FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_sai_travel_m~validatebookingfee.

    METHODS validatecurrencycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_sai_travel_m~validatecurrencycode.

    METHODS validatedateson FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_sai_travel_m~validatedateson.

    METHODS validatestatuson FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_sai_travel_m~validatestatuson.
    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_sai_travel_m~calculatetotalprice.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE ZI_SAI_Travel_m.
    METHODS earlynumbering_cba_Booking FOR NUMBERING
      IMPORTING entities FOR CREATE  zi_sai_travel_m\_Booking.

ENDCLASS.

CLASS lhc_ZI_SAI_Travel_m IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA(lt_entities) = entities.
    DELETE lt_entities WHERE TravelId IS NOT INITIAL.
    TRY.
        cl_numberrange_runtime=>number_get(
           EXPORTING
           nr_range_nr = '01'
           object      = '/DMO/TRV_M'
           quantity    = CONV #( lines( lt_entities ) )
           IMPORTING
           number   =    DATA(lv_latest_num)
           returncode =   DATA(lv_code)
           returned_quantity = DATA(lv_qty)
        ).
      CATCH cx_number_ranges INTO DATA(lo_error).
        LOOP AT lt_entities INTO DATA(ls_entities).
          APPEND VALUE #( %cid = ls_entities-%cid
                   %key = ls_entities-%key )
                TO failed-zi_sai_travel_m.
          APPEND VALUE #( %cid = ls_entities-%cid
                        %key = ls_entities-%key
                         %msg = lo_error )
                 TO reported-zi_sai_travel_m.
        ENDLOOP.
        EXIT.
    ENDTRY.

    ASSERT lv_qty = lines( lt_entities ).
*       data:lt_sai_travel_m type table for mapped early zi_sai_travel_m,
*      ls_sai_travel_m  like line of lt_sai_travel_m.
    DATA(lv_curr_num) = lv_latest_num - lv_qty.
    LOOP AT lt_entities INTO ls_entities.
      lv_curr_num = lv_curr_num + 1.
*          ls_sai_travel_m = VALUE #( %cid = ls_entities-%cid
*                                     TravelId = lv_curr_num
*                                     ).
*             APPEND  ls_sai_travel_m to mapped-zi_sai_travel_m.
      APPEND VALUE #( %cid = ls_entities-%cid
                              TravelId = lv_curr_num ) TO mapped-zi_sai_travel_m.
    ENDLOOP.
  ENDMETHOD.
  METHOD earlynumbering_cba_Booking.

    DATA : lv_max_booking TYPE /dmo/booking_id.

    READ ENTITIES OF ZI_SAI_Travel_m IN LOCAL MODE
    ENTITY ZI_SAI_Travel_m BY \_Booking
    FROM CORRESPONDING #( entities )
    LINK DATA(lt_link_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<1s_group_entity>)
    GROUP BY <1s_group_entity>-TravelId.

      lv_max_booking = REDUCE #( INIT lv_max = CONV /dmo/booking_id( '0' )
                                 FOR ls_link IN lt_link_data USING KEY entity
                              WHERE ( source-TravelId = <1s_group_entity>-TravelId )
                               NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_link-target-BookingId
                                                                   THEN ls_link-target-BookingId
                                                                    ELSE lv_max ) ).
      lv_max_booking = REDUCE #( INIT lv_max = lv_max_booking
                      FOR ls_entity IN entities USING KEY entity
                          WHERE ( TravelId = <1s_group_entity>-TravelId )
                        FOR ls_booking IN ls_entity-%target
                          NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_booking-BookingId
                                                              THEN lS_BOOKING-BookingId
                                                               ELSE lv_max )
                                                               ).
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entities>)
                              USING KEY entity
                              WHERE TravelId = <1s_group_entity>-TravelId.
        LOOP AT <ls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_booking>).
          APPEND CORRESPONDING #( <ls_booking> ) TO mapped-zi_sai_booking_m
          ASSIGNING FIELD-SYMBOL(<ls_new_map_book>).
          IF <ls_booking>-BookingId IS INITIAL.
            lv_max_booking += 10.


            <ls_new_map_book>-BookingId = lv_max_booking.
          ENDIF.

        ENDLOOP.

      ENDLOOP.



    ENDLOOP.
  ENDMETHOD.

  METHOD acceptTravel.
    MODIFY ENTITIES OF zi_sai_travel_m IN LOCAL MODE
      ENTITY zi_sai_travel_m
       UPDATE FIELDS ( OverallStatus )
       WITH VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                            OverallStatus = 'A' ) )
       REPORTED DATA(lt_travel).

    READ ENTITIES OF zi_sai_travel_m IN LOCAL MODE
    ENTITY zi_sai_travel_m
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).
    result = VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky
                                                %param = ls_result ) ).
  ENDMETHOD.

  METHOD copyTravel.

    DATA: it_travel        TYPE TABLE FOR CREATE zi_sai_travel_m,
          it_booking_cba   TYPE TABLE FOR CREATE zi_sai_travel_m\_Booking,
          it_booksuppl_cba TYPE TABLE FOR CREATE zi_sai_booking_m\_Bookingsuppl.

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_without_cid>) WITH KEY %cid =' '.
    ASSERT <ls_without_cid> IS NOT ASSIGNED.

    READ ENTITIES OF zi_sai_travel_m IN LOCAL MODE
         ENTITY zi_sai_travel_m
             ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travel_r)
        FAILED DATA(lt_failed).

    READ ENTITIES OF zi_sai_travel_m IN LOCAL MODE
        ENTITY zi_sai_travel_m BY \_Booking
         ALL FIELDS WITH CORRESPONDING #( lt_travel_r )
         RESULT DATA(lt_booking_r).

    READ ENTITIES OF zi_sai_travel_m IN LOCAL MODE
         ENTITY zi_sai_booking_m BY \_Bookingsuppl
       ALL FIELDS WITH CORRESPONDING #( lt_booking_r )
         RESULT DATA(lt_booksupp_r).
    LOOP AT lt_travel_r  ASSIGNING FIELD-SYMBOL(<ls_travel_r>).
      APPEND INITIAL LINE TO it_travel  ASSIGNING FIELD-SYMBOL(<ls_travel>).
      <ls_travel>-%cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelId ]-%cid.
      <ls_travel>-%data = CORRESPONDING #( <ls_travel_r> EXCEPT travelId ).

*               APPEND VALUE #( %cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelId ]-%cid
*              %data = CORRESPONDING #( <ls_travel_r> EXCEPT TravelId ) )
*                   to it_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      <ls_travel>-BeginDate = cl_abap_context_info=>get_system_date( ).
      <ls_travel>-EndDate = cl_abap_context_info=>get_system_date( ) + 30.
      <ls_travel>-OverallStatus = 'O'.

      APPEND VALUE #( %cid_ref = <ls_travel>-%cid )
       TO it_booking_cba ASSIGNING FIELD-SYMBOL(<it_booking>).

      LOOP AT lt_booking_r ASSIGNING FIELD-SYMBOL(<ls_booking_r>)
                            USING KEY entity
                            WHERE TravelId = <ls_travel_r>-TravelId.
        APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId
             %data = CORRESPONDING #( <ls_booking_r> EXCEPT TravelId ) )
    TO   <it_booking>-%target ASSIGNING FIELD-SYMBOL(<ls_booking_n>).
        <ls_booking_n>-BookingStatus = 'N'.

        APPEND VALUE #( %cid_ref = <ls_booking_n>-%cid )
             TO it_booksuppl_cba ASSIGNING FIELD-SYMBOL(<ls_booksupp>).



        LOOP AT lt_booksupp_r ASSIGNING FIELD-SYMBOL(<ls_booksupp_r>)
                     USING KEY entity
           WHERE TravelId = <ls_travel_r>-TravelId
            AND  BookingId = <ls_booking_r>-BookingId.

          APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId && <ls_booksupp_r>-BookingSupplementId
          %data = CORRESPONDING #( <ls_booksupp_r> EXCEPT TravelId BookingId ) )

          TO <ls_booksupp>-%target.


        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF zi_sai_travel_m IN LOCAL MODE
       ENTITY zi_sai_travel_m
        CREATE FIELDS ( AgencyId CustomerId BeginDate EndDate BookingFee TotalPrice CurrencyCode OverallStatus Description )
             WITH it_travel
       ENTITY zi_sai_travel_m
         CREATE BY \_Booking
          FIELDS ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
          WITH it_booking_cba
          ENTITY zi_sai_booking_m
          CREATE BY \_Bookingsuppl
          FIELDS ( BookingSupplementId SupplementId Price CurrencyCode )
          WITH it_booksuppl_cba
           MAPPED DATA(it_mapped).
    mapped-zi_sai_travel_m = it_mapped-zi_sai_travel_m.


  ENDMETHOD.

  METHOD recalcToPrice.
    TYPES : BEGIN OF ty_total,
              price TYPE /dmo/total_price,
              curr  TYPE /dmo/currency_code,
            END OF ty_total.
    DATA :lt_total      TYPE TABLE OF ty_total,
          lv_conv_price TYPE /dmo/total_price.

    READ ENTITIES OF zi_sai_travel_m IN LOCAL MODE
    ENTITY zi_sai_travel_m
    FIELDS ( BookingFee CurrencyCode )
    WITH CORRESPONDING #( Keys )
    RESULT DATA(lt_travel).
    DELETE lt_travel WHERE currencycode IS INITIAL.

    READ ENTITIES OF zi_sai_travel_m IN LOCAL MODE
    ENTITY zi_sai_travel_m BY \_Booking
    FIELDS ( FlightPrice CurrencyCode )
    WITH CORRESPONDING #( lt_travel )
    RESULT DATA(lt_ba_booking).

    READ ENTITIES OF zi_sai_travel_m IN LOCAL MODE
    ENTITY zi_sai_booking_m BY \_Bookingsuppl
    FIELDS ( price CurrencyCode )
    WITH CORRESPONDING #( lt_ba_booking )
    RESULT DATA(lt_ba_booksuppl).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      lt_total = VALUE #( ( price = <ls_travel>-BookingFee curr = <ls_travel>-CurrencyCode ) ).

      LOOP AT lt_ba_booking ASSIGNING FIELD-SYMBOL(<ls_booking>)
      USING KEY entity
      WHERE TravelId = <ls_travel>-TravelId
      AND currencycode IS NOT INITIAL.

        APPEND VALUE #( price = <ls_booking>-FlightPrice curr = <ls_booking>-CurrencyCode )
        TO lt_total.

        LOOP AT lt_ba_booksuppl ASSIGNING FIELD-SYMBOL(<ls_booksuppl>)
        USING KEY entity
        WHERE TravelId = <ls_booking>-TravelId
        AND BookingId = <ls_booking>-BookingId
        AND currencycode IS NOT INITIAL.
          APPEND VALUE #( price = <ls_booksuppl>-Price curr = <ls_booksuppl>-CurrencyCode )
          TO lt_total.
        ENDLOOP.
      ENDLOOP.
      LOOP AT lt_total ASSIGNING FIELD-SYMBOL(<ls_total>).
        IF <ls_total>-curr = <ls_travel>-CurrencyCode.

          lv_conv_price =  <ls_total>-price.
        ELSE.
          /dmo/cl_flight_amdp=>convert_currency(
            EXPORTING
               iv_amount   = <ls_total>-price
               iv_currency_code_source = <ls_total>-curr
               iv_currency_code_target = <ls_travel>-CurrencyCode
               iv_exchange_rate_date  = cl_abap_context_info=>get_system_date( )
               IMPORTING
                 ev_amount   = lv_conv_price
           ).
        ENDIF.

        <ls_travel>-TotalPrice = <ls_travel>-TotalPrice + lv_conv_price.
      ENDLOOP.

    ENDLOOP.

    MODIFY ENTITIES OF zi_sai_travel_m IN LOCAL MODE
    ENTITY zi_sai_travel_m
    UPDATE FIELDS ( TotalPrice )
    WITH CORRESPONDING #( lt_travel ).


  ENDMETHOD.

  METHOD rejectTravel.
    MODIFY ENTITIES OF zi_sai_travel_m IN LOCAL MODE
      ENTITY zi_sai_travel_m
       UPDATE FIELDS ( OverallStatus )
       WITH VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                            OverallStatus = 'X' ) )
       REPORTED DATA(lt_travel).

    READ ENTITIES OF zi_sai_travel_m IN LOCAL MODE
    ENTITY zi_sai_travel_m
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).
    result = VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky
                                                %param = ls_result ) ).

  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zi_sai_travel_m IN LOCAL MODE
      ENTITY zi_sai_travel_m
      FIELDS ( TravelId OverallStatus )
      WITH CORRESPONDING #( Keys )
      RESULT DATA(lt_travel).
    result = VALUE #( FOR ls_travel IN lt_travel
                      ( %tky = ls_travel-%tky
                        %features-%action-acceptTravel = COND #( WHEN ls_travel-OverallStatus = 'A'
                                                                  THEN if_abap_behv=>fc-o-disabled
                                                                  ELSE if_abap_behv=>fc-o-enabled )
                         %features-%action-rejectTravel = COND #( WHEN ls_travel-OverallStatus = 'X'
                                                                  THEN if_abap_behv=>fc-o-disabled
                                                                  ELSE if_abap_behv=>fc-o-enabled )
                          %features-%assoc-_Booking = COND #( WHEN ls_travel-OverallStatus = 'X'
                                                                  THEN if_abap_behv=>fc-o-disabled
                                                                  ELSE if_abap_behv=>fc-o-enabled )

                                                                   )
                     ).

  ENDMETHOD.

  METHOD validateCustomer.
    READ ENTITY IN LOCAL MODE zi_sai_travel_m
        FIELDS ( CustomerId )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travel).
    DATA: lt_cust TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.
    lt_cust = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customer_id = Customerid ).
    DELETE lt_cust WHERE customer_id IS INITIAL.
    SELECT
      FROM /dmo/customer
      FIELDS customer_id
      FOR ALL ENTRIES IN @lt_cust
      WHERE customer_id = @lt_cust-Customer_Id
      INTO TABLE @DATA(lt_cust_db).
    IF sy-subrc IS INITIAL.

    ENDIF.
    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
      IF <ls_travel>-CustomerId IS INITIAL
      OR NOT line_exists( lt_cust_db[ customer_id = <ls_travel>-CustomerId ] ).
        APPEND VALUE #( %tky = <ls_travel>-%tky )
               TO failed-zi_sai_travel_m.
        APPEND VALUE #( %tky = <ls_travel>-%tky
                        %msg = NEW /dmo/cm_flight_messages(
                        textid =  /dmo/cm_flight_messages=>customer_unkown
                        customer_id = <ls_travel>-CustomerId
                        severity = if_abap_behv_message=>severity-error
                   )
                   %element-CustomerId = if_abap_behv=>mk-on
                          ) TO reported-zi_sai_travel_m.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateBookingFee.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateDateson.
  ENDMETHOD.

  METHOD validateStatuson.
  ENDMETHOD.

  METHOD calculateTotalPrice.
    MODIFY ENTITIES OF zi_sai_travel_m IN LOCAL MODE
       ENTITY zi_sai_travel_m
       EXECUTE recalcToPrice
       FROM CORRESPONDING #( Keys ).
  ENDMETHOD.

ENDCLASS.
