//
//  MainViewBottomBarController.m
//  StoryTeller
//
//  Created by Nipuna H Herath on 5/1/16.
//  Copyright © 2016 Nipuna H Herath. All rights reserved.
//

#import "MainViewBottomBarController.h"
#import "NewStoryViewController.h"


@interface MainViewBottomBarController(){
    CGSize _intrinsicContentSize;
    NewStoryViewController *newStory;
    
}

@end

@implementation MainViewBottomBarController

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"MainViewBottomBar" owner:self options:nil];
        self.bounds = self.view.bounds;
        _intrinsicContentSize = self.bounds.size;
        
        [self addSubview:self.view];
        
    }
    return self;
}
-(CGSize)intrinsicContentSize{
    return _intrinsicContentSize;
}
- (IBAction)newStoryButtonClicked:(UIButton *)sender {
//    if (newStory == NULL) {
//        newStory = [[NewStoryViewController alloc] init];
//    }
//    [[[self superview] viewWithTag:0] addSubview:newStory];
//    CGPoint c = [[self superview] viewWithTag:0].center;
//    newStory.view.center = c;
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    newStory = [storyboard instantiateViewControllerWithIdentifier:@"NewStoryView"];
    
    [self.window.rootViewController presentViewController:newStory
                       animated:YES
                     completion:nil];
}
@end
