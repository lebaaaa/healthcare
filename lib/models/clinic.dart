class Clinic {
  final String name;
  final String address;
  final String website;
  final String contact;
  final String opening_hours;
  final String place_id;

  Clinic({
    required this.name,
    required this.address,
    required this.website,
    required this.contact,
    required this.opening_hours,
    required this.place_id,
  });

  //TODO implement Clinic.fromJson
  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      name: json['properties']['name'] ?? "Name not found",
      address: json['properties']['address_line2'] ?? "Address not found",
      website: json['properties']['website'] ?? "Website not found",
      contact: json['properties']['contact']?['phone'] ??   "Contact not found",
      opening_hours: json['properties']['opening_hours'] ?? "Opening Hours not found",
      place_id: json['properties']['place_id'] ?? "Place ID not found",
    );
  }
}
