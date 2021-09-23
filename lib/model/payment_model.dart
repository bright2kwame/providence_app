class Payment {
  String debitAmt = "";
  String transactionType = "";
  String paymentMethod = "";
  String timeCreated = "";
  String transactionStatus = "";

  Payment({
    this.debitAmt = "",
    this.transactionType = "",
    this.paymentMethod = "",
    this.timeCreated = "",
    this.transactionStatus = "",
  });

  Payment.empty();
  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'debitAmt': debitAmt,
      'transactionType': transactionType,
      'paymentMethod': paymentMethod,
      'timeCreated': timeCreated,
      'transactionStatus': transactionStatus
    };
  }

  @override
  String toString() {
    return 'Payment{debitAmt: $debitAmt}';
  }
}
