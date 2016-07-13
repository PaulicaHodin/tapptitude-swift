//
//  CollectionHeaderController.swift
//  Pods
//
//  Created by Alexandru Tudose on 11/04/16.
//
//

import UIKit

public protocol TTCollectionHeaderControllerProtocol {
    func classToInstantiate() -> AnyClass?
    func nibToInstantiate() -> UINib?
    
    var reuseIdentifier: String {get}
    var headerSize: CGSize {get}
    
    weak var parentViewController : UIViewController? {get set}
    
    func acceptsContent(content: Any) -> Bool
    
    func headerSize(for content: Any, in collectionView: UICollectionView) -> CGSize
    
    func configureHeader(header: UICollectionReusableView, for content: Any, at indexPath: NSIndexPath)
}

public protocol TTCollectionHeaderController: TTCollectionHeaderControllerProtocol {
    associatedtype ObjectType
    associatedtype HeaderType: UICollectionReusableView
    
    func classToInstantiate() -> AnyClass?
    func nibToInstantiate() -> UINib?
    
    var reuseIdentifier: String {get}
    var headerSize: CGSize {get}
    
    func headerSize(for content: ObjectType, in collectionView: UICollectionView) -> CGSize
    func configureHeader(cell: HeaderType, for content: ObjectType, at indexPath: NSIndexPath)
}

extension TTCollectionHeaderController {
    public func classToInstantiate() -> AnyClass? {
        return HeaderType.self
    }
    
    public func nibToInstantiate() -> UINib? {
        if let _ = NSBundle.mainBundle().pathForResource(reuseIdentifier, ofType: "nib") {
            return UINib(nibName: reuseIdentifier, bundle: nil)
        } else {
            return nil
        }
    }
    
    public func headerSize(for content: Any, in collectionView: UICollectionView) -> CGSize {
        return headerSize(for: content as! ObjectType, in: collectionView)
    }
    
    public func configureHeader(header: UICollectionReusableView, for content: Any, at indexPath: NSIndexPath) {
        configureHeader(header as! HeaderType, for: content as! ObjectType, at: indexPath)
    }
    
    public func acceptsContent(content: Any) -> Bool {
        return content is ObjectType
    }
}

public class CollectionHeaderController<ItemType, HeaderName: UICollectionReusableView> : TTCollectionHeaderController {
    public typealias ObjectType = ItemType
    public typealias HeaderType = HeaderName
    
    public var headerSizeForContent : ((content: ObjectType, collectionView: UICollectionView) -> CGSize)?
    public var configureHeader : ((header: HeaderType, content: ObjectType, indexPath: NSIndexPath) -> Void)?
    
    
    public var headerSize : CGSize
    public var reuseIdentifier: String
    
    public weak var parentViewController : UIViewController?
    
    public init(headerSize : CGSize, reuseIdentifier:String? = nil) {
        self.headerSize = headerSize
        self.reuseIdentifier = reuseIdentifier ?? String(HeaderType)
    }
    
    public func headerSize(for content: ObjectType, in collectionView: UICollectionView) -> CGSize {
        let blockCellSize = headerSizeForContent?(content: content, collectionView: collectionView)
        return blockCellSize ?? headerSize
    }
    
    public func configureHeader(header: HeaderType, for content: ObjectType, at indexPath: NSIndexPath) {
        self.configureHeader?(header: header, content: content, indexPath: indexPath)
    }
}