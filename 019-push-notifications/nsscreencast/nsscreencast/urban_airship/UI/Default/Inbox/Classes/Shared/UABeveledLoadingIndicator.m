
#import "UABeveledLoadingIndicator.h"
#include <QuartzCore/QuartzCore.h>

@implementation UABeveledLoadingIndicator

+ (UABeveledLoadingIndicator *)indicator {
    return [[[UABeveledLoadingIndicator alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];
}

- (void)setup {
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.7;
    self.layer.cornerRadius = 10.0;
    self.hidden = YES;
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.hidesWhenStopped = YES;

    [self addSubview:activity];
    
    activity.center = CGPointMake( self.frame.size.width/2, self.frame.size.height/2);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)show {
    self.hidden = NO;
    [activity startAnimating];
}

- (void)hide {
    self.hidden = YES;
    [activity stopAnimating];
}

- (void)dealloc {
    [activity release];
    [super dealloc];
}

@end
