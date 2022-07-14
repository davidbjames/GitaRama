//
//  ChapterCell.swift
//  GitaRama
//
//  Created by David James on 6/21/22.
//

import C3

class ChapterCell : CollectionViewListCell<Chapter> {
    
//    override func update(with chapter:Chapter, update:Update) {
//        if configurationState.isSelected {
//            // ?
//        }
//        super.update(with:chapter, update:update)
//        // This ^^ sets chapter on self and then triggers configuration update vv.
//    }
    
    override func updateConfiguration(using state:UICellConfigurationState) {

        // TODO: consider wrapping this API
        
        if state.isSelected {
            accessories = [.disclosureIndicator()]
        } else {
            accessories = []
        }
        
        var content = defaultContentConfiguration().updated(for:state)
        content.image = UIImage(systemName: "heart")
        content.text = item?.name.english
        if state.isHighlighted {
            content.imageProperties.tintColor = Theme.colors.accent.ui
            content.textProperties.color = Theme.colors.accent.ui
        } else if state.isSelected {
            content.imageProperties.tintColor = Color.white.ui
        } else {
            content.imageProperties.tintColor = Theme.colors.decoration.ui
        }
        contentConfiguration = content
        
        var background = UIBackgroundConfiguration.listSidebarCell().updated(for:state)
        if state.isSelected {
            background.backgroundColor = Theme.colors.accent.ui
        }
        UIView.animate(withDuration:0.5) {
            self.backgroundConfiguration = background
        }
         
//        background.strokeWidth = 1.0
//        background.strokeColor = colors.decoration.ui
//        background.cornerRadius = 20.0
//        backgroundConfiguration = background
    }
}

extension UIConfigurationStateCustomKey {
    static let chapter = UIConfigurationStateCustomKey("com.gitarama.chapter")
}

extension UICellConfigurationState {
    var chapter:Chapter {
        get { return self[.chapter] as! Chapter }
        set { self[.chapter] = newValue }
    }
}

// Cell configuration learnings:
// - To get all the affordances of standard cell UI you must
//   use one of the built-in configurations for the content.
// - If using a *background* configuration, in order for changes
//   to it to have any effect, you must use one of the built-in
//   *content* configurations alongside.
// - Example:
//   contentConfiguration = UIListContentConfiguration.sidebarCell()
//   backgroundConfiguration = UIBackgroundConfiguration.listSidebarCell()
//   (normally you make a var for each ^^, configure, then set)
// - Custom backgrounds (e.g. via "contentView") are mutually exclusive
//   of system background configurations (custom will cover system).
// - Configuration states such as UICellConfigurationState provides
//   trait collection, control states, cell states but can also
//   hold your own custom states which are added/retrieved using
//   custom state keys and can include for example a "view model".
// - Example trait/cell/control/custom states: https://a.cl.ly/DOudm5dy
// - Configuration state can be used to update the configuration.
//   It also exists on the cell as "configurationState"
// - NOTE: when overriding "updateConfiguration(using:)" be sure
//   to set "automaticallyUpdatesContentConfiguration" to false
//   (as well as the background equiv.). Conversly if you just
//   rely entirely on system configuration handling then much
//   of the behavior you would expect (e.g. selected states)
//   should just occur automatically (the default).

