//
//  HomeModel.m
//  eventTest
//
//  Created by Priscilla Tran on 6/30/14.
//  Copyright (c) 2014 IDKNY. All rights reserved.
//

#import "getEvents.h"
#import "IDKDetail.h"

@interface HomeModel()
{
    NSMutableData *_downloadedData;
}
@end

@implementation HomeModel {
    CLLocationManager *locationManager;
}



// --- get location ---//
-(void) initLocatonManager {
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        _criteriaLng = [ NSNumber numberWithFloat: currentLocation.coordinate.longitude];
        _criteriaLat = [ NSNumber numberWithFloat: currentLocation.coordinate.latitude];
    }
}


// --- get data --- //
- (void)downloadItems
{
    [self initLocatonManager];
    
    if (_criteriaLat == nil ) {
        _criteriaLat =  @40.840969429;
        _criteriaLng = @-73.965304239;
    }
    _criteriaRadius = @5;
    
    // Create url path with parameters
    NSString *url = [[NSString alloc] initWithFormat: @"http://idontknow.info/eventRequest.php"];
    //------
    NSString *post = [NSString stringWithFormat:@"price=%@&GPSlad=%f&GPSlong=%f&radius=%@", _criteriaPrice, [_criteriaLat doubleValue], [_criteriaLng doubleValue], _criteriaRadius];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSLog(@"url:%@ \npost:%@", url, post);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = [[NSError alloc]init];
    [ NSURLConnection connectionWithRequest:request delegate:self ];
        /*
    //-------
    
    // Download the json file
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    
    // Create the request
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:jsonFileUrl];
    
    // Create the NSURLConnection
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    
//    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
     */
    
}

