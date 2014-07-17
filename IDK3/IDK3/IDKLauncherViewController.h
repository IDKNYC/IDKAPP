//
//  IDKLauncherViewController.h
//  IDK3
//
//  Created by SATOKO HIGHSTEIN on 7/1/14.
//  Copyright (c) 2014 IDKNY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDKResultsTableViewController.h"

@interface IDKLauncherViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *maxRadius;
@property (weak, nonatomic) IBOutlet UITextField *maxPrice;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (nonatomic, strong) NSArray *radiusArray;
@property (nonatomic, strong) NSArray *priceArray;

-(IBAction) pickOne:(id)sender;

@end
