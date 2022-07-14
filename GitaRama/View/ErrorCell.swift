//
//  ErrorCell.swift
//  GitaRama
//
//  Created by David James on 6/21/22.
//

import C3

class ErrorCell : CollectionViewCell, LiveWithData, Themeable {
    typealias Model = String
    func live(data error:String, update: Update) {
        mutate
            .contentView
            .onRequiredUpdateBuild {
                TextLayer()
                    .in($0, options:.reusable)
            }
            .text(error)
            .applyThemeAndFit()
            .center()
    }
    static var theme: Theme {[
        Self.self => [
            .typographicContextual {[
                .fontSize(5%, reference:>View.self, relativeAxis:$0.isPortrait ? .vertical : .horizontal),
            ]},
            .textColor(colors.text)
        ],
    ];}
}

// use update with data interface for updating the error message
