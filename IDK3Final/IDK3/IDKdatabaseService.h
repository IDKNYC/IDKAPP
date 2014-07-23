//
//  IDKdatabaseService.h
//  IDK2
//
//  Created by SATOKO HIGHSTEIN on 6/24/14.
//  Copyright (c) 2014 SATOKO HIGHSTEIN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol myProtocole <NSObject>

- (void)itemsDownloaded:(NSArray *)items;

@end

@interface IDKdatabaseService : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<myProtocole> delegate;

- (void)downloadItems;

@end
