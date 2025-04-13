// lib/modules/services/admin/attendance_service.dart
// import 'package:linkschool/modules/admin/result/models/attendance_record.dart';
import 'package:linkschool/modules/model/admin/attendance_record_model.dart';
import 'package:linkschool/modules/services/api/api_service.dart';

class AttendanceService {
  final ApiService _apiService;

  AttendanceService(this._apiService);

  Future<ApiResponse<List<AttendanceRecord>>> getAttendanceHistory({
    required String classId,
    required String term,
    required String year,
    required String dbName,
  }) async {
    try {
      final response = await _apiService.get(
        endpoint: 'portal/attendance',
        queryParams: {
          '_db': dbName,
          'class_id': classId,
          'term': term,
          'year': year,
        },
      );

      if (response.success && response.rawData != null) {
        final List<dynamic> attendanceRecordsData = response.rawData!['attendance_records'] ?? [];
        final List<AttendanceRecord> attendanceRecords = attendanceRecordsData
            .map((record) => AttendanceRecord.fromJson(record))
            .toList();

        return ApiResponse<List<AttendanceRecord>>(
          success: true,
          message: 'Attendance records fetched successfully',
          statusCode: response.statusCode,
          data: attendanceRecords,
          rawData: response.rawData,
        );
      } else {
        return ApiResponse<List<AttendanceRecord>>.error(
          response.message,
          response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse<List<AttendanceRecord>>.error(
        'Failed to fetch attendance records: ${e.toString()}',
        500,
      );
    }
  }
}