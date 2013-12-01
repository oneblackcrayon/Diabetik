//
//  UAKeyboardBackingViewButton.m
//  Diabetik
//
//  Created by Nial Giacomelli on 18/03/2013.
//  Copyright 2013 Nial Giacomelli
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "UAKeyboardBackingViewButton.h"

#define kLabelSpacing 13.0f

@implementation UAKeyboardBackingViewButton
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize fullsizeImageView = _fullsizeImageView;

#pragma mark - Setup
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.font = [UAFont standardDemiBoldFontWithSize:13.0f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.minimumScaleFactor = 0.5f;
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
        _activityIndicatorView.hidesWhenStopped = YES;
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_activityIndicatorView];
        
        _fullsizeImageView = [[UIImageView alloc] initWithFrame:frame];
        _fullsizeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _fullsizeImageView.clipsToBounds = YES;
        [self addSubview:_fullsizeImageView];
        
        self.imageView.contentMode = UIViewContentModeCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

#pragma mark - Logic
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _fullsizeImageView.frame = self.bounds;
    
    self.imageView.frame = CGRectMake(floorf(self.frame.size.width/2-self.imageView.image.size.width/2), floorf(self.frame.size.height/2 - (self.imageView.image.size.height)), self.imageView.image.size.width, self.imageView.image.size.height);
    self.titleLabel.frame = CGRectMake(0.0f, floorf(self.frame.size.height/2 + kLabelSpacing), self.frame.size.width, 16.0f);
}
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if(highlighted)
    {
        self.backgroundColor = [UIColor colorWithRed:226.0f/255.0f green:236.0f/255.0f blue:233.0f/255.0f alpha:1.0f];
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
    }
}
- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if(enabled)
    {
        self.titleLabel.alpha = 1.0f;
        self.imageView.alpha = 1.0f;
    }
    else
    {
        self.imageView.alpha = 0.25f;
        self.titleLabel.alpha = 0.5f;
    }
}

@end
