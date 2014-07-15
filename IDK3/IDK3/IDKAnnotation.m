//
//  IDKAnnotation.m
//  IDK3
//
//  Created by SATOKO HIGHSTEIN on 7/1/14.
//  Copyright (c) 2014 SATOKO HIGHSTEIN. All rights reserved.
//

#import "IDKAnnotation.h"

@implementation IDKAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
    if ((self = [super init])) {
        self.coordinate =coordinate;
        self.title = title;
    }
    return self;
}

@end
