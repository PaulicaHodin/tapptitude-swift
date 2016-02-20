//: Playground - noun: a place where people can play

import UIKit
import Tapptitude

let dataSource = DataSource(content: ["test"])
let cellController = CollectionCellController<String, UICollectionViewCell>(cellSize: CGSize(width: 50, height: 50))
cellController.acceptsContent("test")
cellController.acceptsContent(1)
cellController.acceptsContent("Maria" as AnyObject)
let indexPath = NSIndexPath(forItem: 0, inSection: 0)
let object = dataSource.objectAtIndexPath(indexPath)
cellController.configureCell(UICollectionViewCell(), forContent: object, indexPath: indexPath)
cellController.parentViewController = nil
cellController.parentViewController = UIViewController()

//let feedController = CollectionFeedController(nibName: "CollectionFeedController", bundle: nil)
let feedController = CollectionFeedController()
feedController.dataSource = dataSource
feedController.cellController = cellController

print(feedController.view)
feedController.collectionView?.backgroundColor = UIColor.grayColor()


cellController.configureCellBlock = { cell, content, indexPath in
    cell.backgroundColor = UIColor.redColor()
    print(cell)
}
cellController.didSelectContentBlock = { content, indexPath, collectionView in
    print("did select", content)
    let cell = collectionView.cellForItemAtIndexPath(indexPath)
    print(cellController.parentViewController!)
}
print(feedController.collectionView)

import XCPlayground
XCPlaygroundPage.currentPage.liveView = feedController.view
