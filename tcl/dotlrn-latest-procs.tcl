ad_library {

    Procs to set up the dotLRN latest applet

    @author cesar@viaro.net
   
}

namespace eval dotlrn_latest {}

ad_proc -public dotlrn_latest::applet_key {} {
    What's my applet key?
} {
    return dotlrn_latest
}

ad_proc -public dotlrn_latest::package_key {} {
    What package do I deal with?
} {
    return "latest"
}

ad_proc -public dotlrn_latest::my_package_key {} {
    What package do I deal with?
} {
    return "dotlrn-latest"
}


ad_proc -public dotlrn_latest::get_pretty_name {} {
    returns the pretty name
} {
    return "latest"
}

ad_proc -public dotlrn_latest::add_applet {} {
    One time init - must be repeatable!
} {
    dotlrn_applet::add_applet_to_dotlrn -applet_key [applet_key] -package_key [my_package_key]
}

ad_proc -public dotlrn_latest::remove_applet {} {
    One time destroy.
} {
    set applet_id [dotlrn_applet::get_applet_id_from_key [my_package_key]]
    db_exec_plsql delete_applet_from_communities { *SQL* }
    db_exec_plsql delete_applet { *SQL* }
}


ad_proc -public dotlrn_latest::add_applet_to_community {
    community_id
} {
    Add the latest applet to a specifc dotlrn community
} {
    set portal_id [dotlrn_community::get_portal_id -community_id $community_id]

    # create the latest package instance
    set package_id [dotlrn::instantiate_and_mount $community_id [package_key]]
  
    set args [ns_set create]
    ns_set put $args package_id $package_id
    dotlrn_latest::add_portlet_helper $portal_id $args 
    return $package_id
}

ad_proc -public dotlrn_latest::remove_applet_from_community {
    community_id
} {
    remove the applet from the community
} {
    ad_return_complaint 1 "[applet_key] remove_applet_from_community not implimented!"
}

ad_proc -public dotlrn_latest::add_user {
    user_id
} {
    one time user-specifuc init
} {
    ns_log notice "we are going to add the latest portlet to the user with the id = $user_id"
   #set portal_id [dotlrn::get_portal_id -user_id user_id]

   db_0or1row get_portal "select portal_id
            from dotlrn_users
            where user_id = :user_id" 
    latest_portlet::add_self_to_page -portal_id $portal_id -package_id 0 -param_action overwrite

}

ad_proc -public dotlrn_latest::remove_user {
    user_id
} {
} {
    ad_return_complaint 1 "[applet_key] remove_user not implimented!"
}

ad_proc -public dotlrn_latest::add_user_to_community {
    community_id
    user_id
} {
    Add a user to a specifc dotlrn community
} {
    set package_id [dotlrn_community::get_applet_package_id -community_id $community_id -applet_key [applet_key]]
    set portal_id [dotlrn::get_portal_id -user_id $user_id]

    # use "append" here since we want to aggregate
    set args [ns_set create]
    ns_set put $args package_id $package_id
    ns_set put $args param_action append
    add_portlet_helper $portal_id $args
}


ad_proc -public dotlrn_latest::remove_user_from_community {
    community_id
    user_id
} {
    Remove a user from a community
} {
    set package_id [dotlrn_community::get_applet_package_id -community_id $community_id -applet_key [applet_key]]
    set portal_id [dotlrn::get_portal_id -user_id $user_id]

    set args [ns_set create]
    ns_set put $args package_id $package_id

   dotlrn_latest::remove_portlet $portal_id $args
}


ad_proc -public dotlrn_latest::add_portlet {
    portal_id
} {
    A helper proc to add the underlying portlet to the given portal.

    @param portal_id
} {
    # simple, no type specific stuff, just set some dummy values

    set args [ns_set create]
    ns_set put $args package_id 0
    ns_set put $args param_action overwrite
    ns_log notice "dotrln_latest::add_portlet, portal id = $portal_id"
   # set type [dotlrn::get_type_from_portal_id -portal_id $portal_id]
    db_0or1row get_type "select type 
                         from dotlrn_portal_types_map dm, portals p
                         where p.portal_id = :portal_id
                               and p.template_id = dm.portal_id"
     
  
    ns_log notice "el tipo de portal al que se add es $type"

    if {[string equal $type "user"]}  {
            # Add the portlet only to user portal
           dotlrn_latest::add_portlet_helper $portal_id $args
        }  else {
            # not to any of the other types
            return
        }

}

ad_proc -public dotlrn_latest::add_portlet_helper {
    portal_id
    args
} {
    A helper proc to add the underlying portlet to the given portal.

    @param portal_id
    @param args an ns_set
} {
    ns_log notice "We are going to call latest_portlet::add_self_to_page"
   
    db_0or1row get_type "select type 
                         from dotlrn_portal_types_map dm, portals p
                         where p.portal_id = :portal_id
                               and p.template_id = dm.portal_id"
     
  
    ns_log notice "el tipo de portal al que se add es $type"

    if {[string equal $type "user"]}  {
            # Add the portlet only to user portal
       latest_portlet::add_self_to_page \
        -portal_id $portal_id \
        -package_id [ns_set get $args package_id] \
        -param_action [ns_set get $args param_action]       

        }  else {
            # not to any of the other types
            return
        } 
 }

ad_proc -public dotlrn_latest::remove_portlet {
        portal_id
        args
} {
        A helper proc to remove the underlying portlet from the given portal.

        @param portal_id
        @param args An ns_set of args
} {
    
    set package_id [ns_set get $args package_id]
    ns_log notice "dotlrn_latest::remove_portlet"
    latest_portlet::remove_self_from_page -portal_id $portal_id -package_id $package_id
}
   
   
  

