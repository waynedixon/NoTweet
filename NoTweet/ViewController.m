//
//  ViewController.m
//  NoTweet
//
//  Created by Wayne Dixon on 6/11/16.
//  Copyright © 2016 Wayne Dixon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    IBOutlet UITextView *tweetText;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *characterCount;
    
    long userNameCharacterCount;
}

@end

@implementation ViewController
@synthesize tweetText;
@synthesize titleLabel, characterCount;
@synthesize userNameCharacterCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Set character count and text to zero and nothing, respectively
    tweetText.text = @"";
    characterCount.text = @"0";
    
    [self.tweetText setDelegate:self];
    self.tweetText.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    [self registerNotifications];
    

}

- (void)registerNotifications
{
    //Register Notifications for character presses
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector (textViewText:)
                               name:UITextViewTextDidChangeNotification
                             object:tweetText];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)keyboardDidShow: (NSNotification *) notif{
    UIEdgeInsets insets = self.tweetText.contentInset;
    insets.bottom += [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.tweetText.contentInset = insets;
    
    insets = self.tweetText.scrollIndicatorInsets;
    insets.bottom += [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.tweetText.scrollIndicatorInsets = insets;
    
}

- (void)keyboardDidHide: (NSNotification *) notif{
    UIEdgeInsets insets = self.tweetText.contentInset;
    insets.bottom -= [notif.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    self.tweetText.contentInset = insets;
    
    insets = self.tweetText.scrollIndicatorInsets;
    insets.bottom -= [notif.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    self.tweetText.scrollIndicatorInsets = insets;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) textViewText:(id)notification {

    long charCount = [self getCharacterCount:nil];
    NSString *charCountString = [NSString stringWithFormat:@"%ld", charCount];
    characterCount.text = charCountString;
}

-(int)getCharacterCount:(id)sender
{
    int charCount = 0;
    int charCountUsernames = 0;
    int charCountWords = 0;
    int charCountLinks = 0;
    
    /* Replace new lines with asterick so they will be counted in the total count */
    NSString *newText = [tweetText.text stringByReplacingOccurrencesOfString:@"\n" withString:@"*"];
    
    /*
     Explode entire text view into an array, using space as the delimiter.
     Loop through array and Search for any strings that contain @
      If they contain an @, add to charCountUSernames, these will not count towards the overall total
      If they do not contain an @ symbol, get length, and add one character to account for the space removed during explosion of array.
    */
    
    NSArray *listOfWords = [newText componentsSeparatedByString:@" "];
    for (NSString *word in listOfWords)
    {
        
        if( ([word rangeOfString:@"@"].location != NSNotFound) && ([[word lowercaseString] rangeOfString:@"http"].location == NSNotFound) )
        {
            charCountUsernames += [word length] + 1;
        }
        else if(([word rangeOfString:@"@"].location == NSNotFound) && ([[word lowercaseString] rangeOfString:@"http"].location != NSNotFound) )
        {
            charCountLinks += 21;
        }
        else
        {
            charCountWords += [word length]; // +1
            //NSLog(@"word with @: %@", word);
        }
        //NSLog(@"word: %@", word);
    }
    
    /**/
    charCount = charCountWords + charCountLinks;
    /*
    NSLog(@"original Count: %d", originalCount);
    NSLog(@"charCountUsernames: %d", charCountUsernames);
    NSLog(@"charCountWords: %d", charCountWords);
     */
    
    if(charCount < 0)
    {
        charCount = 0;
    }
    return charCount;
}

- (BOOL)isUsername:(id)sender userNameString:(NSString *)userNameString
{
    BOOL result;
    
    if ([userNameString rangeOfString:@"@"].location == NSNotFound) {
        result = false;
    } else {
        result = true;
    }
    
    return result;
}

@end
