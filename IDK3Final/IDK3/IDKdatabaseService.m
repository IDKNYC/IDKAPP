//
//  IDKdatabaseService.m
//  IDK2
//
//  Created by SATOKO HIGHSTEIN on 6/24/14.
//  Copyright (c) 2014 SATOKO HIGHSTEIN. All rights reserved.
//

#import "IDKdatabaseService.h"
#import "IDKDetail.h"

@interface IDKdatabaseService () {
    NSMutableData *_downloadedData;
}

@end


@implementation IDKdatabaseService

- (void)downloadItems {
    // download jason file
    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://idontknow.info/someservice.php"];
    
    // created the request
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    //create the create NSURL connection
//    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}

#pragma mark NSURLConnectionDataProtocol Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // initialize the data object
    _downloadedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // append the newly downloadedd data
    [_downloadedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // create an array to store the locations
    NSMutableArray *_venues = [[NSMutableArray alloc] init];
    
    // parse the JSON that came in
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    // Loop through Json objects, create question objects and add them to our questions array
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];
        
        // Create a new location object and set its props to JsonElement properties
        IDKDetail *newVenue = [[IDKDetail alloc] init];
        newVenue.venueName = jsonElement[@"eventName"];
        newVenue.address = jsonElement[@"address"];
//        newVenue.type = jsonElement[@"Type"];
        
        // Add this question to the locations array
        [_venues addObject:newVenue];
    }
    
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate)
    {
        [self.delegate itemsDownloaded:_venues];
    }
    // loop through Json objects, create questio object and add them
}


@end
