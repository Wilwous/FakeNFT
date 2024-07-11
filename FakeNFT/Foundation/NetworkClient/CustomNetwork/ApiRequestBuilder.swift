import Foundation

// MARK: - ApiRequestBuilderProtocol

protocol ApiRequestBuilderProtocol: AnyObject {
    func getNft(nftId: String) -> URLNetworkRequest?
    func getProfile(profileId: String) -> URLNetworkRequest?
    func updateProfile(params: UpdateProfileParams) -> URLNetworkRequest?
    func getOrder(orderId: String) -> URLNetworkRequest?
    func updateOrder(orderId: String, nftIds: [String]) -> URLNetworkRequest?
}

// MARK: - ApiRequestBuilder

final class ApiRequestBuilder: ApiRequestBuilderProtocol {
    
    // MARK: - Nft Methods
    
    func getNft(nftId: String) -> URLNetworkRequest? {
        let endpoint = "/api/v1/nft/\(nftId)"
        guard let url = URL(string: RequestConstants.baseURL + endpoint) else {
            print("Ошибка: Невалидный URL")
            return nil
        }
        
        return URLNetworkRequest(endpoint: url, httpMethod: .get)
    }
    
    // MARK: - Profile Methods
    
    func getProfile(profileId: String) -> URLNetworkRequest? {
        return buildRequest(endpoint: "/api/v1/profile/\(1)", method: .get)
    }
    
    func updateProfile(params: UpdateProfileParams) -> URLNetworkRequest? {
        let endpoint = "/api/v1/profile/\(params.profileId)"
        guard let url = URL(string: RequestConstants.baseURL + endpoint) else {
            return nil
        }
        
        var parameters: [String] = []
        if let name = params.name {
            parameters.append("name=\(name)")
        }
        if let avatar = params.avatar {
            parameters.append("avatar=\(avatar)")
        }
        if let description = params.description {
            parameters.append("description=\(description)")
        }
        if let website = params.website {
            parameters.append("website=\(website)")
        }
        if let likes = params.likes {
            parameters.append("likes=\(likes.joined(separator: ","))")
        }
        
        let requestBodyString = parameters.joined(separator: "&")
        guard let requestBodyData = requestBodyString.data(using: .utf8) else {
            return nil
        }
        
        return URLNetworkRequest(
            endpoint: url,
            httpMethod: .put,
            dto: requestBodyData,
            isUrlEncoded: true
        )
    }
    
    // MARK: - Order Methods
    
    func getOrder(orderId: String) -> URLNetworkRequest? {
        return buildRequest(endpoint: "/api/v1/orders/\(orderId)", method: .get)
    }
    
    func updateOrder(orderId: String, nftIds: [String]) -> URLNetworkRequest? {
        let endpoint = "/api/v1/orders/\(orderId)"
        guard let url = URL(string: RequestConstants.baseURL + endpoint) else { return nil }
        
        let nftsJoined = nftIds.joined(separator: ",")
        let requestBodyString = nftIds.isEmpty ? "" : "nfts=\(nftsJoined)"
        let requestBodyData = requestBodyString.data(using: .utf8)
        
        return URLNetworkRequest(endpoint: url, httpMethod: .put, dto: requestBodyData, isUrlEncoded: true)
    }
    
    // MARK: - Private Methods
    
    private func buildRequest(endpoint: String, method: HttpMethod, parameters: Encodable? = nil, isUrlEncoded: Bool = false) -> URLNetworkRequest? {
        guard let token = TokenManager.shared.token else {
            assertionFailure("Token should be set")
            return nil
        }
        
        let urlString = "\(RequestConstants.baseURL)\(endpoint)"
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLNetworkRequest(endpoint: url, httpMethod: method)
        request = request.update(dto: parameters)
        request = request.update(isUrlEncoded: isUrlEncoded)
        request = request.update(token: token)
        return request
    }
}

