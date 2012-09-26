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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <AdSupport/AdSupport.h>
#import "BeintooPlayer.h"
#import "BeintooVC.h"
#import "BeintooVgood.h"
#import "BeintooAlliance.h"
#import "BeintooVGoodVC.h"
#import "BeintooMission.h"
#import "BeintooMessage.h"
#import "BeintooMessagesVC.h"
#import "BeintooMessagesShowVC.h"
#import "BeintooMultipleVgoodVC.h"
#import "BeintooNewMessageVC.h"
#import "BeintooLoginVC.h"
#import "BLoadingView.h"
#import "BeintooMacros.h"
#import "BeintooLoginVC.h"
#import "BeintooSignupVC.h"
#import "BeintooSigninFacebookVC.h"
#import "BeintooSigninVC.h"
#import "BeintooUser.h"
#import "BeintooNetwork.h"
#import "BeintooDevice.h"
#import "BeintooProfileVC.h"
#import "BeintooFriendActionsVC.h"
#import "BeintooLeaderboardVC.h"
#import "BeintooLeaderboardContestVC.h"
#import "BeintooAlliancesLeaderboardVC.h"
#import "BeintooVGoodShowVC.h"
#import "BeintooWalletVC.h"
#import "BeintooChallengesVC.h"
#import "BeintooFriendsListVC.h"
#import "BeintooShowChallengeVC.h"
#import "BImageDownload.h"
#import "BScore.h"
#import "BView.h"
#import "BGradientView.h"
#import "BButton.h"
#import "BTableView.h"
#import "BTableViewCell.h"
#import "BScrollView.h"
#import "BPrize.h"
#import "BeintooBalanceVC.h"
#import "BeintooFindFriendsVC.h"
#import "BeintooFriendRequestsVC.h"
#import "BeintooMainDelegate.h"
#import "BeintooGraphic.h"
#import "BVirtualGood.h"
#import "BeintooMainController.h"
#import "BeintooNavigationController.h"
#import "BeintooVgoodNavController.h"
#import "BeintooiPadController.h"
#import "BeintooSigninAlreadyVC.h"
#import "BeintooAchievements.h"
#import "BeintooAchievementsVC.h"
#import "BPopup.h"
#import "BMessageAnimated.h"
#import "BeintooWebViewVC.h"
#import "BeintooAllianceActionsVC.h"
#import "BeintooViewAllianceVC.h"
#import "BeintooAlliancesListVC.h"
#import "BeintooCreateAllianceVC.h"
#import "BeintooAlliancePendingVC.h"
#import "BPopupAnimated.h"
#import "BMissionView.h"
#import "BeintooBrowserVC.h"
#import "BSignupLayouts.h"
#import "BSendChallengesView.h"
#import "BSendChallengeDetailsView.h"
#import "BeintooNotificationListVC.h"
#import "BeintooBestore.h"
#import "BeintooBestoreVC.h"
#import "BeintooUrlParser.h"
#import "BeintooOpenUDID.h"

#define BFEATURE_PROFILE			@"Profile"
#define BFEATURE_MARKETPLACE		@"Marketplace"
#define BFEATURE_LEADERBOARD		@"Leaderboard"
#define BFEATURE_WALLET				@"Wallet"
#define BFEATURE_CHALLENGES			@"Challenges"
#define BFEATURE_ACHIEVEMENTS		@"Achievements"
#define BFEATURE_TIPSANDFORUM       @"TipsAndForum"

// BeintooActiveFeatures : NSArray
extern NSString *BeintooActiveFeatures;
extern NSString *BeintooAppOrientation;
extern NSString *BeintooForceRegistration;
extern NSString *BeintooApplicationWindow;
extern NSString *BeintooAchievementNotification;
extern NSString *BeintooLoginNotification;
extern NSString *BeintooScoreNotification;
extern NSString *BeintooNoRewardNotification;
extern NSString *BeintooNotificationPosition;
extern NSString *BeintooDismissAfterRegistration;
extern NSString *BeintooTryBeintooWithRewardImage;
extern NSInteger BeintooNotificationPositionTop;
extern NSInteger BeintooNotificationPositionBottom; 
extern NSString *BeintooAppStatusBarHidden;

@class BeintooVC;

extern NSString *BNSDefLastLoggedPlayers;
extern NSString *BNSDefLoggedPlayer;
extern NSString *BNSDefLoggedUser;
extern NSString *BNSDefIsUserLogged;

@interface Beintoo : NSObject {
	
	id <BeintooMainDelegate> mainDelegate;

	NSString			*apiKey;
	NSString			*apiSecret;
	NSString			*deviceID;
	NSString			*restBaseUrl;
	int					appOrientation;
	BOOL				forceRegistration;
	BOOL				isOnSandbox;
    BOOL                isOnPrivateSandbox;
    BOOL                showAchievementNotification;
    BOOL                showLoginNotification;
    BOOL                showScoreNotification;
    BOOL                showNoRewardNotification;
    BOOL                dismissBeintooAfterRegistration;
    BOOL                forceTryBeintoo;
    BOOL                tryBeintooImageTypeReward;
    BOOL                statusBarHiddenOnApp;
    
