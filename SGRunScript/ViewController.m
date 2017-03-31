//
//  ViewController.m
//  SGRunScript
//
//  Created by SegunLee on 2017. 3. 28..
//  Copyright © 2017년 SegunLee. All rights reserved.
//

#import "ViewController.h"
#import "RNDecryptor.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tv;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPlist];
}

- (void)loadPlist {
    
    NSString *encryptKey = @"HELLOWORLD";
    NSArray *plists = @[@"PropertyList", @"A", @"B", @"C"];
    
    for (NSString *name in plists) {
        NSData *encryptData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"plist"]];
        NSError *error;
        NSData *plistData = [RNDecryptor decryptData:encryptData withPassword:encryptKey error:&error];
        if (plistData) {
            NSPropertyListFormat propertyListFormat;
            NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:&propertyListFormat error:&error];
            if(!plist){
                _tv.text = (_tv.text.length == 0) ? [NSString stringWithFormat:@"%@\n\n", error.description] : [NSString stringWithFormat:@"%@\n%@\n\n",_tv.text, error.description];
                [_tv scrollRectToVisible:CGRectMake(0, _tv.contentSize.height, _tv.frame.size.width, _tv.frame.size.height) animated:YES];
            } else {
                NSString *txt = [NSString stringWithFormat:@"File: %@\n%@", name, plist];
                _tv.text = (_tv.text.length == 0) ? [NSString stringWithFormat:@"%@\n\n", txt] : [NSString stringWithFormat:@"%@\n%@\n\n",_tv.text, txt];
                [_tv scrollRectToVisible:CGRectMake(0, _tv.contentSize.height, _tv.frame.size.width, _tv.frame.size.height) animated:YES];
            }
        } else {
            NSString *txt = error.description;
            _tv.text = (_tv.text.length == 0) ? [NSString stringWithFormat:@"%@\n\n", txt] : [NSString stringWithFormat:@"%@\n%@\n\n",_tv.text, txt];
            [_tv scrollRectToVisible:CGRectMake(0, _tv.contentSize.height, _tv.frame.size.width, _tv.frame.size.height) animated:YES];
        }
    }
}

@end
