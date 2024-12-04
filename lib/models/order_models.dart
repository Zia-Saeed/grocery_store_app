import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderModels with ChangeNotifier {
  final String orderId, userId, productId, userName, price, imageUrl, quantity;
  final Timestamp orderDate;

  OrderModels({
    required this.orderId,
    required this.userId,
    required this.productId,
    required this.userName,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.orderDate,
  });
}
