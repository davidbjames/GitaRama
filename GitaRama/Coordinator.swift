//
//  Coordinator.swift
//  GitaRama
//
//  Created by David James on 6/21/22.
//

import Foundation
import UIKit

class Coordinator {
    
    let navController:UINavigationController
    
    lazy var rootController:MainVc = {
        navController.viewControllers.first as! MainVc
    }()
    
    init(_ nav:UINavigationController) {
        self.navController = nav
        // Nav controller setup here:
    }
    func start() {
        let root = MainVc()
        root.coordinator = self
        navController.pushViewController(root, animated:false)
    }
    // Coordinator API here:
    func viewChapters() {
        let chapters = ChaptersVc()
        chapters.coordinator = self
        chapters.title = NSLocalizedString("Chapters", comment: "Title shown above list of Gita chapters.")
        navController.pushViewController(chapters, animated:true)
    }
    func viewChapterSummaries() {
        let summaries = ChapterSummariesVc()
        summaries.coordinator = self 
        summaries.title = NSLocalizedString("Summaries", comment: "Title shown above list of Gita chapter summaries.")
        navController.pushViewController(summaries, animated:true)
    }
    func viewChapter(_ chapter:Chapter) {
        print("TODO: moving to chapter no.", chapter.number)
    }
}

/// Any view controller that can access it's coordinator.
///
/// The coordinator should be stored strongly on the root view
/// controller to keep it alive, but weakly on sub-view controllers.
protocol CoordinatorAccessible : UIViewController {
    /* weak */ var coordinator: Coordinator? { get set }
}
