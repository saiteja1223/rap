@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Supply Projection'
@Metadata.allowExtensions: true
define view entity ZC_SAI_BSUPPLY_M as projection on ZI_SAI_BSUPPLY_M
{
    key TravelId,
    key BookingId,
    key BookingSupplementId,
    @ObjectModel.text.element: [ 'SupplementDesc' ]
    SupplementId,
    _SupplementText.Description as SupplementDesc : localized,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Price,
    CurrencyCode,
    LastChangedAt,
    /* Associations */
     _Travel: redirected to ZC_SAI_TRAVEL_M,
    _booking: redirected to parent ZC_SAI_BOOKING_M ,
    _Supplement,
    _SupplementText
}
