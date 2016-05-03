//
//  StoryViewController.m
//  StoryTeller
//
//  Created by Nipuna H Herath on 3/19/16.
//  Copyright © 2016 Nipuna H Herath. All rights reserved.
//

#import "StoryViewController.h"
#import "NFXIntroViewController.h"


@interface StoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation StoryViewController

-(void)viewWillAppear:(BOOL)animated{
    UIImage*i1 = [UIImage imageNamed:@"closeButton"];
    UIImage*i2 = [UIImage imageNamed:@"newImage"];
    UIImage*i3 = [UIImage imageNamed:@"pencil"];
    UIImage*i4 = [UIImage imageNamed:@"plusButton"];
    UIImage*i5 = [UIImage imageNamed:@"proPicImage"];
    UIImage*i6 = [UIImage imageNamed:@"save"];
    UIImage*i7 = [UIImage imageNamed:@"Splash"];
    
    
    //NFXIntroViewController *vc = [[NFXIntroViewController alloc] initWithViews:@[i1,i2,i3,i4,i5,i2,i6,i7]];
    
    
    NFXIntroViewController *vc = [[NFXIntroViewController alloc] initWithViews:@[i1,i2,i3,i4,i5,i2,i6,i7] storydata:_storyData];
    NSLog(@"%@",_storyData);
    [self presentViewController:vc animated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = self.storyTitle;
//    self.lblStory.text = self.story;
//    self.lblTitle.text = self.storyTitle;
//    //self.background.image = self.storyImage.image;
//    self.background.alpha = 0.6;
//    self.lblStory.lineBreakMode = NSLineBreakByWordWrapping;
//    self.lblStory.numberOfLines = 0;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBack:(id)sender {
//    self.storyImage = NULL;
//    self.lblStory = NULL;
//
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
