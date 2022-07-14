//
//  ChapterCell.swift
//  GitaRama
//
//  Created by David James on 6/21/22.
//

import Foundation
import C3

class ChapterSummaryCell : CollectionViewCell, LiveWithData, Themeable {
    typealias Model = Chapter
    func live(data chapter:Model, update:Update) {
        view
            .onCreate { $0
                .applyTheme()
            }
            .onStateChange { $1
                .applyTheme(for:$0.controlState)
                .with { $0.textLayers(Label.self) }
                .applyTheme(for:$0.controlState)
            }
        
        view
            .onCreateBuild {
                Label().in($0, repeat:3)
            }
            .update(with: ["\(chapter.number)", chapter.name.hindi, chapter.name.english])
            .onRequiredUpdate { $0
                .centerVertically()
                .emanateVertically()
            }
            .onPortrait { $0
                .centerHorizontally()
            } else: { $0
                .leading(16.0)
            }
    }
    override var selfSizing: (axis:Layout.Axis, outset:InsetGroup?)? {
        (.vertical, [.vertical:30.0])
    }
    class Label : TextLayer, UpdatableWithData, CustomControl {
        typealias Model = String
        func update(with text: String, update: Update) {
            onCreate{ $0
                .applyTheme()
            }
            .text(text)
            .sizeToFit()
        }
    }
    static var theme: Theme {[
        ContentView.self => [
            .corners(radius:defaults.cornerRadius)
        ],
        ContentView.self + .normal => [
            .color(colors.background)
        ],
        ContentView.self + .selected => [
            .color(colors.accent)
        ],
        Label.self + .normal => [
            .textColor(colors.text)
        ],
        Label.self + .selected => [
            .textColor(Color.white)
        ],
        Label.self & 0 => [
            .fontSize(30.0, reference:nil, relativeAxis:.both)
        ],
        Label.self & 1 => [
            .fontStyle(.bold)
        ]
    ];}
}

// in order for this per-cell supplementary view to show you need to build out the compositional layout (per verbose API) to include the supplementary 

class ChapterTag : CollectionReusableView, LiveWithData, ModelAccessible {
    
    typealias Model = Chapter
    typealias Item = ChapterItem
    typealias Section = ChapterSection
    
    func live(data chapter: Model, update: Update) {
        mutate
            .span(20%)
            .color(colors.backgroundLuminance())
            .corners()
            .make {
                TextLayer()
                    .in($0)
                    .text("\(chapter.number)")
                    .textColor(colors.text)
                    .fontSize(50.0)
                    .sizeToFit()
                    .center()
            }
    }
    func modelForItemIdentifier(item: Item) -> Chapter? {
        if case let .item(id) = item {
            return ClientAPI.chapters[id-1]
        }
        return nil
    }
}
