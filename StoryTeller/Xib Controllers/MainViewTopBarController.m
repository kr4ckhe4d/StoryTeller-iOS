//
//  MainViewTopBarController.m
//  StoryTeller
//
//  Created by Nipuna H Herath on 5/1/16.
//  Copyright © 2016 Nipuna H Herath. All rights reserved.
//

#import "MainViewTopBarController.h"
#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface MainViewTopBarController(){
    CGSize _intrinsicContentSize;
    LoginViewController *lvc1;
    FBSDKLoginButton *loginButton;
    __weak IBOutlet UIButton *loginButtonOutlet;
}
@end

@implementation MainViewTopBarController

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
        [[NSBundle mainBundle] loadNibNamed:@"MainViewTopBar" owner:self options:nil];
        self.bounds = self.view.bounds;
        _intrinsicContentSize = self.bounds.size;
        
        BOOL isLoggedIn = NO;
        
        if ([FBSDKAccessToken currentAccessToken]) {
            isLoggedIn = YES;
            NSLog(@"facebook already connected");
            [loginButtonOutlet setTitle:@"Logout" forState:UIControlStateNormal];
            [loginButtonOutlet setImage:[UIImage imageNamed:@"proPicImage"] forState:UIControlStateNormal];

        }

        
        [self addSubview:self.view];
        
    }
    return self;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (IBAction)loginBtnClicked:(UIButton *)sender {
    if ([loginButtonOutlet.titleLabel.text  isEqual: @"Login"]) {
        if (lvc1 == NULL) {
            lvc1 = [[LoginViewController alloc] init];
            [lvc1 setTag:5];
            
        }
        
        [[[self superview] viewWithTag:0] addSubview:lvc1];
        CGPoint c = [[self superview] viewWithTag:0].center;
        c.y = - lvc1.bounds.size.height;
        lvc1.center = c;
        
        [UIView animateWithDuration:0.6 animations:^{
            CGPoint center = lvc1.center;
            center.y = [[self superview] viewWithTag:0].center.y;
            lvc1.center = center;
        } completion:^(BOOL finished) {
            if (loginButton == NULL) {
                loginButton = [[FBSDKLoginButton alloc] init];
            }
            
            // Add a custom login button to your app
            UIButton *myLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
            //myLoginButton.backgroundColor=[UIColor blueColor];
            [myLoginButton setImage:[UIImage imageNamed:@"facebookLoginButton"] forState:UIControlStateNormal];
            myLoginButton.frame=CGRectMake(0,0,180,40);
            myLoginButton.center = [lvc1.view viewWithTag:2].center ;
            //[myLoginButton setTitle: @"Login with Facebook" forState: UIControlStateNormal];
            myLoginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            myLoginButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

            // Handle clicks on the button
            [myLoginButton
             addTarget:self
             action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            
            // Add the button to the view
            [lvc1.view addSubview:myLoginButton];
        }];
    }
    if ([loginButtonOutlet.titleLabel.text isEqual:@"Logout"]) {
        
        BOOL isLoggedIn = NO;
        
        if ([FBSDKAccessToken currentAccessToken]) {
            isLoggedIn = YES;
            NSLog(@"facebook already connected");
        }
        
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        
        [loginButtonOutlet setImage:nil forState:UIControlStateNormal];
        [loginButtonOutlet setTitle:@"Login" forState:UIControlStateNormal];
    }
    
    
}

-(void)loginButtonClicked
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
     fromViewController:nil
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             [lvc1 removeFromSuperview];
             [loginButtonOutlet setTitle:@"Logout" forState:UIControlStateNormal];
             [loginButtonOutlet setImage:[UIImage imageNamed:@"proPicImage"] forState:UIControlStateNormal];
             NSLog(@"Logged in");
             //[self fetchUserInfo];

         }
     }];
}

-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 //NSLog(@"resultis:%@",result);
                 NSLog(@"%@",[NSString stringWithFormat:@"%@",[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]]);
                 //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:MyURL]]];

             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
        
    }
    
}

-(CGSize)intrinsicContentSize{
    return _intrinsicContentSize;
}
@end
