//
//  Launch.h
//  SpaceX News
//
//  Created by Jimit Shah on 3/22/18.
//  Copyright © 2018 Jimit Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Launch : NSObject {
  
}

@property(nonatomic, strong) NSString *payloadName;
@property(nonatomic, strong) NSString *customerName;
@property(nonatomic, strong) NSString *rocketName;
@property(nonatomic, strong) NSString *launchYear;
@property(nonatomic, strong) NSString *launchDate;
@property(nonatomic, strong) NSString *coreDetails;
@property(nonatomic, strong) NSString *payloadDetails;
@property(nonatomic, strong) NSString *siteName;
@property(nonatomic, strong) NSString *reuse;
@end
