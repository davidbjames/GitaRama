//
//  ChapterSummariesVc.swift
//  GitaRama
//
//  Created by David James on 6/30/22.
//

import C3
import Combine

class ChapterSummariesVc : ExtendedViewController<Theme>, SafeLayout, CoordinatorAccessible, UICollectionViewDelegate {
    
    weak var coordinator: Coordinator?
        
    func updateLayout(update: Update) {
    
        CollectionView<ChapterSection,ChapterItem>()
            .in(view, options:.reusable)
            //.delegate(self)
            .compositional(update) {
                let loading = $0.registerCell(LoadingCell.self)
                let error = $0.registerCell(ErrorCell.self)
                let chapterSummary = $0.registerCell(ChapterSummaryCell.self)
                // NOT TESTED YET
                let chapterTag = $0.registerSupplementary(ChapterTag.self, kind:"tag")
                // NOTE: headers/footers in compositional layouts require
                // specifying the header (aka "boundary supplementary")
                // in the compositional layout (api tbd).
//                let header = BoundaryRegistration<ChaptersHeader>(in:$0, boundary:.header)
                
                cells(in:$0) { collection, index, item in
                    switch item {
                    case .loading : // TODO (initial state)
                        return collection.dequeueCell(
                            using: loading,
                            for: index,
                            model: true
                        )
                    case .error(let message) :
                        return collection.dequeueCell(
                            using: error,
                            for: index,
                            model: message
                        )
                    case .item(let id) :
                        return collection.dequeueCell(
                            using: chapterSummary,
                            for: index,
                            model: ClientAPI.chapters[id-1]
                        )
                    }
                }
                .sections { dataSource, section, environment in
                    guard
                        let section = dataSource.sectionIdentifier(for:section)
                    else {
                        return .singleColumnList(environment)
                    }
                    switch section {
                    case .main where environment.container.effectiveContentSize.width > 500.0 :
                        return .dualColumnList(environment)
                    case .main, .single :
                        return .singleColumnList(environment)
                    }
                }
                .supplementary { collection, kind, index in
                    // Can switch on kind to return different types of supplementary views.
                    // If list is in headerMode or footerMode use the appropriate identifer:
                    print(kind)
                    switch kind {
                    case UICollectionView.elementKindSectionHeader :
                        break
                    case UICollectionView.elementKindSectionFooter :
                        break
                    default :
                         break
                    }

                    return collection.dequeueSupplementary(
                        using: chapterTag,
                        for: index
                    )
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
                action: { chapters, collectionView in
                    var snapshot = NSDiffableDataSourceSnapshot<ChapterSection,ChapterItem>()
                    snapshot.appendSections([.main])
                    snapshot.appendItems(chapters.toDataSourceItems)
                    collectionView.diffableDataSource?.apply(snapshot, animatingDifferences:true)
                },
                completion: { _,_ in
                    
                }
            )
            .onItemSelect { info, cell in
                guard
                    info.isSelected, case let .item(id) = info.item
                else {
                    cell.base?.deselectItem(at:info.indexPath, animated:true)
                    return
                }
                self.coordinator?.viewChapter(ClientAPI.chapters[id-1])
            }
    }
    
    /*
    Equivalent "item select" using delegate:
     
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let dataSource = (collectionView as? CollectionView<ChapterSection,ChapterItem>)?.diffableDataSource,
            let item = dataSource.itemIdentifier(for:indexPath),
            case let .item(id) = item
        else {
            collectionView.deselectItem(at:indexPath, animated:true)
            return
        }
        coordinator?.viewChapter(ClientAPI.chapters[id-1])
    }
    */
}

private extension NSCollectionLayoutSection {
    
    typealias SectionBuilder = (_ environment:NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
    
    static let dualColumnList:SectionBuilder = { environment in
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(16)
        // Sections can also just be lists..
        // let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        // NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 16
        return section
    }

    static let singleColumnList:SectionBuilder = { environment in
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize,
            subitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 16
        return section
    }
}
