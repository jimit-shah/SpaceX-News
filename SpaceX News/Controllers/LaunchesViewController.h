//
//  ViewController.h
//  SpaceX News
//
//  Created by Jimit Shah on 3/22/18.
//  Copyright © 2018 Jimit Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterVCDelegate <NSObject>
- (void)receiveFilters:(NSString *)startDt : (NSString *)endDt :(NSString *)year;
@end


@interface LaunchesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FilterVCDelegate>

@end

