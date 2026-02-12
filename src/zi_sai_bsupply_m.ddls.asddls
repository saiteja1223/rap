@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking  Supply Interface View Managed'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SAI_BSUPPLY_M
 as select from zsai_bsupply_m
 association to parent ZI_SAI_BOOKING_M as _booking on $projection.TravelId=_booking.TravelId
and $projection.BookingId = _booking.BookingId
association[1..1] to zi_sai_travel_m as _Travel on $projection.TravelId= _Travel.TravelId
 association [1..1] to /DMO/I_Supplement as _Supplement on $projection. SupplementId = _Supplement.SupplementID
association [1..*] to /DMO/I_SupplementText as _SupplementText on $projection.SupplementId = _SupplementText.SupplementID
{
    key travel_id as TravelId,
    key booking_id as BookingId,
    key booking_supplement_id as BookingSupplementId,
    supplement_id as SupplementId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    price as Price,
    currency_code as CurrencyCode,
            @Semantics.systemDateTime.localInstanceLastChangedAt: true
    
    last_changed_at as LastChangedAt,
     _Travel ,
    _booking,
    _Supplement,
    _SupplementText
}
