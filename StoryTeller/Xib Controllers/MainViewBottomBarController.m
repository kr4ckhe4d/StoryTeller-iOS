//
//  MainViewBottomBarController.m
//  StoryTeller
//
//  Created by Nipuna H Herath on 5/1/16.
//  Copyright © 2016 Nipuna H Herath. All rights reserved.
//

#import "MainViewBottomBarController.h"

@interface MainViewBottomBarController(){
    CGSize _intrinsicContentSize;
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
@end
