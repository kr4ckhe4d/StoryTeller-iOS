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
#import "Firebase.h"



@interface NewStoryViewController ()<UIImagePickerControllerDelegate>
@property (nonatomic, strong) JotViewController *jotViewController;
//@property (weak, nonatomic) IBOutlet UIButton *DrawModeBtn;

@end
UIButton *DrawModeBtn;
UIButton *TextModeBtn;
UIButton *AddImageBtn;
UIButton *SaveImageBtn;

UIButton *MainPageBtn;
UIButton *AddOnePage;

NSMutableArray *pagesArray;


UIButton *closeViewControllerBtn;

NSString *imageMode;

int storycount;

UIImage *imageBackground;
UIImage *drawnImage;
UIImageView *previewImage;

CGFloat buttonWidth = 30;
Firebase *ref;
@implementation NewStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ref = [[Firebase alloc] initWithUrl:@"https://firetestapp123.firebaseio.com/mad"];
    
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        storycount = [snapshot.value count];
        NSLog(@"%d",snapshot.childrenCount);
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];

    
    
    _jotViewController = [JotViewController new];
    self.jotViewController.delegate = self;
    
    [self addChildViewController:self.jotViewController];
    [self.view addSubview:self.jotViewController.view];
    [self.jotViewController didMoveToParentViewController:self];
    self.jotViewController.view.frame = self.view.frame;
    self.jotViewController.textColor = [UIColor blackColor];
    

    imageMode = @"NoBackground";
    
    MainPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [MainPageBtn addTarget:self
                    action:@selector(showMainPage:)
          forControlEvents:UIControlEventTouchUpInside];
    [MainPageBtn setTitle:@"Main Page" forState:UIControlStateNormal];
    [MainPageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [MainPageBtn setBackgroundColor:[UIColor blueColor]];
    //[MainPageBtn setImage:[UIImage imageNamed:@"pencil"] forState:UIControlStateNormal];
    MainPageBtn.frame = CGRectMake(20, 100, 100 , 100);
    [_jotViewController.view addSubview:MainPageBtn];
    
    
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

-(void)showMainPage:(UIButton *)sender{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Publish Story"
                                                                              message: @"Input title and summary"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Title";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Summary";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * titlefield = textfields[0];
        UITextField * summaryfiled = textfields[1];
        NSLog(@"%@:%@",titlefield.text,summaryfiled.text);
        
        
        
        
        NSString *urlString = [NSString stringWithFormat:@"http://192.168.1.2/uploader/test.php"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        
        NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
        
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        
        //Populate a dictionary with all the regular values you would like to send.
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters setValue:[NSString stringWithFormat:@"%@",titlefield.text] forKey:@"param1-name"];
        
        [parameters setValue:@"lol" forKey:@"param2-name"];
        
        [parameters setValue:@"lol" forKey:@"param3-name"];
        
        
        // add params (all params are strings)
        for (NSString *param in parameters) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        
        for (int i = 0 ; i<[pagesArray count]; i++) {
//            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//            
//            [parameters setValue:[NSString stringWithFormat:@"%d",i] forKey:@"fileindex"];
//            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
//            
//            
            
            NSData *imageData = UIImagePNGRepresentation(pagesArray[i]);
            
            //NSMutableData *body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile%d\"; filename=\"%d.png\"\r\n",i,i] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imageData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
            [request setHTTPBody:body];
            
            //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            //
            //
            //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            //
            //    NSLog(@"Image Return String: %@", returnString);
            
            NSURLSessionUploadTask *session = [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:nil completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSLog(@"Image Return String: %@", returnString);
                
                NSString *linkfield = [NSString stringWithFormat:@"http://192.168.1.2/uploader/%@/0.png",titlefield.text];
                
                
                NSDictionary *alanisawesome = @{
                                                @"link" : linkfield,
                                                @"story": summaryfiled.text,
                                                @"title":titlefield.text
                                                };
                Firebase *alanRef = [ref childByAppendingPath: [NSString stringWithFormat:@"%d",storycount]];
                [alanRef setValue: alanisawesome];
            }];
            
            [session resume];
        
        NSLog(@"done");

        
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    
    
    NSLog(@"%lu",(unsigned long)[pagesArray count]);
    
    
}




-(void)saveImagePressed:(UIButton *)sender{
    
    if ([imageMode  isEqual: @"WithBackground"]) {
        drawnImage = [self.jotViewController drawOnImage:imageBackground];
        if (pagesArray == NULL) {
            pagesArray = [[NSMutableArray alloc] init];

        }
        [pagesArray addObject:drawnImage];
        [self.jotViewController clearAll];
        [previewImage removeFromSuperview];
        imageBackground = NULL;


    }
    else{
        drawnImage = [self.jotViewController renderImageWithScale:2.f
                                                          onColor:self.view.backgroundColor];

        if (pagesArray == NULL) {
            pagesArray = [[NSMutableArray alloc] init];
            
        }
        [pagesArray addObject:drawnImage];
        [self.jotViewController clearAll];
        [previewImage removeFromSuperview];
        imageBackground = NULL;
    }
    
    
    
    
//
//    [self.jotViewController clearAll];
//    
//    
//    ALAssetsLibrary *library = [ALAssetsLibrary new];
//    [library writeImageToSavedPhotosAlbum:[drawnImage CGImage]
//                              orientation:(ALAssetOrientation)[drawnImage imageOrientation]
//                          completionBlock:^(NSURL *assetURL, NSError *error){
//                              if (error) {
//                                  NSLog(@"Error saving photo: %@", error.localizedDescription);
//                              } else {
//                                  [previewImage removeFromSuperview];
//                                  imageBackground = NULL;
//                                  NSLog(@"Saved photo to saved photos album.");
//                              }
//                          }];

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
    pagesArray = NULL;
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
