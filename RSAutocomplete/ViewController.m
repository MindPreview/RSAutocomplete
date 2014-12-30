//
//  ViewController.m
//  RSAutocomplete
//
//  Created by kkr on 12/29/14.
//  Copyright (c) 2014 allting. All rights reserved.
//

#import "ViewController.h"
#import "RSAutocomplete.h"

@interface ViewController()<NSTextFieldDelegate>
@property (nonatomic) RSAutocomplete* autocompelte;
@property (nonatomic) IBOutlet NSTextField* textField;
@property (nonatomic, assign, getter=isCompleting) BOOL completing;
@property (nonatomic) NSArray* emails;
@property (nonatomic) NSString* lastTypedString;
@property (nonatomic) NSString* autoCompleteString;
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
    self.autoCompleteString = [[fieldEditor string] copy];
    
    if (!self.isCompleting) {
        self.completing = YES;
        self.lastTypedString = self.autoCompleteString;
        [fieldEditor complete:nil];
        self.completing = NO;
    }
    return;
    
    BOOL textDidNotChange = [self.lastTypedString isEqualToString:self.autoCompleteString];
    
    if( textDidNotChange ){
        NSLog(@"text did not change:%@", self.lastTypedString);
        return;
    }
    else {
        NSLog(@"text did change:%@ to %@", self.lastTypedString, [fieldEditor string]);
        self.lastTypedString = [[fieldEditor string] copy];
        [fieldEditor complete:nil];
    }
}
/*
- (NSArray *) completionsForPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index {
    // this would be defined somewhere else, but just for example..
    NSArray *usernames = [NSArray arrayWithObjects:@"@andreas", @"@clara", @"@jeena", @"@peter", nil];
    
    NSMutableArray *matchedNames = [NSMutableArray array];
    NSString *toMatch = [[self.textField stringValue] substringWithRange:charRange];
    for(NSString *username in usernames) {
        if([username hasPrefix:toMatch])
            [matchedNames addObject:username];
    }
    
    return matchedNames; // that's it.
}
*/

- (NSArray *)control:(NSControl *)control textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index
{
    NSLog(@"completions-current:%@, words:%@, range:%@, index:%ld", [textView string], words, NSStringFromRange(charRange), *index);
    
    *index = -1;
    
//    NSArray *usernames = [NSArray arrayWithObjects:@"andreas", @"clara", @"jeena", @"peter", nil];
    NSArray* usernames = self.emails;
    
    NSMutableArray *matchedNames = [NSMutableArray array];
//    NSString *toMatch = [[textView string] substringWithRange:charRange];
    NSString* toMatch = self.lastTypedString;
    for(NSString *username in usernames) {
        if([username hasPrefix:toMatch])
            [matchedNames addObject:username];
    }
    
    if([matchedNames count]){
        if([[textView string] isEqualToString:matchedNames[0]])
            *index = 0;
    }else{
        return words;
    }
    
    return matchedNames; // that's it.
}

static NSString		* const kUNIXWordsFilePath = @"/usr/share/dict/words";

-(NSArray*)emails{
    if(_emails)
        return _emails;
    
    NSError					* theError = nil;
    NSString				* theString = [NSString stringWithContentsOfFile:kUNIXWordsFilePath encoding:NSUTF8StringEncoding error:&theError];
    _emails = [theString componentsSeparatedByString:@"\n"];
    return _emails;
}


@end
