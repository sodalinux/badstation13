/*
        Ported from /vg/station:
        https://github.com/vgstation-coders/vgstation13/blob/Bleeding-Edge/code/game/objects/items/devices/sound_synth.dm
*/

/obj/item/soundsynth
    name = "sound synthesizer"
    desc = "A device that is able to create sounds."
    icon = 'icons/obj/radio.dmi'
    icon_state = "radio"
    item_state = "radio"
    w_class = WEIGHT_CLASS_TINY
    siemens_coefficient = 1

    var/tmp/spam_flag = 0 //To prevent mashing the button to cause annoyance like a huge idiot.
    var/selected_sound = "sound/items/bikehorn.ogg"
    var/shiftpitch = 1
    var/volume = 50

    var/list/sound_list = list( //How I would like to add tabbing to make this not as messy, but BYOND doesn't like that.
    "Honk" = "selected_sound=sound/items/bikehorn.ogg&shiftpitch=1&volume=50",
    "Applause" = "selected_sound=sound/effects/applause.ogg&shiftpitch=1&volume=65",
    "Laughter" = "selected_sound=sound/effects/laughtrack.ogg&shiftpitch=1&volume=65",
    "Rimshot" = "selected_sound=sound/effects/rimshot.ogg&shiftpitch=1&volume=65",
    "Trombone" = "selected_sound=sound/misc/sadtrombone.ogg&shiftpitch=1&volume=50",
    "Airhorn" = "selected_sound=sound/items/airhorn.ogg&shiftpitch=1&volume=50",
    "Alert" = "selected_sound=sound/effects/alert.ogg&shiftpitch=1&volume=50",
    "Boom" = "selected_sound=sound/effects/explosion1.ogg&shiftpitch=1&volume=50",
    "Boom from Afar" = "selected_sound=sound/effects/explosionfar.ogg&shiftpitch=1&volume=50",
    "Bubbles" = "selected_sound=sound/effects/bubbles.ogg&shiftpitch=1&volume=50",
    "Countdown" = "selected_sound=sound/ambience/countdown.ogg&shiftpitch=0&volume=55",
    "Creepy Whisper" = "selected_sound=sound/hallucinations/turn_around1.ogg&shiftpitch=1&volume=50",
    "Ding" = "selected_sound=sound/machines/ding.ogg&shiftpitch=1&volume=50",
    "Bwoink" = "selected_sound=sound/effects/adminhelp.ogg&shiftpitch=1&volume=50",
    "Double Beep" = "selected_sound=sound/machines/twobeep.ogg&shiftpitch=1&volume=50",
    "Flush" = "selected_sound=sound/machines/disposalflush.ogg&shiftpitch=1&volume=40",
    "Kawaii" = "selected_sound=sound/ai/default/animes.ogg&shiftpitch=0&volume=60",
    "Startup" = "selected_sound=sound/mecha/nominal.ogg&shiftpitch=0&volume=50",
    "Welding Noises" = "selected_sound=sound/items/welder.ogg&shiftpitch=1&volume=55",
    "Short Slide Whistle" = "selected_sound=sound/effects/slide_whistle_short.ogg&shiftpitch=1&volume=50",
    "Long Slide Whistle" = "selected_sound=sound/effects/slide_whistle_long.ogg&shiftpitch=1&volume=50",
    "YEET" = "selected_sound=sound/effects/yeet.ogg&shiftpitch=1&volume=50",
    "Time Stop" = "selected_sound=sound/magic/timeparadox2.ogg&shiftpitch=0&volume=80",
    "Click" = "selected_sound=sound/machines/click.ogg&shiftpitch=0&volume=80",
    "Booing" = "selected_sound=sound/effects/audience-boo.ogg&shiftpitch=0&volume=80",
    "Awwing" = "selected_sound=sound/effects/audience-aww.ogg&shiftpitch=0&volume=80",
    "Gasping" = "selected_sound=sound/effects/audience-gasp.ogg&shiftpitch=0&volume=80",
    "Oohing" = "selected_sound=sound/effects/audience-ooh.ogg&shiftpitch=0&volume=80"
    )

/obj/item/soundsynth/verb/pick_sound()
    set category = "Object"
    set name = "Select Sound Playback"
    var/thesoundthatwewant = input("Pick a sound:", null) as null|anything in sound_list
    if(!thesoundthatwewant)
        return
    to_chat(usr, "Sound playback set to: [thesoundthatwewant]!")
    var/list/assblast = params2list(sound_list[thesoundthatwewant])
    selected_sound = assblast["selected_sound"]
    shiftpitch = text2num(assblast["shiftpitch"])
    volume = text2num(assblast["volume"])

/obj/item/soundsynth/attack_self(mob/user as mob)
    if(spam_flag + 2 SECONDS < world.timeofday)
        playsound(src, selected_sound, volume, shiftpitch)
        spam_flag = world.timeofday

/obj/item/soundsynth/AltClick(mob/living/carbon/user)
	pick_sound()

/obj/item/soundsynth/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
    if(M == user)
        pick_sound()
    else if(spam_flag + 2 SECONDS < world.timeofday)
        M.playsound_local(get_turf(src), selected_sound, volume, shiftpitch)
        spam_flag = world.timeofday
        //to_chat(M, selected_sound) //this doesn't actually go to their chat very much at all.

/obj/item/soundsynth/boombox  // tator item
	var/trigger_sound
	var/recharge_rate = 5 MINUTES
	COOLDOWN_DECLARE(kaboom)

/obj/item/soundsynth/boombox/proc/generate_sound()
	var/sound_index = pick(sound_list)
    var/list/assblast = params2list(sound_list[sound_index])
    trigger_sound = assblast["selected_sound"]
	return trigger_sound // returns to the uplink buy proc, to add to memory

/obj/item/soundsynth/boombox/attack_self(mob/user)
	if(trigger_sound == selected_sound)
		if(COOLDOWN_FINISHED(src, kaboom))
			for(var/atom/movable/affected in oview(2, user))
				affected.emp_act(EMP_HEAVY)
				do_sparks(1, FALSE, affected)
				if(ismob(affected))
					var/mob/A = affected
					log_combat(user, A, "attacked", "EMP-boombox")
			user.visible_message("<span class='danger'>A wave of static seems to eminate out of [user].</span>")
			do_sparks(1, FALSE, user)
			COOLDOWN_START(src, kaboom, 5 MINUTES)
		else
			to_chat(user, "<span class='warning'>\The [src] is still recharging! You can use it again in [round((kaboom - world.time) / 10)] seconds.")
		return
	. = ..()
