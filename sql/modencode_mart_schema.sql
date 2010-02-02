CREATE TABLE transfac__transcriptional_factor__main (
       tf_id_key	int(5) unsigned NOT NULL AUTO_INCREMENT,
       species		varchar(64) NOT NULL,
       gene_id		varchar(20) NOT NULL,
       public_name	varchar(20) NOT NULL,
       tf_chromosome_name	    varchar(10) NOT NULL,
       tf_chromosome_start	    int(20) unsigned NOT NULL,
       tf_chromosome_end	    int(20) unsigned NOT NULL,
       tf_chromosome_strand	    char(1) NOT NULL,
       concise_description	    text DEFAULT NULL,
       PRIMARY KEY (tf_id_key)        
);

CREATE TABLE transfac__binding_sites__main (
       tf_id_key        int(5) unsigned NOT NULL,
       bs_id_key        int(20) unsigned NOT NULL AUTO_INCREMENT,
       bs_id            int(10) unsigned NOT NULL,
       bs_chromosome_name       varchar(10) NOT NULL,
       bs_chromosome_start      int(20) unsigned NOT NULL,
       bs_chromosome_end        int(20) unsigned NOT NULL,
       bs_chromosome_strand     char(1) NOT NULL, 
       q_value          float NOT NULL,
       bs_sequence      blob,
       PRIMARY KEY (bs_id_key),
       FOREIGN KEY (tf_id_key) REFERENCES transfac__transcriptional_factor__main (tf_id_key) ON DELETE CASCADE
);

CREATE TABLE transfac__binding_sites_genes__dm (
       bs_gene_id       int(20) unsigned NOT NULL AUTO_INCREMENT,
       bs_id_key        int(20) unsigned NOT NULL,
       gene_id          varchar(20) NOT NULL,
       relative_position        int(1) signed,
       distance         int(20) unsigned NOT NULL,
       PRIMARY KEY (bs_gene_id),
       FOREIGN KEY (bs_id_key) REFERENCES transfac__binding_sites__main (bs_id_key) ON DELETE CASCADE
);

CREATE TABLE transfac__antibody__dm (
       tf_antibody_id   int(20) unsigned NOT NULL AUTO_INCREMENT,
       tf_id_key        int(5) unsigned NOT NULL,
       antibody_id      int(5) unsigned,
       official_name    varchar(64),
       short_name       varchar(64),
       target_species   varchar(64),
       target_id        varchar(64),
       target_public_name       varchar(64),
       host_species     varchar(64),
       purified         boolean,
       monoclonal       boolean,
       contribute_lab   varchar(32),
       wiki_perma_url   varchar(64),
       PRIMARY KEY (tf_antibody_id),
       FOREIGN KEY (tf_id_key) REFERENCES transfac__transcriptional_factor__main (tf_id_key) ON DELETE CASCADE
);

CREATE TABLE transfac__strain__dm (
       tf_strain_id   int(20) unsigned NOT NULL AUTO_INCREMENT,
       tf_id_key        int(5) unsigned NOT NULL,
       strain_id        int(5) unsigned,
       official_name    varchar(64),
       short_name       varchar(64),
       species          varchar(64),
       genotype         varchar(200),
       trangenic_type   varchar(200),
       tag              varchar(64),
       contribute_lab   varchar(32),
       wiki_perma_url   varchar(64),
       PRIMARY KEY (tf_strain_id),
       FOREIGN KEY (tf_id_key) REFERENCES transfac__transcriptional_factor__main (tf_id_key) ON DELETE CASCADE
);

CREATE TABLE transfac__developmental_stage__dm (
       tf_devstage_id   int(20) unsigned NOT NULL AUTO_INCREMENT,
       tf_id_key        int(5) unsigned NOT NULL,
       official_name    varchar(64),
       short_name       varchar(64),
       species          varchar(64),
       sex              varchar(20),
       ontology_name    blob,
       wiki_perma_url   varchar(64),
       PRIMARY KEY (tf_devstage_id),
       FOREIGN KEY (tf_id_key) REFERENCES transfac__transcriptional_factor__main (tf_id_key) ON DELETE CASCADE
);

CREATE TABLE transfac__cellline__dm (
       tf_cellline_id   int(20) unsigned NOT NULL AUTO_INCREMENT,
       tf_id_key        int(5) unsigned NOT NULL,
       official_name    varchar(64),
       short_name       varchar(64),
       species          varchar(64),
       genotype         varchar(200),
       sex              varchar(20),
       tissue_ontology_name     blob,
       cell_type        varchar(50),
       developmental_stage_ontology_name     blob,
       contribute_lab   varchar(32),
       wiki_perma_url   varchar(64),
       PRIMARY KEY (tf_cellline_id),
       FOREIGN KEY (tf_id_key) REFERENCES transfac__transcriptional_factor__main (tf_id_key) ON DELETE CASCADE
);

CREATE TABLE transfac__tissue__dm (
       tf_tissue_id   int(20) unsigned NOT NULL AUTO_INCREMENT,
       tf_id_key        int(5) unsigned NOT NULL,
       official_name    varchar(64),
       short_name       varchar(64),
       species          varchar(64),
       sex              varchar(20),
       ontology_name    blob,
       contribute_lab   varchar(32),
       wiki_perma_url   varchar(64),
       PRIMARY KEY (tf_tissue_id),                                       
       FOREIGN KEY (tf_id_key) REFERENCES transfac__transcriptional_factor__main (tf_id_key) ON DELETE CASCADE
);
