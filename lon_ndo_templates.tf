### CREATE APPLICATION PROFILES ###
resource "mso_schema_template_anp" "r_anp_new_app" {
    display_name = "tf-anp-${var.name_new_app}${random_integer.r_rnd_appid.id}"
    name         = "tf-anp-${var.name_new_app}${random_integer.r_rnd_appid.id}"
    schema_id    = mso_schema.r_schm_new_app.id
    template     = mso_schema_template.r_tmpl_new_app.name
}

### CREATE EPGs ###
resource "mso_schema_template_anp_epg" "r_epg_new_app_web" {
    schema_id                  = mso_schema.r_schm_new_app.id
    template_name              = mso_schema_template.r_tmpl_new_app.name
    anp_name                   = mso_schema_template_anp.r_anp_new_app.name
    name                       = "tf-epg-${var.name_new_app}${random_integer.r_rnd_appid.id}-web"
    display_name               = "tf-epg-${var.name_new_app}${random_integer.r_rnd_appid.id}-web"
    bd_name                    = var.infra_bd_name_hybrid_bd
    bd_schema_id               = var.infra_schema_id_hybrid_apps 
    bd_template_name           = var.infra_template_name_onprem 
    vrf_name                   = var.infra_vrf_name_stretch_vrf
    vrf_schema_id              = var.infra_schema_id_hybrid_apps 
    vrf_template_name          = var.infra_template_name_shared
    intersite_multicast_source = false
    intra_epg                  = "unenforced"
    preferred_group            = false
    proxy_arp                  = false
    useg_epg                   = false
}

### CREATE WEB EPG SELECTOR for AWS ###
resource "mso_schema_template_anp_epg_selector" "r_epgsel_new_app_web" {
    schema_id                  = mso_schema.r_schm_new_app.id
    template_name              = mso_schema_template.r_tmpl_new_app.name
    anp_name                   = mso_schema_template_anp.r_anp_new_app.name
    epg_name                   = mso_schema_template_anp_epg.r_epg_new_app_web.name
    name                       = "tf-epgsel-${var.name_new_app}${random_integer.r_rnd_appid.id}-web"
    expressions {
        key         = "Custom:Name"
        operator    = "equals"
        value       = var.name_new_app_web_server
    }
}

resource "mso_schema_template_anp_epg" "r_epg_new_app_db" {
    schema_id                  = mso_schema.r_schm_new_app.id
    template_name              = mso_schema_template.r_tmpl_new_app.name
    anp_name                   = mso_schema_template_anp.r_anp_new_app.name
    name                       = "tf-epg-${var.name_new_app}${random_integer.r_rnd_appid.id}-db"
    display_name               = "tf-epg-${var.name_new_app}${random_integer.r_rnd_appid.id}-db"
    bd_name                    = var.infra_bd_name_hybrid_bd
    bd_schema_id               = var.infra_schema_id_hybrid_apps 
    bd_template_name           = var.infra_template_name_onprem 
    vrf_name                   = var.infra_vrf_name_stretch_vrf
    vrf_schema_id              = var.infra_schema_id_hybrid_apps 
    vrf_template_name          = var.infra_template_name_shared
    intersite_multicast_source = false
    intra_epg                  = "unenforced"
    preferred_group            = false
    proxy_arp                  = false
    useg_epg                   = false
}



### CREATE CONTRACTS ###

resource "mso_schema_template_contract" "r_cn_new_app_db" {
    contract_name        = "tf-con-${var.name_new_app}${random_integer.r_rnd_appid.id}-db"
    schema_id            = mso_schema.r_schm_new_app.id
    scope                = "context"
    template_name        = mso_schema_template.r_tmpl_new_app.name  
    directives           = [
        "none",
    ]
    display_name         = "tf-con-${var.name_new_app}${random_integer.r_rnd_appid.id}-db"
    filter_relationships = {
        filter_name          = mso_schema_template_filter_entry.r_flt_new_app_db_3306.name
        filter_schema_id     = mso_schema.r_schm_new_app.id
        filter_template_name = mso_schema_template.r_tmpl_new_app.name
    }
   
}


