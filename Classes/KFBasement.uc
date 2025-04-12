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
    }
}

auto state Loop
{
    function BroadcastMessage()
    {
        local string Message = "Get in the zone or get kicked. I don't make the rules..";
        local PlayerController PC;

        if( (WorldInfo != none) && Role == ROLE_Authority )
        {
            foreach WorldInfo.AllControllers(class'PlayerController', PC)
            {
                if( PC.bIsPlayer ) WorldInfo.Game.Broadcast(PC, Message);
            }

        }
    }

Begin:
    BroadcastMessage();
    Sleep(TimeBetweenMessages);
    goto 'Begin';
    stop;
}