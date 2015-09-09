//
//  SelfieTableViewCell.h
//  Selfie
//
//  Created by Thomas DeMeo on 9/9/15.
//  Copyright (c) 2015 Thomas DeMeo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfieTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel *captionLabel;
@property(nonatomic, strong) IBOutlet UIImageView *selfieImageView;

@end
