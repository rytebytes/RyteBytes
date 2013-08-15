//
//  RBFirstViewController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 2/4/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EatRyteViewController : UIViewController

@property (nonatomic,strong) IBOutlet UILabel *heading;
@property (nonatomic,strong) IBOutlet UIButton *pickMealBtn;
@property (nonatomic,strong) IBOutlet UIButton *buildMealBtn;
@property (nonatomic,strong) IBOutlet UIBarButtonItem *checkOutBtn;


@end
