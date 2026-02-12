CLASS zcl_read_ptactice DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
     INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_read_ptactice IMPLEMENTATION.
 method if_oo_adt_classrun~main.
*   read entity Zi_sai_travel_m
*     from value #( ( %key-TravelId = '00000021'
*                     %control = VALUE #( AgencyId = if_abap_behv=>mk-on
*                                         CUSTOMERID = if_abap_behv=>mk-on
*                                         BEGINDATE   = if_abap_behv=>mk-on
*                                 )
*     ) )
*     RESULT data(it_result_short)
*     FAILED data(it_failed_sort).
*     if it_failed_sort is not INITIAL.
*     out->write( 'REad failed' ).
*     else.
*     out->write( it_result_short ).
*     ENDIF.
* read entity Zi_sai_travel_m
*     by \_Booking
*     All fields
**     Fields ( AgencyId BeginDate BookingFee )
*     with value #( ( %key-TravelId = '00000021'  ) )
*     RESULT data(it_result_short)
*     FAILED data(it_failed_sort).
*     if it_failed_sort is not INITIAL.
*     out->write( 'REad failed' ).
*     else.
*     out->write( it_result_short ).
*     ENDIF.
*     Read ENTITIES OF zi_sai_travel_m
*        ENTITY zi_sai_travel_m
*        All fields
*        WITH value #( ( %key-TravelId = '00000021' ) )
*        result data(lt_result_travel)
*        entity zi_sai_booking_m
*        ALL FIELDS WITH value #( ( %key-TravelId = '00000021' ) )
*        result data(it_result_book)
*        FAILED data(it_failed_sort).
*        if it_failed_sort is not INITIAL.
*        out->write( 'REad failed' ).
*        else.
*        out->write( lt_result_travel ).
*        out->write( it_result_book ).
*        ENDIF.
* dynamic read operation
        data:it_optab type abp_behv_retrievals_tab,
             it_travel type table for read  import zi_sai_travel_m,
             it_travel_result type table for read RESULT zi_sai_travel_m.

             it_travel = value #( ( %key-TravelId = '00000021'
             %control = VALUE #( AgencyId = if_abap_behv=>mk-on
                                         CUSTOMERID = if_abap_behv=>mk-on
                                         BEGINDATE   = if_abap_behv=>mk-on
                                 )
             ) ).
             it_optab = VALUE #( ( op = if_abap_behv=>op-r-read
                entity_name = 'ZI_SAI_TRAVEL_M'
                 instances = REf #( it_travel )
                results = Ref #( it_travel_result )
               ) ).
               read ENTITIES
                       operations it_optab
                        failed  data(it_failed_sort).

              if it_failed_sort is not initial .
              out->write( 'Read failed' ).
              else.
              out->write( it_travel_result ).
              endif.



 ENDMETHOD.
ENDCLASS.