### CREATE FILTERS ###

resource "mso_schema_template_filter_entry" "r_flt_new_app_db_3306" {
        schema_id = mso_schema.r_schm_new_app.id
        template_name = mso_schema_template.r_tmpl_new_app.name  
        name = "tf-flt-${var.name_new_app}${random_integer.r_rnd_appid.id}-db-3306"
        display_name="tf-flt-${var.name_new_app}${random_integer.r_rnd_appid.id}-db-3306"
        entry_name = "tf-fltent-${var.name_new_app}${random_integer.r_rnd_appid.id}-3306"
        entry_display_name="tf-fltent-${var.name_new_app}${random_integer.r_rnd_appid.id}-3306"
        ether_type = "ip"
        ip_protocol = "tcp"
        destination_from="3306"
        destination_to="3306"
        source_from="unspecified"
        source_to="unspecified"
        arp_flag="unspecified"
}


### EPG CONTRACT RELATIONSHIPS ###

###-------DB 3306----------###
resource "mso_schema_template_anp_epg_contract" "r_epgcn_db_db_p" {
    anp_name               = mso_schema_template_anp.r_anp_new_app.name
    contract_name          = mso_schema_template_contract.r_cn_new_app_db.contract_name
    contract_schema_id     = mso_schema.r_schm_new_app.id
    contract_template_name = mso_schema_template.r_tmpl_new_app.name
    epg_name               = mso_schema_template_anp_epg.r_epg_new_app_db.name
    relationship_type      = "provider"
    schema_id              = mso_schema.r_schm_new_app.id
    template_name          = mso_schema_template.r_tmpl_new_app.name
}

resource "mso_schema_template_anp_epg_contract" "r_epgcn_web_db_c" {
    anp_name               = mso_schema_template_anp.r_anp_new_app.name
    contract_name          = mso_schema_template_contract.r_cn_new_app_db.contract_name
    contract_schema_id     = mso_schema.r_schm_new_app.id
    contract_template_name = mso_schema_template.r_tmpl_new_app.name
    epg_name               = mso_schema_template_anp_epg.r_epg_new_app_web.name
    relationship_type      = "consumer"
    schema_id              = mso_schema.r_schm_new_app.id
    template_name          = mso_schema_template.r_tmpl_new_app.name
}
###-------ICMP----------###
resource "mso_schema_template_anp_epg_contract" "r_epgcn_db_icmp_p" {
    anp_name               = mso_schema_template_anp.r_anp_new_app.name
    contract_name          = var.infra_contract_name_icmp
    contract_schema_id     = var.infra_schema_id_hybrid_apps
    contract_template_name = var.infra_template_name_shared
    epg_name               = mso_schema_template_anp_epg.r_epg_new_app_db.name
    relationship_type      = "provider"
    schema_id              = mso_schema.r_schm_new_app.id
    template_name          = mso_schema_template.r_tmpl_new_app.name
}

resource "mso_schema_template_anp_epg_contract" "r_epgcn_db_icmp_c" {
    anp_name               = mso_schema_template_anp.r_anp_new_app.name
    contract_name          = var.infra_contract_name_icmp
    contract_schema_id     = var.infra_schema_id_hybrid_apps
    contract_template_name = var.infra_template_name_shared
    epg_name               = mso_schema_template_anp_epg.r_epg_new_app_db.name
    relationship_type      = "consumer"
    schema_id              = mso_schema.r_schm_new_app.id
    template_name          = mso_schema_template.r_tmpl_new_app.name
}

resource "mso_schema_template_anp_epg_contract" "r_epgcn_web_icmp_p" {
    anp_name               = mso_schema_template_anp.r_anp_new_app.name
    contract_name          = var.infra_contract_name_icmp
    contract_schema_id     = var.infra_schema_id_hybrid_apps
    contract_template_name = var.infra_template_name_shared
    epg_name               = mso_schema_template_anp_epg.r_epg_new_app_web.name
    relationship_type      = "provider"
    schema_id              = mso_schema.r_schm_new_app.id
    template_name          = mso_schema_template.r_tmpl_new_app.name
}

