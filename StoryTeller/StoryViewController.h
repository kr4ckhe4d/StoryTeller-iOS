//
//  StoryViewController.h
//  StoryTeller
//
//  Created by Nipuna H Herath on 3/19/16.
//  Copyright © 2016 Nipuna H Herath. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StoryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *storyImage;
@property (weak, nonatomic) IBOutlet UILabel *lblStory;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic) NSString *story;
@property (nonatomic) NSString *storyTitle;
@property (weak, nonatomic) IBOutlet UIImageView *background;

@property (nonatomic) int *row;
@end
