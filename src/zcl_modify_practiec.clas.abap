CLASS zcl_modify_practiec DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
     INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_modify_practiec IMPLEMENTATION.
  method if_oo_adt_classrun~main.
     MODIFY entity zi_sai_travel_m
        CREATE FROM VALUE #(
                      ( %cid = 'cid1'
                        %data-BeginDate ='20260212'
                        %control-BeginDate = if_abap_behv=>mk-on

                                  ) )

                 FAILED FINAL(it_failed)
                 mapped final(it_mapped)
                 reported final(it_ewsult).

  ENDMETHOD.

ENDCLASS.
