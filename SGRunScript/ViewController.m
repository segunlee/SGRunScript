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
    
    NSArray<NSURL *> *plistFilePaths = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"plist" subdirectory:nil];
    NSArray *ignorePlists = @[@"Info"];
    NSMutableArray *plists = [NSMutableArray array];
    
    for (NSURL *url in plistFilePaths) {
        NSString *plistName = [[[[url path] lastPathComponent] componentsSeparatedByString:@"."] firstObject];
        if (![ignorePlists containsObject:plistName]) {
            [plists addObject:plistName];
        }
    }
    
    
    NSString *encryptKey = @"HELLOWORLD";
    NSPropertyListFormat propertyListFormat;
    
    for (NSString *name in plists) {
        NSLog(@"%@", [self loadPlistWithName:name]);
        
        NSData *encryptData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"plist"]];
        NSError *checkError;
        NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:encryptData options:NSPropertyListImmutable format:&propertyListFormat error:&checkError];
        
        if (plist == nil || checkError) {
            NSString *txt = [NSString stringWithFormat:@"%@.plist is encrypted", name];
            _tv.text = (_tv.text.length == 0) ? [NSString stringWithFormat:@"%@\n", txt] : [NSString stringWithFormat:@"%@\n%@\n",_tv.text, txt];
            [_tv scrollRectToVisible:CGRectMake(0, _tv.contentSize.height, _tv.frame.size.width, _tv.frame.size.height) animated:YES];
        }
        
        NSError *error;
        NSData *plistData = [RNDecryptor decryptData:encryptData withPassword:encryptKey error:&error];
        if (plistData) {
            
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

- (nullable NSDictionary *)loadPlistWithName:(NSString *)name {
    NSString *encryptKey = @"HELLOWORLD";
    NSPropertyListFormat propertyListFormat;
    NSError *error;
    NSData *encryptData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"plist"]];
    NSData *plistData = [RNDecryptor decryptData:encryptData withPassword:encryptKey error:&error];

    if (plistData) {
        NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:&propertyListFormat error:&error];
        return plist;
    }
    
    if (error) {
        NSLog(@"load failed %@.plist by %@", name, error.description);
        NSLog(@"load again plist data");
        error = nil;
        NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:encryptData options:NSPropertyListImmutable format:&propertyListFormat error:&error];
        if (plist) {
            return plist;
        }
    }
    return nil;
}

@end
