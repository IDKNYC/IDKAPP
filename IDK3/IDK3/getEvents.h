//
//  HomeModel.h
//  eventTest
//
//  Created by Priscilla Tran on 6/30/14.
//  Copyright (c) 2014 IDKNY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol HomeModelProtocol <NSObject, CLLocationManagerDelegate>

- (void)itemsDownloaded:(NSArray *)items;

@end

@interface HomeModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<HomeModelProtocol> delegate;
@property NSNumber *criteriaPrice;  // 1, 2, 3 or 4 for restaurants. dollar amount for events
@property NSNumber *criteriaRadius; // only 0.5, 1, 2, 5 or 10
@property NSNumber *criteriaLat;
@property NSNumber *criteriaLng;
@property BOOL isEvent;

- (void)downloadItems;
- (void)downloadGooglePlaces;

@end