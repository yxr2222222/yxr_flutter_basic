import 'package:json_annotation/json_annotation.dart';

part 'oss_policy.g.dart';

@JsonSerializable()
class OssPolicy {
  @JsonKey(defaultValue: '')
  final String accessKeyId;
  @JsonKey(defaultValue: '')
  final String policy;
  @JsonKey(defaultValue: '')
  final String signature;
  @JsonKey(defaultValue: '')
  final String dir;
  @JsonKey(defaultValue: '')
  final String host;

  const OssPolicy({
    required this.accessKeyId,
    required this.policy,
    required this.signature,
    required this.dir,
    required this.host,
  });

  factory OssPolicy.fromJson(Map<String, dynamic> json) =>
      _$OssPolicyFromJson(json);

  Map<String, dynamic> toJson() => _$OssPolicyToJson(this);
}
