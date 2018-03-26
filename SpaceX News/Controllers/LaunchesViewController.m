//
//  ViewController.m
//  SpaceX News
//
//  Created by Jimit Shah on 3/22/18.
//  Copyright © 2018 Jimit Shah. All rights reserved.
//

#import "LaunchesViewController.h"
#import "Launch.h"
#import "LaunchInfoCell.h"
#import "HTTPService.h"
#import "FilterViewController.h"

@interface LaunchesViewController () {
  NSDateFormatter *formatter;
  NSString *fromDate;
  NSString *toDate;
  NSString *yearString;
}

# pragma mark Properties

@property (strong, nonatomic) NSMutableArray *upcomingLaunchList;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

# pragma mark Outlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation LaunchesViewController

# pragma mark Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //[self createSearchBar];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.allowsSelection = NO;
  self.upcomingLaunchList = [[NSMutableArray alloc]init];
  
  formatter = [[NSDateFormatter alloc]init];
  [formatter setDateFormat:@"yyyy-MM-dd"];
  
  fromDate = [[NSString alloc]init];
  toDate = [[NSString alloc]init];
  yearString = [[NSString alloc]init];
  
  [self getData:@"UpcomingLaunches"];
  [self configureUI];
  
}


# pragma mark Get Data

- (void) getData:(NSString *)methodName {
  // start spinner
  [self startSpinner:self :_spinner];
  
  // GET data
  [[HTTPService instance]getLaunchData:fromDate :toDate :yearString :methodName :^(NSArray * _Nullable dataArray, NSString * _Nullable errMessage) {
    
    if (dataArray) {
      NSLog(@"Dictionary: %@", dataArray.debugDescription);
      
      NSMutableArray *arr = [[NSMutableArray alloc]init];
      
      for (NSDictionary *dict in dataArray) {
        
        Launch *launch= [[Launch alloc]init];
        
        NSString *localDateString = [[dict objectForKey:@"launch_date_local"] substringToIndex:10];
        NSDate *date = [formatter dateFromString: localDateString];
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"MM-dd-yyyy"];
        launch.launchDate = [df stringFromDate:date];
        
        // rocket details
        NSDictionary *rocket = [dict objectForKey:@"rocket"];
        launch.rocketName = [NSString stringWithFormat:@"%@%s%@", [rocket objectForKey:@"rocket_name"], " ", [rocket objectForKey:@"rocket_type"]];
        
        NSDictionary *firstStage = [rocket objectForKey:@"first_stage"];
        NSArray *coresArray = [firstStage objectForKey:@"cores"];
        if (coresArray) {
          NSDictionary *core1 = [coresArray objectAtIndex:0];
          launch.coreDetails = [NSString stringWithFormat:@"%@%s%@", [core1 objectForKey:@"core_serial"], "-", [core1 objectForKey:@"flight"]];
          launch.reuse = [core1 objectForKey:@"reused"];
        }
        
        NSDictionary *secondStage = [rocket objectForKey:@"second_stage"];
        NSArray *payloadsArray = [secondStage objectForKey:@"payloads"];
        if(payloadsArray) {
          NSDictionary *payload1 = [payloadsArray objectAtIndex:0];
          launch.payloadName = [payload1 objectForKey:@"payload_id"];
          NSArray *customers = [payload1 objectForKey:@"customers"];
          if(customers) {
            launch.customerName = [customers componentsJoinedByString:@","];
          }
          launch.payloadDetails = [NSString stringWithFormat:@"%@%s%@", [payload1 objectForKey:@"payload_type"], ", Orbit: ", [payload1 objectForKey:@"orbit"]];
        }
        // launch site
        NSDictionary *launchSite = [dict objectForKey:@"launch_site"];
        launch.siteName = [launchSite objectForKey:@"site_name"];
        
        [arr addObject:launch];
      }
      
      self.upcomingLaunchList = arr;
      [self updateTableData];
      
    } else if (errMessage){
      NSLog(@"Error: %@", errMessage);
    }
  }];
  
}

# pragma mark Update table data

- (void) updateTableData {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
    [self stopSpinner:self :_spinner];
  });
}

# pragma mark Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:@"segueFilter"])
  {
    FilterViewController *fvc = [segue destinationViewController];
    [fvc setDelegate:self];
  }
}

# pragma mark - Tableview Delegates

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  
  NSString *cellIdentifier = @"ItemCell";
  
  LaunchInfoCell * cell = (LaunchInfoCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if (!cell) {
    cell = [[LaunchInfoCell alloc]init];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  Launch *launch = [self.upcomingLaunchList objectAtIndex:indexPath.row];
  LaunchInfoCell *launchCell = (LaunchInfoCell *)cell;
  [launchCell updateUI:launch];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.upcomingLaunchList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (void)receiveFilters:(NSString *)startDt :(NSString *)endDt :(NSString *)year {
  fromDate = startDt;
  toDate = endDt;
  yearString = year;
  
  if ([startDt isEqualToString:@""] && [endDt isEqualToString:@""] && [year isEqualToString:@""]) {
    [self getData:@"UpcomingLaunches"];
    [self.navigationItem setTitle:@"Upcoming Launches"];
    
  } else {
    [self getData:@"FilteredAllLaunches"];
    [self.navigationItem setTitle:@"Filtered Launches"];
  }
}

# pragma makr configureUI

- (void)configureUI {
  self.spinner = [[UIActivityIndicatorView alloc]init];
  [[self navigationItem] setPrompt:@"SpaceX NEWS"];
  [self.tableView setBounces:YES];
}



#pragma mark Start/Show spinner

-(void) startSpinner:(UIViewController *)controller :(UIActivityIndicatorView*)activityIndicator {
  [activityIndicator setCenter:(controller.view.center)];
  [activityIndicator setHidesWhenStopped:true];
  [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
  
  [controller.view addSubview:activityIndicator];
  
  [activityIndicator startAnimating];
}

#pragma mark Stop/Hide spinner

-(void) stopSpinner:(UIViewController *)controller :(UIActivityIndicatorView*)activityIndicator {
  if (activityIndicator.isAnimating) {
    
    [activityIndicator stopAnimating];
  }
}

@end
