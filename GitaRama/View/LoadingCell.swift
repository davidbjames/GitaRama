//
//  LoadingCell.swift
//  GitaRama
//
//  Created by David James on 6/21/22.
//

import C3

class LoadingCell : CollectionViewCell, LiveWithData {
    typealias Model = Bool
    func live(data enable:Bool, update: Update) {
//        onRequiredUpdate{ $0
//            // necessary on cell? necessary on contentView?
//            .contentView
//            .stretchToFit()
//        }
        contentView
            .mutate
            .onCreateBuild {
                Spinner()
                    .in($0)
                    .hidesWhenStopped(true)
                    .indicatorStyle(.large)
                    .edit {
                        $0.color = self.colors.text
                    }
                    .animating(true)
            }
            .center()
    }
}
