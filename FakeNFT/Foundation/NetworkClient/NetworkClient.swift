import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
}

// MARK: - Protocol

protocol NetworkClient {
    @discardableResult
    func send(
        request: NetworkRequest,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) -> NetworkTask?
    
    @discardableResult
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) -> NetworkTask?
}

extension NetworkClient {
    
    @discardableResult
    func send(
        request: NetworkRequest,
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) -> NetworkTask? {
        send(request: request, completionQueue: .main, onResponse: onResponse)
    }
    
    @discardableResult
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) -> NetworkTask? {
        send(request: request, type: type, completionQueue: .main, onResponse: onResponse)
    }
}

struct DefaultNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder()) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }
    
    @discardableResult
    func send(
        request: NetworkRequest,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) -> NetworkTask? {
        let onResponse: (Result<Data, Error>) -> Void = { result in
            completionQueue.async {
                onResponse(result)
            }
        }
        guard let urlRequest = create(request: request) else { return nil }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                onResponse(.failure(NetworkClientError.urlSessionError))
                return
            }
            
            guard 200 ..< 300 ~= response.statusCode else {
                onResponse(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                return
            }
            
            if let data = data {
                onResponse(.success(data))
                return
            } else if let error = error {
                onResponse(.failure(NetworkClientError.urlRequestError(error)))
                return
            } else {
                assertionFailure("Unexpected condition!")
                return
            }
        }
        
        task.resume()
        
        return DefaultNetworkTask(dataTask: task)
    }
    
    @discardableResult
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) -> NetworkTask? {
        return send(request: request, completionQueue: completionQueue) { result in
            switch result {
            case let .success(data):
                self.parse(data: data, type: type, onResponse: onResponse)
            case let .failure(error):
                onResponse(.failure(error))
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func create(request: NetworkRequest) -> URLRequest? {
        guard let endpoint = request.endpoint else {
            assertionFailure("Empty endpoint")
            return nil
        }
        
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        setAuthHeaders(for: &urlRequest, with: request.token)
        setBody(for: &urlRequest, from: request)
        
        return urlRequest
    }
    
    private func setAuthHeaders(for urlRequest: inout URLRequest, with token: String?) {
        if let authToken = token {
            urlRequest.setValue(
                authToken,
                forHTTPHeaderField: RequestConstants.tokenKey
            )
        }
        urlRequest.setValue(
            RequestConstants.tokenValue,
            forHTTPHeaderField: RequestConstants.tokenKey
        )
        urlRequest.setValue(
            RequestConstants.acceptValue,
            forHTTPHeaderField: RequestConstants.acceptKey
        )
    }
    
    private func setBody(for urlRequest: inout URLRequest, from request: NetworkRequest) {
        if let dto = request.dto {
            urlRequest.setValue(
                RequestConstants.acceptValue,
                forHTTPHeaderField: RequestConstants.acceptKey
            )
            urlRequest.setValue(
                RequestConstants.contentTypeValue,
                forHTTPHeaderField: RequestConstants.contentTypeKey
            )
            urlRequest.httpBody = dto as? Data
        } else if request.httpMethod != .get, let body = request.token {
            urlRequest.setValue(
                RequestConstants.contentTypeValue,
                forHTTPHeaderField: RequestConstants.contentTypeKey
            )
            urlRequest.httpBody = body.data(using: .utf8)
        }
    }
    
    private func parse<T: Decodable>(
        data: Data,
        type _: T.Type,
        onResponse: @escaping (Result<T, Error>) -> Void) {
            do {
                let response = try decoder.decode(T.self, from: data)
                onResponse(.success(response))
            } catch {
                onResponse(.failure(NetworkClientError.parsingError))
            }
        }
}
