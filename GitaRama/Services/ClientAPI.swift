//
//  ClientAPI.swift
//  GitaRama
//
//  Created by David James on 6/21/22.
//

import Foundation
import Unilib

class ClientAPI {
    static var chapters:[Chapter]!
//    = (0..<100).map {
//        Chapter(number:$0, versesCount: 2, name:.init(english:"\($0): Hello World", hindi:"", transliteration:""), meaning:.init(english:"", hindi:""), summary:.init(english:"", hindi:""))
//    }
    static func loadChapters() async throws -> [Chapter] {
        if let chapters = Self.chapters {
            return chapters
        }
        let chapters:[Chapter] = try await ServerAPI.fetch(.chapters()).map { Chapter(raw:$0) }
        Self.chapters = chapters
        return chapters
    }
}
