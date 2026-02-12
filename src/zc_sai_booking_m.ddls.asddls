@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking PROJECTION'
@Metadata.allowExtensions: true
define view entity ZC_SAI_BOOKING_M as projection on ZI_SAI_BOOKING_M
{
    key TravelId,
    key BookingId,
    BookingDate,
    @ObjectModel.text.element: [ 'CustomerName' ]
    CustomerId,
      @ObjectModel.text.element: [ 'CarrierName' ]
    CarrierId,
    _Carrier.Name as CarrierName,
    ConnectionId,
    _Customer.LastName as CustomerName,
    FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    FlightPrice,
    CurrencyCode,
     @ObjectModel.text.element: [ 'BookingStatusText' ]
    BookingStatus,
     _Booking_status._Text.Text as BookingStatusText :localized,
    LastChangedAt,
    /* Associations */
    _bookingsuppl:redirected to composition child ZC_SAI_BSUPPLY_M,
    _Booking_status,
    _Carrier,
    _Connection,
    _Customer,
    _Travel: redirected to parent ZC_SAI_TRAVEL_M
}
