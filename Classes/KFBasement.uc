class KFBasement extends Actor
    config(KFBasement);


var config float TimeBetweenMessages;
var config int IniVersion;

function PostBeginPlay()
{
    if( Role == ROLE_Authority )
    {
        LogInternal("Loading the basement....");
        LogInternal(TimeStamp());
        LogInternal("TimeBetweenMessages:"@TimeBetweenMessages);
        LogInternal("DONE!");
        UpdateIniIfNoExist();
    }
}

function UpdateIniIfNoExist()
{
    if (IniVersion == 0)
    {
        TimeBetweenMessages = 45.f;
        IniVersion = 1;
        SaveConfig();
    }

}

auto state Loop
{
    function BroadcastMessagIfObjectiveMode()
    {
        local string announcment;
        local PlayerController PC;
        local KFGameReplicationInfo GRI;

        if( (WorldInfo != none) && Role == ROLE_Authority)
        {
            GRI = KFGameReplicationInfo(WorldInfo.GRI);
            if (GRI.bTraderIsOpen){
                foreach WorldInfo.AllControllers(class'PlayerController', PC)
                {
                    announcment = "Get in the zone or get kicked. I don't make the rules..";
                    if( PC.bIsPlayer ) WorldInfo.Game.Broadcast(PC, announcment);
                }
            }
            
        }
    }

Begin:
    BroadcastMessagIfObjectiveMode();
    Sleep(TimeBetweenMessages);
    goto 'Begin';
    stop;
}