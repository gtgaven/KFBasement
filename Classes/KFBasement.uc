class KFBasement extends Actor
    config(KFBasement);


var config float TimeBetweenMessages;

function PostBeginPlay()
{
    if( Role == ROLE_Authority )
    {
        LogInternal("Loading the basement....");
        LogInternal(TimeStamp());
        LogInternal("TimeBetweenMessages:"@TimeBetweenMessages);
        LogInternal("DONE!");
        UpdateIni();
    }
}

function UpdateIni()
{
    TimeBetweenMessages = 12.f;
    SaveConfig();
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
            if (GRI.bObjectiveMode){
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