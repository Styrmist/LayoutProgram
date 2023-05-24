//
//  ListingLayout.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 24.04.2023.
//

import UIKit

protocol ListingLayoutDelegate: AnyObject {
    
    func listingLayout(_ layout: ListingLayout, offsetForItemAt indexPath: IndexPath) -> CGFloat
    func listingLayout(_ layout: ListingLayout, widthForItemAt indexPath: IndexPath) -> CGFloat
    func listingLayout(_ layout: ListingLayout, heightForRowsInSection section: Int) -> CGFloat
    func listingLayout(_ layout: ListingLayout, widthForColumnAtIndex index: Int) -> CGFloat
    
    func widthsOfSideColumn(in layout: ListingLayout) -> CGFloat?
    func heightOfHeaderRow(in layout: ListingLayout) -> CGFloat?
    
}

extension ListingLayoutDelegate {
    
    func heightOfHeaderRowInListing(layout: ListingLayout) -> CGFloat? { nil }
    func widthsOfSideColumnInListing(layout: ListingLayout) -> CGFloat? { nil }
    
}


class ListingLayout: UICollectionViewLayout {
    
    weak var delegate: ListingLayoutDelegate?
    
    var stickyRowHeader = true
    var stickyColumnHeader = true
    var useFirstTableView = true
    
    private var cacheBuilt = false
    private var firstTableViewSet: Bool = false
    
    private lazy var cellCache = [[UICollectionViewLayoutAttributes]]()
    private lazy var rowCache = [UICollectionViewLayoutAttributes]()
    private lazy var columnCache = [UICollectionViewLayoutAttributes]()

    private var firstHeaderCellLayoutAttributes: UICollectionViewLayoutAttributes?
    
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat = 0

    public enum ViewKindType: String {
        
        case rowHeader = "RowHeadlineKind"
        case columnHeader = "ColumnHeaderKind"
        case decorationFirstHeaderCell = "DecorationFirstHeaderCellKind"
        
    }
    
    /// Convenience initializer. Pass delegate and the respective Decoration View types if required.
    convenience init(
        delegate: ListingLayoutDelegate?,
        firstHeaderCellDecorationViewClass: AnyClass? = nil
    ) {
        self.init()
        
        self.delegate = delegate
    }
    
    override func prepare() {
        guard let collectionView = self.collectionView,
              let delegate = self.delegate,
              !self.cacheBuilt else { return }
        
        var maxItemsInSection = 0
                
        let sideColumnWidth: CGFloat? = delegate.widthsOfSideColumn(in: self)
        let headerRowHeight: CGFloat? = delegate.heightOfHeaderRow(in: self)
        
        var rowHeights = [CGFloat]()
        
        // Calculate Row Headers cache and row heights for sections
        var currentRowYoffset: CGFloat = headerRowHeight ?? 0
        for section in 0 ..< collectionView.numberOfSections {
            let rowHeight = delegate.listingLayout(self, heightForRowsInSection: section)
            rowHeights.append(rowHeight)
            
            let items = collectionView.numberOfItems(inSection: section)
            maxItemsInSection = max(maxItemsInSection, items)
            
            if let sideColumnWidth = sideColumnWidth {
                let leftRowAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: ViewKindType.rowHeader.rawValue, with: IndexPath(item: 0, section: section))
                leftRowAttributes.frame = CGRect(x: 0, y: currentRowYoffset, width: sideColumnWidth, height: rowHeight)
                self.rowCache.append(leftRowAttributes)
            }
            currentRowYoffset += rowHeight
        }
    
