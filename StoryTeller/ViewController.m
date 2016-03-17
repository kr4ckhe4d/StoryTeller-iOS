//
//  ViewController.m
//  StoryTeller
//
//  Created by Nipuna H Herath on 3/10/16.
//  Copyright © 2016 Nipuna H Herath. All rights reserved.
//

#import "ViewController.h"
#import "Firebase.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@end
NSMutableDictionary *storyList;
NSArray *array;
NSURLSessionDownloadTask *getImageTask;


NSURLSessionConfiguration *sessionConfig;
NSURLSession *session;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                          delegate:nil delegateQueue:nil];
    
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://firetestapp123.firebaseio.com/mad"];
    
    
    // Attach a block to read the data at our posts reference
    
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@", snapshot.value);
        array = [NSMutableArray arrayWithArray:snapshot.value];
        //array = [storyList allValues];
        
        [self.collectionView reloadData];
        //NSLog(@"%@",storyList);
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfItemsInSlidingMenu {
    NSLog(@"%lu",(unsigned long)[storyList count]);
    return [array count]; // returns menu count
}

- (void)customizeCell:(RPSlidingMenuCell *)slidingMenuCell forRow:(NSInteger)row {
    slidingMenuCell.textLabel.text = [[array objectAtIndex:row] valueForKey:@"title"];
    slidingMenuCell.detailTextLabel.text = [[array objectAtIndex:row] valueForKey:@"story"];
    
    //Getting the Image and viewing it on the Image View
    NSString *imageURL = [[array objectAtIndex:row] valueForKey:@"link"];
    
    getImageTask = [session downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];

            slidingMenuCell.backgroundImageView.image =downloadedImage;
        });
    }];
    [getImageTask resume];
}

//Image download Completion Handler
//-(void)URLSession:(NSURLSession *)session
//     downloadTask:(NSURLSessionDownloadTask *)downloadTask
//didFinishDownloadingToURL:(NSURL *)location
//{
//    // use code above from completion handler
//    UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //_imageView.image = downloadedImage;
//        //slidingMenuCell.backgroundImageView.image = downloadedImage;
//
//    }
//                   );
//    
//}

- (void)slidingMenu:(RPSlidingMenuViewController *)slidingMenu didSelectItemAtRow:(NSInteger)row {
    // when a row is tapped do some action like go to another view controller
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Row Tapped"
                                                    message:[NSString stringWithFormat:@"Row %d tapped.", row]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
