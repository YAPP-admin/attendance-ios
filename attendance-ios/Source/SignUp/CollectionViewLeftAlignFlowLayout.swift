//
//  CollectionViewLeftAlignFlowLayout.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/07.
//

import UIKit

final class CollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {

    private let cellSpacing: CGFloat

    init(cellSpacing: CGFloat) {
        self.cellSpacing = cellSpacing
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        self.minimumLineSpacing = cellSpacing
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0

        attributes.forEach { attribute in
            if attribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            attribute.frame.origin.x = leftMargin
            leftMargin += attribute.frame.width + cellSpacing
            maxY = max(attribute.frame.maxY, maxY)
        }

        return attributes
    }

}
