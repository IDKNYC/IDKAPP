//
//  IDKDetailViewController.m
//  IDK3
//
//  Created by SATOKO HIGHSTEIN on 7/1/14.
//  Copyright (c) 2014 IDKNY. All rights reserved.
//

#import "IDKDetailViewController.h"

@interface IDKDetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel *Name;
@property (strong, nonatomic) IBOutlet UILabel *Type;
@property (strong, nonatomic) IBOutlet UILabel *Address;
@property (strong, nonatomic) IBOutlet UILabel *Time;
@property (strong, nonatomic) IBOutlet MKMapView *myMap;
@property (strong, nonatomic) IBOutlet UITextView *infoLong;
@property (strong, nonatomic) IBOutlet UILabel *Info;
@property (strong, nonatomic) IBOutlet UILabel *venueName;
@property (strong, nonatomic) IBOutlet UILabel *Date;
@property (strong, nonatomic) IBOutlet UIImageView *Logo;

@end


@implementation IDKDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

    CLLocationCoordinate2D coord;
//    if([self.selectedVenue.lat]){}
//    if( self.selectedVenue.lat != *nil) {
        coord.latitude =  self.selectedVenue.lat;
        coord.longitude = self.selectedVenue.lng;
//    } else {
//        coord.latitude = 40.7679;
//        coord.longitude = -73.9650;
//    }
    
    
    MKCoordinateSpan span = {.latitudeDelta =  0.020, .longitudeDelta =  0.020};
    MKCoordinateRegion region = {coord, span};
    
    IDKAnnotation *annotation = [[IDKAnnotation alloc] initWithCoordinate:coord title:self.selectedVenue.venueName];
    
    _myMap.showsUserLocation=YES;
    _myMap.zoomEnabled = YES;

    [_myMap addAnnotation:annotation];
    [_myMap setRegion:region animated:YES];
    
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.selectedVenue = [[IDKDetail alloc] init];
    }
    return self;
}

- (void) viewDidLayoutSubviews
{
    self.scrollView.contentSize = CGSizeMake(320, 800);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    [IDKCommon addGradientLayerForView:self.view withTopColor:[UIColor whiteColor] bottomColor:[UIColor lightGrayColor]];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"venueName is set to %@", self.selectedVenue.venueName );
    
    self.Name.text = self.selectedVenue.Name;
    _Name.font = [UIFont boldSystemFontOfSize:21.0f];
    self.Type.text = self.selectedVenue.type;
    self.Address.text = [NSMutableString stringWithFormat: @"Address: %@", self.selectedVenue.address];
    
    NSLog(@"Icon path:%@", self.selectedVenue.iconPath);
//    NSURL * imageURL = [NSURL URLWithString:@"http://farm4.static.flickr.com/3092/2915896504_a88b69c9de.jpg"];
    NSURL * imageURL = [NSURL URLWithString: self.selectedVenue.iconPath ];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    [self.Logo setImage:image];
//    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3092/2915896504_a88b69c9de.jpg"]]];
//    self.logo = [[UIImageView alloc] initWithImage: image];
    if( self.selectedVenue.time == nil) {
        self.Date.hidden = true;
        [self.Date sizeToFit];
        self.venueName.hidden = true;
        [self.venueName sizeToFit];
        self.Info.hidden = true;
        [self.Info sizeToFit];
        self.infoLong.hidden = true;
    } else {
        NSMutableString *dateTime = [[NSMutableString alloc] init];
        if( self.selectedVenue.date ) {
            [dateTime setString: self.selectedVenue.date];
        }
        if( self.selectedVenue.time) {
            [dateTime appendString: [NSString stringWithFormat:@" at %@", self.selectedVenue.time]];
        }
        self.Date.text = dateTime;
        self.venueName.text = self.selectedVenue.venueName;
        self.venueName.font = [UIFont systemFontOfSize:17.0f];
        self.infoLong.text = [NSMutableString stringWithFormat:@"Info:\n%@", self.selectedVenue.info];
    }
    

    
    // [self viewWillAppear:YES];
    //[self.view addSubview:self.Logo];

}

- (void) viewDidAppear:(BOOL)animated
{
    if (self.Logo.image == nil) {
        NSLog(@"Image is nil");
        [self.Logo removeFromSuperview];
        [UIView animateWithDuration:1.0
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.myMap.frame = CGRectMake(self.myMap.frame.origin.x, self.myMap.frame.origin.y-180, self.myMap.frame.size.width, self.myMap.frame.size.height);
                             self.venueName.frame = CGRectMake(self.venueName.frame.origin.x, self.venueName.frame.origin.y-180, self.venueName.frame.size.width, self.venueName.frame.size.height);
                             self.Address.frame = CGRectMake(self.Address.frame.origin.x, self.Address.frame.origin.y-180, self.Address.frame.size.width, self.Address.frame.size.height);
                         }
                         completion:^(BOOL finished){}];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
