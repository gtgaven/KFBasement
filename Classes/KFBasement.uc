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
    function BroadcastMessage()
    {
        local string announcment;
        local PlayerController PC;

        if( (WorldInfo != none) && Role == ROLE_Authority )
        {
            foreach WorldInfo.AllControllers(class'PlayerController', PC)
            {
                announcment = "Get in the zone or get kicked. I don't make the rules..";
                if( PC.bIsPlayer ) WorldInfo.Game.Broadcast(PC, announcment);
            }
        }
    }

Begin:
    BroadcastMessage();
    Sleep(TimeBetweenMessages);
    goto 'Begin';
    stop;
}