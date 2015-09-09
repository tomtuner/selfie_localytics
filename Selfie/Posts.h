//
//  Posts.h
//  Selfie
//
//  Created by Thomas DeMeo on 9/9/15.
//  Copyright (c) 2015 Thomas DeMeo. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Posts : NSManagedObject

@property (nonatomic, retain) NSString * attribution;
@property (nonatomic, retain) NSArray * tags;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDictionary * comments;
@property (nonatomic, retain) NSString * filter;
@property (nonatomic, retain) NSString * created_time;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSDictionary * likes;
@property (nonatomic, retain) NSString * large_image_url;
@property (nonatomic, retain) NSString * user_name;
@property (nonatomic, retain) NSString * caption_text;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * identifier;


@end
