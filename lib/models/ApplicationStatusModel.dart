class ApplicationStatus {
  final String status;
  final String? adminNotes;
  final bool hasApplication;

  ApplicationStatus({required this.status, this.adminNotes, required this.hasApplication});

  factory ApplicationStatus.fromJson(Map<String, dynamic> json) {
    if (json['msg'] == 'No application found') {
      return ApplicationStatus(status: 'none', hasApplication: false);
    }
    return ApplicationStatus(
      status: json['status'] ?? 'none',
      adminNotes: json['adminNotes'], // This is crucial for Rejection!
      hasApplication: true,
    );
  }
}