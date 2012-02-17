//
//  PusherExampleMenuViewController.m
//  libPusher
//
//  Created by Luke Redpath on 14/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "PusherExampleMenuViewController.h"

@implementation PusherExampleMenuViewController

@synthesize pusher;

- (void)awakeFromNib
{
  NSMutableArray *options = [NSMutableArray array];
  
  NSMutableDictionary *exampleOne = [NSMutableDictionary dictionary];
  [exampleOne setObject:@"Subscribe and trigger" forKey:@"name"];
  [exampleOne setObject:@"Trigger events using the REST API and see them appear in real-time." forKey:@"description"];
  [exampleOne setObject:@"PusherEventsViewController" forKey:@"controllerClass"];
  [options addObject:exampleOne];
  
  NSMutableDictionary *exampleTwo = [NSMutableDictionary dictionary];
  [exampleTwo setObject:@"Presence channels" forKey:@"name"];
  [exampleTwo setObject:@"Connect multiple clients and see them announced." forKey:@"description"];
  [exampleTwo setObject:@"PusherPresenceEventsViewController" forKey:@"controllerClass"];
  [options addObject:exampleTwo];
  
  menuOptions = [options copy];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [menuOptions count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }
  
  NSDictionary *example = [menuOptions objectAtIndex:indexPath.row];
  cell.textLabel.text = [example objectForKey:@"name"];
  cell.detailTextLabel.numberOfLines = 2;
  cell.detailTextLabel.text = [example objectForKey:@"description"];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDictionary *example = [menuOptions objectAtIndex:indexPath.row];
  
  Class controllerClass = NSClassFromString([example objectForKey:@"controllerClass"]);
  NSAssert1(controllerClass, @"Controller class %@ does not exist! Typo?", [example objectForKey:@"controllerClass"]);
  
  UIViewController *viewController = [[controllerClass alloc] init];
  [viewController performSelector:@selector(setPusher:) withObject:self.pusher];
  [self.navigationController pushViewController:viewController animated:YES];
}

@end
