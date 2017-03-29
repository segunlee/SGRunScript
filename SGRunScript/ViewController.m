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
@property (nonatomic, strong) NSDictionary *plist;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPlist];
}

- (void)loadPlist {
    NSData *encryptData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PropertyList" ofType:@"plist"]];
    NSString *encryptKey = @"HELLOWORLD";
    NSError *error;
    NSData *plistData = [RNDecryptor decryptData:encryptData withPassword:encryptKey error:&error];
    if (plistData) {
        NSPropertyListFormat propertyListFormat;
        NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:&propertyListFormat error:&error];
        if(!plist){
            NSLog(@"%@", error.localizedDescription);
        }
        _plist = plist;
        NSLog(@"%@", _plist);
    } else {
        NSLog(@"plist load error");
    }
}

@end
