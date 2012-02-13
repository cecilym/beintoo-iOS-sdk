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

#import <UIKit/UIKit.h>
#import "Beintoo.h"


@interface BeintooViewController : UIViewController <BeintooPlayerDelegate, BeintooVgoodDelegate, BeintooMissionDelegate, BeintooMissionDelegate>{
	
    //---> Buttons
    IBOutlet BButton *playerLogin;
    IBOutlet BButton *logout;
    IBOutlet BButton *submitScore;
    IBOutlet BButton *submitScoreForContest;
    IBOutlet BButton *achievements;
    IBOutlet BButton *getVgood;
    IBOutlet BButton *getScoreForContest;
    IBOutlet BButton *setBalance;
    IBOutlet BButton *london;
    IBOutlet BButton *milan;
    IBOutlet BButton *sanFrancisco;
    IBOutlet BButton *mission;
    
    IBOutlet UIView     *greenLondon;
    IBOutlet UIView     *greenMilan;
    IBOutlet UIView     *greenSanFrancisco;
    
    IBOutlet UIView     *redLondon;
    IBOutlet UIView     *redMilan;
    IBOutlet UIView     *redSanFrancisco;
    
}

- (IBAction)startBeintoo;
- (IBAction)startMarketplace;
- (IBAction)playerLogin;
- (IBAction)submitScore;
- (IBAction)submitScoreForContest;
- (IBAction)getVgood;
- (IBAction)getScoreForContest;
- (IBAction)setBalance;
- (IBAction)playerLogout;
- (IBAction)submitAchievement;
- (IBAction)setMilan;
- (IBAction)setSanFrancisco;
- (IBAction)setLondon;
- (IBAction)getMission;

- (void)buttonsCustomization;
- (void)manageLocation;

@end

