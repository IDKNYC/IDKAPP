//
//  IDKDummyEvents.h
//  IDK3/
//
//  This is used purely for testing
//
//
//  Created by SATOKO HIGHSTEIN on 7/13/14.
//  Copyright (c) 2014 SATOKO HIGHSTEIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDKDetail.h"

@interface IDKDummyEvents : NSObject

@property NSMutableArray *dummyEvents;


/**
 * Use this method to get
 * the dummy date to test
 * during development
 */

-(NSMutableArray *) getDummyData;

@end
