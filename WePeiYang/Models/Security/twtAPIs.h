//
//  twtAPIs.h
//  WePeiYang
//
//  Created by 秦昱博 on 15/1/31.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface twtAPIs : NSObject

+ (NSString *)newsList;
+ (NSString *)newsDetail;
+ (NSString *)studySearch;
+ (NSString *)GPAInquire;
+ (NSString *)GPAAutoEvaluate;
+ (NSString *)login;
+ (NSString *)bindLib;
+ (NSString *)bindTju;
+ (NSString *)unbindLib;
+ (NSString *)unbindTju;
+ (NSString *)logout;

@end