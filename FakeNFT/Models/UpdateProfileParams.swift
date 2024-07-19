import Foundation

struct UpdateProfileParams {
    let profileId: String
    let name: String?
    let description: String?
    let website: String?
    let likes: [String]?
    let avatar: String?
    
    init(
        profileId: String = "1",
        name: String? = nil,
        description: String? = nil,
        website: String? = nil,
        likes: [String]? = nil,
        avatar: String? = nil
    ) {
        self.profileId = profileId
        self.name = name
        self.description = description
        self.website = website
        self.likes = likes
        self.avatar = avatar
    }
}
