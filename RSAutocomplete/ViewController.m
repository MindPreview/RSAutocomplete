//
//  ViewController.m
//  RSAutocomplete
//
//  Created by kkr on 12/29/14.
//  Copyright (c) 2014 allting. All rights reserved.
//

#import "ViewController.h"

static NSString	* const kUNIXWordsFilePath = @"/usr/share/dict/words";

@interface ViewController()<NSTextFieldDelegate>
@property (nonatomic) IBOutlet NSTextField* textField;
@property (nonatomic, assign, getter=isCompleting) BOOL completing;
@property (nonatomic) NSArray* usernames;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.textField.delegate = self;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (void) controlTextDidChange: (NSNotification *)note {
    NSTextView * fieldEditor = [[note userInfo] objectForKey:@"NSFieldEditor"];
    
    if (!self.isCompleting) {
        self.completing = YES;
        [fieldEditor complete:nil];
        self.completing = NO;
    }
}

- (NSArray *)control:(NSControl *)control textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index
{
    *index = -1;

    NSString* toMatch = [textView string];
    NSArray* usernames = self.usernames;
    if(0 == [toMatch length])
        return usernames;
    
    NSMutableArray *matchedNames = [NSMutableArray array];
    for(NSString *username in usernames) {
        if([username hasPrefix:toMatch])
            [matchedNames addObject:username];
    }
    
    if([matchedNames count]){
        if([toMatch isEqualToString:matchedNames[0]])
            *index = 0;
    }
    
    return matchedNames;
}

-(NSArray*)usernames{
    if(_usernames)
        return _usernames;
    
    NSError	* theError = nil;
    NSString * theString = [NSString stringWithContentsOfFile:kUNIXWordsFilePath encoding:NSUTF8StringEncoding error:&theError];
    _usernames = [theString componentsSeparatedByString:@"\n"];
    return _usernames;
}


@end
