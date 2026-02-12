CLASS lhc_ZI_SAI_Travel_m DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR ZI_SAI_Travel_m RESULT result.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE ZI_SAI_Travel_m.
    methods earlynumbering_cba_Booking for NUMBERING
      importing entities for create  zi_sai_travel_m\_Booking.

ENDCLASS.

CLASS lhc_ZI_SAI_Travel_m IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
       DATA(lt_entities) = entities.
       DELETE lt_entities where TravelId is not initial.
       try.
       cl_numberrange_runtime=>number_get(
          EXPORTING
          nr_range_nr = '01'
          object      = '/DMO/TRV_M'
          quantity    = CONV #( lines( lt_entities ) )
          IMPORTING
          number   =    data(lv_latest_num)
          returncode =   data(lv_code)
          returned_quantity = data(lv_qty)
       ).
       catch cx_number_ranges into data(lo_error).
       LOOP AT lt_entities INTO DATA(ls_entities).
         APPEND VALUE #( %cid = ls_entities-%cid
                  %key = ls_entities-%key )
               TO failed-zi_sai_travel_m.
         APPEND VALUE #( %cid = ls_entities-%cid
                       %key = ls_entities-%key
                        %msg = lo_error )
                TO reported-zi_sai_travel_m.
        endloop.
        exit.
       ENDTRY.

       ASSERT lv_qty = lines( lt_entities ).
*       data:lt_sai_travel_m type table for mapped early zi_sai_travel_m,
*      ls_sai_travel_m  like line of lt_sai_travel_m.
        data(lv_curr_num) = lv_latest_num - lv_qty.
       loop at lt_entities into ls_entities.
           lv_curr_num = lv_curr_num + 1.
*          ls_sai_travel_m = VALUE #( %cid = ls_entities-%cid
*                                     TravelId = lv_curr_num
*                                     ).
*             APPEND  ls_sai_travel_m to mapped-zi_sai_travel_m.
           Append VALUE #( %cid = ls_entities-%cid
                                   TravelId = lv_curr_num ) to mapped-zi_sai_travel_m.
        endloop.
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
                FOR LS_ENTITY IN entities USING KEY entity
                    WHERE ( TravelId = <1s_group_entity>-TravelId )
                  FOR LS_BOOKING IN LS_ENTITY-%target
                    NEXT LV_MAX = COND /dmo/booking_id( WHEN lv_max < LS_BOOKING-BookingId
                                                        THEN lS_BOOKING-BookingId
                                                         ELSE lv_max )
                                                         ).
     LOOP AT entities assigning FIELD-SYMBOL(<ls_entities>)
                             using key entity
                             where TravelId = <1s_group_entity>-TravelId.
           LOOP AT <ls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_booking>).

                            IF <ls_booking>-BookingId IS INITIAL.
                             lv_max_booking += 10.
                       APPEND CORRESPONDING #( <ls_booking> ) TO mapped-zi_sai_booking_m
                    ASSIGNING FIELD-SYMBOL(<ls_new_map_book>).

                    <ls_new_map_book>-BookingId = lv_max_booking.
ENDIF.

ENDLOOP.

endloop.



  ENDLOOP.
ENDMETHOD.

ENDCLASS.
