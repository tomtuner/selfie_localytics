//
//  ViewController.h
//  Selfie
//
//  Created by Thomas DeMeo on 9/9/15.
//  Copyright (c) 2015 Thomas DeMeo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AFSelfieAPIClient.h"
#import "SelfieTableViewCell.h"
#import "Posts.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) NSMutableArray* posts;
@property (nonatomic, strong) IBOutlet UITableView *selfieTable;

@end

