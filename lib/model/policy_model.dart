class Policy {
  String policyNumber = "";
  String vehicleMake = "";
  String ownerName = "";
  String renewalDate = "";
  bool isRenewalDue = false;
  String colour = "";
  String totalPremium = "";

  Policy({
    this.policyNumber = "",
    this.vehicleMake = "",
    this.ownerName = "",
    this.renewalDate = "",
    this.isRenewalDue = false,
    this.colour = "",
    this.totalPremium = "",
  });

  Policy.empty();
  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'policyNumber': policyNumber,
      'vehicleMake': vehicleMake,
      'ownerName': ownerName,
      'renewalDate': renewalDate,
      'isRenewalDue': isRenewalDue,
      'colour': colour,
      'totalPremium': totalPremium,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Policy{policyNumber: $policyNumber}';
  }
}
