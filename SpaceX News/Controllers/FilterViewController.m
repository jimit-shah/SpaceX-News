//
//  FilterViewController.m
//  SpaceX News
//
//  Created by Jimit Shah on 3/23/18.
//  Copyright © 2018 Jimit Shah. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController() {
  NSDateFormatter *formatter;
}
@property (weak, nonatomic) IBOutlet UITextField *fromDateField;
@property (weak, nonatomic) IBOutlet UITextField *toDateField;
@property (weak, nonatomic) IBOutlet UITextField *yearField;

@property (strong, nonatomic) UIDatePicker *fromDatePicker;
@property (strong, nonatomic) UIDatePicker *toDatePicker;
@property (strong, nonatomic) UIDatePicker *yearPicker;


@end

@implementation FilterViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.fromDatePicker = [[UIDatePicker alloc]init];
  self.toDatePicker = [[UIDatePicker alloc]init];
  self.yearPicker = [[UIDatePicker alloc]init];
  
  [self createPicker:[self fromDateField]];
  [self createPicker:[self toDateField]];
  [self createPicker:[self yearField]];
  
  formatter = [[NSDateFormatter alloc]init];
  [formatter setDateFormat:@"yyyy-MM-dd"];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [_fromDateField setText:@""];
  [_toDateField setText:@""];
  [_yearField setText:@""];
}

- (IBAction)donePressed:(UIButton *)sender {
  
  [self.delegate receiveFilters:_fromDateField.text :_toDateField.text :_yearField.text];
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)cancelPressed:(UIButton *)sender {
  
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) createPicker:(UITextField *)dateField {
  // toolbar
  UIToolbar *toolbar = [[UIToolbar alloc]init];
  [toolbar sizeToFit];
  
  // done for toolbar
  UIBarButtonItem *done;
  
  if (dateField.tag == 1) {
    done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:@selector(fromDatePickerDonePressed)];
  } else if (dateField.tag == 2) {
    done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:@selector(toDatePickerDonePressed)];
  } else if (dateField.tag == 3) {
    done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:@selector(yearPickerDonePressed)];
  };
  
  NSMutableArray *arr = [NSMutableArray new];
  [arr addObject:done];
  [toolbar setItems:arr animated:false];
  
  [dateField setInputAccessoryView:toolbar];
  
  if (dateField.tag == 1) {
    [dateField setInputView:self.fromDatePicker];
    [self.fromDatePicker setDatePickerMode:UIDatePickerModeDate];
  } else if (dateField.tag == 2) {
    [dateField setInputView:self.toDatePicker];
    [self.toDatePicker setDatePickerMode:UIDatePickerModeDate];
  } else if (dateField.tag == 3) {
    [dateField setInputView:self.yearPicker];
    [self.yearPicker setDatePickerMode:UIDatePickerModeDate];
  };
  
}

-(void) fromDatePickerDonePressed {
  // formate date
  NSString *dateString = [formatter stringFromDate:[self.fromDatePicker date]];
  
  [self.fromDateField setText:dateString];
  [self.view endEditing:true];
}

-(void) toDatePickerDonePressed {
  // formate date
  NSString *dateString = [formatter stringFromDate:[self.toDatePicker date]];
  
  [self.toDateField setText:dateString];
  [self.view endEditing:true];
}

-(void) yearPickerDonePressed {
  // formate date
  [formatter setDateFormat:@"yyyy"];
  NSString *dateString = [formatter stringFromDate:[self.yearPicker date]];
  [self.yearField setText:dateString];
  [self.view endEditing:true];
}

-(void) datePickerDonePressed:(UIDatePicker *)datePicker :(UITextField *)dateField {
  // formate date
  NSString *dateString = [formatter stringFromDate:[datePicker date]];
  
  [dateField setText:dateString];
  [self.view endEditing:true];
}

@end
