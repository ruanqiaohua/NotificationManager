# NotificationManager
Objective-c 推送

```Objective-c

/** 初始化 */
+ (instancetype)manager;
/** 请求推送权限 */
- (void)requestAuthorization;
/** 本地推送 */
- (void)addUserInfo:(NSDictionary *)userInfo;
/** 处理用户点击（IOS8.0～IOS10.0） */
- (void)dealWithUserInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier;
/** 返回用户信息 */
- (void)userInfoHandler:(void(^)(NSDictionary *userInfo))handler;


```

极简版本

具体使用请看Demo

推荐使用Knuff测试推送

https://github.com/KnuffApp/Knuff
