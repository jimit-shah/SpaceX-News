//
//  LaunchInfoCell.h
//  SpaceX News
//
//  Created by Jimit Shah on 3/22/18.
//  Copyright © 2018 Jimit Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Launch.h"

@interface LaunchInfoCell : UITableViewCell
-(void)updateUI:(nonnull Launch*) Launch;
@end
