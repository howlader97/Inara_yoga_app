class OrdersResponse {
  final List<Order> orders;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  OrdersResponse({
    required this.orders,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      orders: (json['orders'] as List)
          .map((order) => Order.fromJson(order))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders.map((order) => order.toJson()).toList(),
      'total': total,
      'page': page,
      'pageSize': pageSize,
      'totalPages': totalPages,
    };
  }
}

class Order {
  final String id;
  final String orderNumber;
  final String productName;
  final String orderedBy;
  final String orderedByEmail;
  final int price;
  final int quantity;
  final DateTime orderDate;
  final String progress;
  final String status;

  Order({
    required this.id,
    required this.orderNumber,
    required this.productName,
    required this.orderedBy,
    required this.orderedByEmail,
    required this.price,
    required this.quantity,
    required this.orderDate,
    required this.progress,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      productName: json['productName'] as String,
      orderedBy: json['orderedBy'] as String,
      orderedByEmail: json['orderedByEmail'] as String,
      price: json['price'] as int,
      quantity: json['quantity'] as int,
      orderDate: DateTime.parse(json['orderDate'] as String),
      progress: json['progress'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'productName': productName,
      'orderedBy': orderedBy,
      'orderedByEmail': orderedByEmail,
      'price': price,
      'quantity': quantity,
      'orderDate': orderDate.toIso8601String(),
      'progress': progress,
      'status': status,
    };
  }
}
