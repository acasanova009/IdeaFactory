//
//  InfoController.m
//  Table
//
//  Created by Renato Casanova on 5/31/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import "InfoController.h"
#import "BWFileManagementAdditions.h"
#import "URLConst.h"
#import "AlertStrings.h"

@interface InfoController ()

@end

@implementation InfoController

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)rateAction:(id)sender {
    
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id826660420";
    NSURL * url = [NSURL URLWithString:iOS7AppStoreURLFormat];
    
    [[UIApplication sharedApplication] openURL:url]; 

}


- (IBAction)sendAction:(id)sender {
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    NSString *model = [[UIDevice currentDevice] model];
    NSString *version = @"1.0";
    NSString *build = @"100";
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setToRecipients:[NSArray arrayWithObjects: @"renato.casanova@me.com",nil]];
    [mailComposer setSubject:[NSString stringWithFormat: @"IdeaFactory V%@ (build %@).",version,build]];
    NSString *supportText = [NSString stringWithFormat:@"Device: %@\niOS Version:%@\n\n",model,iOSVersion];
    supportText = [supportText stringByAppendingString: NSLocalizedString(@"Hello Alfonso, I wanted to tell you this: ", @"Some body text for when the user is going to write me a review personally")];
    [mailComposer setMessageBody:supportText isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}
@end
