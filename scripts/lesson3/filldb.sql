CREATE TABLE IF NOT EXISTS `user` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(245) NOT NULL,
  `phone` BIGINT(13) UNSIGNED NOT NULL,
  `password_hash` CHAR(65) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE NOW(),
  `deleted_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `profile` (
  `user_id` INT(10) UNSIGNED NOT NULL,
  `firstname` VARCHAR(245) NOT NULL,
  `lastname` VARCHAR(245) NOT NULL,
  `gender` ENUM('m', 'f', 'x') NOT NULL,
  `birhday` DATE NOT NULL,
  `address` VARCHAR(245) NULL DEFAULT NULL,
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE NOW(),
  `photo_id` INT(10) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  INDEX `firstname_lastname_idx` (`lastname` ASC, `firstname` ASC),
  INDEX `media_idx` (`photo_id` ASC),
  CONSTRAINT `fk_profile_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_profile_media1`
    FOREIGN KEY (`photo_id`)
    REFERENCES `media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `message` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `from_user_id` INT(10) UNSIGNED NOT NULL,
  `to_user_id` INT(10) UNSIGNED NOT NULL,
  `text` TEXT NULL DEFAULT NULL,
  `media_id` INT(10) UNSIGNED NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `read_at` DATETIME NULL DEFAULT NULL,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `from_user_idx` (`from_user_id` ASC),
  INDEX `to_user_idx` (`to_user_id` ASC),
  INDEX `media_idx` (`media_id` ASC),
  CONSTRAINT `fk_mesage_profile1`
    FOREIGN KEY (`from_user_id`)
    REFERENCES `profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_mesage_profile2`
    FOREIGN KEY (`to_user_id`)
    REFERENCES `profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_message_media1`
    FOREIGN KEY (`media_id`)
    REFERENCES `media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `friend_request` (
  `from_user_id` INT(10) UNSIGNED NOT NULL,
  `to_user_id` INT(10) UNSIGNED NOT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '-1 - отклонён; 0 - запрос; 1 - дружба',
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE NOW(),
  INDEX `from_user_idx` (`from_user_id` ASC),
  INDEX `to_user_idx` (`to_user_id` ASC),
  PRIMARY KEY (`from_user_id`, `to_user_id`),
  CONSTRAINT `fk_friend_request_profile1`
    FOREIGN KEY (`from_user_id`)
    REFERENCES `profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_friend_request_profile2`
    FOREIGN KEY (`to_user_id`)
    REFERENCES `profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `community` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `admin_id` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `admin_idx` (`admin_id` ASC),
  CONSTRAINT `fk_community_profile1`
    FOREIGN KEY (`admin_id`)
    REFERENCES `profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `user_community` (
  `community_id` INT(10) UNSIGNED NOT NULL,
  `user_id` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`community_id`, `user_id`),
  INDEX `user_idx` (`user_id` ASC),
  INDEX `community_idx` (`community_id` ASC),
  CONSTRAINT `fk_community_has_profile_community1`
    FOREIGN KEY (`community_id`)
    REFERENCES `community` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_community_has_profile_profile1`
    FOREIGN KEY (`user_id`)
    REFERENCES `profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `post` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT(10) UNSIGNED NOT NULL,
  `community_id` INT(10) UNSIGNED NULL DEFAULT NULL,
  `post_id` INT(10) UNSIGNED NULL DEFAULT NULL,
  `text` TEXT NULL DEFAULT NULL,
  `media_id` INT(10) UNSIGNED NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`id`),
  INDEX `user_idx` (`user_id` ASC),
  INDEX `community_idx` (`community_id` ASC),
  INDEX `post_idx` (`post_id` ASC),
  INDEX `media_idx` (`media_id` ASC),
  CONSTRAINT `fk_post_profile1`
    FOREIGN KEY (`user_id`)
    REFERENCES `profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_community1`
    FOREIGN KEY (`community_id`)
    REFERENCES `community` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_media1`
    FOREIGN KEY (`media_id`)
    REFERENCES `media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `media_type` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `media` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `media_type_id` INT(10) UNSIGNED NOT NULL,
  `user_id` INT(10) UNSIGNED NOT NULL,
  `url` VARCHAR(45) NULL DEFAULT NULL,
  `blob` BLOB NULL DEFAULT NULL,
  `metadata` JSON NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`id`),
  INDEX `media_type_idx` (`media_type_id` ASC),
  INDEX `user_idx` (`user_id` ASC),
  CONSTRAINT `fk_media_media_type1`
    FOREIGN KEY (`media_type_id`)
    REFERENCES `media_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_profile1`
    FOREIGN KEY (`user_id`)
    REFERENCES `profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;