/*******************************************************************************
 * Copyright 2011 Beintoo - author fmessina@beintoo.com
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/

#import "BeintooViewController.h"
#import "Beintoo.h"

@implementation BeintooViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    //* This is just for testing: simulate other locations where marketplace is enabled
    [Beintoo updateUserLocation];
    
    //* SampleBeintoo buttons customization
	[self buttonsCustomization];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self manageLocation];
}

- (IBAction)startBeintoo{
    
    /*
     *  Use 
     *  
     *  [Beintoo launchBeintoo]; 
     *  
     *  to directly launch the Dashboard
     */

    [Beintoo launchBeintoo];
    
    /*
     *
     *  If your app uses Virtual Currency, after setting your Virtual Currency name and your user 
     *  ID in your App Delegate, you have to save user's Virtual Currency balance
     *  so, we suggest to use the method
     *
     *  [Beintoo launchBeintooOnAppWithVirtualCurrencyBalance:user's_virtual_currency_balance];
     *
     *
     *  Or in alternative, first store user's Virtual Currency balance
     *
     *  [Beintoo setVirtualCurrencyBalance:user's_virtual_currency_balance];
     *
     *  and then
     *
     *  [Beintoo launchBeintoo];
     *
     */
}

- (IBAction)startMarketplace{
    
    /*
     *  Use 
     *
     *  [Beintoo launchMarketplace];
     *
     *  to directly launch Marketplace, overlapping the dashboars
     */
    
    [Beintoo launchMarketplace];
    
    /*
     *
     * If your app uses Virtual Currency, you have to save user's Virtual Currency balance
     * so, we suggest to use the method
     *
     * [Beintoo launchMarketplaceOnAppWithVirtualCurrencyBalance:user's_virtual_currency_balance];
     *
     *
     * Or in alternative, first store user's Virtual Currency balance
     *
     * [Beintoo setVirtualCurrencyBalance:user's_virtual_currency_balance];
     *
     * and then
     *
     * [Beintoo launchMarketplaceOnApp];
     *
     */
    
}

- (IBAction)playerLogin{
	[BeintooPlayer setPlayerDelegate:self];
    [BeintooPlayer login];
}

- (IBAction)submitScore{
	[BeintooPlayer setPlayerDelegate:self];
    [BeintooPlayer submitScore:1];
}

- (IBAction)submitScoreForContest{
	[BeintooPlayer setPlayerDelegate:nil];
	//[BeintooPlayer submitScore:1 forContest:@"default"]; // Here the contest name instead of "default"
    
    [BeintooPlayer submitScoreAndGetVgoodForScore:10 andContest:@"default" withThreshold:100 andVgoodMultiple:YES];
    
}

- (IBAction)getScoreForContest{
	[BeintooPlayer setPlayerDelegate:self];
	[BeintooPlayer getScore];
}

- (IBAction)setBalance{
	[BeintooPlayer setPlayerDelegate:self];
	[BeintooPlayer setBalance:0 forContest:@"default"];
}

- (IBAction)getVgood{
	/**
	 * VGOOD GET VIRTUAL GOOD : 
	 * This function must be called every time the developer wants to deliver a virtual good to the user. 
	 * Note that not always a virtual good will be generated from Beintoo. Wait for the generation response from 
	 * the delegate  */
    [BeintooVgood setVgoodDelegate:self];
	[BeintooVgood getSingleVirtualGood];
    
}

- (IBAction)submitAchievement{
	[BeintooAchievements setAchievementDelegate:self];
	// These are all possible ways to submit an achievement progress
	//[BeintooAchievements setAchievement:@"w234567" withScore:10];
	//[BeintooAchievements setAchievement:@"w234567" withPercentage:50];
	//[BeintooAchievements incrementAchievement:@"123456789" withScore:5];
    [BeintooAchievements unlockAchievement:@"w234567"];
    
}

- (IBAction)playerLogout{
	[Beintoo playerLogout];
    [self manageLocation];
}

- (IBAction)setMilan{
	// 45.467354,9.189377
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:45.467354 longitude:9.189377];
    [Beintoo _setUserLocation:loc];
    
    [self manageLocation];
}

- (IBAction)setNewYork{
	// 40.719681,-73.997726
	CLLocation *loc = [[CLLocation alloc] initWithLatitude:40.719681 longitude:-73.997726];
    [Beintoo _setUserLocation:loc];
    
    [self manageLocation];
}
- (IBAction)setLondon{
	// 51.4925,-0.105057
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:51.4925 longitude:-0.105057];
    
	//CLLocation *loc = [[CLLocation alloc] initWithLatitude:51.492500 longitude:-0.105057];
    [Beintoo _setUserLocation:loc];
    
    [self manageLocation];    
}

- (IBAction)setSanFrancisco{
	// 37.771258,-122.417564
	CLLocation *loc = [[CLLocation alloc] initWithLatitude:37.771258 longitude:-122.417564];
    [Beintoo _setUserLocation:loc];
    
    [self manageLocation];
}

