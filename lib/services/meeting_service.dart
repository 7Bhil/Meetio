class MeetingService {
  Future<List<Meeting>> getMeetings() {}
  Future<Meeting> getMeeting(String id) {}
  Future<void> createMeeting(Meeting meeting) {}
  Future<void> updateMeeting(Meeting meeting) {}
  Future<void> deleteMeeting(String id) {}
}