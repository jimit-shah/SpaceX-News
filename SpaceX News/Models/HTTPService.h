//
//  HTTPService.h
//  SpaceX News
//
//  Created by Jimit Shah on 3/22/18.
//  Copyright © 2018 Jimit Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^onComplete)(NSArray * _Nullable dataArray, NSString * _Nullable errMessage);

@interface HTTPService : NSObject

+ (id _Nullable) instance;
//- (void) getLaunchData:(nullable onComplete)completionHandler;
- (void) getLaunchData:(NSString*_Nullable)startDate :(NSString *_Nullable)endDate :(NSString*_Nullable)year :(NSString*_Nonnull)methodName :(nullable onComplete)completionHandler;
- (NSURL *_Nonnull)URLByAppendingQueryParameters:(NSString *_Nonnull)baseURL withQueryParameters:(NSDictionary *_Nullable)queryParameters;
@end


