//
//  IDKDummyEvents.m
//  IDK3
//
//  Created by SATOKO HIGHSTEIN on 7/13/14.
//  Copyright (c) 2014 SATOKO HIGHSTEIN. All rights reserved.
//

#import "IDKDummyEvents.h"

@implementation IDKDummyEvents

-(NSMutableArray *) getDummyData {
    IDKDetail *venue1 = [[IDKDetail alloc] init];
    venue1.venueName = @"Le Cirque";
    venue1.type = @"Restaurant";
    venue1.address = @"151 E 58th St, New York, NY 10022";
    venue1.lat = @40.7679;
    venue1.lng = @-73.9650;
    [_dummyEvents addObject:venue1];

    IDKDetail *venue2 = [[IDKDetail alloc] init];
    venue2.venueName = @"ChaTime";
    venue2.type = @"Cafe";
    venue2.address = @"858 Lexington Ave, New York, NY 10035";
    venue2.lat = @40.7659;
    venue2.lng = @-73.9650;
    [_dummyEvents addObject:venue2];

    IDKDetail *venue3 = [[IDKDetail alloc] init];
    venue3.venueName = @"The Plaza Food Hall";
    venue3.type = @"Food Court";
    venue3.address = @"Fifth Avenue at Central Park South, New York, NY 10019";
    venue3.lat = @40.7679;
    venue3.lng = @-73.9650;
    [_dummyEvents addObject:venue3];

    return _dummyEvents;
}

@end
