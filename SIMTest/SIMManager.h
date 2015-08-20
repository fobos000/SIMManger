//
//  SIMManager.h
//  SIMTest
//
//  Created by Ostap.Horbach on 8/19/15.
//  Copyright (c) 2015 Ostap.Horbach. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SIMStatusInserted,
    SIMStatusRemoved
} SIMStatus;

@interface SIMManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, readonly) BOOL isSimInserted;
@property (nonatomic, readonly) BOOL isSimAvailable;
@property (nonatomic, copy) void (^simStatusChangedCallback)(SIMStatus simStatus);

@end
