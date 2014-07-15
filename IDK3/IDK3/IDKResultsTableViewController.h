//
//  IDKResultsTableViewController.h
//  IDK3
//
//  Created by SATOKO HIGHSTEIN on 7/1/14.
//  Copyright (c) 2014 SATOKO HIGHSTEIN. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IDKDetail.h"
#import "getEvents.h"


#import "IDKDetailViewController.h"
#import "IDKTableViewCell.h"

@interface IDKResultsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, HomeModelProtocol>

@property NSString *whatType; // events or restaurants
@property BOOL isEvent; // replaces whatType

@property NSMutableString *maxPx;
@property NSMutableString *maxRadius;

@end
