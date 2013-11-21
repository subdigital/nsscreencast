//
//  ViewController.m
//  CoreImageFun
//
//  Created by ben on 11/17/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

@import CoreImage;
#import "ViewController.h"
#import "FaceView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSMutableSet *faces;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.faces = [NSMutableSet set];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.imageView.image = [UIImage imageNamed:@"benandphil.jpg"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                  context:nil
                                                  options:@{
                                                            CIDetectorAccuracy : CIDetectorAccuracyHigh }];
        CIImage *ciImage = [CIImage imageWithCGImage:[self.imageView.image CGImage]];
        NSArray *features = [detector featuresInImage:ciImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            for (CIFeature *feature in features) {
                if ([feature isKindOfClass:[CIFaceFeature class]]) {
                    CIFaceFeature *faceFeature = (CIFaceFeature *)feature;
                    FaceView *face = [[FaceView alloc] init];
                    face.feature = faceFeature;
                    [self.faces addObject:face];
                }
            }
            
            [self drawFaces];
        });
    });

}

- (void)drawFaces {
    CGSize imageSize = self.imageView.image.size;
    CGFloat imageScale = fminf(self.imageView.bounds.size.width / imageSize.width,
                               self.imageView.bounds.size.height / imageSize.height);
    CGSize scaledImageSize = CGSizeMake(imageSize.width * imageScale, imageSize.height * imageScale);
    CGRect imageFrame = CGRectMake(
                                   roundf(0.5f * (self.imageView.bounds.size.width - scaledImageSize.width)),
                                   roundf(0.5f * (self.imageView.bounds.size.height - scaledImageSize.height)),
                                   roundf(scaledImageSize.width),
                                   roundf(scaledImageSize.height)
                                   );
    NSLog(@"Scale: %g", imageScale);
    NSLog(@"Image frame: %@", NSStringFromCGRect(imageFrame));
    
    for (FaceView *face in self.faces) {
        face.hidden = NO;
        face.scale = imageScale;
        face.imageSize = scaledImageSize;
        face.frame = imageFrame;
        
        if (!face.superview) {
            [self.imageView addSubview:face];
        }
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // hide faces
    for (FaceView *face in self.faces) {
        face.hidden = YES;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // redraw faces
    [self drawFaces];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
