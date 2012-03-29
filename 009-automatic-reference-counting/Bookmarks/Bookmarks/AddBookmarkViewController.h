//
//  AddBookmarkViewController.h
//  Bookmarks
//
//  Created by Ben Scheirman on 3/11/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddBookmarkDelegate;

@interface AddBookmarkViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, unsafe_unretained) id<AddBookmarkDelegate> delegate;
@property (nonatomic) IBOutlet UITextField *labelTextField;
@property (nonatomic) IBOutlet UITextField *urlTextField;


@end

@protocol AddBookmarkDelegate <NSObject>

@required

- (void)addBookmarkViewController:(AddBookmarkViewController *)viewController 
         didSaveBookmarkWithLabel:(NSString *)label
                              url:(NSString *)url;

- (void)addBookmarkViewControllerDidCancel:(AddBookmarkViewController *)viewController;

@end
