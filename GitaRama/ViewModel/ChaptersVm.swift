//
//  ChaptersVm.swift
//  GitaRama
//
//  Created by David James on 6/21/22.
//

import Foundation
import C3
// import Combine

/*
class ChaptersVm {
    
    weak var collectionView:CollectionView?
    
    var data:[Chapter]?
    
    private(set) var state:CollectionState<Chapter> = .idle {
        didSet {
            collectionView
        }
    }
    
    init(_ collectionView:CollectionView) {
        self.collectionView = collectionView
//        super.init()
    }
    
    private func loadData() async {
        do {
            data = try await ServerAPI.fetch(.chapters())
            // how to reload with diffable data source?
//            collectionView?.reloadData()
        } catch let error {
            print(error)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        data?.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        collectionView.dequeueReusableCell(withReuseIdentifier:"chapter", for:indexPath)
//    }
}

*/
