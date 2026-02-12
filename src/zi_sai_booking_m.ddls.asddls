@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOOKING INTERFACE VIEW MANAGED'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SAI_BOOKING_M as select from zsai_booking_m
association to parent ZI_SAI_Travel_m as _Travel on $projection.TravelId=_Travel.TravelId
composition [0..*] of ZI_SAI_BSUPPLY_M as _bookingsuppl
association [1..1] to /DMO/I_Carrier as _Carrier on $projection.CarrierId=_Carrier.AirlineID
association[1..1] to /DMO/I_Customer as _Customer on $projection.CustomerId = _Customer.CustomerID
association[1..1] to /DMO/I_Connection as _Connection on $projection.ConnectionId=_Connection.ConnectionID
association[1..1] to /DMO/I_Booking_Status_VH as _Booking_status on $projection.BookingStatus= _Booking_status.BookingStatus
{
    key travel_id as TravelId,
    key booking_id as BookingId,
    booking_date as BookingDate,
    customer_id as CustomerId,
    carrier_id as CarrierId,
    connection_id as ConnectionId,
    flight_date as FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    flight_price as FlightPrice,
    currency_code as CurrencyCode,
    booking_status as BookingStatus,
        @Semantics.systemDateTime.localInstanceLastChangedAt: true
    last_changed_at as LastChangedAt,
    _bookingsuppl,
    _Carrier,
    _Customer,
    _Connection ,
    _Booking_status, _Travel
}
