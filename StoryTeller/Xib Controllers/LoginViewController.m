//
//  LoginViewController.m
//  StoryTeller
//
//  Created by Nipuna H Herath on 5/1/16.
//  Copyright © 2016 Nipuna H Herath. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController(){
    CGSize _intrinsicContentSize;
    __weak IBOutlet UIView *fbButton;
}
@end
@implementation LoginViewController

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
        [[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil];
        self.bounds = self.view.bounds;
        _intrinsicContentSize = self.bounds.size;
        
        [self addSubview:self.view];
        
    }
    return self;
}
- (IBAction)loginBtnClicked:(UIButton *)sender {
    BOOL isLoggedIn = NO;

    if ([FBSDKAccessToken currentAccessToken]) {
        isLoggedIn = YES;
        NSLog(@"facebook already connected");
    }
}


- (IBAction)dismissBtnSelected:(UIButton *)sender {
    
    [UIView animateWithDuration:0.6 animations:^{
        CGPoint center = self.center;
        center.y = -self.bounds.size.height;
        self.center = center;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];

    }];
}


-(CGSize)intrinsicContentSize{
    return _intrinsicContentSize;
}

#pragma mark - hide keyboard
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
