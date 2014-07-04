//
//  MasterViewController.h
//  Västtrafik
//
//  Created by Johan Dahlgren on 9/11/13.
//  Copyright (c) 2013 KnowIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
