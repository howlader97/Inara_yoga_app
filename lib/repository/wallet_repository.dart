import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../models/wallet_model.dart';
import '../services/api/api_services.dart';

class WalletRepository {
  WalletRepository._privateConstructor();
  static final WalletRepository _instance =
      WalletRepository._privateConstructor();
  static WalletRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _apiEndPoint = AppApiEndPoint.instance;

  Future<WalletBalanceModel?> getBalance() async {
    try {
      var response = await _apiServices.apiGetServices(
        _apiEndPoint.walletBalance,
      );
      if (response != null) {
        return WalletBalanceModel.fromJson(response);
      }
    } catch (e) {
      errorLog('getBalance repo', e);
    }
    return null;
  }

  Future<WalletHistoryResponseModel?> getHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        'page': page,
        'page_size': pageSize,
      };

      var response = await _apiServices.apiGetServices(
        _apiEndPoint.walletHistory,
        queryParameters: queryParameters,
      );

      if (response != null) {
        return WalletHistoryResponseModel.fromJson(response);
      }
    } catch (e) {
      errorLog('getHistory repo', e);
    }
    return null;
  }

  Future<WalletTopupResponseModel?> topUpWallet({
    required double amount,
  }) async {
    try {
      var body = {'amount': amount};

      var response = await _apiServices.apiPostServices(
        url: _apiEndPoint.walletTopUp,
        body: body,
      );

      if (response != null) {
        return WalletTopupResponseModel.fromJson(response);
      }
    } catch (e) {
      errorLog('topUpWallet repo', e);
    }
    return null;
  }
}
