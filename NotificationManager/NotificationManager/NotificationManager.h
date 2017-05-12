//
//  NotificationManager.h
//  NotificationManager
//
//  Created by 阮巧华 on 2017/5/11.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject

@property (nonatomic, copy) NSString *deviceToken;

+ (instancetype)manager;

- (void)requestAuthorization;

- (void)addUserInfo:(NSDictionary *)userInfo;

- (void)dealWithUserInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier;

- (void)userInfoHandler:(void(^)(NSDictionary *userInfo))handler;

@end
