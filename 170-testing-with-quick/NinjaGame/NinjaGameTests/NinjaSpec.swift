//
//  NinjaSpec.swift
//  NinjaGame
//
//  Created by Ben Scheirman on 5/19/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Foundation
import NinjaGame
import Quick
import Nimble

class NinjaSpec : QuickSpec {

    override func spec() {
        var ninja = Ninja(name: "Sid")
        
        UIApplication.sharedApplication().delegate?.window?
        
        describe("initialization") {
            it("initialized the name") {
                expect(ninja.name).to(equal("Sid"))
            }
        }
        
        describe("equality") {
            var ninja2: Ninja!
            context("two ninjas with the same name") {
                beforeEach {
                    ninja2 = Ninja(name: "Sid")
                }
                
                it("should be considered equal") {
                    expect(ninja) == ninja2
                }
            }
            
            context("two ninjas with different names") {
                beforeEach {
                    ninja2 = Ninja(name: "Barry")
                }
                it("should not be considered equal") {
                    expect(ninja) != ninja2
                }
            }
        }
        
        describe("attacking") {
            it("should attack when the enemy least expects it") {
                let enemy = Enemy()
                ninja.encounter(enemy)
                
                expect(enemy.hitPoints).toEventually(beLessThan(100))
                
            }
        }
    }
    
}