- (IBAction)getMission{
    //Please, note that if app uses missions, one will be shown just one time every 24 hours, to avoid that it appears everytime a user open the app
    [BeintooMission getMission];
}

#pragma mark -
#pragma mark Delegates

/**
 * Use the delegates callback to perform custom actions on your app
 * Check the iOS Beintoo sdk documentation for more informations.
 */

// -------------- PLAYER LOGIN CALLBACKS
- (void)playerDidLoginWithResult:(NSDictionary *)result{
	NSLog(@"playerLogin result: %@", result);
    
    [self manageLocation];
}

- (void)playerDidFailLoginWithResult:(NSString *)error{
	NSLog(@"playerLogin error: %@",error);
    
}

// -------------- PLAYER LOGIN CALLBACKS
- (void)didCompleteBackgroundRegistration:(NSDictionary *)result{
    NSLog(@"Set User Callback -------> result %@", result);

}
- (void)didNotCompleteBackgroundRegistration{
    NSLog(@"Error in Set User Callback ------->");
    
}

// -------------- PLAYER SUBMITSORE CALLBACKS
- (void)playerDidSumbitScoreWithResult:(NSString *)result{
	NSLog(@"%@",result);
}
- (void)playerDidFailSubmitScoreWithError:(NSString *)error{
	NSLog(@"%@",error);
}

// -------------- PLAYER GETSCORE CALLBACKS
- (void)playerDidGetScoreWithResult:(NSDictionary *)result{
	NSLog(@"Beintoo: player getscore result: %@",result);
}

- (void)playerDidFailGetScoreWithError:(NSString *)error{
	NSLog(@"Beintoo: player getscore error: %@",error);
}

// -------------- PLAYER SETBALANCE CALLBACKS
- (void)playerDidSetBalanceWithResult:(NSString *)result{
	NSLog(@"Beintoo: player setBalance result: %@",result);
}
- (void)playerDidFailSetBalanceWithError:(NSString *)error{
	NSLog(@"Beintoo: player setBalance error: %@",error);
}

// -------------- ACHIEVEMENT SUBMIT CALLBACKS
- (void)didSubmitAchievementWithResult:(NSDictionary *)result{
	NSLog(@"Beintoo: achievement submitted with result: %@",result);
}
- (void)didFailToSubmitAchievementWithError:(NSString *)error{
	NSLog(@"Beintoo: achievement submit error: %@",error);
}

- (void)didGetAllUserAchievementsWithResult:(NSArray *)result{
    NSLog(@"Beintoo: achievement list: %@", result);
    
}

- (void)didGetAchievementStatus:(NSString *)_status andPercentage:(int)_percentage forAchievementId:(NSString *)_achievementId{

    NSLog(@"Achieve %@ || status %@ || precentage %i", _achievementId, _status, _percentage);

}

- (void)didBeintooGenerateAVirtualGood:(BVirtualGood *)theVgood{
	if ([theVgood isMultiple]) {
		NSLog(@"Multiple Vgood generated from user delegate: %@",[theVgood theGoodsList]);
	}
	else {
		NSLog(@"Single Vgood generated from user delegate: %@",[theVgood theGood]);
	}
}

- (void)didBeintooFailToGenerateAVirtualGoodWithError:(NSString *)error{
	NSLog(@"Main View Controller --- Vgood generation error from user delegate: %@",error);
}

- (void)beintooPrizeWillAppear{
    NSLog(@"Main View Controller --- Prize will Appear"); 
}

- (void)beintooPrizeDidAppear{
    NSLog(@"Main View Controller --- Prize did Appear");
}

- (void)beintooPrizeWillDisappear{
    NSLog(@"Main View Controller --- Prize will Disappear");
}

- (void)beintooPrizeDidDisappear{
    NSLog(@"Main View Controller --- Prize did Disappear");
}

- (void)beintooPrizeAlertWillAppear{
    NSLog(@"Main View Controller --- Prize alert will Appear");
}

- (void)beintooPrizeAlertDidDisappear{
    NSLog(@"Main View Controller --- Prize alert did Disappear");
}

- (void)beintooPrizeAlertWillDisappear{
    NSLog(@"Main View Controller --- Prize alert will Disappear");
}

- (void)beintooPrizeAlertDidAppear{
    NSLog(@"Main View Controller --- Prize alert did Appear");
}

- (void)userDidTapOnClosePrize{
    NSLog(@"Main View Controller --- Tapped on close Prize");
}

- (void)userDidTapOnThePrize{
    NSLog(@"Main View Controller --- Tapped on Prize");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [Beintoo changeBeintooOrientation:interfaceOrientation];
    return YES;
}

