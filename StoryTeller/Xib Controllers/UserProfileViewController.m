//
//  UserProfileViewController.m
//  StoryTeller
//
//  Created by Nipuna H Herath on 5/1/16.
//  Copyright © 2016 Nipuna H Herath. All rights reserved.
//

#import "UserProfileViewController.h"
#import "GlobalVars.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface UserProfileViewController(){
    CGSize _intrinsicContentSize;
    __weak IBOutlet UIView *profilePicBackground;
    __weak IBOutlet UIImageView *userProfilePicture;
    __weak IBOutlet UILabel *userName;
}
@end
@implementation UserProfileViewController


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"UserProfileView" owner:self options:nil];
        self.bounds = self.view.bounds;
        _intrinsicContentSize = self.bounds.size;
        profilePicBackground.layer.cornerRadius = profilePicBackground.bounds.size.width/2;
        userProfilePicture.layer.masksToBounds = YES;
        userProfilePicture.layer.cornerRadius = userProfilePicture.bounds.size.width/2;

        [self addSubview:self.view];
        
    }
    return self;
}

-(CGSize)intrinsicContentSize{
    return _intrinsicContentSize;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)willMoveToWindow:(UIWindow *)newWindow{
    NSLog(@"willmovetowindow");
    [self fetchUserInfo];
}

- (IBAction)backButtonClicked:(UIButton *)sender {
    CGPoint c = self.view.center;
    c.y = self.view.bounds.size.height*2;
    [UIView animateWithDuration:0.6 animations:^{
        self.view.center = c;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
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
                 NSLog(@"resultis:%@",result);
                 NSString *url = [NSString stringWithFormat:@"%@",[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                 UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
                 
                 [userName setText:[[NSString stringWithFormat:@"%@",[result objectForKey:@"name"]] uppercaseString]]  ;
                 userProfilePicture.image = image;
                 
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
        
    }
    
}
- (IBAction)btnSignOut:(UIButton *)sender {
    
    
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Sign Out" message:@"Are you sure you want to Sign Out?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Sign Out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        // Sign Out button tappped.
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        
        status = 0;
        
        CGPoint c = self.view.center;
        c.y = self.view.bounds.size.height*2;
        [UIView animateWithDuration:0.6 animations:^{
            self.view.center = c;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    // Present action sheet.
    [self.window.rootViewController presentViewController:actionSheet animated:YES completion:nil];

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
            //[loginButtonOutlet setImage:nil forState:UIControlStateNormal];
            //[loginButtonOutlet setTitle:@"Login" forState:UIControlStateNormal];
}


@end
