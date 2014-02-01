//
//  UAKeyboardShortcutAccessoryView.m
//  Diabetik
//
//  Created by Nial Giacomelli on 31/01/2014.
//  Copyright (c) 2014 UglyApps. All rights reserved.
//

#import "UAKeyboardShortcutAccessoryView.h"

@interface UAKeyboardShortcutAccessoryView ()
@property (nonatomic, strong) UIView *buttonContainer;
@end

@implementation UAKeyboardShortcutAccessoryView

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, 320.0f, 44.0f);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.clipsToBounds = YES;
        self.showingAutocompleteBar = NO;
        
        self.buttonContainer = [[UIView alloc] initWithFrame:frame];
        self.buttonContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.buttonContainer];
        
        self.tagButton = [[UAKeyboardShortcutButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 35.0f)];
        [self.tagButton setImage:[UIImage imageNamed:@"Tag"] forState:UIControlStateNormal];
        [self.tagButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.photoButton = [[UAKeyboardShortcutButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 35.0f)];
        [self.photoButton setImage:[UIImage imageNamed:@"PhotoCamera"] forState:UIControlStateNormal];
        [self.photoButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.shareButton = [[UAKeyboardShortcutButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 35.0f)];
        [self.reminderButton setImage:[UIImage imageNamed:@"Link"] forState:UIControlStateNormal];
        [self.shareButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.reminderButton = [[UAKeyboardShortcutButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 35.0f)];
        [self.reminderButton setImage:[UIImage imageNamed:@"Task"] forState:UIControlStateNormal];
        [self.reminderButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.locationButton = [[UAKeyboardShortcutButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 35.0f)];
        [self.locationButton setImage:[UIImage imageNamed:@"Location"] forState:UIControlStateNormal];
        [self.locationButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.deleteButton = [[UAKeyboardShortcutButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 35.0f)];
        [self.deleteButton setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
    
        self.buttons = @[self.tagButton, self.photoButton, self.locationButton, self.reminderButton, self.shareButton, self.deleteButton];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);
    CGFloat buttonSpacing = 5.0f;
    CGFloat buttonWidths = 0;
    for(UIButton *button in self.buttons)
    {
        buttonWidths += button.bounds.size.width + buttonSpacing;
    }
    buttonWidths -= buttonSpacing;
    
    CGFloat x = centerX - buttonWidths/2.0f;
    for(UIButton *button in self.buttons)
    {
        button.frame = CGRectMake(x, centerY - button.bounds.size.height/2.0f, button.bounds.size.width, button.bounds.size.height);
        x += button.bounds.size.width + buttonSpacing;
    }
}

#pragma mark - Logic
- (void)didPressButton:(UAKeyboardShortcutButton *)button
{
    if(self.delegate)
    {
        [self.delegate keyboardShortcut:self didPressButton:button];
    }
}
- (void)showAutocompleteSuggestionsForInput:(NSString *)text
{
    if([self.autocompleteBar showSuggestionsForInput:text])
    {
        NSLog(@"Showing autocomplete");
        [self setShowingAutocompleteBar:YES];
    }
    else
    {
                NSLog(@"hiding autocomplete");
        [self setShowingAutocompleteBar:NO];
    }
}

#pragma mark - Accessors
- (void)setShowingAutocompleteBar:(BOOL)state
{
    if(state)
    {
        if(!self.showingAutocompleteBar)
        {
            UAAutocompleteBar *autocompleteBar = [self autocompleteBar];
            [UIView animateWithDuration:0.15f animations:^{
                self.buttonContainer.frame = CGRectMake(0.0f, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
            } completion:^(BOOL finished) {
                autocompleteBar.alpha = 0.0f;
                autocompleteBar.hidden = NO;
                [UIView animateWithDuration:0.1 animations:^{
                    autocompleteBar.alpha = 1.0f;
                }];
            }];
        }
    }
    else
    {
        if(self.showingAutocompleteBar)
        {
            UAAutocompleteBar *autocompleteBar = [self autocompleteBar];
            [UIView animateWithDuration:0.15f animations:^{
                autocompleteBar.alpha = 0.0f;
            } completion:^(BOOL finished) {
                autocompleteBar.hidden = YES;
                [UIView animateWithDuration:0.1 animations:^{
                    self.buttonContainer.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height);
                }];
            }];
        }
    }
    _showingAutocompleteBar = state;
}
- (void)setButtons:(NSArray *)newButtons
{
    _buttons = newButtons;
    for(UIButton *button in self.buttons)
    {
        if(![button superview])
        {
            [self.buttonContainer addSubview:button];
        }
    }
    
    [self setNeedsLayout];
}
- (UAAutocompleteBar *)autocompleteBar
{
    if(!_autocompleteBar)
    {
        _autocompleteBar = [[UAAutocompleteBar alloc] initWithFrame:self.bounds];
        _autocompleteBar.delegate = self;
        _autocompleteBar.hidden = YES;
        
        [self addSubview:_autocompleteBar];
    }
    
    return _autocompleteBar;
}

#pragma mark - UAAutocompleteBarDelegate methods
- (NSArray *)suggestionsForAutocompleteBar:(UAAutocompleteBar *)theAutocompleteBar
{
    if(self.delegate)
    {
        return [self.delegate suggestionsForAutocompleteBar:theAutocompleteBar];
    }
    
    return nil;
}
- (void)autocompleteBar:(UAAutocompleteBar *)autocompleteBar didSelectSuggestion:(NSString *)suggestion
{
    if(self.delegate) [self.delegate autocompleteBar:autocompleteBar didSelectSuggestion:suggestion];
}
- (void)addTagCaret
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(addTagCaret)])
    {
        [self.delegate addTagCaret];
    }
}

@end
