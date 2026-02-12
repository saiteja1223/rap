@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Projection View'
@Metadata.allowExtensions: true
define root view entity ZC_SAI_TRAVEL_M 
provider contract transactional_query
as projection on ZI_SAI_Travel_m
{
    key TravelId,
    @ObjectModel.text.element: [ 'AgencyName' ]
    AgencyId,
    _Agency.Name as AgencyName,
      @ObjectModel.text.element:['CustomerName']
    CustomerId,
    _Customer.LastName as CustomerName,
    BeginDate,
    EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TotalPrice,
    CurrencyCode,
    Description,
    @ObjectModel.text.element:['OverallStatusText']
    OverallStatus,
    _status._Text.Text as OverallStatusText :localized,
   // CreatedBy,
   // CreatedAt,
   // LastChangedBy,
    LastChangedAt,
    /* Associations */
    _Agency,
    _Booking:redirected to composition child  ZC_SAI_BOOKING_M,
    _Currency,
    _Customer,
    _status
}
