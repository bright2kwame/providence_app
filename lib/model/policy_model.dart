class Policy {
  String policyNumber = "";
  String vehicleMake = "";
  String vehicleNumber = "";
  String ownerName = "";
  String renewalDate = "";
  bool isRenewalDue = false;
  String colour = "";
  String totalPremium = "";
  String stickerUrl = "";
  String certificateUrl = "";
  String scheduleUrl = "";

  Policy({
    this.policyNumber = "",
    this.vehicleMake = "",
    this.vehicleNumber = "",
    this.ownerName = "",
    this.renewalDate = "",
    this.isRenewalDue = false,
    this.colour = "",
    this.totalPremium = "",
    this.stickerUrl = "",
    this.certificateUrl = "",
    this.scheduleUrl = "",
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
      'stickerUrl': stickerUrl,
      'certificateUrl': certificateUrl,
      'scheduleUrl': scheduleUrl,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Policy{policyNumber: $policyNumber}';
  }
}
