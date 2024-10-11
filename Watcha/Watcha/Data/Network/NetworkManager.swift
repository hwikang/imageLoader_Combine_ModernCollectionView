//
//  NetworkManager.swift
//  Watcha
//
//  Created by hwikang on 10/11/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(urlString: String, httpMethod: HTTPMethod, headers: [String: String]?, queryParams: [String: Any]?) async -> Result<T,NetworkError>
}

struct NetworkManager: NetworkManagerProtocol {
    private let session: URLSession
    init(session: URLSession) {
        self.session = session
        
    }
    
    func fetchData<T: Decodable>(urlString: String, httpMethod: HTTPMethod, headers: [String: String]?, queryParams: [String: Any]?) async -> Result<T,NetworkError> {

        guard let url = URL(string: urlString),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return .failure(NetworkError.urlError(urlString))
        }
        debugPrint("URL - \(url)")
        
        components.queryItems = queryParams?.compactMap({ key, value in
            return URLQueryItem(name: key, value: "\(value)")
        })

        guard let url = components.url else { return .failure(.invalidQueryParams)}
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
            let (data, response) = try await session.data(for: request)
            guard let response =  response as? HTTPURLResponse else { return .failure(NetworkError.invalid) }
            if 200..<400 ~= response.statusCode {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    return .success(decodedData)
                } catch let error {
                    debugPrint(error)
                    return .failure(NetworkError.failToDecode(error.localizedDescription))
                }
            } else {
                return .failure(.serverError(response.statusCode))
            }

        } catch let error {
            return .failure(NetworkError.requestFailed(error.localizedDescription))
        }
    }
}
