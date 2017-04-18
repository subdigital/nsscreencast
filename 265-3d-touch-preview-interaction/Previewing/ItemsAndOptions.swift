//
//  Option.swift
//  Previewing
//
//  Created by Conrad Stoll on 2/27/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//

import Foundation
import UIKit

struct ItemCollection {
    var items = sampleData()
    
    mutating func check(_ item : Item) {
        if let index = items.index(of: item) {
            var modifyItem = item
            modifyItem.type = .check
            items[index] = modifyItem
        }
    }
    
    mutating func uncheck(_ item : Item) {
        if let index = items.index(of: item) {
            var modifyItem = item
            modifyItem.type = .none
            items[index] = modifyItem
        }
    }
    
    mutating func moveUp(_ item : Item) -> (from : Int, to : Int)? {
        if let index = items.index(of: item) {
            items.remove(at: index)
            items.insert(item, at: 0)
            
            return (index, 0)
        }
        
        return nil
    }
    
    mutating func moveDown(_ item : Item) -> (from : Int, to : Int)? {
        if let index = items.index(of: item) {
            items.remove(at: index)
            items.append(item)
            
            return (index, items.count - 1)
        }
        
        return nil
    }
    
    mutating func delete(_ item : Item) -> Int? {
        if let index = items.index(of: item) {
            items.remove(at: index)
            
            return index
        }
        
        return nil
    }
}

struct Item : Equatable {
    let title : String
    var type : OptionType
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.title == rhs.title
    }
}

enum OptionType {
    case none
    case check
}

func sampleData() -> [Item] {
    let item1 = Item(title: "Basic list entry", type: .none)
    let item2 = Item(title: "Slightly advanced list entry with a moderate amount of content", type: .check)
    let item3 = Item(title: "Super advanced and complex list entry with more content than you can shake a stick at", type: .check)
    let item4 = Item(title: "Super boring list entry", type: .none)
    let item5 = Item(title: "Standard run of the mill rather lengthy list entry", type: .check)
    
    return [item1, item2, item3, item4, item5]
}

class ItemCell : UITableViewCell {
    @IBOutlet weak var background : UIView!
    @IBOutlet weak var label : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.background.layer.cornerRadius = 7.0
        self.background.layer.masksToBounds = true
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            background.alpha = 0.5
        } else {
            background.alpha = 1.0
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            background.alpha = 0.5
        } else {
            background.alpha = 1.0
        }
    }
}