    dispatch_queue_t                beintooDispatchQueue;
    NSInteger                       notificationPosition;
	CLLocation                      *userLocation;
	CLLocationManager               *locationManager;
	NSArray                         *featuresArray;
	NSArray                         *lastLoggedPlayers;
      
#ifdef UI_USER_INTERFACE_IDIOM
    UIPopoverController             *homePopover;
    UIPopoverController             *loginPopover;
    UIPopoverController             *vgoodPopover;
    UIPopoverController             *recommendationPopover;
#endif
	
    UIWindow                        *applicationWindow;
	BeintooVgood                    *beintooVgoodService;
	BeintooPlayer                   *beintooPlayerService;
    BeintooUser                     *beintooUserService;
	BeintooAchievements             *beintooAchievementsService;
    BeintooBestore                  *beintooBestoreService;
	
    NSDictionary                    *lastRetrievedMission;
	BVirtualGood                    *lastGeneratedGood;
    BVirtualGood                    *lastGeneratedAd;
	BPrize                          *prizeView;
    BPrize                          *adView;
    BMissionView                    *missionView;
	BMessageAnimated                *notificationView;
	
    BeintooMainController           *mainController;
    BeintooMainController           *mainAdController;
	BeintooNavigationController     *mainNavigationController;
    BeintooNavigationController     *bestoreNavigationController;
    BeintooNavigationController     *leaderboardNavigationController;
    BeintooNavigationController     *achievementsNavigationController;
    BeintooNavigationController     *myoffersNavigationController;
    BeintooNavigationController     *notificationsNavigationController;
    BeintooNavigationController     *signupNavigationController;
    BeintooNavigationController     *privateNotificationsNavigationController;
    BeintooNavigationController     *privateSignupNavigationController;
	BeintooVgoodNavController       *vgoodNavigationController;
    BeintooVgoodNavController       *adNavigationController;
	BeintooiPadController           *ipadController;
	
    BeintooVC                       *beintooPanelRootViewController;
    BeintooWalletVC                 *beintooWalletViewController;
    BeintooLeaderboardVC            *beintooLeaderboardVC;
    BeintooLeaderboardContestVC     *beintooLeaderboardWithContestVC;
    BeintooNotificationListVC       *beintooNotificationsVC;
    BeintooBestoreVC                *beintooBestoreVC;
    
}

