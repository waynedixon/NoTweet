//
//  ViewController.h
//  NoTweet
//
//  Created by Wayne Dixon on 6/11/16.
//  Copyright © 2016 Wayne Dixon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, retain) UITextView *tweetText;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *characterCount;

@property (nonatomic) long userNameCharacterCount;
@end

