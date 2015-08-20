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
    dispatch_queue_t background_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(background_queue, ^{
        while (YES) {
            SIMStatus currentSimStatus = [self currentSimStatus];
            if (self.cachedSIMStatus != currentSimStatus) {
                if (self.simStatusChangedCallback) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        self.simStatusChangedCallback(currentSimStatus);
                    });
                    self.cachedSIMStatus = currentSimStatus;
                }
            }
            
            sleep(1);
        }
    });
}

@end
