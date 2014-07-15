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
@property NSMutableString *criteriaPrice;  // 1, 2, 3 or 4
@property NSMutableString *criteriaRadius; // only 0.5, 1, 2, or 5
@property NSMutableString *criteriaLat;
@property NSMutableString *criteriaLng;
@property BOOL isEvent;

- (void)downloadItems;
- (void)downloadGooglePlaces;

@end