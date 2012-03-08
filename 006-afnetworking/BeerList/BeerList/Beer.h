//
//  Beer.h
//  BeerList
//
//  Created by Ben Scheirman on 2/26/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

/*   {
 abv = "14.5";
 "brewery_name" = "Avery Brewing Company";
 category = "British Ale";
 description = "A super-caramelly, oak-aged English-style strong ale. The oak is very apparent in this rich and high gravity ale. Additional depth and complexity result in a woody and cask-like nose, with a pronounced vanilla flavor on the palate. As of 2007, the use of additional roasted malt has resulted in subtle bitternes to balance the natural sweetness.";
 ibu = 41;
 id = 5844;
 name = "Samael's Oak-aged Ale";
 rating = 0;
 reviews = 0;
 srm = "12.5";
 style = "Strong Ale";
*/

@interface Beer : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *brewery;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
