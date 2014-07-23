//
//  IDKCommon.m
//  IDK3
//
//  Created by MahdiMakki on 7/15/14.
//  Copyright (c) 2014 SATOKO HIGHSTEIN. All rights reserved.
//

#import "IDKCommon.h"

@implementation IDKCommon

+ (void) addGradientLayerForView:(UIView*) view withTopColor:(UIColor*) topColor bottomColor:(UIColor*) bottomColor
{
    NSArray *colors = @[(id)topColor.CGColor, (id)bottomColor.CGColor];
    NSArray *locations = @[@0.0, @1.0]; // Top at 0.0 and bottom at 1.0
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.colors = colors;
    layer.locations = locations;
    layer.frame = view.bounds;
    layer.name = @"GradientLayer";
    [view.layer insertSublayer:layer atIndex:0];
}

@end
