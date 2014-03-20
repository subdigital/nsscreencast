//
//  GTMyScene.m
//  GiggleTouch
//
//  Created by ben on 3/17/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "GTMyScene.h"

@implementation GTMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.65 green:0.90 blue:1.0 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Touch the screen!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        SKAction *wait = [SKAction waitForDuration:5];
        SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:1];
        [myLabel runAction:[SKAction sequence:@[wait, fadeOut]]];
        
        [self addChild:myLabel];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self spawnNodeAtLocation:[touch locationInNode:self]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self spawnNodeAtLocation:[touch locationInNode:self]];
    }
}

- (void)spawnNodeAtLocation:(CGPoint)location {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:[self randomShape]];
    sprite.yScale = sprite.xScale = 0.8;
    sprite.position = location;
    
    [sprite runAction:[SKAction colorizeWithColor:[self randomColor]
                                 colorBlendFactor:1.0
                                         duration:0]];
    
    CGFloat duration = [self randomDuration];
    SKAction *rotate = [SKAction rotateByAngle:[self randomAngle]
                                      duration:duration];
    CGFloat scaleAmount = [self randomScale];
    SKAction *scale = [SKAction scaleTo:scaleAmount duration:duration];
    SKAction *group = [SKAction group:@[rotate, scale]];
    SKAction *fadeAction = [SKAction fadeAlphaTo:0 duration:0.25];
    [sprite runAction:[SKAction sequence:@[ group, fadeAction ]]];
    
    [self addChild:sprite];
}

- (CGFloat)randomScale {
    CGFloat x = arc4random() % 30;
    CGFloat scale = (90.0 - x) / 100.0;
    return scale;
}

- (NSString *)randomShape {
    static NSArray *__shapes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shapes = @[ @"triangle", @"pentagon", @"star" ];
    });
    
    return __shapes[arc4random() % __shapes.count];
}

- (UIColor *)randomColor {
    static NSArray *__colors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __colors = @[
                        [UIColor colorWithRed:.11372549  green:.819607843 blue:.819607843 alpha:1.0], //29,209,99
                        [UIColor colorWithRed:.882352941 green:.466666667 blue:.709803922 alpha:1.0], //225,119,181
                        [UIColor colorWithRed:.647058824 green:.164705882 blue:.482352941 alpha:1.0], //165,42,123
                        [UIColor colorWithRed:.482352941 green:.17254902  blue:.733333333 alpha:1.0], //123,44,187
                        [UIColor colorWithRed:.219607843 green:.098039216 blue:.698039216 alpha:1.0], //56,25,178
                        [UIColor colorWithRed:.678431373 green:.843137255 blue:.274509804 alpha:1.0]  //173,215,70
                     ];
    });
    return __colors[arc4random() % __colors.count];
}

- (CGFloat)randomDuration {
    return (CGFloat)(arc4random() % 3 + 1);
}

- (CGFloat)randomAngle {
    CGFloat revs = (arc4random() % 8 + 1) / 2.0f;
    return revs * 2 * M_PI;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
