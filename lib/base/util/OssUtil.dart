import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import 'package:yxr_flutter_basic/base/model/oss_policy.dart';
import 'package:yxr_flutter_basic/base/util/Log.dart';
import 'package:image_picker/image_picker.dart';

class OssUtil {
  static final Dio _dio = Dio();

  OssUtil._();

  static Future<String?> upload(
    XFile file, {
    required OssPolicy ossPolicy,
    CancelToken? cancelToken,
  }) async {
    try {
      var fileName =
          const Uuid().v1().replaceAll("-", "") + path.extension(file.name);
      fileName = "${ossPolicy.dir}/$fileName";

      var content = await file.readAsBytes();

      var formData = FormData.fromMap({
        'key': fileName,
        'success_action_status': 200,
        'OSSAccessKeyId': ossPolicy.accessKeyId,
        'policy': ossPolicy.policy,
        'Signature': ossPolicy.signature,
        'Content-Type': file.mimeType,
        'file': MultipartFile.fromBytes(content, filename: fileName),
      });

      var response = await _dio.post(
        ossPolicy.host,
        data: formData,
        cancelToken: cancelToken,
        options: Options(
          headers: {"Content-Type": "multipart/form-data"},
        ),
      );

      if (response.statusCode == 200) {
        return '/$fileName';
      }
    } catch (e) {
      Log.d(e.toString());
      return null;
    }
  }
}
