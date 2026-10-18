class WalletBalanceModel {
  final String walletId;
  final double balance;
  final String currency;

  WalletBalanceModel({
    required this.walletId,
    required this.balance,
    required this.currency,
  });

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) {
    return WalletBalanceModel(
      walletId: json['wallet_id'] as String? ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'QAR',
    );
  }
}

class WalletHistoryResponseModel {
  final List<TransactionModel> transactions;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  WalletHistoryResponseModel({
    required this.transactions,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory WalletHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return WalletHistoryResponseModel(
      transactions:
          (json['transactions'] as List<dynamic>?)
              ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 20,
      totalPages: json['total_pages'] as int? ?? 1,
    );
  }
}

class TransactionModel {
  final String id;
  final String type; // DEPOSIT, DEBIT
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final String description;
  final String referenceId;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.description,
    required this.referenceId,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'DEPOSIT',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      balanceBefore: (json['balance_before'] as num?)?.toDouble() ?? 0.0,
      balanceAfter: (json['balance_after'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      referenceId: json['reference_id'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? (DateTime.tryParse(json['created_at'].toString())?.toLocal() ??
                DateTime.now())
          : DateTime.now(),
    );
  }
}

class WalletTopupResponseModel {
  final String paymentUrl;
  final String invoiceId;
  final String referenceId;
  final double amount;
  final String currency;
  final String message;

  WalletTopupResponseModel({
    required this.paymentUrl,
    required this.invoiceId,
    required this.referenceId,
    required this.amount,
    required this.currency,
    required this.message,
  });

  factory WalletTopupResponseModel.fromJson(Map<String, dynamic> json) {
    return WalletTopupResponseModel(
      paymentUrl: json['payment_url'] as String? ?? '',
      invoiceId: json['invoice_id'] as String? ?? '',
      referenceId: json['reference_id'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'QAR',
      message: json['message'] as String? ?? '',
    );
  }
}
