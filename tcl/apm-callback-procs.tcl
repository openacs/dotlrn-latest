ad_library {
    Procedures for registering implementations for the
    dotlrn latest package. 
    
    @creation-date 2006-08-28
    @author cesar@viaro.net

}

namespace eval dotlrn_latest {}

ad_proc -public dotlrn_latest::install {} {
    dotLRN latest package install proc
} {
    register_portal_datasource_impl
}

ad_proc -public dotlrn_latest::uninstall {} {
    dotLRN Latest package uninstall proc
} {
    unregister_portal_datasource_impl
}

ad_proc -public dotlrn_latest::register_portal_datasource_impl {} {
    Register the service contract implementation for the dotlrn_applet service contract
} {
    set spec {
        name "dotlrn_latest"
	contract_name "dotlrn_applet"
	owner "dotlrn-latest"
        aliases {
	    GetPrettyName dotlrn_latest::get_pretty_name
	    AddApplet dotlrn_latest::add_applet
	    RemoveApplet dotlrn_latest::remove_applet
	    AddAppletToCommunity dotlrn_latest::add_applet_to_community
	    RemoveAppletFromCommunity dotlrn_latest::remove_applet_from_community
	    AddUser dotlrn_latest::add_user
	    RemoveUser dotlrn_latest::remove_user
	    AddUserToCommunity dotlrn_latest::add_user_to_community
	    RemoveUserFromCommunity dotlrn_latest::remove_user_from_community
	    AddPortlet dotlrn_latest::add_portlet
	    RemovePortlet dotlrn_latest::remove_portlet
	    Clone dotlrn_latest::clone
	    ChangeEventHandler dotlrn_latest::change_event_handler
        }
    }
    
    acs_sc::impl::new_from_spec -spec $spec
}

ad_proc -public dotlrn_latest::unregister_portal_datasource_impl {} {
    Unregister service contract implementations
} {
    acs_sc::impl::delete \
        -contract_name "dotlrn_applet" \
        -impl_name "dotlrn_latest"
}

