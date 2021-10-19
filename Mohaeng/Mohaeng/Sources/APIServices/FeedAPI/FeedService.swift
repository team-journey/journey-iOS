//
//  FeedService.swift
//  Journey
//
//  Created by 윤예지 on 2021/07/13.
//

import Foundation
import UIKit
import Moya

enum FeedService {
    case getAllFeed
    case getMyDrawer(year: Int, month: Int)
    case postFeed(content: String, mood: Int, isPrivate: Bool, image: UIImage?)
}
// {"content": "엄마 나 모행 다녀올게", "mood": 2, "isPrivate": false}

extension FeedService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getAllFeed, .postFeed:
            return Const.URL.feedURL
        case .getMyDrawer(let year, let month):
            return Const.URL.feedURL + "/\(year)" + "/\(month)"
        }
    
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllFeed, .getMyDrawer:
            return .get
        case .postFeed:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getAllFeed, .getMyDrawer:
            return .requestPlain
        case .postFeed(let content, let mood, let isPrivate, let image):
            var multiPartFormData: [MultipartFormData] = []
            let json: [String: Any] = [
                "content": content,
                "mood": mood,
                "isPrivate": isPrivate
            ]

            let jsondata = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            guard let data = jsondata else { return .uploadMultipart([]) }

            let jsonString = String(data: data, encoding: .utf8)!
            let multipartData = MultipartFormData(provider: .data(jsonString.data(using: String.Encoding.utf8)!), name: "feed")
            multiPartFormData.append(multipartData)
            
            if let image = image,
               let imageData = image.jpegData(compressionQuality: 1.0) {
                let imgData = MultipartFormData(provider: .data(imageData), name: "image", fileName: "image", mimeType: "image/jpeg")
                multiPartFormData.append(imgData)
            }

            return .uploadMultipart(multiPartFormData)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getAllFeed, .getMyDrawer:
            return [
                "Content-Type": "application/json",
                "Bearer": UserDefaults.standard.string(forKey: "jwtToken") ?? ""
            ]
        case .postFeed:
            return [
                "Content-Type": "multipart/form-data",
                "Bearer": UserDefaults.standard.string(forKey: "jwtToken") ?? ""
            ]
        
        }
    }
    
}
