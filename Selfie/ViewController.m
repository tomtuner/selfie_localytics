//
//  ViewController.m
//  Selfie
//
//  Created by Thomas DeMeo on 9/9/15.
//  Copyright (c) 2015 Thomas DeMeo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = self.selfieTable.bounds;
    frame.origin.y = -frame.size.height;

    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *operations = [NSMutableArray array];
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"8ff126431bd74804a9638db1e5eac5a5" forKey:@"client_id"];
    NSMutableURLRequest *request = [[AFSelfieAPIClient sharedClient]
                                    GETRequestWithParameters:param];
    AFHTTPRequestOperation *operation = [[AFSelfieAPIClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *e = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData: responseObject options: NSJSONReadingMutableContainers error: &e];
        NSArray *data = [response objectForKey:@"data"];
        NSLog(@"Response: %@", data);

        AppDelegate *dele = [[UIApplication sharedApplication] delegate];
        [dele removeAllCoreDataObjects];
        [dele processIntoCoreDataWithArray:data];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed with error: %@", error);
    }];
    
    [operations addObject:operation];
    
    [[AFSelfieAPIClient sharedClient] enqueueBatchOfHTTPRequestOperations:operations progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        NSLog(@"All operations completed");
        [self loadRecordsFromCoreData];
        
    }];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelfieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kSelfieTableViewCell" forIndexPath:indexPath];
    
    if (cell == nil)
        cell = [[SelfieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kSelfieTableViewCell"];
    Posts *post = self.posts[indexPath.row];
    
    cell.captionLabel.text = post.caption_text;
    cell.selfieImageView.image = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *temp = [NSString stringWithFormat:@"%@", post.large_image_url ];
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:temp]]];
        if (imgData) {
            UIImage *image = [UIImage imageWithData:imgData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SelfieTableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell)
                        updateCell.selfieImageView.image = image;
                });
            }
        }
    });
    // Configure Cell here
    return cell;
}



- (void)loadRecordsFromCoreData {
    AppDelegate *dele = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = [dele managedObjectContext];
    [moc performBlockAndWait:^{
        [moc reset];
        
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Posts"];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event_id = %@", self.detailItem.remote_id];
//        NSLog(@"Event_ID: %@", self.detailItem.remote_id);
//        [request setPredicate:predicate];
//        [request setSortDescriptors:[NSArray arrayWithObject:
//                                     [NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:NO]]];
        self.posts = [moc executeFetchRequest:request error:&error];
        
        [self.selfieTable reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
