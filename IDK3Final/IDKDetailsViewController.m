//
//  IDKDetailsViewController.m
//  IDK3
//
//  Created by Mahdi Makki on 7/15/14.
//  Copyright (c) 2014 IDKNY. All rights reserved.
//

#import "IDKDetailsViewController.h"

@interface IDKDetailsViewController ()

@property (strong, nonatomic) UIImageView *logo;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *type;
@property (strong, nonatomic) UILabel *address;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UILabel *venue;
@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *info;

@end

@implementation IDKDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *Navimage = [UIImage imageNamed: @"ios-result-view.png"];
    [self.navigationController.navigationBar setBackgroundImage:Navimage forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20]}];
    self.navigationItem.title = @"IDK!?";
    self.navigationController.navigationBar.topItem.title = @"Back";
    //self.navigationItem.backBarButtonItem.title = @"back";
    // self.navigationItem.title = self.selectedVenue.Name;
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self; // Set delegate
        CGFloat y = 84;
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 280, 22)]; // 22
    self.name.numberOfLines = 2; // Label can be 2 lines
  
    [self setupLabel:self.name
            withText:self.selectedVenue.Name
                font:[UIFont boldSystemFontOfSize:20.0f]
           textColor:[UIColor darkGrayColor]
       textAlignment:NSTextAlignmentLeft];
    [self.name sizeToFit]; // Resize label if there's need
    //
    [self.scrollView addSubview:self.name];
    y = self.name.frame.origin.y + self.name.frame.size.height + 10;

    if (self.selectedVenue.info.length > 0)
    {

        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, y, 280, 150)];
        self.textView.font = [UIFont systemFontOfSize:14.0];
        self.textView.textColor = [UIColor grayColor];
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.editable = NO;
        self.textView.text = self.selectedVenue.info;
        [self.textView sizeToFit];
        CGFloat height = 280;
        if (self.textView.frame.size.width > height) {
            self.textView.frame = CGRectMake(20, y, 280, height);
        } else {
      
            self.textView.scrollEnabled = NO;
        }
        [self.scrollView addSubview:self.textView];
        y = self.textView.frame.origin.y + self.textView.frame.size.height + 10;
    }
    if (self.selectedVenue.type.length > 0) {

        self.type = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 280, 22)];
        
        [self setupLabel:self.type
                withText:self.selectedVenue.type
                    font:[UIFont systemFontOfSize:16.0]
               textColor:[UIColor lightGrayColor]
           textAlignment:NSTextAlignmentLeft];
      
        [self.scrollView addSubview:self.type];
        y = self.type.frame.origin.y + self.type.frame.size.height + 10;
    }
    NSString *dateAndTime;
    if (self.selectedVenue.date.length > 0) {
        dateAndTime = self.selectedVenue.date;
    }
    if (self.selectedVenue.time.length > 0) {
        dateAndTime = [dateAndTime stringByAppendingString:
                       [NSString stringWithFormat:@" at %@", self.selectedVenue.time]];
    }
    if (dateAndTime.length > 0) {
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 280, 22)];
        //
        [self setupLabel:self.date
                withText:dateAndTime
                    font:[UIFont systemFontOfSize:16.0]
               textColor:[UIColor lightGrayColor]
           textAlignment:NSTextAlignmentLeft];
        //
        [self.scrollView addSubview:self.date];
        y = self.date.frame.origin.y + self.date.frame.size.height + 10;
    }
    
    // -- setting the correct path to get images
    NSString *pathToPhoto = [[ NSString alloc] init ];
    if( ![self.selectedVenue.photoPath  isEqual: @""]  ) {
        pathToPhoto = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxheight=180&maxwidth=280&photoreference=%@", self.selectedVenue.photoPath ];
    }
    else {
        pathToPhoto = [ NSString stringWithFormat: @"%@", self.selectedVenue.iconPath ];
    }
    
    NSURL *imageURL = [NSURL URLWithString: pathToPhoto];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    if (image) {
        self.logo = [[UIImageView alloc] initWithImage:image];
        self.logo.frame = CGRectMake(self.logo.frame.origin.x, y, self.logo.frame.size.width, self.logo.frame.size.height);
        self.logo.center = CGPointMake(self.view.bounds.size.width/2.0, self.logo.center.y);
        if (self.logo.frame.size.width > 280) {
            self.logo.frame = CGRectMake(20, y, 280, 180);
            self.logo.contentMode = UIViewContentModeScaleAspectFit;
        }
        [self.scrollView addSubview:self.logo];
        y = self.logo.frame.origin.y + self.logo.frame.size.height + 10;
    }
    //
    if (self.selectedVenue.address.length > 0) {
        self.address = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 280, 22)];
        self.address.numberOfLines = 0;
       
        [self setupLabel:self.address
                withText:[NSString stringWithFormat:@"Address: %@", self.selectedVenue.address]
                    font:[UIFont systemFontOfSize:16.0]
               textColor:[UIColor lightGrayColor]
           textAlignment:NSTextAlignmentLeft];
        [self.address sizeToFit];
        
        [self.scrollView addSubview:self.address];
        y = self.address.frame.origin.y + self.address.frame.size.height + 10;
    }
    // Map
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(20, y, 280, 180)];
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled = YES;
    self.mapView.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.mapView];
    y+= 20;

    if (y + self.mapView.frame.size.height < self.view.bounds.size.height) {
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + 1.0);
    } else {
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, y + self.mapView.frame.size.height);
    }
   
    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CLLocationCoordinate2D coord;
    coord.latitude =  [self.selectedVenue.lat doubleValue];
    coord.longitude = [self.selectedVenue.lng doubleValue];
    MKCoordinateSpan span = {.latitudeDelta =  0.002, .longitudeDelta =  0.002};
    MKCoordinateRegion region = {coord, span};
    IDKAnnotation *annotation = [[IDKAnnotation alloc]initWithCoordinate:coord title:self.selectedVenue.venueName];
    [self.mapView addAnnotation:annotation];
    [self.mapView setRegion:region animated:YES];
}


- (void) setupLabel:(UILabel *)label withText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment
{
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.textAlignment = textAlignment;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