- (void)downloadGooglePlaces {
    [self initLocatonManager];
    
    if( _criteriaLat == nil || _criteriaLat == 0) {
        _criteriaLat = [ NSNumber numberWithFloat:  40.840969429 ];
        _criteriaLng = [ NSNumber numberWithFloat: -73.965304239];
    }
//    [locationManager stopUpdatingLocation];
    
    NSString *userLat = [ NSString stringWithFormat:@"%@", _criteriaLat ]; // @"40.768608";
    NSString *userLng = [ NSString stringWithFormat:@"%@", _criteriaLng ]; // @"-73.965304";
    NSString *userPrice = [NSString stringWithFormat:@"%@", _criteriaPrice ]; // @"3";
    int rad = [_criteriaRadius floatValue] * 1000;
    NSString *userRadius = [ NSString stringWithFormat:@"%d", rad ];

    NSString *url = [[NSString alloc] initWithFormat:
                     @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=%@&types=restaurant&maxpice=%@&key=AIzaSyC2TYszFCEbi09cLFheG9N8tqL30FtKg2g", userLat, userLng, userRadius, userPrice ];
    NSLog(@"url:%@", url);
    
    // --- directly using google api
    NSURL *googlePlacesURL = [NSURL URLWithString:url];
    NSMutableURLRequest *googleRequest = [[NSMutableURLRequest alloc] initWithURL:googlePlacesURL];
    [NSURLConnection connectionWithRequest:googleRequest delegate:self];

}

#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Initialize the data object
    _downloadedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    NSLog(@"data is %@", data);
    [_downloadedData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Parse the JSON that came in
    NSError *error;
    NSString *stringData = [[NSString alloc] initWithData: _downloadedData encoding:NSUTF8StringEncoding];
    NSLog(@"\n\n******** Downloaded data: %@", stringData);
    
    if( [stringData isEqual: @"\"Sorry. There are no events near you. Try modifying your search criteria.\""] ) {

        NSMutableArray *_locations = [[NSMutableArray alloc] init];
        IDKDetail *detail = [[IDKDetail alloc] init];
        detail.Name = @"No event returned";
        detail.address = @"";
        detail.date = @"";
        detail.time = @"";
        detail.lat = _criteriaLat;
        detail.lng = _criteriaLng;
        detail.venueName = @"";
        detail.info = @"";
        detail.iconPath = @"";

        
        [ _locations addObject:detail];
        if (self.delegate)
        {
            [self.delegate itemsDownloaded:_locations];
        }
    } else {
        if( self.isEvent ==  NO ) {
            NSDictionary *dArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
            [self parseGoogleResults:dArray];
        } else {
            // Loop through Json objects, create question objects and add them to our questions array
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
            [self parseEventResults:jsonArray];
        }
    }
}

- (void)parseGoogleResults :(NSDictionary *)dict {
    // Create an array to store the locations
    NSMutableArray *_locations = [[NSMutableArray alloc] init];
    
    NSArray *resArray = [dict valueForKey:@"results"];
    NSLog(@"results has this many @%lu", (unsigned long)resArray.count);
    
    // Store each results into array groups
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    for (NSDictionary *groupDic in resArray) {
        IDKDetail *detail = [[IDKDetail alloc] init];
        
        for (NSString *key in groupDic) {
//            NSLog(@"key=%@", key);
            if([ key isEqualToString:@"name"]) {
                [ detail setValue:[groupDic valueForKey:key] forKeyPath:@"Name"];
                [ detail setValue:[groupDic valueForKey:key] forKeyPath:@"venueName"];
            }
            if([ key isEqualToString:@"vicinity"]) {
                [ detail setValue:[groupDic valueForKey:key] forKeyPath:@"address"];
            }
            if([ key isEqualToString:@"photo"] || [key isEqualToString:@"photos"] ) {
                NSLog(@"photo= %@", [groupDic valueForKey:key]);
                
                [ detail setValue: [[[groupDic objectForKey:key] valueForKey:@"photo_reference" ] objectAtIndex:0] forKeyPath:@"photoPath"];
            }
            if([ key isEqualToString:@"icon"]) {
                NSLog(@"Icon= %@", [groupDic valueForKey:key]);
                
                [ detail setValue:[groupDic valueForKey:key] forKeyPath:@"iconPath"];
            }
            if([ key isEqualToString:@"types"]) {
                NSString *myTypes = [[groupDic valueForKey:key] componentsJoinedByString:@", "];
//                NSLog(@"myTypes: %@", myTypes);
                
                [detail setValue:myTypes forKeyPath:@"type"];
            }
            if( [key isEqualToString:@"geometry"] ) {
//                NSLog(@"geometry!!!! ");
                
                NSDictionary *loc = [[groupDic objectForKey:key] objectForKey:@"location"];
                for( NSString *gKey in loc ) {
                    if( [gKey isEqualToString:@"lat"]) {
                        [detail setValue:[loc valueForKeyPath:gKey] forKeyPath:@"lat"];
                    }
                    if( [gKey isEqualToString:@"lng"]) {
                        [detail setValue:[loc valueForKeyPath:gKey] forKeyPath:@"lng"];
                    }
                }
                
            }
        } // end of groupDisc
        
        [groups addObject:detail];
//        [_locations addObject:detail];
    }
    
    // get random 3 from group's array
    
    int counter = 0;
    int numInGroups = (unsigned int) [groups count];
    if( numInGroups < 3 ){
        _locations = groups;
    } else {
        int upperBoundValid = numInGroups-1;
        for( counter = 0; counter < 3; counter++ ) {
            int x = arc4random() % upperBoundValid;
            [_locations addObject: [ groups objectAtIndex:x]];
        }
    }
    
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate)
    {
        [self.delegate itemsDownloaded:_locations];
    }
} // End of parseGoogleResults

-(void) parseEventResults:(NSArray *)resArray {
    // Create an array to store the locations
    NSMutableArray *_locations = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < resArray.count; i++)
    {
        NSDictionary *jsonElement = resArray[i];
        
        // Create a new location object and set its props to JsonElement properties
        IDKDetail *newLocation = [[IDKDetail alloc] init];
        newLocation.Name = jsonElement[@"eventName"];
        newLocation.address = jsonElement[@"address"];
        newLocation.date = jsonElement[@"date"];
        newLocation.time = jsonElement[@"time"];
        newLocation.lat = [ NSNumber numberWithDouble: [jsonElement[@"GPSlad"] doubleValue] ];
        newLocation.lng = [ NSNumber numberWithDouble: [jsonElement[@"GPSlong"] doubleValue] ];
        newLocation.venueName = jsonElement[@"eventVenue"];
        newLocation.info = jsonElement[@"eventInfo"];
        newLocation.iconPath = jsonElement[@"logo"];
        
        // Add this question to the locations array
        [_locations addObject:newLocation];
    }
    
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate)
    {
        [self.delegate itemsDownloaded:_locations];
    }

}


@end