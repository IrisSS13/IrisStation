/obj/item/organ/appendix/become_inflamed()
	if(!(owner.mind && owner.mind.assigned_role && owner.mind.assigned_role.job_flags & JOB_CREW_MEMBER))
		return

	return ..()
