//
//  IDKCoinFlipperViewController.h
//  IDK
//
//  Created by MahdiMakki on 6/5/14.
//  Copyright (c) 2014 Capstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDKCoinFlipperViewController : UIViewController <UINavigationBarDelegate, UINavigationControllerDelegate>

//@property (strong, nonatomic) IBOutlet UITextField *option1;

//@property (strong, nonatomic) IBOutlet UITextField *option2;
//@property (strong, nonatomic) IBOutlet UILabel *result;

//- (IBAction)Flip:(UIButton *)sender;

//-(IBAction)dismissKeyboard:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITextField *option1;

@property (strong, nonatomic) IBOutlet UITextField *option2;
@property (strong, nonatomic) IBOutlet UILabel *result;

- (IBAction)Flip:(UIButton *)sender;

-(IBAction)dismissKeyboard:(UIButton *)sender;
@end
