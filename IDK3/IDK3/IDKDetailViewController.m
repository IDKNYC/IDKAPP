//
//  IDKDetailViewController.m
//  IDK3
//
//  Created by SATOKO HIGHSTEIN on 7/1/14.
//  Copyright (c) 2014 SATOKO HIGHSTEIN. All rights reserved.
//

#import "IDKDetailViewController.h"

@interface IDKDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *Type;
@property (weak, nonatomic) IBOutlet UILabel *Address;
@property (weak, nonatomic) IBOutlet UILabel *Time;
@property (weak, nonatomic) IBOutlet MKMapView *myMap;
@property (weak, nonatomic) IBOutlet UITextView *infoLong;
@property (weak, nonatomic) IBOutlet UILabel *Info;
@property (weak, nonatomic) IBOutlet UILabel *venueName;
@property (weak, nonatomic) IBOutlet UILabel *Date;
@property (weak, nonatomic) IBOutlet UIImageView *Logo;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"venueName is set to %@", self.selectedVenue.venueName );
    
    self.Name.text = self.selectedVenue.Name;
    _Name.font = [UIFont boldSystemFontOfSize:21.0f];
    self.Type.text = self.selectedVenue.type;
    self.Address.text = [NSMutableString stringWithFormat: @"Address: %@", self.selectedVenue.address];
    
    NSLog(@"Icon path:%@", self.selectedVenue.iconPath);
    
    NSURL *imageURL;
    
    if(self.selectedVenue.isEvent){
        imageURL = [NSURL URLWithString: self.selectedVenue.iconPath ];
    } else {
        if( self.selectedVenue.iconPath ) {
            imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?%@", self.selectedVenue.iconPath] ];
        } else {
            self.Logo.hidden = YES; 
        }
    }
    
    
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    [self.Logo setImage:image];
    
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
    
    [self viewWillAppear:YES];
//    [self.view addSubview:self.Logo];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
