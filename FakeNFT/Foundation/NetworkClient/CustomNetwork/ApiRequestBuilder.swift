import Foundation

// MARK: - ApiRequestBuilderProtocol

protocol ApiRequestBuilderProtocol: AnyObject {
    func getNft(nftId: String) -> URLNetworkRequest?
    func getProfile(profileId: String) -> URLNetworkRequest?
    func updateProfile(profileId: String, name: String?, description: String?, website: String?, likes: [String]?, avatar: String?) -> URLNetworkRequest?
    func getOrder(orderId: String) -> URLNetworkRequest?
    func updateOrder(orderId: String, nftIds: [String]) -> URLNetworkRequest?
}

// MARK: - ApiRequestBuilder

final class ApiRequestBuilder: ApiRequestBuilderProtocol {
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
    
    func updateProfile(profileId: String, name: String?, description: String?, website: String?, likes: [String]?, avatar: String?) -> URLNetworkRequest? {
        let endpoint = "/api/v1/profile/\(profileId)"
        guard let url = URL(string: RequestConstants.baseURL + endpoint) else {
            return nil
        }
        
        var profileData: String = ""
        if let name = name {
            profileData += "&name=\(name)"
        }
        if let avatar = avatar {
            profileData += "&avatar=\(avatar)"
        }
        if let description = description {
            profileData += "&description=\(description)"
        }
        if let website = website {
            profileData += "&website=\(website)"
        }
        if let likes = likes {
            for like in likes {
                profileData += "&likes=\(like)"
            }
        }
        
        guard let requestBodyData = profileData.data(using: .utf8) else {
            return nil
        }
        
        return URLNetworkRequest(endpoint: url, httpMethod: .put, dto: requestBodyData, isUrlEncoded: true)
    }
    
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

