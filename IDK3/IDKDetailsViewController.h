//
//  IDKDetailsViewController.h
//  IDK3
//
//  Created by Mahdi Makki on 7/15/14.
//  Copyright (c) 2014 IDKNY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "IDKDetail.h"
#import "IDKAnnotation.h"

@interface IDKDetailsViewController : UIViewController <UIScrollViewDelegate>

@property IDKDetail *selectedVenue;

@end
