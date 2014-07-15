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
        _criteriaLng = [NSMutableString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        _criteriaLat = [NSMutableString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
}


// --- get data --- //
- (void)downloadItems
{
    [self initLocatonManager];
    
    // Create url path with parameters
    NSString *url = [[NSString alloc] initWithFormat: @"http://idontknow.info/eventRequest.php"];
    //------
    NSString *post = [NSString stringWithFormat:@"price=%@ & GPSlad=%@ & GPSlong=%@ & radius=%@", _criteriaPrice, _criteriaLat, _criteriaLng, _criteriaRadius];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = [[NSError alloc]init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error: &error ];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Reponse code:%d", [urlResponse statusCode]);
    if([urlResponse statusCode] >=200 && [urlResponse statusCode] < 300) {
        NSLog(@"Response: %@", result);
    }

    //-------
    
    // Download the json file
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    
    // Create the request
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:jsonFileUrl];
    
    // Create the NSURLConnection
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    
//    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
}

- (void)downloadGooglePlaces {
    [self initLocatonManager];
    
    if( _criteriaLat == nil) {
        _criteriaLat = [NSMutableString stringWithFormat:@"40.768608"];
        _criteriaLng = [NSMutableString stringWithFormat: @"-73.965304"];
    }
//    [locationManager stopUpdatingLocation];
    
    NSString *userLat = _criteriaLat; // @"40.768608";
    NSString *userLng = _criteriaLng; // @"-73.965304";
    NSString *userPrice = _criteriaPrice; // @"3";

    NSString *url = [[NSString alloc] initWithFormat:
                     @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=500&types=restaurant&maxpice=%@&key=AIzaSyC2TYszFCEbi09cLFheG9N8tqL30FtKg2g", userLat, userLng, userPrice ];
    NSLog(@"url:%@", url);
    
    //@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=40.768608,-73.965304&radius=500&types=restaurant&maxpice=4&key=AIzaSyC2TYszFCEbi09cLFheG9N8tqL30FtKg2g"
    // --- directly using google api
    NSURL *googlePlacesURL = [NSURL URLWithString:url];
    NSMutableURLRequest *googleRequest = [[NSMutableURLRequest alloc] initWithURL:googlePlacesURL];
    [NSURLConnection connectionWithRequest:googleRequest delegate:self];

//    NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:gRequest delegate:self];
    
    /*
    NSData *xmlData = [NSData dataWithContentsOfURL:googlePlacesURL];
    
     *xmlDocument = [[GDataXMLDocument alloc]initWithData:xmlData options:0 error:nil];
    NSArray *arr = [xmlDocument.rootElement elementsForName:@"result"];
    
    for(GDataXMLElement *e in arr )
    {
        [placesOutputArray addObject:e];
    }
    
    */
    
    
    /*////// --- using DB
    
    _criteriaPrice = [[NSMutableString alloc] initWithString:@"2"];
    _criteriaRadius = [[NSMutableString alloc] initWithString:@"1.0"];
    _criteriaLat = [[NSMutableString alloc] initWithString:@"40.767911"];
    _criteriaLng = [[NSMutableString alloc] initWithString: @"-70.33453"];
    
    NSString *post = [NSString stringWithFormat:@"price=%@ & GPSlad=%@ & GPSlong=%@ & radius=%@", _criteriaPrice, _criteriaLat, _criteriaLng, _criteriaRadius];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:@"http://idontknow.info/restRequest.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = [[NSError alloc]init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error: &error ];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Reponse code:%d", [urlResponse statusCode]);
    if([urlResponse statusCode] >=200 && [urlResponse statusCode] < 300) {
        NSLog(@"Response: %@", result);
    }
    */
    
    /*------- from stackoverflow ---------
    NSString *receipt1 = @"username";
    
    NSString *post =[NSString stringWithFormat:@"receipt=%@",receipt1];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"http://localhost:8888/validateaction.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Response Code: %d", [urlResponse statusCode]);
    
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
    {
        NSLog(@"Response: %@", result);
    }
    */
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

- (void)parseGoogleResults :(NSDictionary *)dict {
    // Create an array to store the locations
    NSMutableArray *_locations = [[NSMutableArray alloc] init];
    
    NSArray *resArray = [dict valueForKey:@"results"];
    NSLog(@"results has this many: %d", resArray.count);
    
    // Store each results into array groups
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    for (NSDictionary *groupDic in resArray) {
        IDKDetail *detail = [[IDKDetail alloc] init];
        NSLog(@"-----");
        for (NSString *key in groupDic) {
            NSLog(@"key=%@", key);
            if([ key isEqualToString:@"name"]) {
                [ detail setValue:[groupDic valueForKey:key] forKeyPath:@"Name"];
                [ detail setValue:[groupDic valueForKey:key] forKeyPath:@"venueName"];
            }
            if([ key isEqualToString:@"vicinity"]) {
                [ detail setValue:[groupDic valueForKey:key] forKeyPath:@"address"];
            }
            if([ key isEqualToString:@"icon"]) {
//                NSLog(@"Icon= %@", [groupDic valueForKey:key]);
                
//                [ detail setValue:[groupDic valueForKey:key] forKeyPath:@"iconPath"];
            }
            if([ key isEqualToString:@"types"]) {
                NSArray *gTypes = [groupDic valueForKeyPath:key];
                
                NSString *myTypes = [[groupDic valueForKey:key] componentsJoinedByString:@", "];
//                NSLog(@"myTypes: %@", myTypes);
                
                [detail setValue:myTypes forKeyPath:@"type"];
            }
            if( [key isEqualToString:@"photo"] || [key isEqualToString:@"photos"] ){
                NSLog(@"------Photo ref:%@", [[groupDic objectForKey:key] objectForKey:@"photo_reference"] );
                
                [detail setValue:[[groupDic objectForKey:key] objectForKey:@"photo_reference"] forKeyPath:@"iconPath"];
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
    int numInGroups = [groups count];
    int upperBoundValid = numInGroups-1;
    for( counter = 0; counter < 3; counter++ ) {
        int x = arc4random() % upperBoundValid;
        [_locations addObject: [ groups objectAtIndex:x]];
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
        newLocation.lat = [jsonElement[@"GPSlad"] doubleValue];
        newLocation.lng = [jsonElement[@"GPSlong"] doubleValue];
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Parse the JSON that came in
    NSError *error;
    
    if( self.isEvent ==  NO ) {
        NSDictionary *dArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
        [self parseGoogleResults:dArray];
    } else {
        // Loop through Json objects, create question objects and add them to our questions array
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
        [self parseEventResults:jsonArray];
    }
}

@end