//
//  ChangePickupLocationViewController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/26/13.
//
//

#import <UIKit/UIKit.h>

@interface ChangePickupLocationViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) IBOutlet UIPickerView *locationPicker;
@property (nonatomic,strong) IBOutlet UIButton *saveLocation;

@end
