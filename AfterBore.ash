// ShaBob & Joe's AFTERBORE Script
// http://kolmafia.us/showthread.php?t=

notify ShaBob;
import <zlib.ash>
import <eatdrink.ash>
//script "AfterBore.ash";

string thisver = "0.9.3";		// This is the script's version!

 
// check_version("AfterBore", "AfterBore", thisver, 7015)

// Thanks to those whose work has been absorbed to make this: 
//    jasonharper, slyz & Especially Panama Joe whose script this is.
//
//////////////////////////////////////////////////////////////////////
//                                                                  //
//             You MUST run the Relay Script to                     //
//             Set Configuration Options before                     //
//             Attempting to use this Script.                       //
//                                                                  //
//             Setting Options Directly is NOT                      //
//             A Good Idea (tm)                                     //
//                                                                  //
//////////////////////////////////////////////////////////////////////



//Avoid script abort due to CLI command problems
boolean safe_cli_execute( string cmd )   
	{   
	    boolean success; 
	    try   
	    {   
        	cli_execute( cmd );
	        success = true;   
	    }   
	    finally   
	    {   
	        return success;   
	    }   
	    return success;   
	}


// Some Settings & Variables to make Script Cleaner


item BORE_FOOD = get_property("boreDiet_Food").to_item();
item BORE_DRINK = get_property("boreDiet_Drink").to_item();
item BORE_DRINK_FILLER = get_property("boreDiet_Drink_Filler").to_item();
item BORE_SPLEEN = get_property("boreDiet_Spleen").to_item();
string BORE_MOB = get_property("boreMonster").to_monster();
string BORE_FAX = get_property("boreMonster");

// Donation Script from slyz

int total_donation( string hero )
	{
    		return get_property( "heroDonation" + hero ).to_int();
	}

string to_command( string hero )
	{
	    switch( hero )
	    {
		    case "Boris": return "boris";
		    case "Jarlsberg": return "jarl";
		    case "SneakyPete": return "pete";
	    }
	    return "";
	}

