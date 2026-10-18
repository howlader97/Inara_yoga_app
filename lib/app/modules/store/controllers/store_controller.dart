import 'package:flutter/material.dart';
import '../../../utils/app_log.dart';
import '../../../../repository/store_repository.dart';
import 'package:get/get.dart';

import '../../../../models/store_product_model.dart';

class StoreController extends GetxController {
  late ScrollController scrollController;
  final RxList<StoreProductModel> products = <StoreProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPaginationLoading = false.obs;
  bool isHasPagination = true;
  var page = 1;

  void pagination() {
    try {
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          if (isHasPagination && !isPaginationLoading.value) {
            isPaginationLoading.value = true;
            getStoreData(page: page);
          }
        }
      });
    } catch (_) {}
  }

  Future<void> getStoreData({required int page}) async {
    try {
      final (response, hasPagination) = await StoreRepository.instance
          .storeClasses(page);
      products.addAll(response);
      if (hasPagination == true) {
        this.page = page + 1;
      } else {
        isHasPagination = false;
      }
    } catch (e) {
      errorLog("error is", e);
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
    }
  }

  Future<void> onAppInitial() async {
    try {
      isLoading.value = true;
      scrollController = .new();
      await getStoreData(page: 1);
      pagination();
    } catch (e) {
      errorLog("error form StoreController onAppInitial function ", e);
    }
  }

  void onAppClose() {
    try {
      scrollController.dispose();
    } catch (_) {}
  }

  @override
  void onInit() {
    onAppInitial();
    super.onInit();
  }

  @override
  void onClose() {
    onAppClose();
    super.onClose();
  }
}
