import Foundation

struct NFTRequest: NetworkRequest {

    let id: String
    var token: String? = RequestConstants.tokenValue

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
    
    var httpMethod: HttpMethod {
        .get
    }
}
