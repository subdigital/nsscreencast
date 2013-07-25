//
//  Money.h
//  
//
//  Created by ben on 7/23/13.
//
//

@interface Money : NSObject

@property (nonatomic, readonly) NSInteger amount;
@property (nonatomic, readonly) NSString *currency;

+ (id)dollarWithAmount:(NSInteger)amount;

- (id)initWithAmount:(NSInteger)amount currency:(NSString *)currency;

+ (id)euroWithAmount:(NSInteger)amount;

- (Money *)times:(NSInteger)multiplier;

@end
