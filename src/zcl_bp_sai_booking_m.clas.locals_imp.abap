CLASS lhc_zi_sai_booking_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_sai_booking_m RESULT result.
    METHODS earlynumbering_cba_bookingsupp FOR NUMBERING
      IMPORTING entities FOR CREATE zi_sai_booking_m\_bookingsuppl.

    METHODS validateconnection FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_sai_booking_m~validateconnection.

    METHODS validatecurrencycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_sai_booking_m~validatecurrencycode.

    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_sai_booking_m~validatecustomer.

    METHODS validateflightprice FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_sai_booking_m~validateflightprice.

    METHODS validatestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_sai_booking_m~validatestatus.
    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_sai_booking_m~calculatetotalprice.

ENDCLASS.

CLASS lhc_zi_sai_booking_m IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_sai_travel_m IN LOCAL MODE
      ENTITY zi_sai_travel_m BY \_Booking
      FIELDS ( TravelId BookingStatus )
      WITH CORRESPONDING #( Keys )
      RESULT DATA(lt_booking).
    result = VALUE #( FOR ls_booking IN lt_booking
                      ( %tky = ls_booking-%tky
                          %features-%assoc-_bookingsuppl = COND #( WHEN ls_booking-BookingStatus = 'X'
                                                                  THEN if_abap_behv=>fc-o-disabled
                                                                  ELSE if_abap_behv=>fc-o-enabled )

                                                                   )
                     ).

  ENDMETHOD.

  METHOD earlynumbering_cba_Bookingsupp.
  ENDMETHOD.

  METHOD validateConnection.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateCustomer.
  ENDMETHOD.

  METHOD validateFlightPrice.
  ENDMETHOD.

  METHOD validateStatus.
  ENDMETHOD.

  METHOD calculateTotalPrice.
    DATA: it_travel TYPE STANDARD TABLE OF zi_sai_travel_m WITH UNIQUE HASHED KEY  key COMPONENTS Travelid.
    it_travel = CORRESPONDING #( keys DISCARDING DUPLICATES MAPPING TravelId = Travelid ).
    MODIFY ENTITIES OF zi_sai_travel_m IN LOCAL MODE
        ENTITY zi_sai_travel_m
        EXECUTE recalcToPrice
        FROM CORRESPONDING #( it_travel ).

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
