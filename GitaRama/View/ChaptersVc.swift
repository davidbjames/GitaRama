//
//  ChaptersVc.swift
//  GitaRama
//
//  Created by David James on 6/21/22.
//

import Foundation
import C3
import Combine

// In addition to "bits & bobs" goals,
// collection view API "goals" as follows:
// - Continue watching/noting/implementing WWDC UICollectionView videos
// - Continue referencing "Modern Collection Views" project
// - Create API for compositional section building (inline with above two ^^)
// - See TBD in UICollectionView.swift re: C3.CollectionView trickling into providers..
// - Question: why are selections not maintained on rotation (reload)?
// - Sort out sections/items vv - can make default with default behavior
//   including sensible "loading" and error handling?
//   OR, even DefaultCollectionView which wraps standard section/item
//   and behaviors.
// - Create API for list configuration (if it makes sense)
// - Experiment with per-cell supplementary (see ChapterTag)
// - Create Chapter view which will be an async loading of
//   each verse, and possibly as interesting compositional layout
// - Experiment with dynamic type sizes with custom cells (e.g. summaries)
//   See also Properties+Typographic for add'l dynamic type support notes.
// - Experiment with UIListContentView which can be embedded in
//   a custom cell but take advantage of configuration, if this is useful

enum ChapterSection : Hashable {
    /// Section for loading or error UI
    case single
    /// Section for main content
    case main
}

enum ChapterItem : Hashable {
    case loading
    case error(String)
    case item(Int)
}

enum CollectionState<T> : Equatable where T:Equatable {
    case idle
    case loading
    case loaded([T])
    case failed(String)

    var canLoad: Bool {
        switch self {
        case .idle, .failed:
            return true
        case .loading, .loaded:
            return false
        }
    }
}

class ChaptersVc : ExtendedViewController<Theme>, SafeLayout, CoordinatorAccessible, UICollectionViewDelegate {
    
    weak var coordinator: Coordinator?
    
    func updateLayout(update: Update) {
        
        // NOTE: The registered cells have generic data models via UpdatableWithData
        // ensuring that the updates (via update() or optional handlers) are provided
        // the appropriate data. These models are distinct from the CollectionView
        // "ChapterSection" and "ChapterItem" which are representations of the type
        // of section or item, including item id (which can be used to look up the
        // appropriate model). These Hashable "identifiers" are used for looking up
        // cells (vs. old index path method). Lookups are constant time.
        
        CollectionView<ChapterSection,ChapterItem>()
            .in(view, options:.reusable)
            .delegate(self)
            .list(update) {
                let loadingCell = $0.registerCell(LoadingCell.self)
                let errorCell = $0.registerCell(ErrorCell.self)
                let chapterCell = $0.registerCell(ChapterCell.self) { cell, index, chapter in
                    cell.automaticallyUpdatesBackgroundConfiguration = false
                }
                let header = $0.registerHeader(ChaptersHeader.self)

                cells(in:$0) { collection, index, item in
                    switch item {
                    case .loading : // TODO (initial state)
                        return collection.dequeueCell(
                            using: loadingCell,
                            for: index,
                            model: true
                        )
                    case .error(let message) :
                        return collection.dequeueCell(
                            using: errorCell,
                            for: index,
                            model: message
                        )
                    case .item(let id) :
                        return collection.dequeueCell(
                            using: chapterCell,
                            for: index,
                            model: ClientAPI.chapters[id-1]
                        )
                    }
                }
                .appearance(.sidebarPlain)
                .header { collection, index in
                    collection.dequeueSupplementary(using:header, for:index)
                }
            }
            .onReceive(
                Future<[Chapter],ServerError> { promise in
                    Task {
                        let result = try await ClientAPI.loadChapters()
                        promise(.success(result))
                    }
                },
                subscription: nil,
                action: { chapters, collectionViews in
                    var snapshot = NSDiffableDataSourceSnapshot<ChapterSection,ChapterItem>()
                    snapshot.appendSections([.main])
                    snapshot.appendItems(chapters.toDataSourceItems)
                    collectionViews.edit {
                        $0.diffableDataSource?.apply(snapshot, animatingDifferences:true)
                    }
                },
                completion: { _,_ in
                    
                }
            )
    }
}

