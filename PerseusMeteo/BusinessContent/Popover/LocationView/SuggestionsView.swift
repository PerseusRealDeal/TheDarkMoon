//  SuggestionsView.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7534 (17.09.2025).
//
//  Copyright © 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7534 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//

import Cocoa

class SuggestionsView: NSScrollView,
                       NSCollectionViewDelegate,
                       NSCollectionViewDataSource,
                       NSCollectionViewDelegateFlowLayout {

    public static var shouldProcessVisisbility = false

    // MARK: - Properties

    public static var single: SuggestionsView?

    public var heightCalculated: CGFloat {
        let height = SuggestionsViewItem.heightConstant * Double(suggestionsArray.count) +
        SuggestionsViewItem.minimumLineSpacing * 2.0
        return height > 55 ? 55 - SuggestionsViewItem.minimumLineSpacing : height
    }

    public var suggestionsArray = [Location]()
    public var collectionView: NSCollectionView?

    // MARK: - Initialization

    required public init?(coder: NSCoder) {
        super.init(coder: coder)

        SuggestionsView.single = self
    }

    public func deselectAllItems() {
        guard let collection = collectionView else { return }
        for index in 0...suggestionsArray.count-1 {
            if let item = collection.item(at: IndexPath(item: index, section: 0)) {
                (item as? SuggestionsViewItem)?.isSelected = false
            }
        }
    }

    // MARK: - NSCollectionViewDataSource Protocol

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection
                        section: Int) -> Int {
        return suggestionsArray.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt
                        indexPath: IndexPath) -> NSCollectionViewItem {

        let index = (indexPath as NSIndexPath).item
        let data = suggestionsArray[index]

        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(
            rawValue: "\(SuggestionsViewItem.self)"), for: indexPath) as? SuggestionsViewItem

        item?.data = data

        return (item) ?? SuggestionsViewItem()
    }

    // MARK: - NSCollectionViewDelegateFlowLayout Protocol

    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSCollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: self.bounds.width, height: SuggestionsViewItem.heightConstant)
    }

    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSCollectionViewLayout,
                        insetForSectionAt section: Int) -> NSEdgeInsets {
        return NSEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }

    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSCollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return SuggestionsViewItem.minimumLineSpacing
    }

    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSCollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
