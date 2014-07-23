//
//  IDKDetailViewController.h
//  IDK3
//
//  Created by SATOKO HIGHSTEIN on 7/1/14.
//  Copyright (c) 2014 IDKNY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "IDKDetail.h"
#import "IDKCommon.h"
#import "IDKAnnotation.h"

@interface IDKDetailViewController : UIViewController <UIScrollViewDelegate>

@property IDKDetail *selectedVenue;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
