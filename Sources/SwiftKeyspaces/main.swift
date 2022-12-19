import AWSLambdaRuntime
import CassandraClient

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

var configuration = CassandraClient.Configuration(contactPointsProvider: { callback in
	let points = ["cassandra.us-east-2.amazonaws.com"]

	callback(.success(points))
}, port: 9142, protocolVersion: .v4)

configuration.consistency = .localQuorum
configuration.username = "abc"
configuration.password = "def"
configuration.keyspace = "test"

var ssl = CassandraClient.Configuration.SSL()

ssl.verifyFlag = CassandraClient.Configuration.SSL.VerifyFlag.none
ssl.cert = "path/to/sf-class2-root.crt"
//configuration.ssl = ssl

let cassandra = CassandraClient(configuration: configuration)

Lambda.run { (context, input: Input, completion: @escaping (Result<Output, Error>) -> Void) in
	completion(.success(Output(message: "world")))
}
