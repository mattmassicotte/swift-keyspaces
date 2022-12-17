// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "SwiftKeyspaces",
    dependencies: [
		.package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", .upToNextMajor(from: "0.5.0")),
		.package(url: "https://github.com/apple/swift-cassandra-client", .upToNextMajor(from: "0.1.0")),
    ],
    targets: [
        .executableTarget(
            name: "SwiftKeyspaces",
            dependencies: [
				.product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
				.product(name: "CassandraClient", package: "swift-cassandra-client"),
			]),
        .testTarget(
            name: "SwiftKeyspacesTests",
            dependencies: ["SwiftKeyspaces"]),
    ]
)
