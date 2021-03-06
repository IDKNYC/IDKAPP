//
//  IDKDetail.h
//  IDK3
//
//  Detail of event or restautnat
//
//  Created by SATOKO HIGHSTEIN on 7/1/14.
//  Copyright (c) 2014 SATOKO HIGHSTEIN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDKDetail : NSObject

@property NSString *venueName;
@property NSString *type;
@property NSString *address;
@property NSString *date;
@property NSString *time;
@property NSString *Name;   // name of the event. in the case of restaurant, name of the establishment
@property NSString *info;
@property NSString *iconPath;
@property NSString *photoPath;
@property NSString *phone;


@property NSNumber *lat;
@property NSNumber *lng;

@end
