//
//  ViewController.m
//  StoryTeller
//
//  Created by Nipuna H Herath on 3/10/16.
//  Copyright © 2016 Nipuna H Herath. All rights reserved.
//

#import "ViewController.h"
#import "StoryViewController.h"
#import "Firebase.h"
#import "MainViewTopBarController.h"
#import "GlobalVars.h"
#import "LoginViewController.h"
#import "MainViewBottomBarController.h"

@interface ViewController ()<UIScrollViewDelegate,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) CGFloat lastContentOffset;


@end
NSMutableDictionary *storyList;
NSMutableArray *array;
NSURLSessionDownloadTask *getImageTask;
NSString *detailedStory;
NSInteger selectedRow;

MainViewTopBarController *m1;
MainViewBottomBarController *bottomBar;

NSString *urlImage;
NSURLSessionConfiguration *sessionConfig;
NSURLSession *session;
UIImage *retrievedImage;
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
        [array removeObjectIdenticalTo:[NSNull null]];

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
    //NSLog(@"%lu",(unsigned long)[storyList count]);
    return [array count]; // returns menu count
}
-(void)abc{
    NSLog(@"lol");
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    NSLog(@"lol");
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        NSLog(@"did end dragging");
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.lastContentOffset > scrollView.contentOffset.y)
    {
        NSLog(@"Scrolling Up %f",scrollView.contentOffset.y);
        if (m1==NULL) {
            m1 = [[MainViewTopBarController alloc] init];
            [m1.view setTag:11];
        }
        [self.view addSubview:m1];
        CGPoint center = m1.center;
        center.x = self.view.center.x;
        center.y = -m1.bounds.size.height;
        m1.center = center;
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            CGPoint newcenter = m1.center;
            //newcenter.x = self.view.center.x;
            
            newcenter.y = m1.bounds.size.height/2;
            m1.center = newcenter;
            
            
        } completion:nil];

    }
    else if (self.lastContentOffset < scrollView.contentOffset.y)
    {
        if (m1==NULL) {
            m1 = [[MainViewTopBarController alloc] init];
            [m1.view setTag:11];

        }
        [self.view addSubview:m1];
        CGPoint center = m1.center;
        center.x = self.view.center.x;
        center.y = -200;
        m1.center = center;
        
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            CGPoint newcenter = m1.center;
            //newcenter.x = self.view.center.x;
            
            newcenter.y = -m1.bounds.size.height;
            m1.center = center;
            
        } completion:nil];
        
        if (status == 1) {
            if (mvCtrller == NULL) {
                mvCtrller = [[MainViewBottomBarController alloc] init];
            }
            [mvCtrller setTag:99];
            [self.view addSubview:mvCtrller];
            CGPoint bottomBarCenter = mvCtrller.center;
            bottomBarCenter.x = self.view.center.x;
            bottomBarCenter.y = self.view.bounds.size.height + mvCtrller.bounds.size.height*2;
            mvCtrller.center = bottomBarCenter;
            
            [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                CGPoint newBottombarCenter = mvCtrller.center;
                //newcenter.x = self.view.center.x;
                
                newBottombarCenter.y = self.view.bounds.size.height-mvCtrller.bounds.size.height/2;
                mvCtrller.center = newBottombarCenter;
                
            } completion:nil];

        }
        
        NSLog(@"Scrolling Down");
    }
    self.lastContentOffset = scrollView.contentOffset.y;

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"willbegin");
    if (self.lastContentOffset > scrollView.contentOffset.y)
    {
        NSLog(@"Scrolling Up");
    }
    else if (self.lastContentOffset < scrollView.contentOffset.y)
    {
        NSLog(@"Scrolling Down");
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (m1==NULL) {
        m1 = [[MainViewTopBarController alloc] init];
        [m1.view setTag:11];

    }
    if (scrollView.contentOffset.y == 0) {
        [self.view addSubview:m1];
        CGPoint center = m1.center;
        center.x = self.view.center.x;
        center.y = -m1.bounds.size.height;
        m1.center = center;
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            CGPoint newcenter = m1.center;
            //newcenter.x = self.view.center.x;
            
            newcenter.y = m1.bounds.size.height/2;
            m1.center = newcenter;
            
            
        } completion:nil];
    }
    NSLog(@"did end decelerating");
}

//-(void) showLoginView{
//    LoginViewController *loginv = [[LoginViewController alloc] init];
//    
//    [self.view addSubview:loginv];
//    loginv.center = self.view.center;
//}

- (void)customizeCell:(RPSlidingMenuCell *)slidingMenuCell forRow:(NSInteger)row {
    
    slidingMenuCell.textLabel.text = [array[row] valueForKey:@"title"];
    slidingMenuCell.detailTextLabel.text = [array[row] valueForKey:@"story"];
    detailedStory = [NSString stringWithFormat:@"%@",[array[row] valueForKey:@"story"]];
    
    //Getting the Image and viewing it on the Image View
    NSString *imageURL = [array[row] valueForKey:@"link"];
    urlImage = [NSString stringWithFormat:@"%ld",(long)row];
    getImageTask = [session downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            retrievedImage = downloadedImage;
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
    
    [self performSegueWithIdentifier:@"STORY" sender:self];
    selectedRow = row;
    urlImage = [NSString stringWithFormat:@"%ld",(long)row];

   NSLog(@"%ld",(long)selectedRow);
    
    }

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    StoryViewController *storyView = (StoryViewController *)segue.destinationViewController;
        //Getting the Image and viewing it on the Image View
   NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
   NSLog(@"%ld",(long)[indexPath row]);
    NSInteger row = [indexPath row];
    
    storyView.story = [NSString stringWithFormat:@"%@",[array[row] valueForKey:@"story"]];
    storyView.storyTitle = [array[row] valueForKey:@"title"];
    
    //Getting the Image and viewing it on the Image View
    NSString *imageURL = [array[row] valueForKey:@"link"];
    urlImage = [NSString stringWithFormat:@"%ld",(long)row];
    getImageTask = [session downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            //retrievedImage = downloadedImage;
            storyView.storyImage.image =downloadedImage;
            storyView.background.image =downloadedImage;
        });
    }];
    [getImageTask resume];
}
@end
