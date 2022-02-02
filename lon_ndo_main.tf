### GENERATE RANDOM STRING ###
resource "random_integer" "r_rnd_appid" {
  min    = 0
  max    = 1
}

### CREATE SCHEMA ###
resource "mso_schema" "r_schm_new_app" {
    name          = "tf-schema-${var.name_new_app}${random_integer.r_rnd_appid.id}"
    template_name = "tf-tmpl-service(DoNotUse)"
    tenant_id     = var.infra_tenant_id_hybrid_tn1
}

### CREATE TEMPLATE ###
resource "mso_schema_template" "r_tmpl_new_app" {
    name         = "tf-tmpl-${var.name_new_app}${random_integer.r_rnd_appid.id}"
    display_name = "tf-tmpl-${var.name_new_app}${random_integer.r_rnd_appid.id}"
    schema_id    = mso_schema.r_schm_new_app.id
    tenant_id    = var.infra_tenant_id_hybrid_tn1
}


### ASSIGN SITES TO TEMPLATES ###
resource "mso_schema_site" "r_schema_site_new_app_lon" {
    schema_id     = mso_schema.r_schm_new_app.id
    template_name = mso_schema_template.r_tmpl_new_app.name
    site_id       = var.infra_site_id_dcloud_lon
}

resource "mso_schema_site" "r_schema_site_new_app_aws" {
    schema_id     = mso_schema.r_schm_new_app.id
    template_name = mso_schema_template.r_tmpl_new_app.name
    site_id       = var.infra_site_id_dcloud_aws
    depends_on =  [ mso_schema_site.r_schema_site_new_app_lon, ]
}
