// personal assistant agent

/* Task 2 Start of your solution */

/* Task 2.3: Add user preferences for wake-up methods and implement inference rule */

!initialize_user_preferences.

+!initialize_user_preferences
    :   true
    <-
        .print("T2.3: Initializing user preferences for wake-up methods...");
        +ranking(wake_up_method(vibrations), 0);
        +ranking(wake_up_method(natural_light), 1);
        +ranking(wake_up_method(artificial_light), 2);
        .print("T2.3: User preferences initialized.");
    .

// Inference rule for determining the best wake-up method
// best_option(Option)
//     :-  ranking(wake_up_method(Option), Rank)
//         & not (ranking(wake_up_method(_), LowerRank) & LowerRank < Rank).
/* Task 2.3 End */

/* Task 2.5: Update inference rule */
best_option(Option)
    :-  ranking(wake_up_method(Option), Rank)
        & not used(wake_up_method(Option))
        & not (ranking(wake_up_method(_), LowerRank) &
             LowerRank < Rank &
             not used(wake_up_method(_)))
    .
// Record used wake up methods
+used(wake_up_method(Method))
    : true
    <- .print("T2.5: Recording method as used: ", Method).
/* Task 2.5 End */

/* Task 2.1 Start: Log state changes for devices and owner */

// Log state changes for the owner's state reported by the wristband
+owner_state(State)
    :   true
    <-
        .print("T2.1: Owner state changed: ", State);
    .

-owner_state(State)
    :   true
    <-
        .print("T2.1: Owner state removed: ", State);
    .


// Log state changes for lights
+lights(State)
    :   true
    <-
        .print("T2.1: Lights state changed: ", State);
    .

-lights(State)
    :   true
    <-
        .print("T2.1: Lights state removed: ", State);
    .

// Log state changes for blinds
+blinds(State)
    :   true
    <-
        .print("T2.1: Blinds state changed: ", State);
    .

-blinds(State)
    :   true
    <-
        .print("T2.1: Blinds state removed: ", State);
    .

// Log state changes for mattress
+mattress(State)
    :   true
    <-
        .print("T2.1: Mattress state changed: ", State);
    .

-mattress(State)
    :   true
    <-
        .print("T2.1: Mattress state removed: ", State);
    .

// Log the addition of an upcoming event
+upcoming_event(EventTime)
    :   true
    <-
        .print("T2.1: Upcoming event added: ", EventTime);
        // Task 2.2
        !handle_event;
    .

// Log the removal of an upcoming event
-upcoming_event(EventTime)
    :   true
    <-
        .print("T2.1: Upcoming event removed: ", EventTime);
    .
/* Task 2.1 End */

/* Task 2.2: React to the addition of upcoming_event("now") via handle_event goal */
// When an upcoming event is now and the user is awake
+!handle_event
    :   owner_state("awake")
    <-
        .print("T2.2: Enjoy your event.");
    .

// When an upcoming event is now and the user is asleep
+!handle_event
    :   owner_state("asleep")
    <-
        .print("T2.2: Starting wake-up routine.");
        // Task 2.4
        !wake_up_user;
       
    .
/* Task 2.2 End */

/* Task 2.4 and 2.5: Wake up the user based on the best waking option */

+!wake_up_user
    :   true
    <-
        .print("T2.4: Attempting to wake up the user...");
        !try_wake_up;
    .

// Attempt to wake up the user using the best_option
+!try_wake_up
    :   best_option(vibrations)
    <-
        .print("T2.4: Using mattress vibrations to wake the user...");
        setVibrationsMode; // Simulated action to wake user by vibration
        // Task 2.5
        +used(wake_up_method(vibrations));

        !check_user_awake;
    .

+!try_wake_up
    :   best_option(natural_light)
    <-
        .print("T2.4: Using natural light to wake the user...");
        raiseBlinds;
        // Task 2.5
        +used(wake_up_method(natural_light));
        !check_user_awake;
    .

+!try_wake_up
    :   best_option(artificial_light)
    <-
        .print("T2.4: Using artificial light to wake the user...");
        turnOnLights;
        // Task 2.5
        +used(wake_up_method(artificial_light));
        !check_user_awake;
    .

// Check if user is awake, otherwise keep trying
+!check_user_awake
    :   owner_state("awake")
    <-
        .print("T2.4: User is now awake! Wake-up goal achieved.");
        // Task 2.5
        !clear_wakeup_methods;

    .

+!check_user_awake
    :   owner_state("asleep")
    <-
        .print("T2.4: User is still asleep. Retrying to wake up in 5 seconds...");
        // easier to debug :-)
        .wait(5000);

        !try_wake_up;
    .

// Task 2.5 Clear all `used wake_up_method beliefs
+!clear_wakeup_methods
    :   true
    <-
        .print("T2.5: Clearing all used wake-up method beliefs...");
        -used(wake_up_method(vibrations));
        -used(wake_up_method(natural_light));
        -used(wake_up_method(artificial_light));
        .print("T2.5: All wake-up method beliefs cleared.");
    .
/* Task 2.4 and 2.5 End */


/* Task 2 End of your solution */

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }