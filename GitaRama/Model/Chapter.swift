//
//  Chapter.swift
//  GitaRama
//
//  Created by David James on 6/3/22.
//

import Foundation

struct ChapterRaw : Codable, Equatable {
    let chapter_number:Int
    let verses_count:Int
    let name:String
    let translation:String
    let transliteration:String
    let meaning:[String:String]
    let summary:[String:String]
}

struct Chapter : Identifiable, Equatable, Hashable {
    var id:Int { number }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    init(raw:ChapterRaw) {
        self.number = raw.chapter_number
        self.versesCount = raw.verses_count
        self.name = .init(english:raw.translation, hindi:raw.name, transliteration:raw.transliteration)
        self.meaning = .init(
            english: raw.meaning["en"] ?? "'meaning.en' is missing",
            hindi: raw.meaning["hi"] ?? "'meaning.hi' is missing"
        )
        self.summary = .init(
            english: raw.meaning["en"] ?? "'summary.en' is missing",
            hindi: raw.meaning["hi"] ?? "'summary.hi' is missing"
        )
    }
    struct Name : Equatable {
        let english:String
        let hindi:String
        let transliteration:String
    }
    struct Meaning : Equatable {
        let english:String
        let hindi:String
    }
    struct Summary : Equatable {
        let english:String
        let hindi:String
    }
    let number:Int
    let versesCount:Int
    let name:Name
    let meaning:Meaning
    let summary:Summary
}

extension Array where Element == Chapter {
    var toDataSourceItems:[ChapterItem] {
        map { .item($0.id) }
    }
}