resource "mso_schema_template_anp_epg_contract" "r_epgcn_web_icmp_c" {
    anp_name               = mso_schema_template_anp.r_anp_new_app.name
    contract_name          = var.infra_contract_name_icmp
    contract_schema_id     = var.infra_schema_id_hybrid_apps
    contract_template_name = var.infra_template_name_shared
    epg_name               = mso_schema_template_anp_epg.r_epg_new_app_web.name
    relationship_type      = "consumer"
    schema_id              = mso_schema.r_schm_new_app.id
    template_name          = mso_schema_template.r_tmpl_new_app.name
}


###-------ONPREM SERVICES----------###

resource "mso_schema_template_anp_epg_contract" "r_epgcn_web_onpremsrv_p" {
    anp_name               = mso_schema_template_anp.r_anp_new_app.name
    contract_name          = var.infra_contract_name_onprem_services
    contract_schema_id     = var.infra_schema_id_hybrid_apps
    contract_template_name = var.infra_template_name_shared
    epg_name               = mso_schema_template_anp_epg.r_epg_new_app_web.name
    relationship_type      = "provider"
    schema_id              = mso_schema.r_schm_new_app.id
    template_name          = mso_schema_template.r_tmpl_new_app.name
}

resource "mso_schema_template_anp_epg_contract" "r_epgcn_db_onpremsrv_p" {
    anp_name               = mso_schema_template_anp.r_anp_new_app.name
    contract_name          = var.infra_contract_name_onprem_services
    contract_schema_id     = var.infra_schema_id_hybrid_apps
    contract_template_name = var.infra_template_name_shared
    epg_name               = mso_schema_template_anp_epg.r_epg_new_app_db.name
    relationship_type      = "provider"
    schema_id              = mso_schema.r_schm_new_app.id
    template_name          = mso_schema_template.r_tmpl_new_app.name
}

###-------INTERNET ACCESS----------###

resource "mso_schema_template_anp_epg_contract" "r_epgcn_web_inetacc_c" {
    anp_name               = mso_schema_template_anp.r_anp_new_app.name
    contract_name          = var.infra_contract_name_inet_access
    contract_schema_id     = var.infra_schema_id_hybrid_apps
    contract_template_name = var.infra_template_name_shared
    epg_name               = mso_schema_template_anp_epg.r_epg_new_app_web.name
    relationship_type      = "consumer"
    schema_id              = mso_schema.r_schm_new_app.id
    template_name          = mso_schema_template.r_tmpl_new_app.name
}

resource "mso_schema_template_anp_epg_contract" "r_epgcn_db_inetacc_c" {
    anp_name               = mso_schema_template_anp.r_anp_new_app.name
    contract_name          = var.infra_contract_name_inet_access
    contract_schema_id     = var.infra_schema_id_hybrid_apps
    contract_template_name = var.infra_template_name_shared
    epg_name               = mso_schema_template_anp_epg.r_epg_new_app_db.name
    relationship_type      = "consumer"
    schema_id              = mso_schema.r_schm_new_app.id
    template_name          = mso_schema_template.r_tmpl_new_app.name
}


###-------WEB PUBLISH----------###

resource "mso_schema_template_anp_epg_contract" "r_epgcn_web_webpub_p" {
    anp_name               = mso_schema_template_anp.r_anp_new_app.name
    contract_name          = var.infra_contract_name_web_publish
    contract_schema_id     = var.infra_schema_id_hybrid_apps
    contract_template_name = var.infra_template_name_shared
    epg_name               = mso_schema_template_anp_epg.r_epg_new_app_web.name
    relationship_type      = "provider"
    schema_id              = mso_schema.r_schm_new_app.id
    template_name          = mso_schema_template.r_tmpl_new_app.name
}



