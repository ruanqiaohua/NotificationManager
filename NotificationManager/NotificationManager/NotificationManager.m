//
//  NotificationManager.m
//  NotificationManager
//
//  Created by 阮巧华 on 2017/5/11.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import "NotificationManager.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>

#define IS_OS_10_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

@interface NotificationManager ()<UNUserNotificationCenterDelegate>

@property (nonatomic, copy) void (^handler)();

@end

@implementation NotificationManager

+ (instancetype)manager {
    static NotificationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NotificationManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)requestAuthorization {
    
    if (IS_OS_10_OR_LATER) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (granted) {
                                      [[UIApplication sharedApplication] registerForRemoteNotifications];
                                  }
                              }];
        center.delegate = self;
    } else {
        [self requestAuthorization_1];
    }
}

static NSString *const requestIdentifier = @"requestIdentifier";

- (void)addUserInfo:(NSDictionary *)userInfo {
    
    if (IS_OS_10_OR_LATER) {
        // 1. 创建通知内容
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.userInfo = userInfo;
        // 2. 创建发送触发
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
        // 4. 创建一个发送请求
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:trigger];
        
        // 将请求添加到发送中心
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error == nil) {
                NSLog(@"Time Interval Notification scheduled: \(requestIdentifier)");
            }
        }];
    } else {
        [self addUserInfo_1:userInfo];
    }
}

- (void)requestAuthorization_1 {
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                            settingsForTypes:(UIUserNotificationTypeBadge |
                                                              UIUserNotificationTypeSound |
                                                              UIUserNotificationTypeAlert)
                                            categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)addUserInfo_1:(NSDictionary *)userInfo {
    
    UILocalNotification *note = [[UILocalNotification alloc] init];
    note.userInfo = userInfo;
    [[UIApplication sharedApplication] presentLocalNotificationNow:note];
}

/**
 在前台收到通知
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(nonnull void (^)(UNNotificationPresentationOptions))completionHandler {
    [self dealWithUserInfo:notification.request.content.userInfo identifier:nil];
}

/**
 用户操作反馈
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(nonnull void (^)())completionHandler {
   
    [self dealWithUserInfo:response.notification.request.content.userInfo identifier:response.actionIdentifier];
    completionHandler();
}

- (void)dealWithUserInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier {
    
    if (self.handler) {
        self.handler(userInfo);
    }
}

- (void)userInfoHandler:(void(^)(NSDictionary *userInfo))handler {
    
    if (handler) {
        self.handler = handler;
    }
}

@end
