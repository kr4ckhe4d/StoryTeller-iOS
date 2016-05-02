//
//  NewStoryViewController.m
//  StoryTeller
//
//  Created by Nipuna H Herath on 5/2/16.
//  Copyright © 2016 Nipuna H Herath. All rights reserved.
//

#import "NewStoryViewController.h"
#import <jot/jot.h>
#import "GlobalVars.h"
@import AssetsLibrary;
@import Photos;
#import <Masonry/Masonry.h>


@interface NewStoryViewController ()<UIImagePickerControllerDelegate>
@property (nonatomic, strong) JotViewController *jotViewController;
//@property (weak, nonatomic) IBOutlet UIButton *DrawModeBtn;

@end
UIButton *DrawModeBtn;
UIButton *TextModeBtn;
UIButton *AddImageBtn;
UIButton *SaveImageBtn;
UIButton *closeViewControllerBtn;

NSString *imageMode;

UIImage *imageBackground;
UIImage *drawnImage;
UIImageView *previewImage;

CGFloat buttonWidth = 30;

@implementation NewStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _jotViewController = [JotViewController new];
    self.jotViewController.delegate = self;
    
    [self addChildViewController:self.jotViewController];
    [self.view addSubview:self.jotViewController.view];
    [self.jotViewController didMoveToParentViewController:self];
    self.jotViewController.view.frame = self.view.frame;
    self.jotViewController.textColor = [UIColor blackColor];
    

    imageMode = @"NoBackground";
    
    
    
    DrawModeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [DrawModeBtn addTarget:self
               action:@selector(drawModePressed:)
     forControlEvents:UIControlEventTouchUpInside];
    [DrawModeBtn setTitle:@"DrawMode" forState:UIControlStateNormal];
    [DrawModeBtn setImage:[UIImage imageNamed:@"pencil"] forState:UIControlStateNormal];
    DrawModeBtn.frame = CGRectMake(20, self.view.bounds.size.height-buttonWidth, buttonWidth , buttonWidth);
    [_jotViewController.view addSubview:DrawModeBtn];

    
    TextModeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [TextModeBtn addTarget:self
                    action:@selector(textModePressed:)
          forControlEvents:UIControlEventTouchUpInside];
    [TextModeBtn setTitle:@"TextMode" forState:UIControlStateNormal];
    [TextModeBtn setImage:[UIImage imageNamed:@"text"] forState:UIControlStateNormal];
    TextModeBtn.frame = CGRectMake(self.view.bounds.size.width-buttonWidth-20, self.view.bounds.size.height-buttonWidth, buttonWidth , buttonWidth);
    [_jotViewController.view addSubview:TextModeBtn];
    
    
    AddImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [AddImageBtn addTarget:self
                    action:@selector(newBackground:)
          forControlEvents:UIControlEventTouchUpInside];
    [AddImageBtn setTitle:@"AddImage" forState:UIControlStateNormal];
    [AddImageBtn setImage:[UIImage imageNamed:@"newImage"] forState:UIControlStateNormal];
    AddImageBtn.frame = CGRectMake(self.view.center.x-buttonWidth/2, self.view.bounds.size.height-buttonWidth, buttonWidth , buttonWidth);
    [_jotViewController.view addSubview:AddImageBtn];
    
    
    SaveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [SaveImageBtn addTarget:self
                    action:@selector(saveImagePressed:)
          forControlEvents:UIControlEventTouchUpInside];
    [SaveImageBtn setTitle:@"SaveImage" forState:UIControlStateNormal];
    [SaveImageBtn setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    SaveImageBtn.frame = CGRectMake(20, 20, buttonWidth , buttonWidth);
    [_jotViewController.view addSubview:SaveImageBtn];
    
    closeViewControllerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeViewControllerBtn addTarget:self
                    action:@selector(closeButtonPressed:)
          forControlEvents:UIControlEventTouchUpInside];
    [closeViewControllerBtn setTitle:@"DrawMode" forState:UIControlStateNormal];
    [closeViewControllerBtn setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
    closeViewControllerBtn.frame = CGRectMake(self.view.bounds.size.width-buttonWidth-20, 20, buttonWidth , buttonWidth);
    [_jotViewController.view addSubview:closeViewControllerBtn];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)deselectAllModes{
    [DrawModeBtn setBackgroundColor:[UIColor clearColor]];
    [TextModeBtn setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - button actions

-(void)saveImagePressed:(UIButton *)sender{
    if ([imageMode  isEqual: @"WithBackground"]) {
        drawnImage = [self.jotViewController drawOnImage:imageBackground];
    }
    else{
        drawnImage = [self.jotViewController renderImageWithScale:2.f
                                                          onColor:self.view.backgroundColor];
    }
    
    [self.jotViewController clearAll];
    
    
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    [library writeImageToSavedPhotosAlbum:[drawnImage CGImage]
                              orientation:(ALAssetOrientation)[drawnImage imageOrientation]
                          completionBlock:^(NSURL *assetURL, NSError *error){
                              if (error) {
                                  NSLog(@"Error saving photo: %@", error.localizedDescription);
                              } else {
                                  [previewImage removeFromSuperview];
                                  imageBackground = NULL;
                                  NSLog(@"Saved photo to saved photos album.");
                              }
                          }];

}

- (void)drawModePressed:(UIButton *)sender{
    [self deselectAllModes];
    [DrawModeBtn setBackgroundColor:[UIColor lightGrayColor]];
    self.jotViewController.state = JotViewStateDrawing;
}

-(void)textModePressed:(UIButton *)sender{
    [self deselectAllModes];
    [TextModeBtn setBackgroundColor:[UIColor lightGrayColor]];
    self.jotViewController.textColor = [UIColor blackColor];
    self.jotViewController.state = JotViewStateEditingText;
    NSLog(@"%@",self.jotViewController.textString);
}

-(void)newBackground:(UIButton *)sender{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
    imageMode = [NSString stringWithFormat:@"WithBackground"];
}

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    imageBackground = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    previewImage = [[UIImageView alloc] initWithImage:imageBackground];
    
    previewImage.frame = self.jotViewController.view.frame;
    
    [self.jotViewController.view addSubview:previewImage ];
    [self.jotViewController.view sendSubviewToBack:previewImage ];
    
    
    //[self.jotViewController.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)closeButtonPressed:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
