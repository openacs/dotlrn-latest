<?Xml version="1.0"?>

<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>


<fullquery name="dotlrn_latest::remove_applet.delete_applet_from_communities">
  <querytext>

        delete from dotlrn_community_applets where applet_id = :applet_id

  </querytext>
</fullquery>



<fullquery name="dotlrn_latest::remove_applet.delete_applet">
  <querytext>

        delete from dotlrn_applets where applet_id = :applet_id

  </querytext>
</fullquery>

</queryset>
