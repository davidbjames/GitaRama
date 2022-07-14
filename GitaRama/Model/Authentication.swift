//
//  Authentication.swift
//  GitaRama
//
//  Created by David James on 6/8/22.
//

import Foundation
import Unilib

struct Authentication : Codable {
    let token:Token?
    let type:String
    let scope:Scope
    struct Token : Codable {
        let value:String
        func encode(to encoder: Encoder) throws {
            // Ensure this is persisted locally.
            var container = encoder.singleValueContainer()
            try container.encode(value)
        }
    }
    struct Scope : OptionSet, Codable {
        let rawValue:Int
        init(rawValue:Int) {
            self.rawValue = rawValue
        }
        static let chapter = Scope(rawValue: 1 << 0)
        static let verse = Scope(rawValue: 1 << 1)
        func encode(to encoder: Encoder) throws {
            // Ensure this can be persisted locally in the
            // same format as came from the server (string)
            var parts = [String]()
            if contains(.verse) {
                parts.append("verse")
            }
            if contains(.chapter) {
                parts.append("chapter")
            }
            let value = parts.joined(separator:"%20")
            var container = encoder.singleValueContainer()
            try container.encode(value)
        }
    }
    enum CodingKeys : String, CodingKey {
        case token = "access_token"
        case type = "token_type"
        case scope = "scope"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let accessToken = try? container.decode(String.self, forKey:.token) {
            self.token = Token(value:accessToken)
        } else {
            self.token = nil
        }
        self.type = try container.decode(String.self, forKey:.type)
        let stringScope = try container.decode(String.self, forKey:.scope)
        let parts = stringScope.components(separatedBy:" ")
        var scope = Scope()
        for part in parts {
            switch part {
            case "verse" :
                scope.formUnion(.verse)
            case "chapter" :
                scope.formUnion(.chapter)
            default :
                continue
            }
        }
        self.scope = scope 
    }
    init(token:Token? = nil, scope:Scope = .chapter.union(.verse)) {
        self.token = token
        self.type = "Bearer"
        self.scope = scope
    }
    static func restore() -> Self {
        UserDefaults.standard.codable(Self.self, forKey:"auth", debug:true) ?? Authentication()
    }
    func store() {
        UserDefaults.standard.setCodable(self, forKey:"auth", debug:true)
    }
    func invalidateToken() -> Self {
        // uncomment this when auth flow is working
//        UserDefaults.standard.removeObject(forKey:"auth")
        return Authentication(token:nil, scope:scope)
    }
}
