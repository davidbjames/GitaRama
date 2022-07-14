//
//  ChaptersHeader.swift
//  GitaRama
//
//  Created by David James on 7/8/22.
//

import C3

struct ChaptersTitle : Hashable {
    let title:String
}

class ChaptersHeader : CollectionReusableView, LiveWithData, ModelAccessible, Themeable {
    typealias Model = ChaptersTitle
    typealias Item = ChapterItem
    typealias Section = ChapterSection
    func live(data chapter: Model, update: Update) {
        onRequiredUpdate { $0
            .height(15%)
            .applyTheme()
        }
        .onRequiredUpdateMake {
            DisplayText(insets:16.0...25.0)
                .in($0, options:.reusable)
                .text("\(chapter.title)")
                .applyTheme()
        }
    }
    func modelForSectionIdentifier(section: ChapterSection) -> ChaptersTitle? {
        ChaptersTitle(title: "Welcome to the Holy Bhagavad Gita")
    }
    static var theme: Theme {[
        Self.self => [
            .color(colors.backgroundLuminance())
        ],
        DisplayText.self => [
            .font(fonts.display),
            .textColor(colors.text),
            .fontSizeToFill(allowOverflow:false)
        ]
    ];}
}

