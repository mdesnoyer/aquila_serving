# Description: Tensorflow Serving tensorflow servable.

package(
    default_visibility = [
        "//tensorflow_serving:internal",
    ],
    features = [
        "-layering_check",
        "-parse_headers",
    ],
)

licenses(["notice"])  # Apache 2.0

exports_files(["LICENSE"])

filegroup(
    name = "all_files",
    srcs = glob(
        ["**/*"],
        exclude = [
            "**/METADATA",
            "**/OWNERS",
        ],
    ),
)

load("//tensorflow_serving:serving.bzl", "serving_proto_library")

serving_proto_library(
    name = "session_bundle_config_proto",
    srcs = ["session_bundle_config.proto"],
    cc_api_version = 2,
    visibility = [
        "//visibility:public",
    ],
    deps = [
        "@tf//google/protobuf:cc_wkt_protos",
        "@tf//tensorflow/core:protos_all_cc",
    ],
)

cc_library(
    name = "session_bundle_source_adapter",
    srcs = ["session_bundle_source_adapter.cc"],
    hdrs = ["session_bundle_source_adapter.h"],
    visibility = [
        "//visibility:public",
    ],
    deps = [
        "@tf//tensorflow/core:core_cpu",
        "@tf//tensorflow/core:lib",
        "@tf//tensorflow/core:protos_all_cc",
        "@tf//tensorflow/core:tensorflow",
        ":session_bundle_config_proto",
        ":session_bundle_source_adapter_proto",
        "//tensorflow_serving/core:simple_loader",
        "//tensorflow_serving/core:source_adapter",
        "//tensorflow_serving/core:storage_path",
        "//tensorflow_serving/servables/tensorflow:serving_session",
        "//tensorflow_serving/session_bundle",
    ],
)

serving_proto_library(
    name = "session_bundle_source_adapter_proto",
    srcs = ["session_bundle_source_adapter.proto"],
    cc_api_version = 2,
    visibility = [
        "//visibility:public",
    ],
    deps = [
        ":session_bundle_config_proto",
    ],
)

cc_library(
    name = "simple_servers",
    srcs = ["simple_servers.cc"],
    hdrs = ["simple_servers.h"],
    visibility = [
        "//visibility:public",
    ],
    deps = [
        "@tf//tensorflow/core:lib",
        "@tf//tensorflow/core:tensorflow",
        ":session_bundle_source_adapter",
        ":session_bundle_source_adapter_proto",
        "//tensorflow_serving/core:aspired_versions_manager_builder",
        "//tensorflow_serving/core:eager_unload_policy",
        "//tensorflow_serving/core:loader",
        "//tensorflow_serving/core:manager",
        "//tensorflow_serving/core:source",
        "//tensorflow_serving/core:source_adapter",
        "//tensorflow_serving/core:storage_path",
        "//tensorflow_serving/core:target",
        "//tensorflow_serving/session_bundle",
        "//tensorflow_serving/sources/storage_path:file_system_storage_path_source",
        "//tensorflow_serving/sources/storage_path:file_system_storage_path_source_proto",
    ],
)

cc_library(
    name = "serving_session",
    srcs = ["serving_session.cc"],
    hdrs = ["serving_session.h"],
    deps = [
        "@tf//tensorflow/core:core_cpu",
        "@tf//tensorflow/core:lib",
        "@tf//tensorflow/core:protos_all_cc",
        "@tf//tensorflow/core:tensorflow",
    ],
)
