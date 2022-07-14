//
//  ViewController.swift
//  GitaRama
//
//  Created by David James on 2022-05-26.
//

import C3
import Combine

// https://bhagavadgitaapi.in/
// Free but may want a donation for paid apps.
// Includes a ton of translations.

// Bits & Bobs
// - Combine (data task pub, flatMap)
// - Async/await/tasks
// - MVVM
// - Coordinator
// - UserDefaults 
// - Collection view
// - Master/detail navigation
// - Core data
// - Search
// - Unit tests (app)

// Bonus Bits
// - Keychain (for token)
// - Cloudkit (for saving faves)
// - GRDB (e.g. FTS)
// - Xcode Cloud

class MainVc: ExtendedViewController<Theme>, SafeLayout, CoordinatorAccessible {
    
    var coordinator: Coordinator?
            
    func updateLayout(update: Update) {
        View()
            .in(view, options:.reusable)
            .color(colors.background)
            .make {
                Button()
                    .in($0, data:[
                        ("Chapters", { [weak self] in self?.coordinator?.viewChapters() }),
                        ("Summaries", { [weak self] in self?.coordinator?.viewChapterSummaries() })
                    ])
                    .emanateVertically(offset:10.0...20.0)
            }
    }
    
    class Button : C3.Button, LiveWithData, Themeable, ControlStateUpdatable {
        typealias Router = ()->()?
        typealias Model = (title:String, router:Router)
        func live(data: Model, update: Update) {
            onCreate { $0
                .text(data.title)
            }
            .onTap { _ in
                data.router()
            }
            .onRequiredUpdate { $0
                .applyThemeAndFit()
                .center()
            }
        }
        static var theme: Theme {[
            Self.self => [
                .typographicContextual {[
                    .systemFont(size:5%, reference:>View.self, relativeAxis:$0.isPortrait ? .vertical : .horizontal, weight:.bold)
                ]}
            ],
            Self.self + .normal => [
                .textColor(colors.text)
            ],
            Self.self + .highlighted => [
                .textColor(colors.accent)
            ]
        ];}
    }

}

