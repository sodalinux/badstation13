/*

	PHOTOCOPIER FILE!

	Contains:
	Public Photocopier
	Head's (and qm) Photocopier
	Admin Photocopier

- candycane / etherware
*/

/obj/machinery/laminator
	name = "laminator"
	desc = "A public-access laminator, for your documents and whatnot."
	icon = 'icons/obj/library.dmi'
	icon_state = "laminator"
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 30
	active_power_usage = 200
	power_channel = AREA_USAGE_EQUIP
	max_integrity = 300
	integrity_failure = 100
	level = LAMINATE_STD  // what type of lamination does this do?
	var/access_import  // access level to unlock the lamination (heads only)

/obj/machinery/laminator/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/paper) && user.a_intent != INTENT_HARM)
		var/obj/item/paper/target = I  // checks type already, shouldnt need to check if target is not null
		if(target.laminate)
			to_chat(user, "You cant laminate this, theres already a layer of plastic!")
			return
		target.laminate = level
		target.papercut = obj_flags & EMAGGED  // paper gets papercutty
		target.req_one_access = access_import
		target.update_curstate()
		target.forceMove(src.loc)  // moves paper on top of laminator, to make it look proccessed
		src.visible_message("The laminator pings, and ejects the paper.")
	if(istype(I, /obj/item/paper/contract/infernal))  // cuz its coool
		to_chat(user, "<span class='warning'>[src] smokes, smelling of brimstone!</span>")
		resistance_flags |= FLAMMABLE
		fire_act()

/obj/machinery/laminator/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		obj_flags &= ~EMAGGED
		to_chat(user, "You restore the safety programming.")
		src.visible_message("The laminator pings.")
		return
	obj_flags |= EMAGGED
	update_icon()
	to_chat(user, "You scramble the cutting protector.")
	src.visible_message("The laminator makes a strange vibrating noise.")

/obj/machinery/laminator/head
	name = "private-use laminator"
	desc = "A fancy high-end laminator, for use by station captains."
	icon_state = "laminator_head"
	level = LAMINATE_HEAD
	req_one_access = list(ACCESS_CAPTAIN)
	var/list/owner = list()

/obj/machinery/laminator/head/Initialize()
	req_one_access += owner  // makes the access thing require better

/obj/machinery/laminator/head/sec
	name = "head of security laminator"
	desc = "To make your arrest warrents more stylish."
	owner = list(ACCESS_HOS)

/obj/machinery/laminator/head/eng
	name = "cheif engineer laminator"
	desc = "Relaminate the sm."
	owner = list(ACCESS_CE)

/obj/machinery/laminator/head/med
	name = "cheif medical officer laminator"
	desc = "9 out of 10 doctors reccomend!"  // yes im reusing this from my other pr
	owner = list(ACCESS_CMO)

/obj/machinery/laminator/head/sci
	name = "research director laminator"
	desc = "For the good of all of us (except the ones who are dead)."  // Portal - Still Alive
	owner = list(ACCESS_RD)

/obj/machinery/laminator/head/srv
	name = "head of personell laminator"
	desc = "Bureocracy is a HoP's best friend."
	owner = list(ACCESS_HOP)

/obj/machinery/laminator/head/car
	name = "cargo laminator"
	desc = "Helps you keep track of who buys what, in case of emergency."
	owner = list(ACCESS_CARGO)

/obj/machinery/laminator/com  // exclusive to centcom hq
	name = "mystical laminator"
	desc = "The highest-quality photocopier one could buy. Some claim it prints gold."
	icon_state = "laminator_head"
	level = LAMINATE_COM
	// owner is handled in paper.dm
