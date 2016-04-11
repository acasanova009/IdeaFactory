//
//  InfoController.h
//  Table
//
//  Created by Renato Casanova on 5/31/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@protocol InfoProtocol <NSObject>
-(void)reloadAllKeys;
@end 
@interface InfoController : UIViewController <UIAlertViewDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic,assign) id <InfoProtocol> delegate;

- (IBAction)rateAction:(id)sender;
- (IBAction)sendAction:(id)sender;

@end
