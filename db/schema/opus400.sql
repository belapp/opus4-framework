SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `opus400` ;
USE `opus400`;

-- -----------------------------------------------------
-- Table `opus400`.`documents`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`documents` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key.' ,
  `range_id` INT NULL COMMENT 'Foreign key: ?.? .' ,
  `completed_date` DATE NULL COMMENT 'Date of completion of the publication.' ,
  `completed_year` YEAR NOT NULL COMMENT 'Year of completion of the publication, if the \"completeted_date\" (exact date) is unknown.' ,
  `contributing_corporation` TEXT NULL COMMENT 'Contribution corporate body.' ,
  `creating_corporation` TEXT NULL COMMENT 'Creating corporate body.' ,
  `date_accepted` DATE NULL COMMENT 'Date of final exam (date of the doctoral graduation).' ,
  `type` VARCHAR(100) NOT NULL COMMENT 'Document type.' ,
  `edition` VARCHAR(25) NULL COMMENT 'Edition.' ,
  `issue` VARCHAR(25) NULL COMMENT 'Issue.' ,
  `language` VARCHAR(255) NULL COMMENT 'Language(s) of the document.' ,
  `non_institute_affiliation` TEXT NULL COMMENT 'Institutions, which are not officialy part of the university.' ,
  `page_first` INT NULL COMMENT 'First page of a publication.' ,
  `page_last` INT NULL COMMENT 'Last page of a pbulication.' ,
  `page_number` INT NULL COMMENT 'Total page numbers.' ,
  `publication_state` ENUM('published', 'unpublished','deleted') NOT NULL COMMENT 'Status of publication prozess in the repository.' ,
  `published_date` DATE NULL COMMENT 'Exact date of publication. Could differ from \"server_date_published\".' ,
  `published_year` YEAR NULL COMMENT 'Year of the publication, if the \"published_date\" (exact date) is unknown.  Could differ from \"server_date_published\".' ,
  `publisher_name` VARCHAR(255) NOT NULL COMMENT 'Name of an external publisher' ,
  `publisher_place` VARCHAR(255) NULL COMMENT 'City/State of extern. publisher' ,
  `publisher_university` VARCHAR(255) NULL COMMENT 'Name of ext. publishing university' ,
  `reviewed` ENUM('peer', 'editorial', 'open') NOT NULL COMMENT 'Style of the review process.' ,
  `server_date_modified` DATETIME NULL COMMENT 'Last modification of the document (is generated by the system).' ,
  `server_date_published` DATETIME NOT NULL COMMENT 'Date of publication on the repository (is generated by the system).' ,
  `server_date_unlocking` DATE NULL COMMENT 'Expiration date of a embargo.' ,
  `server_date_valid` DATE NULL COMMENT 'Expiration date of the validity of the document.' ,
  `source` VARCHAR(255) NULL COMMENT 'Bibliographic date from OPUS 3.x (formerly in OPUS 3.x \"source_text\").' ,
  `swb_id` VARCHAR(255) NULL COMMENT 'Identification number of the online union catalogue of the Cataloguing Union\nin South-Western Germany (SWB).' ,
  `volume` VARCHAR(25) NULL COMMENT 'Volume.' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Document related data (monolingual, unreproducible colums).'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`document_identifiers`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`document_identifiers` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key.' ,
  `document_id` INT UNSIGNED NOT NULL COMMENT 'Foreign key to: documents.documents_id.' ,
  `type` ENUM('doi', 'handle', 'urn', 'std-doi', 'url', 'cris-link', 'splash-url', 'isbn', 'issn') NOT NULL COMMENT 'Type of the identifier.' ,
  `value` TEXT NOT NULL COMMENT 'Value of the identifier.' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_document_identifiers_documents` (`document_id` ASC) ,
  CONSTRAINT `fk_document_identifiers_documents`
    FOREIGN KEY (`document_id` )
    REFERENCES `opus400`.`documents` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Table for identifiers  related to the document.'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`institutes_contents`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`institutes_contents` (
  `id` INT UNSIGNED NOT NULL COMMENT 'Primary key.' ,
  `type` VARCHAR(50) NOT NULL COMMENT 'Type of institute.' ,
  `name` VARCHAR(255) NOT NULL COMMENT 'Name or description of the institute.' ,
  `postal_address` TEXT NULL COMMENT 'Postal address.' ,
  `site` TEXT NULL COMMENT 'URI to the website of the institute.' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = '(Relation) table for insitute related data.'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`document_files`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`document_files` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key.' ,
  `document_id` INT UNSIGNED NULL COMMENT 'Foreign key to: documents.documents_id.' ,
  `path_name` TEXT NOT NULL COMMENT 'File and path name.' ,
  `sort_order` TINYINT(4) NOT NULL COMMENT 'Order of the files.' ,
  `label` TEXT NOT NULL COMMENT 'Display text of the file.' ,
  `file_type` VARCHAR(255) NOT NULL COMMENT 'Filetype according to dublin core.' ,
  `mime_type` VARCHAR(255) NOT NULL COMMENT 'Mime type of the file.' ,
  `language` VARCHAR(3) NULL COMMENT 'Language of the file.' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_document_files_documents` (`document_id` ASC) ,
  CONSTRAINT `fk_document_files_documents`
    FOREIGN KEY (`document_id` )
    REFERENCES `opus400`.`documents` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Table for file related data.'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`file_hashvalues`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`file_hashvalues` (
  `file_id` INT UNSIGNED NOT NULL ,
  `type` VARCHAR(50) NOT NULL COMMENT 'Type of the hash value.' ,
  `value` TEXT NOT NULL COMMENT 'Hash value.' ,
  PRIMARY KEY (`type`, `file_id`) ,
  INDEX `fk_file_hashvalues_document_files` (`file_id` ASC) ,
  CONSTRAINT `fk_file_hashvalues_document_files`
    FOREIGN KEY (`file_id` )
    REFERENCES `opus400`.`document_files` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Table for hash values.'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`document_subjects`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`document_subjects` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key.' ,
  `document_id` INT UNSIGNED NULL COMMENT 'Foreign key to: documents.documents_id.' ,
  `language` VARCHAR(3) NULL COMMENT 'Language of the subject heading.' ,
  `type` ENUM('swd', 'psyndex', 'uncontrolled') NOT NULL COMMENT 'Subject type, i. e. a specific authority file.' ,
  `value` VARCHAR(255) NOT NULL COMMENT 'Value of the subject heading, i. e. text, notation etc.' ,
  `external_key` VARCHAR(255) NULL COMMENT 'Identifier for linking the subject heading to external systems such as authority files.' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_document_subjects_documents` (`document_id` ASC) ,
  CONSTRAINT `fk_document_subjects_documents`
    FOREIGN KEY (`document_id` )
    REFERENCES `opus400`.`documents` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Table for subject heading related data.'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`document_title_abstracts`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`document_title_abstracts` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key.' ,
  `document_id` INT UNSIGNED NULL COMMENT 'Foreign key to: documents.documents_id.' ,
  `type` ENUM('main', 'parent', 'abstract') NOT NULL COMMENT 'Type of title or abstract.' ,
  `value` TEXT NOT NULL COMMENT 'Value of title or abstract.' ,
  `language` VARCHAR(3) NOT NULL COMMENT 'Language of the title or abstract.' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_document_title_abstracts_documents` (`document_id` ASC) ,
  CONSTRAINT `fk_document_title_abstracts_documents`
    FOREIGN KEY (`document_id` )
    REFERENCES `opus400`.`documents` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Table with title and abstract related data.'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`persons`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`persons` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key.' ,
  `academic_title` VARCHAR(255) NULL COMMENT 'Academic title.' ,
  `date_of_birth` DATETIME NULL COMMENT 'Date of birth.' ,
  `email` VARCHAR(100) NULL COMMENT 'E-mail address.' ,
  `first_name` VARCHAR(255) NULL COMMENT 'First name.' ,
  `last_name` VARCHAR(255) NOT NULL COMMENT 'Last name.' ,
  `place_of_birth` VARCHAR(255) NULL COMMENT 'Place of birth.' ,
  PRIMARY KEY (`id`) ,
  INDEX `last_name` (`last_name` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Person related data.'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`person_external_keys`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`person_external_keys` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key.' ,
  `person_id` INT UNSIGNED NULL COMMENT 'Foreign key to: persons.persons_id.' ,
  `type` ENUM('pnd') NOT NULL COMMENT 'Type of the external identifer, i. e. PND-Number (Personennormdatei).' ,
  `value` TEXT NOT NULL COMMENT 'Value of the external identifier.' ,
  `resolver` VARCHAR(255) NULL COMMENT 'URI to external resolving machanism for this identifier type.' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_person_external_keys_persons` (`person_id` ASC) ,
  CONSTRAINT `fk_person_external_keys_persons`
    FOREIGN KEY (`person_id` )
    REFERENCES `opus400`.`persons` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Table for external identifiers related to a person.'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`link_persons_documents`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`link_persons_documents` (
  `person_id` INT UNSIGNED NOT NULL COMMENT 'Primary key and foreign key to: persons.persons_id.' ,
  `document_id` INT UNSIGNED NOT NULL COMMENT 'Primary key and foreign key to: documents.documents_id.' ,
  `institute_id` INT UNSIGNED NULL COMMENT 'Foreign key to: institutes_contents.institutes_id.' ,
  `role` ENUM('advisor', 'author', 'contributor', 'editor', 'referee',  'other', 'translator') NOT NULL COMMENT 'Role of the person in the actual document-person context.' ,
  `sort_order` TINYINT UNSIGNED NOT NULL COMMENT 'Sort order of the persons related to the document.' ,
  `allow_email_contact` BOOLEAN NOT NULL DEFAULT 0 COMMENT 'Is e-mail contact in the actual document-person context allowed? (1=yes, 0=no).' ,
  INDEX `fk_link_documents_persons_persons` (`person_id` ASC) ,
  PRIMARY KEY (`person_id`, `document_id`) ,
  INDEX `fk_link_persons_publications_institutes_contents` (`institute_id` ASC) ,
  INDEX `fk_link_persons_documents_documents` (`document_id` ASC) ,
  CONSTRAINT `fk_link_documents_persons_persons`
    FOREIGN KEY (`person_id` )
    REFERENCES `opus400`.`persons` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_link_persons_publications_institutes_contents`
    FOREIGN KEY (`institute_id` )
    REFERENCES `opus400`.`institutes_contents` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_link_persons_documents_documents`
    FOREIGN KEY (`document_id` )
    REFERENCES `opus400`.`documents` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Relation table (documents, persons, institutes_contents).'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`document_patents`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`document_patents` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key.' ,
  `document_id` INT UNSIGNED NOT NULL COMMENT 'Foreign key to: documents.documents_id.' ,
  `countries` TEXT NOT NULL COMMENT 'Countries in which the patent was granted.' ,
  `date_granted` DATE NOT NULL COMMENT 'Date when the patent was granted.' ,
  `number` VARCHAR(255) NOT NULL COMMENT 'Patent number / Publication number.' ,
  `year_applied` YEAR NOT NULL COMMENT 'Year of the application.' ,
  `application` TEXT NOT NULL COMMENT 'Description of the patent.' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_patent_information_document` (`document_id` ASC) ,
  CONSTRAINT `fk_patent_information_document`
    FOREIGN KEY (`document_id` )
    REFERENCES `opus400`.`documents` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Table for patent related data.'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`document_statistics`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`document_statistics` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key.' ,
  `document_id` INT UNSIGNED NOT NULL COMMENT 'Foreign key to: documents.documents_id.' ,
  `type` TEXT NOT NULL COMMENT 'Type of the statistic.' ,
  `value` TEXT NOT NULL COMMENT 'Value of the statistic.' ,
  `start_survey_period` DATETIME NOT NULL COMMENT 'Time and date of the beginning of the survey period.' ,
  `end_survey_period` DATETIME NOT NULL COMMENT 'Time and date of the ending of the survey period.' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_document_statistics_Document` (`document_id` ASC) ,
  CONSTRAINT `fk_document_statistics_Document`
    FOREIGN KEY (`document_id` )
    REFERENCES `opus400`.`documents` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Table for statistic related data.'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`document_notes`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`document_notes` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key.' ,
  `document_id` INT UNSIGNED NOT NULL COMMENT 'Foreign key to: documents.documents_id.' ,
  `message` TEXT NOT NULL COMMENT 'Message text.' ,
  `creator` TEXT NOT NULL COMMENT 'Crator of the message.' ,
  `scope` ENUM('private', 'public', 'reference') NOT NULL COMMENT 'Visibility: private, public, reference to another document version.' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_document_notes_document` (`document_id` ASC) ,
  CONSTRAINT `fk_document_notes_document`
    FOREIGN KEY (`document_id` )
    REFERENCES `opus400`.`documents` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Table for notes to documents.'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`type_enrichments`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`type_enrichments` (
  `id` INT UNSIGNED NOT NULL ,
  `name` VARCHAR(100) NOT NULL ,
  `type` VARCHAR(100) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `opus400`.`document_enrichments`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`document_enrichments` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key.' ,
  `type_enrichment_id` INT UNSIGNED NOT NULL ,
  `document_id` INT UNSIGNED NOT NULL COMMENT 'Foreign key to: documents.documents_id.' ,
  `value` TEXT NOT NULL COMMENT 'Value of the enrichment.' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_document_enrichment_document` (`document_id` ASC) ,
  INDEX `fk_document_enrichments_type_enrichments` (`type_enrichment_id` ASC) ,
  CONSTRAINT `fk_document_enrichment_document`
    FOREIGN KEY (`document_id` )
    REFERENCES `opus400`.`documents` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_document_enrichments_type_enrichments`
    FOREIGN KEY (`type_enrichment_id` )
    REFERENCES `opus400`.`type_enrichments` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Key-value table for database scheme enhancements.'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`document_licences`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`document_licences` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key.' ,
  `active` TINYINT NOT NULL COMMENT 'Flag: can authors choose this licence (0=no, 1=yes)?' ,
  `comment_internal` MEDIUMTEXT NULL COMMENT 'Internal comment.' ,
  `desc_markup` MEDIUMTEXT NULL COMMENT 'Description of the licence in a markup language (XHTML etc.).' ,
  `desc_text` MEDIUMTEXT NULL COMMENT 'Description of the licence in short and pure text form.' ,
  `language` VARCHAR(3) NOT NULL COMMENT 'Language of the licence.' ,
  `link_licence` MEDIUMTEXT NOT NULL COMMENT 'URI of the licence text.' ,
  `link_logo` MEDIUMTEXT NULL COMMENT 'URI of the licence logo.' ,
  `link_sign` MEDIUMTEXT NULL COMMENT 'URI of the licence contract form.' ,
  `mime_type` VARCHAR(30) NOT NULL COMMENT 'Mime type of the licence text linked in \"link_licence\".' ,
  `name_long` VARCHAR(255) NOT NULL COMMENT 'Full name of the licence as displayed to users.' ,
  `pod_allowed` TINYINT(1) NOT NULL COMMENT 'Flag: is print on demand allowed. (1=yes, 0=yes).' ,
  `sort_order` TINYINT NOT NULL COMMENT 'Sort order (00 to 99).' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Table for licence related data.'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`institutes_structure`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`institutes_structure` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key.' ,
  `institutes_id` INT UNSIGNED NOT NULL COMMENT 'Foreign key to: institutes_contents.institutes_id.' ,
  `left` INT UNSIGNED NOT NULL COMMENT 'The left value of the nested set node.' ,
  `right` INT UNSIGNED NOT NULL COMMENT 'The right value of the nested set node.' ,
  `visible` TINYINT NOT NULL COMMENT 'Is the institute visible? (1=yes, 0=no).' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_institutes_structure_institutes_contents` (`institutes_id` ASC) ,
  CONSTRAINT `fk_institutes_structure_institutes_contents`
    FOREIGN KEY (`institutes_id` )
    REFERENCES `opus400`.`institutes_contents` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Table for the structure of the institutes hierarchy.'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`institutes_replacement`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`institutes_replacement` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key.' ,
  `institutes_id` INT UNSIGNED NOT NULL COMMENT 'Foreign key to: institutes_contents.institutes_id. Reference to actual displayed/processed institute.' ,
  `replacement_for_id` INT UNSIGNED NULL COMMENT 'Foreign key to: institutes_contents.institutes_id. Reference to replaced institute.' ,
  `replacement_by_id` INT UNSIGNED NULL COMMENT 'Foreign key to: institutes_contents.institutes_id. Reference to replacing institute.' ,
  `current_replacement_id` INT UNSIGNED NULL COMMENT 'Foreign key to: institutes_contents.institutes_id. Reference to direct succeeding institute.' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_link_institute` (`institutes_id` ASC) ,
  INDEX `fk_link_institute_replacement_for` (`replacement_for_id` ASC) ,
  INDEX `fk_link_institute_replacement_by` (`replacement_by_id` ASC) ,
  INDEX `fk_link_institute_current_replacement` (`current_replacement_id` ASC) ,
  CONSTRAINT `fk_link_institute`
    FOREIGN KEY (`institutes_id` )
    REFERENCES `opus400`.`institutes_contents` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_link_institute_replacement_for`
    FOREIGN KEY (`replacement_for_id` )
    REFERENCES `opus400`.`institutes_contents` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_link_institute_replacement_by`
    FOREIGN KEY (`replacement_by_id` )
    REFERENCES `opus400`.`institutes_contents` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_link_institute_current_replacement`
    FOREIGN KEY (`current_replacement_id` )
    REFERENCES `opus400`.`institutes_contents` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Table for the institutes history related data.'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`accounts`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`accounts` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key.' ,
  `login` VARCHAR(45) NOT NULL COMMENT 'Login name.' ,
  `password` VARCHAR(45) NOT NULL COMMENT 'Password.' ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UNIQUE_LOGIN` (`login` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Table for system user accounts.';


-- -----------------------------------------------------
-- Table `opus400`.`collections_roles`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`collections_roles` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key.' ,
  `name` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_general_ci' NOT NULL COMMENT 'Name, label or type of the collection role, i.e. a specific classification or conference.' ,
  `position` INT(11) UNSIGNED NOT NULL COMMENT 'Position of this collection tree (role) in the sorted list of collection roles for browsing and administration.' ,
  `link_docs_path_to_root` TINYINT(1) UNSIGNED NOT NULL COMMENT 'If not 0: Every document belonging to a collection C automatically belongs to every collection on the path from C to the root of the collection tree.' ,
  `visible` TINYINT(1) UNSIGNED NOT NULL COMMENT 'Is the collection visible? (1=yes, 0=no).' ,
  `display_browsing` VARCHAR(512) NULL ,
  `display_doclist` VARCHAR(512) NULL ,
  `display_col_front` VARCHAR(512) NULL ,
  `display_frontdoor` VARCHAR(512) NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UNIQUE_NAME` (`name` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Administration table for the indivdual collection trees.';


-- -----------------------------------------------------
-- Table `opus400`.`link_documents_licences`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`link_documents_licences` (
  `document_id` INT UNSIGNED NOT NULL COMMENT 'Primary key and foreign key to: documents.documents_id.' ,
  `licence_id` INT UNSIGNED NOT NULL COMMENT 'Primary key and foreign key to: licences.licences_id.' ,
  PRIMARY KEY (`document_id`, `licence_id`) ,
  INDEX `fk_documents_has_document_licences_documents` (`document_id` ASC) ,
  INDEX `fk_documents_has_document_licences_document_licences` (`licence_id` ASC) ,
  CONSTRAINT `fk_documents_has_document_licences_documents`
    FOREIGN KEY (`document_id` )
    REFERENCES `opus400`.`documents` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_documents_has_document_licences_document_licences`
    FOREIGN KEY (`licence_id` )
    REFERENCES `opus400`.`document_licences` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Relation table (documents, document_licences).'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`link_institutes_documents`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`link_institutes_documents` (
  `institute_id` INT UNSIGNED NOT NULL COMMENT 'Primary key and foreign key to: institutes_contents.institutes_id.' ,
  `document_id` INT UNSIGNED NOT NULL COMMENT 'Primary key and foreign key to: documents.documents_id.' ,
  `role` ENUM('publisher','creator','other') NOT NULL COMMENT 'Role of the institute in the actual institute-document context.' ,
  PRIMARY KEY (`institute_id`, `document_id`) ,
  INDEX `fk_institutes_contents_has_documents_institutes_contents` (`institute_id` ASC) ,
  INDEX `fk_institutes_contents_has_documents_documents` (`document_id` ASC) ,
  CONSTRAINT `fk_institutes_contents_has_documents_institutes_contents`
    FOREIGN KEY (`institute_id` )
    REFERENCES `opus400`.`institutes_contents` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_institutes_contents_has_documents_documents`
    FOREIGN KEY (`document_id` )
    REFERENCES `opus400`.`documents` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Relation table (documents, institutes_contents).'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`document_references`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`document_references` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key.' ,
  `document_id` INT UNSIGNED NOT NULL COMMENT 'Foreign key to referencing document.' ,
  `type` ENUM('doi', 'handle', 'urn', 'std-doi', 'url', 'cris-link', 'splash-url', 'isbn', 'issn') NOT NULL COMMENT 'Type of the identifier.' ,
  `value` TEXT NOT NULL COMMENT 'Value of the identifier.' ,
  `label` TEXT NOT NULL COMMENT 'Display text of the identifier.' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_document_references_documents` (`document_id` ASC) ,
  CONSTRAINT `fk_document_references_documents`
    FOREIGN KEY (`document_id` )
    REFERENCES `opus400`.`documents` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Table for identifiers referencing to related documents.'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`link_metadocument_collection`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`link_metadocument_collection` (
  `content_id` INT(11) UNSIGNED NOT NULL COMMENT 'Primary key of a specific collection' ,
  `role_id` INT(11) UNSIGNED NOT NULL COMMENT 'Primary key of a specific role' ,
  `document_id` INT UNSIGNED NOT NULL COMMENT 'Primary key of a document' ,
  PRIMARY KEY (`content_id`, `role_id`) ,
  INDEX `fk_link_documents_collection_documents` (`document_id` ASC) ,
  CONSTRAINT `fk_link_documents_collection_documents`
    FOREIGN KEY (`document_id` )
    REFERENCES `opus400`.`documents` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'Reference to a metadata document for a collection.'
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`configurations`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`configurations` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL ,
  `theme` VARCHAR(45) NULL DEFAULT 'default' ,
  `site_name` VARCHAR(255) NULL ,
  `admin_email` VARCHAR(255) NULL ,
  `smtp_server_host` VARCHAR(255) NULL ,
  `smtp_server_login` VARCHAR(45) NULL ,
  `smtp_server_password` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`roles`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`roles` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `parent` INT UNSIGNED NULL ,
  `name` VARCHAR(255) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_roles_roles` (`parent` ASC) ,
  CONSTRAINT `fk_roles_roles`
    FOREIGN KEY (`parent` )
    REFERENCES `opus400`.`roles` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `opus400`.`privileges`
-- 
-- The columns role_id, privilege and resource may be changed to allow NULL.
-- Zend_Acl uses null to define default rules.
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`privileges` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` INT UNSIGNED NOT NULL ,
  `privilege` VARCHAR(15) NOT NULL ,
  `resource` VARCHAR(255) NOT NULL ,
  `granted` TINYINT NOT NULL COMMENT 'Flag: is the privilege allowed or disallowed? (0=disallowed, 1=allowed)?' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_privileges_roles` (`role_id` ASC) ,
  CONSTRAINT `fk_privileges_roles`
    FOREIGN KEY (`role_id` )
    REFERENCES `opus400`.`roles` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `opus400`.`link_accounts_roles`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`link_accounts_roles` (
  `account_id` INT UNSIGNED NOT NULL ,
  `role_id` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`account_id`, `role_id`) ,
  INDEX `fk_accounts_has_roles_accounts` (`account_id` ASC) ,
  INDEX `fk_accounts_has_roles_roles` (`role_id` ASC) ,
  CONSTRAINT `fk_accounts_has_roles_accounts`
    FOREIGN KEY (`account_id` )
    REFERENCES `opus400`.`accounts` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_accounts_has_roles_roles`
    FOREIGN KEY (`role_id` )
    REFERENCES `opus400`.`roles` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


-- -----------------------------------------------------
-- Table `opus400`.`translations`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opus400`.`translations` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `context` VARCHAR(15) NOT NULL,
    `locale` VARCHAR(10) NOT NULL,    
    `translation_key` VARCHAR(15) NOT NULL,
    `translation_msg` VARCHAR(15) NOT NULL,    
    PRIMARY KEY (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
PACK_KEYS = 0
ROW_FORMAT = DEFAULT;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