############## SITE-LOCAL CONFIGURATION ###################

### CREATE AND ASSIGN VMM dOMAIN TO EPG ###

resource "mso_schema_site_anp_epg_domain" "r_epgvmm_web_lon_60" {
    allow_micro_segmentation = false
    anp_name                 = mso_schema_template_anp.r_anp_new_app.name
    dn                       = var.infra_vmm_domain_name_vm60
    domain_type              = "vmmDomain"
    epg_name                 = mso_schema_template_anp_epg.r_epg_new_app_web.name
    resolution_immediacy     = "immediate"
    schema_id                = mso_schema.r_schm_new_app.id 
    site_id                  = var.infra_site_id_dcloud_lon
    switch_type              = "default"
    switching_mode           = "native"
    template_name            = mso_schema_template.r_tmpl_new_app.name
    vlan_encap_mode          = "dynamic"
    deploy_immediacy         = "immediate"
    depends_on = [mso_schema_site.r_schema_site_new_app_lon,
  ]
}


resource "mso_schema_site_anp_epg_domain" "r_epgvmm_db_lon_60" {
    allow_micro_segmentation = false
    anp_name                 = mso_schema_template_anp.r_anp_new_app.name
    dn                       = var.infra_vmm_domain_name_vm60
    domain_type              = "vmmDomain"
    epg_name                 = mso_schema_template_anp_epg.r_epg_new_app_db.name
    resolution_immediacy     = "immediate"
    schema_id                = mso_schema.r_schm_new_app.id
    site_id                  = var.infra_site_id_dcloud_lon
    switch_type              = "default"
    switching_mode           = "native"
    template_name            = mso_schema_template.r_tmpl_new_app.name
    vlan_encap_mode          = "dynamic"
    deploy_immediacy         = "immediate"
    depends_on = [mso_schema_site.r_schema_site_new_app_lon,
  ]
}


resource "mso_schema_template_deploy" "r_deploy_tmpl_to_sites" {
  schema_id = mso_schema.r_schm_new_app.id
  template_name = mso_schema_template.r_tmpl_new_app.name
  undeploy = false
  depends_on = [
                mso_schema.r_schm_new_app,
                mso_schema_site.r_schema_site_new_app_aws,
                mso_schema_site.r_schema_site_new_app_lon,
                mso_schema_site_anp_epg_domain.r_epgvmm_db_lon_60,
                mso_schema_site_anp_epg_domain.r_epgvmm_web_lon_60,
                mso_schema_template.r_tmpl_new_app,
                mso_schema_template_anp.r_anp_new_app,
                mso_schema_template_anp_epg.r_epg_new_app_db,
                mso_schema_template_anp_epg.r_epg_new_app_web,
                mso_schema_template_anp_epg_selector.r_epgsel_new_app_web,
                mso_schema_template_contract.r_cn_new_app_db,
                mso_schema_template_filter_entry.r_flt_new_app_db_3306,
                mso_schema_template_anp_epg_contract.r_epgcn_db_db_p,
                mso_schema_template_anp_epg_contract.r_epgcn_db_icmp_c,
                mso_schema_template_anp_epg_contract.r_epgcn_db_icmp_p,
                mso_schema_template_anp_epg_contract.r_epgcn_db_inetacc_c,
                mso_schema_template_anp_epg_contract.r_epgcn_db_onpremsrv_p,
                mso_schema_template_anp_epg_contract.r_epgcn_web_db_c,
                mso_schema_template_anp_epg_contract.r_epgcn_web_icmp_c,
                mso_schema_template_anp_epg_contract.r_epgcn_web_icmp_p,
                mso_schema_template_anp_epg_contract.r_epgcn_web_inetacc_c,
                mso_schema_template_anp_epg_contract.r_epgcn_web_onpremsrv_p,
                mso_schema_template_anp_epg_contract.r_epgcn_web_webpub_p,
  ]
}
