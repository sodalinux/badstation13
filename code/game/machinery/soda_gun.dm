/obj/machinery/soda_gun
	name = "soda gun console"
	desc = "A way to quickly get some drinks on the table. Comes with the most popular drinks, and a handy nozzle. \
	It even comes with holographic cups!"
	icon_state = "synthesizer"
	idle_power_usage = 8 //5 with default parts
	active_power_usage = 13 //10 with default parts
	circuit = /obj/item/circuitboard/machine/dish_drive
	var/static/base_drinks = list(
		/datum/reagent/water,
		/datum/reagent/consumable/ice,
		/datum/reagent/consumable/coffee,
		/datum/reagent/consumable/cream,
		/datum/reagent/consumable/tea,
		/datum/reagent/consumable/icetea,
		/datum/reagent/consumable/space_cola,
		/datum/reagent/consumable/tonic,
		/datum/reagent/consumable/sodawater,
		/datum/reagent/consumable/lemon_lime,
		/datum/reagent/consumable/sugar,

		/datum/reagent/consumable/ethanol/beer,
		/datum/reagent/consumable/ethanol/wine,
		/datum/reagent/consumable/ethanol/vodka,
		/datum/reagent/consumable/ethanol/gin,
		/datum/reagent/consumable/ethanol/triple_sec,
	)

	// var/obj/item/soda_stream/attached_nozzle

/obj/machinery/soda_gun/attack_hand(mob/living/user)
	. = ..()
	var/datum/reagent/your_pick = input(usr, "", "What drink would you like?") as null | anything in base_drinks
	if(!your_pick)
		return

	to_chat(user, your_pick)