        // Calculate Column Header cache and width
        var currentColumnHeadlineXoffset = sideColumnWidth ?? 0
        var rowHeaderWidths = [CGFloat]()
        for item in 0 ..< maxItemsInSection {
            let topColumnWidth = delegate.listingLayout(self, widthForColumnAtIndex: item)
            rowHeaderWidths.append(topColumnWidth)

            if let headerRowHeight = headerRowHeight {
                let topColumnAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: ViewKindType.columnHeader.rawValue, with: IndexPath(item: item, section: 0))
                topColumnAttributes.frame = CGRect(x: currentColumnHeadlineXoffset, y: 0, width: topColumnWidth, height: headerRowHeight)
                self.columnCache.append(topColumnAttributes)

                currentColumnHeadlineXoffset += topColumnWidth
            }
        }
        
        // Calculate Columns widths for sections
        var columnWidths = [[CGFloat]]()
        for section in 0..<collectionView.numberOfSections {
            var rowWidths = [CGFloat]()
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                let topColumnWidth = delegate.listingLayout(self, widthForItemAt: IndexPath(item: item, section: section))
                rowWidths.append(topColumnWidth)
            }
            columnWidths.append(rowWidths)
        }
        
        // Calculate Cell Data cache
        var globalCellXoffset = sideColumnWidth ?? 0
        var globalCellYoffset = headerRowHeight ?? 0
        for currentSection in 0 ..< columnWidths.count {
            var currentCellXoffset = sideColumnWidth ?? 0
            let itemOffset = delegate.listingLayout(self, offsetForItemAt: IndexPath(item: 0, section: currentSection))
            currentCellXoffset += itemOffset
            let sectionHeight = rowHeights[currentSection]
            var sectionAttributes = [UICollectionViewLayoutAttributes]()
            for currentItem in 0 ..< columnWidths[currentSection].count {
                let rowWidth = columnWidths[currentSection][currentItem]
                let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentItem, section: currentSection))
                cellAttributes.frame = CGRect(x: currentCellXoffset, y: globalCellYoffset, width: rowWidth, height: sectionHeight)
                currentCellXoffset += rowWidth
                sectionAttributes.append(cellAttributes)
            }
            globalCellXoffset = max(currentCellXoffset, globalCellXoffset)
            self.cellCache.append(sectionAttributes)
            globalCellYoffset += sectionHeight
        }
        
        // Calculate FirstHeaderCell cache
        if collectionView.numberOfSections > 0 {
            if let leftRowWidth = sideColumnWidth {
                if self.useFirstTableView,
                   let headerRowHeight = headerRowHeight {
                    
                    let topLeftAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: ViewKindType.decorationFirstHeaderCell.rawValue, with: IndexPath(item: 0, section: 0))
                    topLeftAttributes.frame = CGRect(x: 0, y: 0, width: leftRowWidth, height: headerRowHeight)
                    self.firstHeaderCellLayoutAttributes = topLeftAttributes
                }
            }
        }
        
        if self.contentWidth != globalCellXoffset {
            collectionView.setContentOffset(CGPoint.zero, animated: false)
        }
        
        self.contentWidth = globalCellXoffset
        self.contentHeight = globalCellYoffset
        self.cacheBuilt = true
    }
    
    override var collectionViewContentSize : CGSize {
        CGSize(width: self.contentWidth, height: self.contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else { return nil }
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Cell
        for cellCacheArray in self.cellCache {
            for cellAttributes in cellCacheArray where cellAttributes.frame.intersects(rect) {
                cellAttributes.zIndex = 0
                layoutAttributes.append(cellAttributes)
            }
        }
        
        // Row
        if self.stickyRowHeader && collectionView.contentOffset.x >= 0 {
            let contentOffsetX = collectionView.contentOffset.x
            
            if contentOffsetX >= 0 {
                for rowAttributes in self.rowCache {
                    rowAttributes.frame.origin.x = contentOffsetX
                    rowAttributes.zIndex = 1000
                    layoutAttributes.append(rowAttributes)
                }
            }
        } else {
            for rowAttributes in self.rowCache where rowAttributes.frame.intersects(rect) {
                rowAttributes.frame.origin.x = 0
                rowAttributes.zIndex = 1000
                layoutAttributes.append(rowAttributes)
            }
        }
        
        // Column
        if self.stickyColumnHeader && collectionView.contentOffset.y >= 0 {
            for columnAttributes in self.columnCache {
                columnAttributes.frame.origin.y = collectionView.contentOffset.y
                columnAttributes.zIndex = 2000
                layoutAttributes.append(columnAttributes)
            }
        } else {
            for columnAttributes in self.columnCache where columnAttributes.frame.intersects(rect) {
                columnAttributes.frame.origin.y = 0
                columnAttributes.zIndex = 2000
                layoutAttributes.append(columnAttributes)
            }
        }
        
        // FirstHeaderCell
        if let firstHeaderCellLayoutAttributes = self.firstHeaderCellLayoutAttributes {
            if self.stickyRowHeader && collectionView.contentOffset.x >= 0 {
                firstHeaderCellLayoutAttributes.frame.origin.x = collectionView.contentOffset.x
            } else if firstHeaderCellLayoutAttributes.frame.intersects(rect) {
                firstHeaderCellLayoutAttributes.frame.origin.x = 0
            }
            
            if self.stickyColumnHeader && collectionView.contentOffset.y >= 0 {
                firstHeaderCellLayoutAttributes.frame.origin.y = collectionView.contentOffset.y
            } else if firstHeaderCellLayoutAttributes.frame.intersects(rect) {
                firstHeaderCellLayoutAttributes.frame.origin.y = 0
            }
            
            firstHeaderCellLayoutAttributes.zIndex = 3000
            layoutAttributes.append(firstHeaderCellLayoutAttributes)
        }
        
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cellCache[indexPath.section][indexPath.row]
    }

    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let viewKind = ViewKindType(rawValue: elementKind) else {
            fatalError("Invalid View Kind for string: \(elementKind)")
        }
        
        switch viewKind {
        case .rowHeader:
            return self.rowCache[indexPath.section]
        case .columnHeader:
            return self.columnCache[indexPath.item]
        case .decorationFirstHeaderCell:
            return self.firstHeaderCellLayoutAttributes
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        stickyRowHeader || stickyColumnHeader
    }
    
    /// Reset layout cache. This will cause the layout to recalculate all display information.
    func resetLayoutCache() {
        cellCache = []
        rowCache = []
        columnCache = []
        firstHeaderCellLayoutAttributes = nil
        cacheBuilt = false
    }
    
}
