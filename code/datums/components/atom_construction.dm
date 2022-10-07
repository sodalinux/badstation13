/*

A modified construction proc, for in place construction.
Very useful :)

*/

/datum/component/construction/inplace
	/// callback is called when the last step is deconstructed
	var/datum/callback/deconstruct_callback
	/// callback is called when the final step is constructed
	var/datum/callback/complete_callback

/datum/component/construction/inplace/Initialize(dcon, complete)
	. = ..()
	deconstruct_callback = dcon
	complete_callback = complete

/datum/component/construction/inplace/get_steps()
	return parent:construction_steps

/datum/component/construction/spawn_result()
	complete_callback.Invoke()

/datum/component/construction/on_step()
	if(index < 0)
		deconstruct_callback.Invoke()
	. = ..()
