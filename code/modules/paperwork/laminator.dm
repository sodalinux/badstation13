/*

	PHOTOCOPIER FILE!

	Contains:
	Public Photocopier
	Head's (and qm) Photocopier
	Admin Photocopier

- candycane / etherware
*/

/obj/machinery/laminator
	name = "public laminator"
	desc = "A public-access laminator, for your menus and whatnot."
	icon = 'icons/obj/library.dmi'
	icon_state = "photocopier"
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 30
	active_power_usage = 200
	power_channel = AREA_USAGE_EQUIP
	max_integrity = 300
	integrity_failure = 100
	level = LAMINATE_STD  // what type of lamination does this do?

/obj/machinery/laminator/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/paper) && user.a_intent != INTENT_HARM)
		var/obj/item/paper/target = I
		target.laminate = level
		target.papercut = obj_flags & EMAGGED  // paper gets papercutty
		target.update_curstate()
		target.forceMove(src.loc)  // moves paper on top of laminator, to make it look proccessed
		src.visible_message("The laminator pings, and the paper is ejected.")

/obj/machinery/laminator/emag_act(mob/user)
	if(!obj_flags & EMAGGED)
		obj_flags |= EMAGGED
		to_chat(user, "You scramble the cutting protector.")
		src.visible("The laminator makes a strange vibrating noise.")

/obj/machinery/laminator/head
	name = "private-use laminator"
	desc = "A fancy high-end laminator, for use by station officials."
	level = LAMINATE_HEAD

/obj/machinery/laminator/com  // exclusive to centcom hq
	name = "mystical laminator"
	desc = "The highest-quality photocopier one could buy. Some claim it prints gold."
	level = LAMINATE_COM
