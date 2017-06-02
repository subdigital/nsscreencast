//
//  ArrayDatasource.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 6/1/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation

class ArrayDatasource<T> {
    
    weak var delegate: DatasourceDelegate?
    
    var objects: Array<T> = []
    
    func object(at indexPath: IndexPath) -> T {
        return objects[indexPath.row]
    }
    
    @discardableResult
    func insert(object: T, at index: Int) -> IndexPath {
        objects.insert(object, at: index)
        let indexPath = IndexPath(item: index, section: 0)
        DispatchQueue.main.async {
            self.delegate?.objectAdded(at: indexPath)
        }
        return indexPath
    }
    
    @discardableResult
    func add(object: T) -> IndexPath {
        objects.append(object)
        let indexPath = IndexPath(item: objects.count - 1, section: 0)
        DispatchQueue.main.async {
            self.delegate?.objectAdded(at: indexPath)
        }
        return indexPath
    }
    
    @discardableResult
    func delete(at index: Int) -> IndexPath {
        objects.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
        DispatchQueue.main.async {
            self.delegate?.objectRemoved(at: indexPath)
        }
        return indexPath
    }
}