+ (void)initWithApiKey:(NSString *)_apikey andApiSecret:(NSString *)_apisecret andBeintooSettings:(NSDictionary *)_settings andMainDelegate:(id<BeintooMainDelegate>)beintooMainDelegate;
+ (void)launchBeintoo;
+ (void)launchBeintooOnAppWithVirtualCurrencyBalance:(float)_value;
+ (void)launchNotifications;
+ (void)_launchPrivateSignup;
+ (void)launchBestore;
+ (void)launchBestoreWithVirtualCurrencyBalance:(float)_value;
+ (void)launchMarketplace __attribute__((deprecated("use 'launchBestore' instead")));
+ (void)launchMarketplaceOnAppWithVirtualCurrencyBalance:(float)_value __attribute__((deprecated("use 'launchBestoreWithVirtualCurrencyBalance:' instead")));
+ (void)launchMyOffers;
+ (void)launchWallet __attribute__((deprecated("use 'launchMyOffers' instead")));
+ (void)launchLeaderboard;
+ (void)launchSignup;
+ (void)launchAchievements;
+ (void)launchPrize;
+ (void)launchPrizeOnAppWithDelegate:(id<BeintooPrizeDelegate>)_beintooPrizeDelegate;
+ (void)launchAd;
+ (void)launchAdWithDelegate:(id<BeintooPrizeDelegate>)_beintooPrizeDelegate;
+ (void)launchMission __attribute__((deprecated));
+ (void)launchIpadLogin;
+ (void)dismissIpadLogin;
+ (void)launchIpadNotifications;
+ (void)_launchPrivateNotifications;
+ (void)dismissIpadNotifications;
+ (BOOL)isUserLogged;
+ (BOOL)isRegistrationForced;
+ (BOOL)isTryBeintooForced;
+ (BOOL)showAchievementNotification;
+ (BOOL)showLoginNotification;
+ (BOOL)showScoreNotification;
+ (BOOL)showNoRewardNotification;
+ (BOOL)isTryBeintooImageTypeReward;
+ (BOOL)dismissBeintooOnRegistrationEnd;
+ (BOOL)isOnSandbox;
+ (BOOL)isOnPrivateSandbox;
+ (BOOL)userHasAllowedLocationServices;
+ (void)setUserLogged:(BOOL)isLoggedValue;
+ (NSString *)currentVersion;
+ (NSInteger)notificationPosition;
+ (NSDictionary *)getPlayer;
+ (NSDictionary *)getUserIfLogged;
+ (NSDictionary *)getAppVgoodThresholds;
+ (NSString *)getRestBaseUrl;
+ (NSString *)getApiKey;
+ (NSString *)getPlayerID;
+ (NSString *)getUserID;
+ (NSArray *)getFeatureList;
+ (NSArray *)getLastLoggedPlayers;
+ (NSString *)getMissionTimestamp;
+ (void)setMissionTimestamp:(NSString *)_timestamp;
+ (BVirtualGood *)getLastGeneratedVGood;
+ (BVirtualGood *)getLastGeneratedAd;
+ (NSDictionary *)getLastRetrievedMission;
+ (void)setLastRetrievedMission:(NSDictionary *)_mission;
+ (BeintooVgood *)beintooVgoodService;
+ (BeintooPlayer *)beintooPlayerService;
+ (BeintooUser *)beintooUserService;
+ (BeintooAchievements *)beintooAchievementService;
+ (BeintooBestore *)beintooBestoreService;
+ (UIViewController *)getMainController;
+ (BeintooNavigationController *)getMainNavigationController;
+ (BeintooVgoodNavController *)getVgoodNavigationController;
+ (BeintooNavigationController *)getBestoreNavigationController;
+ (BeintooNavigationController *)getLeaderboardsNavigationController;
+ (BeintooNavigationController *)getMyOffersNavigationController;
+ (BeintooNavigationController *)getAchievementsNavigationController;
+ (BeintooNavigationController *)getNotificationsNavigationController;
+ (BeintooNavigationController *)getSignupNavigationController;
+ (BeintooNavigationController *)getPrivateNotificationsNavigationController;
+ (BeintooNavigationController *)getPrivateSignupNavigationController;
+ (BeintooNotificationListVC *)getPrivateNotificationsViewController;
+ (UIWindow *)getAppWindow;
+ (void)setLastGeneratedVgood:(BVirtualGood *)_theVGood;
+ (void)setLastGeneratedAd:(BVirtualGood *)_theAd;
+ (int)appOrientation;
+ (void)setBeintooUser:(NSDictionary *)_user;
+ (void)setBeintooPlayer:(NSDictionary *)_player;
+ (void)setBeintooUserFriends:(NSArray *)friends;
+ (NSArray *)getBeintooUserFriends;
+ (BOOL)isAFriendOfMine:(NSString *)_friendID;
+ (void)switchBeintooToSandbox;
+ (void)dismissBeintoo;
+ (void)dismissBeintoo:(int)type;
+ (void)dismissBeintooNotAnimated;
+ (void)dismissPrize;
+ (void)dismissAd;
+ (void)dismissRecommendation;
+ (void)dismissMission;
+ (void)beintooDidAppear;
+ (void)beintooDidDisappear;
+ (void)prizeDidAppear;
+ (void)beintooWillDisappear;
+ (void)prizeDidDisappear;
+ (void)updateUserLocation;
+ (void)setLastLoggedPlayers:(NSArray *)_players;
+ (void)playerLogout;
+ (void)notifyVGoodGenerationOnMainDelegate;
+ (void)changeBeintooOrientation:(int)_orientation;
+ (void)notifyVGoodGenerationErrorOnMainDelegate:(NSDictionary *)_error;
+ (id<BeintooMainDelegate>)getMainDelegate;
+ (dispatch_queue_t)beintooDispatchQueue;
+ (NSString *)getUserLocationForURL;
+ (BeintooVC *)getBeintooPanelRootViewController;
+ (BMessageAnimated *)getNotificationView;
+ (CLLocation *)getUserLocation;
+ (void)shutdownBeintoo;
+ (BOOL)isStatusBarHiddenOnApp;
+ (void)_setUserLocation:(CLLocation *)_location;

//-------> Marketplace Developer Currency Management Methods <--------
+ (void)setVirtualCurrencyName:(NSString *)_name forUserId:(NSString *)_userId withBalance:(float)_value;
+ (void)setDeveloperUserId:(NSString *)_userId withBalance:(float)_value;
+ (NSString *)getVirtualCurrencyName;
+ (void)setVirtualCurrencyName:(NSString *)_name;
+ (void)setDeveloperUserId:(NSString *)_id;
+ (NSString *)getDeveloperUserId;
+ (float)getVirtualCurrencyBalance;
+ (void)setVirtualCurrencyBalance:(float)_value;
+ (void)removeStoredVirtualCurrency;
+ (BOOL)isVirtualCurrencyStored;

+ (void)postNotificationBeintooUserDidLogin;
+ (void)postNotificationBeintooUserDidSignup;

+ (void)adControllerDidAppear;
+ (void)adControllerDidDisappear;
+ (void)notifyAdGenerationOnMainDelegate;
+ (void)notifyAdGenerationErrorOnMainDelegate:(NSDictionary *)_error;

@end


