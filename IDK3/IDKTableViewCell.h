//
//  IDKTableViewCell.h
//  IDK3
//
//  Created by SATOKO HIGHSTEIN on 7/1/14.
//  Copyright (c) 2014 SATOKO HIGHSTEIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDKTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellName;
@property (weak, nonatomic) IBOutlet UILabel *cellAddress;
@property (weak, nonatomic) IBOutlet UILabel *cellType;

@end
