//
//  ServerAPI.swift
//  GitaRama
//
//  Created by David James on 6/21/22.
//

import Foundation

struct ServerAPI {
    enum Route {
        case chapters(chapter:Int? = nil)
        case verse(chapter:Int, verse:Int)
    }
    static func fetch<T:Codable>(_ route: Route) async throws -> [T] {
        var url = URL(string:"https://bhagavadgitaapi.in")!
        switch route {
        case .chapters(let chapter?) :
            if let storedChapter = UserDefaults.standard.codable([T].self, forKey:"chapter-\(chapter)") {
                return storedChapter
            }
            url.appendPathComponent("chapter")
            url.appendPathComponent("\(chapter)")
        case .chapters :
            if let storedChapters = UserDefaults.standard.codable([T].self, forKey:"chapters", debug:true) {
                return storedChapters
            }
            url.appendPathComponent("chapters")
        case let .verse(chapter, verse) :
            // TODO storage
            url.appendPathComponent("slok")
            url.appendPathComponent("\(chapter)")
            url.appendPathComponent("\(verse)")
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard
            let (data, _) = try? await URLSession.shared.data(for: request)
        else {
            return []
        }
        let result = try JSONDecoder().decode([T].self, from:data)
        switch route {
        case .chapters(let chapter?) :
            UserDefaults.standard.setCodable(result, forKey:"chapter-\(chapter)")
        case .chapters :
            UserDefaults.standard.setCodable(result, forKey:"chapters", debug:true)
        case .verse(_, _) :
            break // TODO
        }
        return result
    }
}

enum ServerError : Error {
    case unauthorized, invalidResponse, rateLimited, serverBusy
}