item to_key( string hero )
	{
	    switch( hero )
	    {
		    case "Boris": return $item[ Boris's key ];
		    case "Jarlsberg": return $item[ Jarlsberg's key ];
		    case "SneakyPete": return $item[ Sneaky Pete's key ];
	    }
	    return $item[ Xlyinia's notebook ];
	}	
// Panama Joe's bestfam() function

void best_fam()
	{
		string famkeep = vars["is_100_run"];
		if ( famkeep == "none" )
		{
			int temp;
			familiar bestfam;
			foreach f in $familiars[] if (have_familiar(f) && familiar_weight(f) > temp) 
			{ 
				temp = familiar_weight(f);
				bestfam = f;
			} 
			use_familiar ( bestfam );
		}
	}

// Options are ALL selected in the relay script. Do not Edit this File!

// Collects Flowers
void pvp()
	{
		print_html("<b>AfterBore:</b> Commencing Flower Picking For Your Convenience");
		maximize ("mox", false );
		best_fam();
		cli_execute ("flowers");

	}

void get_ode()
	{
	while ((have_effect($effect[ode to booze]) < inebriety_limit() ) && have_skill($skill[ode to booze]))
	{
	   use_skill(1 , $skill[ode to booze]);
   	}
	if ( ! have_skill ( $skill [ode to booze] ))
	{
		print("purchasing Ode to Booze from a buffbot...", "blue");
		if ( have_effect ( $effect [polka of plenty]) > 0 )
		cli_execute ("shrug polka" );
		cli_execute("csend 1 meat to Testudinata");
		int iterations = 0;
		while(have_effect($effect[Ode to Booze]) < 1 && iterations < 30) {
		   wait(30);
		   refresh_status();
		   iterations = iterations + 1;
	   }
	if(have_effect($effect[Ode to Booze]) < 1)
	{
	   print("failed to get Ode to Booze", "red");
	   }

	}
}

// Drinks the User Selected Drink - Uses Joe's Ode routines
void drink()
	{
		print_html("<b>AfterBore:</b> About to Start in on the Booze");

//		if (have_skill($skill[Ode to Booze]) )	use_skill( 1 , $skill[ ode to booze] );
//		else 
//		{
//			print("purchasing Ode to Booze from a buffbot...", "blue");
//			cli_execute("csend 1 meat to Testudinata");
//			int iterations = 0;
//			while(have_effect($effect[Ode to Booze]) < 1 && iterations < 30) {
//			   wait(30);
//			   refresh_status();
//			   iterations = iterations + 1;
//			}	
//			if(have_effect($effect[Ode to Booze]) < 1){
//			   print("failed to get Ode to Booze", "red");
//			   }
//			  else print ("Ready to rock!", "green" );
//		}

		get_ode();
		int amount = floor((inebriety_limit() - my_inebriety()) / 3);
		drink(amount, BORE_DRINK);
		
		int fillup = floor(inebriety_limit() - my_inebriety());
		drink(fillup, BORE_DRINK_FILLER);
	}



// Eats the User Selected Food
void diet() // This section is clearly in need of significant work.
	{   
		print_html("<b>AfterBore:</b> Eating Time!");
		int temp_full = 0;
		while ( my_fullness() < fullness_limit() && temp_full != my_fullness() )
		{
			if ( have_effect ( $effect[got milk]) < 3)//use milk only as required
			{
				use (1, $item[milk of magnesium]);
			}
			temp_full = my_fullness();
			eat (1, BORE_FOOD);
		}
	}
// Spleens the, you get the picture
void spleen()
	{
		use (3, BORE_SPLEEN);
		use (1, $item[mojo filter]);
		use (1, BORE_SPLEEN);
	}

// Fights Monster as selected by the user. 
// The Script maximizes itemdrops, and can become somewhat expensive :)
void clod()
	{
		print_html("<b>AfterBore:</b> Fighting your Selected Monster.");
		if ( get_property ( "_photocopyUsed" ) == true ) return;
		if( !is_online( "faxbot" ) ) abort( "Faxbot is dead!" );
		while ( get_property( "photocopyMonster" ) != BORE_MOB )
		{
			if (item_amount ( $item[photocopied monster] ) != 0)
			{
				cli_execute ("fax put");
			}
			chat_private ("faxbot", BORE_FAX );
			wait (60);
			cli_execute ("fax get");
		}
		//buffing and combat routine
		maximize ("items", false );
		foreach potion in $items[cyclops eyedrops, polka pop, blue-frosted astral cupcake, knob goblin eyedrops, buffing spray]
		{
			use (1, potion);
		}
		cli_execute ( "ccs " + get_property("boreClod_4dCCS") ); //ccs to use 4-d camera
		use ( 1, $item[photocopied monster]);
		cli_execute ( "ccs " + get_property("boreClod_PuttyCCS") );//ccs to use putty
		use ( 1, $item[Shaking 4-d camera]);
		for j from 1 to 5
		{
			use ( 1, $item[spooky putty monster]);
		}
	}

// Takes Shoretrips towards the Boat Trophies.
// If someone could show me a method of getting this down to one line, I'd be a happy bunny.
// something along the lines of : adventure ( 1 , VAC_LOC ); // which didn't work :(
void shoretrip()
	{
		print_html("<b>AfterBore:</b> About to have some Vacations");
		print(get_property("boreShore_Stat"));
		maximize ("mp regen max", false );//let's get some MP out of this
		if (get_property("boreShore_Stat") == "Moxie")
		{
		print("Moxie Vacation");
		for foo from 1 to (my_adventures() / 3)
			{
			print("Taking Trip No."+foo);
			adventure ( 1 , $location[moxie vacation] );
			set_property("boreShoretrips", to_int(get_property("boreShoretrips")) + 1);
			}
		}
		if (get_property("boreShore_Stat") == "Muscle")
		{
		print("Muscle Vacation");
		for foo from 1 to (my_adventures() / 3)
			{
			print("Taking Trip No."+foo);
			adventure ( 1 , $location[muscle vacation] );
			set_property("boreShoretrips", to_int(get_property("boreShoretrips")) + 1);
			}
		}
		if (get_property("boreShore_Stat") == "Mysticality")
		{
		print("Myst Vacation");
		for foo from 1 to (my_adventures() / 3)
			{
			print("Taking Trip No."+foo);
			adventure ( 1 , $location[mysticality vacation] );
			set_property("boreShoretrips", to_int(get_property("boreShoretrips")) + 1);
			}
		}
	}


// Donates
void donate()
	{
		print("<b>AfterBore:</b> Donating to Heroes - So You Don't Have To!");
		
		    int donation;
		    int max_donation = my_level() * 10000;
		    foreach hero in $strings[ Boris, Jarlsberg, SneakyPete ]
		    {
		        if ( total_donation( hero ) >= 1000000 ) continue;
		        if ( max_donation <= 0 ) return;
        		if ( my_meat() == 0 )
		        {
		            print( "You need meat to make donations!" );
		            return;
		        }
		        if ( item_amount( hero.to_key() ) == 0 )
		        {
		            print( "You need a " + hero.to_key() + " to donate to " + hero, "red" );
		            continue;
		        }
		        donation = min( my_meat(), min( max_donation , 1000000 - total_donation( hero ) ) ); 
		        if ( safe_cli_execute( "donate " + hero.to_command() + " " + donation ) )
		        {
		            max_donation -= donation;
		        }
		        // the donation failed, you have probably donated the limit for the day
		}
	}

//Prints a summary

void summary()
	{
		print("AfterBore:</b> Summary");
		print ("Total black puddings fought " + get_property( "blackPuddingsDefeated" ), "green");
		print ("Total shore trips " + get_property( "boreShoretrips" ), "green");
		print ("Total 4-D cameras used " + get_property ( "camerasUsed" ), "green");
		print ("Donated to Boris " + get_property( "heroDonationBoris" ), "green");
		print ("Donated to Jarlsberg " + get_property( "heroDonationJarlsberg" ), "green");
		print ("Donated to Sneaky Pete " + get_property( "heroDonationSneakyPete" ), "green");
	}

//Does Rollovers - This presently appears to be broken :(

void rollover()
	{
		print("AfterBore:Setting up your rollover");
		if (get_property("boreDrink")== true)
			drink (1, BORE_DRINK);
		else
		// if we're not on bore booze, let eatdrink overdrink us
		eatdrink ( fullness_limit(), inebriety_limit(), spleen_limit(), TRUE );
		maximize ("pvp fights", false );
		chat_clan("/whitelist " + get_property("boreRolloverClan"));
	}


//Ties it all together
void run()
{
		if (get_property("borePvp")== true) pvp();
		if (get_property("boreDrink")== true) drink();
		if (get_property("boreDiet")== true) diet();
		if (get_property("boreSpleen")== true) spleen();
		eatdrink ( fullness_limit(), inebriety_limit(), spleen_limit(), FALSE );//use up any remaining diet room
		if (get_property("boreClod")== true) clod();
		if (get_property("boreShore")== true) shoretrip();
		if (get_property("boreDonate")== true) donate();
		summary();
	//test for adventures lost to rollover and shout if case
	if ( my_adventures < 130 && my_inebriety() == inebriety_limit() && get_property ("boreRollover") == true ) 
//	{
//		if   ( get_property("boreRollover")== true)
//		{
			rollover();
//		}
//	}
else
print ( "Ouch, you may lose adventures to rollover", "red" );
}

void main()
	{
	run();
	}
