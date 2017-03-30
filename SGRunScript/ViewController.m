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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPlist];
}

- (void)loadPlist {
    
    NSArray *plists = @[@"PropertyList", @"A", @"B", @"C"];
    for (NSString *name in plists) {
        NSData *encryptData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"plist"]];
        NSString *encryptKey = @"HELLOWORLD";
        NSError *error;
        NSData *plistData = [RNDecryptor decryptData:encryptData withPassword:encryptKey error:&error];
        if (plistData) {
            NSPropertyListFormat propertyListFormat;
            NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:&propertyListFormat error:&error];
            if(!plist){
                NSLog(@"%@", error.localizedDescription);
            } else {
                NSLog(@"File: %@\n%@", name, plist);
            }
            
        } else {
            NSLog(@"plist load error");
        }

    }
}

@end
