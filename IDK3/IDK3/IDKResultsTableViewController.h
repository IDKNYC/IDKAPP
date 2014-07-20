//
//  IDKResultsTableViewController.h
//  IDK3
//
//  Created by Mahdi Makki on 7/15/14.
//  Copyright (c) 2014 IDKNY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IDKDetail.h"
#import "getEvents.h"


#import "IDKDetailViewController.h"
#import "IDKDetailsViewController.h"
#import "IDKTableViewCell.h"

@interface IDKResultsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, HomeModelProtocol>

@property NSString *whatType; // events or restaurants
@property BOOL isEvent; // replaces whatType

@property NSMutableString *maxPx;
@property NSMutableString *maxRadius;

@end
