import AWSLambdaRuntime
import AWSLambdaEvents
import CassandraClient
import Foundation

struct Input: Codable {
	let name: String
}

struct Output: Codable {
	let message: String
}

struct TableModel: Codable {
	let key: String
	let value: String
}

let region = ProcessInfo.processInfo.environment["AWS_REGION"] ?? "us-east-1"

var configuration = CassandraClient.Configuration(contactPointsProvider: { callback in
	let points = ["cassandra.\(region).amazonaws.com"]

	callback(.success(points))
}, port: 9142, protocolVersion: .v4)

configuration.consistency = .localQuorum
configuration.username = ProcessInfo.processInfo.environment["KEYSPACES_USER"]
configuration.password = ProcessInfo.processInfo.environment["KEYSPACES_PASS"]
configuration.keyspace = ProcessInfo.processInfo.environment["KEYSPACES_NAME"]

var ssl = CassandraClient.Configuration.SSL()

let url = URL(fileURLWithPath: "/opt/sf-class2-root.crt")
let certContents = try? String(contentsOf: url)

ssl.verifyFlag = CassandraClient.Configuration.SSL.VerifyFlag.none
ssl.cert = certContents
configuration.ssl = ssl

let cassandra = CassandraClient(configuration: configuration)

extension Lambda {
	public static func run<In: Decodable, Out: Encodable>(_ closure: @escaping (Lambda.Context, In) async throws -> Out) {
		self.run { (context: Lambda.Context, input: In, completion: @escaping (Result<Out, Error>) -> Void) in
			Task {
				do {
					let out = try await closure(context, input)

					completion(.success(out))
				} catch {
					completion(.failure(error))
				}
			}
		}
	}
}

Lambda.run { (context, request: APIGateway.V2.Request) async throws -> APIGateway.V2.Response in
	let results: [TableModel] = try await cassandra.query("SELECT * FROM test_table")

	let data = try JSONEncoder().encode(results)

	return APIGateway.V2.Response(statusCode: .accepted,
									body: String(data: data, encoding: .utf8)!,
								isBase64Encoded: false)
}
