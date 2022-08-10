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

/obj/machinery/laminator/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/paper) && user.a_intent != INTENT_HARM)
		var/obj/item/paper/target = I  // checks type already, shouldnt need to check if target is not null
		if(target.laminate)
			to_chat(user, "You cant laminate this, theres already a layer of plastic!")
			return
		target.laminate = level
		target.papercut = obj_flags & EMAGGED  // paper gets papercutty
		target.update_curstate()
		target.forceMove(src.loc)  // moves paper on top of laminator, to make it look proccessed
		src.visible_message("The laminator pings, and ejects the paper.")
	if(istype(I, /obj/item/paper/contract/infernal))  // cuz its coool
		to_chat(user, "<span class='warning'>[src] smokes, smelling of brimstone!</span>")
		resistance_flags |= FLAMMABLE
		fire_act()

/obj/machinery/laminator/emag_act(mob/user)
	if(!obj_flags & EMAGGED)
		obj_flags |= EMAGGED
		to_chat(user, "You scramble the cutting protector.")
		src.visible_message("The laminator makes a strange vibrating noise.")

/obj/machinery/laminator/head
	name = "private-use laminator"
	desc = "A fancy high-end laminator, for use by station officials."
	icon_state = "laminator_head"
	level = LAMINATE_HEAD

/obj/machinery/laminator/com  // exclusive to centcom hq
	name = "mystical laminator"
	desc = "The highest-quality photocopier one could buy. Some claim it prints gold."
	icon_state = "laminator_head"
	level = LAMINATE_COM
