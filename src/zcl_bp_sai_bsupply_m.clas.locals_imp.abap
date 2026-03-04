CLASS lhc_zi_sai_bsupply_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateCurrencyCode FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_sai_bsupply_m~validateCurrencyCode.

    METHODS validatePrice FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_sai_bsupply_m~validatePrice.

    METHODS validateSupplement FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_sai_bsupply_m~validateSupplement.
    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_sai_bsupply_m~calculateTotalPrice.

ENDCLASS.

CLASS lhc_zi_sai_bsupply_m IMPLEMENTATION.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validatePrice.
  ENDMETHOD.

  METHOD validateSupplement.
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
