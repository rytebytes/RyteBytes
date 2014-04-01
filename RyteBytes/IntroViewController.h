//
//  IntroViewController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/12/14.
//
//

#import <UIKit/UIKit.h>

@interface IntroViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) IBOutlet UIPickerView *locationPicker;
@property (nonatomic,strong) IBOutlet UIButton *getStarted;
@end
