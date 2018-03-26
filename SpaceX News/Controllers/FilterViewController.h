//
//  FilterViewController.h
//  SpaceX News
//
//  Created by Jimit Shah on 3/23/18.
//  Copyright © 2018 Jimit Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaunchesViewController.h"

@class LaunchesViewController;

@interface FilterViewController : UIViewController
@property (weak, nonatomic) id<FilterVCDelegate> delegate;
@end


