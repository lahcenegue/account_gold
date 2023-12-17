abstract class AppStates {}

class AppInitialState extends AppStates{}

class HomeDataLoading extends AppStates{}
class HomeDataSuccess extends AppStates{}
class HomeDataError extends AppStates{}

class CompanyDataLoading extends AppStates{}
class CompanyDataSuccess extends AppStates{}
class CompanyDataError extends AppStates{}

class InvoiceDataLoading extends AppStates{}
class InvoiceDataSuccess extends AppStates{}
class InvoiceDataError extends AppStates{}

class GroupDataLoading extends AppStates{}
class GroupDataSuccess extends AppStates{}
class GroupDataError extends AppStates{}

class AddInvoiceDataLoading extends AppStates{}
class AddInvoiceDataSuccess extends AppStates{}
class AddInvoiceDataError extends AppStates{}

class AddInvoice2DataLoading extends AppStates{}
class AddInvoice2DataSuccess extends AppStates{}
class AddInvoice2DataError extends AppStates{}

class NewListCompleted extends AppStates{}

class GetImageSuccess extends AppStates{}
class GetImageError extends AppStates{}

class AddNewInvoiceLoading extends AppStates{}
class AddNewInvoiceSuccess extends AppStates{
  final String msg;
  final String massage;

  AddNewInvoiceSuccess({required this.massage, required this.msg});
}
class AddNewInvoiceError extends AppStates{}


class PaymentDataLoading extends AppStates{}
class PaymentDataSuccess extends AppStates{}
class PaymentDataError extends AppStates{}

class PaymentSearchDataLoading extends AppStates{}
class PaymentSearchDataSuccess extends AppStates{}
class PaymentSearchDataError extends AppStates{}

class AddPaymentLoading extends AppStates{}
class AddPaymentSuccess extends AppStates{
  final String msg;

  AddPaymentSuccess({required this.msg});
}
class AddPaymentError extends AppStates{}


class HistoryDataLoading extends AppStates{}
class HistoryDataSuccess extends AppStates{}
class HistoryDataError extends AppStates{}

class NewUrlSuccess extends AppStates{}


class CompanyAddLoading extends AppStates{}
class CompanyAddSuccess extends AppStates{
  final String msg;
  final String massage;

  CompanyAddSuccess({required this.massage, required this.msg});
}
class CompanyAddError extends AppStates{}


class GroupAddLoading extends AppStates{}
class GroupAddSuccess extends AppStates{
  final String msg;
  final String massage;

  GroupAddSuccess({required this.massage, required this.msg});
}
class GroupAddError extends AppStates{}

class SearchFileLoading extends AppStates{}
class SearchFileSuccess extends AppStates{}
class SearchFileError extends AppStates{}

class InternetChange extends AppStates{}