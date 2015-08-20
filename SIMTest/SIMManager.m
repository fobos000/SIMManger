//
//  SIMManager.m
//  SIMTest
//
//  Created by Ostap.Horbach on 8/19/15.
//  Copyright (c) 2015 Ostap.Horbach. All rights reserved.
//

#import "SIMManager.h"

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface SIMManager ()

@property (nonatomic) SIMStatus cachedSIMStatus;

@end

@implementation SIMManager

+ (instancetype)sharedManager
{
    static SIMManager *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SIMManager alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cachedSIMStatus = [self currentSimStatus];
        [self startObservingSIM];
    }
    return self;
}

- (BOOL)isSimInserted
{
    return [self currentSimStatus] == SIMStatusInserted;
}

- (BOOL)isSimAvailable
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
}

- (SIMStatus)currentSimStatus
{
    CTCarrier* carrier = [[CTTelephonyNetworkInfo alloc] init].subscriberCellularProvider;
    return (carrier.mobileCountryCode != nil) ? SIMStatusInserted : SIMStatusRemoved;
}

- (void)startObservingSIM
{
    NSDate *now = [[NSDate alloc] init];
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:now
                                              interval:1.0
                                                target:self
                                              selector:@selector(checkSIMStatus)
                                              userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)checkSIMStatus
{
    SIMStatus currentSimStatus = [self currentSimStatus];
    if (self.cachedSIMStatus != currentSimStatus) {
        if (self.simStatusChangedCallback) {
            self.simStatusChangedCallback(currentSimStatus);
            self.cachedSIMStatus = currentSimStatus;
        }
    }
}

@end
