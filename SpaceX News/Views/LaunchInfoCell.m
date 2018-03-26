//
//  LaunchInfoCell.m
//  SpaceX News
//
//  Created by Jimit Shah on 3/22/18.
//  Copyright © 2018 Jimit Shah. All rights reserved.
//

#import "LaunchInfoCell.h"
#import "Launch.h"
@interface LaunchInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *payloadName;
@property (weak, nonatomic) IBOutlet UILabel *customer;
@property (weak, nonatomic) IBOutlet UILabel *siteName;

@property (weak, nonatomic) IBOutlet UILabel *rocketNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *coreDetails;
@property (weak, nonatomic) IBOutlet UILabel *payloadDetails;
@property (weak, nonatomic) IBOutlet UILabel *datetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reuseLabel;

@end

@implementation LaunchInfoCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  self.layer.cornerRadius = 3.0;
  self.layer.shadowColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:0.8].CGColor;
  self.layer.shadowOpacity = 0.8;
  self.layer.shadowRadius = 5.0;
  self.layer.shadowOffset = CGSizeMake(0.0,2.0);
  
  self.reuseLabel.layer.cornerRadius = self.reuseLabel.frame.size.height / 2;
  self.reuseLabel.layer.borderColor = [[UIColor whiteColor]CGColor];
  self.reuseLabel.layer.borderWidth = 1;
  [self.reuseLabel setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

-(void)updateUI:(nonnull Launch*)Launch {
  
  self.payloadName.text = Launch.payloadName;
  self.customer.text = Launch.customerName;
  self.rocketNameLabel.text = Launch.rocketName;
  self.siteName.text = Launch.siteName;
  self.coreDetails.text = Launch.coreDetails;
  self.payloadDetails.text = Launch.payloadDetails;
  self.datetimeLabel.text = Launch.launchDate;
  if ([Launch.reuse boolValue]) {
    [self.reuseLabel setHidden:NO];
  } else {
    [self.reuseLabel setHidden:YES];
  }
  
}


@end
