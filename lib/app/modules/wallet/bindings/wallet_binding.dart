import 'package:get/get.dart';
import '../controllers/wallet_controller.dart';

class WalletBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<WalletController>(() => WalletController());
  }
}
