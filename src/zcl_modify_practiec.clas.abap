CLASS zcl_modify_practiec DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
     INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MODIFY_PRACTIEC IMPLEMENTATION.


  method if_oo_adt_classrun~main.
  data : lt_book type table for create zi_sai_travel_m\_booking.
     MODIFY entity zi_sai_travel_m
*use Delete from value ( pass all key fields )
        CREATE FROM VALUE #(
                      ( %cid = 'cid1'
                        %data-BeginDate ='20260212'
                        %control-BeginDate = if_abap_behv=>mk-on

                                  ) )
         create by \_Booking
               from value #( ( %cid_ref = 'cid1'
                            %target = value #( ( %cid        = 'cid11'
                                                %data-BookingDate = '20260212'
                                                 %control-bookingdate = if_abap_behv=>mk-on
                                                   ) )
 ) )

                 FAILED FINAL(it_failed)
                 mapped final(it_mapped)
                 reported final(it_result).

          if it_failed is not initial.
            out->write( it_failed ).
            else.
            commit entities.
            endif.


  ENDMETHOD.
ENDCLASS.
