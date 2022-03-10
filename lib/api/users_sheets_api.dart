import 'package:gsheets/gsheets.dart';

class UserSpreadSheetApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "blnk-task-challenge",
  "private_key_id": "45653f25f2ecd2a2ab015a9a3ed49b27bc1aa534",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQCw0Q7+Dr5g6itr\nP+fUymByCiqbsS/Iowu3NH6bP7MfOWqQfHLSfLXS29XSjiTCTnPbpCQ0iODwtCEg\n5rdyp1xvRjwfu6FvYHHmMDY9Ybj67HxzE1PsRWnCb9uG9D75mabiCn/1lgbOyn32\n9qBZSiTPNOurxvZ0DUzCi+88RlDUEy0/OtWLNh3K+4WqmUszhkCe4gGrjVF4juNR\ndEE2oMX5rD3QM33899doRi1ibkASiX8JQp6R0ayXRN8tQrQpjsuSnJSzwaQu1Jx+\npBngVDcseEa/xR0Qz2J9vmimzYe/YBkHy2kCK8U1200sNVdAZT+zkelqH1RuxZ8N\nmMEWOhbPAgMBAAECgf9WYSZEczGGJxG0QucoPu+1rdZtQWSShzW+Y3t2fbBWsb5N\nKl3lj1nY+62jN5xaikusVDmd07Rzb2tUbaQYZ0dub+FznzZPGjHU33aoQ/RUTsAa\nXvwD5LvvUb5Yq333aedv0JiRitI8M/qwkuRoNm1yirJEzZvKgYuKyajDoCsF4tJ/\ndSWW8nsKR8Mi6gkUMBY47UtFJoaHZQM/huHH2DZJUDrtvLZuOI/vm93g4K7mmOm2\n2/4AQ5+g7WEXt1TdJUoaZvgRNXBhT0mj2tsyauUw5zkpsZ9zfRBs0OlLsJs7mv3d\naNjJERBxMy37B6M8UdjE209NBbLvhyhP+UuC9okCgYEA4jztkRrWxlSaBHaPpra1\nn5nxz0gnCuxXxcYXV6yPcRu5Sa/3nS6tmHisYri8VWYgzbcA0cG/hRn8zDtM9jEw\nmdC6hCs/A96YS+aoMZKuWVhSfIZzP1IYTRtJo/e/l68A28AS1643j385nviBXpk0\n4houJp2nvGJRKS3NlHXodv0CgYEAyBPBWYm71qm2sTZ7luZFS7oIGWvulaXuwo81\n870kCHdAq6hB5RWsP+9y12ZWxH/K3XO9BPXYBgiI5lV4ePg/5xiNRBEHCZ16NIBi\nKcPxN3DaqFjal3S7LdxUUbG4O5AagR8EbrmerZLUo0SCG4CEMA4DIRkLCk0pluLT\nkk9dnLsCgYEAmzxlYqDA6Jvaht93mFRccaQnSSzgJV2gqINRNwaf8mOskwRcao1B\n7pI27xKFoC+QqLc+p69DJCh9zwGNwIxmJdUUdmZaOeR+Ke6eUE2utn2lM+7pm3RQ\nWnAz6n+wBnu9ogu8oiPX2e3ZctxfoLKNl+uQ6UxacSghOplEK+9v0F0CgYBoS7wH\no7/SJ8f/WupUABdxYTllnxjQ053BuAuk0hzdeOSyVtR6ybBv569Sz5s9dWxXwkRv\nOIRyqLJMd5OEY8xT+D1zlPi5L2kLwzzojqbIgsDI7wCL4SLNxkQCDgV+ryDR3Exg\nN8yaqKbFsSmtknHV5wgEkdxqc0zRxc4KP+sJjwKBgD2FZoKjcQ4pZb9PQDO8ivwb\nd9ubcS5krLyfiXl2rUDj+BaXowyZcPE413OjyrwjfZ+kUJ6H6z3RrBlyoHjwPej3\nTmn+i3hf5CUD9g9NIV9ElaadEF31nmqwSupt1PE4+xdI7dN8HSHQ+NKHCi0XOWfi\npigcwhaZ6VpyDvyxfExR\n-----END PRIVATE KEY-----\n",
  "client_email": "blnk-45@blnk-task-challenge.iam.gserviceaccount.com",
  "client_id": "115217633112999859078",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/blnk-45%40blnk-task-challenge.iam.gserviceaccount.com"
}
''';
  static final _spreatsheetID = '1ImSsOIPT1tB0bwHgUnTLhiK_CdmUpdki-FZdByXqfA4';

  static final url =
      "https://docs.google.com/spreadsheets/d/e/2PACX-1vREcL0T4buZfJdeu08KcAHipMX4Er-qE1QjazFSV4YqdsaoD9t1PWaNIuOMtJYHx4USHfDtupGExodE/pubhtml?gid=2072572073&single=true";

  static final _gsheets = GSheets(_credentials);
  static Future<dynamic>? _userSheet;
  static Worksheet? _worksheet;

  static Future init() async {
    final spreadsheet = _gsheets.spreadsheet(_spreatsheetID);

    spreadsheet.then((value) => {
          _userSheet = _getWorkSheet(value, title: "Users"),
        });
  }

  static Future _getWorkSheet(Spreadsheet spreadsheet,
      {required String title}) async {
    try {
      await spreadsheet.addWorksheet(title).then((value) => {
            value.values.insertRow(1, [
              "First Name",
              "Last Name",
              "Address",
              "Landline",
              "Mobile Number",
              "Country"
            ]),
            _worksheet = value
          });
    } catch (e) {
      _worksheet = spreadsheet.worksheetByTitle(title);
    }
  }

  static Future insert(
      int counter,
      String _firstName,
      String _lastName,
      String _address,
      String _landline,
      String _mobile,
      String dropdownValue) async {
    if (_worksheet == null) return;

    _worksheet!.values.insertRow(counter,
        [_firstName, _lastName, _address, _landline, _mobile, dropdownValue]);
  }
}
