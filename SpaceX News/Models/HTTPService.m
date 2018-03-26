//
//  HTTPService.m
//  SpaceX News
//
//  Created by Jimit Shah on 3/22/18.
//  Copyright © 2018 Jimit Shah. All rights reserved.
//

#import "HTTPService.h"

// example https://api.spacexdata.com/v2/launches/upcoming?start=2018-03-21&final=2018-12-31

#define URL_BASE "https://api.spacexdata.com/v2/launches/upcoming?"
#define URL_BASE_ALL "https://api.spacexdata.com/v2/launches/all?"
#define URL_START_DT ""
#define URL_END_DT ""
#define URL_YEAR ""

@implementation HTTPService

+ (id) instance {
  static HTTPService *sharedInstance = nil;
  
  @synchronized(self) {
    if (sharedInstance == nil) {
      sharedInstance = [[self alloc]init];
    }
  }
  return sharedInstance;
}

- (void) getLaunchData:(NSString*_Nullable)startDate :(NSString *_Nullable)endDate :(NSString*_Nullable)year :(NSString*_Nonnull)methodName :(nullable onComplete)completionHandler {
  
  NSURLSession *session = [NSURLSession sharedSession];
  
  NSDictionary *parameters = @{
                               @"start": startDate,
                               @"final": endDate,
                               @"launch_year": year,
                               };
  
  // call helper method to build url with parameters
  NSURL *url = [[NSURL alloc]init];
  if ([methodName isEqual: @"UpcomingLaunches"]) {
    url = [self URLByAppendingQueryParameters:@URL_BASE withQueryParameters:parameters];
  } else {
    url = [self URLByAppendingQueryParameters:@URL_BASE_ALL withQueryParameters:parameters];
  }
  
  NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
  request.HTTPMethod = @"GET";
  
  NSLog(@"Request %@",request.debugDescription);
  
  NSURLSessionDataTask *downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
    if (data != nil) {
      NSError *err;
      NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
      
      if (httpResp.statusCode >= 200 && httpResp.statusCode <= 299) {
        
        NSArray* json = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:kNilOptions
                         error:&err];
        
        if (err == nil) {
          completionHandler(json, nil);
        } else {
          completionHandler(nil, @"Data parsing error.");
        }
      } else {
        completionHandler(nil, @"Your request returned a status code other than 2xx!");
      }
    } else {
      NSLog(@"Network Error: %@", error.debugDescription);
      completionHandler(nil, @"Problem connecting to the server, please try again later.");
    }
  }];
  [downloadTask resume];
}


// MARK: - URLByAppendingQueryParameters withQueryParameters
- (NSURL *_Nonnull)URLByAppendingQueryParameters:(NSString *_Nonnull)baseURL withQueryParameters:(NSDictionary *)queryParameters
{
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",baseURL]];
  if (queryParameters == nil) {
    return url;
  } else if (queryParameters.count == 0) {
    return url;
  }
  
  NSArray *queryKeys = [queryParameters allKeys];
  NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
  NSMutableArray * newQueryItems = [NSMutableArray arrayWithCapacity:1];
  
  for (NSURLQueryItem * item in components.queryItems) {
    if (![queryKeys containsObject:item.name]) {
      [newQueryItems addObject:item];
    }
  }
  
  for (NSString *key in queryKeys) {
    NSURLQueryItem * newQueryItem = [[NSURLQueryItem alloc] initWithName:key value:queryParameters[key]];
    [newQueryItems addObject:newQueryItem];
  }
  
  [components setQueryItems:newQueryItems];
  
  return [components URL];
}


@end