- (void)buttonsCustomization{
    
    [playerLogin setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[playerLogin setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[playerLogin setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [playerLogin setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [playerLogin setTextSize:[NSNumber numberWithInt:14]];
    
    [logout setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[logout setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[logout setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [logout setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [logout setTextSize:[NSNumber numberWithInt:14]];
    
    [getVgood setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[getVgood setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[getVgood setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [getVgood setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [getVgood setTextSize:[NSNumber numberWithInt:14]];
    
    [submitScore setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[submitScore setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[submitScore setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [submitScore setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [submitScore setTextSize:[NSNumber numberWithInt:14]];
    
    [submitScoreForContest setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[submitScoreForContest setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[submitScoreForContest setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [submitScoreForContest setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [submitScoreForContest setTextSize:[NSNumber numberWithInt:14]];
    
    [setBalance setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[setBalance setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[setBalance setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [setBalance setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [setBalance setTextSize:[NSNumber numberWithInt:14]];
    
    [getScoreForContest setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[getScoreForContest setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[getScoreForContest setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [getScoreForContest setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [getScoreForContest setTextSize:[NSNumber numberWithInt:14]];
    
    [achievements setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[achievements setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[achievements setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [achievements setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [achievements setTextSize:[NSNumber numberWithInt:14]];
    
    [london setHighColor:[UIColor colorWithRed:10.0/255 green:90.0/255 blue:229.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
	[london setMediumHighColor:[UIColor colorWithRed:8.0/255 green:72.0/255 blue:183.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
	[london setMediumLowColor:[UIColor colorWithRed:8.0/255 green:72.0/255 blue:183.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
    [london setLowColor:[UIColor colorWithRed:7.0/255 green:64.0/255 blue:163.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
    [london setTextSize:[NSNumber numberWithInt:14]];
    
    [milan setHighColor:[UIColor colorWithRed:10.0/255 green:90.0/255 blue:229.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
	[milan setMediumHighColor:[UIColor colorWithRed:8.0/255 green:72.0/255 blue:183.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
	[milan setMediumLowColor:[UIColor colorWithRed:8.0/255 green:72.0/255 blue:183.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
    [milan setLowColor:[UIColor colorWithRed:7.0/255 green:64.0/255 blue:163.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
    [milan setTextSize:[NSNumber numberWithInt:14]];
    
    [sanFrancisco setHighColor:[UIColor colorWithRed:10.0/255 green:90.0/255 blue:229.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
	[sanFrancisco setMediumHighColor:[UIColor colorWithRed:8.0/255 green:72.0/255 blue:183.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
	[sanFrancisco setMediumLowColor:[UIColor colorWithRed:8.0/255 green:72.0/255 blue:183.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
    [sanFrancisco setLowColor:[UIColor colorWithRed:7.0/255 green:64.0/255 blue:163.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
    [sanFrancisco setTextSize:[NSNumber numberWithInt:14]];
    
    [mission setHighColor:[UIColor colorWithRed:10.0/255 green:90.0/255 blue:229.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
	[mission setMediumHighColor:[UIColor colorWithRed:8.0/255 green:72.0/255 blue:183.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
	[mission setMediumLowColor:[UIColor colorWithRed:8.0/255 green:72.0/255 blue:183.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
    [mission setLowColor:[UIColor colorWithRed:7.0/255 green:64.0/255 blue:163.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
    [mission setTextSize:[NSNumber numberWithInt:14]];


}

- (void)manageLocation{
    
    if ([Beintoo getUserLocation]){
        
        if ([Beintoo getUserLocation].coordinate.latitude == 45.467354 && [Beintoo getUserLocation].coordinate.longitude == 9.189377){
            
            //Milan
            NSLog(@"Location updated to: Milan");
            [greenMilan         setHidden:NO];
            [greenLondon        setHidden:YES];
            [greenSanFrancisco  setHidden:YES];
            [redMilan           setHidden:YES];
            [redLondon          setHidden:NO];
            [redSanFrancisco    setHidden:NO];
        }
        else if ([Beintoo getUserLocation].coordinate.latitude == 51.492500 && [Beintoo getUserLocation].coordinate.longitude == -0.105057){
            
            //London
            NSLog(@"Location updated to: London");
            [greenMilan         setHidden:YES];
            [greenLondon        setHidden:NO];
            [greenSanFrancisco  setHidden:YES];
            [redMilan           setHidden:NO];
            [redLondon          setHidden:YES];
            [redSanFrancisco    setHidden:NO];
        }
        else if ([Beintoo getUserLocation].coordinate.latitude == 37.771258 && [Beintoo getUserLocation].coordinate.longitude == -122.417564){
            
            //San Francesco
            NSLog(@"Location updated to: San Francesco");
            [greenMilan         setHidden:YES];
            [greenLondon        setHidden:YES];
            [greenSanFrancisco  setHidden:NO];
            [redMilan           setHidden:NO];
            [redLondon          setHidden:NO];
            [redSanFrancisco    setHidden:YES];
        }
        else {
            [greenMilan             setHidden:YES];
            [greenLondon            setHidden:YES];
            [greenSanFrancisco      setHidden:YES];
            [redMilan               setHidden:NO];
            [redLondon              setHidden:NO];
            [redSanFrancisco        setHidden:NO];
        }
    }
    else {
        [greenMilan             setHidden:YES];
        [greenLondon            setHidden:YES];
        [greenSanFrancisco      setHidden:YES];
        [redMilan               setHidden:NO];
        [redLondon              setHidden:NO];
        [redSanFrancisco        setHidden:NO];
    }
}

@end
