//
//  SearchClassViewController.m
//  Introspecty
//
//  Created by Ben Scheirman on 10/14/12.
//  Copyright (c) 2012 foo. All rights reserved.
//

#import "SearchClassViewController.h"
#import <objc/runtime.h>

enum {
    SearchClassViewControllerMethodSection = 0,
    SearchClassViewControllerIVarSection,
    SearchClassViewControllerSectionCount
};

@interface SearchClassViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *methods;
@property (nonatomic, strong) NSArray *ivars;

@end

@implementation SearchClassViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.title = @"Introspecty";
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    self.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchBar;
}

- (NSArray *)methodsInClass:(Class)class {
    unsigned int methodCount;
    Method *methods = class_copyMethodList(class, &methodCount);
    NSMutableArray *methodNames = [NSMutableArray arrayWithCapacity:methodCount];
    
    for (int i=0; i<methodCount; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);
        [methodNames addObject:name];
    }
    
    return [methodNames sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
}

- (NSArray *)ivarsInClass:(Class)class {
    unsigned int ivarCount;
    Ivar *ivars = class_copyIvarList(class, &ivarCount);
    NSMutableArray *ivarNames = [NSMutableArray arrayWithCapacity:ivarCount];
    
    for (int i=0; i<ivarCount; i++) {
        Ivar ivar = ivars[i];
        const char *ivarNameStr = ivar_getName(ivar);
        NSString *ivarName = [NSString stringWithCString:ivarNameStr encoding:NSUTF8StringEncoding];
        [ivarNames addObject:ivarName];
    }
    
    return [ivarNames sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
}

- (void)inspectClass:(Class)class {
    self.methods = [self methodsInClass:class];
    self.ivars = [self ivarsInClass:class];
    
    [self.tableView reloadData];
}

- (BOOL)searchForClass:(NSString *)className {
    Class class = NSClassFromString(className);
    if (!class) {
        NSString *msg = [NSString stringWithFormat:@"No class named %@ was found", className];
        [[[UIAlertView alloc] initWithTitle:@"Class not found"
                                    message:msg
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return NO;
    } else {
        NSLog(@"Found class: %@", class);
        [self inspectClass:class];
        return YES;
    }
}

#pragma mark - UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([self searchForClass:searchBar.text]) {
        [searchBar resignFirstResponder];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SearchClassViewControllerSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SearchClassViewControllerMethodSection:
            return self.methods.count;
        case SearchClassViewControllerIVarSection:
            return self.ivars.count;
            
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case SearchClassViewControllerMethodSection:
            return @"Methods";
            
        case SearchClassViewControllerIVarSection:
            return @"Instance Variables";
            
        default:
            return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *collection;
    
    switch (indexPath.section) {
        case SearchClassViewControllerMethodSection:
            collection = self.methods;
            break;
            
        case SearchClassViewControllerIVarSection:
            collection = self.ivars;
            break;
    }
 
    cell.textLabel.text = [collection objectAtIndex:indexPath.row];
    
    return cell;
}


@end
